//
//  AppDelegate.m
//  YumYum2
//
//  Created by Maurice Mickens on 2/21/15.
//  Copyright (c) 2015 Loud Skies. All rights reserved.
//

#import "AppDelegate.h"
//#import <FacebookSDK/FacebookSDK.h>
#import <CoreData/CoreData.h>
#import "RecipeDetailViewController.h"
#import "CreateRecipeViewController.h"
#import "YumYum2Macros.h"
#import "WebViewController.h"
//#import "SCErrorHandler.h"
//#import "SCSettings.h"

NSString * const ManagedObjectContextSaveDidFailNotification =
@"ManagedObjectContextSaveDidFailNotification";

@interface AppDelegate ()<UIAlertViewDelegate>


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self customizeAppearance];
    
    // Intialize location manager
    
    /*self.customLocationManager = [[CLLocationManager alloc] init];
    self.customLocationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    self.customLocationManager.delegate = self;
    [self.customLocationManager startUpdatingLocation];*/
    
    // Create an instance of a UINavigationController
    // its stack contains only itemsViewController
    //UINavigationController *navController = [[UINavigationController alloc]
                                             //initWithRootViewController:detailViewController];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fatalCoreDataError:)
                                                 name:ManagedObjectContextSaveDidFailNotification
                                               object:nil];
    return YES;
}

- (void)customizeAppearance
{
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName : [UIColor redColor],
                                                           }];
    [[UITabBar appearance] setTintColor: [UIColor redColor]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // Logs 'install' and 'app activate' App Events.
    /*[FBAppEvents activateApp];
    
    // Facebook SDK * login flow *
    // We need to properly handle activation of the application with regards to SSO
    //  (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    [FBAppCall handleDidBecomeActive];*/
}

/*- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // Facebook SDK * login flow *
    // Attempt to handle URLs to complete any auth (e.g., SSO) flow.
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication fallbackHandler:^(FBAppCall *call) {
        // Since Scrumptious supports Single Sign On from the Facebook App (such as bookmarks),
        // we supply a fallback handler to parse any inbound URLs (e.g., deep links)
        // which can contain an access token.
        if (call.accessTokenData) {
            if ([FBSession activeSession].isOpen) {
                //NSLog(@"INFO: Ignoring new access token because current session is open.");
            }
            else {
                [self _handleOpenURLWithAccessToken:call.accessTokenData];
            }
        }
    }];
}*/

/*- (void)_handleOpenURLWithAccessToken:(FBAccessTokenData *)token {
    // Initialize a new blank session instance...
    FBSession *sessionFromToken = [[FBSession alloc] initWithAppID:nil
                                                       permissions:nil
                                                   defaultAudience:FBSessionDefaultAudienceNone
                                                   urlSchemeSuffix:nil
                                                tokenCacheStrategy:[FBSessionTokenCachingStrategy nullCacheInstance] ];
    [FBSession setActiveSession:sessionFromToken];
    // ... and open it from the supplied token.
    [sessionFromToken openFromAccessTokenData:token
                            completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                // Forward any errors to the FBLoginView delegate.
                                if (error) {
                                    SCHandleError(error);
                                }
                            }];
}*/


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    //[self saveContext];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    abort();
}

- (void)fatalCoreDataError:(NSNotification *)notification
{
    UIAlertView *alertView = [[UIAlertView alloc]
                initWithTitle:NSLocalizedString(@"Internal Error", nil)
                message:NSLocalizedString(@"There was a fatal error in the app and it cannot continue.\n\nPress OK to terminate the app. Sorry for the inconvenience.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil)
                        otherButtonTitles:nil];
                        [alertView show];
}
                                                        
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel == nil) {
        NSString *modelPath = [[NSBundle mainBundle]
                               pathForResource:@"YumYum2" ofType:@"momd"];
        NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
        _managedObjectModel = [[NSManagedObjectModel alloc]
                               initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}
- (NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    //NSLog(@"%@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory  inDomains:NSUserDomainMask] lastObject]);
    
    NSString *documentsDirectory = [paths lastObject];
    return documentsDirectory;
}

- (NSString *)dataStorePath
{
    return [[self documentsDirectory]
            stringByAppendingPathComponent:@"DataStore.sqlite"];
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator == nil) {
        NSURL *storeURL = [NSURL fileURLWithPath:
                           [self dataStorePath]];
        _persistentStoreCoordinator =
        [[NSPersistentStoreCoordinator alloc]
         initWithManagedObjectModel:self.managedObjectModel];
        NSError *error;
        if (![_persistentStoreCoordinator
              addPersistentStoreWithType:NSSQLiteStoreType
              configuration:nil URL:storeURL options:nil
              error:&error]) {
            NSLog(@"Error adding persistent store %@, %@", error,
                  [error userInfo]);
            abort();
        }
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext == nil) {
        NSPersistentStoreCoordinator *coordinator =
        self.persistentStoreCoordinator;
        if (coordinator != nil) {
            _managedObjectContext =
            [[NSManagedObjectContext alloc] init];
            [_managedObjectContext
             setPersistentStoreCoordinator:coordinator];
        }
    }
    return _managedObjectContext;
}

/*#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.loudskies.YumYum2" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"YumYum2" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"YumYum2.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
*/
/*# pragma mark - Updates user's current location

-(void)updateCurrentLocation {
    [self.customLocationManager startUpdatingLocation];
}

-(void)stopUpdatingCurrentLocation {
    [self.customLocationManager stopUpdatingHeading];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.currentUserLocation = newLocation;
    
    [self.customLocationManager stopUpdatingLocation];
    self.currentUserLocation = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude
                                                          longitude:newLocation.coordinate.longitude];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    //NSLog(@"didFailWithError %@", error);
}
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    //NSLog(@"didUpdateLocations %@", newLocation);
}*/

@end
