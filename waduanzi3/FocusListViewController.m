//
//  TimelineViewController.m
//  waduanzi3
//
//  Created by chendong on 13-6-17.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "FocusListViewController.h"
#import <RestKit/RestKit.h>
#import "CDDefine.h"
#import "CDPost.h"
#import "CDRestClient.h"
#import "WCAlertView.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "CDDataCache.h"
#import "WBSuccessNoticeView+WaduanziMethod.h"
#import "ArticleDetailViewController.h"

@interface FocusListViewController ()

@end

@implementation FocusListViewController

- (void)viewDidLoad
{
    // Do any additional setup after loading the view.
    self.title = @"挖热点";
    _channelID = CHANNEL_FOCUS;
    
    _statuses = [[CDDataCache shareCache] fetchFocusPosts];
    
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
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:channel_id forKey:@"channel_id"];
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
    NSString *max_time = [NSString stringWithFormat:@"%d", _maxtime];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:channel_id forKey:@"channel_id"];
    [params setObject:max_time forKey:@"maxtime"];
    
    return [CDRestClient requestParams:params];
}


#pragma mark - loadLatestStatuses
- (void)latestStatusesSuccess:(RKObjectRequestOperation *)operation mappingResult:(RKMappingResult *)result
{
    CDLog(@"FocusListViewController latestStatusesSuccess:mappingResult:");
    
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
        [[CDDataCache shareCache] cacheFocusPosts:_statuses];
    
    _noticeView = [WBSuccessNoticeView showSuccessNoticeView:self.view title:noticeTitle sticky:NO delay:1.0f dismissedBlock:nil];
}

//- (void) latestStatusesFailed:(RKObjectRequestOperation *)operation error:(NSError *)error
//{
//    NSLog(@"FocusListViewController latestStatusesFailed:error:");
//}

#pragma mark - loadMoreStatuses
- (void)moreStatusesSuccess:(RKObjectRequestOperation *)operation mappingResult:(RKMappingResult *)result
{
    CDLog(@"FocusListViewController moreStatusesSuccess:mappingResult:");

    if (result.count > 0) {
        NSArray* statuses = (NSArray *)[result array];
        [_statuses addObjectsFromArray:statuses];
        
        [self.tableView reloadData];
    }
}

//- (void) moreStatusesFailed:(RKObjectRequestOperation *)operation error:(NSError *)error
//{
//    NSLog(@"FocusListViewController moreStatusesFailed:error:");
//}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        CDPost *post = [_statuses objectAtIndex:indexPath.row];
        ArticleDetailViewController *detailViewController = [[ArticleDetailViewController alloc] initWithPost:post];
        CDPostTableViewCell *cell = (CDPostTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        if (cell.imageView.image != nil)
            detailViewController.smallImage = cell.imageView.image;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    @catch (NSException *exception) {
        CDLog(@"exception: %@", exception);
    }
    @finally {
        ;
    }
}

@end