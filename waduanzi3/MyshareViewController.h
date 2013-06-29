//
//  MyshareViewController.h
//  waduanzi3
//
//  Created by chendong on 13-6-23.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "PostListViewController.h"

@interface MyshareViewController : PostListViewController
{
    NSInteger _userID;
    NSInteger _page;
}

- (id) initWithUserID:(NSInteger)user_id;
@end
