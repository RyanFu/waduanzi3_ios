//
//  CDConfig.m
//  waduanzi3
//
//  Created by chendong on 13-6-11.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDConfig.h"
#import "MobClick.h"
#import "CDDataCache.h"

#define APP_CONFIG_CACHE_ID @"app_config"

@interface CDConfig ()

- (void) setDefaults;
+ (NSString *) generateCacheID:(NSString *)key;
+ (void) cacheConfig:(CDConfig *)config;
+ (id) fetchCacheConfig;

@end

@implementation CDConfig

+ (CDConfig *) shareInstance
{
    static CDConfig *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self fetchCacheConfig];
        if (instance == nil)
            instance = [[CDConfig alloc] init];
    });
    return instance;
}

- (void) setDefaults
{

}

+ (BOOL) enabledFocusListBannerAdvert
{
    if (CD_DEBUG) return YES;
    
    @try {
        double firstBootTime = [[CDDataCache shareCache] fetchAppFirstBootTime];
        if (firstBootTime > CFAbsoluteTimeGetCurrent() - DAY_SECONDS)
            return NO;
        NSString *switcher = [MobClick getConfigParams:UM_ONLINE_CONFIG_ENABLE_FOCUS_LIST_BANNER];
        return [switcher isEqualToString:@"on"];
    }
    @catch (NSException *exception) {
        CDLog(@"enable umhandle exception: %@", exception.reason);
        return NO;
    }
    @finally {
        ;
    }
    
    return NO;
}

+ (BOOL) showAppRecommendTab
{
    if (CD_DEBUG) return YES;
    
    @try {
        double firstBootTime = [[CDDataCache shareCache] fetchAppFirstBootTime];
        if (firstBootTime > CFAbsoluteTimeGetCurrent() - DAY_SECONDS)
            return NO;
        
        NSString *switcher = [MobClick getConfigParams:UM_ONLINE_CONFIG_SHOW_APP_RECOMMEND_TAB];
        return [switcher isEqualToString:@"on"];
    }
    @catch (NSException *exception) {
        CDLog(@"show app recommend tab exception: %@", exception.reason);
        return NO;
    }
    @finally {
        ;
    }
    
    return NO;
}

+ (BOOL) enabledUMHandle
{
    if (CD_DEBUG) return YES;
    
    @try {
        double firstBootTime = [[CDDataCache shareCache] fetchAppFirstBootTime];
        if (firstBootTime > CFAbsoluteTimeGetCurrent() - DAY_SECONDS)
            return NO;
        
        NSString *switcher = [MobClick getConfigParams:UM_ONLINE_CONFIG_APP_UNION_HANLE];
        return [switcher isEqualToString:@"on"];
    }
    @catch (NSException *exception) {
        CDLog(@"enable umhandle exception: %@", exception.reason);
        return NO;
    }
    @finally {
        ;
    }
    
    return NO;
}


- (void) cache
{
    [CDConfig cacheConfig:self];
}



+ (void) cacheConfig:(CDConfig *)config
{
    NSString *cacheKey = [CDConfig generateCacheID: APP_CONFIG_CACHE_ID];
    NSData *archiver = [NSKeyedArchiver archivedDataWithRootObject:config];
    [USER_DEFAULTS setObject:archiver forKey:cacheKey];
}

+ (id) fetchCacheConfig
{
    NSString *cacheKey = [CDConfig generateCacheID: APP_CONFIG_CACHE_ID];
    NSData *data = [USER_DEFAULTS objectForKey:cacheKey];
    if (data == nil)
        return nil;
    else {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
}

+ (NSString *) generateCacheID:(NSString *)key
{
    return [NSString stringWithFormat:@"app_config_ver_%@_%@", APP_VERSION, key];
}

@end
