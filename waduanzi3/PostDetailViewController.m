//
//  PostDetailViewController.m
//  waduanzi3
//
//  Created by chendong on 13-6-5.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <RestKit/RestKit.h>
#import "PostDetailViewController.h"
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
#import "UserLoginViewController.h"
#import "UMSocial.h"
#import "WBErrorNoticeView+WaduanziMethod.h"
#import "CDUserConfig.h"
#import "MobClick.h"

@interface PostDetailViewController ()
- (void) initData;
- (void) loadPostComments;
- (NSDictionary *) commentsParameters;
- (NSDictionary *) createCommentParameters;
- (void) setupNavButtionItems;
- (void) setupTableView;
- (void) setCommentCellSubViews:(CDCommentTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void) supportComment:(NSInteger) index;
- (void) copyComment:(NSInteger) index;
- (void) reportComment:(NSInteger) index;
- (void) setupTableViewInfiniteScrollView;
- (void) setupCommentFormView;
- (BOOL) submitCommentAction;
- (void) sendComment;

@end


@implementation PostDetailViewController

@synthesize tableView = _tableView;
@synthesize postID = _postID;
@synthesize post = _post;
@synthesize smallImage = _smallImage;
@synthesize middleImage = _middleImage;
@synthesize commentMode = _commentMode;

- (void) initData
{
    _comments = [NSMutableArray array];
    _lasttime = 0;
    _commentMode = NO;
    detailFontSize = [CDUserConfig shareInstance].postFontSize;
    commentFontSize = [CDUserConfig shareInstance].commentFontSize;
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
    self.title = @"查看详情";
    self.view.userInteractionEnabled = YES;
    self.view.exclusiveTouch = YES;
    
    // 设置键盘显示和隐藏的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    // 设置导航栏组件
    [self setupNavButtionItems];
    // 设置UITableView
    [self setupTableView];
    // 设置评论框组件视图
    [self setupCommentFormView];
    

    // 右滑回到段子列表
    UISwipeGestureRecognizer *swipGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwips:)];
    swipGestureRecognizer.delegate = self;
    swipGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    swipGestureRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:swipGestureRecognizer];
    
    // 设置下滑和下滑视图
    [self setupTableViewInfiniteScrollView];
    [self.tableView triggerInfiniteScrolling];
}


- (void) viewDidUnload
{
    [super viewDidUnload];
    
    // 移除键盘显示和隐藏的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    
    // 终止评论获取进程和更新段子信息进程
    [[RKObjectManager sharedManager] cancelAllObjectRequestOperationsWithMethod:RKRequestMethodGET matchingPathPattern:@"/comment/show/:post_id"];
    [[RKObjectManager sharedManager] cancelAllObjectRequestOperationsWithMethod:RKRequestMethodGET matchingPathPattern:@"/post/show/:post_id"];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 判断用户是否修改了字体大小，如果修改了应用新字体大小
    CGFloat newCommentFontSize = [CDUserConfig shareInstance].commentFontSize;
    CGFloat newDetailFontSize = [CDUserConfig shareInstance].postFontSize;
    if (newDetailFontSize != detailFontSize || newCommentFontSize != commentFontSize) {
        commentFontSize = newCommentFontSize;
        [self.tableView reloadData];
    }
    
    // 如果进入此窗口的动作是评论，则显示内容后直接进入评论状态
    if (_commentMode) {
        [self performSelector:@selector(commentTextFieldBecomeFirstResponder)];
        _commentMode = NO;
    }
}

// 当键盘显示时
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

// 当键盘隐藏时
- (void) keyboardWillHide:(NSNotification*)notification
{
    _tableView.userInteractionEnabled = YES;
    
    CGRect formViewFrame = _formView.frame;
    formViewFrame.origin.y = _tableView.frame.origin.y + _tableView.frame.size.height;
    _formView.frame = formViewFrame;
}

// 此容器右滑不打开左边栏
- (BOOL) viewDeckController:(IIViewDeckController *)viewDeckController shouldOpenViewSide:(IIViewDeckSide)viewDeckSide
{
    return NO;
}

