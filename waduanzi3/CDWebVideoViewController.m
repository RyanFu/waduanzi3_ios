//
//  CDWebViewController.m
//  waduanzi3
//
//  Created by chendong on 13-7-20.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDWebVideoViewController.h"

@interface CDWebVideoViewController ()
{
    CDNavigationBarStyle _navigationBarStyle;
    CDBarButtionItemStyle _barButtonItemStyle;
    CDToolBarStyle _toolBarStyle;
}
@end

@implementation CDWebVideoViewController

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
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [super webViewDidFinishLoad:webView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清爽模式" style:UIBarButtonItemStyleBordered target:nil action:nil];
}

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}


@end
