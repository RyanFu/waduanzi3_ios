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

- (BOOL) cacheTimelinePosts:(NSMutableArray *)posts
{
    return [self cachePosts:posts cacheKey:@"latest_funny_posts"];
}

- (NSMutableArray *)fetchTimelinePosts
{
    return [self fetchPostsByCacheKey:@"latest_funny_posts"];
}

- (void) removeTimelinePosts
{
    [self removePostsCache:@"latest_funny_posts"];
}


#pragma mark - history

- (BOOL) cacheHistoryPosts:(NSMutableArray *)posts
{
    return [self cachePosts:posts cacheKey:@"history_posts"];
}

- (NSMutableArray *) fetchHistoryPosts
{
    return [self fetchPostsByCacheKey:@"history_posts"];
}

- (void) removeHistoryPosts
{
    [self removePostsCache:@"history_posts"];
}


#pragma mark - best

- (BOOL) cacheBestPosts:(NSMutableArray *)posts
{
    return [self cachePosts:posts cacheKey:@"best_posts"];
}

- (NSMutableArray *) fetchBestPosts
{
    return [self fetchPostsByCacheKey:@"best_posts"];
}

- (void) removeBestPosts
{
    [self removePostsCache:@"best_posts"];
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
    NSString *cacheKey = [self generateCacheID:@"login_username"];
    
    if (username.length > 0)
        [USER_DEFAULTS setObject:username forKey:cacheKey];
    else
        [USER_DEFAULTS removeObjectForKey:cacheKey];
    return YES;
}

- (NSString *) fetchLoginUserName
{
    NSString *cacheKey = [self generateCacheID:@"login_username"];
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
    NSFileManager  *_manager = [NSFileManager defaultManager];
    NSArray *_cachePaths =  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString  *_cacheDirectory = [_cachePaths objectAtIndex:0];
    NSArray  *_cacheFileList;
    NSEnumerator *_cacheEnumerator;
    NSString *_cacheFilePath;
    unsigned long long int _cacheFolderSize = 0;
    
    _cacheFileList = [ _manager subpathsAtPath:_cacheDirectory];
    _cacheEnumerator = [_cacheFileList objectEnumerator];
    
    while (_cacheFilePath = [_cacheEnumerator nextObject]) {
        NSDictionary *_cacheFileAttributes = [_manager attributesOfItemAtPath:[_cacheDirectory stringByAppendingPathComponent:_cacheFilePath] error:nil];
        _cacheFolderSize += [_cacheFileAttributes fileSize];
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
    NSFileManager  *_manager = [NSFileManager defaultManager];
    NSArray *_cachePaths =  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString  *_cacheDirectory = [_cachePaths objectAtIndex:0];
    NSArray  *_cacheFileList;
    NSEnumerator *_cacheEnumerator;
    NSString *_cacheFilePath;
    
    _cacheFileList = [ _manager subpathsOfDirectoryAtPath:_cacheDirectory error:nil];
    _cacheEnumerator = [_cacheFileList objectEnumerator];
    
    while (_cacheFilePath = [_cacheEnumerator nextObject]) {
        NSString *fileAbsolutePath = [_cacheDirectory stringByAppendingPathComponent:_cacheFilePath];
        if ([_manager fileExistsAtPath:fileAbsolutePath]) {
            BOOL success = [_manager removeItemAtPath:fileAbsolutePath error:nil];
            if (success)
                continue;
            else {
                NSLog(@"error: %@", fileAbsolutePath);
                return NO;
            }
        }
    }
    
    return YES;
}

@end
