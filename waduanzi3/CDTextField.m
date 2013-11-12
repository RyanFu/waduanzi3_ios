//
//  CDTextField.m
//  waduanzi3
//
//  Created by chendong on 13-6-19.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDTextField.h"

@implementation CDTextField

@synthesize horizontalPadding = _horizontalPadding;
@synthesize verticalPadding = _verticalPadding;

- (CGRect) textRectForBounds:(CGRect)bounds
{
    return CGRectMake(bounds.origin.x + _horizontalPadding,
                      bounds.origin.y + _verticalPadding,
                      bounds.size.width - _horizontalPadding*2,
                      bounds.size.height - _verticalPadding*2);
}

- (CGRect) editingRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
}

@end
