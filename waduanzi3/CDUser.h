//
//  CDUser.h
//  waduanzi3
//
//  Created by chendong on 13-5-29.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CDUser : NSObject

@property (nonatomic, strong) NSNumber * create_time;
@property (nonatomic, strong) NSDate * create_time_at;
@property (nonatomic, copy) NSString * desc;
@property (nonatomic, strong) NSNumber * user_id;
@property (nonatomic, copy) NSString * large_avatar;
@property (nonatomic, copy) NSString * mini_avatar;
@property (nonatomic, copy) NSString * screen_name;
@property (nonatomic, copy) NSString * small_avatar;
@property (nonatomic, strong) NSNumber * token_time;
@property (nonatomic, copy) NSString * username;
@property (nonatomic, copy) NSString * website;

+ (BOOL) logined;

@end
