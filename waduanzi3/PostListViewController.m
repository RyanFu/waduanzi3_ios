//
//  PostListViewController.m
//  waduanzi3
//
//  Created by chendong on 13-3-4.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <RestKit/RestKit.h>
#import "CDDefine.h"
#import "PostListViewController.h"
#import "IIViewDeckController.h"
#import "CDPost.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "FunnyDetailViewController.h"
#import "CDRestClient.h"
#import "CDPostTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "CDConfig.h"
#import "ImageDetailViewController.h"
#import "CDDataCache.h"
#import "CDAppUser.h"
#import "WBSuccessNoticeView+WaduanziMethod.h"
#import "WBErrorNoticeView+WaduanziMethod.h"
#import "PublishViewController.h"
#import "CDUserConfig.h"
#import "UMUFPHandleView.h"
#import "UMUFPBadgeView.h"
#import "FunnyDetailViewController.h"
#import "ArticleDetailViewController.h"
#import "MACAddress.h"

@interface PostListViewController ()
- (void) setupNavButtionItems;
- (void) setupTableView;
- (void) setupUMAppNetworkView;
- (void) setupAdView;
- (void) setCellSubViews:(CDPostTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void) setupTableViewPullScrollView;
- (void) setupTableViewInfiniteScrollView;
@end

@implementation PostListViewController

@synthesize tableView = _tableView;
@synthesize adView = _adView;
@synthesize forceRefresh = _forceRefresh;

- (id) init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    NSLog(@"method: PostListViewController init");
    return self;
}

- (void) initData
{
    _statuses = [NSMutableArray array];
    _parameters = [NSMutableDictionary dictionary];
    _channelID = CHANNEL_FUNNY;
    _mediaType = MEDIA_TYPE_MIXED;
    _lasttime = 0;
    _maxtime = 0;
    _requireLogined = NO;
    detailFontSize = [CDUserConfig shareInstance].postFontSize;
    NSLog(@"method: PostListViewController initData");
}

- (NSUInteger) userID
{
    NSInteger user_id = 0;
    if ([CDAppUser hasLogined]) {
        CDUser *user = [CDAppUser currentUser];
        user_id = [user.user_id integerValue];
    }
    return user_id;
}

- (void) subarrayWithMaxCount:(NSUInteger)count
{
    if (count > 0 && _statuses.count > count) {
        NSArray *maxCountStatuses = [_statuses subarrayWithRange:NSMakeRange(0, count)];
        [_statuses removeAllObjects];
        _statuses = [NSMutableArray arrayWithArray:maxCountStatuses];
    }
}

- (NSDictionary *) latestStatusesParameters
{
    [NSException raise:@"Invoked abstract method: latestStatusesParameters" format:@"Invoked abstract method"];
    return nil;
}

- (NSDictionary *) moreStatusesParameters
{
    [NSException raise:@"Invoked abstract method: moreStatusesParameters" format:@"Invoked abstract method"];
    return nil;
}

- (NSString *) latestStatusesRestPath
{
    [NSException raise:@"Invoked abstract method: latestStatusesRestPath" format:@"Invoked abstract method"];
    return nil;
}

- (NSString *) moreStatusesRestPath
{
    [NSException raise:@"Invoked abstract method: moreStatusesRestPath" format:@"Invoked abstract method"];
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor grayColor];
    
    [self setupNavButtionItems];
    [self setupTableView];

    [self setupTableViewPullScrollView];
    [self setupTableViewInfiniteScrollView];
    
    [self setupUMAppNetworkView];
    
    if (_statuses.count == 0) {
        NSLog(@"count = 0, data from remote");
        [_tableView triggerPullToRefresh];
    }
    else
        NSLog(@"count > 0, data from cache");
}

