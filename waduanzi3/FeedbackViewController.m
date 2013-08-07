//
//  FeedbackViewController.m
//  waduanzi3
//
//  Created by chendong on 13-8-5.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "FeedbackViewController.h"
#import "CDUIKit.h"
#import "CDAppUser.h"

@interface FeedbackViewController ()
{
    MBProgressHUD *_hub;
}
- (void) setupNavbar;
@end

@implementation FeedbackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setupNavbar];
    
    _hub = [[MBProgressHUD alloc] initWithView:self.view];
    _hub.yOffset = -100.0f;
    _hub.delegate = self;
    [self.view addSubview:_hub];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setup subviews

- (void) setupNavbar
{
    [CDUIKit setNavigationBar:self.navigationController.navigationBar style:CDNavigationBarStyleBlack forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(sendUserFeedback:)];
    
    [CDUIKit setBackBarButtionItemStyle:CDBarButtionItemStyleBlack forBarMetrics:UIBarMetricsDefault];
    [CDUIKit setBarButtionItem:self.navigationItem.rightBarButtonItem style:CDBarButtionItemStyleBlack forBarMetrics:UIBarMetricsDefault];
}

- (void) sendUserFeedback:(id)sender
{
    if (![self.textView hasText]) return;
    
    NSNumber *user_id = [NSNumber numberWithInteger:0];
    if ([CDAppUser hasLogined]) {
        CDUser *user = [CDAppUser currentUser];
        user_id = user.user_id;
    }
    
    @try {
        NSDictionary *parameters = @{@"user_id": user_id, @"content": self.textView.text};
        RKObjectManager *objectManager = [RKObjectManager sharedManager];
        [objectManager.HTTPClient postPath:@"/feedback/create" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"result: %@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@", error);
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"exception: %@", exception);
    }
    @finally {
        _hub.labelText = @"感谢您的反馈！";
        _hub.mode = MBProgressHUDModeText;
        [_hub show:YES];
        [_hub hide:YES afterDelay:1.0f];
    }
    
}

- (void) hudWasHidden:(MBProgressHUD *)hud
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
