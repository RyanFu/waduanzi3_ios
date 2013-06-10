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

@interface PostListViewController ()
- (void) initData;
- (void)loadLatestStatuses;
- (void)loadMoreStatuses;
- (NSDictionary *) latestStatusesParameters;
- (NSDictionary *) moreStatusesParameters;
- (void) setCellSubViews:(CDPostTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@implementation PostListViewController

- (void) initData
{
    _statuses = [NSMutableArray array];
    _parameters = [NSMutableDictionary dictionary];
    _channelID = 1;
    _mediaType = 0;
    _lasttime = 0;
    _maxtime = 0;
    
}

- (id) initWithStyle:(UITableViewStyle)style andChanneID:(NSInteger)channelID andMediaType:(NSInteger)mediaType
{
    self = [super initWithStyle:style];
    if (self) {
        [self initData];
        _channelID = channelID;
        _mediaType = mediaType;
        
        _restPath = @"/post/timeline";
    }
    return self;
}

- (NSDictionary *) latestStatusesParameters
{
    if (_statuses.count > 0) {
        CDPost *firstPost = [_statuses objectAtIndex:0];
        _lasttime = [firstPost.create_time integerValue];
    }
    
    NSString *channel_id = [NSString stringWithFormat:@"%d", 1];
    NSString *media_type = [NSString stringWithFormat:@"%d", _mediaType];
    NSString *last_time = [NSString stringWithFormat:@"%d", _lasttime];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:channel_id forKey:@"channel_id"];
    [params setObject:media_type forKey:@"media_type"];
    [params setObject:last_time forKey:@"lasttime"];
    
    return [CDRestClient requestParams:params];
}

- (NSDictionary *) moreStatusesParameters
{
    if (_statuses.count > 0) {
        CDPost *lastPost = [_statuses lastObject];
        _maxtime = [lastPost.create_time integerValue];
    }
    
    NSString *channel_id = [NSString stringWithFormat:@"%d", 1];
    NSString *media_type = [NSString stringWithFormat:@"%d", _mediaType];
    NSString *max_time = [NSString stringWithFormat:@"%d", _maxtime];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:channel_id forKey:@"channel_id"];
    [params setObject:media_type forKey:@"media_type"];
    [params setObject:max_time forKey:@"maxtime"];
    
    return [CDRestClient requestParams:params];;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *swipGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwips:)];
    swipGestureRecognizer.delegate = self;
    swipGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    swipGestureRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:swipGestureRecognizer];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(openLeftSlideView:)];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
    __block PostListViewController *blockSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [blockSelf loadLatestStatuses];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [blockSelf loadMoreStatuses];
    }];
    
    [self.tableView triggerPullToRefresh];
}

- (void) handleSwips:(UISwipeGestureRecognizer *)recognizer
{
    NSLog(@"direction: %d", recognizer.direction);
    if (recognizer.direction & UISwipeGestureRecognizerDirectionRight)
        [self.viewDeckController openLeftViewAnimated:YES];
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
        
        [self setCellSubViews:cell forRowAtIndexPath:indexPath];
    }
    
    CDPost *post = [_statuses objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = post.content;
    cell.authorTextLabel.text = post.author_name;
    
    cell.datetimeTextLabel.text = post.create_time_at;
    
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:post.user.mini_avatar] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    if (post.small_pic.length > 0) {
        NSURL *imageUrl = [NSURL URLWithString:post.small_pic];
        UIImage *placeImage = [UIImage imageNamed:@"thumb_placeholder"];
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
    NSLog(@"state: %d", cell.upButton.state);
    return cell;
}

