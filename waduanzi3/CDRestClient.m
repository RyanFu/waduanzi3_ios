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
#import "CDVideo.h"
#import "OpenUDID.h"
#import "CDRestError.h"
#import "CDSession.h"
#import "MBProgressHUD+Custom.h"


@interface CDRestClient ()

- (void) initHttpClient;
- (void) setHttpDefaultHeaders;
- (void) initObjectManager;
- (void) setResponseDescriptor;
- (RKObjectMapping *) setPostObjectMapping;
- (RKObjectMapping *) setUserObjectMapping;
- (RKObjectMapping *) setCommentObjectMapping;
- (RKObjectMapping *) setVideoObjectMapping;
- (RKObjectMapping *) setErrorObjectMapping;

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
    NSString *userToken = @"";
    if ([[CDSession shareInstance] hasLogined]) {
        CDUser *user = [[CDSession shareInstance] currentUser];
        userToken = user.token;
    }

    [_client setDefaultHeader:@"Referer" value:@"http://apps.waduanzi.com"];
    [_client setDefaultHeader:@"User-Agent" value:[CDRestClient userAgent]];
    [_client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
    [_client setDefaultHeader:@"Device-UDID" value:[OpenUDID value]];
    [_client setDefaultHeader:@"User-Token" value:userToken];
    [_client setDefaultHeader:@"Network-Status" value:[NSString stringWithFormat:@"%d", _client.networkReachabilityStatus]];
    
    [_client setDefaultHeader:@"OS-Version" value:CDDEVICE.systemVersion];
    [_client setDefaultHeader:@"App-Version" value:APP_VERSION];
    [_client setDefaultHeader:@"OS-Name" value:CDDEVICE.systemName];
}

- (void) initObjectManager
{
    _manager = [[RKObjectManager alloc] initWithHTTPClient:_client];

    [RKObjectMapping addDefaultDateFormatterForString:@"MMM-dd HH:mm" inTimeZone:nil];
    _manager.requestSerializationMIMEType = RKMIMETypeFormURLEncoded;
}


