//
//  File: AdMoGoAdapterAdChinaFullAd.h
//  Project: AdsMOGO iOS SDK
//  Version: 1.2.1
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//  AdChina v2.5.2

#import "AdMoGoAdNetworkAdapter.h"
#import "AdChinaFullScreenView.h"

/*
    方案二
 */
@interface AdMoGoAdapterAdChinaFullAd : AdMoGoAdNetworkAdapter<AdChinaFullScreenViewDelegate> {
    AdChinaFullScreenView *fullScreenAd;
    BOOL isStop;
    NSTimer *timer;
    BOOL isLoaded;
}

+ (NSDictionary *)networkType;
- (void)sendAdFullClick;
@end
