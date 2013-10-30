//
//  CDQuickDialogController.m
//  waduanzi3
//
//  Created by chendong on 13-9-18.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDQuickDialogController.h"

@interface CDQuickDialogController ()

@end

@implementation CDQuickDialogController


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

@end
