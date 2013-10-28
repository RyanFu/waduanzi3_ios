//
//  BestTabBarViewController.m
//  waduanzi3
//
//  Created by chendong on 13-10-26.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDNavigationController.h"
#import "BestTabBarViewController.h"
#import "BestViewController.h"

@interface BestTabBarViewController ()

@end

@implementation BestTabBarViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    BestViewController *imageViewController = [[BestViewController alloc] initWithMediaType:MEDIA_TYPE_IMAGE];
    imageViewController.imageHeightFilter = CDImageHeightFilterOnlyShort;
    BestViewController *textViewController = [[BestViewController alloc] initWithMediaType:MEDIA_TYPE_TEXT];
    BestViewController *longImageViewController = [[BestViewController alloc] initWithMediaType:MEDIA_TYPE_IMAGE];
    longImageViewController.imageHeightFilter = CDImageHeightFilterOnlyLong;
    BestViewController *videoViewController = [[BestViewController alloc] initWithMediaType:MEDIA_TYPE_VIDEO];
    textViewController.title = imageViewController.title = videoViewController.title =  longImageViewController.title = @"精华推荐";
    
    CDNavigationController *imageNavController = [[CDNavigationController alloc] initWithRootViewController:imageViewController];
    imageNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle: @"图片" image:[UIImage imageNamed:@"ios7_tabbar_feedicon_normal"] tag:0];
    CDNavigationController *textNavController = [[CDNavigationController alloc] initWithRootViewController:textViewController];
    textNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle: @"文字" image:[UIImage imageNamed:@"ios7_tabbar_moreicon_normal"] tag:1];
    CDNavigationController *longImageNavController = [[CDNavigationController alloc] initWithRootViewController:longImageViewController];
    longImageNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle: @"长图" image:[UIImage imageNamed:@"ios7_tabbar_notificationsicon_normal"] tag:2];
    CDNavigationController *videoNavController = [[CDNavigationController alloc] initWithRootViewController:videoViewController];
    videoNavController.tabBarItem = [[UITabBarItem alloc] initWithTitle: @"视频" image:[UIImage imageNamed:@"ios7_tabbar_contactsicon_normal"] tag:3];
    
    NSArray *viewControllers = @[imageNavController, textNavController, longImageNavController, videoNavController];
    self.viewControllers = viewControllers;
    self.selectedIndex = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
