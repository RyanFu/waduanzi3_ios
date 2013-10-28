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
    
    CDNavigationController *textNavController = [[CDNavigationController alloc] initWithRootViewController:textViewController];
    textNavController.tabBarItem.title = @"文字";
    CDNavigationController *imageNavController = [[CDNavigationController alloc] initWithRootViewController:imageViewController];
    imageNavController.tabBarItem.title = @"图片";
    CDNavigationController *videoNavController = [[CDNavigationController alloc] initWithRootViewController:videoViewController];
    videoNavController.tabBarItem.title = @"视频";
    CDNavigationController *longImageNavController = [[CDNavigationController alloc] initWithRootViewController:longImageViewController];
    longImageNavController.tabBarItem.title = @"长图";
    
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
