//
//  WebTestViewController.m
//  waduanzi3
//
//  Created by chendong on 13-8-19.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "WebTestViewController.h"

@interface WebTestViewController ()

@end

@implementation WebTestViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGRect viewRect = self.view.bounds;
    viewRect.origin.y = 50.0f;
    viewRect.size.height -= 100.0f;
    _scrollView = [[UIScrollView alloc] initWithFrame:viewRect];
    _scrollView.userInteractionEnabled = YES;
    _scrollView.scrollEnabled = YES;
    [self.view addSubview:_scrollView];
    
    CGRect webRect = self.view.bounds;
//    webRect.origin.y = 100.0f;
    webRect.size.height = 300.0f;
    _webView = [[UIWebView alloc] initWithFrame:webRect];
    _webView.delegate = self;
    [_scrollView addSubview:_webView];
    
    NSURL *url = [NSURL URLWithString:@"http://www.waduanzi.com/mobile/archives/54784"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
//    NSString *jscode = @"function getDocHeight() {var D = document;return Math.max(D.body.scrollHeight, D.documentElement.scrollHeight,D.body.offsetHeight, D.documentElement.offsetHeight,D.body.clientHeight, D.documentElement.clientHeight);} getDocHeight();";
    
    
    
//    NSString *docHeight = [_webView stringByEvaluatingJavaScriptFromString:jscode];
//    NSLog(@"height: %@", docHeight);

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) webViewDidFinishLoad:(UIWebView *)aWebView
{
    CGRect webRect = aWebView.frame;
    webRect.size = aWebView.scrollView.contentSize;
    aWebView.frame = webRect;
    aWebView.scrollView.scrollEnabled = NO;
    _scrollView.contentSize = aWebView.scrollView.contentSize;
}

- (void)we2bViewDidFinishLoad:(UIWebView *)webView
{
    NSString *jscode = @"function getDocHeight() {var D = document;return Math.max(D.body.scrollHeight, D.documentElement.scrollHeight,D.body.offsetHeight, D.documentElement.offsetHeight,D.body.clientHeight, D.documentElement.clientHeight);} getDocHeight();";
    
    CGFloat content_height = [[webView stringByEvaluatingJavaScriptFromString:jscode] floatValue];
    
//    CGRect viewRect = self.view.frame;
//    viewRect.size.height = content_height;
//    self.view.frame = viewRect;
    
    CGRect rect = webView.frame;
    rect.size.height = content_height;
    webView.frame = rect;
    webView.scrollView.contentSize = rect.size;
    NSLog(@"height: %f", content_height);
}

@end
