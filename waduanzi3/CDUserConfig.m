//
//  CDUserConfig.m
//  waduanzi3
//
//  Created by chendong on 13-8-14.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDUserConfig.h"

#define APP_USER_CONFIG_CACHE_ID @"user_config"

@interface CDUserConfig ()

- (void) setDefaults;
+ (NSString *) generateCacheID:(NSString *)key;
+ (void) cacheConfig:(CDUserConfig *)config;
+ (id) fetchCacheConfig;

@end


@implementation CDUserConfig

@synthesize postFontSize = _postFontSize;
@synthesize commentFontSize = _commentFontSize;
@synthesize auto_change_image_size = _auto_change_image_size;
@synthesize enable_push_message = _enable_push_message;

+ (CDUserConfig *)shareInstance
{
    static CDUserConfig *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [CDUserConfig fetchCacheConfig];
        if (instance == nil) {
            instance = [[CDUserConfig alloc] init];
            [instance setDefaults];
        }
        
    });
    return instance;
}

- (void) setDefaults
{
    self.postFontSize = CDPostContentFontSizeNormal;
    self.commentFontSize = CDCommentContentFontSizeNormal;
    self.auto_change_image_size = YES;
    self.enable_push_message = YES;
}


- (void) cache
{
    [[self class] cacheConfig:self];
}



+ (void) cacheConfig:(CDUserConfig *)config
{
    NSString *cacheKey = [CDUserConfig generateCacheID: APP_USER_CONFIG_CACHE_ID];
    NSData *archiver = [NSKeyedArchiver archivedDataWithRootObject:config];
    [USER_DEFAULTS setObject:archiver forKey:cacheKey];
}

+ (id) fetchCacheConfig
{
    NSString *cacheKey = [CDUserConfig generateCacheID: APP_USER_CONFIG_CACHE_ID];
    NSData *data = [USER_DEFAULTS objectForKey:cacheKey];
    if (data == nil)
        return nil;
    else {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
}

+ (NSString *) generateCacheID:(NSString *)key
{
    return [NSString stringWithFormat:@"app_user_config_ver_%@_%@", APP_VERSION, key];
}



- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.postFontSize = [decoder decodeIntegerForKey:@"post_font_size"];
        self.commentFontSize = [decoder decodeIntegerForKey:@"comment_font_size"];
        self.auto_change_image_size = [decoder decodeBoolForKey:@"auto_change_image_size"];
        self.enable_push_message = [decoder decodeBoolForKey:@"enable_push_message"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInteger:_postFontSize forKey:@"post_font_size"];
    [encoder encodeInteger:_commentFontSize forKey:@"comment_font_size"];
    [encoder encodeBool:_auto_change_image_size forKey:@"auto_change_image_size"];
    [encoder encodeBool:_enable_push_message forKey:@"enable_push_message"];
}

@end

