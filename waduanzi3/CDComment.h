//
//  CDComment.h
//  waduanzi3
//
//  Created by chendong on 13-5-30.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDUser.h"

@interface CDComment : NSObject

@property (nonatomic, strong) NSNumber * comment_id;
@property (nonatomic, strong) NSNumber * post_id;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, strong) NSNumber * create_time;
@property (nonatomic, strong) NSString * create_time_at;
@property (nonatomic, strong) NSNumber * up_count;
@property (nonatomic, strong) NSNumber * down_count;
@property (nonatomic, strong) NSNumber * report_count;
@property (nonatomic, strong) NSNumber * author_id;
@property (nonatomic, strong) NSString * author_name;
@property (nonatomic, strong) NSNumber * recommend;

@property (nonatomic, strong) CDUser *user;

@end
