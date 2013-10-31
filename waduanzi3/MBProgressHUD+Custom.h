//
//  MBProgressHUD+Custom.h
//  waduanzi3
//
//  Created by chendong on 13-9-13.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Custom)

+ (MBProgressHUD *) showErrorMessage:(NSString*)message inView:(UIView *)view alpha:(CGFloat)alpha autoHide:(BOOL)autoHide showAnimated:(BOOL)showAnimated hideAnimated:(BOOL)hideAnimated afterDelay:(NSTimeInterval)delay;

+ (MBProgressHUD *) showSuccessMessage:(NSString*)message inView:(UIView *)view alpha:(CGFloat)alpha autoHide:(BOOL)autoHide showAnimated:(BOOL)showAnimated hideAnimated:(BOOL)hideAnimated afterDelay:(NSTimeInterval)delay;

+ (MBProgressHUD *) showText:(NSString*)text inView:(UIView *)view alpha:(CGFloat)alpha autoHide:(BOOL)autoHide showAnimated:(BOOL)showAnimated hideAnimated:(BOOL)hideAnimated afterDelay:(NSTimeInterval)delay;
@end
