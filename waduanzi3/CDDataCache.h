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

- (void) cacheAppFirstBootTime;
- (double) fetchAppFirstBootTime;

- (BOOL) cacheFocusPosts:(NSMutableArray *)posts;
- (NSMutableArray *)fetchFocusPosts;
- (void) removeFocusPosts;

- (BOOL) cacheTimelinePosts:(NSMutableArray *)posts withMediaType:(CD_MEDIA_TYPE)media_type;
- (NSMutableArray *)fetchTimelinePostsWithMediaType:(CD_MEDIA_TYPE)media_type;
- (void) removeTimelinePostsWithMediaType:(CD_MEDIA_TYPE)media_type;

- (BOOL) cacheHistoryPosts:(NSMutableArray *)posts withMediaType:(CD_MEDIA_TYPE)media_type;
- (NSMutableArray *)fetchHistoryPostsWithMediaType:(CD_MEDIA_TYPE)media_type;
- (void) removeHistoryPostsWithMediaType:(CD_MEDIA_TYPE)media_type;

- (BOOL) cacheBestPosts:(NSMutableArray *)posts withMediaType:(CD_MEDIA_TYPE)media_type;
- (NSMutableArray *)fetchBestPostsWithMediaType:(CD_MEDIA_TYPE)media_type;
- (void) removeBestPostsWithMediaType:(CD_MEDIA_TYPE)media_type;


- (BOOL) cacheFavoritePosts:(NSMutableArray *)posts;
- (NSMutableArray *)fetchFavoritePosts;
- (void) removeFavoritePosts;

- (BOOL) cacheMySharePosts:(NSMutableArray *)posts;
- (NSMutableArray *)fetchMySharePosts;
- (void) removeMySharePosts;

- (BOOL) cacheMyFeedbackPosts:(NSMutableArray *)posts;
- (NSMutableArray *)fetchMyFeedbackPosts;
- (void) removeMyFeedbackPosts;

- (BOOL) cachePostsByMediaType:(NSMutableArray *)posts mediaType:(NSInteger)media_type;
- (NSMutableArray *)fetchPostsByMediaType:(NSInteger) media_type;
- (void) removePostsByMediaType:(NSInteger) media_type;

- (BOOL) cacheLoginedUser:(CDUser *)user;
- (CDUser *) fetchLoginedUser;
- (void) removeLoginedUserCache;

- (BOOL) cachePostLikeState:(BOOL)state forPostID:(NSInteger)postid;
- (BOOL) fetchPostLikeState:(NSInteger)postid;

- (BOOL) cachePostFavoriteState:(BOOL)state forPostID:(NSInteger)postid forUserID:(NSInteger)userid;
- (BOOL) fetchPostFavoriteState:(NSInteger)postid forUserID:(NSInteger)userid;

- (BOOL) cacheLoginUserName:(NSString *)username;
- (NSString *) fetchLoginUserName;

+ (NSString *) cacheFilesTotalSize;
+ (BOOL) clearAllCacheFiles;
+ (BOOL) clearCacheFilesBeforeDays:(CGFloat)days;

@end
