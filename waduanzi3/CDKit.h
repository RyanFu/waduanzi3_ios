//
//  UIViewController+Waduanzi.h
//  waduanzi3
//
//  Created by chendong on 13-9-14.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface CDKit : NSObject 

+ (void) openAppStoreByAppID:(NSString *)app_id review:(BOOL)review target:(UIViewController*)controller delegate:(id<SKStoreProductViewControllerDelegate>)delegate;

@end
