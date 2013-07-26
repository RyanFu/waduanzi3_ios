//
//  CDWebViewController.h
//  waduanzi3
//
//  Created by chendong on 13-7-20.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "QWebViewController.h"
#import "CDUIKit.h"

@interface CDWebViewController : QWebViewController

@property (nonatomic, assign) CDToolBarStyle toolbarStyle;

- (id) initWithToolbarStyle:(CDToolBarStyle)style;
- (id)initWithHTML:(NSString *)html toolbarStyle:(CDToolBarStyle)style;
- (id)initWithUrl:(NSString *)url toolbarStyle:(CDToolBarStyle)style;
@end
