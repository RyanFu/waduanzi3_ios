//
//  CDPostTableViewCell.m
//  waduanzi3
//
//  Created by chendong on 13-6-6.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CDCommentTableViewCell.h"
#import "CDDefine.h"

@interface CDCommentTableViewCell ()
- (void) setupTableCellStyle;
@end

@implementation CDCommentTableViewCell

@synthesize padding = _padding;
@synthesize avatarImageView = _avatarImageView;
@synthesize authorTextLabel = _authorTextLabel;
@synthesize orderTextLabel = _orderTextLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.multipleTouchEnabled = YES;
        self.userInteractionEnabled = YES;
        
        self.padding = 10.0f;
        
        self.avatarImageView = [[UIImageView alloc] init];
        self.authorTextLabel = [[UILabel alloc] init];
        self.orderTextLabel = [[UILabel alloc] init];
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:14.0f];
        self.detailTextLabel.textColor = [UIColor colorWithRed:0.01f green:0.01f blue:0.01f alpha:1.00f];
        self.authorTextLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        self.authorTextLabel.textColor = [UIColor colorWithRed:0.20f green:0.30f blue:0.55f alpha:1.00f];
        self.orderTextLabel.font = [UIFont systemFontOfSize:14.0f];
        self.orderTextLabel.textColor = [UIColor colorWithRed:0.65f green:0.65f blue:0.65f alpha:1.00f];
        
        [self.contentView addSubview:_avatarImageView];
        [self.contentView addSubview:_authorTextLabel];
        [self.contentView addSubview:_orderTextLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [self setupTableCellStyle];
    
    CGSize cellContentViewSize = self.contentView.frame.size;
    CGFloat contentViewWidth = cellContentViewSize.width - _padding*2;
    
    CGFloat avatarWidth = COMMENT_AVATAR_WIDTH;
    CGFloat avatarHeight = COMMENT_AVATAR_WIDTH;
    
    CGFloat subContentViewX = _padding + avatarWidth + _padding;
    CGFloat subContentViewWidth = contentViewWidth - avatarWidth - _padding;
    
    CGFloat widgetY = _padding;
    CGFloat widgetHeight = avatarHeight;
    
    // avatarImageView
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    _avatarImageView.opaque = YES;
    CGRect avatarViewFrame = CGRectMake(_padding, widgetY, avatarWidth, widgetHeight);
    [_avatarImageView setFrame:avatarViewFrame];
    
    // timeLabel
    CGSize timeLabelSize = [self.orderTextLabel.text sizeWithFont:self.orderTextLabel.font
                                                   constrainedToSize:CGSizeMake(contentViewWidth, 9999.0)
                                                       lineBreakMode:UILineBreakModeWordWrap];
    CGRect timeLabelFrame = CGRectMake(cellContentViewSize.width - _padding - timeLabelSize.width, widgetY, timeLabelSize.width, widgetHeight);
    [_orderTextLabel setFrame:timeLabelFrame];
    _orderTextLabel.contentMode = UIViewContentModeRight;
    [_orderTextLabel sizeToFit];
    _orderTextLabel.backgroundColor = [UIColor clearColor];
    
    // authorLabel
    CGFloat authorLabelWidth = contentViewWidth - timeLabelSize.width - widgetHeight - _padding*2;
    CGRect authorLabelFrame = CGRectMake(_padding + widgetHeight + _padding, widgetY, authorLabelWidth, widgetHeight);
    [self.authorTextLabel setFrame:authorLabelFrame];
    [_authorTextLabel sizeToFit];
    _authorTextLabel.backgroundColor = [UIColor clearColor];
    
    widgetY += widgetHeight;
    
    // textLabel
    if (self.textLabel.text.length > 0) {
        self.textLabel.numberOfLines = 0;
        self.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        self.textLabel.textColor = [UIColor colorWithRed:0.16f green:0.16f blue:0.16f alpha:1.00f];
        CGSize titleLabelSize = [self.textLabel.text sizeWithFont:self.textLabel.font
                                                       constrainedToSize:CGSizeMake(contentViewWidth, 9999.0)
                                                           lineBreakMode:UILineBreakModeWordWrap];
        
        widgetHeight = titleLabelSize.height;
        CGRect titleLabelFrame = CGRectMake(subContentViewX, widgetY, subContentViewWidth, widgetHeight);
        [self.textLabel setFrame:titleLabelFrame];
        
        widgetY += widgetHeight + _padding;
    }
    
    // detailLabel
    if (self.detailTextLabel.text.length > 0) {
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
        self.detailTextLabel.textColor = [UIColor colorWithRed:0.16f green:0.16f blue:0.16f alpha:1.00f];
        CGSize detailLabelSize = [self.detailTextLabel.text sizeWithFont:self.detailTextLabel.font
                                                constrainedToSize:CGSizeMake(contentViewWidth, 9999.0)
                                                    lineBreakMode:UILineBreakModeWordWrap];
        widgetHeight = detailLabelSize.height;
        CGRect detailLabelFrame = CGRectMake(subContentViewX, widgetY, subContentViewWidth, widgetHeight);
        [self.detailTextLabel setFrame:detailLabelFrame];
        
        widgetY += widgetHeight + _padding;
    }
}

- (void) setupTableCellStyle
{
    self.contentMode = UIViewContentModeTopLeft;
    
    UIImage *bgImage = [[UIImage imageNamed:@"post_cell_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 5.0f, 0)];
    UIImageView *bgView = [[UIImageView alloc] initWithImage:bgImage];
    bgView.contentMode = UIViewContentModeScaleToFill;
    bgView.frame = self.contentView.frame;
    self.backgroundView = bgView;
}

@end


