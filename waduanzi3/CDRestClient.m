//
//  CDRestClient.m
//  waduanzi3
//
//  Created by chendong on 13-5-29.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "CDRestClient.h"
#import "CDPost.h"
#import "CDComment.h"
#import "OpenUDID.h"
#import "CDRestError.h"
#import "WCAlertView.h"


@interface CDRestClient ()
- (void) initHttpClient;
- (void) setHttpDefaultHeaders;
- (void) initObjectManager;
- (void) setResponseDescriptor;
- (RKObjectMapping *) setPostObjectMapping;
- (RKObjectMapping *) setUserObjectMapping;
- (RKObjectMapping *) setCommentObjectMapping;
- (RKObjectMapping *) setErrorObjectMapping;

+ (NSString *) userAgent;
@end


@implementation CDRestClient

- (void) run
{
    [self initHttpClient];
    [self initObjectManager];
    [self setResponseDescriptor];
}

- (void) initHttpClient
{
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // Initialize HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"http://rest.waduanzi.com"];
    _client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    [_client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    [self setHttpDefaultHeaders];
}

- (void) setHttpDefaultHeaders
{
    [_client setDefaultHeader:@"User-Agent" value:[CDRestClient userAgent]];
    [_client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
    [_client setDefaultHeader:@"device_udid" value:[OpenUDID value]];
    
    UIDevice *device = [UIDevice currentDevice];
    [_client setDefaultHeader:@"sys_version" value:device.systemVersion];
    
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    [_client setDefaultHeader:@"app_version" value:appVersion];
}

- (void) initObjectManager
{
    _manager = [[RKObjectManager alloc] initWithHTTPClient:_client];

    [RKObjectMapping addDefaultDateFormatterForString:@"MMM-dd HH:mm" inTimeZone:nil];
    _manager.requestSerializationMIMEType = RKMIMETypeFormURLEncoded;
    
    // check network
    [_manager.HTTPClient setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [WCAlertView showAlertWithTitle:@"没有网络" message:@"请检测您当前手机网络是否正常" customizationBlock:^(WCAlertView *alertView) {
                alertView.style = WCAlertViewStyleWhite;
            } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                ;
            } cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        }
    }];
}

- (void) setResponseDescriptor
{
    RKObjectMapping *postMapping = [self setPostObjectMapping];
    RKObjectMapping *userMapping = [self setUserObjectMapping];
    RKObjectMapping *commentMapping = [self setCommentObjectMapping];
    
    /*
     * RelationshipMapping
     */
    // user relationship mapping
    RKRelationshipMapping* userRelationShipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"user"
                                                                                                 toKeyPath:@"user"
                                                                                               withMapping:userMapping];
    
    // add user relationShipMapping
    [postMapping addPropertyMapping:userRelationShipMapping];
    [commentMapping addPropertyMapping:[userRelationShipMapping copy]];
    
    
    // post response descriptor
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:postMapping
                                                                                       pathPattern:@"/post/timeline"
                                                                                           keyPath:nil
                                                                                       statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [_manager addResponseDescriptor:responseDescriptor];
    
    
    // comment response descriptor
    RKResponseDescriptor *commentResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:commentMapping
                                                                                              pathPattern:@"/comment/show/:post_id"
                                                                                                  keyPath:nil
                                                                                              statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [_manager addResponseDescriptor:commentResponseDescriptor];
    
    
    // post/show response descriptor
    RKResponseDescriptor *postDetailResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:postMapping
                                                                                              pathPattern:@"/post/show/:post_id"
                                                                                                  keyPath:nil
                                                                                              statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [_manager addResponseDescriptor:postDetailResponseDescriptor];
    
    // post/show response descriptor
    RKResponseDescriptor *createCommentResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:commentMapping
                                                                                                 pathPattern:@"/comment/create"
                                                                                                     keyPath:nil
                                                                                                 statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [_manager addResponseDescriptor:createCommentResponseDescriptor];
    
    // user/login
    RKResponseDescriptor *loginUserResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userMapping
                                                                                                pathPattern:@"/user/login"
                                                                                                    keyPath:nil
                                                                                                statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [_manager addResponseDescriptor:loginUserResponseDescriptor];
}

