//
//  CDWebViewController.m
//  waduanzi3
//
//  Created by chendong on 13-7-20.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDWebViewController.h"

@interface CDWebViewController ()

@end

@implementation CDWebViewController

@synthesize toolbarStyle = _toolbarStyle;

- (id) initWithToolbarStyle:(CDToolBarStyle)style
{
    self = [super init];
    if (self) {
        _toolbarStyle = style;
    }
    return self;
}

- (id)initWithHTML:(NSString *)html toolbarStyle:(CDToolBarStyle)style
{
    self = [super initWithHTML:html];
    if (self) {
        _toolbarStyle = style;
    }
    return self;
}

- (id)initWithUrl:(NSString *)url toolbarStyle:(CDToolBarStyle)style
{
    self = [super initWithUrl:url];
    if (self) {
        _toolbarStyle = style;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [CDUIKit setNavigationBar:self.navigationController.navigationBar style:CDNavigationBarStyleBlack forBarMetrics:UIBarMetricsDefault];
    [CDUIKit setBackBarButtionItemStyle:CDBarButtionItemStyleBlack forBarMetrics:UIBarMetricsDefault];
    
    [CDUIKit setToolBar:self.navigationController.toolbar style:_toolbarStyle forToolbarPosition:UIToolbarPositionBottom forBarMetrics:UIBarMetricsDefault];
}


@end
