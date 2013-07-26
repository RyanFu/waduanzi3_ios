//
//  CDUIKit.m
//  waduanzi3
//
//  Created by chendong on 13-7-18.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDUIKit.h"

@implementation CDUIKit

+ (void) setNavigationBar:(UINavigationBar *)bar style:(CDNavigationBarStyle)style forBarMetrics:(UIBarMetrics)barMetrics
{
    switch (style) {
        case CDNavigationBarStyleBlue:
            [bar setBackgroundImage:[UIImage imageNamed:@"NavBarBackground.png"] forBarMetrics:barMetrics];
            break;
        case CDNavigationBarStyleBlack:
            [bar setBackgroundImage:[UIImage imageNamed:@"UISearchBarBackground.png"] forBarMetrics:barMetrics];
            break;
        case CDNavigationBarStyleDefault:
        default:
            break;
    }
}

+ (void) setBarButtionItem:(UIBarButtonItem *)button style:(CDBarButtionItemStyle)style forBarMetrics:(UIBarMetrics)barMetrics
{
    UIEdgeInsets buttonInsets;
    switch (style) {
        case CDBarButtionItemStyleBlue:
            buttonInsets = UIEdgeInsetsMake(0.0f, 4.0f, 0.0f, 4.0f);
            [button setBackgroundImage:[[UIImage imageNamed:@"NavBarButtonPortrait.png"] resizableImageWithCapInsets:buttonInsets]
                              forState:UIControlStateNormal
                            barMetrics:barMetrics];
            [button setBackgroundImage:[[UIImage imageNamed:@"NavBarButtonPortraitPressed.png"] resizableImageWithCapInsets:buttonInsets]
                              forState:UIControlStateSelected
                            barMetrics:UIBarMetricsDefault];
            break;
        case CDBarButtionItemStyleBlack:
            buttonInsets = UIEdgeInsetsMake(0.0f, 4.0f, 0.0f, 4.0f);
            [button setBackgroundImage:[[UIImage imageNamed:@"UISearchBarCancelButtonBackground.png"] resizableImageWithCapInsets:buttonInsets]
                              forState:UIControlStateNormal
                            barMetrics:barMetrics];
            [button setBackgroundImage:[[UIImage imageNamed:@"UISearchBarCancelButtonBackgroundPressed.png"] resizableImageWithCapInsets:buttonInsets]
                              forState:UIControlStateSelected
                            barMetrics:UIBarMetricsDefault];
        case CDBarButtionItemStyleDefault:
        default:
            break;
    }
}

+ (void) setBarButtionItems:(NSArray *)buttons style:(CDBarButtionItemStyle)style forBarMetrics:(UIBarMetrics)barMetrics
{
    for (UIBarButtonItem *button in buttons) {
        [[self class] setBarButtionItem:button style:style forBarMetrics:barMetrics];
    }
}

+ (void) setBackBarButtionItemStyle:(CDBarButtionItemStyle)style forBarMetrics:(UIBarMetrics)barMetrics
{
    UIEdgeInsets buttonInsets;
    switch (style) {
        case CDBarButtionItemStyleBlue:
            buttonInsets = UIEdgeInsetsMake(0.0f, 14.0f, 0.0f, 4.0f);
            [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"NavBarBackButtonPortrait.png"] resizableImageWithCapInsets:buttonInsets]
                              forState:UIControlStateNormal
                            barMetrics:barMetrics];
            [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"NavBarBackButtonPortraitPressed.png"] resizableImageWithCapInsets:buttonInsets]
                              forState:UIControlStateSelected
                            barMetrics:UIBarMetricsDefault];
            break;
        case CDBarButtionItemStyleBlack:
            buttonInsets = UIEdgeInsetsMake(1.0f, 12.0f, 1.0f, 4.0f);
            [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"navibarback.png"] resizableImageWithCapInsets:buttonInsets]
                                        forState:UIControlStateNormal
                                      barMetrics:barMetrics];
            [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"back_press.png"] resizableImageWithCapInsets:buttonInsets]
                                        forState:UIControlStateSelected
                                      barMetrics:UIBarMetricsDefault];
        case CDBarButtionItemStyleDefault:
        default:
            break;
    }
}

+ (void) setToolBar:(UIToolbar *)toolbar style:(CDToolBarStyle)style forToolbarPosition:(UIToolbarPosition)topOrBottom forBarMetrics:(UIBarMetrics)barMetrics
{
    switch (style) {
        case CDToolBarStyleBlue:
            [toolbar setBackgroundImage:[UIImage imageNamed:@"FBWebViewToolbarBackground.png"]
                                               forToolbarPosition:topOrBottom
                                                       barMetrics:barMetrics];
            break;
        case CDToolBarStyleBlack:
            [toolbar setBackgroundImage:[UIImage imageNamed:@"toolbar_bg_black.png"]
                     forToolbarPosition:topOrBottom
                             barMetrics:barMetrics];
            break;
        case CDToolBarStyleDefault:
        default:
            break;
    }
    
}
@end