- (RKObjectMapping *) setPostObjectMapping
{
    RKObjectMapping *postMapping = [RKObjectMapping mappingForClass:[CDPost class]];
    [postMapping addAttributeMappingsFromDictionary:@{
        @"post_id"             : @"post_id",
        @"channel_id"          : @"channel_id",
        @"title"               : @"title",
        @"content"             : @"content",
        @"create_time"         : @"create_time",
        @"create_time_at"      : @"create_time_at",
        @"up_count"            : @"up_count",
        @"down_count"          : @"down_count",
        @"comment_count"       : @"comment_count",
        @"favorite_count"      : @"favorite_count",
        @"author_id"           : @"author_id",
        @"user_id"             : @"user_id",
        @"author_name"         : @"author_name",
        @"tags"                : @"tags",
        @"small_pic"           : @"small_pic",
        @"middle_pic"          : @"middle_pic",
        @"large_pic"           : @"large_pic",
        @"pic_frames"           : @"pic_frames",
     }];
    
    return postMapping;
}

- (RKObjectMapping *) setUserObjectMapping
{
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[CDUser class]];
    [userMapping addAttributeMappingsFromDictionary:@{
        @"user_id"          : @"user_id",
        @"username"         : @"username",
        @"screen_name"      : @"screen_name",
        @"create_time"      : @"create_time",
        @"create_time_at"   : @"create_time_at",
        @"token_time"       : @"token_time",
        @"website"          : @"website",
        @"desc"             : @"desc",
        @"mini_avatar"      : @"mini_avatar",
        @"small_avatar"     : @"small_avatar",
        @"large_avatar"     : @"large_avatar"
    }];
    
    return userMapping;
}

- (RKObjectMapping *) setCommentObjectMapping
{
    RKObjectMapping *commentMapping = [RKObjectMapping mappingForClass:[CDComment class]];
    [commentMapping addAttributeMappingsFromDictionary:@{
         @"comment_id"      : @"comment_id",
         @"post_id"         : @"post_id",
         @"content"         : @"content",
         @"create_time"     : @"create_time",
         @"create_time_at"  : @"create_time_at",
         @"up_count"        : @"up_count",
         @"down_count"      : @"down_count",
         @"author_id"       : @"author_id",
         @"author_name"     : @"author_name",
         @"recommend"       : @"recommend"
     }];
    
    return commentMapping;
}

- (RKObjectMapping *) setErrorObjectMapping
{
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[CDRestError class]];
    [errorMapping addAttributeMappingsFromDictionary:@{
        @"errcode"      : @"errcode",
        @"message"      : @"message"
     }];
    
    return errorMapping;
}


+ (NSString *) userAgent
{
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    
    UIDevice *device = [UIDevice currentDevice];
    NSString *userAgent = [NSString stringWithFormat:@"Waduanzi/%@ (%@; %@ %@)", appVersion, device.model, device.systemName, device.systemVersion];
    
    return userAgent;
}

+ (NSDictionary *) defaultParams
{
    UIDevice *device = [UIDevice currentDevice];
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
         @"123", @"apikey",
         @"json", @"format",
         @"153635366", @"timestamp",
         [OpenUDID value], @"device_udid",
         device.systemVersion, @"sys_version",
         appVersion, @"app_version", nil];
    
    return params;
};

+ (NSDictionary *) requestParams:(NSDictionary *)params
{
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    [args addEntriesFromDictionary:[CDRestClient defaultParams]];
    
    if (params != nil)
        [args addEntriesFromDictionary:params];
    
    NSString *sig = [CDRestClient generateSignatureByParams:args];
    [args setObject:sig forKey:@"sig"];
    
    return args;
}

+ (NSString *) generateSignatureByParams:(NSDictionary *) params
{
    return @"123";
}


@end


