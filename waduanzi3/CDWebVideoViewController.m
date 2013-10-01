//
//  CDWebViewController.m
//  waduanzi3
//
//  Created by chendong on 13-7-20.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDWebVideoViewController.h"
#import "UIView+Border.h"

@interface CDWebVideoViewController ()
{
    CDNavigationBarStyle _navigationBarStyle;
    CDBarButtonItemStyle _barButtonItemStyle;
    CDToolBarStyle _toolBarStyle;
    
    UIBarButtonItem * _btBack;
    UIBarButtonItem * _btForward;
    BOOL _firstPageFinished;
    BOOL _previousToolbarState;
    NSArray *_urlToolbarItems;
    BOOL _playing;
    
    UIView *_adView;
}

- (UIImage *)createBackArrowImage;
- (UIImage *)createForwardArrowImage;
@end

@implementation CDWebVideoViewController

- (void) setNavigationBarStyle:(CDNavigationBarStyle)navigationBarStyle barButtonItemStyle:(CDBarButtonItemStyle)barButtonItemStyle toolBarStyle:(CDToolBarStyle)toolBarStyle
{
    _navigationBarStyle = navigationBarStyle;
    _barButtonItemStyle = barButtonItemStyle;
    _toolBarStyle = toolBarStyle;
}

- (void) dismissViewController
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (CDWebVideoViewController *)initWithHTML:(NSString *)html
{
	
    self = [super init];
    if (self) {
        _html = html;
        _playing = NO;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (CDWebVideoViewController *)initWithUrl:(NSString *)url
{
    
    self = [super init];
    if (self!=nil){
        _url = url;
        _playing = NO;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void) loadView
{
    [super loadView];
    
    NSLog(@"load view");
    
    self.view.backgroundColor = [UIColor blackColor];
    
    
    CGRect webViewFrame = self.view.bounds;
    webViewFrame.size.height = CDSCREEN_SIZE.height - NAVBAR_HEIGHT*2 - STATUSBAR_HEIGHT - VIDEO_WEBVIEW_AD_HEIGHT;
    
    _webView = [[UIWebView alloc] initWithFrame:webViewFrame];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    _webView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_webView];
    [_webView showBorder:1 color:[UIColor blueColor].CGColor radius:0];
    
    CGRect adViewFrame = self.view.bounds;
    adViewFrame.size.height = VIDEO_WEBVIEW_AD_HEIGHT;
    adViewFrame.origin.y = webViewFrame.origin.y + webViewFrame.size.height;
    _adView = [[UIView alloc] initWithFrame:adViewFrame];
    [self.view addSubview:_adView];
    [_adView showBorder:1 color:[UIColor redColor].CGColor radius:0];

    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(dismissViewController)];
    
    [CDUIKit setNavigationBar:self.navigationController.navigationBar style:_navigationBarStyle forBarMetrics:UIBarMetricsDefault];
    [CDUIKit setBarButtonItem:self.navigationItem.leftBarButtonItem style:_barButtonItemStyle forBarMetrics:UIBarMetricsDefault];
    [CDUIKit setBarButtonItem:self.navigationItem.rightBarButtonItem style:_barButtonItemStyle forBarMetrics:UIBarMetricsDefault];
    [CDUIKit setToolBar:self.navigationController.toolbar style:_toolBarStyle forToolbarPosition:UIToolbarPositionBottom forBarMetrics:UIBarMetricsDefault];
    
    [CDUIKit setBarButtonItemTitleAttributes:self.navigationItem.leftBarButtonItem forBarMetrics:UIBarMetricsDefault];
    [CDUIKit setBarButtonItemTitleAttributes:self.navigationItem.rightBarButtonItem forBarMetrics:UIBarMetricsDefault];
    
    UIImage *backImage = [self createBackArrowImage];
    UIImage *forwardImage = [self createForwardArrowImage];
    _btBack = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(actionRewind)];
    _btForward = [[UIBarButtonItem alloc] initWithImage:forwardImage style:UIBarButtonItemStylePlain target:self action:@selector(actionForward)];
    
    _btBack.enabled = NO;
    _btForward.enabled = NO;
    
    UIBarButtonItem *buttonSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    buttonSpacer.width = 30;
    _urlToolbarItems = [NSArray arrayWithObjects:
                        _btBack,
                        buttonSpacer,
                        _btForward,
                        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(actionRefresh)],
                        nil];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
        NSLog(@"frame: %@", NSStringFromCGRect(self.view.bounds));
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlaybackDidStart:)
                                                 name:@"UIMoviePlayerControllerDidEnterFullscreenNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlaybackDidEnd:)
                                                 name:@"UIMoviePlayerControllerWillExitFullscreenNotification"
                                               object:nil];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    _playing = NO;
}

