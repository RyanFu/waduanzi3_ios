//
//  CDVideo.h
//  waduanzi3
//
//  Created by chendong on 13-9-12.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDVideo : NSObject

@property (nonatomic, strong) NSNumber *video_id;
@property (nonatomic, strong) NSNumber *post_id;
@property (nonatomic, copy) NSString *html5_url;
@property (nonatomic, copy) NSString *flash_url;
@property (nonatomic, copy) NSString *source_url;
@property (nonatomic, copy) NSString *desc;

@end
