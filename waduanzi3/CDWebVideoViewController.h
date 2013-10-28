//
//  CDWebViewController.h
//  waduanzi3
//
//  Created by chendong on 13-7-20.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDViewController.h"
#import "CDUIKit.h"
#import "AdMoGoDelegateProtocol.h"
#import "AdMoGoView.h"
#import "AdMoGoWebBrowserControllerUserDelegate.h"

@interface CDWebVideoViewController : CDViewController <UIWebViewDelegate, AdMoGoDelegate, AdMoGoWebBrowserControllerUserDelegate>
{
    AdMoGoView *_adView;

}

@property (nonatomic, assign) BOOL simplePage;
@property (nonatomic, strong) AdMoGoView *adView;

- (CDWebVideoViewController *)initWithUrl:(NSString *)string;
- (CDWebVideoViewController *)initWithHTML:(NSString *)html;

- (void) setNavigationBarStyle:(CDNavigationBarStyle)navigationBarStyle barButtonItemStyle:(CDBarButtonItemStyle)barButtonItemStyle toolBarStyle:(CDToolBarStyle)toolBarStyle;
@end
