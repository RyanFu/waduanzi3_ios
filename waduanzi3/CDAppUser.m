//
//  CDAppUser.m
//  waduanzi3
//
//  Created by chendong on 13-6-27.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDAppUser.h"
#import "CDDataCache.h"
#import "CDUser.h"

@implementation CDAppUser

static CDAppUser *instance;

+ (CDAppUser *)shareAppUser
{
    @synchronized(self) {
        if (instance == nil) {
            instance = [[super alloc] init];
        }
    }
    return instance;
}

+ (CDUser *) currentUser
{
    return [[CDDataCache shareCache] fetchLoginedUser];
}

+ (BOOL) hasLogined
{
    id user = [CDAppUser currentUser];
    return [user isKindOfClass:[CDUser class]];
}
@end
