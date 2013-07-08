//
//  AppDelegate.h
//  waduanzi3
//
//  Created by chendong on 12-12-14.
//  Copyright (c) 2012年 chendong. All rights reserved.
//

#define CDDEVICE        [UIDevice currentDevice]
#define CDSCREEN        [UIScreen mainScreen]
#define CDSCREEN_SIZE   CDSCREEN.bounds.size
#define CDAPPLICATION   [UIApplication sharedApplication]
#define ROOT_CONTROLLER [[[UIApplication sharedApplication] keyWindow] rootViewController]
#define APP_VERSION     [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey]

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (retain, nonatomic) UINavigationController *centerController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
