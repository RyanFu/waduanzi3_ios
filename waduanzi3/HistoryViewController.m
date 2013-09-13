//
//  HistoryViewController.m
//  waduanzi3
//
//  Created by chendong on 13-6-17.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "HistoryViewController.h"
#import <RestKit/RestKit.h>
#import "CDDefine.h"
#import "CDPost.h"
#import "CDRestClient.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "CDDataCache.h"
#import "WBErrorNoticeView+WaduanziMethod.h"
#import "WBSuccessNoticeView+WaduanziMethod.h"

@interface HistoryViewController ()
- (void) setupTitle;
@end

@implementation HistoryViewController

- (void)viewDidLoad
{
    // Do any additional setup after loading the view.
    self.title = @"随机穿越";
    
    _statuses = [[CDDataCache shareCache] fetchHistoryPosts];
    [self setupTitle];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void) viewDeckController:(IIViewDeckController *)viewDeckController didCloseViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated
{
    if (self.forceRefresh) {
        [self.tableView triggerPullToRefresh];
        self.forceRefresh = NO;
    }
}

- (void) setupTitle
{
    if (_statuses.count == 0)
        self.navigationItem.title = @"穿越";
    else {
        CDPost *firstPost = [_statuses objectAtIndex:0];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[firstPost.create_time doubleValue]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        self.navigationItem.title = [dateFormatter stringFromDate:date];
    }
}

- (void) setupTableViewInfiniteScrollView
{
    // disabled TableViewInfiniteScrollView
}

#pragma mark - inherit parent interface required method

- (NSString *) latestStatusesRestPath
{
    return @"/post/history";
}

- (NSString *) moreStatusesRestPath
{
    return @"/post/history";
}

- (NSDictionary *) latestStatusesParameters
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *channel_id = [NSString stringWithFormat:@"%d", _channelID];
    [params setObject:channel_id forKey:@"channel_id"];
    [params setObject:SUPPORT_MEDIA_TYPES forKey:@"media_type"];
    
    return [CDRestClient requestParams:params];
}

- (NSDictionary *) moreStatusesParameters
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *channel_id = [NSString stringWithFormat:@"%d", _channelID];
    [params setObject:channel_id forKey:@"channel_id"];
    [params setObject:SUPPORT_MEDIA_TYPES forKey:@"media_type"];
    
    return [CDRestClient requestParams:params];
}

#pragma mark - loadLatestStatuses
- (void)latestStatusesSuccess:(RKObjectRequestOperation *)operation mappingResult:(RKMappingResult *)result
{
    NSLog(@"HistoryViewController latestStatusesSuccess:mappingResult:");
    
    NSArray* statuses = (NSArray *)[result array];
    NSInteger resultCount = [statuses count];
    NSLog(@"count: %d", resultCount);
    NSString *noticeTitle;
    if (resultCount > 0) {
        [_statuses removeAllObjects];
        _statuses = [NSMutableArray arrayWithArray:statuses];
        [self.tableView reloadData];
        
        [[CDDataCache shareCache] cacheHistoryPosts:_statuses];

        CDPost *firstPost = [_statuses objectAtIndex:0];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[firstPost.create_time doubleValue]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        self.navigationItem.title = [dateFormatter stringFromDate:date];
        noticeTitle = [NSString stringWithFormat:@"穿越到%@", [dateFormatter stringFromDate:date]];
    }
    else {
        NSLog(@"没有更多内容了");
        noticeTitle = @"穿越错了时间，再穿一次吧";
    }
    
    _noticeView = [WBSuccessNoticeView showSuccessNoticeView:self.view title:noticeTitle sticky:NO delay:1.0f dismissedBlock:nil];
}

- (void) latestStatusesFailed:(RKObjectRequestOperation *)operation error:(NSError *)error
{
    NSLog(@"HistoryViewController latestStatusesFailed:error:");
    
    NSString *noticeMessage = @"穿越失败了";
    if (error.code == kCFURLErrorTimedOut)
        noticeMessage = @"网络超时";
    _noticeView = [WBErrorNoticeView showErrorNoticeView:self.view title:@"提示" message:noticeMessage sticky:NO delay:1.0f dismissedBlock:nil];
    
}

//#pragma mark - loadMoreStatuses
//- (void)moreStatusesSuccess:(RKObjectRequestOperation *)operation mappingResult:(RKMappingResult *)result
//{
//    NSLog(@"TimelineViewController moreStatusesSuccess:mappingResult:");
//    
//    if (result.count > 0) {
//        NSArray* statuses = (NSArray *)[result array];
//        NSInteger currentCount = [_statuses count];
//        [_statuses addObjectsFromArray:statuses];
//        
//        NSMutableArray *insertIndexPaths = [NSMutableArray array];
//        for (int i=0; i<statuses.count; i++) {
//            [insertIndexPaths addObject:[NSIndexPath indexPathForRow:currentCount+i inSection:0]];
//        }
//        
//        [self.tableView beginUpdates];
//        [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
//        [self.tableView endUpdates];
//    }
//}

//- (void) moreStatusesFailed:(RKObjectRequestOperation *)operation error:(NSError *)error
//{
//    NSLog(@"TimelineViewController moreStatusesFailed:error:");
//}
@end
