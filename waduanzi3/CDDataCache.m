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

static CDDataCache *instance;

@implementation CDDataCache

+ (CDDataCache *)shareCache
{
    @synchronized(self) {
        if (instance == nil) {
            instance = [[super alloc] init];
        }
    }
    return instance;
}


#pragma mark - timeline

- (BOOL) cacheTimelinePosts:(NSMutableArray *)posts
{
    return [self cachePosts:posts cacheKey:@"latest_posts"];
}

- (NSMutableArray *)fetchTimelinePosts
{
    return [self fetchPostsByCacheKey:@"latest_posts"];
}

- (void) removeTimelinePosts
{
    [self removePostsCache:@"latest_posts"];
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




#pragma mark - cache posts to cache and fetch posts from cache

- (BOOL) cachePosts:(NSMutableArray *)posts cacheKey:(NSString *)key
{
    if ([posts count] > 0) {
        NSString *cacheKey = [self generateCacheID:key];
        NSData *archiver = [NSKeyedArchiver archivedDataWithRootObject:posts];
        [[NSUserDefaults standardUserDefaults] setObject:archiver forKey:cacheKey];
    }
    return YES;
}

- (NSMutableArray *) fetchPostsByCacheKey:(NSString *)key
{
    NSString *cacheKey = [self generateCacheID:key];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:cacheKey];
    
    if (data == nil)
        return [NSMutableArray array];
    
    NSMutableArray *posts = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return posts;
}

- (void) removePostsCache:(NSString *)key
{
    NSString *cacheKey = [self generateCacheID:key];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:cacheKey];
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
    [[NSUserDefaults standardUserDefaults] setObject:archiver forKey:cacheKey];
    return YES;
}

- (CDUser *) fetchLoginedUser
{
    NSString *cacheKey = [self generateCacheID:@"logined_user"];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:cacheKey];
    if (data == nil)
        return nil;
    else
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
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