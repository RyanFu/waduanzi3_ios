//
//  CDUIKit.m
//  waduanzi3
//
//  Created by chendong on 13-7-18.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDUIKit.h"
#import "UIImage+ColorImage.h"

@implementation CDUIKit

+ (void) setBarButtonItemTitleAttributes:(UIBarButtonItem *)button forBarMetrics:(UIBarMetrics)barMetrics
{
    CGFloat size = (barMetrics == UIBarMetricsLandscapePhone) ? 12.0f : 14.0f;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                  [UIColor whiteColor], NSForegroundColorAttributeName,
                  [UIFont fontWithName:FZLTHK_FONT_NAME size:size], NSFontAttributeName,
                  nil];
    [button setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    [attributes setObject:[UIColor lightGrayColor] forKey:NSForegroundColorAttributeName];
    [button setTitleTextAttributes:attributes forState:UIControlStateDisabled];
}

+ (void) setNavigationBar:(UINavigationBar *)bar style:(CDNavigationBarStyle)style forBarMetrics:(UIBarMetrics)barMetrics
{
    switch (style) {
        case CDNavigationBarStyleBlue:
            if (IS_IOS7) {
                UIImage *navBgImage = [UIImage imageWithColor:[UIColor colorWithRed:0.27f green:0.38f blue:0.62f alpha:1.00f] size:CGSizeMake(1, NAVBAR_HEIGHT + STATUSBAR_HEIGHT)];
                [bar setBackgroundImage:navBgImage forBarMetrics:barMetrics];
                bar.barTintColor = [UIColor colorWithRed:0.27f green:0.38f blue:0.62f alpha:1.00f];
                bar.tintColor = [UIColor colorWithRed:0.27f green:0.38f blue:0.62f alpha:1.00f];
            }
            else
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

+ (void) setBarButtonItem:(UIBarButtonItem *)button style:(CDBarButtonItemStyle)style forBarMetrics:(UIBarMetrics)barMetrics
{
    UIEdgeInsets buttonInsets;
    switch (style) {
        case CDBarButtonItemStyleBlue:
            if (barMetrics == UIBarMetricsLandscapePhone) {
                buttonInsets = UIEdgeInsetsMake(0.0f, 4.0f, 0.0f, 4.0f);
                [button setBackgroundImage:[[UIImage imageNamed:@"NavBarButtonLandscape.png"] resizableImageWithCapInsets:buttonInsets]
                                  forState:UIControlStateNormal
                                barMetrics:barMetrics];
                [button setBackgroundImage:[[UIImage imageNamed:@"NavBarButtonLandscapePressed.png"] resizableImageWithCapInsets:buttonInsets]
                                  forState:UIControlStateSelected
                                barMetrics:barMetrics];
                [button setBackgroundImage:[[UIImage imageNamed:@"NavBarButtonLandscapePressed.png"] resizableImageWithCapInsets:buttonInsets]
                                  forState:UIControlStateHighlighted
                                barMetrics:barMetrics];
            }
            else {
                buttonInsets = UIEdgeInsetsMake(0.0f, 4.0f, 0.0f, 4.0f);
                [button setBackgroundImage:[[UIImage imageNamed:@"NavBarButtonPortrait.png"] resizableImageWithCapInsets:buttonInsets]
                                  forState:UIControlStateNormal
                                barMetrics:barMetrics];
                [button setBackgroundImage:[[UIImage imageNamed:@"NavBarButtonPortraitPressed.png"] resizableImageWithCapInsets:buttonInsets]
                                  forState:UIControlStateSelected
                                barMetrics:barMetrics];
                [button setBackgroundImage:[[UIImage imageNamed:@"NavBarButtonPortraitPressed.png"] resizableImageWithCapInsets:buttonInsets]
                                  forState:UIControlStateHighlighted
                                barMetrics:barMetrics];
            }
            break;
        case CDBarButtonItemStyleBlack:
            buttonInsets = UIEdgeInsetsMake(0.0f, 4.0f, 0.0f, 4.0f);
            [button setBackgroundImage:[[UIImage imageNamed:@"UISearchBarCancelButtonBackground.png"] resizableImageWithCapInsets:buttonInsets]
                              forState:UIControlStateNormal
                            barMetrics:barMetrics];
            [button setBackgroundImage:[[UIImage imageNamed:@"UISearchBarCancelButtonBackgroundPressed.png"] resizableImageWithCapInsets:buttonInsets]
                              forState:UIControlStateSelected
                            barMetrics:barMetrics];
            [button setBackgroundImage:[[UIImage imageNamed:@"UISearchBarCancelButtonBackgroundPressed.png"] resizableImageWithCapInsets:buttonInsets]
                              forState:UIControlStateHighlighted
                            barMetrics:barMetrics];
            
            break;
            
        case CDBarButtonItemStyleBlueBack:
            [button setTitlePositionAdjustment:UIOffsetMake(3.0f, 0) forBarMetrics:barMetrics];
            
            if (barMetrics == UIBarMetricsLandscapePhone) {
                buttonInsets = UIEdgeInsetsMake(0.0f, 12.0f, 0.0f, 4.0f);
                [button setBackgroundImage:[[UIImage imageNamed:@"NavBarBackButtonLandscape.png"] resizableImageWithCapInsets:buttonInsets]
                                  forState:UIControlStateNormal
                                barMetrics:barMetrics];
                [button setBackgroundImage:[[UIImage imageNamed:@"NavBarBackButtonLandscapePressed.png"] resizableImageWithCapInsets:buttonInsets]
                                  forState:UIControlStateSelected
                                barMetrics:barMetrics];
                [button setBackgroundImage:[[UIImage imageNamed:@"NavBarBackButtonLandscapePressed.png"] resizableImageWithCapInsets:buttonInsets]
                                  forState:UIControlStateHighlighted
                                barMetrics:barMetrics];
            }
            else {
                buttonInsets = UIEdgeInsetsMake(0.0f, 14.0f, 0.0f, 4.0f);
                [button setBackgroundImage:[[UIImage imageNamed:@"NavBarBackButtonPortrait.png"] resizableImageWithCapInsets:buttonInsets]
                                  forState:UIControlStateNormal
                                barMetrics:barMetrics];
                [button setBackgroundImage:[[UIImage imageNamed:@"NavBarBackButtonPortraitPressed.png"] resizableImageWithCapInsets:buttonInsets]
                                  forState:UIControlStateSelected
                                barMetrics:barMetrics];
                [button setBackgroundImage:[[UIImage imageNamed:@"NavBarBackButtonPortraitPressed.png"] resizableImageWithCapInsets:buttonInsets]
                                  forState:UIControlStateHighlighted
                                barMetrics:barMetrics];
            }
            break;
            
        case CDBarButtonItemStyleBlackBack:
            [button setTitlePositionAdjustment:UIOffsetMake(3.0f, 0) forBarMetrics:barMetrics];
            
            buttonInsets = UIEdgeInsetsMake(0.0f, 12.0f, 0.0f, 5.0f);
            [button setBackgroundImage:[[UIImage imageNamed:@"back_normal.png"] resizableImageWithCapInsets:buttonInsets]
                              forState:UIControlStateNormal
                            barMetrics:barMetrics];
            [button setBackgroundImage:[[UIImage imageNamed:@"back_press.png"] resizableImageWithCapInsets:buttonInsets]
                              forState:UIControlStateSelected
                            barMetrics:barMetrics];
            [button setBackgroundImage:[[UIImage imageNamed:@"back_press.png"] resizableImageWithCapInsets:buttonInsets]
                              forState:UIControlStateHighlighted
                            barMetrics:barMetrics];
            
            break;
            
        case CDBarButtonItemStyleDefault:
        default:
            break;
    }
}

+ (void) setBackBarButtonItemStyle:(CDBarButtonItemStyle)style forBarMetrics:(UIBarMetrics)barMetrics
{
    UIEdgeInsets buttonInsets;
    switch (style) {
        case CDBarButtonItemStyleBlue:
            buttonInsets = UIEdgeInsetsMake(0.0f, 14.0f, 0.0f, 4.0f);
            [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"NavBarBackButtonPortrait.png"] resizableImageWithCapInsets:buttonInsets]
                                                              forState:UIControlStateNormal
                                                            barMetrics:barMetrics];
            [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"NavBarBackButtonPortraitPressed.png"] resizableImageWithCapInsets:buttonInsets]
                                                              forState:UIControlStateSelected
                                                            barMetrics:barMetrics];
            [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"NavBarBackButtonPortraitPressed.png"] resizableImageWithCapInsets:buttonInsets]
                                                              forState:UIControlStateHighlighted
                                                            barMetrics:barMetrics];
            break;
        case CDBarButtonItemStyleBlack:
            buttonInsets = UIEdgeInsetsMake(0.0f, 12.0f, 0.0f, 5.0f);
            [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"back_normal.png"] resizableImageWithCapInsets:buttonInsets]
                                                              forState:UIControlStateNormal
                                                            barMetrics:barMetrics];
            [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"back_press.png"] resizableImageWithCapInsets:buttonInsets]
                                                              forState:UIControlStateSelected
                                                            barMetrics:barMetrics];
            [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"back_press.png"] resizableImageWithCapInsets:buttonInsets]
                                                              forState:UIControlStateHighlighted
                                                            barMetrics:barMetrics];
            break;
        case CDBarButtonItemStyleDefault:
        default:
            break;
    }
}

