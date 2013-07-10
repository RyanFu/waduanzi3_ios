//
//  PostDetailViewController.m
//  waduanzi3
//
//  Created by chendong on 13-6-5.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#define FORWARD_ACTIONSHEET_TAG 999999


#import <QuartzCore/QuartzCore.h>
#import <RestKit/RestKit.h>
#import "PostDetailViewController.h"
#import "WCAlertView.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "CDComment.h"
#import "CDPost.h"
#import "CDRestClient.h"
#import "CDDefine.h"
#import "CDCommentTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "CDPostDetailView.h"
#import "UserProfileViewController.h"
#import "CDDataCache.h"
#import "CDAppUser.h"
#import "ImageDetailViewController.h"
#import "CDCommentFormView.h"


@interface PostDetailViewController ()
{
    MBProgressHUD *_HUD;
    CDPostDetailView *_detailView;
    CDCommentFormView *_formView;
}

- (void) initData;
- (void) loadPostComments;
- (void) loadPostDetail;
- (NSDictionary *) commentsParameters;
- (NSDictionary *) createCommentParameters;
- (void) setupTableView;
- (void) setupPostDetailViewInCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;
- (void) setupPostDetailViewInCellData:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;
- (void) setCommentCellSubViews:(CDCommentTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void) supportComment:(NSInteger) index;
- (void) copyComment:(NSInteger) index;
- (void) reportComment:(NSInteger) index;
- (void) setupTableViewPullAndInfiniteScrollView;
- (void) setupBottomToolBar;
- (void) setupHUD;
- (void) setupCommentFormView;
- (void) sendComment;
@end


@implementation PostDetailViewController

@synthesize tableView = _tableView;
@synthesize postID = _postID;
@synthesize post = _post;
@synthesize smallImage = _smallImage;
@synthesize middleImage = _middleImage;

- (void) initData
{
    _comments = [NSMutableArray array];
    _lasttime = 0;
}

- (id)initWithPostID:(NSInteger)post_id
{
    self = [super init];
    if (self) {
        [self initData];
        self.postID = post_id;
    }
    return self;
}

- (id)initWithPost:(CDPost *)post
{
    self = [super init];
    if (self) {
        [self initData];
        self.post = post;
        self.postID = [_post.post_id integerValue];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch");
    [self.view endEditing:YES];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.userInteractionEnabled = YES;
    self.view.exclusiveTouch = YES;
    
    self.title = @"查看笑话";
    [self setupTableView];
    [self setupBottomToolBar];
    [self setupHUD];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(setupCommentFormView)];
    
    UISwipeGestureRecognizer *swipGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwips:)];
    swipGestureRecognizer.delegate = self;
    swipGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    swipGestureRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:swipGestureRecognizer];
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTableViewLongPress:)];
    longPressRecognizer.minimumPressDuration = 0.3f;
    longPressRecognizer.delegate = self;
    [self.tableView addGestureRecognizer:longPressRecognizer];
    
    [self setupTableViewPullAndInfiniteScrollView];
    [self.tableView triggerInfiniteScrolling];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void) keyboardWillShow:(NSNotification*)notification
{
    _tableView.userInteractionEnabled = NO;
    
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];

    [UIView beginAnimations:nil context:NULL];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    NSNumber *duration = [keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey];
    [UIView setAnimationDuration:duration.floatValue];
    
    CGRect formViewFrame = keyboardFrameBeginRect;
    formViewFrame.origin.y -= (COMMENT_FORM_HEIGHT + NAVBAR_HEIGHT + STATUSBAR_HEIGHT);
    formViewFrame.size.height = COMMENT_FORM_HEIGHT;
    
    _formView.frame = formViewFrame;
    [UIView commitAnimations];
}

