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
#import "WCAlertView.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "CDDataCache.h"

@interface HistoryViewController ()
- (void) setupTitle;
@end

@implementation HistoryViewController

- (void)viewDidLoad
{
    // Do any additional setup after loading the view.
    self.title = @"穿越";
    
    _statuses = [[CDDataCache shareCache] fetchHistoryPosts];
    [self setupTitle];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
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
        NSString *textDate = [dateFormatter stringFromDate:date];
        self.navigationItem.title = [@"穿越到" stringByAppendingString:textDate];
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
    NSString *channel_id = [NSString stringWithFormat:@"%d", _channelID];
    NSString *media_type = [NSString stringWithFormat:@"%d", _mediaType];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:channel_id forKey:@"channel_id"];
    [params setObject:media_type forKey:@"media_type"];
    
    return [CDRestClient requestParams:params];
}

- (NSDictionary *) moreStatusesParameters
{
    NSString *channel_id = [NSString stringWithFormat:@"%d", _channelID];
    NSString *media_type = [NSString stringWithFormat:@"%d", _mediaType];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:channel_id forKey:@"channel_id"];
    [params setObject:media_type forKey:@"media_type"];
    
    return [CDRestClient requestParams:params];
}

#pragma mark - loadLatestStatuses
- (void)latestStatusesSuccess:(RKObjectRequestOperation *)operation mappingResult:(RKMappingResult *)result
{
    NSLog(@"HistoryViewController latestStatusesSuccess:mappingResult:");
    
    NSArray* statuses = (NSArray *)[result array];
    NSInteger resultCount = [statuses count];
    NSLog(@"count: %d", resultCount);
    if (resultCount > 0) {
        [_statuses removeAllObjects];
        _statuses = [NSMutableArray arrayWithArray:statuses];
        [self.tableView reloadData];
        
        [[CDDataCache shareCache] cacheHistoryPosts:_statuses];
        [self setupTitle];
    }
    else {
        NSLog(@"没有更多内容了");
    }
}

- (void) latestStatusesFailed:(RKObjectRequestOperation *)operation error:(NSError *)error
{
    NSLog(@"HistoryViewController latestStatusesFailed:error:");
    self.navigationItem.title = @"穿越失败了";
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
