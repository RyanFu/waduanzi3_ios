//
//  CDViewController.m
//  waduanzi3
//
//  Created by chendong on 13-7-15.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDViewController.h"

@interface CDViewController ()

@end

@implementation CDViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    
    // 右滑回到段子列表
    UISwipeGestureRecognizer *swipGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwips:)];
    swipGestureRecognizer.delegate = self;
    swipGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    swipGestureRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:swipGestureRecognizer];
    swipGestureRecognizer.view.tag = POP_NAVIGATION_CONTROLLER_GESTURE_RECOGNIZER_VIEW_TAG;
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        CDLog(@"ios 7");
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

// 定义视图滑动手势动作，右滑返回段子列表，其它手势无动作
- (void) handleSwips:(UISwipeGestureRecognizer *)recognizer
{
    NSLog(@"direction: %d", recognizer.direction);
    if (recognizer.view.tag == POP_NAVIGATION_CONTROLLER_GESTURE_RECOGNIZER_VIEW_TAG && [self.navigationController isKindOfClass:[UINavigationController class]]
        && self.navigationController.viewControllers.count > 1 && recognizer.direction & UISwipeGestureRecognizerDirectionRight) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// for iOS 6
- (BOOL) shouldAutorotate
{
    return NO;
}

- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

// for iOS 5
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}


// for iOS 7
- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