- (void) keyboardWillHide:(NSNotification*)notification
{
    _tableView.userInteractionEnabled = YES;
    
    CGRect formViewFrame = _formView.frame;
    formViewFrame.origin.y = CDSCREEN_SIZE.height;
    formViewFrame.size.height = COMMENT_FORM_HEIGHT;
    _formView.frame = formViewFrame;
    _formView.hidden = YES;
}

- (void) handleSwips:(UISwipeGestureRecognizer *)recognizer
{
    NSLog(@"direction: %d", recognizer.direction);
    if (recognizer.direction & UISwipeGestureRecognizerDirectionRight)
        [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - setup subviews

- (void) setupTableView
{
    CGRect tableViewFrame = self.view.bounds;
    tableViewFrame.size.height -= (self.navigationController.navigationBar.frame.size.height + TOOLBAR_HEIGHT);
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
}

- (void) setupHUD
{
    if (_HUD == nil || _HUD.superview == nil) {
        _HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_HUD];
        _HUD.mode = MBProgressHUDModeDeterminate;
        _HUD.delegate = self;
    }
}

- (void) setupBottomToolBar
{
    CGRect toolbarFrame = CGRectMake(0, _tableView.frame.origin.y + _tableView.frame.size.height, self.view.frame.size.width, TOOLBAR_HEIGHT);
    _bottomToolbar = [[UIToolbar alloc] initWithFrame:toolbarFrame];
    _bottomToolbar.barStyle = UIBarStyleBlack;
    
    // set button items
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(backButtonDidPressed:)];
    UIBarButtonItem *favoriteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(bookmarkButtonDidPressed:)];
    UIBarButtonItem *flexButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *forwardButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(forwardButtonDidPressed:)];
    UIBarButtonItem *commentButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表评论" style:UIBarButtonItemStylePlain target:self action:@selector(setupCommentFormView)];
    
    NSArray *items = [NSArray arrayWithObjects:backButtonItem, flexButtonItem,
                      commentButtonItem, flexButtonItem,
                      favoriteButton, flexButtonItem,
                      forwardButtonItem,
                      nil];
    
    [_bottomToolbar setItems:items];
    [self.view addSubview:_bottomToolbar];
}

- (void) setupTableViewPullAndInfiniteScrollView
{
    __weak PostDetailViewController *weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf loadPostDetail];
    }];
    [self.tableView.pullToRefreshView setTitle:@"下拉刷新" forState:SVPullToRefreshStateStopped];
    [self.tableView.pullToRefreshView setTitle:@"载入中" forState:SVPullToRefreshStateLoading];
    [self.tableView.pullToRefreshView setTitle:@"释放立即刷新" forState:SVPullToRefreshStateTriggered];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadPostComments];
    }];
    
    CGRect infiniteViewFrame = CGRectMake(0, 0, self.tableView.frame.size.width, 30.0f);
    UILabel *stoppedLabel = [[UILabel alloc] initWithFrame:infiniteViewFrame];
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:infiniteViewFrame];
    UILabel *triggeredLabel = [[UILabel alloc] initWithFrame:infiniteViewFrame];
    stoppedLabel.textAlignment = loadingLabel.textAlignment = triggeredLabel.textAlignment = UITextAlignmentCenter;
    stoppedLabel.textColor = loadingLabel.textColor = triggeredLabel.textColor = [UIColor grayColor];
    stoppedLabel.backgroundColor = loadingLabel.backgroundColor = triggeredLabel.backgroundColor = [UIColor clearColor];
    stoppedLabel.font = loadingLabel.font = triggeredLabel.font = [UIFont systemFontOfSize:14.0f];
    NSInteger moreCommentCount = [_post.comment_count integerValue] - _comments.count;
    stoppedLabel.text = (moreCommentCount > 0) ? [NSString stringWithFormat:@"还有%d条评论", moreCommentCount] : @"没有更多啦";
