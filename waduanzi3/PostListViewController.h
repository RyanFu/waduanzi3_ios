//
//  PostListViewController.h
//  waduanzi3
//
//  Created by chendong on 13-3-4.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostListViewController : UITableViewController <UIGestureRecognizerDelegate>
{
    NSMutableArray *_statuses;
    NSMutableDictionary *_parameters;
    NSString *_restPath;
    NSInteger _channelID;
    NSInteger _lasttime;
    NSInteger _maxtime;
    NSInteger _mediaType;
}

- (id) initWithStyle:(UITableViewStyle)style andChanneID:(NSInteger)channelID andMediaType:(NSInteger)mediaType;

@end
