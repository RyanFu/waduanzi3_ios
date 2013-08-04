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
#import "UserLoginViewController.h"

@implementation CDAppUser

+ (CDAppUser *)shareAppUser
{
    static CDAppUser *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[super alloc] init];
        }
    });
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

+ (void) logoutWithCompletion: (void (^)(void))completion;
{
    @try {
        if ([[self class] hasLogined]) {
            [[CDDataCache shareCache] removeLoginedUserCache];
            [[CDDataCache shareCache] removeMySharePosts];
            [[CDDataCache shareCache] removeFavoritePosts];
            [[CDDataCache shareCache] removeMyFeedbackPosts];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                completion();
            });
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"caught exception: %@", exception);
    }
}

+ (void) requiredLogin
{
    if ([[self class] hasLogined]) return;
    
    UserLoginViewController *loginController = [[UserLoginViewController alloc] init];
    UINavigationController *loginNavController = [[UINavigationController alloc] initWithRootViewController:loginController];
    
    [ROOT_CONTROLLER presentViewController:loginNavController animated:YES completion:nil];
}

@end
