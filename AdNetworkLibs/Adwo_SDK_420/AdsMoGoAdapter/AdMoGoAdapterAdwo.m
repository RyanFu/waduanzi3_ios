//
//  AdMoGoAdapterAdwo.m
//  TestMOGOSDKAPP
//
//  Created by MOGO on 12-10-26.
//  Copyright (c) 2012年 Mogo. All rights reserved.
//

#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdapterAdwo.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoConfigDataCenter.h"

@implementation AdMoGoAdapterAdwo

+ (NSDictionary *)networkType {
	return [self makeNetWorkType:AdMoGoAdNetworkTypeAdwo IsSDK:YES isApi:NO isBanner:YES isFullScreen:NO];
}

+(void)load{
    [[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
}

-(void)getAd{
    
    isSuccess = NO;
    isStop = NO;
    isStopTimer = NO;
    isLoaded = NO;
    [adMoGoCore adDidStartRequestAd];
	[adMoGoCore adapter:self didGetAd:@"adwo"];
    
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    
    AdViewType type = [configData.ad_type intValue];
    
    enum ADWO_ADSDK_AD_TYPE  adwo_ad_type;
    
    //set frame
    frame = CGRectZero;
    switch (type) {
        case AdViewTypeNormalBanner:
            adwo_ad_type = ADWO_ADSDK_AD_TYPE_NORMAL_BANNER;
            frame = CGRectMake(0.0, 0.0, 320.0, 50.0);
            break;
        case AdViewTypeiPadNormalBanner:
            adwo_ad_type = ADWO_ADSDK_AD_TYPE_BANNER_SIZE_FOR_IPAD_320x50;
            frame = CGRectMake(0.0, 0.0, 320.0, 50.0);
            break;
        case AdViewTypeLargeBanner:
            adwo_ad_type = ADWO_ADSDK_AD_TYPE_BANNER_SIZE_FOR_IPAD_720x110;
            frame = CGRectMake(0.0, 0.0, 720.0, 110.0);
            break;
        default:
            [adMoGoCore adapter:self didFailAd:nil];
            return;
            break;
    }
    
    NSString *pid = [self.ration objectForKey:@"key"];
    BOOL testMode = [[self.ration objectForKey:@"testmodel"] intValue];
    adView = [[AWAdView alloc]initWithAdwoPid:pid adTestMode:!testMode];
    NSLog(@"create adview %@",adView);
    
    if(adView){
        BOOL islocation = [configData islocationOn];
        if (islocation) {
            adView.disableGPS = NO;
        }else{
            adView.disableGPS = YES;
        }
        
        [adView performSelector:@selector(setAGGChannel:) withObject:[NSNumber numberWithInteger:ADWOSDK_AGGREGATION_CHANNEL_MOGO]];
        adView.delegate = self;
        adView.frame = frame;
        [adView loadAd:adwo_ad_type];
        self.adNetworkView = adView;
        /*2013*/
        [adView release];
    }else {
        [adMoGoCore adapter:self didFailAd:nil];
    }
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut8 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }

}


#pragma mark AWAdView delegate

/**
 * 描述：当SDK需要弹出自带的Browser以显示mini site时需要使用当前广告所在的控制器。
 * AWAdView的delegate必须被设置，并且此接口必须被实现。
 * 返回：一个视图控制器对象
 */
- (UIViewController*)adwoGetBaseViewController{
    
    if (isStop) {
        return nil;
    }
    
    return [adMoGoDelegate viewControllerForPresentingModalView];
}


/**
 * 描述：捕获当前加载广告失败通知。当你所创建的广告视图对象请求广告失败后，SDK将会调用此接口来通知。参数adView指向当前请求广告的AWAdview对象。开发者可以通过errorCode属性来查询失败原因。
 */
- (void)adwoAdViewDidFailToLoadAd:(AWAdView*)adView_{
    if(isStop){
        return;
    }
    [self stopTimer];
    NSLog(@"adwo error is %d",adView_.errorCode);
    if (self.adNetworkView) {
        [(AWAdView*)self.adNetworkView pauseAd];
        ((AWAdView*)self.adNetworkView).delegate = nil;
    }
    
    [adMoGoCore adapter:self didFailAd:nil];
}

/**
 * 描述：捕获广告加载成功通知。当你广告加载成功时，SDK将会调用此接口。参数adView指向当前请求广告的AWAdView对象。这个接口对于全屏广告展示而言，一般必须实现以捕获可以展示全屏广告的时机。
 */
- (void)adwoAdViewDidLoadAd:(AWAdView*)_adView{
    NSLog(@"revice adview %@",_adView);
    isLoaded = YES;
    if(isStop){
        return;
    }
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    self.adNetworkView.frame = frame;
    [adMoGoCore adapter:self didReceiveAdView:self.adNetworkView waitUntilDone:YES];
    isSuccess = YES;
    [(AWAdView *)self.adNetworkView pauseAd];
    
}


/**
 * 描述：当SDK弹出自带的全屏展示浏览器时，将会调用此接口。参数adView指向当前请求广告的AWAdView对象。这里需要注意的是，当adView弹出全屏展示浏览器时，此adView不允许被释放，否则会导致SDK崩溃。
 */
- (void)adwoDidPresentModalViewForAd:(AWAdView*)_adView{
    if (isStop) {
        return;
    }
    [self helperNotifyDelegateOfFullScreenModal];

}

/**
 * 描述：当SDK自带的全屏展示浏览器被用户关闭后，将会调用此接口。参数adView指向当前请求广告的AWAdView对象。这里允许释放adView对象。
 */
- (void)adwoDidDismissModalViewForAd:(AWAdView*)_adView{
    if (isStop) {
        return;
    }
}




-(void)stopAd{
    isStop = YES;
    [self stopTimer];
    if(adView){
        [adView pauseAd];
        adView.delegate = nil;
    }
}

- (void)stopTimer {
    if (!isStopTimer) {
        isStopTimer = YES;
    }else{
        return;
    }
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

-(void)stopBeingDelegate{
    /*2013*/
    AWAdView *_adView = (AWAdView *)self.adNetworkView;
	if (_adView != nil) {
        _adView.delegate = nil;
        if (isSuccess) {
            [_adView removeFromSuperview];
        }
        self.adNetworkView = nil;
    }
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    NSLog(@"请求超时");
    if (isStop || isLoaded) {
        return;
    }
    [self stopTimer];
    [self stopBeingDelegate];
     NSLog(@"请求超时失败");
    [adMoGoCore adapter:self didFailAd:nil];
}

-(void)dealloc{
//    NSLog(@"dealloc adview %@",adView);
    [self stopTimer];
    [super dealloc];
}

@end
