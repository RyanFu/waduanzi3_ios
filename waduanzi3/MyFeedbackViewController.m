//
//  MyFeedbackViewController.m
//  waduanzi3
//
//  Created by chendong on 13-7-31.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "MyFeedbackViewController.h"
#import "CDDataCache.h"
#import "CDRestClient.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "WBSuccessNoticeView+WaduanziMethod.h"
#import "WBErrorNoticeView+WaduanziMethod.h"
#import "CDAppUser.h"

@interface MyFeedbackViewController ()

@end

@implementation MyFeedbackViewController

- (id)init
{
    self = [super init];
    if (self) {
        _page = FIRST_PAGE_ID;
        _requireLogined = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"我参与的";
    _statuses = [[CDDataCache shareCache] fetchMyFeedbackPosts];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDeckController:(IIViewDeckController *)viewDeckController didCloseViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated
{
    if ([CDAppUser hasLogined]) {
        if (self.forceRefresh) {
            [self.tableView triggerPullToRefresh];
            self.forceRefresh = NO;
        }
    }
    else {
        [_statuses removeAllObjects];
        [self.tableView reloadData];
        
        [WBErrorNoticeView showErrorNoticeView:self.view title:@"提示" message:@"请先登录" sticky:NO delay:2.0f dismissedBlock:nil];
    }
}


#pragma mark - override abstract methods

- (NSDictionary *) latestStatusesParameters
{
    NSString *channel_id = [NSString stringWithFormat:@"%d", _channelID];
    NSString *user_id = [NSString stringWithFormat:@"%d", [self userID]];
    NSString *page_id = [NSString stringWithFormat:@"%d", FIRST_PAGE_ID];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:channel_id forKey:@"channel_id"];
    [params setObject:user_id forKey:@"user_id"];
    [params setObject:page_id forKey:@"page"];
    
    return [CDRestClient requestParams:params];
}

- (NSDictionary *) moreStatusesParameters
{
    NSLog(@"page id: %d", _page);
    NSString *channel_id = [NSString stringWithFormat:@"%d", _channelID];
    NSString *user_id = [NSString stringWithFormat:@"%d", [self userID]];
    NSString *page_id = [NSString stringWithFormat:@"%d", _page];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:channel_id forKey:@"channel_id"];
    [params setObject:user_id forKey:@"user_id"];
    [params setObject:page_id forKey:@"page"];
    
    return [CDRestClient requestParams:params];
}

- (NSString *) latestStatusesRestPath
{
    return @"/post/feedback";
}

- (NSString *) moreStatusesRestPath
{
    return @"/post/feedback";
}


#pragma mark - loadLatestStatuses
- (void)latestStatusesSuccess:(RKObjectRequestOperation *)operation mappingResult:(RKMappingResult *)result
{
    NSLog(@"MyFeedbackViewController latestStatusesSuccess:mappingResult:");
    
    NSArray* statuses = (NSArray *)[result array];
    NSInteger resultCount = [statuses count];
    NSLog(@"count: %d", resultCount);
    if (resultCount > 0) {
        [_statuses removeAllObjects];
        _statuses = [NSMutableArray arrayWithArray:statuses];
        [self.tableView reloadData];
        
        _page = FIRST_PAGE_ID;
        _page++;
        [[CDDataCache shareCache] cacheFavoritePosts:_statuses];
    }
    else {
        NSLog(@"没有更多内容了");
        NSString *noticeTitle = @"您还没有发表过评论......";
        [WBSuccessNoticeView showSuccessNoticeView:self.view title:noticeTitle sticky:NO delay:2.0f dismissedBlock:nil];
    }
}

//- (void) latestStatusesFailed:(RKObjectRequestOperation *)operation error:(NSError *)error
//{
//    NSLog(@"TimelineViewController latestStatusesFailed:error:");
//}

#pragma mark - loadMoreStatuses
- (void)moreStatusesSuccess:(RKObjectRequestOperation *)operation mappingResult:(RKMappingResult *)result
{
    NSLog(@"MyFeedbackViewController moreStatusesSuccess:mappingResult:");
    
    NSArray* statuses = (NSArray *)[result array];
    NSInteger resultCount = [statuses count];
    NSLog(@"count: %d", resultCount);
    if (resultCount > 0) {
        [_statuses addObjectsFromArray:statuses];
        
        [self.tableView reloadData];
        
        _page++;
    }
}

@end
