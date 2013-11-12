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

+ (void) addUMShareToCopyPlatform;
+ (NSArray *) enabledPlatforms;

+ (void) setSocialConfig;
+ (void) unOauthAllPlatforms;
@end
