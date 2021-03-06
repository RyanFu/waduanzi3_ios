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
#import "CDSession.h"

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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(retrunPrevController)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(sendUserFeedback:)];
    
    [CDUIKit setBarButtonItem:self.navigationItem.leftBarButtonItem style:CDBarButtonItemStyleBlackBack forBarMetrics:UIBarMetricsDefault];
    [CDUIKit setBarButtonItem:self.navigationItem.rightBarButtonItem style:CDBarButtonItemStyleBlack forBarMetrics:UIBarMetricsDefault];
    
    [CDUIKit setBarButtonItemTitleAttributes:self.navigationItem.leftBarButtonItem forBarMetrics:UIBarMetricsDefault];
    [CDUIKit setBarButtonItemTitleAttributes:self.navigationItem.rightBarButtonItem forBarMetrics:UIBarMetricsDefault];}

- (void) sendUserFeedback:(id)sender
{
    if (![self.textView hasText]) return;
    
    NSNumber *user_id = [NSNumber numberWithInteger:0];
    if ([[CDSession shareInstance] hasLogined]) {
        CDUser *user = [[CDSession shareInstance] currentUser];
        user_id = user.user_id;
    }
    
    @try {
        RKObjectManager *objectManager = [RKObjectManager sharedManager];
        NSDictionary *parameters = @{@"user_id": user_id, @"content": self.textView.text,
                                     @"device_model": CDDEVICE.model,
                                     @"network_status": [NSNumber numberWithInt:CURRENT_NETWORK_STATUS]};
        
        [objectManager.HTTPClient postPath:@"/feedback/create" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            CDLog(@"result: %@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            CDLog(@"error: %@", error);
        }];
    }
    @catch (NSException *exception) {
        CDLog(@"exception: %@", exception);
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


- (void) retrunPrevController
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

// for iOS 5
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

@end
