//
//  GATClubDetailViewController.h
//  Club Distance Tracking
//
//  Created by Jesse Gatt on 4/13/14.
//  Copyright (c) 2014 Jesse Gatt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface GATClubDetailViewController : UIViewController <CLLocationManagerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSManagedObject *coreDataObject;
@property (strong, nonatomic) NSString *clubName;
@property (weak, nonatomic) IBOutlet UILabel *club;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *attemptedDistance;
@property (weak, nonatomic) IBOutlet UIButton *start;
@property (weak, nonatomic) IBOutlet UIButton *end;
@property (weak, nonatomic) IBOutlet GMSMapView *MapView;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *varyingPoint;
@property (strong, nonatomic) CLLocation *startPoint;
@property (strong, nonatomic) CLLocation *endPoint;
@property (assign, nonatomic) CLLocationDistance distanceFromStart;

//google maps stuff
@property CLLocationCoordinate2D startCoord2D;
@property CLLocationCoordinate2D endCoord2D;
@property GMSMarker *startMarker;
@property GMSMarker *endMarker;

- (IBAction)startClicked:(id)sender;
- (IBAction)endClicked:(id)sender;

@end
