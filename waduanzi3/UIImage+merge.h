//
//  UIImage+merge.h
//  waduanzi3
//
//  Created by chendong on 13-7-23.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (merge)

+ (UIImage *)mergeImage:(UIImage *)image1 withImage:(UIImage *)image2 withAlpha:(NSUInteger)alpha;

@end
