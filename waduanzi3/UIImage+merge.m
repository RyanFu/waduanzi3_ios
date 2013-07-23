//
//  UIImage+merge.m
//  waduanzi3
//
//  Created by chendong on 13-7-23.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "UIImage+merge.h"

@implementation UIImage (merge)

+ (UIImage *)mergeImage:(UIImage *)image1 withImage:(UIImage *)image2 withAlpha:(NSUInteger)alpha
{
    UIGraphicsBeginImageContextWithOptions(image1.size, YES, 0.0);
    [image1 drawAtPoint:CGPointMake(0, 0) blendMode:kCGBlendModeNormal alpha:1.0f];
    [image2 drawAtPoint:CGPointMake(0, 0) blendMode:kCGBlendModeNormal alpha:alpha];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
