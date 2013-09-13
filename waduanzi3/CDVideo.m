//
//  CDVideo.m
//  waduanzi3
//
//  Created by chendong on 13-9-12.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDVideo.h"

@implementation CDVideo

@synthesize video_id = _video_id;
@synthesize post_id = _post_id;
@synthesize html5_url = _html5_url;
@synthesize flash_url = _flash_url;
@synthesize source_url = _source_url;
@synthesize desc = _desc;

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.video_id = [decoder decodeObjectForKey:@"video_id"];
        self.post_id = [decoder decodeObjectForKey:@"post_id"];
        self.html5_url = [decoder decodeObjectForKey:@"html5_url"];
        self.flash_url = [decoder decodeObjectForKey:@"flash_url"];
        self.source_url = [decoder decodeObjectForKey:@"source_url"];
        self.desc = [decoder decodeObjectForKey:@"desc"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_video_id forKey:@"video_id"];
    [encoder encodeObject:_post_id forKey:@"post_id"];
    [encoder encodeObject:_html5_url forKey:@"html5_url"];
    [encoder encodeObject:_flash_url forKey:@"flash_url"];
    [encoder encodeObject:_source_url forKey:@"source_url"];
    [encoder encodeObject:_desc forKey:@"desc"];
}

@end