//    [self.tableView.infiniteScrollingView setCustomView:stoppedLabel forState:SVInfiniteScrollingStateStopped];
    loadingLabel.text = @"加载中，请稍候...";
    [self.tableView.infiniteScrollingView setCustomView:loadingLabel forState:SVInfiniteScrollingStateLoading];
    triggeredLabel.text = @"加载更多";
    [self.tableView.infiniteScrollingView setCustomView:triggeredLabel forState:SVInfiniteScrollingStateTriggered];
}

- (void) setupCommentFormView
{
    if (_formView == nil || _formView.superview == nil) {
        CGRect formFrame = CDSCREEN.bounds;
        formFrame.origin.y = CDSCREEN_SIZE.height;
        _formView = [[CDCommentFormView alloc] initWithFrame:formFrame];
        [self.view addSubview:_formView];
        [_formView.submitButton addTarget:self action:@selector(submitButtonTouhcInUpside:) forControlEvents:UIControlEventTouchUpInside];
        _formView.contentField.delegate = self;
    }
    _formView.hidden = NO;
    [_formView.contentField becomeFirstResponder];
    
    NSLog(@"comment form");
}

#pragma mark - CDCommentFormView selector

- (void) submitButtonTouhcInUpside:(UIButton *)button
{
    if (_formView.contentField.text.length == 0)
        return;

    ^{
        [self sendComment];
    }();
    _formView.contentField.text = nil;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length == 0)
        return NO;
    else {
        ^{
            [self sendComment];
            textField.text = nil;
        }();

        return YES;
    }
}

#pragma mark - bottom bar button selector

- (void) backButtonDidPressed:(id)sender
{
    [_detailView.imageView cancelCurrentImageLoad];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) bookmarkButtonDidPressed:(id)sender
{
    if (![CDAppUser hasLogined]) {
        NSLog(@"user is not logined");
        return;
    }
    
    CDUser *user = [CDAppUser currentUser];
    NSString *userID = [user.user_id stringValue];
    
    UIBarButtonItem *button = (UIBarButtonItem *)sender;
    NSLog(@"stared, tag: %d", button.tag);

    NSString *restPath;
    if (button.tag > 0)
        restPath = [NSString stringWithFormat:@"/post/unlike/%d", [_post.post_id integerValue]];
    else
        restPath = [NSString stringWithFormat:@"/post/like/%d", [_post.post_id integerValue]];
    
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:userID, @"user_id", nil];

    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager.HTTPClient putPath:restPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response: %@", responseObject);
        button.tag = (button.tag > 0) ? 0 : 1;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

- (void) forwardButtonDidPressed:(id)sender
{
    NSLog(@"forward");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"我要分享" delegate:self cancelButtonTitle:@"关闭" destructiveButtonTitle:nil otherButtonTitles:@"短信分享", @"新浪微博", @"腾讯微博", @"复制", @"微信好友", @"微信朋友圈", nil];
    actionSheet.tag = FORWARD_ACTIONSHEET_TAG;
    
    [actionSheet showInView:self.navigationController.view];
}

- (void) openCommentTextInput:(id)sender
{
    NSLog(@"open comment text input");
    PostDetailViewController *dc = [[PostDetailViewController alloc] initWithPost:_post];
    [self presentViewController:dc animated:YES completion:^{
        NSLog(@"open profile");
    }];
}