- (void) setupNavButtionItems
{
    UIImage *launcherImage = [UIImage imageNamed:@"NavBarIconLauncher.png"];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, launcherImage.size.width + 20.0f, launcherImage.size.height);
    [leftButton setImage:launcherImage forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"NavBarIconLauncherHighlighted.png"] forState:UIControlStateSelected];
    [leftButton addTarget:self action:@selector(openLeftSlideView:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.showsTouchWhenHighlighted = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];

    UIImage *composeImage = [UIImage imageNamed:@"mqz_lbs_poi_refresh.png"];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, composeImage.size.width + 20.0f, composeImage.size.height);
    [rightButton setImage:composeImage forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(refreshLatestPosts:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.showsTouchWhenHighlighted = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

- (void) refreshLatestPosts:(id)sender
{
    if (self.tableView.pullToRefreshView) {
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        [self.tableView triggerPullToRefresh];
    }
}


#pragma mark - viewDeckControllerDelegate

- (BOOL) viewDeckController:(IIViewDeckController *)viewDeckController shouldOpenViewSide:(IIViewDeckSide)viewDeckSide
{
    self.tableView.userInteractionEnabled = NO;
    CDLog(@"should open");
    return YES;
}

- (void)viewDeckController:(IIViewDeckController *)viewDeckController willCloseViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated
{
    self.tableView.userInteractionEnabled = YES;
    CDLog(@"will close");
}

- (void) viewDeckController:(IIViewDeckController *)viewDeckController didCloseViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated
{
    self.tableView.userInteractionEnabled = YES;
    CDLog(@"did close");
}

- (void) setupTableView
{
    // setup tableView
    CGRect tableViewFrame = self.view.bounds;
//    NSLog(@"h: %f", tableViewFrame.size.height);
    tableViewFrame.size.height -= NAVBAR_HEIGHT;
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor underPageBackgroundColor];
    _tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pullToRefreshBg.png"]];
}


/**
 设置友盟应用联盟，左下方的小把手
 */
- (void) setupUMAppNetworkView
{
    if (![CDConfig enabledUMHandle])
        return;
    
    @try {
        _mHandleView = [[UMUFPHandleView alloc] initWithFrame:CGRectMake(0, _tableView.bounds.size.height - 64.0f, 32.0f, 64.0f)
                                                       appKey:UMAPPNETWORK_APPKEY
                                                       slotId:nil
                                        currentViewController:self];
        [self.view addSubview:_mHandleView];
        _mHandleView.mContentType = ContentTypeApp;
        _mHandleView.delegate = self;
        _mHandleView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        [_mHandleView setHandleViewBackgroundImage:[UIImage imageNamed:@"umeng_ad_handle.png"]];
        CGRect badgeFrame = _mHandleView.mBadgeView.frame;
        badgeFrame.origin.x = 7.5f;
        _mHandleView.mBadgeView.frame = badgeFrame;
        [_mHandleView requestPromoterDataInBackground];
    }
    @catch (NSException *exception) {
        CDLog(@"setup umeng app network exception: %@", exception);
    }
    @finally {
        CDLog(@"setup umeng app network success");
    }
}


- (void) setupAdView
{
    CGRect tableViewFrame = self.view.bounds;
    CGRect adViewFrame = CGRectMake(0, tableViewFrame.origin.y + tableViewFrame.size.height, self.view.bounds.size.width, AD_BANNER_HEIGHT);
    self.adView = [[UIView alloc] initWithFrame:adViewFrame];
    [self.view addSubview:self.adView];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    BOOL enableAdvert = [CDConfig enabledAdvert];
    CGRect tableViewFrame = self.view.bounds;
//    NSLog(@"h: %f", tableViewFrame.size.height);
    if (enableAdvert) {
        tableViewFrame.size.height -= AD_BANNER_HEIGHT;
        if (self.adView == nil)
            [self setupAdView];
        else
            self.adView.hidden = NO;
    }
    else if (self.adView != nil) {
        self.adView.hidden = YES;
    }
    _tableView.frame = tableViewFrame;
    
    CGFloat newDetailFontSize = [CDUserConfig shareInstance].postFontSize;
    if (newDetailFontSize != detailFontSize) {
        detailFontSize = newDetailFontSize;
        [self.tableView reloadData];
    }
    
    // 如果允许显示小把手，但检查小把手的显示状态，如果是隐藏了，侧显示出来
    if ([CDConfig enabledUMHandle]) {
        if ([_mHandleView isKindOfClass:[UMUFPHandleView class]] && _mHandleView.hidden) {
            _mHandleView.hidden = NO;
            [_mHandleView requestPromoterDataInBackground];
        }
    }
    else if ([_mHandleView isKindOfClass:[UMUFPHandleView class]] && !_mHandleView.hidden)
        _mHandleView.hidden = YES;
}


- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (_noticeView != nil)
        [_noticeView dismissNotice];
}


