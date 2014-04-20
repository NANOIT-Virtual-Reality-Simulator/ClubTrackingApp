//
//  GATGolfClubsTableViewController.h
//  Club Distance Tracking
//
//  Created by Jesse Gatt on 4/13/14.
//  Copyright (c) 2014 Jesse Gatt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GATGolfClubsTableViewController : UITableViewController <UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *globalsArray;

- (IBAction)addClub:(id)sender;
@end
