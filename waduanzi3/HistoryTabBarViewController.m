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

@interface HistoryTabBarViewController ()

@end

@implementation HistoryTabBarViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
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
    
    UMTableViewController *umAppViewController = [[UMTableViewController alloc] init];
    CDNavigationController *umAppNavController = [[CDNavigationController alloc] initWithRootViewController:umAppViewController];
    umAppNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle: @"推荐" image:[UIImage imageNamed:@"ios7_tabbar_me_normal"] tag:3];
    
    NSArray *viewControllers = @[imageNavController, textNavController, longImageNavController, videoNavController, umAppNavController];

    self.viewControllers = viewControllers;
    self.selectedIndex = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
