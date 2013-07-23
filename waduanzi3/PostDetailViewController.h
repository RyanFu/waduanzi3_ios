//
//  PostDetailViewController.h
//  waduanzi3
//
//  Created by chendong on 13-6-5.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "IIViewDeckController.h"

@class CDPost;
@class CDPostDetailView;

@interface PostDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate, MBProgressHUDDelegate, UITextFieldDelegate, IIViewDeckControllerDelegate>
{
    NSMutableArray *_comments;
    NSInteger _lasttime;
    UIToolbar *_bottomToolbar;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) NSInteger postID;
@property (nonatomic, strong) CDPost *post;
@property (nonatomic, strong) UIImage *smallImage;
@property (nonatomic, strong) UIImage *middleImage;
@property (nonatomic) BOOL *commentMode;

- (id)initWithPost:(CDPost *)post;
- (id)initWithPostID:(NSInteger)post_id;

@end
