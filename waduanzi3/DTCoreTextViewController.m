//
//  DTCoreTextViewController.m
//  waduanzi3
//
//  Created by chendong on 13-8-19.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <DTCoreText/DTCoreText.h>
#import <UIImageView+WebCache.h>
#import "DTCoreTextViewController.h"

@interface DTCoreTextViewController ()

@end

@implementation DTCoreTextViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _coreTextView = [[DTAttributedTextView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_coreTextView];
    _coreTextView.textDelegate = self;
    _coreTextView.scrollEnabled = YES;
    _coreTextView.userInteractionEnabled = YES;
    _coreTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"About" ofType:@"html"];
//    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSData *htmlData = [NSData dataWithContentsOfFile:filePath];
    
    NSDictionary *builderOptions = @{
                                     DTDefaultFontFamily: @"Helvetica"
                                     };
    DTHTMLAttributedStringBuilder *stringBuilder = [[DTHTMLAttributedStringBuilder alloc] initWithHTML:htmlData
                                                                                               options:builderOptions
                                                                                    documentAttributes:nil];
    
    _coreTextView.attributedString = [stringBuilder generatedAttributedString];
    _coreTextView.contentInset = UIEdgeInsetsMake(6, 8, 8, 8);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *) attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
    if ([attachment isKindOfClass:[DTImageTextAttachment class]]) {
        NSLog(@"contentURL: %@, x:%f, y:%f, w:%f, h:%f", attachment.contentURL,frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((frame.size.width-30)/2, (frame.size.height-30)/2, 30, 30)];
        loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        loadingView.hidesWhenStopped = YES;
        [imageView addSubview:loadingView];

        [loadingView startAnimating];
        [imageView setImageWithURL:attachment.contentURL placeholderImage:[UIImage imageNamed:@"thumb_placeholder.png"] options:SDWebImageRetryFailed progress:^(NSUInteger receivedSize, long long expectedSize) {
            if (receivedSize == expectedSize) {
                [loadingView stopAnimating];
            }
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            [loadingView stopAnimating];
        }];
        
        return imageView;
    }
    else
        return nil;
}

@end
