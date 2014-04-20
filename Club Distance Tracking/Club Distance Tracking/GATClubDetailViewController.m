//
//  GATClubDetailViewController.m
//  Club Distance Tracking
//
//  Created by Jesse Gatt on 4/13/14.
//  Copyright (c) 2014 Jesse Gatt. All rights reserved.
//

#import "GATClubDetailViewController.h"


@interface GATClubDetailViewController ()

@end

@implementation GATClubDetailViewController

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
    _globalsArray = [[NSArray alloc] initWithContentsOfFile:[self dataFilePath]];
    _club.text = [_globalsArray[[_chosenIndex integerValue]] objectForKey:@"Club"];
    NSNumber *total = [_globalsArray[[_chosenIndex integerValue]] objectForKey:@"Total"];
    NSNumber *count = [_globalsArray[[_chosenIndex integerValue]] objectForKey:@"Count"];
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
//    _start.layer.borderWidth = 1.0f;
//    _start.layer.borderColor = [[UIColor greenColor] CGColor];
//    _start.layer.cornerRadius = 8;
//    _end.layer.borderWidth = 1.0f;
//    _end.layer.borderColor = [[UIColor redColor] CGColor];
//    _end.layer.cornerRadius = 8;
    
    self.locationManager = [[CLLocationManager alloc] init]; _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
    
    _start.enabled = NO;
    _end.enabled = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma mark -
#pragma mark CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {

    _varyingPoint = [locations lastObject];
    if (_startPoint == nil) {
        _start.enabled = YES;
    }else if(_startPoint != nil && _endPoint == nil){
        _end.enabled = YES;
    }
   
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
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
    NSString *titleString = [NSString stringWithFormat:@"%@ Was Hit %@ Yards", _club.text = [_globalsArray[[_chosenIndex integerValue]] objectForKey:@"Club"], _attemptedDistance.text];
    
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
        NSNumber *currentTotal = [_globalsArray[[_chosenIndex integerValue]] objectForKey:@"Total"];
        
        NSNumber *newTotal =  [NSNumber numberWithDouble:[currentTotal doubleValue] +  (_distanceFromStart * 1.0936)];
        [_globalsArray[[_chosenIndex integerValue]] setObject:newTotal forKey:@"Total"];
        
        NSNumber *currentCount = [_globalsArray[[_chosenIndex integerValue]] objectForKey:@"Count"];
        NSNumber *newCount = [NSNumber numberWithInt:[currentCount intValue] + 1];
        [_globalsArray[[_chosenIndex integerValue]] setObject:newCount forKey:@"Count"];
        
        NSNumber *total = [_globalsArray[[_chosenIndex integerValue]] objectForKey:@"Total"];
        NSNumber *count = [_globalsArray[[_chosenIndex integerValue]] objectForKey:@"Count"];
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
        NSString *filePath = [self dataFilePath];
        [_globalsArray writeToFile:filePath atomically:YES];
    }
    
}

//code to save plist file if application is put into background
- (void)applicationWillResignActive:(NSNotification *)notification
{
    NSString *filePath = [self dataFilePath];
    [_globalsArray writeToFile:filePath atomically:YES];
}


- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"Clubs.plist"];
}
@end
