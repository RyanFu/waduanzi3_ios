//
//  CDConfig.h
//  waduanzi3
//
//  Created by chendong on 13-6-11.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDConfig : NSObject

+ (BOOL) enabledFocusListBannerAdvert;
+ (BOOL) enabledUMHandle;

+ (CDConfig *) shareInstance;
- (void) cache;

@end
