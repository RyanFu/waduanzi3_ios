//
//  PostListViewController.h
//  waduanzi3
//
//  Created by chendong on 13-3-4.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "IIViewDeckController.h"
#import "CDPostTableViewCell.h"

@interface PostListViewController : UIViewController <CDPostTableViewCellDelegate, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, IIViewDeckControllerDelegate>
{
    NSMutableArray *_statuses;
    NSMutableDictionary *_parameters;
    NSString *_restPath;
    NSInteger _channelID;
    NSInteger _mediaType;
    NSInteger _lasttime;
    NSInteger _maxtime;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *adView;

- (void) initData;
- (NSDictionary *) latestStatusesParameters;
- (NSDictionary *) moreStatusesParameters;
- (void)loadLatestStatuses;
- (void)loadMoreStatuses;
- (NSString *) latestStatusesRestPath;
- (NSString *) moreStatusesRestPath;

- (void) latestStatusesSuccess:(RKObjectRequestOperation *)operation mappingResult:(RKMappingResult *)result;
- (void) latestStatusesFailed:(RKObjectRequestOperation *)operation error:(NSError *)error;
- (void) moreStatusesSuccess:(RKObjectRequestOperation *)operation mappingResult:(RKMappingResult *)result;
- (void) moreStatusesFailed:(RKObjectRequestOperation *)operation error:(NSError *)error;

@end
