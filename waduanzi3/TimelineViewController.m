//
//  TimelineViewController.m
//  waduanzi3
//
//  Created by chendong on 13-6-17.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "TimelineViewController.h"
#import <RestKit/RestKit.h>
#import "CDDefine.h"
#import "CDPost.h"
#import "CDRestClient.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "CDDataCache.h"
#import "WBSuccessNoticeView+WaduanziMethod.h"

@interface TimelineViewController ()

@end

@implementation TimelineViewController


- (void)viewDidLoad
{
    // Do any additional setup after loading the view.
//    self.title = @"每日更新";
    
    _statuses = [[CDDataCache shareCache] fetchTimelinePostsWithMediaType:_mediaType withImageFilter:self.imageHeightFilter];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}



#pragma mark - inherit parent interface required method

- (NSString *) latestStatusesRestPath
{
    return @"/post/timeline";
}

- (NSString *) moreStatusesRestPath
{
    return @"/post/timeline";
}

- (NSDictionary *) latestStatusesParameters
{
    if (_statuses.count > 0) {
        CDPost *firstPost = [_statuses objectAtIndex:0];
        _lasttime = [firstPost.create_time integerValue];
    }
    else
        _lasttime = 0;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *channel_id = [NSString stringWithFormat:@"%d", _channelID];
    [params setObject:channel_id forKey:@"channel_id"];
    NSString *last_time = [NSString stringWithFormat:@"%d", _lasttime];
    [params setObject:last_time forKey:@"lasttime"];
    NSString *imageFilter = [NSString stringWithFormat:@"%d", self.imageHeightFilter];
    [params setObject:imageFilter forKey:@"image_filter"];

    NSString *mediaTypes = (_mediaType == MEDIA_TYPE_MIXED) ? SUPPORT_MEDIA_TYPES : [NSString stringWithFormat:@"%d", _mediaType];
    [params setObject:mediaTypes forKey:@"media_type"];

    return [CDRestClient requestParams:params];
}

- (NSDictionary *) moreStatusesParameters
{
    if (_statuses.count > 0) {
        CDPost *lastPost = [_statuses lastObject];
        _maxtime = [lastPost.create_time integerValue];
    }
    else
        _maxtime = 0;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *channel_id = [NSString stringWithFormat:@"%d", _channelID];
    NSString *max_time = [NSString stringWithFormat:@"%d", _maxtime];
    [params setObject:channel_id forKey:@"channel_id"];
    [params setObject:max_time forKey:@"maxtime"];
    NSString *imageFilter = [NSString stringWithFormat:@"%d", self.imageHeightFilter];
    [params setObject:imageFilter forKey:@"image_filter"];

    NSString *mediaTypes = (_mediaType == MEDIA_TYPE_MIXED) ? SUPPORT_MEDIA_TYPES : [NSString stringWithFormat:@"%d", _mediaType];
    [params setObject:mediaTypes forKey:@"media_type"];

    
    return [CDRestClient requestParams:params];
}


#pragma mark - loadLatestStatuses
- (void)latestStatusesSuccess:(RKObjectRequestOperation *)operation mappingResult:(RKMappingResult *)result
{
    CDLog(@"TimelineViewController latestStatusesSuccess:mappingResult:");
    
    if (self.navigationController.tabBarController != nil) {
        self.navigationController.tabBarItem.badgeValue = nil;
    }
    
    NSArray* statuses = (NSArray *)[result array];
    NSInteger resultCount = [statuses count];
    CDLog(@"count: %d", resultCount);
    NSString *noticeTitle;
    if (resultCount > 0) {
        noticeTitle = [NSString stringWithFormat:@"挖到%d条新段子", resultCount];
        NSArray *reverseStatuses = [[statuses reverseObjectEnumerator] allObjects];
        for (CDPost *post in reverseStatuses) {
            [_statuses insertObject:post atIndex:0];
        }
        [self subarrayWithMaxCount:POST_LIST_MAX_ROWS];
        [self.tableView reloadData];
    }
    else {
        CDLog(@"没有更多内容了");
        noticeTitle = @"暂时没有新段子了";
    }
    
    // 之所以不管有没有新段子，都重新缓存一下的原因是因为如果用户发表评论后，评论数量并没有缓存。
    if (_statuses.count > 0)
        [[CDDataCache shareCache] cacheTimelinePosts:_statuses withMediaType:_mediaType withImageFilter:self.imageHeightFilter];
    
    _noticeView = [WBSuccessNoticeView showSuccessNoticeView:self.view title:noticeTitle sticky:NO delay:1.0f dismissedBlock:nil];
}

//- (void) latestStatusesFailed:(RKObjectRequestOperation *)operation error:(NSError *)error
//{
//    NSLog(@"TimelineViewController latestStatusesFailed:error:");
//}

#pragma mark - loadMoreStatuses
- (void)moreStatusesSuccess:(RKObjectRequestOperation *)operation mappingResult:(RKMappingResult *)result
{
    CDLog(@"TimelineViewController moreStatusesSuccess:mappingResult:");

    if (result.count > 0) {
        NSArray* statuses = (NSArray *)[result array];
        [_statuses addObjectsFromArray:statuses];
        
        [self.tableView reloadData];
    }
}

//- (void) moreStatusesFailed:(RKObjectRequestOperation *)operation error:(NSError *)error
//{
//    NSLog(@"TimelineViewController moreStatusesFailed:error:");
//}

- (NSMutableArray *) fetchCachePostsWithMediaType:(CD_MEDIA_TYPE)media_type
{
    return [[CDDataCache shareCache] fetchTimelinePostsWithMediaType:_mediaType withImageFilter:self.imageHeightFilter];
}

@end
