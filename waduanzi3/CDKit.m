//
//  UIViewController+Waduanzi.m
//  waduanzi3
//
//  Created by chendong on 13-9-14.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDKit.h"

@implementation CDKit

+ (void) openAppStoreByAppID:(NSString *)app_id review:(BOOL)review target:(UIViewController*)controller delegate:(id<SKStoreProductViewControllerDelegate>)delegate
{
    if (NSStringFromClass([SKStoreProductViewController class]) == nil) {
        NSLog(@"less than 6.0");
        NSString *appUrl = review ? APP_STORE_REVIEW_URL(app_id) : APP_STORE_URL(app_id);
        [CDAPPLICATION openURL:[NSURL URLWithString:appUrl]];
    }
    else {
        NSLog(@"greater than 6.0");
        SKStoreProductViewController *storeProductController = [[SKStoreProductViewController alloc] init];
        storeProductController.delegate = delegate;
        [storeProductController loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:app_id} completionBlock:nil];
        [controller presentViewController:storeProductController animated:YES completion:^{
            NSLog(@"present store product controller, app id: %@", app_id);
        }];
    }
}
@end