// 定义视图滑动手势动作，右滑返回段子列表，其它手势无动作
- (void) handleSwips:(UISwipeGestureRecognizer *)recognizer
{
    NSLog(@"direction: %d", recognizer.direction);
    if (recognizer.direction & UISwipeGestureRecognizerDirectionRight) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - setup subviews

- (void) setupNavButtionItems
{
    UIImage *backImage = [UIImage imageNamed:@"NavBarButtonArrow.png"];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, backImage.size.width + 20.0f, backImage.size.height);
    [leftButton setImage:backImage forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"NavBarButtonArrowHighlighted.png"] forState:UIControlStateSelected];
    [leftButton addTarget:self action:@selector(backButtonDidPressed:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.showsTouchWhenHighlighted = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    UIImage *actionImage = [UIImage imageNamed:@"navBarActionIcon.png"];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, actionImage.size.width + 20.0f, actionImage.size.height);
    [rightButton setImage:actionImage forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"NavBarButtonArrowHighlighted.png"] forState:UIControlStateSelected];
    [rightButton addTarget:self action:@selector(forwardButtonDidPressed:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.showsTouchWhenHighlighted = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
}

- (void) setupTableView
{
    CGRect tableViewFrame = self.view.bounds;
    
    if (OS_VERSION_LESS_THAN(@"7.0"))
        tableViewFrame.size.height -= (NAVBAR_HEIGHT + COMMENT_FORM_HEIGHT);
    else
        tableViewFrame.size.height -= (NAVBAR_HEIGHT + STATUSBAR_HEIGHT + COMMENT_FORM_HEIGHT);
    
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0f];
    _tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pullToRefreshBg.png"]];
}

- (void) setupHUDInView:(UIView *)view
{
    if ([_HUD.superview isEqual:view])
        [_HUD removeFromSuperview];
    _HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:_HUD];
    _HUD.mode = MBProgressHUDModeDeterminate;
    _HUD.delegate = self;

}

- (void) setupTableViewInfiniteScrollView
{
    __weak PostDetailViewController *weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadPostComments];
    }];
}

- (void) setupCommentFormView
{
    // iOS 7 中 状态栏是视图的一部分，所以self.view.frame.origin.y为0，而以前的版本为statusbar的hegiht;
    CGFloat formViewY = self.view.frame.size.height - COMMENT_FORM_HEIGHT - NAVBAR_HEIGHT - STATUSBAR_HEIGHT;
    if (OS_VERSION_LESS_THAN(@"7.0"))
        formViewY = self.view.frame.size.height - COMMENT_FORM_HEIGHT - NAVBAR_HEIGHT;
    CGRect formFrame = CGRectMake(0, formViewY, CDSCREEN_SIZE.width, COMMENT_FORM_HEIGHT);
    _formView = [[CDCommentFormView alloc] initWithFrame:formFrame];
    _formView.submitButton.enabled = _formView.textField.text.length > 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [_formView.submitButton addTarget:self action:@selector(submitButtonTouhcInUpside:) forControlEvents:UIControlEventTouchUpInside];
    _formView.textField.delegate = self;
    [self.view addSubview:_formView];

    
    NSLog(@"comment form, height: %f", self.view.frame.size.height);
}

- (void) commentTextFieldBecomeFirstResponder
{
    NSDictionary *attributes = @{
                                 @"post_id": _post.post_id,
                                 @"post_title": _post.title
                                 };
    [MobClick event:UM_EVENT_POST_COMMENT attributes:attributes];
    
    [_formView.textField becomeFirstResponder];
}

#pragma mark - CDCommentFormView selector

- (void) submitButtonTouhcInUpside:(UIButton *)button
{
    [self submitCommentAction];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [self submitCommentAction];
}

- (BOOL) submitCommentAction
{
    if (_formView.textField.text.length == 0)
        return NO;
    else {
        _formView.submitButton.enabled = NO;
        _formView.textField.text = nil;
        [self.view endEditing:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self sendComment];
        });
        
        return YES;
    }
}

- (void) textFieldDidChanged:(NSNotification *)notification
{
    CDTextField *textField = (CDTextField *)notification.object;
    _formView.submitButton.enabled = (textField.text.length > 0);
}

#pragma mark - bottom bar button selector

