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
#import "WCAlertView.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "PostDetailViewController.h"
#import "CDRestClient.h"
#import "CDPostTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "CDConfig.h"
#import "ImageDetailViewController.h"

@interface PostListViewController ()
- (void) setupTableView;
- (void) setupAdView;
- (void) setCellSubViews:(CDPostTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void) setupTableViewPullScrollView;
- (void) setupTableViewInfiniteScrollView;
@end

@implementation PostListViewController

@synthesize tableView = _tableView;
@synthesize adView = _adView;

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
    NSLog(@"method: PostListViewController initData");
}

- (NSDictionary *) latestStatusesParameters
{
    [NSException raise:@"Invoked abstract method" format:@"Invoked abstract method"];
    return nil;
}

- (NSDictionary *) moreStatusesParameters
{
    [NSException raise:@"Invoked abstract method" format:@"Invoked abstract method"];
    return nil;
}

- (NSString *) latestStatusesRestPath
{
    [NSException raise:@"Invoked abstract method" format:@"Invoked abstract method"];
    return nil;
}

- (NSString *) moreStatusesRestPath
{
    [NSException raise:@"Invoked abstract method" format:@"Invoked abstract method"];
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor grayColor];
    self.viewDeckController.delegate = self;
    
    [self setupTableView];
    [self setupAdView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackToSubscriptions.png"]
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(openLeftSlideView:)];
    [self setupTableViewPullScrollView];
    [self setupTableViewInfiniteScrollView];
    
    if (_statuses.count == 0) {
        NSLog(@"count = 0, data from remote");
        [self.tableView triggerPullToRefresh];
    }
    else
        NSLog(@"count > 0, data from cache");
}



#pragma mark - viewDeckControllerDelegate

- (void)viewDeckController:(IIViewDeckController *)viewDeckController willOpenViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated
{
    self.tableView.userInteractionEnabled = NO;
    NSLog(@"will open");
}

- (void)viewDeckController:(IIViewDeckController *)viewDeckController didCloseViewSide:(IIViewDeckSide)viewDeckSide animated:(BOOL)animated
{
    self.tableView.userInteractionEnabled = YES;
    NSLog(@"did close");
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
    _tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feed_table_bg.jpg"]];
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
    self.viewDeckController.panningMode = IIViewDeckNavigationBarOrOpenCenterPanning;
    [super viewWillAppear:animated];
    
    BOOL enableAdvert = [CDConfig enabledAdvert];
    CGRect tableViewFrame = self.view.bounds;
//    NSLog(@"h: %f", tableViewFrame.size.height);
    if (enableAdvert) {
        tableViewFrame.size.height -= AD_BANNER_HEIGHT;
        [self setupAdView];
    }
    else {
        [self.adView removeFromSuperview];
        self.adView = nil;
    }
    _tableView.frame = tableViewFrame;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.viewDeckController.panningMode = IIViewDeckNoPanning;
}

- (void) setupTableViewPullScrollView
{
    __weak PostListViewController *weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf loadLatestStatuses];
    }];

    [self.tableView.pullToRefreshView setTitle:@"下拉刷新" forState:SVPullToRefreshStateStopped];
    [self.tableView.pullToRefreshView setTitle:@"载入中" forState:SVPullToRefreshStateLoading];
    [self.tableView.pullToRefreshView setTitle:@"释放立即刷新" forState:SVPullToRefreshStateTriggered];
}

- (void) setupTableViewInfiniteScrollView
{
    __weak PostListViewController *weakSelf = self;
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMoreStatuses];
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
    cell.authorTextLabel.text = post.author_name;
    cell.datetimeTextLabel.text = post.create_time_at;
    
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:post.user.small_avatar] placeholderImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
    
    if (post.small_pic.length > 0) {
        cell.imageView.tag = indexPath.row;
        NSURL *imageUrl = [NSURL URLWithString:post.small_pic];
        UIImage *placeImage = [UIImage imageNamed:@"thumb_placeholder.png"];
        [cell.imageView setImageWithURL:imageUrl placeholderImage:placeImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            ;
        }];
        cell.textLabel.text = nil;
    }
    else {
        cell.textLabel.text = post.title;
        cell.imageView.image = nil;
    }
    
    cell.upButton.tag = cell.commentButton.tag = indexPath.row;
    [cell.upButton setTitle:[post.up_count stringValue] forState:UIControlStateNormal];
    NSString *commentButtonText = [post.comment_count integerValue] > 0 ? [post.comment_count stringValue] : @"抢沙发";
    [cell.commentButton setTitle:commentButtonText forState:UIControlStateNormal];
    
    
    post = nil;
//    NSLog(@"state: %d", cell.upButton.state);
    return cell;
}

- (void) setCellSubViews:(CDPostTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.padding = POST_LIST_CELL_PADDING;
    cell.thumbSize = CGSizeMake(THUMB_WIDTH, THUMB_HEIGHT);
    
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.authorTextLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    cell.datetimeTextLabel.font = [UIFont systemFontOfSize:12.0f];

    cell.upButton.imageEdgeInsets = cell.commentButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5.0f);
    cell.upButton.titleEdgeInsets = cell.commentButton.titleEdgeInsets = UIEdgeInsetsMake(0, 8.0f, 0, 0);
    cell.upButton.titleLabel.font = cell.commentButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    cell.upButton.adjustsImageWhenHighlighted = cell.commentButton.adjustsImageWhenHighlighted = NO;
    
    [cell.upButton setImage:[UIImage imageNamed:@"mqz_feed_like.png"] forState:UIControlStateNormal];
    [cell.upButton setImage:[UIImage imageNamed:@"mqz_feed_like_disable.png"] forState:UIControlStateDisabled];
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

