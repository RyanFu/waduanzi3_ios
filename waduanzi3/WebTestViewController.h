//
//  WebTestViewController.h
//  waduanzi3
//
//  Created by chendong on 13-8-19.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebTestViewController : UIViewController <UIWebViewDelegate>
{
    UIScrollView *_scrollView;
    UIWebView *_webView;
}
@end
