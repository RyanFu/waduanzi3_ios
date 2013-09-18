//
//  SettingViewController.h
//  waduanzi3
//
//  Created by chendong on 13-6-19.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "CDQuickDialogController.h"

@interface SettingViewController : CDQuickDialogController <QuickDialogStyleProvider, SKStoreProductViewControllerDelegate>

@end
