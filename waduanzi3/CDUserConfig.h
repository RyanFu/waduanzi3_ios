//
//  CDUserConfig.h
//  waduanzi3
//
//  Created by chendong on 13-8-14.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDUserConfig : NSObject

@property (nonatomic, assign) NSInteger postFontSize;
@property (nonatomic, assign) NSInteger commentFontSize;
@property (nonatomic, assign) BOOL wwan_big_image;
@property (nonatomic, assign) BOOL wifi_big_image;
@property (nonatomic, assign) BOOL enable_push_message;

+ (CDUserConfig *)shareInstance;
- (void) cache;
@end
