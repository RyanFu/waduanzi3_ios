//
//  QButtonTableViewCell.m
//  waduanzi3
//
//  Created by chendong on 13-9-24.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDQButtonTableViewCell.h"

@implementation CDQButtonTableViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.size.width -= textLabelFrame.origin.x * 2;
    self.textLabel.frame = textLabelFrame;
}

@end
