//
//  AdMoGoAdapterBaiduFullAds.m
//  TestV1.3.1
//
//  Created by wang hao on 13-9-17.
//
//

#import "AdMoGoAdapterBaiduFullAds.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoConfigDataCenter.h"

#define kAdMoGoBaiduAppInterstitialIDKey @"AppID"
#define kAdMoGoBaiduAppInterstitialSecretKey @"AppSEC"

@implementation AdMoGoAdapterBaiduFullAds
+ (NSDictionary *)networkType{
    return [self makeNetWorkType:AdMoGoAdNetworkTypeBaiduMobAd IsSDK:YES isApi:NO isBanner:NO isFullScreen:YES];
}

+ (void)load{
    [[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd{
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    isLocationOn = [configData islocationOn];
    baiduInterstitial = [[BaiduMobAdInterstitial alloc] init];
    baiduInterstitial.delegate = self;
    baiduInterstitial.interstitialType = BaiduMobAdViewTypeInterstitialRefresh;
    [baiduInterstitial load];
    [interstitial adapterDidStartRequestAd:self];
     timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut30 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    [self stopBeingDelegate];
    [adMoGoCore adapter:self didFailAd:nil];
}

- (void)stopTimer{
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

- (BOOL)isReadyPresentInterstitial{
    return baiduInterstitial.isReady;
}

- (void)presentInterstitial{
    UIViewController *viewController = [self.adMoGoInterstitialDelegate viewControllerForPresentingInterstitialModalView];
    
    [baiduInterstitial presentFromRootViewController:viewController];
}

- (void)stopBeingDelegate{
    
}

- (void)dealloc {
    [self stopTimer];
    [super dealloc];
}
#pragma mark BaiduMobAdInterstitialDelegate 
/**
 *  应用在mounion.baidu.com上的id
 */
- (NSString *)publisherId{
    id key =  [self.ration objectForKey:@"key"];
    id appID;
    NSString *appIDStr;
    if (key != nil && ([key isKindOfClass:[NSDictionary class]])) {
        appID = [key objectForKey:kAdMoGoBaiduAppInterstitialIDKey];
        if (appID != nil && ([appID isKindOfClass:[NSString class]])) {
            appIDStr = [NSString stringWithString:appID];
        }
    }
    return appIDStr;
}

/**
 *  应用在mounion.baidu.com上的计费名
 */
- (NSString*) appSpec{
    id key =  [self.ration objectForKey:@"key"];
    id appSpec;
    NSString *appSpecStr;
    if (key != nil && ([key isKindOfClass:[NSDictionary class]])) {
        appSpec = [key objectForKey:kAdMoGoBaiduAppInterstitialSecretKey];
        if (appSpec != nil && ([appSpec isKindOfClass:[NSString class]])) {
            appSpecStr = [NSString stringWithString:appSpec];
        }
    }
    return appSpecStr;
}

/**
 *  渠道id
 */
- (NSString*) channelId{
    return @"13b50d6f";
}



/**
 *  启动位置信息
 */
-(BOOL) enableLocation{
    return isLocationOn;
}

/**
 *  广告预加载成功
 */
- (void)interstitialSuccessToLoadAd:(BaiduMobAdInterstitial *)_interstitial{
    [self stopTimer];
}

/**
 *  广告预加载失败
 */
- (void)interstitialFailToLoadAd:(BaiduMobAdInterstitial *)_interstitial{
    [self stopTimer];
    [interstitial adapter:self didFailAd:nil];
}

/**
 *  广告即将展示
 */
- (void)interstitialWillPresentScreen:(BaiduMobAdInterstitial *)_interstitial{

}

/**
 *  广告展示成功
 */
- (void)interstitialSuccessPresentScreen:(BaiduMobAdInterstitial *)_interstitial{
    [interstitial baiduInterstitialSendRIB];
}

/**
 *  广告展示失败
 */
- (void)interstitialFailPresentScreen:(BaiduMobAdInterstitial *)_interstitial withError:(BaiduMobFailReason) reason{
//    [interstitial adapter:self didFailAd:nil];
}

/**
 *  广告展示结束
 */
- (void)interstitialDidDismissScreen:(BaiduMobAdInterstitial *)_interstitial{
    [interstitial adapter:self didDismissScreen:_interstitial];
}


@end