- (void) setupTableViewPullScrollView
{
    __weak PostListViewController *weakSelf = self;
    __block BOOL _weakRequireLogined = _requireLogined;
    [self.tableView addPullToRefreshWithActionHandler:^{
        CDLog(@"requiredLogined: %d, hasLogined: %d", _weakRequireLogined, [CDAppUser hasLogined]);
        
        if (![CDRestClient checkNetworkStatus]) {
            [weakSelf.tableView.pullToRefreshView stopAnimating];
            return;
        }
        
        if (!_weakRequireLogined || [CDAppUser hasLogined])
            [weakSelf loadLatestStatuses];
        else {
            [weakSelf.tableView.pullToRefreshView stopAnimating];
            [CDAppUser requiredLogin];
        }
    }];

    [self.tableView.pullToRefreshView setTitle:@"下拉刷新" forState:SVPullToRefreshStateStopped];
    [self.tableView.pullToRefreshView setTitle:@"载入中" forState:SVPullToRefreshStateLoading];
    [self.tableView.pullToRefreshView setTitle:@"释放立即刷新" forState:SVPullToRefreshStateTriggered];
}

- (void) setupTableViewInfiniteScrollView
{
    __weak PostListViewController *weakSelf = self;
    __block BOOL _weakRequireLogined = _requireLogined;
    __weak NSMutableArray *_weakStatuses = _statuses;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        if (![CDRestClient checkNetworkStatus]) {
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
            return;
        }
        
        if (!_weakRequireLogined || [CDAppUser hasLogined]) {
            if (_weakStatuses.count == 0)
                [weakSelf.tableView.infiniteScrollingView stopAnimating];
            else
                [weakSelf loadMoreStatuses];
        }
        else {
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
            [CDAppUser requiredLogin];
        }
        
     
    }];
    
    CGRect infiniteViewFrame = CGRectMake(0, 0, self.tableView.frame.size.width, 40.0f);
    UILabel *stoppedLabel = [[UILabel alloc] initWithFrame:infiniteViewFrame];
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:infiniteViewFrame];
    UILabel *triggeredLabel = [[UILabel alloc] initWithFrame:infiniteViewFrame];
    stoppedLabel.textAlignment = loadingLabel.textAlignment = triggeredLabel.textAlignment = UITextAlignmentCenter;
    stoppedLabel.textColor = loadingLabel.textColor = triggeredLabel.textColor = [UIColor grayColor];
    stoppedLabel.font = loadingLabel.font = triggeredLabel.font = [UIFont systemFontOfSize:14.0f];
    stoppedLabel.backgroundColor = loadingLabel.backgroundColor = triggeredLabel.backgroundColor = [UIColor clearColor];
    
    stoppedLabel.text = @"向上滑动载入更多";
//    [self.tableView.infiniteScrollingView setCustomView:stoppedLabel forState:SVInfiniteScrollingStateStopped];
    loadingLabel.text = @"加载中，请稍候...";
    [self.tableView.infiniteScrollingView setCustomView:loadingLabel forState:SVInfiniteScrollingStateLoading];
    triggeredLabel.text = @"加载更多";
    [self.tableView.infiniteScrollingView setCustomView:triggeredLabel forState:SVInfiniteScrollingStateTriggered];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_statuses count];
}

