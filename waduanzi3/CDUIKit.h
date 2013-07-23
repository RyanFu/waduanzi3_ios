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
    CDNavigationBarStyleSearch
};

typedef NS_ENUM(NSInteger, CDBarButtionItemStyle) {
    CDBarButtionItemStyleDefault,
    CDBarButtionItemStyleSearch
};

@interface CDUIKit : NSObject

+ (void) setNavigationBar:(UINavigationBar *)bar style:(CDNavigationBarStyle)style forBarMetrics:(UIBarMetrics)barMetrics;
+ (void) setBarButtionItem:(UIBarButtonItem *)button style:(CDBarButtionItemStyle)style forBarMetrics:(UIBarMetrics)barMetrics;
+ (void) setBarButtionItems:(NSArray *)buttons style:(CDBarButtionItemStyle)style forBarMetrics:(UIBarMetrics)barMetrics;
+ (void) setBackBarButtionItemStyle:(CDBarButtionItemStyle)style forBarMetrics:(UIBarMetrics)barMetrics;
@end