//
//  HistoryTabBarViewController.m
//  waduanzi3
//
//  Created by chendong on 13-10-26.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDNavigationController.h"
#import "HistoryTabBarViewController.h"
#import "HistoryViewController.h"
#import "UMTableViewController.h"
#import "MobClick.h"
#import "CDConfig.h"

@interface HistoryTabBarViewController ()

@end

@implementation HistoryTabBarViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.delegate = self;
    
    HistoryViewController *imageViewController = [[HistoryViewController alloc] initWithMediaType:MEDIA_TYPE_IMAGE];
    imageViewController.imageHeightFilter = CDImageHeightFilterOnlyShort;
    HistoryViewController *textViewController = [[HistoryViewController alloc] initWithMediaType:MEDIA_TYPE_TEXT];
    HistoryViewController *longImageViewController = [[HistoryViewController alloc] initWithMediaType:MEDIA_TYPE_IMAGE];
    longImageViewController.imageHeightFilter = CDImageHeightFilterOnlyLong;
    HistoryViewController *videoViewController = [[HistoryViewController alloc] initWithMediaType:MEDIA_TYPE_VIDEO];
    textViewController.title = imageViewController.title = videoViewController.title =  longImageViewController.title = @"随机穿越";
    
    CDNavigationController *imageNavController = [[CDNavigationController alloc] initWithRootViewController:imageViewController];
    imageNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle: @"图片" image:[UIImage imageNamed:@"ios7_tabbar_feedicon_normal"] tag:0];
    CDNavigationController *textNavController = [[CDNavigationController alloc] initWithRootViewController:textViewController];
    textNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle: @"文字" image:[UIImage imageNamed:@"ios7_tabbar_moreicon_normal"] tag:1];
    CDNavigationController *longImageNavController = [[CDNavigationController alloc] initWithRootViewController:longImageViewController];
    longImageNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle: @"长图" image:[UIImage imageNamed:@"ios7_tabbar_notificationsicon_normal"] tag:2];
    CDNavigationController *videoNavController = [[CDNavigationController alloc] initWithRootViewController:videoViewController];
    videoNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle: @"视频" image:[UIImage imageNamed:@"ios7_tabbar_contactsicon_normal"] tag:3];
    
    NSMutableArray *navViewControllers = [NSMutableArray array];
    [navViewControllers addObjectsFromArray:@[imageNavController, textNavController, longImageNavController, videoNavController]];
    
    if ([CDConfig showAppRecommendTab]) {
        UMTableViewController *umAppViewController = [[UMTableViewController alloc] init];
        CDNavigationController *umAppNavController = [[CDNavigationController alloc] initWithRootViewController:umAppViewController];
        umAppNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle: @"推荐" image:[UIImage imageNamed:@"ios7_tabbar_me_normal"] tag:3];
        [navViewControllers addObject:umAppNavController];
    }
    
    self.viewControllers = navViewControllers;
    self.selectedIndex = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
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

@end
