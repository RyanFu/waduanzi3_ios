//
//  CDRequestResult.h
//  waduanzi3
//
//  Created by chendong on 13-6-5.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDRestError : NSObject

@property (nonatomic, strong) NSNumber *errcode;
@property (nonatomic, copy) NSString *message;
@end
