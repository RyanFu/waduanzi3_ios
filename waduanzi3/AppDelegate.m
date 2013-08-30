//
//  AppDelegate.m
//  waduanzi3
//
//  Created by chendong on 12-12-14.
//  Copyright (c) 2012年 chendong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CDDefine.h"
#import "AppDelegate.h"
#import "IIViewDeckController.h"
#import "SideMenuViewController.h"
#import "TimelineViewController.h"
#import "CDRestClient.h"
#import "WCAlertView.h"
#import "CDUIKit.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "WxApiService.h"
#import "SDWebImageManager.h"
#import "MobClick.h"
#import "Appirater.h"
#import "CDDataCache.h"

#import "TestViewController.h"
#import "WebTestViewController.h"
#import "MGBoxViewController.h"
#import "DTCoreTextViewController.h"


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

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.description hasPrefix:@"sina"]) {
        return (BOOL)[[UMSocialSnsService sharedInstance] performSelector:@selector(handleSinaSsoOpenURL:) withObject:url];
    }
    else if([url.description hasPrefix:@"wx"]){
        return [WXApi handleOpenURL:url delegate:(id<WXApiDelegate>)[WxApiService shareInstance]];
    }
    else if ([url.scheme isEqualToString:@"waduanzi"]) {
        NSLog(@"waduanzi scheme");
        return YES;
    }
    else
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
    
    [Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [UMSocialSnsService applicationDidBecomeActive];
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
    
    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    [CDUIKit setNavigationBar:[UINavigationBar appearance] style:CDNavigationBarStyleBlue forBarMetrics:UIBarMetricsDefault];
    [CDUIKit setBarButtionItem:[UIBarButtonItem appearance] style:CDBarButtionItemStyleBlue forBarMetrics:UIBarMetricsDefault];
    [CDUIKit setBackBarButtionItemStyle:CDBarButtionItemStyleBlue forBarMetrics:UIBarMetricsDefault];
    
    // UIToolBar
//    [[UIBarButtonItem appearanceWhenContainedIn:[UIToolbar class], nil] setTintColor:[UIColor colorWithRed:0.43f green:0.50f blue:0.65f alpha:1.0f]];
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
    deckController.delegateMode = IIViewDeckDelegateAndSubControllers;

    self.window.rootViewController = deckController;
    
    [self afterWindowVisible];
}

- (void) setupTestRootController
{
    DTCoreTextViewController *coreTextController = [[DTCoreTextViewController alloc] init];
    self.window.rootViewController = coreTextController;
    return;
    
//    MGBoxViewController *mgboxController = [[MGBoxViewController alloc] init];
//    self.window.rootViewController = mgboxController;
//    
//    return;
    
//    WebTestViewController *webTestController = [[WebTestViewController alloc] init];
//    self.window.rootViewController = webTestController;
//    return;
//    
//    TestViewController *testController = [[TestViewController alloc] initWithStyle:UITableViewStylePlain];
//    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:testController];
//    self.window.rootViewController = navController;
}

- (void) afterWindowVisible
{
    // 记录第一次启动时间
    if ([[CDDataCache shareCache] fetchAppFirstBootTime] == 0)
        [[CDDataCache shareCache] cacheAppFirstBootTime];
    
    [DTTextAttachment registerClass:[DTObjectTextAttachment class] forTagName:@"waduanzi"];

    [UMSocialData openLog: CD_DEBUG];
    [MobClick startWithAppkey:UMENG_APPKEY];
    [MobClick updateOnlineConfig];
    [UMSocialData setAppKey:UMENG_APPKEY];
    [WXApi registerApp:WEIXIN_APPID];
    [MobClick checkUpdate];
    
    [UMSocialConfig setSnsPlatformNames:@[UMShareToQzone, UMShareToSina, UMShareToTencent, UMShareToDouban, UMShareToWechatSession, UMShareToWechatTimeline, UMShareToSms, UMShareToEmail]];
    [UMSocialConfig setFollowWeiboUids:@{UMShareToSina:OFFICIAL_SINA_WEIBO_USID}];
    
    [[SDWebImageManager sharedManager].imageDownloader setValue:[CDRestClient userAgent] forHTTPHeaderField:@"User-Agent"];
    
    // set WCAlertView Default style
    [WCAlertView setDefaultCustomiaztonBlock:^(WCAlertView *alertView) {
        alertView.style = WCAlertViewStyleWhite;
        alertView.labelTextColor = [UIColor grayColor];
        alertView.buttonTextColor = [UIColor grayColor];
    }];
    
    // set appirater
    [Appirater setAppId:WADUANZI_APPLE_ID];
    [Appirater setDaysUntilPrompt:5]; // 安装几天后弹出
    [Appirater setUsesUntilPrompt:5]; // 到达最小安装时间后，用户有效操作事件多少次后弹出
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:5]; // 用户点了“稍后提醒我”之后再过多少天再次提醒
    [Appirater setDebug:CD_DEBUG];
    [Appirater appLaunched:YES];
}

- (void) setupRKObjectMapping
{
    if (CD_DEBUG) {
//        RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
        RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    }
    else
        RKLogConfigureByName("RestKit/*", RKLogLevelOff);
    

    CDRestClient *restClient = [[CDRestClient alloc] init];
    [restClient run];
    
    [self performSelector:@selector(updateDeviceInfo) withObject:nil afterDelay:1.0f];
}


// update device info
- (void) updateDeviceInfo
{
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSString *countryCode = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
    
    NSDictionary *infos = [NSDictionary dictionaryWithObjectsAndKeys:CDDEVICE.model, @"model",
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






