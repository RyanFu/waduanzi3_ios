//
//  UserConfig.m
//  waduanzi3
//
//  Created by chendong on 13-8-5.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "UserConfig.h"
#import "CDSession.h"
#import "OpenUDID.h"


@interface UserConfig ()
+ (NSString *) cacheKeyWithUserID:(NSInteger)user_id;
+ (void) cacheUserConfig:(UserConfig *)config withUserID:(NSInteger)user_id;
+ (id) fetchUserConfigFromCacheWithUserID:(NSInteger)user_id;
@end

@implementation UserConfig

@synthesize userID = _userID;
@synthesize deviceUDID = _deviceUDID;
@synthesize enablePushMessage = _enablePushMessage;

+ (id) currentConfig
{
    NSInteger user_id = 0;
    if ([[CDSession shareInstance] hasLogined]) {
        CDUser *user = [[CDSession shareInstance] currentUser];
        user_id = [user.user_id integerValue];
    }
    
    id instance = [[self class] fetchUserConfigFromCacheWithUserID:user_id];
    return (instance == nil) ? [[[self class] alloc] initWithUserID:user_id] : instance;
}

- (id) initWithUserID:(NSInteger)user_id
{
    self = [super init];
    if (self) {
        self.userID = user_id;
        
        // defaults
        self.enablePushMessage = NO;
        self.deviceUDID = OPEN_UDID;
    }
    return self;
}

- (void) updateCache
{
    [[self class] cacheUserConfig:self withUserID:_userID];
}

+ (void) cacheUserConfig:(UserConfig *)config withUserID:(NSInteger)user_id
{
    NSString *cacheKey = [[self class] cacheKeyWithUserID:user_id];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:config];
    [USER_DEFAULTS setObject:data forKey:cacheKey];
}

+ (id) fetchUserConfigFromCacheWithUserID:(NSInteger)user_id
{
    NSString *cacheKey = [[self class] cacheKeyWithUserID:user_id];
    NSData *data = [USER_DEFAULTS objectForKey:cacheKey];
    
    return (data == nil) ? nil : [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+ (NSString *) cacheKeyWithUserID:(NSInteger)user_id
{
    return [NSString stringWithFormat:@"user_config_cache_key_user_id_%d", user_id];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.enablePushMessage = [decoder decodeBoolForKey:@"enable_push_message"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeBool:_enablePushMessage forKey:@"enable_push_message"];
}

@end
