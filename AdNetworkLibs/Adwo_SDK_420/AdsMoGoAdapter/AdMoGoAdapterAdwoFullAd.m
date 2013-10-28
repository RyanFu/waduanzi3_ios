//
//  AdMoGoAdapterAdwoFullAd.m
//  TestMOGOSDKAPP
//
//  Created by Daxiong on 12-10-29.
//
//

#import "AdMoGoAdapterAdwoFullAd.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoConfigDataCenter.h"

@implementation AdMoGoAdapterAdwoFullAd

+ (NSDictionary *)networkType {
    return [self makeNetWorkType:AdMoGoAdNetworkTypeAdwo IsSDK:YES isApi:NO isBanner:NO isFullScreen:YES];
}

+(void)load{
    [[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
}

-(void)getAd{
    
    isSuccess = NO;
    isStop = NO;
    isDelloced = NO;
    isReady = NO;
    isStopTimer = NO;
    [adMoGoCore adDidStartRequestAd];
	[adMoGoCore adapter:self didGetAd:@"adwo"];
    
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:interstitial.configKey];
    
    AdViewType type = [configData.ad_type intValue];
    
    enum ADWO_ADSDK_AD_TYPE  adwo_ad_type;
    
    //this class only have full screen type.
    if(type == AdViewTypeFullScreen || type == AdViewTypeiPadFullScreen){
        adwo_ad_type = ADWO_ADSDK_AD_TYPE_FULL_SCREEN;
    }else{
        [interstitial adapter:self didFailAd:nil];
        return;
    }
    
    // init AWAdView
    NSString *pid = [self.ration objectForKey:@"key"];
    BOOL testMode = [[self.ration objectForKey:@"testmodel"] intValue];
    adFullScreenView = [[AWAdView alloc] initWithAdwoPid:pid adTestMode:!testMode];
    if(adFullScreenView == nil)
    {
        [interstitial adapter:self didFailAd:nil];
        return;
    }
    BOOL islocation = [configData islocationOn];
    if (islocation) {
        adFullScreenView.disableGPS = NO;
    }else{
        adFullScreenView.disableGPS = YES;
    }
    
    adFullScreenView.delegate = self;
    adFullScreenView.fsAdShowForm = ADWOSDK_FSAD_SHOW_FORM_NORMAL;
    //adFullScreenView.adSlotID = 1;
    [adFullScreenView loadAd:adwo_ad_type];
    
    self.adNetworkView = adFullScreenView;
    [adFullScreenView release];
    [interstitial adapterDidStartRequestAd:self];
//    timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut60 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
}

- (BOOL)isReadyPresentInterstitial{
    return isReady;
}

- (void)presentInterstitial{
    
    
    
    
    UIViewController* viewController = [self.adMoGoInterstitialDelegate viewControllerForPresentingInterstitialModalView];
    if (viewController.navigationController != nil &&
        viewController.parentViewController != nil) {
        viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    
    
    [(AWAdView *)self.adNetworkView addedToShowFullScreenAd:viewController.view orientation:[UIApplication sharedApplication].statusBarOrientation];
}

#pragma mark - AWAdView delegates

/**
 * 描述：当SDK需要弹出自带的Browser以显示mini site时需要使用当前广告所在的控制器。
 * AWAdView的delegate必须被设置，并且此接口必须被实现。
 * 返回：一个视图控制器对象
 */
- (UIViewController*)adwoGetBaseViewController{
    
    if (isStop) {
        return nil;
    }
    
    UIViewController* viewController = [self.adMoGoInterstitialDelegate viewControllerForPresentingInterstitialModalView];
    if (viewController.navigationController == nil ||
        viewController.parentViewController == nil) {
        return viewController;
    }
    else{
        return [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    
}

/**
 * 描述：捕获当前加载广告失败通知。当你所创建的广告视图对象请求广告失败后，SDK将会调用此接口来通知。参数adView指向当前请求广告的AWAdview对象。开发者可以通过errorCode属性来查询失败原因。
 */
- (void)adwoAdViewDidFailToLoadAd:(AWAdView*)adView
{
    if (isStop) {
        return;
    }
    [self stopTimer];
    [interstitial adapter:self didFailAd:nil];
}

/**
 * 描述：捕获广告加载成功通知。当你广告加载成功时，SDK将会调用此接口。参数adView指向当前请求广告的AWAdView对象。这个接口对于全屏广告展示而言，一般必须实现以捕获可以展示全屏广告的时机。
 */
- (void)adwoAdViewDidLoadAd:(AWAdView*)adView
{
    if (isStop) {
        return;
    }
    [self stopTimer];
    isReady = YES;
    isSuccess = YES;
    [interstitial adapter:self didReceiveInterstitialScreenAd:adView];
}

- (void)adwoFullScreenAdDismissed:(AWAdView*)adView
{
    NSLog(@"Full-screen ad closed by user!");
    
    if (isStop) {
        return;
    }
    
    [self stopBeingDelegate];

    [interstitial adapter:self didDismissScreen:adView];
}

- (void)adwoDidPresentModalViewForAd:(AWAdView*)ad
{
    
    [interstitial adapterAdModal:self WillPresent:ad];
}

- (void)adwoDidDismissModalViewForAd:(AWAdView*)ad
{
    [interstitial adapterAdModal:self didDismissScreen:ad];
}

- (void)adwoClickAdAction:(AWAdView*)adView{
    [interstitial specialSendRecordNum];
}

-(void)stopAd{
    isStop = YES;
    [self stopBeingDelegate];
}

-(void)stopBeingDelegate{
    [self stopTimer];
    if (isDelloced) {
        return;
    }
    isDelloced = YES;
    if (isSuccess) {
        AWAdView *awAdview = (AWAdView *)self.adNetworkView;
        ((AWAdView *)self.adNetworkView).delegate = nil;
        [awAdview removeFromSuperview];
        adNetworkView = nil;
 
    }else if (self.adNetworkView) {
        self.adNetworkView = nil;
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

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    if (isStop) {
        return;
    }
    [self stopBeingDelegate];
    [interstitial adapter:self didFailAd:nil];
}

- (void)dealloc{
    [self stopTimer];
    [super dealloc];
}

- (void)rotateToOrientation:(UIInterfaceOrientation)orientation{
    if (isStop  || isDelloced) {
        return;
    }
    [adFullScreenView orientationChanged:orientation];
}
@end
