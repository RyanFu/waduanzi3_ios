//
//  CDWebViewController.m
//  waduanzi3
//
//  Created by chendong on 13-7-20.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDWebViewController.h"

@interface CDWebViewController ()
{
    CDNavigationBarStyle _navigationBarStyle;
    CDBarButtionItemStyle _barButtonItemStyle;
    CDToolBarStyle _toolBarStyle;
}
@end

@implementation CDWebViewController

- (void) setNavigationBarStyle:(CDNavigationBarStyle)navigationBarStyle barButtonItemStyle:(CDBarButtionItemStyle)barButtonItemStyle toolBarStyle:(CDToolBarStyle)toolBarStyle
{
    _navigationBarStyle = navigationBarStyle;
    _barButtonItemStyle = barButtonItemStyle;
    _toolBarStyle = toolBarStyle;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%d", self.navigationController.viewControllers.count);
    if (self.navigationController && self.navigationController.viewControllers.count == 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭"
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:self
                                                                                 action:@selector(dismissViewController)];
    }
    
    [CDUIKit setNavigationBar:self.navigationController.navigationBar style:_navigationBarStyle forBarMetrics:UIBarMetricsDefault];
    [CDUIKit setBackBarButtionItemStyle:_barButtonItemStyle forBarMetrics:UIBarMetricsDefault];
    [CDUIKit setBarButtionItem:self.navigationItem.leftBarButtonItem style:_barButtonItemStyle forBarMetrics:UIBarMetricsDefault];
    [CDUIKit setToolBar:self.navigationController.toolbar style:_toolBarStyle forToolbarPosition:UIToolbarPositionBottom forBarMetrics:UIBarMetricsDefault];
}

- (void) dismissViewController
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"CDWebViewController closed.");
    }];
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
    return UIInterfaceOrientationLandscapeRight;
}


// for iOS 5
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}


@end
