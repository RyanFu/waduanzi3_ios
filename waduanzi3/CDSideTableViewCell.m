//
//  CDSideTableViewCell.m
//  waduanzi3
//
//  Created by chendong on 13-6-28.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDDefine.h"
#import "CDSideTableViewCell.h"

@interface CDSideTableViewCell ()
- (void) setDefaultStyle;
@end

@implementation CDSideTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setDefaultStyle];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    self.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FBSideBarCellBackgroundSelected.png"]];
}

- (void) setDefaultStyle
{
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FBSideBarCellBackground.png"]];
    self.textLabel.textColor = [UIColor colorWithRed:0.77f green:0.80f blue:0.85f alpha:1.00f];
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accessory_arrow.png"]];
    self.textLabel.font = [UIFont systemFontOfSize:16.0f];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
 
    CGRect accessoryViewframe = self.accessoryView.frame;
    accessoryViewframe.origin.x = self.frame.size.width - DECK_LEFT_SIZE - accessoryViewframe.size.width - (self.frame.size.width - self.contentView.frame.size.width)/2;
    self.accessoryView.frame = accessoryViewframe;
}

@end
