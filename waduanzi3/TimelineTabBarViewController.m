//
//  TimelineTabBarViewController.m
//  waduanzi3
//
//  Created by chendong on 13-10-26.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDNavigationController.h"
#import "TimelineTabBarViewController.h"
#import "TimelineViewController.h"
#import "CDPost.h"
#import "CDRestClient.h"
#import "UMTableViewController.h"
#import "MobClick.h"

@interface TimelineTabBarViewController ()
{
    NSUInteger _prevSelectedIndex;
    NSTimer *_updateCountTimer;
    CDNavigationController *textNavController, *imageNavController, *videoNavController, *longImageNavController;
    TimelineViewController *imageViewController, *textViewController, *longImageViewController, *videoViewController;
}

- (void) setupTabBarControllers;
- (void) fetchUpdateCount:(TimelineViewController *)viewController completion:(void (^)(NSInteger count))completion;
- (NSDictionary *) updateCountRequestParameters:(TimelineViewController *)viewController;

@end

@implementation TimelineTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.delegate = self;
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(fetchAllViewControllersUpdateCount)
                                                name:UIApplicationDidBecomeActiveNotification
                                              object:nil];
    
    @try {
        [self setupTabBarControllers];
        
    }
    @catch (NSException *exception) {
        CDLog(@"setupTabBarControllers exception: %@", exception);
    }
    @finally {
        ;
    }
    
}

- (void) viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self performSelector:@selector(fetchAllViewControllersUpdateCount) withObject:nil afterDelay:3.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupTabBarControllers
{
    imageViewController = [[TimelineViewController alloc] initWithMediaType:MEDIA_TYPE_IMAGE];
    imageViewController.imageHeightFilter = CDImageHeightFilterOnlyShort;
    
    textViewController = [[TimelineViewController alloc] initWithMediaType:MEDIA_TYPE_TEXT];
    longImageViewController = [[TimelineViewController alloc] initWithMediaType:MEDIA_TYPE_IMAGE];
    
    longImageViewController.imageHeightFilter = CDImageHeightFilterOnlyLong;
    videoViewController = [[TimelineViewController alloc] initWithMediaType:MEDIA_TYPE_VIDEO];
    
    textViewController.title = imageViewController.title = videoViewController.title =  longImageViewController.title = @"每日更新";
    
    imageNavController = [[CDNavigationController alloc] initWithRootViewController:imageViewController];
    imageNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle: @"图片" image:[UIImage imageNamed:@"ios7_tabbar_feedicon_normal"] tag:0];
    textNavController = [[CDNavigationController alloc] initWithRootViewController:textViewController];
    textNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle: @"文字" image:[UIImage imageNamed:@"ios7_tabbar_moreicon_normal"] tag:1];
    longImageNavController = [[CDNavigationController alloc] initWithRootViewController:longImageViewController];
    longImageNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle: @"长图" image:[UIImage imageNamed:@"ios7_tabbar_notificationsicon_normal"] tag:2];
    videoNavController = [[CDNavigationController alloc] initWithRootViewController:videoViewController];
    videoNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle: @"视频" image:[UIImage imageNamed:@"ios7_tabbar_contactsicon_normal"] tag:3];
    
    UMTableViewController *umAppViewController = [[UMTableViewController alloc] init];
    CDNavigationController *umAppNavController = [[CDNavigationController alloc] initWithRootViewController:umAppViewController];
    umAppNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle: @"推荐" image:[UIImage imageNamed:@"ios7_tabbar_me_normal"] tag:3];
    
    NSArray *navViewControllers = @[imageNavController, textNavController, longImageNavController, videoNavController, umAppNavController];
    self.viewControllers = navViewControllers;
    self.selectedIndex = _prevSelectedIndex = 0;
    
    NSArray *viewControllers = @[imageViewController, textViewController, longImageViewController, videoViewController];
    [viewControllers makeObjectsPerformSelector:@selector(view)];
}

#pragma mark - UITabBarControllerDelegate

