//
//  MBProgressHUD+Custom.h
//  waduanzi3
//
//  Created by chendong on 13-9-13.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Custom)

+ (void) show:(BOOL)showAnimated errorMessage:(NSString*)message inView:(UIView *)view alpha:(CGFloat)alpha hide:(BOOL)hideAnimated afterDelay:(NSTimeInterval)delay;

+ (void) show:(BOOL)showAnimated successMessage:(NSString*)message inView:(UIView *)view alpha:(CGFloat)alpha hide:(BOOL)hideAnimated afterDelay:(NSTimeInterval)delay;
@end
