//
//  UserProfileViewController.m
//  waduanzi3
//
//  Created by chendong on 13-6-19.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <RestKit/RestKit.h>
#import "UserProfileViewController.h"
#import "CDQuickElements.h"
#import "CDAppUser.h"
#import "CDUIKit.h"
#import "UMSocial.h"
#import "CDDataCache.h"
#import "UpdateProfileViewController.h"
#import "MBProgressHUD+Custom.h"

#define LOGOUT_BUTTON_TAG 99999

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
    
    self.quickDialogTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feed_table_bg.png"]];
    self.quickDialogTableView.backgroundColor = [UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
    
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

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CDUser *sessionUser = [CDAppUser currentUser];
    QLabelElement *nicknameElement = (QLabelElement *)[self.root elementWithKey:@"key_nickname"];
    nicknameElement.value = sessionUser.screen_name;
    [self.quickDialogTableView reloadCellForElements:nicknameElement, nil];
    
}

#pragma mark - setup subviews

- (void) setupNavbar
{
    [CDUIKit setNavigationBar:self.navigationController.navigationBar style:CDNavigationBarStyleBlack forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(dismissController)];
    
    [CDUIKit setBackBarButtionItemStyle:CDBarButtionItemStyleBlack forBarMetrics:UIBarMetricsDefault];
    [CDUIKit setBarButtionItem:self.navigationItem.rightBarButtonItem style:CDBarButtionItemStyleBlack forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - selector

- (void) dismissController
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
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

- (void) updateNickname:(QLabelElement *)element
{
    UpdateProfileViewController *updateProfileController = [[UpdateProfileViewController alloc] init];
    [self.navigationController pushViewController:updateProfileController animated:YES];
}


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
                    
                    [MBProgressHUD show:YES errorMessage:@"新浪微博授权出错，请重新授权一次" inView:self.view alpha:0.6f hide:YES afterDelay:1.5f];
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
                    
                    [MBProgressHUD show:YES errorMessage:@"QQ空间授权出错，请重新授权一次" inView:self.view alpha:0.6f hide:YES afterDelay:1.5f];
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
                    
                    [[MBProgressHUD showHUDAddedTo:self.view animated:YES] hide:YES afterDelay:1.0f];
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
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出登录" otherButtonTitles:nil, nil];
    sheet.tag = LOGOUT_BUTTON_TAG;
    [sheet showInView:self.view];
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
        else if (actionSheet.tag == LOGOUT_BUTTON_TAG) {
            [CDAppUser logoutWithCompletion:^{
                [[CDSocialKit shareInstance] unOauthAllPlatforms];
            }];
            [self performSelector:@selector(dismissController) withObject:nil afterDelay:0.3f];
        }
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
