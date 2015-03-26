//
//  AppDelegate.h
//  YumYum2
//
//  Created by Maurice Mickens on 2/21/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocationManager *customLocationManager;
@property (strong, nonatomic) CLLocation *currentUserLocation;

@property (nonatomic, strong) NSManagedObjectContext
*managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel
*managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator
*persistentStoreCoordinator;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)updateCurrentLocation;
- (void)stopUpdatingCurrentLocation;


@end

