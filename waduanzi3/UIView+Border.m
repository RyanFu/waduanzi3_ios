//
//  UIView+Border.m
//  waduanzi3
//
//  Created by chendong on 13-9-20.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UIView+Border.h"

@implementation UIView (Border)

- (void) showBorder:(CGFloat)width color:(CGColorRef)color radius:(CGFloat)radius
{
    self.layer.borderColor = color;
    self.layer.borderWidth = width;
    self.layer.cornerRadius = radius;
}
@end
