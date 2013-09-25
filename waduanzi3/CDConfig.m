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
    if (CD_DEBUG) return YES;
    
    @try {
        double firstBootTime = [[CDDataCache shareCache] fetchAppFirstBootTime];
        if (firstBootTime > CFAbsoluteTimeGetCurrent() - DAY_SECONDS)
            return NO;
        
        NSString *switcher = [MobClick getConfigParams:UM_ONLINE_CONFIG_APP_UNION_HANLE];
        return [switcher isEqualToString:@"on"];
    }
    @catch (NSException *exception) {
        CDLog(@"enable umhandle exception: %@", exception.reason);
        return NO;
    }
    @finally {
        ;
    }
    
    return NO;
}
@end
