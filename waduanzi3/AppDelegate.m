//
//  AppDelegate.m
//  waduanzi3
//
//  Created by chendong on 12-12-14.
//  Copyright (c) 2012年 chendong. All rights reserved.
//

#import "CDDefine.h"
#import "AppDelegate.h"
#import "IIViewDeckController.h"
#import "SideMenuViewController.h"
#import "TimelineViewController.h"
#import "CDRestClient.h"
#import "TestViewController.h"
#import "MGBoxViewController.h"


@interface AppDelegate ()
- (void) customAppearance;
- (void) setupWindowView;
- (void) afterWindowVisible;
- (void) setupRKObjectMapping;

- (void) setupTestRootController;
@end

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

@synthesize centerController = _centerController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self customAppearance];
    [self setupRKObjectMapping];
    [self setupWindowView];
    
//    [self setupTestRootController];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"waduanzi3" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"waduanzi3.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}




#pragma mark - private methods

- (void) customAppearance
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    [[UINavigationBar appearance] setTintColor:[UIColor clearColor]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackOpaque];
}

- (void) setupWindowView
{
    SideMenuViewController *menuController = [[SideMenuViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *sideController = [[UINavigationController alloc] initWithRootViewController:menuController];
    
    TimelineViewController *timelineController = [[TimelineViewController alloc] init];
    self.centerController = [[UINavigationController alloc] initWithRootViewController:timelineController];
    IIViewDeckController *deckController = [[IIViewDeckController alloc] initWithCenterViewController:_centerController leftViewController:sideController];
    
    deckController.leftSize = DECK_LEFT_SIZE;
    deckController.sizeMode = IIViewDeckLedgeSizeMode;
    deckController.navigationControllerBehavior = IIViewDeckNavigationControllerContained;
    deckController.panningMode = IIViewDeckNavigationBarOrOpenCenterPanning;
    deckController.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
    deckController.openSlideAnimationDuration = 0.2f;
    deckController.closeSlideAnimationDuration = 0.25f;
    
    self.window.rootViewController = deckController;
}

- (void) setupTestRootController
{
    MGBoxViewController *mgboxController = [[MGBoxViewController alloc] init];
    self.window.rootViewController = mgboxController;
    
    return;
    
    TestViewController *testController = [[TestViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:testController];
    
    self.window.rootViewController = navController;
}

- (void) afterWindowVisible
{
    
}

- (void) setupRKObjectMapping
{
//    RKLogConfigureByName("RestKit/*", RKLogLevelOff);
//    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
//    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);

    CDRestClient *restClient = [[CDRestClient alloc] init];
    [restClient run];
    
    [self performSelector:@selector(updateDeviceInfo) withObject:nil afterDelay:1.0f];
}

- (void) updateDeviceInfo
{
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *countryCode = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
    
    NSDictionary *infos = [NSDictionary dictionaryWithObjectsAndKeys:CDDEVICE.model, @"model",
                          CDDEVICE.systemName, @"sys_name",
                          CDDEVICE.name, @"device_name",
                          language , @"language",
                          countryCode, @"country", nil];
    
    NSDictionary *params = [CDRestClient requestParams:infos];
    RKObjectManager *manager = [RKObjectManager sharedManager];
    [manager.HTTPClient postPath:@"/device/update" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"deivce update success");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"deivce update error: %@", error.localizedRecoverySuggestion);
    }];
}

@end






