//
//  ImageDetailViewController.h
//  waduanzi2
//
//  Created by Chen Dong on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ImageDetailViewController : UIViewController <UIScrollViewDelegate, MBProgressHUDDelegate> {
    UIButton *saveButton;
    UIScrollView *imageScrollView;
    UIImageView *imageShowView;
}

@property (nonatomic, retain) UIImage *thumbnail;
@property (nonatomic, retain) UIImage *originaPic;
@property (nonatomic, retain) NSURL *originalPicUrl;
@end
