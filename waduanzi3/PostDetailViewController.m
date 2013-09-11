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
#import "UserLoginViewController.h"
#import "UMSocial.h"
#import "WBErrorNoticeView+WaduanziMethod.h"
#import "CDUserConfig.h"

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
- (void) setupTableViewPullAndInfiniteScrollView;
- (void) setupCommentFormView;
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
    [self setupTableViewPullAndInfiniteScrollView];
    [self.tableView triggerInfiniteScrolling];
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 设置键盘显示和隐藏的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 移除键盘显示和隐藏的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
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
    formViewFrame.origin.y = self.view.frame.origin.y + self.view.frame.size.height - COMMENT_FORM_HEIGHT;
    NSLog(@"yyy: %f", self.view.frame.size.height);
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
    tableViewFrame.size.height -= (self.navigationController.navigationBar.frame.size.height + TOOLBAR_HEIGHT);
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

- (void) setupTableViewPullAndInfiniteScrollView
{
    __weak PostDetailViewController *weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadPostComments];
    }];
}

- (void) setupCommentFormView
{
    CGRect formFrame = CGRectMake(0, self.view.frame.size.height - COMMENT_FORM_HEIGHT - NAVBAR_HEIGHT, CDSCREEN_SIZE.width, COMMENT_FORM_HEIGHT);
    _formView = [[CDCommentFormView alloc] initWithFrame:formFrame];
    [self.view addSubview:_formView];
    [_formView.submitButton addTarget:self action:@selector(submitButtonTouhcInUpside:) forControlEvents:UIControlEventTouchUpInside];
    _formView.textField.delegate = self;

    NSLog(@"comment form, height: %f", self.view.frame.size.height);
}

- (void) commentTextFieldBecomeFirstResponder
{
    [_formView.textField becomeFirstResponder];
}

#pragma mark - CDCommentFormView selector

- (void) submitButtonTouhcInUpside:(UIButton *)button
{
    if (_formView.textField.text.length == 0)
        return;
    NSLog(@"send comment");
    button.enabled = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self sendComment];
        _formView.textField.text = nil;
    });
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length == 0)
        return NO;
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self sendComment];
            textField.text = nil;
        });

        return YES;
    }
}

#pragma mark - bottom bar button selector

- (void) backButtonDidPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) likeButtonDidPressed:(id)sender
{
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
        return;
    }
    
    CDUser *user = [CDAppUser currentUser];
    NSString *userID = [user.user_id stringValue];
    
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
    
    NSString *identifier = [NSString stringWithFormat:@"post_social_share_%@", _post.post_id];
    UMSocialData *socialData = [[UMSocialData alloc] initWithIdentifier:identifier withTitle:_post.title];
    socialData.shareText = _post.content;
    
    if (_middleImage) {
        socialData.shareImage = _middleImage;
    }
    else if (_post.middle_pic.length > 0) {
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:_post.middle_pic];
        socialData.urlResource = urlResource;
    }
    
    UMSocialExtConfig *extConfig = [[UMSocialExtConfig alloc] init];
    socialData.extConfig = extConfig;
    extConfig.title = _post.title;
    extConfig.mailMessage = _post.content;
    extConfig.wxDescription = _post.content;
    extConfig.appUrl = _post.url;
    if (_middleImage || _post.middle_pic.length > 0) {
        extConfig.thumbUrl = _post.middle_pic;
        extConfig.wxMessageType = UMSocialWXMessageTypeOther;
        WXWebpageObject *webpageObject = [WXWebpageObject object];
        webpageObject.webpageUrl = _post.url;
        extConfig.wxMediaObject = webpageObject;
    }
    else
        extConfig.wxMessageType = UMSocialWXMessageTypeText;

    UMSocialControllerService *socialDataService = [[UMSocialControllerService alloc] initWithUMSocialData:socialData];
    socialDataService.socialUIDelegate = self;
    __weak PostDetailViewController *weakSelf = self;
    UMSocialIconActionSheet *iconActionSheet = [socialDataService getSocialIconActionSheetInController:weakSelf];
    [iconActionSheet showInView: self.navigationController.view];
}

#pragma mark - socialUIDelegate

- (void) didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    NSLog(@"share response: %@", response);
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
        cell.textLabel.font = [UIFont systemFontOfSize:commentFontSize];
        
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
    if (actionSheet.tag == FORWARD_ACTIONSHEET_TAG) {
        switch (buttonIndex) {
            case 0:
                break;
            case 1:
                [self performSelector:@selector(socialShareToSina)];
                break;
            case 4:
                [self performSelector:@selector(socialShareToWeichatSession)];
                break;
            case 5:
                [self performSelector:@selector(socialShareToWeichatTimeline)];
                break;
            default:
                break;
        }
        
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

#pragma mark - sns share selector

- (void) socialShareToSina
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    snsPlatform.loginClickHandler(self, [UMSocialControllerService defaultControllerService], YES, ^(UMSocialResponseEntity *response){
        NSLog(@"response is %@",response);
    });
}

- (void) socialShareToWeichatSession
{
    UMSocialIconActionSheet *iconActionSheet = [[UMSocialControllerService defaultControllerService] getSocialIconActionSheetInController:self];
    [iconActionSheet showInView:self.view];
    
//    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
//    snsPlatform.loginClickHandler(self, [UMSocialControllerService defaultControllerService], YES, ^(UMSocialResponseEntity *response){
//        NSLog(@"response is %@",response);
//    });
}

- (void) socialShareToWeichatTimeline
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatTimeline];
    snsPlatform.loginClickHandler(self, [UMSocialControllerService defaultControllerService], YES, ^(UMSocialResponseEntity *response){
        NSLog(@"response is %@",response);
    });
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
    
    [self.view endEditing:YES];
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
                        if (error.code == kCFURLErrorTimedOut)
                            alertMessage = @"网络超时";
                        
                        [WCAlertView showAlertWithTitle:@"出错啦"
                                               message:alertMessage
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
