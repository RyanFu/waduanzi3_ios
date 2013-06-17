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


@interface PostDetailViewController ()
- (void) initData;
- (void) loadPostComments;
- (void) loadPostDetail;
- (NSDictionary *) commentsParameters;
- (void) setupTableView;
- (void) setupPostDetailViewInCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;
- (void) setCommentCellSubViews:(CDCommentTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void) supportComment:(NSInteger) index;
- (void) copyComment:(NSInteger) index;
- (void) reportComment:(NSInteger) index;
- (void) setupTableViewPullAndInfiniteScrollView;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTableView];
    
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

- (void) setupTableView
{
    // setup tableView
    CGRect tableViewFrame = self.view.bounds;
    //    NSLog(@"h: %f", tableViewFrame.size.height);
    tableViewFrame.size.height -= NAVBAR_HEIGHT;
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void) setupTableViewPullAndInfiniteScrollView
{
    __block PostDetailViewController *blockSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [blockSelf loadPostDetail];
    }];
    [self.tableView.pullToRefreshView setTitle:@"下拉刷新" forState:SVPullToRefreshStateStopped];
    [self.tableView.pullToRefreshView setTitle:@"载入中" forState:SVPullToRefreshStateLoading];
    [self.tableView.pullToRefreshView setTitle:@"释放立即刷新" forState:SVPullToRefreshStateTriggered];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [blockSelf loadPostComments];
    }];
    
    CGRect infiniteViewFrame = CGRectMake(0, 0, self.tableView.frame.size.width, 30.0f);
    UILabel *stoppedLabel = [[UILabel alloc] initWithFrame:infiniteViewFrame];
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:infiniteViewFrame];
    UILabel *triggeredLabel = [[UILabel alloc] initWithFrame:infiniteViewFrame];
    stoppedLabel.textAlignment = loadingLabel.textAlignment = triggeredLabel.textAlignment = UITextAlignmentCenter;
    stoppedLabel.textColor = loadingLabel.textColor = triggeredLabel.textColor = [UIColor grayColor];
    stoppedLabel.font = loadingLabel.font = triggeredLabel.font = [UIFont systemFontOfSize:14.0f];
    NSInteger moreCommentCount = [_post.comment_count integerValue] - _comments.count;
    stoppedLabel.text = (moreCommentCount > 0) ? [NSString stringWithFormat:@"还有%d条评论", moreCommentCount] : @"没有更多啦";
//    [self.tableView.infiniteScrollingView setCustomView:stoppedLabel forState:SVInfiniteScrollingStateStopped];
    loadingLabel.text = @"加载中，请稍候...";
    [self.tableView.infiniteScrollingView setCustomView:loadingLabel forState:SVInfiniteScrollingStateLoading];
    triggeredLabel.text = @"加载更多";
    [self.tableView.infiniteScrollingView setCustomView:triggeredLabel forState:SVInfiniteScrollingStateTriggered];
}

