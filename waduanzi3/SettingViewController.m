//
//  SettingViewController.m
//  waduanzi3
//
//  Created by chendong on 13-6-19.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <RestKit/RestKit.h>
#import "CDDefine.h"
#import "SettingViewController.h"
#import "CDDataCache.h"
#import "CDSession.h"
#import "CDQuickElements.h"
#import "UserProfileViewController.h"
#import "CDUIKit.h"
#import "CDWebViewController.h"
#import "UserConfig.h"
#import "FeedbackViewController.h"
#import "Appirater.h"
#import "CDKit.h"
#import "QPickerElement.h"
#import "QPickerTableViewCell.h"
#import "CDUserConfig.h"
#import "MBProgressHUD+Custom.h"

@interface SettingViewController ()
- (void) setupNavbar;
@end

@implementation SettingViewController

- (id) init
{
    self = [super init];
    if (self) {
        QRootElement *root = [CDQuickElements createSettingElements];
        self.root = root;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.quickDialogTableView.deselectRowWhenViewAppears = YES;
    
    [self setupNavbar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.quickDialogTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feed_table_bg.png"]];
    self.quickDialogTableView.backgroundColor = [UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
    
    QBadgeElement *userProfileElement = (QBadgeElement *)[self.root elementWithKey:@"key_user_profile"];
    userProfileElement.hidden = ![[CDSession shareInstance] hasLogined];
    
    QBooleanElement *pushMessageElement = (QBooleanElement*)[self.root elementWithKey:@"key_message_push"];
    pushMessageElement.boolValue = [CDUserConfig shareInstance].enable_push_message;
    NSLog(@"pushed: %d", pushMessageElement.boolValue);
    
    
    QBooleanElement *wwanShowImageSizeElement = (QBooleanElement*)[self.root elementWithKey:@"key_wwan_switch_big_image"];
    wwanShowImageSizeElement.boolValue = [CDUserConfig shareInstance].wwan_big_image;
    QBooleanElement *autoChangeImageSizeElement = (QBooleanElement*)[self.root elementWithKey:@"key_wifi_switch_big_image"];
    autoChangeImageSizeElement.boolValue = [CDUserConfig shareInstance].wifi_big_image;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[CDUserConfig shareInstance] cache];
}

- (void) setupNavbar
{
    [CDUIKit setNavigationBar:self.navigationController.navigationBar style:CDNavigationBarStyleBlack forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭"
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(closeController)];
    
    [CDUIKit setBarButtonItem:self.navigationItem.leftBarButtonItem style:CDBarButtonItemStyleBlackBack forBarMetrics:UIBarMetricsDefault];
    [CDUIKit setBarButtonItem:self.navigationItem.rightBarButtonItem style:CDBarButtonItemStyleBlack forBarMetrics:UIBarMetricsDefault];
    
    [CDUIKit setBarButtonItemTitleAttributes:self.navigationItem.leftBarButtonItem forBarMetrics:UIBarMetricsDefault];
    [CDUIKit setBarButtonItemTitleAttributes:self.navigationItem.rightBarButtonItem forBarMetrics:UIBarMetricsDefault];
}


#pragma mark - selector

- (void) closeController
{
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}

#pragma mark - SKStoreProductViewControllerDelegate

- (void) productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - QuickDialog Element Actions

- (void) clearCacheAction:(QLabelElement *)element
{
    BOOL result = [CDDataCache clearAllCacheFiles];
    if (result) {
        [MBProgressHUD showSuccessMessage:@"清除缓存成功！" inView:self.navigationController.view alpha:0.7f autoHide:YES showAnimated:YES hideAnimated:YES afterDelay:1.0f];
        [self.quickDialogTableView reloadCellForElements:element, nil];
    }
    NSLog(@"clear cache files result: %d", result);
}

- (void) feedbackAction:(QLabelElement *)element
{
    NSLog(@"feedback");
    FeedbackViewController *feedbackController = [[FeedbackViewController alloc] initWithTitle:@"意见反馈"];
    [self.navigationController pushViewController:feedbackController animated:YES];
}

- (void) starredAction:(QLabelElement *)element
{
    [CDKit openAppStoreByAppID:WADUANZI_APPLE_ID review:YES target:self delegate:self];
}

- (void) userProfileAction:(QLabelElement *)element
{
    static UserProfileViewController *profileController;
    if (profileController == nil)
        profileController = [[UserProfileViewController alloc] init];

    [self.navigationController pushViewController:profileController animated:YES];
    NSLog(@"user profile");
}

- (void) aboutmeAction:(QLabelElement *)element
{
    CDWebViewController *webController = [[CDWebViewController alloc] initWithUrl:@"http://m.waduanzi.com/about"];
    [webController setNavigationBarStyle:CDNavigationBarStyleBlack barButtonItemStyle:CDBarButtonItemStyleBlackBack toolBarStyle:CDToolBarStyleBlack];
    [self.navigationController pushViewController:webController animated:YES];
    
    NSLog(@"aboutme");
}

- (void) messagePushAction:(QBooleanElement *)element
{
    NSLog(@"message pushed: %d", [element.numberValue integerValue]);
    [CDUserConfig shareInstance].enable_push_message = element.boolValue;
    
    NSNumber *user_id = [NSNumber numberWithInteger:0];
    if ([[CDSession shareInstance] hasLogined]) {
        CDUser *user = [[CDSession shareInstance] currentUser];
        user_id = user.user_id;
    }
    
    NSDictionary *parameters = @{
                             @"user_id": user_id,
                             @"state": [NSNumber numberWithBool:element.boolValue]
                             };
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager.HTTPClient postPath:@"/device/pushstate" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"user config update: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"user config update errror: %@", error);
    }];
}


- (void) wwanSwitchBigImageAction:(QBooleanElement *)element
{
    NSLog(@"wwan bool value: %d", element.boolValue);
    [CDUserConfig shareInstance].wwan_big_image = element.boolValue;
}

- (void) wifiSwitchBigImageAction:(QBooleanElement *)element
{
    NSLog(@"wifi bool value: %d", element.boolValue);
    [CDUserConfig shareInstance].wifi_big_image = element.boolValue;
}



@end
