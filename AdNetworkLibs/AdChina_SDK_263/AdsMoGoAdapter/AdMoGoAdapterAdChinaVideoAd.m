//
//  AdMoGoAdapterAdChinaVideoAd.m
//  TestMOGOSDKAPI
//
//  Created by Daxiong on 13-8-7.
//  Copyright (c) 2013年 Daxiong. All rights reserved.
//
#import "AdChinaVideoView.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoAdapterAdChinaVideoAd.h"
#import "AdChinaLocationManager.h"

@interface AdMoGoAdapterAdChinaVideoAd ()<AdChinaVideoViewDelegate>{
    BOOL isStop;
    BOOL isReady;
    BOOL isClosed;
    UIViewController *_viewController;
    AdChinaVideoView *_adChinaVideoView;
    NSTimer *timer;
}

@end

@implementation AdMoGoAdapterAdChinaVideoAd
+ (NSDictionary *)networkType {
    return [self makeNetWorkType:AdMoGoAdNetworkTypeAdChina IsSDK:YES isApi:NO isBanner:NO isFullScreen:YES isVideo:YES];
}

+ (void)load {
	[[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    isStop = NO;
    isReady = NO;
    isClosed = NO;
    [adMoGoCore adDidStartRequestAd];
    
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:interstitial.configKey];
    AdViewType type =[configData.ad_type intValue];
    if (type != AdViewTypeVideo) {
        NSLog(@"not video ad type");
        [interstitial adapter:self didFailAd:nil];
        return;
    }
    if ([configData islocationOn] == FALSE) {
        [AdChinaLocationManager setLocationServiceEnabled:NO];
    }
    _viewController = [self.adMoGoInterstitialDelegate viewControllerForPresentingInterstitialModalView];
    _adChinaVideoView = [[AdChinaVideoView requestAdWithAdSpaceId:[self.ration objectForKey:@"key"]
                                                        delegate:self
                                                  shouldAutoPlay:NO] retain];
    /* Set Video Size width:height = 4:3 */
    CGSize videoSize = VideoSizeWithAdViewWidth([UIScreen mainScreen].bounds.size.width);
	_adChinaVideoView.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    /* Dock at center */
	_adChinaVideoView.center = _viewController.view.center;
    /* Set viewcontroller for browser, default viewcontroller is delegate */
	[_adChinaVideoView setViewControllerForBrowser:_viewController];// presentModalView to show browser
    [interstitial adapterDidStartRequestAd:self];
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    
}

- (void)dealloc{
    [super dealloc];
}
- (void)stopBeingDelegate{
    if (_adChinaVideoView) {
        if (_adChinaVideoView.window) {
          [_adChinaVideoView removeFromSuperview];
        }
        [_adChinaVideoView release],_adChinaVideoView = nil;
    }
}
- (void)stopAd{
    
    isStop = YES;
    [self stopBeingDelegate];
}

- (void)stopTimer{
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

/*2013*/
- (void)loadAdTimeOut:(NSTimer*)theTimer {
    if (isStop) {
        return;
    }
    [self stopTimer];
    [interstitial adapter:self didFailAd:nil];
}

- (BOOL)isReadyPresentInterstitial{
    return isReady;
}
-(void)playVideoAd{
    if (isReady) {
        [interstitial adapter:self WillPresent:nil];
        [_viewController.view addSubview:_adChinaVideoView];
        [_adChinaVideoView startPlaying];
        
        if ([interstitial respondsToSelector:@selector(adsMoGoDidPlayVideoAd:)]) {
            [interstitial performSelector:@selector(adsMoGoDidPlayVideoAd:) withObject:nil];
        }
        
    }
}
- (void)presentInterstitial{
}


#pragma mark -
#pragma mark AdChinaVideoView Delegate method
- (void)didGetVideoAd:(AdChinaVideoView *)adView{
    if (isStop) {
        return;
    }
    isReady = YES;
    [self stopTimer];
    [interstitial adapter:self didReceiveInterstitialScreenAd:adView];
    if ([interstitial respondsToSelector:@selector(adsMoGoDidLoadVideoAd:)]) {
        [interstitial performSelector:@selector(adsMoGoDidLoadVideoAd:) withObject:nil];
    }
}
- (void)didFailToGetVideoAd:(AdChinaVideoView *)adView{
    if (isStop) {
        return;
    }
    [self stopTimer];
    
    if ([interstitial respondsToSelector:@selector(adsMoGoFailLoadVideoAd:)]) {
        [interstitial performSelector:@selector(adsMoGoFailLoadVideoAd:) withObject:nil];
    }
    [interstitial adapter:self didFailAd:nil];
}
- (void)didCloseVideoAd:(AdChinaVideoView *)adView{
    if (isStop || isClosed) {
        return;
    }
    isClosed = YES;
    [interstitial adapter:self didDismissScreen:nil];
    if ([interstitial respondsToSelector:@selector(adsMoGoFinishVideoAd:)]) {
        [interstitial performSelector:@selector(adsMoGoFinishVideoAd:) withObject:nil];
    }
    
}

// Called when user opens an in-app web browser
// You may use this method to pause game animation, music, etc.
- (void)didEnterFullScreenMode{
    [interstitial adapterAdModal:self WillPresent:nil];
}
- (void)didExitFullScreenMode{
    [interstitial adapterAdModal:self didDismissScreen:nil];
}

// You may use these methods to count click/watch number by yourself
- (void)didClickVideoAd:(AdChinaVideoView *)adView{
    [interstitial specialSendRecordNum];
}
- (void)didFinishWatchingVideoAd:(AdChinaVideoView *)adView{
    if (isStop || isClosed) {
        return;
    }
    isClosed = YES;
    [interstitial adapter:self didDismissScreen:nil];
    if ([interstitial respondsToSelector:@selector(adsMoGoFinishVideoAd:)]) {
        [interstitial performSelector:@selector(adsMoGoFinishVideoAd:) withObject:nil];
    }
}
@end