- (void) setCellSubViews:(CDPostTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.padding = CELL_PADDING;
    cell.thumbSize = CGSizeMake(THUMB_WIDTH, THUMB_HEIGHT);
    
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.textLabel.textColor = [UIColor colorWithRed:0.01f green:0.01f blue:0.01f alpha:1.00f];
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:0.01f green:0.01f blue:0.01f alpha:1.00f];
    
    cell.authorTextLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    cell.authorTextLabel.textColor = [UIColor colorWithRed:0.37f green:0.75f blue:0.51f alpha:1.00f];
    
    cell.datetimeTextLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.datetimeTextLabel.textColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f];
    
    
    
    cell.upButton.contentEdgeInsets = cell.commentButton.contentEdgeInsets = UIEdgeInsetsMake(3, 0, 3, 0);
    cell.upButton.imageEdgeInsets = cell.commentButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 7);
    cell.upButton.titleEdgeInsets = cell.commentButton.titleEdgeInsets = UIEdgeInsetsMake(2, 7, 0, 0);
    cell.upButton.titleLabel.font = cell.commentButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.upButton.layer.borderWidth = cell.commentButton.layer.borderWidth = 1.0f;
    cell.upButton.layer.borderColor = cell.commentButton.layer.borderColor = [[UIColor colorWithRed:0.83f green:0.83f blue:0.83f alpha:0.70f] CGColor];
    cell.upButton.layer.cornerRadius = cell.commentButton.layer.cornerRadius = 6.0f;
    cell.upButton.backgroundColor = cell.commentButton.backgroundColor = [UIColor whiteColor];
    
    cell.upButton.adjustsImageWhenHighlighted = NO;
    cell.commentButton.adjustsImageWhenHighlighted = NO;
    
    [cell.upButton setImage:[UIImage imageNamed:@"avatar_placeholder"] forState:UIControlStateNormal];
    [cell.upButton setTitleColor:[UIColor colorWithRed:0.73f green:0.73f blue:0.73f alpha:1.00f] forState:UIControlStateNormal];
    [cell.upButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [cell.upButton addTarget:self action:@selector(cellButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [cell.upButton addTarget:self action:@selector(upButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.commentButton setImage:[UIImage imageNamed:@"avatar_placeholder"] forState:UIControlStateNormal];
    [cell.commentButton setTitleColor:[UIColor colorWithRed:0.73f green:0.73f blue:0.73f alpha:1.00f] forState:UIControlStateNormal];
    [cell.commentButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [cell.commentButton addTarget:self action:@selector(cellButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [cell.commentButton addTarget:self action:@selector(commentButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - cell buttion event selector

- (void) cellButtonTouchDown:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
//    NSLog(@"up button down : %d", button.tag);
    NSLog(@"%d, %d, %d, %d, %d, %d", UIControlStateNormal, UIControlStateHighlighted, UIControlStateDisabled, UIControlStateSelected, UIControlStateReserved, UIControlStateApplication);
    NSLog(@"state: %d", button.state);
}

- (void) upButtonTouchUpInside:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSLog(@"state: %d", button.state);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [button setHighlighted:YES];
        button.userInteractionEnabled = NO;
    });

    
    
    // 不管成不成功都加1
    CDPost *post = [_statuses objectAtIndex:button.tag];
    post.up_count = [NSNumber numberWithInteger:[post.up_count integerValue]+1];
    [_statuses replaceObjectAtIndex:button.tag withObject:post];
    [button setTitle:[post.up_count stringValue] forState:UIControlStateNormal];
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[post.post_id stringValue], @"post_id", nil];

    [objectManager.HTTPClient putPath:@"/post/up" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

- (void) commentButtonTouchUpInside:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [btn setBackgroundColor:[UIColor colorWithRed:0.37f green:0.75f blue:0.49f alpha:1.00f]];
    NSLog(@"comment button clicked");
}


#pragma mark - Table view delegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDPost *post = [_statuses objectAtIndex:indexPath.row];
    
    CGFloat contentWidth = self.view.frame.size.width - CELL_PADDING*2;
    UIFont *titleFont = [UIFont systemFontOfSize:16.0f];
    CGSize titleLabelSize = [post.title sizeWithFont:titleFont
                                   constrainedToSize:CGSizeMake(contentWidth, 9999.0)
                                       lineBreakMode:UILineBreakModeWordWrap];
    
    UIFont *detailFont = [UIFont systemFontOfSize:16.0f];
    CGSize detailLabelSize = [post.content sizeWithFont:detailFont
                                      constrainedToSize:CGSizeMake(contentWidth, 9999.0)
                                          lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat cellHeight = CELL_PADDING + POST_AVATAR_WIDTH + detailLabelSize.height + CELL_PADDING + CELL_BUTTON_HEIGHT;
    if (post.small_pic.length > 0)
        cellHeight += THUMB_HEIGHT + CELL_PADDING;
    else
        cellHeight +=  titleLabelSize.height + CELL_PADDING;
    
    return cellHeight + CELL_PADDING;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDPost *post = [_statuses objectAtIndex:indexPath.row];
    PostDetailViewController *detailViewController = [[PostDetailViewController alloc] initWithStyle:UITableViewStylePlain andPost:post];
    CDPostTableViewCell *cell = (CDPostTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
//    detailViewController.smallImage = cell.imageView.image;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - selector

- (void) openLeftSlideView:(id) sender
{
    [self.viewDeckController toggleLeftViewAnimated:YES];
}

#pragma mark - load data
- (void)loadLatestStatuses
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager getObjectsAtPath:_restPath
                         parameters:[self latestStatusesParameters]
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                [self.tableView.pullToRefreshView stopAnimating];
                                
                                if (mappingResult.count > 0) {
                                    NSMutableArray* statuses = (NSMutableArray *)[mappingResult array];
    //                                NSLog(@"Loaded statuses: %@", statuses);
                                    _statuses = statuses;
                                    
                                    if (self.isViewLoaded)
                                        [self.tableView reloadData];
                                }
                                else {
                                    NSLog(@"没有更多内容了");
                                }
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                [self.tableView.pullToRefreshView stopAnimating];
                                
                                [WCAlertView showAlertWithTitle:@"出错啦" message:@"载入数据出错。" customizationBlock:^(WCAlertView *alertView) {
                                                 
                                     alertView.style = WCAlertViewStyleWhite;
                                                 
                                 } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                                     if (buttonIndex == 1)
                                         [self loadLatestStatuses];
                                 } cancelButtonTitle:@"关闭" otherButtonTitles:@"重试",nil];
                                NSLog(@"Hit error: %@", error);
                            }];

}

- (void)loadMoreStatuses
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager getObjectsAtPath:_restPath
                         parameters:[self moreStatusesParameters]
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                [self.tableView.infiniteScrollingView stopAnimating];
                                
                                if (mappingResult.count > 0) {
                                    NSArray* statuses = (NSArray *)[mappingResult array];
//                                    NSLog(@"Loaded statuses: %@", statuses);
                                    NSInteger currentCount = [_statuses count];
                                    [_statuses addObjectsFromArray:statuses];
                                    
                                    NSMutableArray *insertIndexPaths = [NSMutableArray array];
                                    for (int i=0; i<statuses.count; i++) {
                                        [insertIndexPaths addObject:[NSIndexPath indexPathForRow:currentCount+i inSection:0]];
                                    }
                                    
                                    [self.tableView beginUpdates];
                                    [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                                    [self.tableView endUpdates];
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
                                                     [self loadLatestStatuses];
                                             } cancelButtonTitle:@"关闭" otherButtonTitles:@"重试",nil];
                                NSLog(@"Hit error: %@", error);
                            }];
    
}

@end
