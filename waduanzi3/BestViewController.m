//
//  ChoiceViewController.m
//  waduanzi3
//
//  Created by chendong on 13-6-17.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "BestViewController.h"
#import <RestKit/RestKit.h>
#import "CDDefine.h"
#import "CDPost.h"
#import "CDRestClient.h"
#import "WCAlertView.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "CDDataCache.h"
#import "WBSuccessNoticeView+WaduanziMethod.h"

@interface BestViewController ()

@end

@implementation BestViewController

- (void)viewDidLoad
{
    _page = FIRST_PAGE_ID;
    _hours = 24;
    
    // Do any additional setup after loading the view.
    self.title = @"精华";
    
    _statuses = [[CDDataCache shareCache] fetchBestPosts];
    
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
    return @"/post/best";
}

- (NSString *) moreStatusesRestPath
{
    return @"/post/best";
}

- (NSDictionary *) latestStatusesParameters
{
    NSString *channel_id = [NSString stringWithFormat:@"%d", _channelID];
    NSString *page_id = [NSString stringWithFormat:@"%d", FIRST_PAGE_ID];
    NSString *inhours = [NSString stringWithFormat:@"%d", _hours];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:channel_id forKey:@"channel_id"];
    [params setObject:page_id forKey:@"page"];
    [params setObject:inhours forKey:@"hours"];
    
    return [CDRestClient requestParams:params];
}

- (NSDictionary *) moreStatusesParameters
{
    NSLog(@"page id: %d", _page);
    NSString *channel_id = [NSString stringWithFormat:@"%d", _channelID];
    NSString *page_id = [NSString stringWithFormat:@"%d", _page];
    NSString *inhours = [NSString stringWithFormat:@"%d", _hours];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:channel_id forKey:@"channel_id"];
    [params setObject:page_id forKey:@"page"];
    [params setObject:inhours forKey:@"hours"];
    
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
        noticeTitle = [NSString stringWithFormat:@"挖到%d条精品段子", resultCount];
        
        [_statuses removeAllObjects];
        _statuses = [NSMutableArray arrayWithArray:statuses];
        [self.tableView reloadData];
        
        _page = FIRST_PAGE_ID;
        _page++;
        [[CDDataCache shareCache] cacheBestPosts:_statuses];
    }
    else {
        NSLog(@"没有更多内容了");
        noticeTitle = @"没有挖到精品段子了";
    }
    
    _noticeView = [WBSuccessNoticeView showSuccessNoticeView:self.view title:noticeTitle sticky:NO delay:2.0f dismissedBlock:nil];
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
        
//        NSInteger currentCount = [_statuses count];
//        NSMutableArray *insertIndexPaths = [NSMutableArray array];
//        for (int i=0; i<statuses.count; i++) {
//            [insertIndexPaths addObject:[NSIndexPath indexPathForRow:currentCount+i inSection:0]];
//        }
//
//        [self.tableView beginUpdates];
//        [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
//        [self.tableView endUpdates];
        
        _page++;
    }
}

//- (void) moreStatusesFailed:(RKObjectRequestOperation *)operation error:(NSError *)error
//{
//    NSLog(@"TimelineViewController moreStatusesFailed:error:");
//}

@end
