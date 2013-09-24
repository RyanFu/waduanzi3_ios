//
//  CDUMSociaSnsPlatformExtend.m
//  waduanzi3
//
//  Created by chendong on 13-9-24.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDUMSociaSnsPlatformExtend.h"
#import "MBProgressHUD+Custom.h"


@implementation CDUMSociaSnsPlatformExtend

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
