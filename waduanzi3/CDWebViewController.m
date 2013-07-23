//
//  CDWebViewController.m
//  waduanzi3
//
//  Created by chendong on 13-7-20.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDWebViewController.h"
#import "CDUIKit.h"

@interface CDWebViewController ()

@end

@implementation CDWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [CDUIKit setNavigationBar:self.navigationController.navigationBar style:CDNavigationBarStyleSearch forBarMetrics:UIBarMetricsDefault];
    [CDUIKit setBackBarButtionItemStyle:CDBarButtionItemStyleSearch forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.toolbar setBackgroundImage:[UIImage imageNamed:@"FBWebViewToolbarBackground.png"]
                                       forToolbarPosition:UIToolbarPositionBottom
                                               barMetrics:UIBarMetricsDefault];
}


@end
