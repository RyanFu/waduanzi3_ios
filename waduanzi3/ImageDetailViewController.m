//
//  ImageDetailViewController.m
//  waduanzi2
//
//  Created by Chen Dong on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CDDefine.h"
#import "ImageDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "WCAlertView.h"
#import "MBProgressHUD.h"

@interface ImageDetailViewController ()
{
    MBProgressHUD *_HUD;
}
- (void) setupSaveButton;
- (void) setupImageView;
- (void) setupImageScrollView;
- (void) adjustImageViewSize;
- (void) setupHUD;
@end

@implementation ImageDetailViewController

@synthesize thumbnail = _thumbnail;
@synthesize originalPicUrl = _originalPicUrl;
@synthesize originaPic = _originaPic;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeImageController:)];
    singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTap];
    
    [self setupImageScrollView];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [CDAPPLICATION setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [CDAPPLICATION setStatusBarHidden:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - setup ui control

- (void) setupSaveButton
{
    saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"button_save.png"] forState:UIControlStateNormal];
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGFloat x = (screen.size.width - 70) / 2;
    CGFloat y = screen.size.height - 60 - STATUSBAR_HEIGHT;
    saveButton.frame = CGRectMake(x, y, 70, 55);
    [saveButton addTarget:self action:@selector(savePicture:) forControlEvents:UIControlEventTouchUpInside];
    saveButton.alpha = 0.9;
    if (self.originaPic == nil)
        saveButton.hidden = YES;
    [self.view addSubview:saveButton];
}

- (void) setupImageScrollView
{
    imageScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    imageScrollView.scrollEnabled = YES;
    imageScrollView.delegate = self;
    imageScrollView.maximumZoomScale = 3.0;
    imageScrollView.minimumZoomScale = 1.0;
    imageScrollView.alpha = 0.9;
    imageScrollView.backgroundColor = [UIColor blackColor];
    imageScrollView.showsVerticalScrollIndicator = NO;
    imageScrollView.showsHorizontalScrollIndicator = NO;
    imageScrollView.contentSize = self.view.bounds.size;
    
    [self.view addSubview:imageScrollView];
    [self setupHUD];
    [self setupImageView];
}

- (void) setupImageView
{
    imageShowView = [[UIImageView alloc] initWithImage:_thumbnail];

    imageShowView.contentMode = UIViewContentModeScaleAspectFit;
    imageShowView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageShowView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:.5];
    [self adjustImageViewSize];
    [imageScrollView addSubview:imageShowView];
    [self setupSaveButton];
    
    if (_originaPic) {
        imageShowView.image = _originaPic;
        [self adjustImageViewSize];
    }
    else {
        __weak ImageDetailViewController *weakSelf = self;
        __weak UIButton *weakSaveButton = saveButton;
        __weak MBProgressHUD *weakHUD = _HUD;
        __weak UIImageView *weakImageShowView = imageShowView;

        [imageShowView setImageWithURL:_originalPicUrl placeholderImage:_thumbnail options:SDWebImageRetryFailed progress:^(NSUInteger receivedSize, long long expectedSize) {
            if (expectedSize <= 0) {
                weakHUD.mode = MBProgressHUDModeDeterminate;
                [weakHUD show:YES];
            }
            else
                weakHUD.progress = receivedSize / (expectedSize + 0.0);
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            [weakHUD hide:YES];
            if (error) {
                [weakImageShowView cancelCurrentImageLoad];
                NSLog(@"picture download failed:%@", error);
            }
            else {
                weakSaveButton.hidden = NO;
                weakSelf.originaPic = image;
                [weakSelf adjustImageViewSize];
                NSLog(@"picture download success");
            }
        }];
    }
}

- (void) adjustImageViewSize
{

    CGSize imageSize = CGSizeMake(imageShowView.image.size.width / 2, imageShowView.image.size.height / 2);
    CGFloat imageViewHeight = imageScrollView.frame.size.width * imageSize.height / imageSize.width;
    CGFloat imageViewY = 0.0;
    if (imageViewHeight < imageScrollView.frame.size.height)
        imageViewY = (imageScrollView.frame.size.height - imageViewHeight) / 2;
    imageShowView.frame = CGRectMake(0.0, imageViewY, imageScrollView.frame.size.width, imageViewHeight);
    
    CGSize scrollViewContentSize = imageScrollView.contentSize;
    scrollViewContentSize.height = imageViewHeight;
    imageScrollView.contentSize = scrollViewContentSize;
    
}

- (void) setupHUD
{
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.view addSubview:_HUD];
	_HUD.mode = MBProgressHUDModeDeterminate;
	_HUD.delegate = self;
}

#pragma mark - UIScrollView delegate

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageShowView;
}

- (void) scrollViewDidEndZooming: (UIScrollView *) scrollView withView: (UIView *) view atScale: (float) scale
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, scale, scale);
    view.transform = transform;
    
    CGRect screen = imageScrollView.frame;
    CGFloat imageViewY = 0.0;
    if (view.frame.size.height < screen.size.height)
        imageViewY = (screen.size.height - view.frame.size.height) / 2;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
	view.frame = CGRectMake(view.frame.origin.x, imageViewY, view.frame.size.width, view.frame.size.height);
    [UIView commitAnimations];
}

#pragma mark - the selector

- (void) closeImageController:(id) sender
{
    [imageShowView cancelCurrentImageLoad];
    [self dismissViewControllerAnimated:NO completion:NULL];
}

- (void) savePicture:(id) sender
{
    if (_originaPic == nil)
        return;

    saveButton.enabled = NO;
    UIImageWriteToSavedPhotosAlbum(_originaPic, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        NSString *message = @"保存图片出错";
        if ([error.domain isEqualToString:@"ALAssetsLibraryErrorDomain"]) {
            message = @"您当前的设置不允许保存图片，请打开 设置-隐私-照片 来进行设置\n";
            
        }
        [WCAlertView showAlertWithTitle:@"提示" message:message customizationBlock:NULL completionBlock:NULL cancelButtonTitle:@"知道了～" otherButtonTitles:nil, nil];
    }
    else {
        _HUD.labelText = @"保存成功";
        _HUD.mode = MBProgressHUDModeCustomView;
        _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkmark.png"]];
        [_HUD show:YES];
        [_HUD hide:YES afterDelay:0.5f];
    }
    saveButton.enabled = YES;
}

@end


