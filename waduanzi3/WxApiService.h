//
//  WxApiViewController.h
//  waduanzi3
//
//  Created by chendong on 13-7-26.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"

@interface WxApiService : NSObject <WXApiDelegate>

+ (WxApiService *) shareInstance;
@end
