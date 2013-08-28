//
//  FunnyDetailViewController.m
//  waduanzi3
//
//  Created by chendong on 13-8-25.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "FunnyDetailViewController.h"
#import "CDPostToolBar.h"
#import "CDPost.h"
#import "CDPostDetailView.h"
#import "ImageDetailViewController.h"
#import "UIImageView+WebCache.h"

@interface FunnyDetailViewController ()
{
    CDPostDetailView *_detailView;
}
- (void) setupPostDetailViewInCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;
- (void) setupPostDetailViewInCellData:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;
@end

@implementation FunnyDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = @"查看笑话";
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.rightBarButtonItem.enabled = (self.post.middle_pic.length == 0) || self.middleImage;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 取消当前大图片下载进程
    [_detailView.imageView cancelCurrentImageLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *) setupPostDetailViewCell:(NSIndexPath *)indexPath
{
    static NSString *PostDetailCellIdentifier = @"PostDetailCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:PostDetailCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PostDetailCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    [self setupPostDetailViewInCell:cell indexPath:indexPath];
    [self setupHUDInView:cell];
    [self setupPostDetailViewInCellData:cell indexPath:indexPath];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView detailViewCellheightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat contentWidth = tableView.frame.size.width - POST_DETAIL_CELL_PADDING*2;
    CGSize titleLabelSize = [self.post.title sizeWithFont:[UIFont fontWithName:FZLTHK_FONT_NAME size:16.0f]
                                    constrainedToSize:CGSizeMake(contentWidth, 9999.0)
                                        lineBreakMode:UILineBreakModeWordWrap];
    
    CGSize detailLabelSize = [self.post.content sizeWithFont:[UIFont fontWithName:FZLTHK_FONT_NAME size:detailFontSize]
                                       constrainedToSize:CGSizeMake(contentWidth, 9999.0)
                                           lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat cellHeight = POST_DETAIL_CELL_PADDING + POST_AVATAR_SIZE.height + POST_DETAIL_CELL_PADDING + detailLabelSize.height;
    
    CGFloat imageViewHeight = 0;
    if (self.middleImage) {
        CGSize middleImageSize = CGSizeMake(self.middleImage.size.width / 2, self.middleImage.size.height / 2);
        // 引处按照将图片宽度全部拉伸为contentWidth
        imageViewHeight =  contentWidth * middleImageSize.height / middleImageSize.width;
    }
    else if (self.smallImage) {
        CGSize smallImageSize = CGSizeMake(self.smallImage.size.width / 2, self.smallImage.size.height / 2);
        imageViewHeight =  contentWidth * smallImageSize.height / smallImageSize.width;
    }
    else if (self.post.middle_pic.length > 0)
        imageViewHeight = THUMB_HEIGHT;
    
    if (imageViewHeight > 0)
        cellHeight += imageViewHeight + POST_DETAIL_CELL_PADDING;
    else
        cellHeight += titleLabelSize.height + POST_DETAIL_CELL_PADDING;
    
    return cellHeight + POST_DETAIL_CELL_PADDING * 2;
}

- (void) setupPostDetailViewInCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    [_detailView removeFromSuperview];
    _detailView = nil;
    _detailView = [[CDPostDetailView alloc] initWithFrame:cell.contentView.bounds];
    _detailView.detailTextLabel.font = _detailView.textLabel.font = [UIFont fontWithName:FZLTHK_FONT_NAME size:detailFontSize];
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
    if (self.middleImage) {
        CGSize middleImageSize = CGSizeMake(self.middleImage.size.width / 2, self.middleImage.size.height / 2);
        // 引处按照将图片宽度全部拉伸为contentWidth
        imageViewHeight =  contentWidth * middleImageSize.height / middleImageSize.width;
    }
    else if (self.smallImage) {
        CGSize smallImageSize = CGSizeMake(self.smallImage.size.width / 2, self.smallImage.size.height / 2);
        imageViewHeight =  contentWidth * smallImageSize.height / smallImageSize.width;
    }
    else
        imageViewHeight = DETAIL_THUMB_HEIGHT;
    _detailView.imageSize = CGSizeMake(contentWidth, imageViewHeight);
    _detailView.detailTextLabel.text = self.post.content;
    _detailView.authorTextLabel.text = self.post.author_name;
    _detailView.datetimeTextLabel.text = self.post.create_time_at;
    [_detailView.avatarImageView setImageWithURL:[NSURL URLWithString:self.post.user.small_avatar] placeholderImage:[UIImage imageNamed:@"avatar_placeholder.png"]];
    
    if (self.middleImage) {
        _detailView.imageView.image = self.middleImage;
        _detailView.textLabel.text = nil;
    }
    else if (self.post.middle_pic.length > 0) {
        if (self.smallImage == nil)
            self.smallImage = [UIImage imageNamed:@"thumb_placeholder.png"];
        
        __weak PostDetailViewController *weakSelf = self;
        __weak MBProgressHUD *weakHUD = _HUD;
        __weak UIImageView *weakImageView = _detailView.imageView;
        __weak CDPostToolBar *weakToolbar = _postToolbar;
        @try {
            NSURL *imageUrl = [NSURL URLWithString:self.post.middle_pic];
            [_detailView.imageView setImageWithURL:imageUrl placeholderImage:self.smallImage options:SDWebImageRetryFailed progress:^(NSUInteger receivedSize, long long expectedSize) {
                CDLog(@"expected size: %d/%lld", receivedSize, expectedSize);
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
                    weakSelf.navigationItem.rightBarButtonItem.enabled = weakToolbar.actionButton.enabled = YES;
                }
            }];
        }
        @catch (NSException *exception) {
            [weakImageView cancelCurrentImageLoad];
            CDLog(@"download big image exception: %@", exception);
        }
        @finally {
            ;
        }
        // 如果是趣图，不显示标题，只显示内容
        _detailView.textLabel.text = nil;
    }
    else {
        _detailView.textLabel.text = self.post.title;
        _detailView.imageView.image = nil;
    }
}

- (void) showFullscreenImage:(UITapGestureRecognizer *) recognizer
{
    ImageDetailViewController *imageViewController = [[ImageDetailViewController alloc] init];
    imageViewController.thumbnail = self.smallImage;
    imageViewController.originaPic = self.middleImage;
    imageViewController.originalPicUrl = [NSURL URLWithString:self.post.middle_pic];
    [self presentViewController:imageViewController animated:NO completion:NULL];
}

- (void) backButtonDidPressed:(id)sender
{
    [_detailView.imageView cancelCurrentImageLoad];
    [super backButtonDidPressed:sender];
}


@end

