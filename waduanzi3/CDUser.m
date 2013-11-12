//
//  CDUser.m
//  waduanzi3
//
//  Created by chendong on 13-5-29.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDUser.h"


@implementation CDUser

@synthesize create_time = _create_time;
@synthesize create_time_at = _create_time_at;
@synthesize desc = _desc;
@synthesize user_id = _user_id;
@synthesize large_avatar = _large_avatar;
@synthesize mini_avatar = _mini_avatar;
@synthesize screen_name = _screen_name;
@synthesize small_avatar = _small_avatar;
@synthesize token = _token;
@synthesize username = _username;
@synthesize website = _website;
@synthesize score = _score;

+ (BOOL) logined
{
    return NO;
}


- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.create_time = [decoder decodeObjectForKey:@"create_time"];
        self.create_time_at = [decoder decodeObjectForKey:@"create_time_at"];
        self.desc = [decoder decodeObjectForKey:@"desc"];
        self.user_id = [decoder decodeObjectForKey:@"user_id"];
        self.large_avatar = [decoder decodeObjectForKey:@"large_avatar"];
        self.small_avatar = [decoder decodeObjectForKey:@"small_avatar"];
        self.mini_avatar = [decoder decodeObjectForKey:@"mini_avatar"];
        self.token = [decoder decodeObjectForKey:@"token"];
        self.username = [decoder decodeObjectForKey:@"username"];
        self.screen_name = [decoder decodeObjectForKey:@"screen_name"];
        self.website = [decoder decodeObjectForKey:@"website"];
        self.score = [decoder decodeObjectForKey:@"score"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_create_time forKey:@"create_time"];
    [encoder encodeObject:_create_time_at forKey:@"create_time_at"];
    [encoder encodeObject:_desc forKey:@"desc"];
    [encoder encodeObject:_user_id forKey:@"user_id"];
    [encoder encodeObject:_large_avatar forKey:@"large_avatar"];
    [encoder encodeObject:_small_avatar forKey:@"small_avatar"];
    [encoder encodeObject:_mini_avatar forKey:@"mini_avatar"];
    [encoder encodeObject:_token forKey:@"token"];
    [encoder encodeObject:_username forKey:@"username"];
    [encoder encodeObject:_screen_name forKey:@"screen_name"];
    [encoder encodeObject:_website forKey:@"website"];
    [encoder encodeObject:_score forKey:@"score"];
}

@end
