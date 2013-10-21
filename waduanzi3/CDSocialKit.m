//
//  CDSocialKit.m
//  waduanzi3
//
//  Created by chendong on 13-7-27.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDSocialKit.h"
#import "CDUIKit.h"
#import "MBProgressHUD+Custom.h"

@implementation CDSocialKit


+ (CDSocialKit *)shareInstance
{
    static CDSocialKit *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CDSocialKit alloc] init];
    });
    return instance;
}

+ (NSArray *) enabledPlatforms
{
    return @[UMShareToQzone, UMShareToQQ, UMShareToSina, UMShareToTencent, UMShareToWechatSession, UMShareToWechatTimeline, UMShareToDouban, UMShareToEmail, UMShareToSms, UMShareToCopy, UMShareToFacebook, UMShareToTwitter];
}

+ (void) setSocialConfig
{
    [UMSocialData openLog: CD_DEBUG];
    [UMSocialData setAppKey:UMENG_APPKEY];
    
    [CDSocialKit addUMShareToCopyPlatform];
    
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAllButUpsideDown];
    
    [UMSocialConfig setNavigationBarConfig:^(UINavigationBar *bar, UIButton *closeButton, UIButton *backButton, UIButton *postButton, UIButton *refreshButton, UINavigationItem *navigationItem) {
        [CDUIKit setNavigationBar:bar style:CDNavigationBarStyleBlue forBarMetrics:UIBarMetricsDefault];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = navigationItem.title;
        [titleLabel sizeToFit];
        titleLabel.backgroundColor  = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont fontWithName:FZLTHK_FONT_NAME size:16.0f];
        [navigationItem setTitleView: titleLabel];
    }];
    
    [UMSocialConfig setSnsPlatformNames: [CDSocialKit enabledPlatforms]];
    [UMSocialConfig setSupportSinaSSO:CD_DEBUG];
    [UMSocialConfig setFollowWeiboUids:@{UMShareToSina:OFFICIAL_SINA_WEIBO_USID}];
    [UMSocialConfig setWXAppId:WEIXIN_APPID url:nil];
    [UMSocialConfig setSupportQzoneSSO:YES importClasses:@[[QQApiInterface class],[TencentOAuth class]]];
    [UMSocialConfig setQQAppId:QQ_CONNECT_APPID url:nil importClasses:@[[QQApiInterface class],[TencentOAuth class]]];
}


+ (void) unOauthAllPlatforms
{
    NSArray *platforms = [CDSocialKit enabledPlatforms];
    for (NSString *platform in platforms) {
        if ([UMSocialAccountManager isOauthWithPlatform:platform])
            [[UMSocialDataService defaultDataService] requestUnOauthWithType:platform completion:nil];
    }
}




+ (void) addUMShareToCopyPlatform
{
    UMSocialSnsPlatform *copyPlatform = [[UMSocialSnsPlatform alloc] initWithPlatformName:UMShareToCopy];
    copyPlatform.displayName = @"复制";
    copyPlatform.shareToType = UMSocialSnsTypeCopy;
    copyPlatform.bigImageName = @"copy_icon";
    copyPlatform.snsClickHandler = ^(UIViewController *presentingController, UMSocialControllerService * socialControllerService, BOOL isPresentInController) {
        @try {
            if ([socialControllerService.socialUIDelegate respondsToSelector:@selector(didSelectSocialPlatform:withSocialData:)]) {
                [socialControllerService.socialUIDelegate performSelector:@selector(didSelectSocialPlatform:withSocialData:)
                                                               withObject:UMShareToCopy
                                                               withObject:socialControllerService.socialData];
            }
            CDLog(@"copy text: %@, current controller: %@", socialControllerService.socialData.shareText, socialControllerService.currentViewController);
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:socialControllerService.socialData.shareText];
            
            [MBProgressHUD show:YES successMessage:@"复制成功" inView:socialControllerService.currentViewController.view alpha:0.9f hide:YES afterDelay:0.5f];
        }
        @catch (NSException *exception) {
            CDLog(@"copy exception: %@", exception.reason);
            [MBProgressHUD show:YES errorMessage:@"复制出错" inView:socialControllerService.currentViewController.view alpha:0.9f hide:YES afterDelay:0.5f];
        }
        @finally {
            ;
        }
        
    };
    
    [UMSocialConfig addSocialSnsPlatform:@[copyPlatform]];
}


@end
