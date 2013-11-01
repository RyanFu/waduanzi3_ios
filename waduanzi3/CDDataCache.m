//
//  CDDataCache.m
//  waduanzi3
//
//  Created by chendong on 13-6-23.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDDataCache.h"

@interface CDDataCache ()
- (NSString *) generateCacheID:(NSString *)key;
- (BOOL) cachePosts:(NSMutableArray *)posts cacheKey:(NSString *)key;
- (NSMutableArray *) fetchPostsByCacheKey:(NSString *)key;
- (void) removePostsCache:(NSString *)key;
@end



@implementation CDDataCache

+ (CDDataCache *)shareCache
{
    static CDDataCache *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CDDataCache alloc] init];
    });
    return instance;
}

- (void) cacheAppFirstBootTime
{
    NSString *cacheKey = [self generateCacheID:@"app_first_boot_time"];
    [USER_DEFAULTS setDouble:CFAbsoluteTimeGetCurrent() forKey:cacheKey];
}

- (double) fetchAppFirstBootTime
{
    NSString *cacheKey = [self generateCacheID:@"app_first_boot_time"];
    return [USER_DEFAULTS doubleForKey:cacheKey];
}

#pragma mark - focus

- (BOOL) cacheFocusPosts:(NSMutableArray *)posts
{
    return [self cachePosts:posts cacheKey:@"latest_focus_posts"];
}

- (NSMutableArray *)fetchFocusPosts
{
    return [self fetchPostsByCacheKey:@"latest_focus_posts"];
}

- (void) removeFocusPosts
{
    [self removePostsCache:@"latest_focus_posts"];
}

#pragma mark - timeline

- (BOOL) cacheTimelinePosts:(NSMutableArray *)posts withMediaType:(CD_MEDIA_TYPE)media_type withImageFilter:(CDImageHeightFilter)image_filter
{
    NSString *cacheKey = [NSString stringWithFormat:@"latest_funny_posts_media_type_%d_image_filter_%d", media_type, image_filter];
    return [self cachePosts:posts cacheKey:cacheKey];
}

- (NSMutableArray *)fetchTimelinePostsWithMediaType:(CD_MEDIA_TYPE)media_type withImageFilter:(CDImageHeightFilter)image_filter
{
    NSString *cacheKey = [NSString stringWithFormat:@"latest_funny_posts_media_type_%d_image_filter_%d", media_type, image_filter];
    return [self fetchPostsByCacheKey:cacheKey];
}

- (void) removeTimelinePostsWithMediaType:(CD_MEDIA_TYPE)media_type withImageFilter:(CDImageHeightFilter)image_filter
{
    NSString *cacheKey = [NSString stringWithFormat:@"latest_funny_posts_media_type_%d_image_filter_%d", media_type, image_filter];
    [self removePostsCache:cacheKey];
}


#pragma mark - history

- (BOOL) cacheHistoryPosts:(NSMutableArray *)posts withMediaType:(CD_MEDIA_TYPE)media_type withImageFilter:(CDImageHeightFilter)image_filter
{
    NSString *cacheKey = [NSString stringWithFormat:@"history_posts_media_type_%d_image_filter_%d", media_type, image_filter];
    return [self cachePosts:posts cacheKey: cacheKey];
}

- (NSMutableArray *) fetchHistoryPostsWithMediaType:(CD_MEDIA_TYPE)media_type withImageFilter:(CDImageHeightFilter)image_filter
{
    NSString *cacheKey = [NSString stringWithFormat:@"history_posts_media_type_%d_image_filter_%d", media_type, image_filter];
    return [self fetchPostsByCacheKey: cacheKey];
}

- (void) removeHistoryPostsWithMediaType:(CD_MEDIA_TYPE)media_type withImageFilter:(CDImageHeightFilter)image_filter
{
    NSString *cacheKey = [NSString stringWithFormat:@"history_posts_media_type_%d_image_filter_%d", media_type, image_filter];
    [self removePostsCache: cacheKey];
}


#pragma mark - best

