//
//  CDCommon.m
//  waduanzi3
//
//  Created by chendong on 13-8-4.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDCommon.h"
#import "CDDefine.h"
#import "MACAddress.h"


void CDLog(NSString *format, ...)
{
    if (CD_DEBUG) {
        va_list ap;
        va_start(ap, format);
        NSLogv(format, ap);
        va_end(ap);
    }
}

NSString *macAddress()
{
    NSString *address;
    if (IS_IOS7)
        address = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    else
        address = [MACAddress address];
    
    return address;
}