#pragma mark - tableview datasource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (section == 0)
        count = 1;
    else if (section == 1)
        count = [_comments count];

    return count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *PostDetailCellIdentifier = @"PostDetailCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PostDetailCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PostDetailCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [self setupPostDetailViewInCell:cell indexPath:indexPath];
        [self setupPostDetailViewInCellData:cell indexPath:indexPath];

        return cell;
    }
    else {
        static NSString *CommentListCellIdentifier = @"CommentListCell";
        
        CDCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CommentListCellIdentifier];
        if (cell == nil) {
            cell = [[CDCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CommentListCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentMode = UIViewContentModeTopLeft;
            
            UIImage *bgImage = [[UIImage imageNamed:@"post_cell_bg.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:5.0f];
            UIImageView *bgView = [[UIImageView alloc] initWithImage:bgImage];
            bgView.contentMode = UIViewContentModeScaleToFill;
            bgView.frame = cell.contentView.frame;
            cell.backgroundView = bgView;
            
            [self setCommentCellSubViews:cell forRowAtIndexPath:indexPath];
        }
        
        CDComment *comment = [_comments objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = comment.content;
        cell.authorTextLabel.text = comment.author_name;
        cell.orderTextLabel.text = [NSString stringWithFormat:@"#%d", indexPath.row+1];
        [cell.avatarImageView setImageWithURL:[NSURL URLWithString:comment.user.mini_avatar] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
        cell.imageView.image = nil;
        comment = nil;
        
        return cell;
    }
    
}

- (void) setupPostDetailViewInCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    [_detailView removeFromSuperview];
    _detailView = nil;
    _detailView = [[CDPostDetailView alloc] initWithFrame:cell.contentView.bounds];
    [cell.contentView addSubview:_detailView];
    _detailView.padding = POST_DETAIL_CELL_PADDING;

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFullscreenImage:)];
    [_detailView.imageView addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.delegate = self;
}

- (void) setupPostDetailViewInCellData:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    CGFloat contentWidth = _detailView.frame.size.width - POST_DETAIL_CELL_PADDING * 2;
    CGFloat imageViewHeight = 0;
    if (_middleImage) {
        CGSize middleImageSize = CGSizeMake(_middleImage.size.width / 2, _middleImage.size.height / 2);
        // 引处按照将图片宽度全部拉伸为contentWidth
        imageViewHeight =  contentWidth * middleImageSize.height / middleImageSize.width;
    }
    else if (_smallImage) {
        CGSize smallImageSize = CGSizeMake(_smallImage.size.width / 2, _smallImage.size.height / 2);
        imageViewHeight =  contentWidth * smallImageSize.height / smallImageSize.width;
    }
    else
        imageViewHeight = THUMB_HEIGHT;
    _detailView.imageSize = CGSizeMake(contentWidth, imageViewHeight);
    
    _detailView.detailTextLabel.text = _post.content;
    _detailView.authorTextLabel.text = _post.author_name;
    _detailView.datetimeTextLabel.text = _post.create_time_at;
    [_detailView.avatarImageView setImageWithURL:[NSURL URLWithString:_post.user.small_avatar] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    
    if (_middleImage) {
        _detailView.imageView.image = _middleImage;
        _detailView.textLabel.text = nil;
    }
    else if (_post.middle_pic.length > 0) {
        if (_smallImage == nil)
            self.smallImage = [UIImage imageNamed:@"thumb_placeholder"];
        
        __weak PostDetailViewController *weakSelf = self;
        __weak MBProgressHUD *weakHUD = _HUD;
        __weak UIImageView *weakImageView = _detailView.imageView;
        NSURL *imageUrl = [NSURL URLWithString:_post.middle_pic];
        [_detailView.imageView setImageWithURL:imageUrl placeholderImage:_smallImage options:SDWebImageRetryFailed progress:^(NSUInteger receivedSize, long long expectedSize) {
            if (expectedSize <= 0) {
                weakHUD.mode = MBProgressHUDModeDeterminate;
                [weakHUD show:YES];
            }
            else
                weakHUD.progress = receivedSize / (expectedSize + 0.0);
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            [weakHUD hide:YES];
            if (error) {
                [weakImageView cancelCurrentImageLoad];
                NSLog(@"picture download failed:%@", error);
            }
            else {
                weakSelf.middleImage = image;
                [weakSelf.tableView reloadData];
            }
        }];
        // 如果是趣图，不显示标题，只显示内容
        _detailView.textLabel.text = nil;
    }
    else {
        _detailView.textLabel.text = _post.title;
        _detailView.imageView.image = nil;
    }
}

- (void) showFullscreenImage:(UITapGestureRecognizer *) recognizer
{
    ImageDetailViewController *imageViewController = [[ImageDetailViewController alloc] init];
    imageViewController.thumbnail = _smallImage;
    imageViewController.originaPic = _middleImage;
    imageViewController.originalPicUrl = [NSURL URLWithString:_post.middle_pic];
    [self presentViewController:imageViewController animated:NO completion:NULL];
}


- (void) setCommentCellSubViews:(CDCommentTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.padding = POST_DETAIL_CELL_PADDING;
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:0.01f green:0.01f blue:0.01f alpha:1.00f];
    
    cell.authorTextLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    cell.authorTextLabel.textColor = [UIColor colorWithRed:0.37f green:0.75f blue:0.51f alpha:1.00f];
    
    cell.orderTextLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.orderTextLabel.textColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CGFloat contentWidth = tableView.frame.size.width - POST_DETAIL_CELL_PADDING*2;
        CGSize titleLabelSize = [_post.title sizeWithFont:[UIFont systemFontOfSize:16.0f]
                                       constrainedToSize:CGSizeMake(contentWidth, 9999.0)
                                           lineBreakMode:UILineBreakModeWordWrap];
        
        CGSize detailLabelSize = [_post.content sizeWithFont:[UIFont systemFontOfSize:16.0f]
                                          constrainedToSize:CGSizeMake(contentWidth, 9999.0)
                                              lineBreakMode:UILineBreakModeWordWrap];
        
        CGFloat cellHeight = POST_DETAIL_CELL_PADDING + POST_AVATAR_WIDTH + POST_DETAIL_CELL_PADDING + detailLabelSize.height;
        
        CGFloat imageViewHeight = 0;
        if (_middleImage) {
            CGSize middleImageSize = CGSizeMake(_middleImage.size.width / 2, _middleImage.size.height / 2);
            // 引处按照将图片宽度全部拉伸为contentWidth
            imageViewHeight =  contentWidth * middleImageSize.height / middleImageSize.width;
        }
        else if (_smallImage) {
            CGSize smallImageSize = CGSizeMake(_smallImage.size.width / 2, _smallImage.size.height / 2);
            imageViewHeight =  contentWidth * smallImageSize.height / smallImageSize.width;
        }
        else if (_post.middle_pic.length > 0)
            imageViewHeight = THUMB_HEIGHT;
        
        if (imageViewHeight > 0)
            cellHeight += imageViewHeight + POST_DETAIL_CELL_PADDING;
        else
            cellHeight += titleLabelSize.height + POST_DETAIL_CELL_PADDING;

        return cellHeight + POST_DETAIL_CELL_PADDING * 2;
    }
    else if (indexPath.section == 1 && indexPath.row < _comments.count) {
        CDComment *comment = [_comments objectAtIndex:indexPath.row];
        
        CGFloat contentWidth = self.view.frame.size.width - POST_DETAIL_CELL_PADDING*2;
        UIFont *detailFont = [UIFont systemFontOfSize:14.0f];
        CGSize detailLabelSize = [comment.content sizeWithFont:detailFont
                                          constrainedToSize:CGSizeMake(contentWidth, 9999.0)
                                              lineBreakMode:UILineBreakModeWordWrap];
        
        CGFloat cellHeight = POST_DETAIL_CELL_PADDING + COMMENT_AVATAR_WIDTH + detailLabelSize.height + POST_DETAIL_CELL_PADDING;
        
        return cellHeight;
    }
    else
        return 0.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001f;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    static UIView *footerView;
    if (footerView == nil)
        footerView = [[UIView alloc] init];
    
    return footerView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 1 ? 20.0f : 0.001f;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        CGRect headerViewFrame = CGRectMake(0, 0, tableView.frame.size.width, 20.0f);
        UIView *headerView = [[UIView alloc] initWithFrame:headerViewFrame];
        headerView.backgroundColor = [UIColor lightGrayColor];
        CGRect labelFrame = headerViewFrame;
        
        labelFrame.origin.x += 10.0f;
        labelFrame.size.width -= labelFrame.origin.x * 2;
        UILabel *textLabel = [[UILabel alloc] initWithFrame:labelFrame];
        textLabel.text = @"评论列表";
        textLabel.textColor = [UIColor whiteColor];
        textLabel.font = [UIFont systemFontOfSize:13.0f];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.numberOfLines = 1;
        
        [headerView addSubview:textLabel];
        return headerView;
    }
    else
        return [[UIView alloc] initWithFrame:CGRectZero];
}