#pragma mark - cell buttion event selector


- (void) upButtonTouchUpInside:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSLog(@"state: %d", button.state);
    button.enabled = NO;
    button.userInteractionEnabled = NO;
//    __weak UIButton *weakButton = button;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{    
        // 不管成不成功都加1
        CDPost *post = [_statuses objectAtIndex:button.tag];
        post.up_count = [NSNumber numberWithInteger:[post.up_count integerValue]+1];
        [_statuses replaceObjectAtIndex:button.tag withObject:post];
        [button setTitle:[post.up_count stringValue] forState:UIControlStateNormal];
        
        RKObjectManager *objectManager = [RKObjectManager sharedManager];
        NSString *restPath = [NSString stringWithFormat:@"/post/support/%d", [post.post_id integerValue]];
        [objectManager.HTTPClient putPath:restPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"response: %@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@", error);
        }];
    });
}

- (void) commentButtonTouchUpInside:(id)sender
{
    NSLog(@"comment button clicked");
    UIButton *btn = (UIButton *)sender;
    [btn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    CDPost *post = [_statuses objectAtIndex:btn.tag];
    PostDetailViewController *detailViewController = [[PostDetailViewController alloc] initWithPost:post];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag inSection:0];
    CDPostTableViewCell *cell = (CDPostTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (cell.imageView.image != nil)
        detailViewController.smallImage = cell.imageView.image;
    detailViewController.commentMode = YES;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}


#pragma mark - Table view delegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDPost *post = [_statuses objectAtIndex:indexPath.row];
    
    CGFloat contentWidth = self.view.frame.size.width - POST_AVATAR_WIDTH - POST_LIST_CELL_PADDING*3;
    UIFont *titleFont = [UIFont systemFontOfSize:16.0f];
    CGSize titleLabelSize = [post.title sizeWithFont:titleFont
                                   constrainedToSize:CGSizeMake(contentWidth, 9999.0)
                                       lineBreakMode:UILineBreakModeWordWrap];
    
    UIFont *detailFont = [UIFont systemFontOfSize:16.0f];
    CGSize detailLabelSize = [[post summary] sizeWithFont:detailFont
                                      constrainedToSize:CGSizeMake(contentWidth, 9999.0)
                                          lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat cellHeight = POST_LIST_CELL_PADDING + POST_AVATAR_WIDTH + detailLabelSize.height + POST_LIST_CELL_PADDING + CELL_BUTTON_HEIGHT;
    if (post.small_pic.length > 0)
        cellHeight += THUMB_HEIGHT + POST_LIST_CELL_PADDING;
    else
        cellHeight +=  titleLabelSize.height + POST_LIST_CELL_PADDING;
    
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDPost *post = [_statuses objectAtIndex:indexPath.row];
    PostDetailViewController *detailViewController = [[PostDetailViewController alloc] initWithPost:post];
    CDPostTableViewCell *cell = (CDPostTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if (cell.imageView.image != nil)
        detailViewController.smallImage = cell.imageView.image;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - selector

- (void) openLeftSlideView:(id) sender
{
    [self.viewDeckController toggleLeftViewAnimated:YES];
}

#pragma mark - load data

- (void) latestStatusesSuccess:(RKObjectRequestOperation *)operation mappingResult:(RKMappingResult *)result
{
    [NSException raise:@"Invoked abstract method" format:@"Invoked abstract method"];
}

- (void) latestStatusesFailed:(RKObjectRequestOperation *)operation error:(NSError *)error
{
    NSLog(@"method: PostListViewController latestStatusesFailed:error:");
    [WCAlertView showAlertWithTitle:@"出错啦" message:@"载入数据出错。" customizationBlock:^(WCAlertView *alertView) {
        alertView.style = WCAlertViewStyleWhite;
    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
        if (buttonIndex == 1)
            [self loadLatestStatuses];
    } cancelButtonTitle:@"关闭" otherButtonTitles:@"重试",nil];
    NSLog(@"Hit error: %@", error);
}

- (void) moreStatusesSuccess:(RKObjectRequestOperation *)operation mappingResult:(RKMappingResult *)result
{
    [NSException raise:@"Invoked abstract method" format:@"Invoked abstract method"];
}

- (void) moreStatusesFailed:(RKObjectRequestOperation *)operation error:(NSError *)error
{
    [WCAlertView showAlertWithTitle:@"出错啦"
                            message:@"载入数据出错。"
                 customizationBlock:^(WCAlertView *alertView) {
                     
                     alertView.style = WCAlertViewStyleWhite;
                     
                 } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                     if (buttonIndex == 1)
                         [self loadLatestStatuses];
                 } cancelButtonTitle:@"关闭" otherButtonTitles:@"重试",nil];
    NSLog(@"Hit error: %@", error);
}

- (void)loadLatestStatuses
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager getObjectsAtPath:[self latestStatusesRestPath]
                         parameters:[self latestStatusesParameters]
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                [self.tableView.pullToRefreshView stopAnimating];
                                if ([self respondsToSelector:@selector(latestStatusesSuccess:mappingResult:)])
                                    [self performSelector:@selector(latestStatusesSuccess:mappingResult:) withObject:operation withObject:mappingResult];
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                [self.tableView.pullToRefreshView stopAnimating];
                                if ([self respondsToSelector:@selector(latestStatusesFailed:error:)])
                                    [self performSelector:@selector(latestStatusesFailed:error:) withObject:operation withObject:error];
                                NSLog(@"Hit error: %@", error);
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
                                if ([self respondsToSelector:@selector(moreStatusesFailed:error:)])
                                    [self performSelector:@selector(moreStatusesFailed:error:) withObject:operation withObject:error];
                                NSLog(@"Hit error: %@", error);
                            }];
    
}

@end
