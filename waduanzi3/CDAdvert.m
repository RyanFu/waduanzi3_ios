//
//  CDAdvert.m
//  waduanzi3
//
//  Created by chendong on 13-9-14.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDAdvert.h"

@implementation CDAdvert

@synthesize advert_id = _advert_id;
@synthesize advert_solt = _advert_solt;
@synthesize show_url = _show_url;
@synthesize title = _title;
@synthesize desc = _desc;
@synthesize advert_pic = _advert_pic;
@synthesize app_name = _app_name;
@synthesize app_store_id = _app_store_id;
@synthesize app_bundle_identifier = _app_bundle_identifier;


- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.advert_id = [decoder decodeObjectForKey:@"advert_id"];
        self.advert_solt = [decoder decodeObjectForKey:@"advert_solt"];
        self.show_url = [decoder decodeObjectForKey:@"show_url"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.desc = [decoder decodeObjectForKey:@"desc"];
        self.advert_pic = [decoder decodeObjectForKey:@"advert_pic"];
        self.app_name = [decoder decodeObjectForKey:@"app_name"];
        self.app_store_id = [decoder decodeObjectForKey:@"app_store_id"];
        self.app_bundle_identifier = [decoder decodeObjectForKey:@"app_bundle_identifier"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_advert_id forKey:@"advert_id"];
    [encoder encodeObject:_advert_solt forKey:@"advert_solt"];
    [encoder encodeObject:_show_url forKey:@"show_url"];
    [encoder encodeObject:_title forKey:@"title"];
    [encoder encodeObject:_desc forKey:@"desc"];
    [encoder encodeObject:_advert_pic forKey:@"advert_pic"];
    [encoder encodeObject:_app_name forKey:@"app_name"];
    [encoder encodeObject:_app_store_id forKey:@"app_store_id"];
    [encoder encodeObject:_app_bundle_identifier forKey:@"app_bundle_identifier"];
}

- (NSURL *) appStoreUrl
{
    return (_app_store_id.intValue > 0) ? [NSURL URLWithString:APP_STORE_URL(_app_store_id)] : nil;
}

@end