- (BOOL) cacheBestPosts:(NSMutableArray *)posts withMediaType:(CD_MEDIA_TYPE)media_type withImageFilter:(CDImageHeightFilter)image_filter
{
    NSString *cacheKey = [NSString stringWithFormat:@"best_posts_media_type_%d_image_filter_%d", media_type, image_filter];
    return [self cachePosts:posts cacheKey: cacheKey];
}

- (NSMutableArray *) fetchBestPostsWithMediaType:(CD_MEDIA_TYPE)media_type withImageFilter:(CDImageHeightFilter)image_filter
{
    NSString *cacheKey = [NSString stringWithFormat:@"best_posts_media_type_%d_image_filter_%d", media_type, image_filter];
    return [self fetchPostsByCacheKey: cacheKey];
}

- (void) removeBestPostsWithMediaType:(CD_MEDIA_TYPE)media_type withImageFilter:(CDImageHeightFilter)image_filter
{
    NSString *cacheKey = [NSString stringWithFormat:@"best_posts_media_type_%d_image_filter_%d", media_type, image_filter];
    [self removePostsCache: cacheKey];
}


#pragma mark - favorite

- (BOOL) cacheFavoritePosts:(NSMutableArray *)posts
{
    return [self cachePosts:posts cacheKey:@"favorite_posts"];
}

- (NSMutableArray *) fetchFavoritePosts
{
    return [self fetchPostsByCacheKey:@"favorite_posts"];
}

- (void) removeFavoritePosts
{
    [self removePostsCache:@"favorite_posts"];
}


#pragma mark - myshare

- (BOOL) cacheMySharePosts:(NSMutableArray *)posts
{
    return [self cachePosts:posts cacheKey:@"myshare_posts"];
}

- (NSMutableArray *) fetchMySharePosts
{
    return [self fetchPostsByCacheKey:@"myshare_posts"];
}

- (void) removeMySharePosts
{
    [self removePostsCache:@"myshare_posts"];
}

#pragma mark - myfeedback

- (BOOL) cacheMyFeedbackPosts:(NSMutableArray *)posts
{
    return [self cachePosts:posts cacheKey:@"myfeedback_posts"];
}

- (NSMutableArray *) fetchMyFeedbackPosts
{
    return [self fetchPostsByCacheKey:@"myfeedback_posts"];
}

- (void) removeMyFeedbackPosts
{
    [self removePostsCache:@"myfeedback_posts"];
}


#pragma mark - mediatype posts

- (BOOL) cachePostsByMediaType:(NSMutableArray *)posts mediaType:(NSInteger)media_type
{
    NSString *key = [NSString stringWithFormat:@"media_type_%d", media_type];
    return [self cachePosts:posts cacheKey:key];
}

- (NSMutableArray *) fetchPostsByMediaType:(NSInteger)media_type
{
    NSString *key = [NSString stringWithFormat:@"media_type_%d", media_type];
    return [self fetchPostsByCacheKey:key];
}

- (void) removePostsByMediaType:(NSInteger)media_type
{
    NSString *key = [NSString stringWithFormat:@"media_type_%d", media_type];
    [self removePostsCache:key];
}

- (BOOL) cacheLoginUserName:(NSString *)username
{
    @try {
        NSString *cacheKey = [self generateCacheID:@"login_username"];
        
        if (username.length > 0)
            [USER_DEFAULTS setObject:username forKey:cacheKey];
        else
            [USER_DEFAULTS removeObjectForKey:cacheKey];
        return YES;
    }
    @catch (NSException *exception) {
        return NO;
    }
    @finally {
        ;
    }
}

- (NSString *) fetchLoginUserName
{
    NSString *cacheKey = [self generateCacheID:@"login_username"];
    return [USER_DEFAULTS stringForKey:cacheKey];
}


- (BOOL) cacheBaiduPushBindState:(BOOL)state
{
    @try {
        NSString *cacheKey = @"baidu_push_bind_state";

        [USER_DEFAULTS setBool:state forKey:cacheKey];
        return YES;
    }
    @catch (NSException *exception) {
        return NO;
    }
    @finally {
        ;
    }
}

- (BOOL) fetchBaiduPushBindState
{
    NSString *cacheKey = @"baidu_push_bind_state";
    return [USER_DEFAULTS boolForKey:cacheKey];
}