#pragma mark - comment cell long press selector and methods

- (void) handleTableViewLongPress:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [recognizer locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
        if (indexPath == nil || indexPath.section == 0) return;
        
        CDComment *comment = [_comments objectAtIndex:indexPath.row];
        NSString *upText = [NSString stringWithFormat:@"顶[%d]", [comment.up_count integerValue]];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                                         cancelButtonTitle:@"取消"
                                                    destructiveButtonTitle:nil
                                                         otherButtonTitles:upText, @"复制", @"举报", nil];
        actionSheet.tag = indexPath.row;
        [actionSheet showInView:self.navigationController.view];
    }
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"action sheet tag: %d,  buttonIndex: %d", actionSheet.tag, buttonIndex);
    if (actionSheet.tag == FORWARD_ACTIONSHEET_TAG) {
        NSLog(@"forward button pressed");
    }
    else {
        switch (buttonIndex) {
            case 0:
                [self supportComment:actionSheet.tag];
                break;
            case 1:
                [self copyComment:actionSheet.tag];
                break;
            case 2:
                [self reportComment:actionSheet.tag];
                break;
            default:
                break;
        }
    }
}

- (void) supportComment:(NSInteger) index
{
    CDComment *comment = [_comments objectAtIndex:index];
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    NSString *restPath = [NSString stringWithFormat:@"/comment/support/%d", [comment.comment_id integerValue]];
    [objectManager.HTTPClient putPath:restPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        comment.up_count = [NSNumber numberWithInteger: [comment.up_count integerValue] + 1];
        [_comments replaceObjectAtIndex:index withObject:comment];
        
        NSLog(@"response: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

- (void) reportComment:(NSInteger)index
{
    CDComment *comment = [_comments objectAtIndex:index];
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    NSString *restPath = [NSString stringWithFormat:@"/comment/report/%d", [comment.comment_id integerValue]];
    [objectManager.HTTPClient putPath:restPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        comment.report_count = [NSNumber numberWithInteger: [comment.report_count integerValue] + 1];
        [_comments replaceObjectAtIndex:index withObject:comment];
        
        NSLog(@"response: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

- (void) copyComment:(NSInteger)index
{
    CDComment *comment = [_comments objectAtIndex:index];
    
    NSString *text = comment.content;
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:text];
}

#pragma mark - load data


- (NSDictionary *) commentsParameters
{
    if (_comments.count > 0) {
        CDComment *lastComment = [_comments lastObject];
        _lasttime = [lastComment.create_time integerValue];
    }
    else
        _lasttime = 0;
    
    NSString *last_time = [NSString stringWithFormat:@"%d", _lasttime];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:last_time forKey:@"lasttime"];
    
    return [CDRestClient requestParams:params];
}


- (void)loadPostComments
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager getObjectsAtPath:[NSString stringWithFormat:@"/comment/show/%d", _postID]
                         parameters:[self commentsParameters]
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                [self.tableView.infiniteScrollingView stopAnimating];
                                
                                if (mappingResult.count > 0) {
                                    NSMutableArray* statuses = (NSMutableArray *)[mappingResult array];
                                    NSInteger currentCount = [_comments count];
                                    [_comments addObjectsFromArray:statuses];
                                    
                                    NSMutableArray *insertIndexPaths = [NSMutableArray array];
                                    for (int i=0; i<statuses.count; i++) {
                                        [insertIndexPaths addObject:[NSIndexPath indexPathForRow:currentCount+i inSection:1]];
                                    }
                                    
                                    [self.tableView beginUpdates];
                                    [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationNone];
                                    [self.tableView endUpdates];
                                    
                                    NSInteger moreCommentCount = [_post.comment_count integerValue] - _comments.count;
                                    if (moreCommentCount <= 0)
                                        self.tableView.showsInfiniteScrolling = NO;
                                }
                                else {
                                    NSLog(@"没有更多内容了");
                                }
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                [self.tableView.infiniteScrollingView stopAnimating];
                                [WCAlertView showAlertWithTitle:@"出错啦"
                                                        message:@"载入数据出错。"
                                             customizationBlock:^(WCAlertView *alertView) {
                                                 
                                                 alertView.style = WCAlertViewStyleWhite;
                                                 
                                             } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                                                 if (buttonIndex == 1)
                                                     [self loadPostComments];
                                             } cancelButtonTitle:@"关闭" otherButtonTitles:@"重试",nil];
                                NSLog(@"Hit error: %@", error);
                            }];
    
}

