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
#import "CDSession.h"
#import "WBSuccessNoticeView+WaduanziMethod.h"
#import "WBErrorNoticeView+WaduanziMethod.h"
#import "PublishViewController.h"
#import "CDUserConfig.h"
#import "UMUFPHandleView.h"
#import "UMUFPBadgeView.h"
#import "FunnyDetailViewController.h"
#import "ArticleDetailViewController.h"
#import "MACAddress.h"
#import "CDWebVideoViewController.h"
#import "CDVideo.h"
#import "CDAdvertTableViewCell.h"
#import "CDKit.h"
#import "UIImage+ColorImage.h"
#import "CDNavigationController.h"
#import "UIView+Border.h"
#import "MobClick.h"

@interface PostListViewController ()
- (void) setupNavButtonItems;
- (void) setupTableView;
- (void) setupUMAppNetworkView;
- (void) setupAdView;
- (void) setPostCellSubViews:(CDPostTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void) setAdvertCellSubViews:(CDAdvertTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void) setupTableViewPullScrollView;
- (void) setupTableViewInfiniteScrollView;
- (CDPostTableViewCell *)tableView:(UITableView *)tableView preparedPostCellForIndexPath:(NSIndexPath *)indexPath;
- (CDAdvertTableViewCell *)tableView:(UITableView *)tableView preparedAdvertCellForIndexPath:(NSIndexPath *)indexPath;
- (void) didVideoSelectRowAtIndex:(NSInteger)index;
@end

@implementation PostListViewController

@synthesize tableView = _tableView;
@synthesize adView = _adView;
@synthesize forceRefresh = _forceRefresh;
@synthesize statuses = _statuses;
@synthesize networkStatus = _networkStatus;

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
    _networkStatus = CURRENT_NETWORK_STATUS;
    NSLog(@"method: PostListViewController initData");
}

