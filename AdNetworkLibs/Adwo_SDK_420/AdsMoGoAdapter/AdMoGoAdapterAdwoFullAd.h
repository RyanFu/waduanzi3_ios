//
//  AdMoGoAdapterAdwoFullAd.h
//  TestMOGOSDKAPP
//
//  Created by Daxiong on 12-10-29.
//
//

#import "AdMoGoAdNetworkAdapter.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AWAdView.h"

@interface AdMoGoAdapterAdwoFullAd:AdMoGoAdNetworkAdapter<AWAdViewDelegate>{
    BOOL isSuccess;
    BOOL isDelloced;
    BOOL isStop;
    AWAdView *adFullScreenView;
    NSTimer *timer;
    BOOL isReady;
    BOOL isStopTimer;
}
- (void)orientationChanged:(UIInterfaceOrientation)orientation;
@end