- (void) backButtonDidPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) likeButtonDidPressed:(id)sender
{
    NSDictionary *attributes = @{
                                 @"post_id": _post.post_id,
                                 @"post_title": _post.title
                                 };
    [MobClick event:UM_EVENT_LIKE_POST attributes:attributes];
    
    UIButton *button = (UIButton *)sender;
    NSLog(@"state: %d", button.state);
    button.selected = YES;
    [[CDDataCache shareCache] cachePostLikeState:YES forPostID:_postID];
    button.userInteractionEnabled = NO;
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    NSString *restPath = [NSString stringWithFormat:@"/post/support/%d", [_post.post_id integerValue]];
    [objectManager.HTTPClient putPath:restPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _post.up_count = [NSNumber numberWithInteger:[_post.up_count integerValue]+1];
        NSLog(@"response: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

- (void) favoriteButtonDidPressed:(id)sender
{
    
    if (![CDAppUser hasLogined]) {
        [CDAppUser requiredLogin];
        NSLog(@"user is not logined");
        
        // umeng
        NSDictionary *attributes = @{
                                     @"post_id": _post.post_id,
                                     @"post_title": _post.title,
                                     @"user_logined": [NSNumber numberWithBool:NO]
                                     };
        [MobClick event:UM_EVENT_FAVORITE_POST attributes:attributes];
        
        return;
    }
    
    CDUser *user = [CDAppUser currentUser];
    NSString *userID = [user.user_id stringValue];
    
    // umeng
    NSDictionary *attributes = @{
                                 @"post_id": _post.post_id,
                                 @"post_title": _post.title,
                                 @"user_logined": [NSNumber numberWithBool:YES],
                                 @"user_id": userID,
                                 @"user_name": user.username
                                 };
    [MobClick event:UM_EVENT_FAVORITE_POST attributes:attributes];
    
    UIButton *button = (UIButton *)sender;
    
    // 不管成功与否，都设置相应状态
    button.selected = !button.selected;
    [[CDDataCache shareCache] cachePostFavoriteState:button.selected forPostID:_postID forUserID:[user.user_id integerValue]];

    NSString *restPath;
    if (button.selected)
        restPath = [NSString stringWithFormat:@"/post/like/%d", [_post.post_id integerValue]];
    else
        restPath = [NSString stringWithFormat:@"/post/unlike/%d", [_post.post_id integerValue]];
        
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:userID, @"user_id", nil];
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager.HTTPClient putPath:restPath parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

- (void) forwardButtonDidPressed:(id)sender
{
    NSLog(@"forward");
    
    [self.view endEditing:YES];
    
    @try {
        [UMSocialConfig setQQAppId:QQ_CONNECT_APPID url:_post.url importClasses:@[[QQApiInterface class],[TencentOAuth class]]];

        UMSocialData *socialData = [UMSocialData defaultData];
        socialData.identifier = [NSString stringWithFormat:@"umshare_identifier_post_%@", _post.post_id];
        socialData.title = _post.title;
        socialData.shareText = _post.content;
        
        [[UMSocialControllerService defaultControllerService] setSocialUIDelegate:self];
        UMSocialIconActionSheet *actionSheet = [[UMSocialControllerService defaultControllerService] getSocialIconActionSheetInController:self];
        [actionSheet showInView:self.navigationController.view];
    }
    @catch (NSException *exception) {
        CDLog(@"exception: %@", exception);
    }
    @finally {
        ;
    }
}

#pragma mark - socialUIDelegate

- (void) willCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    CDLog(@"willCloseUIViewController: %d", fromViewControllerType);
}

- (void) didCloseUIViewController:(UMSViewControllerType)fromViewControllerType
{
    CDLog(@"didCloseUIViewController: %d", fromViewControllerType);
}

- (void) didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData
{
    CDLog(@"didSelectSocialPlatform: %@", platformName);
    
    if (_post.video && _post.video.source_url.length > 0) {
        if (_smallImage)
            socialData.shareImage = _smallImage;
        
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeVideo url:_post.url];
        socialData.urlResource = urlResource;
    }
    else if (_post.middle_pic.length > 0) {
        if (_middleImage)
            socialData.shareImage = _middleImage;
        else {
            UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:_post.middle_pic];
            socialData.urlResource = urlResource;
        }
    }
    
    socialData.extConfig.title = _post.title;
    
    
    if ([platformName isEqualToString:UMShareToSms]) {
        if (_post.middle_pic.length > 0 || _post.video.source_url.length > 0)
            socialData.shareText = [socialData.shareText stringByAppendingString:_post.url];
        else
            socialData.shareText = [NSString stringWithFormat:@"[来自挖段子网]%@", socialData.shareText];
    }
    if ([platformName isEqualToString:UMShareToEmail]) {
        socialData.extConfig.mailMessage = [_post.content stringByAppendingFormat:@"<p>[来自挖段子网]<a href=\"%@\">%@</a></p>", _post.url, _post.url];
    }
    else if ([platformName isEqualToString:UMShareToQzone]) {
        if (_post.middle_pic.length > 0)
            socialData.extConfig.thumbUrl = _post.middle_pic;
    }
    else if ([platformName isEqualToString:UMShareToWechatTimeline] || [platformName isEqualToString:UMShareToWechatSession]) {
        if (_smallImage) {
            socialData.shareImage = _smallImage;
        }
        socialData.extConfig.wxDescription = _post.content;
        
        if (_post.video && _post.video.source_url.length > 0) {
            socialData.extConfig.wxMessageType = UMSocialWXMessageTypeOther;
            socialData.extConfig.appUrl = _post.url;
            WXVideoObject *videoObject = [WXVideoObject object];
            videoObject.videoUrl = _post.url;
            videoObject.videoLowBandUrl = _post.video.source_url;
            socialData.extConfig.wxMediaObject = videoObject;
        }
        else if (_post.middle_pic.length > 0) {
            socialData.extConfig.wxMessageType = UMSocialWXMessageTypeOther;
            socialData.extConfig.appUrl = _post.url;
            WXWebpageObject *webpageObject = [WXWebpageObject object];
            webpageObject.webpageUrl = _post.url;
            socialData.extConfig.wxMediaObject = webpageObject;
        }
        else
            socialData.extConfig.wxMessageType = UMSocialWXMessageTypeText;
    }
}

