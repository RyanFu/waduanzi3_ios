//
//  PostListViewController.h
//  waduanzi3
//
//  Created by chendong on 13-3-4.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <StoreKit/SKStoreProductViewController.h>
#import "IIViewDeckController.h"
#import "CDPostTableViewCell.h"
#import "CDAdvertTableViewCell.h"
#import "WBNoticeView.h"
#import "UMUFPHandleView.h"
#import "CDViewController.h"

@interface PostListViewController : CDViewController <CDPostTableViewCellDelegate, CDAdvertTableViewCellDelegate, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, IIViewDeckControllerDelegate, UMUFPHandleViewDelegate, SKStoreProductViewControllerDelegate>
{
    NSMutableArray *_statuses;
    NSMutableDictionary *_parameters;
    NSString *_restPath;
    CD_CHANNEL _channelID;
    CD_MEDIA_TYPE _mediaType;
    CDImageHeightFilter _imageHeightFilter;
    NSInteger _lasttime;
    NSInteger _maxtime;
    BOOL _requireLogined;
    CGFloat detailFontSize;
    WBNoticeView *_noticeView;
    UMUFPHandleView *_mHandleView;
    NSCache *_cellCache;
}

@property (nonatomic, assign) CD_CHANNEL channelID;
@property (nonatomic, assign) CD_MEDIA_TYPE mediaType;
@property (nonatomic, assign) CDImageHeightFilter imageHeightFilter;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *adView;
@property (nonatomic, assign) BOOL forceRefresh;
@property (nonatomic, strong) NSMutableArray *statuses;
@property (nonatomic, assign) AFNetworkReachabilityStatus networkStatus;

- (NSUInteger) userID;
- (void) subarrayWithMaxCount:(NSUInteger)count;
- (void) refreshLatestPosts;

- (id) initWithMediaType:(NSInteger) media_type;
- (void) initData;
- (NSDictionary *) latestStatusesParameters;
- (NSDictionary *) moreStatusesParameters;
- (void)loadLatestStatuses;
- (void)loadMoreStatuses;
- (NSString *) latestStatusesRestPath;
- (NSString *) moreStatusesRestPath;
- (BOOL) networkStatusChanged;
- (BOOL) textFontSizeChanged;

- (void) latestStatusesSuccess:(RKObjectRequestOperation *)operation mappingResult:(RKMappingResult *)result;
- (void) latestStatusesFailed:(RKObjectRequestOperation *)operation error:(NSError *)error;
- (void) moreStatusesSuccess:(RKObjectRequestOperation *)operation mappingResult:(RKMappingResult *)result;
- (void) moreStatusesFailed:(RKObjectRequestOperation *)operation error:(NSError *)error;

@end
