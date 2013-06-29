//
//  CDComment.m
//  waduanzi3
//
//  Created by chendong on 13-5-30.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDComment.h"

@implementation CDComment

@synthesize comment_id = _comment_id;
@synthesize post_id = _post_id;
@synthesize content = _content;
@synthesize create_time = _create_time;
@synthesize create_time_at = _create_time_at;
@synthesize up_count = _up_count;
@synthesize down_count = _down_count;
@synthesize report_count = _report_count;
@synthesize author_id = _author_id;
@synthesize author_name = _author_name;
@synthesize recommend = _recommend;
@synthesize user = _user;


- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.comment_id = [decoder decodeObjectForKey:@"comment_id"];
        self.post_id = [decoder decodeObjectForKey:@"post_id"];
        self.content = [decoder decodeObjectForKey:@"content"];
        self.create_time = [decoder decodeObjectForKey:@"create_time"];
        self.create_time_at = [decoder decodeObjectForKey:@"create_time_at"];
        self.up_count = [decoder decodeObjectForKey:@"up_count"];
        self.down_count = [decoder decodeObjectForKey:@"down_count"];
        self.report_count = [decoder decodeObjectForKey:@"report_count"];
        self.author_id = [decoder decodeObjectForKey:@"author_id"];
        self.author_name = [decoder decodeObjectForKey:@"recommend"];
        self.recommend = [decoder decodeObjectForKey:@"comment_id"];
        self.user = [decoder decodeObjectForKey:@"user"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_comment_id forKey:@"comment_id"];
    [encoder encodeObject:_post_id forKey:@"post_id"];
    [encoder encodeObject:_content forKey:@"content"];
    [encoder encodeObject:_create_time forKey:@"create_time"];
    [encoder encodeObject:_create_time_at forKey:@"create_time_at"];
    [encoder encodeObject:_up_count forKey:@"up_count"];
    [encoder encodeObject:_down_count forKey:@"down_count"];
    [encoder encodeObject:_report_count forKey:@"report_count"];
    [encoder encodeObject:_author_id forKey:@"author_id"];
    [encoder encodeObject:_author_name forKey:@"author_name"];
    [encoder encodeObject:_recommend forKey:@"recommend"];
    [encoder encodeObject:_user forKey:@"user"];
}

@end
