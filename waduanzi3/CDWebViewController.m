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
    CDBarButtonItemStyle _barButtonItemStyle;
    CDToolBarStyle _toolBarStyle;
}
@end

@implementation CDWebViewController

- (void) setNavigationBarStyle:(CDNavigationBarStyle)navigationBarStyle barButtonItemStyle:(CDBarButtonItemStyle)barButtonItemStyle toolBarStyle:(CDToolBarStyle)toolBarStyle
{
    _navigationBarStyle = navigationBarStyle;
    _barButtonItemStyle = barButtonItemStyle;
    _toolBarStyle = toolBarStyle;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%d", self.navigationController.viewControllers.count);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(dismissViewController)];
    
    if (self.navigationController && self.navigationController.viewControllers.count > 1) {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(returnPrevController)];
    }
    
    [CDUIKit setNavigationBar:self.navigationController.navigationBar style:_navigationBarStyle forBarMetrics:UIBarMetricsDefault];
    [CDUIKit setBarButtonItem:self.navigationItem.leftBarButtonItem style:_barButtonItemStyle forBarMetrics:UIBarMetricsDefault];
    [CDUIKit setBarButtonItem:self.navigationItem.rightBarButtonItem style:_barButtonItemStyle forBarMetrics:UIBarMetricsDefault];
    
    [CDUIKit setBarButtonItemTitleAttributes:self.navigationItem.leftBarButtonItem forBarMetrics:UIBarMetricsDefault];
    [CDUIKit setBarButtonItemTitleAttributes:self.navigationItem.rightBarButtonItem forBarMetrics:UIBarMetricsDefault];
    [CDUIKit setToolBar:self.navigationController.toolbar style:_toolBarStyle forToolbarPosition:UIToolbarPositionBottom forBarMetrics:UIBarMetricsDefault];
}

- (void) dismissViewController
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        NSLog(@"CDWebViewController closed.");
    }];
}

- (void) returnPrevController
{
    if (self.navigationController.viewControllers.count > 1)
        [self.navigationController popViewControllerAnimated:YES];
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



- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        [CDUIKit setBarButtonItem:self.navigationItem.leftBarButtonItem style:_barButtonItemStyle forBarMetrics:UIBarMetricsLandscapePhone];
        [CDUIKit setBarButtonItem:self.navigationItem.rightBarButtonItem style:_barButtonItemStyle forBarMetrics:UIBarMetricsLandscapePhone];
        [CDUIKit setBarButtonItem:self.navigationItem.leftBarButtonItem style:_barButtonItemStyle forBarMetrics:UIBarMetricsLandscapePhone];
        [CDUIKit setBarButtonItem:self.navigationItem.rightBarButtonItem style:_barButtonItemStyle forBarMetrics:UIBarMetricsLandscapePhone];
    }
    else {
        [CDUIKit setBarButtonItem:self.navigationItem.leftBarButtonItem style:_barButtonItemStyle forBarMetrics:UIBarMetricsDefault];
        [CDUIKit setBarButtonItem:self.navigationItem.rightBarButtonItem style:_barButtonItemStyle forBarMetrics:UIBarMetricsDefault];
        [CDUIKit setBarButtonItem:self.navigationItem.leftBarButtonItem style:_barButtonItemStyle forBarMetrics:UIBarMetricsDefault];
        [CDUIKit setBarButtonItem:self.navigationItem.rightBarButtonItem style:_barButtonItemStyle forBarMetrics:UIBarMetricsDefault];
    }
}


@end
