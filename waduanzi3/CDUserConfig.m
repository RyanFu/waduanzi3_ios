//
//  CDUserConfig.m
//  waduanzi3
//
//  Created by chendong on 13-8-14.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDUserConfig.h"

@interface CDUserConfig ()
+ (NSString *) generateCacheID:(NSString *)key;

+ (void) cacheConfig:(CDUserConfig *)config;
+ (id) fetchCacheConfig;

@end

@implementation CDUserConfig

@synthesize postFontSize = _postFontSize;
@synthesize commentFontSize = _commentFontSize;

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
}


- (void) cache
{
    [[self class] cacheConfig:self];
}



+ (void) cacheConfig:(CDUserConfig *)config
{
    NSString *cacheKey = [CDUserConfig generateCacheID:@"user_config"];
    NSData *archiver = [NSKeyedArchiver archivedDataWithRootObject:config];
    [USER_DEFAULTS setObject:archiver forKey:cacheKey];
}

+ (id) fetchCacheConfig
{
    NSString *cacheKey = [CDUserConfig generateCacheID:@"user_config"];
    NSData *data = [USER_DEFAULTS objectForKey:cacheKey];
    if (data == nil)
        return nil;
    else {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
}

+ (NSString *) generateCacheID:(NSString *)key
{
    return [NSString stringWithFormat:@"app_ver_%@_%@", APP_VERSION, key];
}



- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.postFontSize = [decoder decodeIntegerForKey:@"post_font_size"];
        self.commentFontSize = [decoder decodeIntegerForKey:@"comment_font_size"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeInteger:_postFontSize forKey:@"post_font_size"];
    [encoder encodeInteger:_commentFontSize forKey:@"comment_font_size"];
}

@end

