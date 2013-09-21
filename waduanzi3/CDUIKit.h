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

typedef NS_ENUM(NSInteger, CDBarButtionItemStyle) {
    CDBarButtionItemStyleDefault,
    CDBarButtionItemStyleBlack,
    CDBarButtionItemStyleBlue,
    CDBarButtionItemStyleBlackBack,
    CDBarButtionItemStyleBlueBack,
};

typedef NS_ENUM(NSInteger, CDToolBarStyle) {
    CDToolBarStyleDefault,
    CDToolBarStyleBlack,
    CDToolBarStyleBlue
};

@interface CDUIKit : NSObject

+ (void) setBarButtonItem:(UIBarButtonItem *)button titleAttributes:(NSDictionary *)attributes forBarMetrics:(UIBarMetrics)barMetrics;

+ (void) setNavigationBar:(UINavigationBar *)bar style:(CDNavigationBarStyle)style forBarMetrics:(UIBarMetrics)barMetrics;
+ (void) setBarButtionItem:(UIBarButtonItem *)button style:(CDBarButtionItemStyle)style forBarMetrics:(UIBarMetrics)barMetrics;
+ (void) setBackBarButtionItemStyle:(CDBarButtionItemStyle)style forBarMetrics:(UIBarMetrics)barMetrics;
+ (void) setToolBar:(UIToolbar *)toolbar style:(CDToolBarStyle)style forToolbarPosition:(UIToolbarPosition)topOrBottom forBarMetrics:(UIBarMetrics)barMetrics;
@end