+ (void) setToolBar:(UIToolbar *)toolbar style:(CDToolBarStyle)style forToolbarPosition:(UIToolbarPosition)topOrBottom forBarMetrics:(UIBarMetrics)barMetrics
{
    UIImage *normalImage, *pressedImage;
    UIEdgeInsets buttonInsets;
    switch (style) {
        case CDToolBarStyleBlue:
            [toolbar setBackgroundImage:[UIImage imageNamed:@"FBWebViewToolbarBackground.png"]
                                               forToolbarPosition:topOrBottom
                                                       barMetrics:barMetrics];
            
            buttonInsets = UIEdgeInsetsMake(0.0f, 4.0f, 0.0f, 4.0f);
            normalImage = [[UIImage imageNamed:@"NavBarButtonPortrait.png"] resizableImageWithCapInsets:buttonInsets];
            [[UIBarButtonItem appearanceWhenContainedIn:[UIToolbar class], nil] setBackgroundImage: normalImage
                                                                                          forState: UIControlStateNormal
                                                                                        barMetrics: barMetrics];
            
            pressedImage = [[UIImage imageNamed:@"NavBarButtonPortraitPressed.png"] resizableImageWithCapInsets:buttonInsets];
            [[UIBarButtonItem appearanceWhenContainedIn:[UIToolbar class], nil] setBackgroundImage: pressedImage
                                                                                          forState: UIControlStateSelected
                                                                                        barMetrics: barMetrics];
            
            [[UIBarButtonItem appearanceWhenContainedIn:[UIToolbar class], nil] setBackgroundImage: pressedImage
                                                                                          forState: UIControlStateHighlighted
                                                                                        barMetrics: barMetrics];
            
            break;
        case CDToolBarStyleBlack:
            [toolbar setBackgroundImage:[UIImage imageNamed:@"toolbar_bg_black.png"]
                     forToolbarPosition:topOrBottom
                             barMetrics:barMetrics];
            
            buttonInsets = UIEdgeInsetsMake(0.0f, 4.0f, 0.0f, 4.0f);
            normalImage = [[UIImage imageNamed:@"UISearchBarCancelButtonBackground.png"] resizableImageWithCapInsets:buttonInsets];
            [[UIBarButtonItem appearanceWhenContainedIn:[UIToolbar class], nil] setBackgroundImage: normalImage
                                                                                          forState: UIControlStateNormal
                                                                                        barMetrics: barMetrics];
            
            pressedImage = [[UIImage imageNamed:@"UISearchBarCancelButtonBackgroundPressed.png"] resizableImageWithCapInsets:buttonInsets];
            [[UIBarButtonItem appearanceWhenContainedIn:[UIToolbar class], nil] setBackgroundImage: pressedImage
                                                                                          forState: UIControlStateSelected
                                                                                        barMetrics: barMetrics];
            
            [[UIBarButtonItem appearanceWhenContainedIn:[UIToolbar class], nil] setBackgroundImage: pressedImage
                                                                                          forState: UIControlStateHighlighted
                                                                                        barMetrics: barMetrics];
            
            break;
        case CDToolBarStyleDefault:
        default:
            break;
    }
    
}
@end


