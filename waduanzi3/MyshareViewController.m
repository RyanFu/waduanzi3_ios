//
//  MyshareViewController.m
//  waduanzi3
//
//  Created by chendong on 13-6-23.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "MyshareViewController.h"
#import <RestKit/RestKit.h>
#import "CDDefine.h"
#import "CDPost.h"
#import "CDRestClient.h"
#import "WCAlertView.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "CDDataCache.h"

@interface MyshareViewController ()

@end

@implementation MyshareViewController

- (id) initWithUserID:(NSInteger)user_id
{
    self = [super init];
    if (self) {
        _userID = user_id;
        _page = FIRST_PAGE_ID;
    }
    return self;
}

- (void)viewDidLoad
{
	// Do any additional setup after loading the view.
    self.title = @"我发表的";
    _statuses = [[CDDataCache shareCache] fetchMySharePosts];
    
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
    return @"/post/myshare";
}

- (NSString *) moreStatusesRestPath
{
    return @"/post/myshare";
}

- (NSDictionary *) latestStatusesParameters
{
    NSString *channel_id = [NSString stringWithFormat:@"%d", _channelID];
    NSString *user_id = [NSString stringWithFormat:@"%d", _userID];
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
    NSString *user_id = [NSString stringWithFormat:@"%d", _userID];
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
    NSLog(@"MyshareViewController latestStatusesSuccess:mappingResult:");
    
    NSArray* statuses = (NSArray *)[result array];
    NSInteger resultCount = [statuses count];
    NSLog(@"count: %d", resultCount);
    if (resultCount > 0) {
        [_statuses removeAllObjects];
        _statuses = [NSMutableArray arrayWithArray:statuses];
        [self.tableView reloadData];
        
        _page = FIRST_PAGE_ID;
        _page++;
        [[CDDataCache shareCache] cacheMySharePosts:_statuses];
    }
    else {
        NSLog(@"没有更多内容了");
    }
}

//- (void) latestStatusesFailed:(RKObjectRequestOperation *)operation error:(NSError *)error
//{
//    NSLog(@"TimelineViewController latestStatusesFailed:error:");
//}

#pragma mark - loadMoreStatuses
- (void)moreStatusesSuccess:(RKObjectRequestOperation *)operation mappingResult:(RKMappingResult *)result
{
    NSLog(@"MyshareViewController moreStatusesSuccess:mappingResult:");
    
    if (result.count > 0) {
        NSArray* statuses = (NSArray *)[result array];
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