- (BOOL) cacheDeviceToken:(NSString *)token
{
    @try {
        NSString *cacheKey = @"device_push_token";
        
        [USER_DEFAULTS setObject:token forKey:cacheKey];
        return YES;
    }
    @catch (NSException *exception) {
        return NO;
    }
    @finally {
        ;
    }
}

- (NSString *) fetchDeviceToken
{
    NSString *cacheKey = @"device_push_token";
    return [USER_DEFAULTS stringForKey:cacheKey];
}


#pragma mark - cache posts to cache and fetch posts from cache

- (BOOL) cachePosts:(NSMutableArray *)posts cacheKey:(NSString *)key
{
    if ([posts count] > 0) {
        NSString *cacheKey = [self generateCacheID:key];
        NSData *archiver = [NSKeyedArchiver archivedDataWithRootObject:posts];
        [USER_DEFAULTS setObject:archiver forKey:cacheKey];
    }
    return YES;
}

- (NSMutableArray *) fetchPostsByCacheKey:(NSString *)key
{
    NSString *cacheKey = [self generateCacheID:key];
    NSData *data = [USER_DEFAULTS objectForKey:cacheKey];
    
    if (data == nil)
        return [NSMutableArray array];
    
    NSMutableArray *posts = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return posts;
}

- (void) removePostsCache:(NSString *)key
{
    NSString *cacheKey = [self generateCacheID:key];
    [USER_DEFAULTS removeObjectForKey:cacheKey];
}


- (NSString *) generateCacheID:(NSString *)key
{
    return [NSString stringWithFormat:@"app_ver_%@_%@", APP_VERSION, key];
}


#pragma mark - user cache and fetch

- (BOOL) cacheLoginedUser:(CDUser *)user
{
    if (user == nil) return NO;
    
    NSString *cacheKey = [self generateCacheID:@"logined_user"];
    NSData *archiver = [NSKeyedArchiver archivedDataWithRootObject:user];
    [USER_DEFAULTS setObject:archiver forKey:cacheKey];
    return YES;
}

