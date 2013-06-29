//
//  CDSideTableViewCell.m
//  waduanzi3
//
//  Created by chendong on 13-6-28.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDDefine.h"
#import "CDSideTableViewCell.h"

@implementation CDSideTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) layoutSubviews
{
    [super layoutSubviews];
 
    CGRect accessoryViewframe = self.accessoryView.frame;
    accessoryViewframe.origin.x = self.frame.size.width - DECK_LEFT_SIZE - accessoryViewframe.size.width - (self.frame.size.width - self.contentView.frame.size.width)/2;
    self.accessoryView.frame = accessoryViewframe;
}

@end
