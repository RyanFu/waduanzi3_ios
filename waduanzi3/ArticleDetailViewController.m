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


@interface ArticleDetailViewController ()
{
    DTAttributedTextView *_coreTextView;
}
- (DTAttributedTextCell *)tableView:(UITableView *)tableView preparedCellForIndexPath:(NSIndexPath *)indexPath;
@end

@implementation ArticleDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [DTAttributedTextContentView setLayerClass:[DTTiledLayerWithoutFade class]];
    self.title = @"查看新闻";
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

    DTAttributedTextCell *cell = [self.tableView dequeueReusableCellWithIdentifier:detailViewCellIdentifier];
    if (cell == nil) {
        cell = [[DTAttributedTextCell alloc] initWithReuseIdentifier:detailViewCellIdentifier];
        cell.textDelegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.attributedTextContextView.shouldDrawImages = YES;
        
        cell.attributedTextContextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        cell.attributedTextContextView.edgeInsets = UIEdgeInsetsMake(15.0f, 10.0f, 15.0f, 10.0f);
    }

    NSString *csspath = [[NSBundle mainBundle] pathForResource:@"default" ofType:@"css"];
    NSString *defaultCss = [NSString stringWithContentsOfFile:csspath encoding:NSUTF8StringEncoding error:nil];
    DTCSSStylesheet *styleSheet = [[DTCSSStylesheet alloc] initWithStyleBlock:defaultCss];
    NSDictionary *builderOptions = @{
                                     DTDefaultFontFamily: FZLTHK_FONT_FAMILY,
                                     DTDefaultFontSize:[NSNumber numberWithFloat:detailFontSize],
                                     DTDefaultLineHeightMultiplier: @"1.5f",
                                     DTDefaultTextColor: [UIColor colorWithRed:0.20f green:0.20f blue:0.20f alpha:1.00f],
                                     DTDefaultStyleSheet: styleSheet
                                     };
    NSData *htmlData = [self.post.content_html dataUsingEncoding:NSUTF8StringEncoding];
    DTHTMLAttributedStringBuilder *stringBuilder = [[DTHTMLAttributedStringBuilder alloc] initWithHTML:htmlData
                                                                                               options:builderOptions
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
    if ([attachment isKindOfClass:[DTImageTextAttachment class]]) {
//        NSLog(@"contentURL: %@, x:%f, y:%f, w:%f, h:%f", attachment.contentURL,frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        
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
            if (receivedSize == expectedSize) {
                [weakLoadingView stopAnimating];
            }
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            [weakLoadingView stopAnimating];
        }];
        
        return imageView;
    }
    else
        return nil;
}

@end


