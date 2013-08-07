//
//  MyFavoriteViewController.m
//  waduanzi3
//
//  Created by chendong on 13-6-23.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "MyFavoriteViewController.h"
#import <RestKit/RestKit.h>
#import "CDDefine.h"
#import "CDPost.h"
#import "CDRestClient.h"
#import "WCAlertView.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "CDDataCache.h"
#import "WBSuccessNoticeView+WaduanziMethod.h"
#import "WBErrorNoticeView+WaduanziMethod.h"
#import "CDAppUser.h"

@interface MyFavoriteViewController ()

@end

@implementation MyFavoriteViewController

- (id) init
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
    
    self.title = @"我收藏的";
    _statuses = [[CDDataCache shareCache] fetchFavoritePosts];
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


#pragma mark - inherit parent interface required method

- (NSString *) latestStatusesRestPath
{
    return @"/post/favorite";
}

- (NSString *) moreStatusesRestPath
{
    return @"/post/favorite";
}

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


#pragma mark - loadLatestStatuses
- (void)latestStatusesSuccess:(RKObjectRequestOperation *)operation mappingResult:(RKMappingResult *)result
{
    NSLog(@"MyFavoriteViewController latestStatusesSuccess:mappingResult:");
    
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
        NSString *noticeTitle = @"您的收藏夹里还没有段子哦";
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
    NSLog(@"MyFavoriteViewController moreStatusesSuccess:mappingResult:");
    
    NSArray* statuses = (NSArray *)[result array];
    NSInteger resultCount = [statuses count];
    NSLog(@"count: %d", resultCount);
    if (resultCount > 0) {
        [_statuses addObjectsFromArray:statuses];
        
        [self.tableView reloadData];
        
        _page++;
    }
}

//- (void) moreStatusesFailed:(RKObjectRequestOperation *)operation error:(NSError *)error
//{
//    NSLog(@"TimelineViewController moreStatusesFailed:error:");
//}


@end