- (void) didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    CDLog(@"didFinishGetUMSocialDataInViewController: %@", response);
}

#pragma mark - tableview datasource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 0;
    if (section == 0 || section == 1)
        count = 1;
    else if (section == 2)
        count = [_comments count];

    return count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [self setupPostDetailViewCell:indexPath];
        return cell;
    }
    else if (indexPath.section == 1) {
        static NSString *PostButtonsCellIdentifier = @"PostButtons";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PostButtonsCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PostButtonsCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        _postToolbar = [[CDPostToolBar alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40.0f)];
        [_postToolbar.likeButton addTarget:self action:@selector(likeButtonDidPressed:) forControlEvents:UIControlEventTouchUpInside];
        _postToolbar.likeButton.selected = [[CDDataCache shareCache] fetchPostLikeState:_postID];
        _postToolbar.likeButton.userInteractionEnabled = !_postToolbar.likeButton.selected;
        [_postToolbar.favoriteButton addTarget:self action:@selector(favoriteButtonDidPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_postToolbar.commentButton addTarget:self action:@selector(commentTextFieldBecomeFirstResponder) forControlEvents:UIControlEventTouchUpInside];
        [_postToolbar.actionButton addTarget:self action:@selector(forwardButtonDidPressed:) forControlEvents:UIControlEventTouchUpInside];
        _postToolbar.likeButton.selected = [[CDDataCache shareCache] fetchPostLikeState:_postID];
        _postToolbar.likeButton.userInteractionEnabled = !_postToolbar.likeButton.selected;
        
        if ([CDAppUser hasLogined]) {
            CDUser *user = [CDAppUser currentUser];
            _postToolbar.favoriteButton.selected = [[CDDataCache shareCache] fetchPostFavoriteState:_postID forUserID:[user.user_id integerValue]];
        }
        [cell.contentView addSubview:_postToolbar];
        
        return cell;
    }
    else {
        static NSString *CommentListCellIdentifier = @"CommentListCell";
        
        CDCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CommentListCellIdentifier];
        if (cell == nil) {
            cell = [[CDCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CommentListCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            [self setCommentCellSubViews:cell forRowAtIndexPath:indexPath];
        }
        cell.textLabel.font = [UIFont fontWithName:FZLTHK_FONT_NAME size:commentFontSize];
        
        CDComment *comment = [_comments objectAtIndex:indexPath.row];
        cell.textLabel.text = comment.content;
        cell.authorTextLabel.text = comment.author_name;
        cell.orderTextLabel.text = [NSString stringWithFormat:@"%@ #%d", comment.create_time_at, indexPath.row+1];
        [cell.avatarImageView setImageWithURL:[NSURL URLWithString:comment.user.mini_avatar] placeholderImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
        cell.imageView.image = nil;
        comment = nil;
        
        return cell;
    }
    
}

- (UITableViewCell *) setupPostDetailViewCell:(NSIndexPath *)indexPath
{
    [NSException raise:@"Invoked abstract method" format:@"Invoked abstract method"];
    return nil;
}


- (void) setCommentCellSubViews:(CDCommentTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.padding = POST_DETAIL_CELL_PADDING;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [self tableView:tableView detailViewCellheightForRowAtIndexPath:indexPath];
    }
    else if (indexPath.section == 1) {
        return 40.0f;
    }
    else if (indexPath.section == 2 && indexPath.row < _comments.count) {
        CDComment *comment = [_comments objectAtIndex:indexPath.row];
        
        CGFloat contentWidth = self.view.frame.size.width - POST_DETAIL_CELL_PADDING*2;
        CGSize authorLabelSize = [comment.author_name sizeWithFont:[UIFont boldSystemFontOfSize:14.0f]];
        CGSize detailLabelSize = [comment.content sizeWithFont:[UIFont systemFontOfSize:14.0f]
                                          constrainedToSize:CGSizeMake(contentWidth, 9999.0)
                                              lineBreakMode:UILineBreakModeWordWrap];
        
        CGFloat cellHeight = POST_DETAIL_CELL_PADDING + authorLabelSize.height + COMMENT_BLOCK_SPACE_HEIGHT + detailLabelSize.height + POST_DETAIL_CELL_PADDING;
        
        return cellHeight;
    }
    else
        return 40.0f;
}

- (CGFloat) tableView:(UITableView *)tableView detailViewCellheightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [NSException raise:@"Invoked abstract method" format:@"Invoked abstract method"];
    return 0;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        [self.view endEditing:YES];
        
        CDComment *comment = [_comments objectAtIndex:indexPath.row];
        NSString *upText = [NSString stringWithFormat:@"顶[%d]", [comment.up_count integerValue]];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:upText, @"复制", @"举报", nil];
        actionSheet.tag = indexPath.row;
        [actionSheet showInView:ROOT_CONTROLLER.view];
    }
}