- (void) loadPostDetail
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager getObjectsAtPath:[NSString stringWithFormat:@"/post/show/%d", _postID]
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                [self.tableView.pullToRefreshView stopAnimating];
                                
                                self.post = (CDPost *) [mappingResult firstObject];
                                if (self.isViewLoaded) {
                                    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
                                    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                                }
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                [self.tableView.pullToRefreshView stopAnimating];
                                [WCAlertView showAlertWithTitle:@"出错啦"
                                                        message:@"载入数据出错。"
                                             customizationBlock:^(WCAlertView *alertView) {
                                                 
                                                 alertView.style = WCAlertViewStyleWhite;
                                                 
                                             } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                                                 if (buttonIndex == 1)
                                                     [self loadPostComments];
                                             } cancelButtonTitle:@"关闭" otherButtonTitles:@"重试",nil];
                                NSLog(@"Hit error: %@", error);
                            }];
    
}


- (NSDictionary *) createCommentParameters
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_formView.contentField.text forKey:@"content"];
    [params setObject:_post.post_id forKey:@"post_id"];
    if ([CDAppUser hasLogined]) {
        CDUser *user = [CDAppUser currentUser];
        if (user.user_id != nil)
            [params setObject:user.user_id forKey:@"user_id"];
        if (user.screen_name != nil)
            [params setObject:user.screen_name forKey:@"user_name"];
    }
    
    return [CDRestClient requestParams:params];
}


- (void) sendComment
{
    if (_formView.contentField.text.length == 0)
        return;
    
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager postObject:nil path:@"comment/create"
                   parameters:[self createCommentParameters] success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       CDComment *comment = (CDComment *) [mappingResult firstObject];
                      NSLog(@"%@", comment.author_name);
                       [self.view endEditing:YES];
                       if (self.isViewLoaded) {
                           NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:_comments.count inSection:1];
                           NSArray *insertIndexPaths = [NSArray arrayWithObjects:newIndexPath, nil];
                           [_comments addObject:comment];
                           [self.tableView beginUpdates];
                           [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                           [self.tableView endUpdates];
                           [self.tableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                       }
                   } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                       [self.view endEditing:YES];
                       [WCAlertView showAlertWithTitle:@"出错啦"
                                               message:@"载入数据出错。"
                                    customizationBlock:^(WCAlertView *alertView) {
                                        
                                        alertView.style = WCAlertViewStyleWhite;
                                        
                                    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                                        if (buttonIndex == 1)
                                            [self loadPostComments];
                                    } cancelButtonTitle:@"关闭" otherButtonTitles:@"重试",nil];
                       NSLog(@"Hit error: %@", error);
                   }];
}


@end
