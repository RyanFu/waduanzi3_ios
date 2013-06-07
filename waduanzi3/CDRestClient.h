//
//  CDRestClient.h
//  waduanzi3
//
//  Created by chendong on 13-5-29.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <RestKit/RestKit.h>
#import <Foundation/Foundation.h>

@interface CDRestClient : NSObject
{
    AFHTTPClient *_client;
    RKObjectManager *_manager;
}

- (void) run;
+ (NSDictionary *) defaultParams;
+ (NSDictionary *) requestParams:(NSDictionary *)params;
+ (NSString *) generateSignatureByParams:(NSDictionary *) params;
@end
