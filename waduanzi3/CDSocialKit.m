//
//  CDSocialKit.m
//  waduanzi3
//
//  Created by chendong on 13-7-27.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDSocialKit.h"

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

- (NSArray *) enabledPlatforms
{
    return @[UMShareToQzone, UMShareToSina, UMShareToTencent, UMShareToDouban, UMShareToWechatSession, UMShareToWechatTimeline, UMShareToSms, UMShareToEmail];
}

- (void) socialConfig
{
    [UMSocialConfig setSnsPlatformNames: [self enabledPlatforms]];
    [UMSocialConfig setFollowWeiboUids:@{UMShareToSina:OFFICIAL_SINA_WEIBO_USID}];
}

- (void) unOauthAllPlatforms
{
    NSArray *platforms = [self enabledPlatforms];
    for (NSString *platform in platforms) {
        if ([UMSocialAccountManager isOauthWithPlatform:platform])
            [[UMSocialDataService defaultDataService] requestUnOauthWithType:platform completion:nil];
    }
}
@end
