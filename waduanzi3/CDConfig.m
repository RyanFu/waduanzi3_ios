//
//  CDConfig.m
//  waduanzi3
//
//  Created by chendong on 13-6-11.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDConfig.h"
#import "MobClick.h"
#import "CDDataCache.h"

@implementation CDConfig

+ (BOOL) enabledAdvert
{
    return NO;
}

+ (BOOL) enabledUMHandle
{
    double firstBootTime = [[CDDataCache shareCache] fetchAppFirstBootTime];
    if (firstBootTime > CFAbsoluteTimeGetCurrent() - DAY_SECONDS)
        return NO;
    
    NSString *switcher = [MobClick getConfigParams:@"enable_umhandle"];
    return [switcher isEqualToString:@"on"];
}
@end
