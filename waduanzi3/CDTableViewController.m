//
//  CDTableViewController.m
//  waduanzi3
//
//  Created by chendong on 13-9-18.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDTableViewController.h"

@interface CDTableViewController ()

@end

@implementation CDTableViewController

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
