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
#import "CDUIKit.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "WxApiService.h"
#import "SDWebImageManager.h"
#import "MobClick.h"
#import "Appirater.h"
#import "CDDataCache.h"
#import "BPush.h"
#import "CDNavigationController.h"
#import "CDSocialKit.h"
#import "CDUserConfig.h"
#import "MBProgressHUD+Custom.h"
#import "Reachability.h"


@interface AppDelegate ()
{
    IIViewDeckController *_deckController;
}

- (void) asyncInit;
- (void) customAppearance;
- (void) setupWindowView:(UIApplication *)application;
- (void) afterWindowVisible:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void) setupRKRestClient;
- (void) checkNetworkChange;
- (void)preInitWithSize:(CGFloat)size family:(NSString *)family;
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
    [self setupRKRestClient];
    [self setupWindowView:application];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self afterWindowVisible:application didFinishLaunchingWithOptions:launchOptions];
    
    
    return YES;
}

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"source application: %@", sourceApplication);
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    CDLog(@"device token: %@", [[NSString alloc] initWithData:deviceToken encoding:NSUTF8StringEncoding]);
    [BPush registerDeviceToken:deviceToken];
    [BPush bindChannel];
}

- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    CDLog(@"userInfo: %@", userInfo);
    [BPush handleNotification:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    CDLog(@"applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    CDLog(@"applicationDidEnterBackground");
    
    @try {
        [[RKObjectManager sharedManager].operationQueue cancelAllOperations];
        
        [CDDataCache clearCacheFilesBeforeDays:7];

    }
    @catch (NSException *exception) {
        ;
    }
    @finally {
        ;
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    CDLog(@"applicationWillEnterForeground");
    
    [Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    CDLog(@"applicationDidBecomeActive");
    
    application.applicationIconBadgeNumber = 0;
    [UMSocialSnsService applicationDidBecomeActive];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    
    CDLog(@"applicationWillTerminate");
    
    [self saveContext];
    
    [CDDataCache clearCacheFilesBeforeDays:7];
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


#pragma mark - interfaceOrientations
- (NSUInteger) application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}


#pragma mark - private methods

- (void) customAppearance
{
    [[UIApplication sharedApplication] setStatusBarStyle: (IS_IOS7 ? UIStatusBarStyleLightContent : UIStatusBarStyleBlackOpaque)];
    
    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    
    [CDUIKit setNavigationBar:[UINavigationBar appearance] style:CDNavigationBarStyleBlue forBarMetrics:UIBarMetricsDefault];
    [CDUIKit setBarButtonItem:[UIBarButtonItem appearance] style:CDBarButtonItemStyleBlue forBarMetrics:UIBarMetricsDefault];
    [CDUIKit setBackBarButtonItemStyle:CDBarButtonItemStyleBlue forBarMetrics:UIBarMetricsDefault];
    
    if (OS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
        NSDictionary *titleTextAttributes = @{
                                          NSForegroundColorAttributeName: [UIColor whiteColor],
                                          NSFontAttributeName: [UIFont fontWithName:FZLTHK_FONT_NAME size:16.0f]
                                          };
        [[UINavigationBar appearance] setTitleTextAttributes:titleTextAttributes];
    }
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    // UIToolBar
    [[UIBarButtonItem appearanceWhenContainedIn:[UIToolbar class], nil] setTintColor:[UIColor whiteColor]];
}

- (void) setupWindowView:(UIApplication *)application
{
    SideMenuViewController *menuController = [[SideMenuViewController alloc] initWithStyle:UITableViewStylePlain];
    CDNavigationController *sideController = [[CDNavigationController alloc] initWithRootViewController:menuController];
    
    TimelineViewController *timelineController = [[TimelineViewController alloc] init];
    self.centerController = [[CDNavigationController alloc] initWithRootViewController:timelineController];
    _deckController = [[IIViewDeckController alloc] initWithCenterViewController:_centerController leftViewController:sideController];
    
    _deckController.leftSize = DECK_LEFT_SIZE;
    _deckController.sizeMode = IIViewDeckLedgeSizeMode;
    _deckController.navigationControllerBehavior = IIViewDeckNavigationControllerContained;
    _deckController.panningMode = IIViewDeckFullViewPanning;
    _deckController.centerhiddenInteractivity = IIViewDeckCenterHiddenNotUserInteractiveWithTapToClose;
    _deckController.openSlideAnimationDuration = 0.2f;
    _deckController.closeSlideAnimationDuration = 0.25f;
    _deckController.delegateMode = IIViewDeckDelegateAndSubControllers;

    self.window.rootViewController = _deckController;
}


- (void) afterWindowVisible:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self asyncInit];
    [self checkNetworkChange];
    
    application.applicationIconBadgeNumber = 0;
    
    // umeng tongji
    [MobClick startWithAppkey:UMENG_APPKEY];
    [MobClick updateOnlineConfig];
    // ios7会自动更新，所以不需要再使用此方式提醒用户更新
    if (OS_VERSION_LESS_THAN(@"7.0")) {
        [MobClick checkUpdate];
    }
    [CDSocialKit setSocialConfig];
    
    [[SDWebImageManager sharedManager].imageDownloader setValue:[CDRestClient userAgent] forHTTPHeaderField:@"User-Agent"];
    [[SDWebImageManager sharedManager].imageDownloader setValue:HTTP_IMAGE_REQUEST_REFERR forHTTPHeaderField:@"Referer"];
    
    // set appirater
    [Appirater setAppId:WADUANZI_APPLE_ID];
    [Appirater setDaysUntilPrompt:3]; // 安装几天后弹出
    [Appirater setUsesUntilPrompt:2]; // 到达最小安装时间后，用户有效操作事件多少次后弹出
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:5]; // 用户点了“稍后提醒我”之后再过多少天再次提醒
    [Appirater setDebug:CD_DEBUG];
    [Appirater appLaunched:YES];
    
    // set Baidu Push
    [BPush setupChannel:launchOptions];
    [BPush setDelegate:self];
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    

}