- (void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    @try {
        UINavigationController *navViewController = (UINavigationController *)viewController;
        UIViewController *currentViewController = [navViewController.viewControllers lastObject];
        
        if ([currentViewController isKindOfClass:[FunnyListViewController class]]) {
            TimelineViewController *timelineViewController = [navViewController.viewControllers lastObject];
            
            if (viewController.tabBarItem.badgeValue != nil) {
                viewController.tabBarItem.badgeValue = nil;
                [timelineViewController refreshLatestPosts];
            }
            else if ((_prevSelectedIndex == self.selectedIndex) && (timelineViewController.tableView.contentOffset.y > 0)) {
                [timelineViewController.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
            }
        }
        else {
            CDLog(@"current view controller is not FunnyListViewController sub class");
        }
    }
    @catch (NSException *exception) {
        CDLog(@"tabBarController:didSelectViewController exception: %@", exception);
    }
    @finally {
        ;
    }
    
    _prevSelectedIndex = self.selectedIndex;
    
    @try {
        NSArray *umEvents = @[UM_EVENT_MENU_MEDIA_IMAGE
                              , UM_EVENT_MENU_MEDIA_TEXT
                              , UM_EVENT_MENU_MEDIA_LONG_IMAGE
                              , UM_EVENT_MENU_MEDIA_VIDEO
                              , UM_EVENT_MENU_APP_RECOMMEND
                              ];
        
        NSString *event = [umEvents objectAtIndex:self.selectedIndex];
        [MobClick event:event];
    }
    @catch (NSException *exception) {
        ;
    }
    @finally {
        ;
    }
}

#pragma mark - timer action

- (void) fetchAllViewControllersUpdateCount
{
    @try {
        [self fetchUpdateCount:imageViewController completion:^(NSInteger count) {
            if (count > 0) {
                NSString *badgeValue = (count > 9) ? @"N" : [NSString stringWithFormat:@"%d", count];
                imageNavController.tabBarItem.badgeValue = badgeValue;
            }
        }];
        
        [self fetchUpdateCount:textViewController completion:^(NSInteger count) {
            if (count > 0) {
                NSString *badgeValue = (count > 9) ? @"N" : [NSString stringWithFormat:@"%d", count];
                textNavController.tabBarItem.badgeValue = badgeValue;
            }
        }];
        
        [self fetchUpdateCount:longImageViewController completion:^(NSInteger count) {
            if (count > 0) {
                NSString *badgeValue = (count > 9) ? @"N" : [NSString stringWithFormat:@"%d", count];
                longImageNavController.tabBarItem.badgeValue = badgeValue;
            }
        }];
        
        [self fetchUpdateCount:videoViewController completion:^(NSInteger count) {
            if (count > 0) {
                NSString *badgeValue = (count > 9) ? @"N" : [NSString stringWithFormat:@"%d", count];
                videoNavController.tabBarItem.badgeValue = badgeValue;
            }
        }];
    }
    @catch (NSException *exception) {
        CDLog(@"fetchUpdateCountTimerAction exception: %@", exception);
    }
    @finally {
        ;
    }
    
}


#pragma mark - private methods

- (void) fetchUpdateCount:(TimelineViewController *)viewController completion:(void (^)(NSInteger))completion
{
    NSDictionary *parameters = [self updateCountRequestParameters:viewController];
    if (parameters == nil) return;
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager.HTTPClient getPath:@"/post/timelineCount" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        @try {
            
            CDLog(@"responseObject: %@", responseObject);
            NSInteger count = 0;
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseDict = (NSDictionary *)responseObject;
                count = [[responseDict objectForKey:@"count"] integerValue];
            }
            completion(count);
        }
        @catch (NSException *exception) {
            CDLog(@"fetchUpdateCount exception: %@", exception);
        }
        @finally {
            ;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        CDLog(@"error: %@", error );
    }];
}

- (NSDictionary *) updateCountRequestParameters:(TimelineViewController *)viewController
{
    if (viewController.statuses.count == 0) return nil;
    
    CDPost *firstPost = [viewController.statuses objectAtIndex:0];
    NSInteger lasttime = [firstPost.create_time integerValue];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *channel_id = [NSString stringWithFormat:@"%d", viewController.channelID];
    [params setObject:channel_id forKey:@"channel_id"];
    NSString *last_time = [NSString stringWithFormat:@"%d", lasttime];
    [params setObject:last_time forKey:@"lasttime"];
    NSString *imageFilter = [NSString stringWithFormat:@"%d", viewController.imageHeightFilter];
    [params setObject:imageFilter forKey:@"image_filter"];
    
    NSString *mediaTypes = (viewController.mediaType == MEDIA_TYPE_MIXED) ? SUPPORT_MEDIA_TYPES : [NSString stringWithFormat:@"%d", viewController.mediaType];
    [params setObject:mediaTypes forKey:@"media_type"];
    
    return [CDRestClient requestParams:params];
}

@end
