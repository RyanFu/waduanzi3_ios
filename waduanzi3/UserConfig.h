//
//  UserConfig.h
//  waduanzi3
//
//  Created by chendong on 13-8-5.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserConfig : NSObject

@property (nonatomic, assign) NSInteger *userID;
@property (nonatomic, copy) NSString *deviceUDID;
@property (nonatomic, assign) BOOL enablePushMessage;

- (id) initWithUserID:(NSInteger)user_id;
- (void) updateCache;
+ (id) currentConfig;
@end
