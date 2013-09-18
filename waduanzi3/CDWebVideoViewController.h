//
//  CDWebViewController.h
//  waduanzi3
//
//  Created by chendong on 13-7-20.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "QWebViewController.h"
#import "CDUIKit.h"

@interface CDWebVideoViewController : UIViewController <UIWebViewDelegate>
{
@private
    UIWebView *_webView;
    NSString *_url;
    NSString *_html;
}

- (CDWebVideoViewController *)initWithUrl:(NSString *)string;
- (CDWebVideoViewController *)initWithHTML:(NSString *)html;

- (void) setNavigationBarStyle:(CDNavigationBarStyle)navigationBarStyle barButtonItemStyle:(CDBarButtionItemStyle)barButtonItemStyle toolBarStyle:(CDToolBarStyle)toolBarStyle;
@end
