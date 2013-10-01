//
//  CDUIKit.h
//  waduanzi3
//
//  Created by chendong on 13-7-18.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CDNavigationBarStyle) {
    CDNavigationBarStyleDefault,
    CDNavigationBarStyleBlack,
    CDNavigationBarStyleBlue
};

typedef NS_ENUM(NSInteger, CDBarButtonItemStyle) {
    CDBarButtonItemStyleDefault,
    CDBarButtonItemStyleBlack,
    CDBarButtonItemStyleBlue,
    CDBarButtonItemStyleBlackBack,
    CDBarButtonItemStyleBlueBack,
};

typedef NS_ENUM(NSInteger, CDToolBarStyle) {
    CDToolBarStyleDefault,
    CDToolBarStyleBlack,
    CDToolBarStyleBlue
};

@interface CDUIKit : NSObject

+ (void) setBarButtonItemTitleAttributes:(UIBarButtonItem *)button forBarMetrics:(UIBarMetrics)barMetrics;

+ (void) setNavigationBar:(UINavigationBar *)bar style:(CDNavigationBarStyle)style forBarMetrics:(UIBarMetrics)barMetrics;
+ (void) setBarButtonItem:(UIBarButtonItem *)button style:(CDBarButtonItemStyle)style forBarMetrics:(UIBarMetrics)barMetrics;
+ (void) setBackBarButtonItemStyle:(CDBarButtonItemStyle)style forBarMetrics:(UIBarMetrics)barMetrics;
+ (void) setToolBar:(UIToolbar *)toolbar style:(CDToolBarStyle)style forToolbarPosition:(UIToolbarPosition)topOrBottom forBarMetrics:(UIBarMetrics)barMetrics;
@end
