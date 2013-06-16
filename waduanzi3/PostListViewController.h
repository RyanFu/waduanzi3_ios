//
//  PostListViewController.h
//  waduanzi3
//
//  Created by chendong on 13-3-4.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostListViewController : UIViewController <UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_statuses;
    NSMutableDictionary *_parameters;
    NSString *_restPath;
    NSInteger _channelID;
    NSInteger _lasttime;
    NSInteger _maxtime;
    NSInteger _mediaType;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *adView;

- (id) initWithChanneID:(NSInteger)channelID andMediaType:(NSInteger)mediaType;

@end
