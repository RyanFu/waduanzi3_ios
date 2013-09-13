//
//  CDWebViewController.h
//  waduanzi3
//
//  Created by chendong on 13-7-20.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "QWebViewController.h"
#import "CDUIKit.h"

typedef NS_ENUM(NSInteger, CDVideoViewMode) {
    CDVideoViewModeDefault,
    CDVideoViewModeClassic
};

@interface CDWebVideoViewController : QWebViewController {

@private
    CDVideoViewMode viewMode;

}

- (void) setNavigationBarStyle:(CDNavigationBarStyle)navigationBarStyle barButtonItemStyle:(CDBarButtionItemStyle)barButtonItemStyle toolBarStyle:(CDToolBarStyle)toolBarStyle;
@end
