//
//  PublishViewController.m
//  waduanzi3
//
//  Created by chendong on 13-7-30.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "PublishViewController.h"
#import "CDQuickElements.h"
#import "CDUIKit.h"

@interface PublishViewController ()
- (void) setupNavbar;
@end

@implementation PublishViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.root = [CDQuickElements createPublishElements];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setupNavbar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - setup subviews

- (void) setupNavbar
{
    [CDUIKit setNavigationBar:self.navigationController.navigationBar style:CDNavigationBarStyleBlue forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(dismissController)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                             action:@selector(publishContent:)];
    
    [CDUIKit setBackBarButtionItemStyle:CDBarButtionItemStyleBlue forBarMetrics:UIBarMetricsDefault];
    [CDUIKit setBarButtionItem:self.navigationItem.leftBarButtonItem style:CDBarButtionItemStyleBlue forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - selector

- (void) dismissController
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
