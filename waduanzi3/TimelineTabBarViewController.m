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

@interface TimelineTabBarViewController ()

@end

@implementation TimelineTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    TimelineViewController *textViewController = [[TimelineViewController alloc] initWithMediaType:MEDIA_TYPE_TEXT];
    TimelineViewController *imageViewController = [[TimelineViewController alloc] initWithMediaType:MEDIA_TYPE_IMAGE];
    imageViewController.imageHeightFilter = CDImageHeightFilterOnlyShort;
    TimelineViewController *longImageViewController = [[TimelineViewController alloc] initWithMediaType:MEDIA_TYPE_IMAGE];
    longImageViewController.imageHeightFilter = CDImageHeightFilterOnlyLong;
    TimelineViewController *videoViewController = [[TimelineViewController alloc] initWithMediaType:MEDIA_TYPE_VIDEO];

    textViewController.title = imageViewController.title = videoViewController.title =  longImageViewController.title = @"每日更新";
    
    CDNavigationController *textNavController = [[CDNavigationController alloc] initWithRootViewController:textViewController];
    textNavController.tabBarItem.title = @"文字";
    CDNavigationController *imageNavController = [[CDNavigationController alloc] initWithRootViewController:imageViewController];
    imageNavController.tabBarItem.title = @"图片";
    CDNavigationController *videoNavController = [[CDNavigationController alloc] initWithRootViewController:videoViewController];
    videoNavController.tabBarItem.title = @"视频";
    CDNavigationController *longImageNavController = [[CDNavigationController alloc] initWithRootViewController:longImageViewController];
    longImageNavController.tabBarItem.title = @"长图";
    
    NSArray *viewControllers = @[textNavController, imageNavController, longImageNavController, videoNavController];
    self.viewControllers = viewControllers;
    self.customizableViewControllers = viewControllers;
    self.selectedIndex = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
