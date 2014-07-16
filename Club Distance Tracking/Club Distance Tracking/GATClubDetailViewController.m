//
//  GATClubDetailViewController.m
//  Club Distance Tracking
//
//  Created by Jesse Gatt on 4/13/14.
//  Copyright (c) 2014 Jesse Gatt. All rights reserved.
//

#import "GATClubDetailViewController.h"
#import "GATAppDelegate.h"

static NSString * const kClubEntityName = @"Club";
static NSString * const kClubNameKey = @"name";
static NSString * const kClubCountKey = @"count";
static NSString * const kClubTotalKey = @"total";



@interface GATClubDetailViewController ()


@property (weak, nonatomic) GMSMapView *mapView;

@end

@implementation GATClubDetailViewController
{
    GMSMapView *mapView_;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    GATAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:kClubEntityName];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(%K = %@)", kClubNameKey, _clubName];
    [request setPredicate:pred];
    
    
    NSError *error;
    NSArray *coreDataObjects = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (_coreDataObject == nil) {
        NSLog(@"returned empty array");
    }
    
    _coreDataObject= coreDataObjects[0];
    
    
    _club.text = [_coreDataObject valueForKey:kClubNameKey];
    NSNumber *total = [_coreDataObject valueForKey:kClubTotalKey];
    NSNumber *count = [_coreDataObject valueForKey:kClubCountKey];
    
    double average;
    if ([count doubleValue] == 0) {
        average = 0;
    }else{
       average = [total doubleValue] / [count doubleValue]; 
    }
    
    
    //formatting string to show only two decimal places
    NSNumberFormatter *doubleValueWithMaxTwoDecimalPlaces = [[NSNumberFormatter alloc] init];
    [doubleValueWithMaxTwoDecimalPlaces setNumberStyle:NSNumberFormatterDecimalStyle];
    [doubleValueWithMaxTwoDecimalPlaces setMaximumFractionDigits:2];
    
    _distance.text = [doubleValueWithMaxTwoDecimalPlaces stringFromNumber:[NSNumber numberWithDouble:average]];
    [_start setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [_end setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];

    
    self.locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
    
    _start.enabled = NO;
    _end.enabled = NO;
    
    
    //google maps stuff
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:37.33182
                                                            longitude:-122.03118
                                                                 zoom:10];
    mapView_ = [GMSMapView mapWithFrame:_MapView.bounds camera:camera];
    mapView_.myLocationEnabled = YES;
    mapView_.mapType = kGMSTypeSatellite;
    [_MapView addSubview:mapView_];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark -
#pragma mark CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {

    _varyingPoint = [locations lastObject];
    
    
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake( _varyingPoint.coordinate.latitude, _varyingPoint.coordinate.longitude);
    
    
    
    
    
    if (_startPoint == nil) {
        _start.enabled = YES;
        _startCoord2D = position;
        _endCoord2D = position;
        
        GMSCoordinateBounds *bounds =
        [[GMSCoordinateBounds alloc] initWithCoordinate:_startCoord2D coordinate:_endCoord2D];
        
        [mapView_ moveCamera:[GMSCameraUpdate fitBounds:bounds]];
        
        _startMarker.map = nil;
        
        _startMarker = [GMSMarker markerWithPosition:position];
        _startMarker.title = @"Start";
        _startMarker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
        _startMarker.map = mapView_;
    }else if(_startPoint != nil && _endPoint == nil){
        _end.enabled = YES;
        _endCoord2D = position;
        
        GMSCoordinateBounds *bounds =
        [[GMSCoordinateBounds alloc] initWithCoordinate:_startCoord2D coordinate:_endCoord2D];
        
        [mapView_ moveCamera:[GMSCameraUpdate fitBounds:bounds]];
        
        _endMarker.map = nil;
        
        _endMarker = [GMSMarker markerWithPosition:position];
        _endMarker.title = @"End";
        _endMarker.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
        _endMarker.map = mapView_;
    }
   
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSString *errorType = (error.code == kCLErrorDenied) ?
    @"Access Denied" : @"Unknown Error";
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Error getting Location"
                          message:errorType
                          delegate:nil
                          cancelButtonTitle:@"Okay"
                          otherButtonTitles:nil];
    [alert show];
}



- (IBAction)startClicked:(id)sender {
    _startPoint = _varyingPoint;
    _start.enabled = NO;
    
}

- (IBAction)endClicked:(id)sender {
    _endPoint = _varyingPoint;
    _end.enabled = NO;
    _distanceFromStart = [_endPoint distanceFromLocation:_startPoint];
    _attemptedDistance.text = [NSString stringWithFormat:@"%gyd", _distanceFromStart * 1.0936];
    NSString *titleString = [NSString stringWithFormat:@"%@ Was Hit %@ Yards", [_coreDataObject valueForKey:kClubNameKey] , _attemptedDistance.text];
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:titleString
                          message:@"Would You Like To Add This Distance to Average"
                          delegate:self
                          cancelButtonTitle:@"Yes"
                          otherButtonTitles:@"No",nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSNumber *currentTotal = [_coreDataObject valueForKey:kClubTotalKey];
        
        NSNumber *newTotal =  [NSNumber numberWithDouble:[currentTotal doubleValue] +  (_distanceFromStart * 1.0936)];
        [_coreDataObject setValue:newTotal forKey:kClubTotalKey];
        
        NSNumber *currentCount = [_coreDataObject valueForKey:kClubCountKey];
        NSNumber *newCount = [NSNumber numberWithInt:[currentCount intValue] + 1];
        [_coreDataObject setValue:newCount forKey:kClubCountKey];
        
        NSNumber *total = [_coreDataObject valueForKey:kClubTotalKey];
        NSNumber *count = [_coreDataObject valueForKey:kClubCountKey];
        double average;
        if ([count doubleValue] == 0) {
            average = 0;
        }else{
            average = [total doubleValue] / [count doubleValue];
        }
        
        
        //formatting string to show only two decimal places
        NSNumberFormatter *doubleValueWithMaxTwoDecimalPlaces = [[NSNumberFormatter alloc] init];
        [doubleValueWithMaxTwoDecimalPlaces setNumberStyle:NSNumberFormatterDecimalStyle];
        [doubleValueWithMaxTwoDecimalPlaces setMaximumFractionDigits:2];
        
        _distance.text = [doubleValueWithMaxTwoDecimalPlaces stringFromNumber:[NSNumber numberWithDouble:average]];
        
        
        //save new data to disk
        GATAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate saveContext];
    }
    
}



@end
