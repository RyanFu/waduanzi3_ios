//
//  MediaTypeViewController.m
//  waduanzi3
//
//  Created by chendong on 13-6-17.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "MediaTypeViewController.h"
#import <RestKit/RestKit.h>
#import "CDDefine.h"
#import "CDPost.h"
#import "CDRestClient.h"
#import "WCAlertView.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "CDDataCache.h"
#import "WBSuccessNoticeView+WaduanziMethod.h"

@interface MediaTypeViewController ()

@end

@implementation MediaTypeViewController

- (id) initWithMediaType:(NSInteger) media_type
{
    NSLog(@"method: MediaTypeViewController init");
    
    self = [super init];
    if (self) {
        _mediaType = media_type;
    }
    return self;
}

- (void)viewDidLoad
{
	// Do any additional setup after loading the view.
    _statuses = [[CDDataCache shareCache] fetchPostsByMediaType:_mediaType];
    
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
    
    NSString *channel_id = [NSString stringWithFormat:@"%d", _channelID];
    NSString *media_type = [NSString stringWithFormat:@"%d", _mediaType];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:channel_id forKey:@"channel_id"];
    [params setObject:media_type forKey:@"media_type"];
    
    NSString *last_time = [NSString stringWithFormat:@"%d", _lasttime];
    [params setObject:last_time forKey:@"lasttime"];
    
    return [CDRestClient requestParams:params];
}

- (NSDictionary *) moreStatusesParameters
{
    if (_statuses.count > 0) {
        CDPost *lastPost = [_statuses lastObject];
        _maxtime = [lastPost.create_time integerValue];
    }
    
    NSString *channel_id = [NSString stringWithFormat:@"%d", _channelID];
    NSString *media_type = [NSString stringWithFormat:@"%d", _mediaType];
    NSString *max_time = [NSString stringWithFormat:@"%d", _maxtime];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:channel_id forKey:@"channel_id"];
    [params setObject:media_type forKey:@"media_type"];
    [params setObject:max_time forKey:@"maxtime"];
    
    return [CDRestClient requestParams:params];
}


#pragma mark - loadLatestStatuses
- (void)latestStatusesSuccess:(RKObjectRequestOperation *)operation mappingResult:(RKMappingResult *)result
{
    NSLog(@"TimelineViewController latestStatusesSuccess:mappingResult:");
    
    NSArray* statuses = (NSArray *)[result array];
    NSInteger resultCount = [statuses count];
    NSLog(@"count: %d", resultCount);
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
        NSLog(@"没有更多内容了");
        noticeTitle = @"暂时没有新段子了";
    }
    
    // 之所以不管有没有新段子，都重新缓存一下的原因是因为如果用户发表评论后，评论数量并没有缓存。
    if (_statuses.count > 0)
        [[CDDataCache shareCache] cachePostsByMediaType:_statuses mediaType:_mediaType];
    
    _noticeView = [WBSuccessNoticeView showSuccessNoticeView:self.view title:noticeTitle sticky:NO delay:1.0f dismissedBlock:nil];

}

//- (void) latestStatusesFailed:(RKObjectRequestOperation *)operation error:(NSError *)error
//{
//    NSLog(@"TimelineViewController latestStatusesFailed:error:");
//}

#pragma mark - loadMoreStatuses
- (void)moreStatusesSuccess:(RKObjectRequestOperation *)operation mappingResult:(RKMappingResult *)result
{
    NSLog(@"TimelineViewController moreStatusesSuccess:mappingResult:");
    
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
@end
