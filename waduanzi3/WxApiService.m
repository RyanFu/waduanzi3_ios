//
//  WxApiViewController.m
//  waduanzi3
//
//  Created by chendong on 13-7-26.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "WxApiService.h"
#import "UserProfileViewController.h"
#import "WXApi.h"
#import "CDWebViewController.h"
#import "MBProgressHUD+Custom.h"

@interface WxApiService ()

@end

@implementation WxApiService

+ (WxApiService *) shareInstance
{
    static WxApiService *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - WXApiDelegate

- (void) onReq:(BaseReq *)req
{
    if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        ShowMessageFromWXReq *wxreq = (ShowMessageFromWXReq *)req;
        WXMediaMessage *mediaMessage = wxreq.message;
        
        NSLog(@"mediaObject class: %@", [mediaMessage.mediaObject class]);
        NSLog(@"%@, %@", mediaMessage.title, mediaMessage.description);
        if ([mediaMessage.mediaObject isKindOfClass:[WXImageObject class]]) {
            ;
        }
        else if ([mediaMessage.mediaObject isKindOfClass:[WXWebpageObject class]]) {
            [self performSelector:@selector(showMessageWithWebpageObject:) withObject:mediaMessage.mediaObject afterDelay:0.5f];
        }
        else if ([mediaMessage.mediaObject isKindOfClass:[WXAppExtendObject class]]) {
            [self performSelector:@selector(showMessageWithAppExtendObject:) withObject:mediaMessage.mediaObject afterDelay:0.5f];
        }
        else if ([mediaMessage.mediaObject isKindOfClass:[WXMusicObject class]]) {
            ;
        }
        else if ([mediaMessage.mediaObject isKindOfClass:[WXVideoObject class]]) {
            ;
        }
        else {
            ;
        }
    }
    else if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
        ;
    }
    
    NSLog(@"req type: %@", req.class);
    
}

- (void) onResp:(BaseResp *)resp
{
    NSLog(@"wx resp: %@", resp);
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        ;
    }
//    else if ([resp isKindOfClass:[SendAuthReq class]]) {
//        ;
//    }
}

#pragma mark - onReq selector

- (void) showMessageWithImageObject:(id) object
{
    
}


- (void) showMessageWithWebpageObject:(WXWebpageObject *) mediaObject
{
    NSURL *url = [NSURL URLWithString:mediaObject.webpageUrl];
    if (url != nil) {
        CDWebViewController *webViewController = [[CDWebViewController alloc] initWithUrl:mediaObject.webpageUrl];
        [webViewController setNavigationBarStyle:CDNavigationBarStyleBlue barButtonItemStyle:CDBarButtonItemStyleBlue toolBarStyle:CDToolBarStyleBlue];
        UINavigationController *navWebViewController = [[UINavigationController alloc] initWithRootViewController:webViewController];
        [ROOT_CONTROLLER presentViewController:navWebViewController animated:YES completion:^{
            NSLog(@"show webpage: %@", mediaObject.webpageUrl);
        }];
    }
    else {
        [MBProgressHUD showErrorMessage:@"无效的URL地址" inView:ROOT_CONTROLLER.view alpha:0.6f autoHide:YES showAnimated:YES hideAnimated:YES afterDelay:1.5f];
    }
}

- (void) showMessageWithAppExtendObject:(WXAppExtendObject *) mediaObject
{
    NSURL *url = [NSURL URLWithString:mediaObject.url];
    if (url != nil) {
        CDWebViewController *webViewController = [[CDWebViewController alloc] initWithUrl:mediaObject.url];
        [webViewController setNavigationBarStyle:CDNavigationBarStyleBlue barButtonItemStyle:CDBarButtonItemStyleBlue toolBarStyle:CDToolBarStyleBlue];
        UINavigationController *navWebViewController = [[UINavigationController alloc] initWithRootViewController:webViewController];
        [ROOT_CONTROLLER presentViewController:navWebViewController animated:YES completion:^{
            NSLog(@"show app url: %@", mediaObject.url);
        }];
    }
    else {
        [MBProgressHUD showErrorMessage:@"无效的URL地址" inView:ROOT_CONTROLLER.view alpha:0.6f autoHide:YES showAnimated:YES hideAnimated:YES afterDelay:1.5f];
    }
}

@end