- (CDUser *) fetchLoginedUser
{
    NSString *cacheKey = [self generateCacheID:@"logined_user"];
    NSData *data = [USER_DEFAULTS objectForKey:cacheKey];
    if (data == nil)
        return nil;
    else
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (void) removeLoginedUserCache
{
    NSString *cacheKey = [self generateCacheID:@"logined_user"];
    [USER_DEFAULTS removeObjectForKey:cacheKey];
}

- (BOOL) cachePostLikeState:(BOOL)state forPostID:(NSInteger)postid
{
    NSString *key = [NSString stringWithFormat:@"post_like_state_%d", postid];
    NSString *cacheKey = [self generateCacheID:key];
    [USER_DEFAULTS setBool:state forKey:cacheKey];
    return YES;
}

- (BOOL) fetchPostLikeState:(NSInteger)postid
{
    NSString *key = [NSString stringWithFormat:@"post_like_state_%d", postid];
    NSString *cacheKey = [self generateCacheID:key];
    return [USER_DEFAULTS boolForKey:cacheKey];
}

- (BOOL) cachePostFavoriteState:(BOOL)state forPostID:(NSInteger)postid forUserID:(NSInteger)userid
{
    NSString *key = [NSString stringWithFormat:@"post_favorite_state_%d_%d", postid, userid];
    NSString *cacheKey = [self generateCacheID:key];
    [USER_DEFAULTS setBool:state forKey:cacheKey];
    return YES;
}

- (BOOL) fetchPostFavoriteState:(NSInteger)postid forUserID:(NSInteger)userid
{
    NSString *key = [NSString stringWithFormat:@"post_favorite_state_%d_%d", postid, userid];
    NSString *cacheKey = [self generateCacheID:key];
    return [USER_DEFAULTS boolForKey:cacheKey];
}



+ (NSString *) cacheFilesTotalSize
{
    NSString  *_cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSFileManager  *_manager = [[NSFileManager alloc] init];
    NSArray  *_cacheFileList = [ _manager subpathsAtPath:_cacheDirectory];
//    CDLog(@"cache file list: %@", _cacheFileList);
    
    if (_cacheFileList == nil) {
        CDLog(@"an error occured.");
        return @"0B";
    }
    
    unsigned long long int _cacheFolderSize = 0;
    NSString *_cacheFilePath;
    NSEnumerator *_cacheEnumerator = [_cacheFileList objectEnumerator];
    while (_cacheFilePath = [_cacheEnumerator nextObject]) {
        NSString *fileAbsolutePath = [_cacheDirectory stringByAppendingPathComponent:_cacheFilePath];
        
        if ([_manager fileExistsAtPath:fileAbsolutePath] && [_manager isReadableFileAtPath:fileAbsolutePath]) {
            NSDictionary *_cacheFileAttributes = [_manager attributesOfItemAtPath:fileAbsolutePath error:nil];
            _cacheFolderSize += [_cacheFileAttributes fileSize];
        }
    }
    
    NSString *sizeString;
    if (_cacheFolderSize < 1000)
        sizeString = [NSString stringWithFormat:@"%lluB", _cacheFolderSize];
    else if (_cacheFolderSize < 1000000)
        sizeString = [NSString stringWithFormat:@"%.2fK", _cacheFolderSize/1024.0];
    else
        sizeString = [NSString stringWithFormat:@"%.2fM", _cacheFolderSize/1024.0/1024.0];
    
    return sizeString;
}

+ (BOOL) clearAllCacheFiles
{
    NSString  *_cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSFileManager  *_manager = [[NSFileManager alloc] init];
    NSArray *_cacheFileList = [ _manager contentsOfDirectoryAtPath:_cacheDirectory error:nil];
//    CDLog(@"cache file list: %@", _cacheFileList);
    
    if (_cacheFileList == nil) {
        CDLog(@"an error occured.");
        return NO;
    }
    else if (_cacheFileList.count == 0)
        return YES;

    NSEnumerator *_cacheEnumerator = [_cacheFileList objectEnumerator];
    
    NSString *_cacheFilePath;
    while (_cacheFilePath = [_cacheEnumerator nextObject]) {
        @try {
            NSString *fileAbsolutePath = [_cacheDirectory stringByAppendingPathComponent:_cacheFilePath];
            if ([_manager fileExistsAtPath:fileAbsolutePath] && [_manager isDeletableFileAtPath:fileAbsolutePath]) {
                NSError *error;
                [_manager removeItemAtPath:fileAbsolutePath error:&error];
            }
        }
        @catch (NSException *exception) {
            CDLog(@"remove caches exception: %@", exception.reason);
            return NO;
        }
        @finally {
            ;
        }
    }
    
    return YES;
}

+ (BOOL) clearCacheFilesBeforeDays:(CGFloat)days
{
    NSString  *_cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSFileManager  *_manager = [[NSFileManager alloc] init];
    NSArray *_cacheFileList = [ _manager contentsOfDirectoryAtPath:_cacheDirectory error:nil];
//    CDLog(@"cache file list: %@", _cacheFileList);
    
    if (_cacheFileList == nil) {
        CDLog(@"an error occured.");
        return NO;
    }
    else if (_cacheFileList.count == 0)
        return YES;
    
    NSEnumerator *_cacheEnumerator = [_cacheFileList objectEnumerator];
    
    NSString *_cacheFilePath;
    while (_cacheFilePath = [_cacheEnumerator nextObject]) {
        @try {
            NSString *fileAbsolutePath = [_cacheDirectory stringByAppendingPathComponent:_cacheFilePath];
            NSDictionary *_cacheFileAttributes = [_manager attributesOfItemAtPath:fileAbsolutePath error:nil];
            NSDate *fileCreateDate = [_cacheFileAttributes fileCreationDate];

            if (([[NSDate date] timeIntervalSince1970] - [fileCreateDate timeIntervalSince1970]) < 3600 * 24 * days)
                continue;
            
            if ([_manager fileExistsAtPath:fileAbsolutePath] && [_manager isDeletableFileAtPath:fileAbsolutePath]) {
                NSError *error;
                [_manager removeItemAtPath:fileAbsolutePath error:&error];
            }
        }
        @catch (NSException *exception) {
            CDLog(@"remove caches exception: %@", exception.reason);
            return NO;
        }
        @finally {
            ;
        }
    }
    
    return YES;
}

@end
