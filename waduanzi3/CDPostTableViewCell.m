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
- (void) setupSubviewsDefaultStyle;
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
        // MARK: 以后添加列表中的更多按钮
//        [self.contentView addSubview:_moreButton];
        
        [self setupSubviewsDefaultStyle];
        
//        self.upButton.layer.borderWidth = self.commentButton.layer.borderWidth = self.moreButton.layer.borderWidth = 1.0f;
//        self.upButton.layer.borderColor = self.commentButton.layer.borderColor = self.moreButton.layer.borderColor = [UIColor redColor].CGColor;
    }
    return self;
}

- (void) setupSubviewsDefaultStyle
{
    // avatarImageView
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    _avatarImageView.opaque = YES;
    _avatarImageView.layer.cornerRadius = 3.0f;
    _avatarImageView.clipsToBounds = YES;
    
    // datetimeTextLabel
    _datetimeTextLabel.backgroundColor = [UIColor clearColor];
    _datetimeTextLabel.textColor = [UIColor colorWithRed:0.65f green:0.65f blue:0.65f alpha:1.00f];
    
    // authorTextLabel
    _authorTextLabel.backgroundColor = [UIColor clearColor];
    _authorTextLabel.textColor = [UIColor colorWithRed:0.20f green:0.30f blue:0.55f alpha:1.00f];
    
    // textLabel
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.numberOfLines = 0;
    self.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.textLabel.textColor = [UIColor colorWithRed:0.16f green:0.16f blue:0.16f alpha:1.00f];
    
    //detailTextLabel
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.numberOfLines = 0;
    self.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.detailTextLabel.textColor = [UIColor colorWithRed:0.16f green:0.16f blue:0.16f alpha:1.00f];
    
    // imageView
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    self.imageView.opaque = YES;
    
    
    self.upButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.commentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.moreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
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
    CGRect avatarViewFrame = CGRectMake(_padding, widgetY, avatarWidth, widgetHeight);
    [_avatarImageView setFrame:avatarViewFrame];
    
    // timeLabel
    CGSize timeLabelSize = [self.datetimeTextLabel.text sizeWithFont:self.datetimeTextLabel.font
                                                   constrainedToSize:CGSizeMake(containerViewWidth, 9999.0)
                                                       lineBreakMode:UILineBreakModeWordWrap];
    CGRect timeLabelFrame = CGRectMake(cellContentViewSize.width - _padding - timeLabelSize.width, widgetY, timeLabelSize.width, widgetHeight);
    [_datetimeTextLabel setFrame:timeLabelFrame];
    [_datetimeTextLabel sizeToFit];

    // authorLabel
    CGFloat authorLabelWidth = containerViewWidth - timeLabelSize.width - widgetHeight - _padding*2;
    CGRect authorLabelFrame = CGRectMake(_padding + widgetHeight + _padding, widgetY, authorLabelWidth, widgetHeight);
    [self.authorTextLabel setFrame:authorLabelFrame];
    [_authorTextLabel sizeToFit];

    
    widgetY += widgetHeight;
    
    // textLabel
    if (self.textLabel.text.length > 0) {
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

    CGRect buttonFrame = CGRectMake(cellContentViewSize.width - _padding*2 - 70.0f, widgetY, 70.0f, 30);
    // MARK: 以后添加列表中的更多按钮
//    [_moreButton setFrame:buttonFrame];
//    buttonFrame.origin.x -= buttonFrame.size.width;
    [_commentButton setFrame:buttonFrame];
    buttonFrame.origin.x -= buttonFrame.size.width;
    [_upButton setFrame:buttonFrame];
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


