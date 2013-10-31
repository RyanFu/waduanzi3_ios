//
//  MBProgressHUD+Custom.m
//  waduanzi3
//
//  Created by chendong on 13-9-13.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "MBProgressHUD+Custom.h"

@implementation MBProgressHUD (Custom)

+ (MBProgressHUD *) showErrorMessage:(NSString*)message inView:(UIView *)view alpha:(CGFloat)alpha autoHide:(BOOL)autoHide showAnimated:(BOOL)showAnimated hideAnimated:(BOOL)hideAnimated afterDelay:(NSTimeInterval)delay
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tip_error"]];
    hud.alpha = alpha;
    hud.detailsLabelText = message;
    hud.detailsLabelFont = [UIFont systemFontOfSize:14.0f];
    [hud show:showAnimated];
    
    if (autoHide)
        [hud hide:hideAnimated afterDelay:delay];
    
    return hud;
}

+ (MBProgressHUD *) showSuccessMessage:(NSString*)message inView:(UIView *)view alpha:(CGFloat)alpha autoHide:(BOOL)autoHide showAnimated:(BOOL)showAnimated hideAnimated:(BOOL)hideAnimated afterDelay:(NSTimeInterval)delay
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tip_succeed"]];
    hud.alpha = alpha;
    hud.detailsLabelText = message;
    hud.detailsLabelFont = [UIFont systemFontOfSize:14.0f];
    [hud show:showAnimated];
    
    if (autoHide)
        [hud hide:hideAnimated afterDelay:delay];
    
    return hud;
}


+ (MBProgressHUD *) showText:(NSString*)text inView:(UIView *)view alpha:(CGFloat)alpha autoHide:(BOOL)autoHide showAnimated:(BOOL)showAnimated hideAnimated:(BOOL)hideAnimated afterDelay:(NSTimeInterval)delay
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.alpha = alpha;
    hud.detailsLabelText = text;
    hud.detailsLabelFont = [UIFont systemFontOfSize:14.0f];
    [hud show:showAnimated];
    
    if (autoHide)
        [hud hide:hideAnimated afterDelay:delay];
    
    return hud;
}

@end
