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
{
    CALayer *_bottomLineLayer;
}
- (void) setupTableCellStyle;
- (void) setupSubviewsDefaultStyle;
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
        
        [self.contentView addSubview:_avatarImageView];
        [self.contentView addSubview:_authorTextLabel];
        [self.contentView addSubview:_orderTextLabel];
        
        _bottomLineLayer = [CALayer layer];
        _bottomLineLayer.backgroundColor = [UIColor colorWithRed:0.87f green:0.87f blue:0.87f alpha:1.00f].CGColor;
        [self.layer addSublayer:_bottomLineLayer];
        
        [self setupTableCellStyle];
        [self setupSubviewsDefaultStyle];
    }
    return self;
}

- (void) setupSubviewsDefaultStyle
{
    // avatarImageView
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    _avatarImageView.opaque = YES;
    
    // orderLabel
    _orderTextLabel.font = [UIFont systemFontOfSize:12.0f];
    _orderTextLabel.textColor = [UIColor colorWithRed:0.65f green:0.65f blue:0.65f alpha:1.00f];
    _orderTextLabel.contentMode = UIViewContentModeRight;
    _orderTextLabel.backgroundColor = [UIColor clearColor];
    
    // authorLabel
    _authorTextLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    _authorTextLabel.textColor = [UIColor colorWithRed:0.15f green:0.15f blue:0.15f alpha:1.00f];
    _authorTextLabel.backgroundColor = [UIColor clearColor];
    
    // textLabel
    self.textLabel.numberOfLines = 0;
    self.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.textLabel.font = [UIFont systemFontOfSize:14.0f];
    self.textLabel.textColor = [UIColor colorWithRed:0.16f green:0.16f blue:0.16f alpha:1.00f];
    self.textLabel.backgroundColor = [UIColor clearColor];
    
    // detailLabel
    self.detailTextLabel.numberOfLines = 0;
    self.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
    self.detailTextLabel.textColor = [UIColor colorWithRed:0.16f green:0.16f blue:0.16f alpha:1.00f];
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGSize cellContentViewSize = self.contentView.frame.size;
    CGFloat contentViewWidth = cellContentViewSize.width - _padding*2;
    
    CGFloat avatarWidth = COMMENT_AVATAR_WIDTH;
    CGFloat avatarHeight = COMMENT_AVATAR_WIDTH;
    
    CGFloat subContentViewX = _padding + avatarWidth + _padding;
    CGFloat subContentViewWidth = contentViewWidth - avatarWidth - _padding;
    
    CGFloat widgetY = _padding;
    CGFloat widgetHeight = avatarHeight;
    
    // avatarImageView
    CGRect avatarViewFrame = CGRectMake(_padding, widgetY, avatarWidth, widgetHeight);
    [_avatarImageView setFrame:avatarViewFrame];
    
    // orderLabel
    CGSize orderLabelSize = [self.orderTextLabel.text sizeWithFont:self.orderTextLabel.font
                                                   constrainedToSize:CGSizeMake(contentViewWidth, 9999.0)
                                                       lineBreakMode:UILineBreakModeWordWrap];
    CGRect orderLabelFrame = CGRectMake(cellContentViewSize.width - _padding - orderLabelSize.width, widgetY, orderLabelSize.width, widgetHeight);
    [_orderTextLabel setFrame:orderLabelFrame];
    [_orderTextLabel sizeToFit];
    
    // authorLabel
    CGFloat authorLabelWidth = contentViewWidth - orderLabelSize.width - widgetHeight - _padding*2;
    CGRect authorLabelFrame = CGRectMake(_padding + widgetHeight + _padding, widgetY, authorLabelWidth, widgetHeight);
    [self.authorTextLabel setFrame:authorLabelFrame];
    [_authorTextLabel sizeToFit];
    
    widgetY += (_authorTextLabel.frame.size.height + COMMENT_BLOCK_SPACE_HEIGHT);
    
    // textLabel
    if (self.textLabel.text.length > 0) {
        CGSize titleLabelSize = [self.textLabel.text sizeWithFont:self.textLabel.font
                                                       constrainedToSize:CGSizeMake(contentViewWidth, 9999.0)
                                                           lineBreakMode:UILineBreakModeWordWrap];
        
        widgetHeight = titleLabelSize.height;
        CGRect titleLabelFrame = CGRectMake(subContentViewX, widgetY, subContentViewWidth, widgetHeight);
        [self.textLabel setFrame:titleLabelFrame];
        
        widgetY += widgetHeight + COMMENT_BLOCK_SPACE_HEIGHT;
    }
    
    // detailLabel
    if (self.detailTextLabel.text.length > 0) {
        CGSize detailLabelSize = [self.detailTextLabel.text sizeWithFont:self.detailTextLabel.font
                                                constrainedToSize:CGSizeMake(contentViewWidth, 9999.0)
                                                    lineBreakMode:UILineBreakModeWordWrap];
        widgetHeight = detailLabelSize.height;
        CGRect detailLabelFrame = CGRectMake(subContentViewX, widgetY, subContentViewWidth, widgetHeight);
        [self.detailTextLabel setFrame:detailLabelFrame];
        
//        widgetY += widgetHeight + _padding;
    }
    
    
    _bottomLineLayer.frame = CGRectMake(0, self.frame.size.height - 1.0f, self.frame.size.width, 1.0f);
}

- (void) setupTableCellStyle
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentMode = UIViewContentModeTopLeft;
    self.contentView.backgroundColor = [UIColor whiteColor];
}

@end