#pragma mark - MoviePlayer notifications

- (void) moviePlaybackDidStart:(NSNotification *)notification
{
    NSLog(@"moviePlaybackDidStart");
    
    self.navigationItem.leftBarButtonItem.enabled = NO;
}


- (void) moviePlaybackDidEnd:(NSNotification *)notification
{
    NSLog(@"moviePlaybackDidEnd");
    self.navigationItem.leftBarButtonItem.enabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_webView stopLoading];
    [self.navigationController setToolbarHidden:_previousToolbarState animated:YES];
    _webView = nil;
}

- (void)actionRewind
{
    [_webView goBack];
    _btForward.enabled = YES;
    
}

- (void)actionForward
{
    [_webView goForward];
}

- (void)actionRefresh
{
    [_webView reload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
	_previousToolbarState = self.navigationController.toolbarHidden;
    
	if (_html) {
        [_webView loadHTMLString:_html baseURL:nil];
		self.navigationController.toolbarHidden = YES;
        self.toolbarItems = nil;
	}
	else {
		[_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
		self.navigationController.toolbarHidden = NO;
        
        self.toolbarItems = _urlToolbarItems;
	}
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [indicator startAnimating];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:indicator];
    
    if (_url!=nil) {
        self.title = @"载入中";
    }
    if (_firstPageFinished==YES){
        _btBack.enabled = YES;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.navigationItem.rightBarButtonItem = nil;
    NSString *titleFromHTML = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (titleFromHTML!=nil && ![titleFromHTML isEqualToString:@""])
        self.title = titleFromHTML;
    
    _firstPageFinished = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (error.code==-999)
        return;
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.title = @"Error";
    [_webView loadHTMLString:[NSString stringWithFormat:@"<html style='margin:2em'><header><title>Error</title><header><body><h3>Unable to connect to the internet.</h3><p>%@</p><p><br/><br/>Try again: <br/><a href=\"%@\">%@</a></p></body></html>",[error localizedDescription], _url, _url] baseURL:nil];
}


- (UIImage *)createBackArrowImage
{
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(nil,27,27,8,0, colorSpace,kCGImageAlphaPremultipliedLast);
	CFRelease(colorSpace);
    CGColorRef fillColor = [[UIColor blackColor] CGColor];
    CGContextSetFillColor(context, (CGFloat *) CGColorGetComponents(fillColor));
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 8.0f, 13.0f);
    CGContextAddLineToPoint(context, 24.0f, 4.0f);
    CGContextAddLineToPoint(context, 24.0f, 22.0f);
    CGContextClosePath(context);
    CGContextFillPath(context);
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    UIImage *ret = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    
    return ret;
}

- (UIImage *)createForwardArrowImage
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(nil,27,27,8,0, colorSpace,kCGImageAlphaPremultipliedLast);
    CFRelease(colorSpace);
    CGColorRef fillColor = [[UIColor blackColor] CGColor];
    CGContextSetFillColor(context, (CGFloat *) CGColorGetComponents(fillColor));
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 24.0f, 13.0f);
    CGContextAddLineToPoint(context, 8.0f, 4.0f);
    CGContextAddLineToPoint(context, 8.0f, 22.0f);
    CGContextClosePath(context);
    CGContextFillPath(context);
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    UIImage *ret = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    
    return ret;
}


@end


