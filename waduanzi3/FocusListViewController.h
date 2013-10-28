//
//  TimelineViewController.h
//  waduanzi3
//
//  Created by chendong on 13-6-17.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "PostListViewController.h"
#import "AdMoGoView.h"
#import "AdMoGoDelegateProtocol.h"
#import "AdMoGoWebBrowserControllerUserDelegate.h"

@interface FocusListViewController : PostListViewController <AdMoGoDelegate, AdMoGoWebBrowserControllerUserDelegate>
{
    AdMoGoView *_adView;
}

@property (nonatomic, strong) AdMoGoView *adView;

@end
