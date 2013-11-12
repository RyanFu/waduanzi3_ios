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
#import "UMSocialControllerService.h"
#import "CDViewController.h"
#import "CDCommentFormView.h"
#import "CDPostToolBar.h"

@class CDPost;

@interface PostDetailViewController : CDViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate, MBProgressHUDDelegate, UITextFieldDelegate, IIViewDeckControllerDelegate, UMSocialUIDelegate>
{
    NSMutableArray *_comments;
    NSInteger _lasttime;
    UIToolbar *_bottomToolbar;
    CGFloat detailFontSize;
    CGFloat commentFontSize;
    MBProgressHUD *_HUD;
    CDCommentFormView *_formView;
    CDPostToolBar *_postToolbar;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) NSInteger postID;
@property (nonatomic, strong) CDPost *post;
@property (nonatomic, strong) UIImage *smallImage;
@property (nonatomic, strong) UIImage *middleImage;
@property (nonatomic) BOOL *commentMode;

- (id)initWithPost:(CDPost *)post;
- (id)initWithPostID:(NSInteger)post_id;

- (UITableViewCell *) setupPostDetailViewCell:(NSIndexPath *)indexPath;
- (CGFloat) tableView:(UITableView *)tableView detailViewCellheightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void) setupHUDInView:(UIView *)view;
- (void) backButtonDidPressed:(id)sender;

@end
