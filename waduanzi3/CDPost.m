//
//  CDPost.m
//  waduanzi3
//
//  Created by chendong on 13-5-29.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDPost.h"
#import "CDUser.h"

@implementation CDPost

@synthesize post_id = _post_id;
@synthesize channel_id = _channel_id;
@synthesize title = _title;
@synthesize down_count = _down_count;
@synthesize up_count = _up_count;
@synthesize content = _content;
@synthesize create_time = _create_time;
@synthesize author_name = _author_name;
@synthesize author_id = _author_id;
@synthesize favorite_count = _favorite_count;
@synthesize comment_count = _comment_count;
@synthesize small_pic = _small_pic;
@synthesize middle_pic = _middle_pic;
@synthesize large_pic = _large_pic;
@synthesize tags = _tags;
@synthesize create_time_at = _create_time_at;
@synthesize pic_frames = _pic_frames;
@synthesize url = _url;
@synthesize user = _user;

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.post_id = [decoder decodeObjectForKey:@"post_id"];
        self.channel_id = [decoder decodeObjectForKey:@"channel_id"];
        self.title = [decoder decodeObjectForKey:@"title"];
        self.down_count = [decoder decodeObjectForKey:@"down_count"];
        self.up_count = [decoder decodeObjectForKey:@"up_count"];
        self.content = [decoder decodeObjectForKey:@"content"];
        self.create_time = [decoder decodeObjectForKey:@"create_time"];
        self.author_name = [decoder decodeObjectForKey:@"author_name"];
        self.author_id = [decoder decodeObjectForKey:@"author_id"];
        self.favorite_count = [decoder decodeObjectForKey:@"favorite_count"];
        self.comment_count = [decoder decodeObjectForKey:@"comment_count"];
        self.small_pic = [decoder decodeObjectForKey:@"small_pic"];
        self.middle_pic = [decoder decodeObjectForKey:@"middle_pic"];
        self.large_pic = [decoder decodeObjectForKey:@"large_pic"];
        self.tags = [decoder decodeObjectForKey:@"tags"];
        self.create_time_at = [decoder decodeObjectForKey:@"create_time_at"];
        self.pic_frames = [decoder decodeObjectForKey:@"pic_frames"];
        self.url = [decoder decodeObjectForKey:@"url"];
        self.user = [decoder decodeObjectForKey:@"user"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_post_id forKey:@"post_id"];
    [encoder encodeObject:_channel_id forKey:@"channel_id"];
    [encoder encodeObject:_title forKey:@"title"];
    [encoder encodeObject:_down_count forKey:@"down_count"];
    [encoder encodeObject:_up_count forKey:@"up_count"];
    [encoder encodeObject:_content forKey:@"content"];
    [encoder encodeObject:_create_time forKey:@"create_time"];
    [encoder encodeObject:_author_name forKey:@"author_name"];
    [encoder encodeObject:_author_id forKey:@"author_id"];
    [encoder encodeObject:_favorite_count forKey:@"favorite_count"];
    [encoder encodeObject:_comment_count forKey:@"comment_count"];
    [encoder encodeObject:_small_pic forKey:@"small_pic"];
    [encoder encodeObject:_middle_pic forKey:@"middle_pic"];
    [encoder encodeObject:_large_pic forKey:@"large_pic"];
    [encoder encodeObject:_tags forKey:@"tags"];
    [encoder encodeObject:_create_time_at forKey:@"create_time_at"];
    [encoder encodeObject:_pic_frames forKey:@"pic_frames"];
    [encoder encodeObject:_url forKey:@"url"];
    [encoder encodeObject:_user forKey:@"user"];
}

- (NSString *) summary
{
    if (_content != nil && _content.length > CONTENT_SUB_THRESHOLD_LEN)
        return [[self.content substringToIndex:SUMMARY_LEN] stringByAppendingFormat:@"......\n\n﹤长文，剩余%d字﹥", _content.length - SUMMARY_LEN];
    else
        return _content;
}

- (NSString *) shareContentWithLength:(NSUInteger)length withPrefix:(NSString *)prefix withSuffix:(NSString *)suffix
{
    if (_content != nil) {
        NSMutableString *subcontent = [NSMutableString stringWithString:_content];
        if (_content.length <= length)
            return subcontent;
        
        if (prefix != nil)
            [subcontent insertString:prefix atIndex:0];
        if (suffix != nil)
            [subcontent appendString:suffix];
        return [subcontent substringToIndex:length];
    }
    else
        return nil;
}

@end


