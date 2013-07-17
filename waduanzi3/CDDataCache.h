//
//  CDDataCache.h
//  waduanzi3
//
//  Created by chendong on 13-6-23.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CDUser;

@interface CDDataCache : NSObject

+ (CDDataCache *) shareCache;

- (BOOL) cacheTimelinePosts:(NSMutableArray *)posts;
- (NSMutableArray *)fetchTimelinePosts;
- (void) removeTimelinePosts;

- (BOOL) cacheHistoryPosts:(NSMutableArray *)posts;
- (NSMutableArray *)fetchHistoryPosts;
- (void) removeHistoryPosts;

- (BOOL) cacheBestPosts:(NSMutableArray *)posts;
- (NSMutableArray *)fetchBestPosts;
- (void) removeBestPosts;


- (BOOL) cacheFavoritePosts:(NSMutableArray *)posts;
- (NSMutableArray *)fetchFavoritePosts;
- (void) removeFavoritePosts;

- (BOOL) cacheMySharePosts:(NSMutableArray *)posts;
- (NSMutableArray *)fetchMySharePosts;
- (void) removeMySharePosts;

- (BOOL) cachePostsByMediaType:(NSMutableArray *)posts mediaType:(NSInteger)media_type;
- (NSMutableArray *)fetchPostsByMediaType:(NSInteger) media_type;
- (void) removePostsByMediaType:(NSInteger) media_type;


- (BOOL) cacheLoginedUser:(CDUser *)user;
- (CDUser *) fetchLoginedUser;
- (void) removeLoginedUserCache;

+ (NSString *) cacheFilesTotalSize;
+ (BOOL) clearAllCacheFiles;

@end