- (void) asyncInit
{
    // 记录第一次启动时间
    if ([[CDDataCache shareCache] fetchAppFirstBootTime] == 0)
        [[CDDataCache shareCache] cacheAppFirstBootTime];

    // 预加载字体
    dispatch_queue_t queue = dispatch_queue_create("com.waduanzi.iphone", NULL);
    dispatch_async(queue, ^(void) {
        [self preInitWithSize:CDPostContentFontSizeNormal family:FZLTHK_FONT_FAMILY];
        [self preInitWithSize:CDPostContentFontSizeBig family:FZLTHK_FONT_FAMILY];
    });

}


- (void) setupRKRestClient
{
    if (CD_DEBUG) {
//        RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelDebug);
//        RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);
    }
    else
        RKLogConfigureByName("RestKit/*", RKLogLevelOff);
    

    CDRestClient *restClient = [[CDRestClient alloc] init];
    [restClient run];
    
    [self performSelector:@selector(updateDeviceInfo) withObject:nil afterDelay:1.0f];
}

- (void) checkNetworkChange
{
    [[RKObjectManager sharedManager].HTTPClient setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            NSLog(@"network status: not reachable");
        }
        else if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
            NSLog(@"network status: reachable via WWAN");
        }
        else if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
            NSLog(@"network status: reachable via WIFI");
        }
        else if (status == AFNetworkReachabilityStatusUnknown) {
            NSLog(@"network status:  unknown");
        }
        else
            NSLog(@"network status: other status");
        
        // 如果状态改变，刷新当前段子列表
        @try {
            if ((status == AFNetworkReachabilityStatusReachableViaWiFi || status == AFNetworkReachabilityStatusReachableViaWWAN) && [CDUserConfig shareInstance].auto_change_image_size) {
                UINavigationController *currentNavViewController = (UINavigationController *)_deckController.centerController;
                UIViewController *currentViewController = [currentNavViewController.viewControllers lastObject];
                NSLog(@"view Controller: %@", [currentViewController class]);
                
                if ([currentViewController isKindOfClass:[PostListViewController class]]) {
                    PostListViewController *postListViewController = (PostListViewController *)currentViewController;
                    postListViewController.networkStatus = status;
                    [postListViewController.tableView reloadData];
                    NSLog(@"tableView reloadData because network status has change.");
                }
            }
        }
        @catch (NSException *exception) {
            CDLog(@"reload post list table view exception: %@", exception);
        }
        @finally {
            ;
        }
        
    }];
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

#pragma mark - BPushDelegate
- (void) onMethod:(NSString *)method response:(NSDictionary *)data
{
    if ([BPushRequestMethod_Bind isEqualToString:method]) {
        NSDictionary* res = [[NSDictionary alloc] initWithDictionary:data];
        
//        NSString *appid = [res valueForKey:BPushRequestAppIdKey];
//        NSString *userid = [res valueForKey:BPushRequestUserIdKey];
//        NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
//        NSString *requestid = [res valueForKey:BPushRequestRequestIdKey];
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        
        CDLog(@"error code: %d", returnCode);
    }
}


#pragma  DTCoreText preload

- (void)preInitWithSize:(CGFloat)size family:(NSString *)family
{
    NSLog(@"Start");
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:family forKey:(id)kCTFontFamilyNameAttribute];
    [attributes setObject:[NSNumber numberWithFloat:size] forKey:(id)kCTFontSizeAttribute];
    CTFontDescriptorRef fontDesc = CTFontDescriptorCreateWithAttributes((CFDictionaryRef)attributes);
    CTFontRef matchingFont = CTFontCreateWithFontDescriptor(fontDesc, size, NULL);
    CFRelease(matchingFont);
    CFRelease(fontDesc);
    NSLog(@"Finish");
}

@end






