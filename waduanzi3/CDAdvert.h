//
//  CDAdvert.h
//  waduanzi3
//
//  Created by chendong on 13-9-14.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDAdvert : NSObject

@property (nonatomic, strong) NSNumber *advert_id;
@property (nonatomic, copy) NSString *advert_solt;
@property (nonatomic, copy) NSString *show_url;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *advert_pic;
@property (nonatomic, strong) NSNumber *app_store_id;
@property (nonatomic, copy) NSString *app_bundle_identifier;
@property (nonatomic, copy) NSString *app_name;
@property (nonatomic, copy) NSString *provider;

- (NSURL *) appStoreUrl;

@end