- (void) setResponseDescriptor
{
    RKObjectMapping *postMapping = [self setPostObjectMapping];
    RKObjectMapping *userMapping = [self setUserObjectMapping];
    RKObjectMapping *commentMapping = [self setCommentObjectMapping];
    RKObjectMapping *videoMapping = [self setVideoObjectMapping];
    
    /*
     * RelationshipMapping
     */
    // user relationship mapping
    RKRelationshipMapping *userRelationShipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"user"
                                                                                                 toKeyPath:@"user"
                                                                                               withMapping:userMapping];
    
    RKRelationshipMapping *videoRelationShipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"video"
                                                                                                  toKeyPath:@"video"
                                                                                                withMapping:videoMapping];
    
    // add user relationShipMapping
    [postMapping addPropertyMapping:userRelationShipMapping];
    [postMapping addPropertyMapping:videoRelationShipMapping];
    [commentMapping addPropertyMapping:[userRelationShipMapping copy]];
    
    
    // post timeline response descriptor
    RKResponseDescriptor *timelineResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:postMapping
                                                                                                    method:RKRequestMethodGET
                                                                                               pathPattern:@"/post/timeline"
                                                                                                   keyPath:nil
                                                                                               statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [_manager addResponseDescriptor:timelineResponseDescriptor];
    
    // post myshare response descriptor
    RKResponseDescriptor *myshareResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:postMapping
                                                                                                   method:RKRequestMethodGET
                                                                                              pathPattern:@"/post/myshare"
                                                                                                  keyPath:nil
                                                                                              statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [_manager addResponseDescriptor:myshareResponseDescriptor];
    
    // post favorite response descriptor
    RKResponseDescriptor *favoriteResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:postMapping
                                                                                                    method:RKRequestMethodGET
                                                                                               pathPattern:@"/post/favorite"
                                                                                                   keyPath:nil
                                                                                               statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [_manager addResponseDescriptor:favoriteResponseDescriptor];
    
    // post favorite response descriptor
    RKResponseDescriptor *bestResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:postMapping
                                                                                                method:RKRequestMethodGET
                                                                                           pathPattern:@"/post/best"
                                                                                               keyPath:nil
                                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [_manager addResponseDescriptor:bestResponseDescriptor];
    
    // post favorite response descriptor
    RKResponseDescriptor *historyResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:postMapping
                                                                                                   method:RKRequestMethodGET
                                                                                              pathPattern:@"/post/history"
                                                                                                  keyPath:nil
                                                                                              statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [_manager addResponseDescriptor:historyResponseDescriptor];
    
    // post favorite response descriptor
    RKResponseDescriptor *feedbacResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:postMapping
                                                                                                   method:RKRequestMethodGET
                                                                                              pathPattern:@"/post/feedback"
                                                                                                  keyPath:nil
                                                                                              statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [_manager addResponseDescriptor:feedbacResponseDescriptor];
    
    
    // comment response descriptor
    RKResponseDescriptor *commentResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:commentMapping
                                                                                                   method:RKRequestMethodGET
                                                                                              pathPattern:@"/comment/show/:post_id"
                                                                                                  keyPath:nil
                                                                                              statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [_manager addResponseDescriptor:commentResponseDescriptor];
    
    
    // post/show response descriptor
    RKResponseDescriptor *postDetailResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:postMapping
                                                                                                      method:RKRequestMethodGET
                                                                                                 pathPattern:@"/post/show/:post_id"
                                                                                                     keyPath:nil
                                                                                                 statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [_manager addResponseDescriptor:postDetailResponseDescriptor];
    
    // post/show response descriptor
    RKResponseDescriptor *createCommentResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:commentMapping
                                                                                                         method:RKRequestMethodPOST
                                                                                                    pathPattern:@"/comment/create"
                                                                                                        keyPath:nil
                                                                                                    statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [_manager addResponseDescriptor:createCommentResponseDescriptor];
    
    // user/login
    RKResponseDescriptor *loginUserResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userMapping
                                                                                                     method:RKRequestMethodPOST
                                                                                                pathPattern:@"/user/login"
                                                                                                    keyPath:nil
                                                                                                statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [_manager addResponseDescriptor:loginUserResponseDescriptor];
    
    // user/create
    RKResponseDescriptor *createUserResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userMapping
                                                                                                      method:RKRequestMethodPOST
                                                                                                 pathPattern:@"/user/create"
                                                                                                     keyPath:nil
                                                                                                 statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    [_manager addResponseDescriptor:createUserResponseDescriptor];
}

- (RKObjectMapping *) setPostObjectMapping
{
    RKObjectMapping *postMapping = [RKObjectMapping mappingForClass:[CDPost class]];
    [postMapping addAttributeMappingsFromDictionary:@{
        @"post_id"             : @"post_id",
        @"channel_id"          : @"channel_id",
        @"title"               : @"title",
        @"content"             : @"content",
        @"content_html"        : @"content_html",
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
        @"pic_frames"          : @"pic_frames",
        @"pic_width"           : @"pic_width",
        @"pic_height"          : @"pic_height",
        @"url"                 : @"url"
     }];
    
    return postMapping;
}

- (RKObjectMapping *) setVideoObjectMapping
{
    RKObjectMapping *videoMapping = [RKObjectMapping mappingForClass:[CDVideo class]];
    [videoMapping addAttributeMappingsFromDictionary:@{
        @"post_id"             : @"post_id",
        @"video_id"            : @"video_id",
        @"html5_url"           : @"html5_url",
        @"flash_url"           : @"flash_url",
        @"source_url"          : @"source_url",
        @"desc"                : @"desc",
        @"simple_page"         : @"simple_page"
    }];
    
    return videoMapping;
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
        @"large_avatar"     : @"large_avatar",
        @"score"            : @"score"
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
    NSString *userAgent = [NSString stringWithFormat:@"Waduanzi/%@ (%@; %@ %@)", APP_VERSION, CDDEVICE.model, CDDEVICE.systemName, CDDEVICE.systemVersion];
    return userAgent;
}

+ (NSDictionary *) defaultParams
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
         @"123", @"apikey",
         @"json", @"format",
         @"153635366", @"timestamp", nil];
    
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
    NSLog(@"params: %@", args);
    
    return args;
}

+ (NSString *) generateSignatureByParams:(NSDictionary *) params
{
    return @"123";
}


@end


