//
//  CDPostTableViewCell.m
//  waduanzi3
//
//  Created by chendong on 13-6-6.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CDPostTableViewCell.h"
#import "CDDefine.h"

@interface CDPostTableViewCell ()
- (void) setupTableCellStyle;
@end

@implementation CDPostTableViewCell

@synthesize padding = _padding;
@synthesize thumbSize = _thumbSize;
@synthesize avatarImageView = _avatarImageView;
@synthesize authorTextLabel = _authorTextLabel;
@synthesize datetimeTextLabel = _datetimeTextLabel;
@synthesize upButton = _upButton;
@synthesize commentButton = _commentButton;
@synthesize moreButton = _moreButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.multipleTouchEnabled = YES;
        self.userInteractionEnabled = YES;
        
        self.padding = 7.5f;
        self.thumbSize = CGSizeMake(THUMB_WIDTH, THUMB_HEIGHT);
        
        self.avatarImageView = [[UIImageView alloc] init];
        self.authorTextLabel = [[UILabel alloc] init];
        self.datetimeTextLabel = [[UILabel alloc] init];
        self.upButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.commentButton = [[UIButton alloc] init];
        self.moreButton = [[UIButton alloc] init];
        
        [self.contentView addSubview:_avatarImageView];
        [self.contentView addSubview:_authorTextLabel];
        [self.contentView addSubview:_datetimeTextLabel];
        [self.contentView addSubview:_upButton];
        [self.contentView addSubview:_commentButton];
        [self.contentView addSubview:_moreButton];
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
    CGFloat containerViewWidth = cellContentViewSize.width - _padding*2;
    CGFloat contentViewWidth = containerViewWidth - POST_AVATAR_WIDTH - _padding;
    
    CGFloat avatarWidth = POST_AVATAR_WIDTH;
    CGFloat avatarHeight = POST_AVATAR_WIDTH;
    
    CGFloat subContentViewX = _padding + avatarWidth + _padding;
    CGFloat subContentViewWidth = containerViewWidth - avatarWidth - _padding;
    
    CGFloat widgetY = _padding;
    CGFloat widgetHeight = avatarHeight;
    
    // avatarImageView
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    _avatarImageView.opaque = YES;
    _avatarImageView.layer.cornerRadius = 3.0f;
    _avatarImageView.clipsToBounds = YES;
    CGRect avatarViewFrame = CGRectMake(_padding, widgetY, avatarWidth, widgetHeight);
    [_avatarImageView setFrame:avatarViewFrame];
    
    // timeLabel
    CGSize timeLabelSize = [self.datetimeTextLabel.text sizeWithFont:self.datetimeTextLabel.font
                                                   constrainedToSize:CGSizeMake(containerViewWidth, 9999.0)
                                                       lineBreakMode:UILineBreakModeWordWrap];
    CGRect timeLabelFrame = CGRectMake(cellContentViewSize.width - _padding - timeLabelSize.width, widgetY, timeLabelSize.width, widgetHeight);
    [_datetimeTextLabel setFrame:timeLabelFrame];
    _datetimeTextLabel.contentMode = UIViewContentModeRight;
    [_datetimeTextLabel sizeToFit];
    _datetimeTextLabel.backgroundColor = [UIColor clearColor];
    _datetimeTextLabel.textColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f];

    // authorLabel
    CGFloat authorLabelWidth = containerViewWidth - timeLabelSize.width - widgetHeight - _padding*2;
    CGRect authorLabelFrame = CGRectMake(_padding + widgetHeight + _padding, widgetY, authorLabelWidth, widgetHeight);
    [self.authorTextLabel setFrame:authorLabelFrame];
    [_authorTextLabel sizeToFit];
    _authorTextLabel.backgroundColor = [UIColor clearColor];
    _authorTextLabel.textColor = [UIColor colorWithRed:0.37f green:0.75f blue:0.51f alpha:1.00f];

    
    widgetY += widgetHeight;
    
    // textLabel
    if (self.textLabel.text.length > 0) {
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.numberOfLines = 0;
        self.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        self.textLabel.textColor = [UIColor colorWithRed:0.01f green:0.01f blue:0.01f alpha:1.00f];
        
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
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
        self.detailTextLabel.textColor = [UIColor colorWithRed:0.01f green:0.01f blue:0.01f alpha:1.00f];
        
        CGSize detailLabelSize = [self.detailTextLabel.text sizeWithFont:self.detailTextLabel.font
                                                constrainedToSize:CGSizeMake(contentViewWidth, 9999.0)
                                                    lineBreakMode:UILineBreakModeWordWrap];
        widgetHeight = detailLabelSize.height;
        CGRect detailLabelFrame = CGRectMake(subContentViewX, widgetY, subContentViewWidth, widgetHeight);
        [self.detailTextLabel setFrame:detailLabelFrame];
        
        widgetY += widgetHeight + _padding;
    }
    
    // imageView
    if (self.imageView.image) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.opaque = YES;
        widgetHeight = _thumbSize.height;
        CGRect imageViewFrame = CGRectMake(subContentViewX, widgetY, _thumbSize.width, widgetHeight);
        [self.imageView setFrame: imageViewFrame];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(thumbImageViewDidTapFinished:)]) {
            self.imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.delegate action:@selector(thumbImageViewDidTapFinished:)];
            tapGestureRecognizer.numberOfTapsRequired = 1;
            
            [self.imageView addGestureRecognizer:tapGestureRecognizer];
        }
        
        widgetY += widgetHeight + _padding;
    }

    CGRect upButtonFrame = CGRectMake(subContentViewX, widgetY, 75.0f, 27);
    [_upButton setFrame:upButtonFrame];
    
    CGRect commentButtonFrame = upButtonFrame;
    commentButtonFrame.origin.x += 75.0f + _padding;
    [_commentButton setFrame:commentButtonFrame];
}

- (void) setupTableCellStyle
{
    self.contentMode = UIViewContentModeTopLeft;
    
    UIImage *bgImage = [[UIImage imageNamed:@"post_cell_bg.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:5.0f];
    UIImageView *bgView = [[UIImageView alloc] initWithImage:bgImage];
    bgView.contentMode = UIViewContentModeScaleToFill;
    bgView.frame = self.contentView.frame;
    self.backgroundView = bgView;
}

@end