- (CDPostTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"PostCell";
    CDPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (nil == cell) {
        cell = [[CDPostTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
        cell.delegate = self;
        cell.tag = indexPath.row;
        [self setCellSubViews:cell forRowAtIndexPath:indexPath];
    }
    
    CDPost *post = [_statuses objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [post summary];
//    cell.detailTextLabel.font = [UIFont systemFontOfSize:detailFontSize];
    cell.detailTextLabel.font = cell.textLabel.font = [UIFont fontWithName:FZLTHK_FONT_NAME size:detailFontSize];
    cell.authorTextLabel.text = post.author_name;
    cell.datetimeTextLabel.text = post.create_time_at;
    
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:post.user.small_avatar] placeholderImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
    
    if (post.small_pic.length > 0) {
        cell.imageView.tag = indexPath.row;
        cell.isAnimatedGIF = [post isAnimatedGIF];
        cell.isLongImage = [post isLongImage];
        NSURL *imageUrl = [NSURL URLWithString:post.small_pic];
        UIImage *placeImage = [UIImage imageNamed:@"thumb_placeholder.png"];
        [cell.imageView setImageWithURL:imageUrl placeholderImage:placeImage options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            ;
        }];
        cell.textLabel.text = nil;
    }
    else {
        cell.textLabel.text = post.title;
        cell.imageView.image = nil;
        cell.isAnimatedGIF = NO;
        cell.isLongImage = NO;
    }
    
    cell.upButton.tag = cell.commentButton.tag = indexPath.row;
    cell.upButton.enabled = ![[CDDataCache shareCache] fetchPostLikeState:[post.post_id integerValue]];
    [cell.upButton setTitle:[post.up_count stringValue] forState:UIControlStateNormal];
    NSString *commentButtonText = [post.comment_count integerValue] > 0 ? [post.comment_count stringValue] : @"抢沙发";
    [cell.commentButton setTitle:commentButtonText forState:UIControlStateNormal];
    
    post = nil;
    
    return cell;
}

- (void) setCellSubViews:(CDPostTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.thumbSize = CGSizeMake(THUMB_WIDTH, THUMB_HEIGHT);
    
    cell.authorTextLabel.font = [UIFont fontWithName:FZLTHK_FONT_NAME size:16.0f];
    cell.datetimeTextLabel.font = [UIFont systemFontOfSize:12.0f];

    cell.upButton.imageEdgeInsets = cell.commentButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5.0f);
    cell.upButton.titleEdgeInsets = cell.commentButton.titleEdgeInsets = UIEdgeInsetsMake(0, 8.0f, 0, 0);
    cell.upButton.titleLabel.font = cell.commentButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    cell.upButton.adjustsImageWhenHighlighted = cell.commentButton.adjustsImageWhenHighlighted = NO;
    
    [cell.upButton setImage:[UIImage imageNamed:@"mqz_feed_like_disable.png"] forState:UIControlStateNormal];
    [cell.upButton setImage:[UIImage imageNamed:@"mqz_feed_like.png"] forState:UIControlStateDisabled];
    [cell.upButton setTitleColor:[UIColor colorWithRed:0.45f green:0.51f blue:0.64f alpha:1.00f] forState:UIControlStateNormal];
    [cell.upButton addTarget:self action:@selector(upButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];

    [cell.commentButton setImage:[UIImage imageNamed:@"mqz_feed_comment_normal.png"] forState:UIControlStateNormal];
    [cell.commentButton setTitleColor:[UIColor colorWithRed:0.45f green:0.51f blue:0.64f alpha:1.00f] forState:UIControlStateNormal];
    [cell.commentButton addTarget:self action:@selector(commentButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - CDPostTableViewCellDelegate

- (void) thumbImageViewDidTapFinished:(UITapGestureRecognizer *)gestureRecognizer
{
    UIImageView *imageView = (UIImageView *)gestureRecognizer.view;
    CDPost *post = [_statuses objectAtIndex:imageView.tag];
    NSURL *originaUrl = [NSURL URLWithString:post.middle_pic];
    ImageDetailViewController *imageViewController = [[ImageDetailViewController alloc] init];
    imageViewController.thumbnail = imageView.image;
    imageViewController.originalPicUrl = originaUrl;
    
    [self presentModalViewController:imageViewController animated:NO];
}

#pragma mark - cell buttion event selector


- (void) upButtonTouchUpInside:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSLog(@"state: %d", button.state);
    
    // 不管成不成功都当做成功处理
    button.enabled = NO;
    CDPost *post = [_statuses objectAtIndex:button.tag];
    post.up_count = [NSNumber numberWithInteger:[post.up_count integerValue] + 1];
    [_statuses replaceObjectAtIndex:button.tag withObject:post];
    [button setTitle:[post.up_count stringValue] forState:UIControlStateNormal];
    [[CDDataCache shareCache] cachePostLikeState:YES forPostID:[post.post_id integerValue]];
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    NSString *restPath = [NSString stringWithFormat:@"/post/support/%d", [post.post_id integerValue]];
    [objectManager.HTTPClient putPath:restPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

- (void) commentButtonTouchUpInside:(id)sender
{
    NSLog(@"comment button clicked");
    UIButton *btn = (UIButton *)sender;
    [btn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    CDPost *post = [_statuses objectAtIndex:btn.tag];
    
    if (post.channel_id.integerValue == CHANNEL_FUNNY) {
        FunnyDetailViewController *funnyDetailViewController = [[FunnyDetailViewController alloc] initWithPost:post];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag inSection:0];
        CDPostTableViewCell *cell = (CDPostTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        if (cell.imageView.image != nil)
            funnyDetailViewController.smallImage = cell.imageView.image;
        funnyDetailViewController.commentMode = YES;
        
        [self.navigationController pushViewController:funnyDetailViewController animated:YES];
    }
    else if (post.channel_id.integerValue == CHANNEL_FOCUS) {
        ArticleDetailViewController *articleDetailViewController = [[ArticleDetailViewController alloc] initWithPost:post];
        articleDetailViewController.commentMode = YES;
        
        [self.navigationController pushViewController:articleDetailViewController animated:YES];
    }
}


#pragma mark - Table view delegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDPost *post = [_statuses objectAtIndex:indexPath.row];
    
    CGFloat contentWidth = self.view.frame.size.width - POST_LIST_CELL_CONTENT_MARGIN.left - POST_LIST_CELL_CONTENT_MARGIN.right - POST_LIST_CELL_CONTENT_PADDING.left - POST_LIST_CELL_CONTENT_PADDING.right;
    CGSize titleLabelSize = [post.title sizeWithFont:[UIFont fontWithName:FZLTHK_FONT_NAME size:16.0f]
                                   constrainedToSize:CGSizeMake(contentWidth, 9999.0)
                                       lineBreakMode:UILineBreakModeCharacterWrap];
    
    CGSize detailLabelSize = [[post summary] sizeWithFont:[UIFont fontWithName:FZLTHK_FONT_NAME size:detailFontSize]
                                      constrainedToSize:CGSizeMake(contentWidth, 9999.0)
                                          lineBreakMode:UILineBreakModeCharacterWrap];
    
    CGFloat cellHeight = POST_LIST_CELL_CONTENT_MARGIN.top + POST_LIST_CELL_CONTENT_PADDING.top + POST_AVATAR_SIZE.height + POST_LIST_CELL_FRAGMENT_PADDING + detailLabelSize.height + POST_LIST_CELL_FRAGMENT_PADDING + CELL_BUTTON_HEIGHT;
    
    if (post.small_pic.length > 0)
        cellHeight += THUMB_HEIGHT + POST_LIST_CELL_FRAGMENT_PADDING;
    else
        cellHeight +=  titleLabelSize.height + POST_LIST_CELL_FRAGMENT_PADDING;
    
    cellHeight += POST_LIST_CELL_CONTENT_PADDING.bottom + POST_LIST_CELL_CONTENT_MARGIN.bottom;
    
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        CDPost *post = [_statuses objectAtIndex:indexPath.row];
        FunnyDetailViewController *detailViewController = [[FunnyDetailViewController alloc] initWithPost:post];
        CDPostTableViewCell *cell = (CDPostTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        if (cell.imageView.image != nil)
            detailViewController.smallImage = cell.imageView.image;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    @catch (NSException *exception) {
        CDLog(@"exception: %@", exception);
    }
    @finally {
        ;
    }
}

#pragma mark - barButtionItem selector

- (void) openLeftSlideView:(id) sender
{
    [self.viewDeckController toggleLeftViewAnimated:YES];
}

- (void) openPublishViewController:(id)sender
{
    PublishViewController *publishController = [[PublishViewController alloc] init];
    [ROOT_CONTROLLER presentViewController:publishController animated:YES completion:nil];
}

#pragma mark - load data

- (void) latestStatusesSuccess:(RKObjectRequestOperation *)operation mappingResult:(RKMappingResult *)result
{
    [NSException raise:@"Invoked abstract method" format:@"Invoked abstract method"];
}

- (void) latestStatusesFailed:(RKObjectRequestOperation *)operation error:(NSError *)error
{
    CDLog(@"method: PostListViewController latestStatusesFailed:error:");
    
    NSString *noticeMessage = @"载入最新段子出错";
    if (error.code == kCFURLErrorTimedOut)
        noticeMessage = @"网络超时";
    _noticeView = [WBErrorNoticeView showErrorNoticeView:self.view title:@"提示" message:noticeMessage sticky:NO delay:2.0f dismissedBlock:nil];
    
    CDLog(@"Hit error: %@", error);
}

- (void) moreStatusesSuccess:(RKObjectRequestOperation *)operation mappingResult:(RKMappingResult *)result
{
    [NSException raise:@"Invoked abstract method" format:@"Invoked abstract method"];
}

- (void) moreStatusesFailed:(RKObjectRequestOperation *)operation error:(NSError *)error
{
    NSString *noticeMessage = @"载入更多段子出错";
    if (error.code == kCFURLErrorTimedOut)
        noticeMessage = @"网络超时";
    _noticeView = [WBErrorNoticeView showErrorNoticeView:self.view title:@"提示" message:noticeMessage sticky:NO delay:2.0f dismissedBlock:nil];
    
    CDLog(@"Hit error: %@", error);
}

- (void)loadLatestStatuses
{
    // Load the object model via RestKit
    self.navigationItem.rightBarButtonItem.enabled = NO;
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager getObjectsAtPath:[self latestStatusesRestPath]
                         parameters:[self latestStatusesParameters]
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                self.navigationItem.rightBarButtonItem.enabled = YES;
                                [self.tableView.pullToRefreshView stopAnimating];
                                
                                if ([self respondsToSelector:@selector(latestStatusesSuccess:mappingResult:)])
                                    [self performSelector:@selector(latestStatusesSuccess:mappingResult:) withObject:operation withObject:mappingResult];
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                self.navigationItem.rightBarButtonItem.enabled = YES;
                                [self.tableView.pullToRefreshView stopAnimating];
                                
                                if (error.code == NSURLErrorCancelled) return ;
                                
                                if ([self respondsToSelector:@selector(latestStatusesFailed:error:)])
                                    [self performSelector:@selector(latestStatusesFailed:error:) withObject:operation withObject:error];
                                CDLog(@"Hit error: %@", error);
                            }];
    
}

- (void)loadMoreStatuses
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager getObjectsAtPath:[self moreStatusesRestPath]
                         parameters:[self moreStatusesParameters]
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                [self.tableView.infiniteScrollingView stopAnimating];
                                
                                if ([self respondsToSelector:@selector(moreStatusesSuccess:mappingResult:)])
                                    [self performSelector:@selector(moreStatusesSuccess:mappingResult:) withObject:operation withObject:mappingResult];
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                [self.tableView.infiniteScrollingView stopAnimating];
                                
                                if (error.code == NSURLErrorCancelled) return ;
                                
                                if ([self respondsToSelector:@selector(moreStatusesFailed:error:)])
                                    [self performSelector:@selector(moreStatusesFailed:error:) withObject:operation withObject:error];
                                CDLog(@"Hit error: %@", error);
                            }];
    
}

#pragma mark - UMUFPHandleViewDelegate

- (void) didClickedPromoterAtIndex:(UMUFPHandleView *)handleView index:(NSInteger)promoterIndex promoterData:(NSDictionary *)promoterData
{
    @try {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:promoterData];
        [params setObject:OPEN_UDID forKey:@"open_udid"];
        [params setObject:APP_VERSION forKey:@"waduanzi_version"];
        [params setObject:macAddress() forKey:@"mac_address"];
        
        CDLog(@"index:%d, data:%@", promoterIndex, params);
        
        RKObjectManager *objectManager = [RKObjectManager sharedManager];
        [objectManager.HTTPClient postPath:@"/ad/click" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            CDLog(@"ad click response data: %@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            CDLog(@"ad click error: %@", error);
        }];
    }
    @catch (NSException *exception) {
        CDLog(@"ad click exception: %@", exception);
    }
    @finally {
        ;
    }
    
}

@end
