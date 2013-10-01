//
//  ArticleDetailViewController.m
//  waduanzi3
//
//  Created by chendong on 13-8-25.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import "CDPost.h"
#import "UIImageView+WebCache.h"
#import "DTTiledLayerWithoutFade.h"
#import "UIView+Border.h"
#import "ImageDetailViewController.h"


@interface ArticleDetailViewController ()
{
    DTAttributedTextView *_coreTextView;
    NSCache *_cellCache;
}
- (DTAttributedTextCell *)tableView:(UITableView *)tableView preparedCellForIndexPath:(NSIndexPath *)indexPath;
@end

@implementation ArticleDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [DTAttributedTextContentView setLayerClass:[DTTiledLayerWithoutFade class]];
    self.title = @"查看详情";
    
    _cellCache = [[NSCache alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (DTAttributedTextCell *) setupPostDetailViewCell:(NSIndexPath *)indexPath
{
    DTAttributedTextCell *cell = [self tableView:self.tableView preparedCellForIndexPath:indexPath];
    
    return cell;
}

- (DTAttributedTextCell *)tableView:(UITableView *)tableView preparedCellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *detailViewCellIdentifier = @"PostDetailHtmlCell";
    
    NSString *cacheKey = [NSString stringWithFormat:@"attributed_text_cell_pid_%d", self.postID];
    DTAttributedTextCell *cell = [_cellCache objectForKey:cacheKey];

    if (!cell) {
        cell = [[DTAttributedTextCell alloc] initWithReuseIdentifier:detailViewCellIdentifier];
        cell.textDelegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.attributedTextContextView.shouldDrawImages = YES;
        
        cell.attributedTextContextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        cell.attributedTextContextView.edgeInsets = UIEdgeInsetsMake(15.0f, 10.0f, 15.0f, 10.0f);
        
        [_cellCache setObject:cell forKey:cacheKey];
    }

    NSString *csspath = [[NSBundle mainBundle] pathForResource:@"post_default" ofType:@"css"];
    NSString *defaultCss = [NSString stringWithContentsOfFile:csspath encoding:NSUTF8StringEncoding error:nil];
    DTCSSStylesheet *styleSheet = [[DTCSSStylesheet alloc] initWithStyleBlock:defaultCss];
    NSDictionary *buildeOptions = @{
                                     DTDefaultFontFamily: FZLTHK_FONT_FAMILY,
                                     DTDefaultFontSize:[NSNumber numberWithFloat:detailFontSize],
                                     DTDefaultTextColor: POST_TEXT_COLOR,
                                     DTDefaultStyleSheet: styleSheet
                                     };
    NSData *htmlData = [self.post.content_html dataUsingEncoding:NSUTF8StringEncoding];
    DTHTMLAttributedStringBuilder *stringBuilder = [[DTHTMLAttributedStringBuilder alloc] initWithHTML:htmlData
                                                                                               options:buildeOptions
                                                                                    documentAttributes:nil];
    
    cell.attributedString = [stringBuilder generatedAttributedString];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView detailViewCellheightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DTAttributedTextCell *cell = [self tableView:tableView preparedCellForIndexPath:indexPath];

    return [cell requiredRowHeightInTableView:tableView];
}

- (UIView *) attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
    CDLog(@"post content html: %@, attachement: %@", self.post.content_html, attachment.class);
    if ([attachment isKindOfClass:[DTImageTextAttachment class]]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.layer.cornerRadius = 3.0f;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.clipsToBounds = YES;
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((frame.size.width-30)/2, (frame.size.height-30)/2, 30, 30)];
        loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        loadingView.hidesWhenStopped = YES;
        [imageView addSubview:loadingView];
        
        [loadingView startAnimating];
        __weak UIActivityIndicatorView *weakLoadingView = loadingView;
        [imageView setImageWithURL:attachment.contentURL placeholderImage:[UIImage imageNamed:@"thumb_placeholder.png"] options:SDWebImageRetryFailed progress:^(NSUInteger receivedSize, long long expectedSize) {
            ;
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            [weakLoadingView stopAnimating];
        }];
        
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thumbImageDidTapFinished:)];
        tapRecognizer.numberOfTapsRequired = 1;
        [imageView addGestureRecognizer:tapRecognizer];
        
        return imageView;
    }
    else if ([attachment isKindOfClass:[DTIframeTextAttachment class]]) {
        CDLog(@"video frame: %@, %@", NSStringFromCGRect(frame), attachment.contentURL);
        return nil;
    }
    else if ([attachment isKindOfClass:[DTVideoTextAttachment class]]) {
        return nil;
    }
    else
        return nil;
}

- (BOOL) videoView:(DTWebVideoView *)videoView shouldOpenExternalURL:(NSURL *)url
{
    return NO;
}

- (void)thumbImageDidTapFinished:(UITapGestureRecognizer *)recognizer
{
    UIImageView *imageView = (UIImageView *)recognizer.view;
    ImageDetailViewController *imageViewController = [[ImageDetailViewController alloc] init];
    imageViewController.thumbnail = imageView.image;
    imageViewController.originaPic = imageView.image;
    // TODO: 这里需要再详细处理，或需要做成点击之后可以多图片查看的视图
//    imageViewController.originalPicUrl = [NSURL URLWithString:self.post.middle_pic];
    
    [ROOT_CONTROLLER presentViewController:imageViewController animated:NO completion:nil];
}

@end


