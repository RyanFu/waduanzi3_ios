//
//  CDUserConfig.h
//  waduanzi3
//
//  Created by chendong on 13-8-14.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDUserConfig : NSObject

@property (nonatomic) NSInteger postFontSize;
@property (nonatomic) NSInteger commentFontSize;

+ (CDUserConfig *)shareInstance;
- (void) cache;
@end
