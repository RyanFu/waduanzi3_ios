//
//  CDAppUser.m
//  waduanzi3
//
//  Created by chendong on 13-6-27.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDSession.h"
#import "CDDataCache.h"
#import "CDUser.h"
#import "UserLoginViewController.h"

@implementation CDSession

+ (CDSession *)shareInstance
{
    static CDSession *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[super alloc] init];
        }
    });
    return instance;
}

- (CDUser *) currentUser
{
    return [[CDDataCache shareCache] fetchLoginedUser];
}

- (BOOL) hasLogined
{
    id user = [[CDSession shareInstance] currentUser];
    return [user isKindOfClass:[CDUser class]];
}

- (void) logoutWithCompletion: (void (^)(void))completion;
{
    @try {
        if ([self hasLogined]) {
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

- (void) requiredLogin
{
    if ([self hasLogined]) return;
    
    UserLoginViewController *loginController = [[UserLoginViewController alloc] init];
    UINavigationController *loginNavController = [[UINavigationController alloc] initWithRootViewController:loginController];
    
    [ROOT_CONTROLLER presentViewController:loginNavController animated:YES completion:nil];
}

@end
