//
//  CDSocialKit.h
//  waduanzi3
//
//  Created by chendong on 13-7-27.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocial.h"

@interface CDSocialKit : NSObject

+ (CDSocialKit *)shareInstance;

- (NSArray *) enabledPlatforms;
- (void) socialConfig;
- (void) unOauthAllPlatforms;
@end
