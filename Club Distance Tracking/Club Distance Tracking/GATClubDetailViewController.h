//
//  GATClubDetailViewController.h
//  Club Distance Tracking
//
//  Created by Jesse Gatt on 4/13/14.
//  Copyright (c) 2014 Jesse Gatt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface GATClubDetailViewController : UIViewController <CLLocationManagerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSArray *globalsArray;
@property (strong, nonatomic) NSNumber *chosenIndex;
@property (weak, nonatomic) IBOutlet UILabel *club;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *attemptedDistance;
@property (weak, nonatomic) IBOutlet UIButton *start;
@property (weak, nonatomic) IBOutlet UIButton *end;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *varyingPoint;
@property (strong, nonatomic) CLLocation *startPoint;
@property (strong, nonatomic) CLLocation *endPoint;
@property (assign, nonatomic) CLLocationDistance distanceFromStart;

- (IBAction)startClicked:(id)sender;
- (IBAction)endClicked:(id)sender;

@end