- (void) handleSwips:(UISwipeGestureRecognizer *)recognizer
{
    NSLog(@"direction: %d", recognizer.direction);
    if (recognizer.direction & UISwipeGestureRecognizerDirectionRight)
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        CDComment *comment = [_comments objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = comment.content;
        cell.authorTextLabel.text = comment.author_name;
        cell.orderTextLabel.text = [NSString stringWithFormat:@"#%d", indexPath.row+1];
        [cell.avatarImageView setImageWithURL:[NSURL URLWithString:comment.user.mini_avatar] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
        
        comment = nil;
        
        return cell;
    }
    
}

- (void) setupPostDetailViewInCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    CDPostDetailView * detailView = [[CDPostDetailView alloc] initWithFrame:cell.contentView.bounds];
    detailView.padding = CELL_PADDING;
    
    CGFloat contentWidth = detailView.frame.size.width - CELL_PADDING * 2;
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
    detailView.imageSize = CGSizeMake(contentWidth, imageViewHeight);
    
    detailView.detailTextLabel.text = _post.content;
    detailView.authorTextLabel.text = _post.author_name;
    detailView.datetimeTextLabel.text = _post.create_time_at;
    [detailView.avatarImageView setImageWithURL:[NSURL URLWithString:_post.user.mini_avatar] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    if (_middleImage) {
        detailView.imageView.image = _middleImage;
        detailView.textLabel.text = nil;
    }
    else if (_post.middle_pic.length > 0) {
        if (_smallImage == nil)
            self.smallImage = [UIImage imageNamed:@"thumb_placeholder"];
        
        NSURL *imageUrl = [NSURL URLWithString:_post.middle_pic];
        __block PostDetailViewController *blockSelf = self;
        [detailView.imageView setImageWithURL:imageUrl placeholderImage:_smallImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            blockSelf.middleImage = image;
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
            [blockSelf.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            
        }];
        // 如果是趣图，不显示标题，只显示内容
        detailView.textLabel.text = nil;
    }
    else {
        detailView.textLabel.text = _post.title;
        detailView.imageView.image = nil;
    }
    
    detailView.upButton.tag = detailView.commentButton.tag = indexPath.row;
    [detailView.upButton setTitle:[_post.up_count stringValue] forState:UIControlStateNormal];
    NSString *commentButtonText = [_post.comment_count integerValue] > 0 ? [_post.comment_count stringValue] : @"抢沙发";
    [detailView.commentButton setTitle:commentButtonText forState:UIControlStateNormal];
    
    [cell.contentView addSubview:detailView];
}

- (void) setCommentCellSubViews:(CDCommentTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.padding = CELL_PADDING;
    
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
        CGFloat contentWidth = tableView.frame.size.width - CELL_PADDING*2;
        CGSize titleLabelSize = [_post.title sizeWithFont:[UIFont systemFontOfSize:16.0f]
                                       constrainedToSize:CGSizeMake(contentWidth, 9999.0)
                                           lineBreakMode:UILineBreakModeWordWrap];
        
        CGSize detailLabelSize = [_post.content sizeWithFont:[UIFont systemFontOfSize:16.0f]
                                          constrainedToSize:CGSizeMake(contentWidth, 9999.0)
                                              lineBreakMode:UILineBreakModeWordWrap];
        
        CGFloat cellHeight = CELL_PADDING + POST_AVATAR_WIDTH + CELL_PADDING + detailLabelSize.height + CELL_PADDING + CELL_BUTTON_HEIGHT;
        
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
            cellHeight += imageViewHeight + CELL_PADDING;
        else
            cellHeight += titleLabelSize.height + CELL_PADDING;
        
        return cellHeight + CELL_PADDING;
    }
    else if (indexPath.section == 1 && indexPath.row < _comments.count) {
        CDComment *comment = [_comments objectAtIndex:indexPath.row];
        
        CGFloat contentWidth = self.view.frame.size.width - CELL_PADDING*2;
        UIFont *detailFont = [UIFont systemFontOfSize:14.0f];
        CGSize detailLabelSize = [comment.content sizeWithFont:detailFont
                                          constrainedToSize:CGSizeMake(contentWidth, 9999.0)
                                              lineBreakMode:UILineBreakModeWordWrap];
        
        CGFloat cellHeight = CELL_PADDING + COMMENT_AVATAR_WIDTH + detailLabelSize.height + CELL_PADDING;
        
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
    return [[UIView alloc]init];
}

- (void) handleTableViewLongPress:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [recognizer locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
        if (indexPath == nil || indexPath.section == 0) return;
        
        CDComment *comment = [_comments objectAtIndex:indexPath.row];
        NSString *upText = [NSString stringWithFormat:@"顶[%d]", [comment.up_count integerValue]];
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                                         cancelButtonTitle:@"取消"
                                                    destructiveButtonTitle:nil
                                                         otherButtonTitles:upText, @"复制", @"举报", nil];
        actionSheet.tag = indexPath.row;
        [actionSheet showInView:self.navigationController.view];
    }
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
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
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[comment.comment_id stringValue], @"comment_id", nil];
    
    [objectManager.HTTPClient putPath:@"/comment/support" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[comment.comment_id stringValue], @"comment_id", nil];
    
    [objectManager.HTTPClient putPath:@"/comment/report" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                                    [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
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


@end
