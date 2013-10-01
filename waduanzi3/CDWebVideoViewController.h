//
//  CDWebViewController.h
//  waduanzi3
//
//  Created by chendong on 13-7-20.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDViewController.h"
#import "CDUIKit.h"

@interface CDWebVideoViewController : CDViewController <UIWebViewDelegate>
{
@private
    UIWebView *_webView;
    NSString *_url;
    NSString *_html;
}

- (CDWebVideoViewController *)initWithUrl:(NSString *)string;
- (CDWebVideoViewController *)initWithHTML:(NSString *)html;

- (void) setNavigationBarStyle:(CDNavigationBarStyle)navigationBarStyle barButtonItemStyle:(CDBarButtonItemStyle)barButtonItemStyle toolBarStyle:(CDToolBarStyle)toolBarStyle;
@end
