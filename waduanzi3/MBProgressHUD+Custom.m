//
//  MBProgressHUD+Custom.m
//  waduanzi3
//
//  Created by chendong on 13-9-13.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "MBProgressHUD+Custom.h"

@implementation MBProgressHUD (Custom)

+ (void) show:(BOOL)showAnimated errorMessage:(NSString*)message inView:(UIView *)view alpha:(CGFloat)alpha hide:(BOOL)hideAnimated afterDelay:(NSTimeInterval)delay
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tip_error"]];
    hud.alpha = alpha;
    hud.detailsLabelText = message;
    hud.detailsLabelFont = [UIFont systemFontOfSize:14.0f];
    [hud show:showAnimated];
    [hud hide:hideAnimated afterDelay:delay];
}

+ (void) show:(BOOL)showAnimated successMessage:(NSString*)message inView:(UIView *)view alpha:(CGFloat)alpha hide:(BOOL)hideAnimated afterDelay:(NSTimeInterval)delay
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tip_succeed"]];
    hud.alpha = alpha;
    hud.detailsLabelText = message;
    hud.detailsLabelFont = [UIFont systemFontOfSize:14.0f];
    [hud show:showAnimated];
    [hud hide:hideAnimated afterDelay:delay];
}
@end