#pragma mark - comment cell long press selector and methods

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"action sheet tag: %d,  buttonIndex: %d", actionSheet.tag, buttonIndex);
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
                                    [_comments addObjectsFromArray:statuses];
                                    
                                    [self.tableView reloadData];
                                }
                                else {
                                    self.tableView.showsInfiniteScrolling = NO;
                                    NSLog(@"没有更多内容了");
                                }
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                [self.tableView.infiniteScrollingView stopAnimating];
                                
                                if (error.code == NSURLErrorCancelled) return ;
                                
                                NSString *noticeTitle = @"载入评论出错";
                                if (error.code == kCFURLErrorTimedOut)
                                    noticeTitle = @"网络超时";
                                
                                [WBErrorNoticeView showErrorNoticeView:self.view title:@"提示" message:noticeTitle sticky:NO delay:2.0f dismissedBlock:nil];
                                
                                NSLog(@"Hit error: %@", error);
                            }];
    
}

- (NSDictionary *) createCommentParameters
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_formView.textField.text forKey:@"content"];
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
    if (_formView.textField.text.length == 0)
        return;
    
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager postObject:nil path:@"comment/create"
                   parameters:[self createCommentParameters] success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                       _formView.submitButton.enabled = YES;
                       _post.comment_count = [NSNumber numberWithInteger:_post.comment_count.integerValue+1];
                       
                        CDComment *comment = (CDComment *) [mappingResult firstObject];
                       
                        if (self.isViewLoaded) {
                            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:_comments.count inSection:2];
                            NSArray *insertIndexPaths = [NSArray arrayWithObjects:newIndexPath, nil];
                            [_comments addObject:comment];
                            [self.tableView beginUpdates];
                            [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                            [self.tableView endUpdates];
                            [self.tableView scrollToRowAtIndexPath:newIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        }
                    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                        _formView.submitButton.enabled = YES;
                        
                        if (error.code == NSURLErrorCancelled) return ;
                        
                        NSString *alertMessage = @"发布评论失败。";
                        if (error.domain == NSURLErrorDomain && error.code == kCFURLErrorTimedOut)
                            alertMessage = @"网络超时";
                        
                        
                        NSLog(@"Hit error: %@", error);
                   }];
}


@end
