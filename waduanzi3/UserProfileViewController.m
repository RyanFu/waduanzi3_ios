//
//  UserProfileViewController.m
//  waduanzi3
//
//  Created by chendong on 13-6-19.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UserProfileViewController.h"
#import "CDQuickElements.h"
#import "CDAppUser.h"
#import "CDUIKit.h"
#import "UMSocial.h"
#import "WCAlertView.h"

@interface UserProfileViewController ()
- (void) setupNavbar;
@end

@implementation UserProfileViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.root = [CDQuickElements createUserProfileElements];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.quickDialogTableView.styleProvider = self;
    self.quickDialogTableView.deselectRowWhenViewAppears = YES;

    [self setupNavbar];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.quickDialogTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundDark.png"]];
    self.quickDialogTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundLight.png"]];
    
    // update sns account state
    QBooleanElement *sinaElement = (QBooleanElement *)[self.root elementWithKey:@"key_share_sina_weibo"];
    sinaElement.boolValue = [UMSocialAccountManager isOauthWithPlatform:UMShareToSina];
    QBooleanElement *qzoneElement = (QBooleanElement *)[self.root elementWithKey:@"key_share_qzone"];
    qzoneElement.boolValue = [UMSocialAccountManager isOauthWithPlatform:UMShareToQzone];
    QBooleanElement *tencentElement = (QBooleanElement *)[self.root elementWithKey:@"key_share_tencent"];
    tencentElement.boolValue = [UMSocialAccountManager isOauthWithPlatform:UMShareToTencent];

    
    NSDictionary *snsAccountDic = [UMSocialAccountManager socialAccountDictionary];
    UMSocialAccountEntity *sinaAccount = [snsAccountDic valueForKey:UMShareToSina];
    if ([UMSocialAccountManager isOauthWithPlatform:UMShareToSina] && sinaAccount != nil)
        sinaElement.value = sinaAccount.userName;
    
    UMSocialAccountEntity *qzoneAccount = [snsAccountDic valueForKey:UMShareToQzone];
    if ([UMSocialAccountManager isOauthWithPlatform:UMShareToQzone] && qzoneAccount != nil)
        qzoneElement.value = qzoneAccount.userName;
    
    UMSocialAccountEntity *tencentAccount = [snsAccountDic valueForKey:UMShareToTencent];
    if ([UMSocialAccountManager isOauthWithPlatform:UMShareToTencent] && tencentAccount != nil)
        tencentElement.value = tencentAccount.userName;
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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(dismissController)];
    
    [CDUIKit setBarButtionItem:self.navigationItem.leftBarButtonItem style:CDBarButtionItemStyleBlack forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - selector

- (void) dismissController
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - QuickDialogStyleProvider
- (void) cell:(UITableViewCell *)cell willAppearForElement:(QElement *)element atIndexPath:(NSIndexPath *)indexPath
{
    if ([element.key isEqualToString:@"key_logout_button"]) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"common_button_red_nor.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 11.0f, 0, 11.0f)]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"common_button_red_press.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 11.0f, 0, 11.0f)]];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    }
}


#pragma mark quickdialog controllAction

- (void) sinaWeiboLoginAction:(QBooleanElement *)element
{
    NSLog(@"value: %d", element.boolValue);
    element.boolValue = !element.boolValue;
    [self.quickDialogTableView reloadCellForElements:element, nil];
    
    if (element.boolValue) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"新浪微博" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"解除绑定" otherButtonTitles:nil, nil];
        sheet.tag = UMSocialSnsTypeSina;
        [sheet showInView:self.view];
    }
    else {
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
        snsPlatform.loginClickHandler(self, [UMSocialControllerService defaultControllerService], YES, ^(UMSocialResponseEntity *response) {
            NSLog(@"response is %@",response);
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSDictionary *snsAccountDic = [UMSocialAccountManager socialAccountDictionary];
                UMSocialAccountEntity *sinaAccount = [snsAccountDic valueForKey:UMShareToSina];
                if (sinaAccount != nil) {
                    element.boolValue = YES;
                    element.value = sinaAccount.userName;
                    [[UMSocialDataService defaultDataService] requestAddFollow:UMShareToSina followedUsid:@[OFFICIAL_SINA_WEIBO_USID] completion:^(UMSocialResponseEntity *response) {
                        NSLog(@"follow: %@", response);
                    }];
                }
                else {
                    element.boolValue = NO;
                    [WCAlertView showAlertWithTitle:@"提示" message:@"新浪微博授权出错，请重新授权一次" customizationBlock:^(WCAlertView *alertView) {
                        ;
                    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                        ;
                    } cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                }
            }
            else
                element.boolValue = NO;
            
            [self.quickDialogTableView reloadCellForElements:element, nil];
        });
    }
}