- (NSUInteger) userID
{
    NSInteger user_id = 0;
    if ([[CDSession shareInstance] hasLogined]) {
        CDUser *user = [[CDSession shareInstance] currentUser];
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

- (BOOL) networkStatusChanged
{
    return _networkStatus != CURRENT_NETWORK_STATUS;
}

- (BOOL) textFontSizeChanged
{
    return detailFontSize != [CDUserConfig shareInstance].postFontSize;
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
    self.view.backgroundColor = [UIColor whiteColor];
    
    _cellCache = [[NSCache alloc] init];
    
    [self setupNavButtonItems];
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

- (void) setupNavButtonItems
{
    UIImage *launcherImage = [UIImage imageNamed:@"NavBarIconLauncher.png"];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, launcherImage.size.width + 20.0f, launcherImage.size.height);
    [leftButton setImage:launcherImage forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"NavBarIconLauncherHighlighted.png"] forState:UIControlStateSelected];
    [leftButton addTarget:self action:@selector(openLeftSlideView:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.showsTouchWhenHighlighted = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];

    UIImage *refreshImage = [UIImage imageNamed:@"navBar_refresh.png"];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, refreshImage.size.width + 20.0f, refreshImage.size.height);
    [rightButton setImage:refreshImage forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(refreshLatestPosts:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.showsTouchWhenHighlighted = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

- (void) refreshLatestPosts:(id)sender
{
    if (self.tableView.pullToRefreshView) {
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
        [self.tableView triggerPullToRefresh];
    }
}

- (void) setupTableView
{
    // setup tableView
    CGRect tableViewFrame = self.view.bounds;

    if (OS_VERSION_LESS_THAN(@"7.0"))
        tableViewFrame.size.height -= NAVBAR_HEIGHT;
    else
        tableViewFrame.size.height -= (NAVBAR_HEIGHT + STATUSBAR_HEIGHT);
    
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
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
    
    if ([self networkStatusChanged]) {
        CDLog(@"network status has changed");
        _networkStatus = [RKObjectManager sharedManager].HTTPClient.networkReachabilityStatus;
        [self.tableView reloadData];
    }
    else
        CDLog(@"network status has not changed");
    
    if ([self textFontSizeChanged]) {
        CDLog(@"post text font size has changed");
        detailFontSize = [CDUserConfig shareInstance].postFontSize;
        [self.tableView reloadData];
    }
    else
        CDLog(@"post text font size has changed");
    
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CDLog(@"viewDidAppear");
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
        CDLog(@"requiredLogined: %d, hasLogined: %d", _weakRequireLogined, [[CDSession shareInstance] hasLogined]);
        
        if (!_weakRequireLogined || [[CDSession shareInstance] hasLogined])
            [weakSelf loadLatestStatuses];
        else {
            [weakSelf.tableView.pullToRefreshView stopAnimating];
            [[CDSession shareInstance] requiredLogin];
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

    [self.tableView addInfiniteScrollingWithActionHandler:^{
        NSLog(@"statuses count: %d",weakSelf.statuses.count);

        if (!_weakRequireLogined || [[CDSession shareInstance] hasLogined]) {
            if (weakSelf.statuses.count == 0)
                [weakSelf.tableView.infiniteScrollingView stopAnimating];
            else
                [weakSelf loadMoreStatuses];
        }
        else {
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
            [[CDSession shareInstance] requiredLogin];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:tableView preparedPostCellForIndexPath:indexPath];
    
    // TODO: 此处是处理广告cell，此版本暂时注释
//    [self tableView:tableView preparedAdvertCellForIndexPath:indexPath];
}

- (CDAdvertTableViewCell *)tableView:(UITableView *)tableView preparedAdvertCellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"AdvertCell";
    
    CDPost *post = [_statuses objectAtIndex:indexPath.row];
    
    NSString *cacheKey = [NSString stringWithFormat:@"post_list_advert_cell_id_%d", post.post_id.intValue];
    CDAdvertTableViewCell *cell = [_cellCache objectForKey:cacheKey];
    
    if (!cell) {
        cell = [[CDAdvertTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
        cell.delegate = self;
        [self setAdvertCellSubViews:cell forRowAtIndexPath:indexPath];
        
        [_cellCache setObject:cell forKey:cacheKey];
    }
    
    cell.tag = cell.imageView.tag = indexPath.row;
    cell.appNameLabel.text = post.title;
    cell.detailTextLabel.text = [post summary];
    cell.detailTextLabel.font = cell.textLabel.font = [UIFont fontWithName:FZLTHK_FONT_NAME size:detailFontSize];
    cell.authorTextLabel.text = post.author_name;
    cell.textLabel.text = nil;
    
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:post.user.small_avatar] placeholderImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
    
    if (post.small_pic.length > 0) {
        NSURL *imageUrl = [NSURL URLWithString:post.small_pic];
        UIImage *placeImage = [UIImage imageNamed:@"thumb_placeholder.png"];
        [cell.imageView setImageWithURL:imageUrl placeholderImage:placeImage options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            ;
        }];
    }
    else {
        cell.textLabel.text = post.title;
        cell.imageView.image = nil;
    }
    
    post = nil;
    
    return cell;
}

- (CDPostTableViewCell *)tableView:(UITableView *)tableView preparedPostCellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"PostCell";
    
    CDPost *post = [_statuses objectAtIndex:indexPath.row];
    
    NSString *cacheKey = [NSString stringWithFormat:@"post_list_post_cell_pid_%d", post.post_id.intValue];
    CDPostTableViewCell *cell = [_cellCache objectForKey:cacheKey];
    
    if (!cell) {
        cell = [[CDPostTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
        cell.delegate = self;
        [self setPostCellSubViews:cell forRowAtIndexPath:indexPath];
        
        [_cellCache setObject:cell forKey:cacheKey];
    }

    cell.isVideo = [post.video isKindOfClass:[CDVideo class]];
    cell.tag = cell.imageView.tag = indexPath.row;
    cell.detailTextLabel.text = [post summary];
    cell.detailTextLabel.font = cell.textLabel.font = [UIFont fontWithName:FZLTHK_FONT_NAME size:detailFontSize];
    cell.authorTextLabel.text = post.author_name;
    cell.datetimeTextLabel.text = post.create_time_at;
    cell.textLabel.text = nil;
    
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:post.user.small_avatar] placeholderImage:[UIImage imageNamed:@"avatar_placeholder.png"]];

    
    if (post.small_pic.length > 0) {
        cell.isAnimatedGIF = [post isAnimatedGIF];
        cell.isLongImage = [post isLongImage];
        
        cell.thumbSize = CGSizeMake(THUMB_WIDTH, THUMB_HEIGHT);
        NSString *imageUrlString = post.small_pic;
        if (NETWORK_STATUS_IS_WIFI) {
            cell.thumbSize = [post picSizeByWidth:[cell contentBlockWidth]];
            imageUrlString = post.middle_pic;
            cell.showLongIcon = cell.showGIFIcon = NO;
        }
        else {
            cell.showLongIcon = cell.showGIFIcon = YES;
        }
        
        NSURL *imageUrl = [NSURL URLWithString:imageUrlString];
        UIImage *placeImage = [UIImage imageNamed:@"thumb_placeholder.png"];
        [cell.imageView setImageWithURL:imageUrl placeholderImage:placeImage options:SDWebImageRetryFailed progress:^(NSUInteger receivedSize, long long expectedSize) {
            CDLog(@"receivedSize/expectedSize: %d/%lld", receivedSize, expectedSize);
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            CDLog(@"image download finished.");
        }];
    }
    else if (cell.isVideo) {
        cell.isAnimatedGIF = cell.isLongImage = NO;
        cell.thumbSize = VIDEO_THUMB_SIZE;
        cell.imageView.image = [UIImage imageWithColor:[UIColor blackColor] size:VIDEO_THUMB_SIZE];
    }
    else {
        cell.textLabel.text = post.title;
        cell.imageView.image = nil;
        cell.isAnimatedGIF = NO;
        cell.isLongImage = NO;
        cell.isVideo = NO;
    }

    cell.upButton.tag = cell.commentButton.tag = indexPath.row;
    cell.upButton.enabled = ![[CDDataCache shareCache] fetchPostLikeState:[post.post_id integerValue]];
    [cell.upButton setTitle:[post.up_count stringValue] forState:UIControlStateNormal];
    NSString *commentButtonText = [post.comment_count integerValue] > 0 ? [post.comment_count stringValue] : @"抢沙发";
    [cell.commentButton setTitle:commentButtonText forState:UIControlStateNormal];
    
    post = nil;
    
    return cell;
}

- (void) setAdvertCellSubViews:(CDAdvertTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CDPost *post = [_statuses objectAtIndex:indexPath.row];
    
    cell.authorTextLabel.font = [UIFont fontWithName:FZLTHK_FONT_NAME size:16.0f];
}


- (void) setPostCellSubViews:(CDPostTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
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

- (void) videoImageViewDidTapFinished:(UITapGestureRecognizer *)gestureRecognizer
{
    UIImageView *imageView = (UIImageView *)gestureRecognizer.view;

    [self didVideoSelectRowAtIndex:imageView.tag];
}

- (void) advertImageViewDidTapFinished:(UITapGestureRecognizer *)gestureRecognizer
{
    UIImageView *imageView = (UIImageView *)gestureRecognizer.view;
    CDLog(@"advert clicked: %d", imageView.tag);
    
    
}

#pragma mark - SKStoreProductViewControllerDelegate

- (void) productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - cell buttion event selector


- (void) upButtonTouchUpInside:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSLog(@"state: %d", button.state);
    
    // 不管成不成功都当做成功处理
    button.enabled = NO;
    CDPost *post = [_statuses objectAtIndex:button.tag];
    
    NSDictionary *attributes = @{
                                 @"post_id": post.post_id,
                                 @"post_title": post.title
                                 };
    [MobClick event:UM_EVENT_LIKE_POST attributes:attributes];
    
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
    CDPostTableViewCell *cell = [self tableView:tableView preparedPostCellForIndexPath:indexPath];
    return [cell realHeight];
    
    // TODO: 此处是处理广告cell的高度，此版本暂时注释
//    CDAdvertTableViewCell *cell = [self tableView:tableView preparedAdvertCellForIndexPath:indexPath];
//    return [cell realHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: 此处是广告cell处理，此版本暂时注释
//    if (indexPath.row == 0) {
//        [CDKit openAppStoreByAppID:WADUANZI_APPLE_ID review:YES target:self delegate:self];
//        return;
//    }
    
    @try {
        CDPost *post = [_statuses objectAtIndex:indexPath.row];
        
        NSDictionary *attributes = @{
                                     @"post_id": post.post_id,
                                     @"post_title": post.title
                                     };
        [MobClick event:UM_EVENT_GOTO_COMMENT_LIST attributes:attributes];
        
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

- (void) didVideoSelectRowAtIndex:(NSInteger)index
{
    CDPost *post = [_statuses objectAtIndex:index];
    
    NSDictionary *attributes = @{
                                 @"post_id": post.post_id,
                                 @"post_title": post.title
                                 };
    [MobClick event:UM_EVENT_PLAY_VIDEO attributes:attributes];
    
    CDLog(@"source url: %@", post.video.source_url);
    CDWebVideoViewController *webVideoController = [[CDWebVideoViewController alloc] initWithUrl:post.video.source_url];
    [webVideoController setNavigationBarStyle:CDNavigationBarStyleBlue barButtonItemStyle:CDBarButtonItemStyleBlueBack toolBarStyle:CDToolBarStyleBlue];
    CDNavigationController *navWebVideoController = [[CDNavigationController alloc] initWithRootViewController:webVideoController];
    [ROOT_CONTROLLER presentViewController:navWebVideoController animated:YES completion:nil];
}

#pragma mark - barButtonItem selector

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
    _noticeView = [WBErrorNoticeView showErrorNoticeView:self.view title:@"提示" message:noticeMessage sticky:NO delay:1.0f dismissedBlock:nil];
    
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
    _noticeView = [WBErrorNoticeView showErrorNoticeView:self.view title:@"提示" message:noticeMessage sticky:NO delay:1.0f dismissedBlock:nil];
    
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
                                
                                if (error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled) return ;
                                
                                if (error.domain == NSURLErrorDomain && error.code == NSURLErrorNotConnectedToInternet) {
                                    _noticeView = [WBErrorNoticeView showErrorNoticeView:self.view title:@"提示" message:@"好像您的手机没有启用网络" sticky:NO delay:1.0f dismissedBlock:nil];
                                    
                                    return;
                                }
                                
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
                                
                                if (error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled) return ;
                                
                                if (error.domain == NSURLErrorDomain && error.code == NSURLErrorNotConnectedToInternet) {
                                    _noticeView = [WBErrorNoticeView showErrorNoticeView:self.view title:@"提示" message:@"好像您的手机没有启用网络" sticky:NO delay:1.0f dismissedBlock:nil];
                                    
                                    return;
                                }
                                
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
