//
//  GATAppDelegate.h
//  Club Distance Tracking
//
//  Created by Jesse Gatt on 4/5/14.
//  Copyright (c) 2014 Jesse Gatt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GATAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//core data stuff
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