- (void) qzoneLoginAction:(QBooleanElement *)element
{
    NSLog(@"value: %d", element.boolValue);
    element.boolValue = !element.boolValue;
    [self.quickDialogTableView reloadCellForElements:element, nil];
    
    if (element.boolValue) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"QQ空间" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"解除绑定" otherButtonTitles:nil, nil];
        sheet.tag = UMSocialSnsTypeQzone;
        [sheet showInView:self.view];
    }
    else {
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQzone];
        snsPlatform.loginClickHandler(self, [UMSocialControllerService defaultControllerService], YES, ^(UMSocialResponseEntity *response) {
            NSLog(@"response is %@",response);
            if (response.responseCode == UMSResponseCodeSuccess) {
                element.boolValue = YES;
                NSDictionary *snsAccountDic = [UMSocialAccountManager socialAccountDictionary];
                UMSocialAccountEntity *qzoneAccount = [snsAccountDic valueForKey:UMShareToQzone];
                if (qzoneAccount != nil) {
                    element.boolValue = YES;
                    element.value = qzoneAccount.userName;
                }
                else {
                    element.boolValue = NO;
                    [WCAlertView showAlertWithTitle:@"提示" message:@"QQ空间授权出错，请重新授权一次" customizationBlock:^(WCAlertView *alertView) {
                        ;
                    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                        ;
                    } cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                }
            }
            else
                element.boolValue = NO;
            
            [self.quickDialogTableView reloadCellForElements:element, nil];
        });
    }
}


- (void) tencentLoginAction:(QBooleanElement *)element
{
    NSLog(@"value: %d", element.boolValue);
    element.boolValue = !element.boolValue;
    [self.quickDialogTableView reloadCellForElements:element, nil];
    
    if (element.boolValue) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"腾讯微博" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"解除绑定" otherButtonTitles:nil, nil];
        sheet.tag = UMSocialSnsTypeTenc;
        [sheet showInView:self.view];
    }
    else {
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToTencent];
        snsPlatform.loginClickHandler(self, [UMSocialControllerService defaultControllerService], YES, ^(UMSocialResponseEntity *response) {
            NSLog(@"response is %@",response);
            if (response.responseCode == UMSResponseCodeSuccess) {
                element.boolValue = YES;
                NSDictionary *snsAccountDic = [UMSocialAccountManager socialAccountDictionary];
                UMSocialAccountEntity *tencentAccount = [snsAccountDic valueForKey:UMShareToTencent];
                if (tencentAccount != nil) {
                    element.boolValue = YES;
                    element.value = tencentAccount.userName;
                }
                else {
                    element.boolValue = NO;
                    [WCAlertView showAlertWithTitle:@"提示" message:@"腾讯微博授权出错，请重新授权一次" customizationBlock:^(WCAlertView *alertView) {
                        ;
                    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                        ;
                    } cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                }
            }
            else
                element.boolValue = NO;
            
            [self.quickDialogTableView reloadCellForElements:element, nil];
        });
    }
}


- (void) logoutAction:(QButtonElement *)element
{
    element.enabled = NO;
    __weak UserProfileViewController *weakSelf = self;
    [CDAppUser logoutWithCompletion:^(CDUser *user) {
        [weakSelf performSelector:@selector(dismissController)];
    }];
}


#pragma mark - UIActionSheetDelegate

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"index:%d", buttonIndex);
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        if (actionSheet.tag == UMSocialSnsTypeSina)
            [self performSelector:@selector(unOauthSina)];
        else if (actionSheet.tag == UMSocialSnsTypeQzone)
            [self performSelector:@selector(unOauthQzone)];
        else if (actionSheet.tag == UMSocialSnsTypeTenc)
            [self performSelector:@selector(unOauthTencent)];
            
    }
}

- (void) unOauthSina
{
    [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToSina completion:^(UMSocialResponseEntity *response) {
        NSLog(@"response is %@",response);
        QBooleanElement *element = (QBooleanElement *)[self.root elementWithKey:@"key_share_sina_weibo"];
        if (response.responseType == UMSResponseUnOauth && response.responseCode == UMSResponseCodeSuccess) {
            element.boolValue = NO;
            element.value = nil;
        }
        else
            element.boolValue = YES;
        
        [self.quickDialogTableView reloadCellForElements:element, nil];
    }];
}


- (void) unOauthQzone
{
    [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToQzone completion:^(UMSocialResponseEntity *response) {
        NSLog(@"response is %@",response);
        QBooleanElement *element = (QBooleanElement *)[self.root elementWithKey:@"key_share_qzone"];
        if (response.responseType == UMSResponseUnOauth && response.responseCode == UMSResponseCodeSuccess) {
            element.boolValue = NO;
            element.value = nil;
        }
        else
            element.boolValue = YES;
        
        [self.quickDialogTableView reloadCellForElements:element, nil];
    }];
}



- (void) unOauthTencent
{
    [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToTencent completion:^(UMSocialResponseEntity *response) {
        NSLog(@"response is %@",response);
        QBooleanElement *element = (QBooleanElement *)[self.root elementWithKey:@"key_share_tencent"];
        if (response.responseType == UMSResponseUnOauth && response.responseCode == UMSResponseCodeSuccess) {
            element.boolValue = NO;
            element.value = nil;
        }
        else
            element.boolValue = YES;
        
        [self.quickDialogTableView reloadCellForElements:element, nil];
    }];
}

@end
