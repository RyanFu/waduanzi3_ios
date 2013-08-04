//
//  CDAppUser.h
//  waduanzi3
//
//  Created by chendong on 13-6-27.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDSocialKit.h"
#import "CDUser.h"

@interface CDAppUser : NSObject

+ (CDAppUser *) shareAppUser;
+ (CDUser *) currentUser;
+ (BOOL) hasLogined;
+ (void) logoutWithCompletion: (void (^)(void))completion;

+ (void) requiredLogin;

@end
