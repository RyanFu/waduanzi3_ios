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
{
    UIImageView *_gifImageIconView;
    UIImageView *_longImageIconView;
}
- (void) setupTableCellStyle;
- (void) setupSubviewsDefaultStyle;
@end

@implementation CDPostTableViewCell

@synthesize thumbSize = _thumbSize;
@synthesize avatarImageView = _avatarImageView;
@synthesize authorTextLabel = _authorTextLabel;
@synthesize datetimeTextLabel = _datetimeTextLabel;
@synthesize upButton = _upButton;
@synthesize commentButton = _commentButton;
@synthesize moreButton = _moreButton;
@synthesize contentMargin = _contentMargin;
@synthesize contentPadding = _contentPadding;
@synthesize separatorHeight = _separatorHeight;
@synthesize isAnimatedGIF = _isAnimatedGIF;
@synthesize isLongImage = _isLongImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.multipleTouchEnabled = YES;
        self.userInteractionEnabled = YES;
        self.isAnimatedGIF = NO;
        self.isLongImage = NO;
        
        self.separatorHeight = POST_LIST_CELL_FRAGMENT_PADDING;
        self.contentMargin = POST_LIST_CELL_CONTENT_MARGIN;
        self.contentPadding = POST_LIST_CELL_CONTENT_PADDING;
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
        
        _gifImageIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mqz_img_gif.png"]];
        [_gifImageIconView sizeToFit];
        _longImageIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mqz_img_long.png"]];
        [_longImageIconView sizeToFit];

        
        
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
    _avatarImageView.layer.cornerRadius = 3.0f;
    _avatarImageView.clipsToBounds = YES;
    
    // datetimeTextLabel
    _datetimeTextLabel.backgroundColor = [UIColor clearColor];
    _datetimeTextLabel.textColor = [UIColor colorWithRed:0.65f green:0.65f blue:0.65f alpha:1.00f];
    
    // authorTextLabel
    _authorTextLabel.backgroundColor = [UIColor clearColor];
    _authorTextLabel.textColor = [UIColor colorWithRed:0.15f green:0.15f blue:0.15f alpha:1.00f];
    
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
    
    CGRect contentViewFrame = self.frame;
    contentViewFrame.origin.x = _contentMargin.left;
    contentViewFrame.origin.y = _contentMargin.top;
    contentViewFrame.size.width -= _contentMargin.left + _contentMargin.right;
    contentViewFrame.size.height -= _contentMargin.top + _contentMargin.bottom;
    self.contentView.frame = contentViewFrame;
    self.contentView.layer.cornerRadius = 3.0f;
    self.contentView.layer.borderColor = [UIColor colorWithRed:0.76f green:0.77f blue:0.78f alpha:1.00f].CGColor;
    self.contentView.layer.borderWidth = 1.0f;
    
    
    CGSize contentViewSize = self.contentView.frame.size;
    CGFloat containerViewWidth = contentViewSize.width;
    CGFloat contentBlockWidth = containerViewWidth  - _contentPadding.left - _contentPadding.right;
    
    CGFloat widgetY = _contentPadding.top;
    CGFloat widgetHeight = POST_AVATAR_SIZE.height;
    
    // avatarImageView
    CGRect avatarViewFrame = CGRectMake(_contentPadding.left, widgetY, POST_AVATAR_SIZE.width, POST_AVATAR_SIZE.height);
    [_avatarImageView setFrame:avatarViewFrame];
    
    // timeLabel
    CGSize timeLabelSize = [self.datetimeTextLabel.text sizeWithFont:self.datetimeTextLabel.font];
    CGRect timeLabelFrame = CGRectMake(contentViewSize.width - _contentPadding.right - timeLabelSize.width, widgetY, timeLabelSize.width, 0);
    [_datetimeTextLabel setFrame:timeLabelFrame];
    [_datetimeTextLabel sizeToFit];

    // authorLabel
//    CGFloat authorLabelWidth = containerViewWidth - timeLabelSize.width - widgetHeight - _separatorHeight*2;
    CGRect authorLabelFrame = CGRectMake(_contentPadding.left + widgetHeight + _separatorHeight, widgetY, 0, 0);
    [self.authorTextLabel setFrame:authorLabelFrame];
    [_authorTextLabel sizeToFit];

    
    widgetY += widgetHeight + _separatorHeight;
    
    // textLabel
    if (self.textLabel.text.length > 0) {
        CGSize titleLabelSize = [self.textLabel.text sizeWithFont:self.textLabel.font
                                                       constrainedToSize:CGSizeMake(contentBlockWidth, 9999.0)
                                                           lineBreakMode:UILineBreakModeCharacterWrap];
        
        widgetHeight = titleLabelSize.height;
        CGRect titleLabelFrame = CGRectMake(_contentPadding.left, widgetY, contentBlockWidth, widgetHeight);
        [self.textLabel setFrame:titleLabelFrame];
        
        widgetY += widgetHeight + _separatorHeight;
    }
    
    // detailLabel
    if (self.detailTextLabel.text.length > 0) {
        CGSize detailLabelSize = [self.detailTextLabel.text sizeWithFont:self.detailTextLabel.font
                                                constrainedToSize:CGSizeMake(contentBlockWidth, 9999.0)
                                                    lineBreakMode:UILineBreakModeCharacterWrap];
        widgetHeight = detailLabelSize.height;
        CGRect detailLabelFrame = CGRectMake(_contentPadding.left, widgetY, contentBlockWidth, widgetHeight);
        [self.detailTextLabel setFrame:detailLabelFrame];
        
        widgetY += widgetHeight + _separatorHeight;
    }
    
    // imageView
    if (self.imageView.image) {
        widgetHeight = _thumbSize.height;
        CGRect imageViewFrame = CGRectMake(_contentPadding.left, widgetY, _thumbSize.width, widgetHeight);
        [self.imageView setFrame: imageViewFrame];
        
        if (_gifImageIconView.superview != nil)
            [_gifImageIconView removeFromSuperview];
        if (_longImageIconView.superview != nil)
            [_longImageIconView removeFromSuperview];
        
        if (_isAnimatedGIF) {
            CGRect gifImageFrame = _gifImageIconView.frame;
            gifImageFrame.origin.x = self.imageView.frame.size.width - gifImageFrame.size.width;
            gifImageFrame.origin.y = self.imageView.frame.size.height - gifImageFrame.size.height;
            _gifImageIconView.frame = gifImageFrame;
            [self.imageView addSubview:_gifImageIconView];
        }
        else if (_isLongImage) {
            CGRect longImageFrame = _longImageIconView.frame;
            longImageFrame.origin.x = self.imageView.frame.size.width - longImageFrame.size.width;
            longImageFrame.origin.y = self.imageView.frame.size.height - longImageFrame.size.height;
            _longImageIconView.frame = longImageFrame;

            [self.imageView addSubview:_longImageIconView];
        }

        if (self.delegate && [self.delegate respondsToSelector:@selector(thumbImageViewDidTapFinished:)]) {
            self.imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.delegate action:@selector(thumbImageViewDidTapFinished:)];
            tapGestureRecognizer.numberOfTapsRequired = 1;
            
            [self.imageView addGestureRecognizer:tapGestureRecognizer];
        }
        
        widgetY += widgetHeight + _separatorHeight;
    }

    CGRect buttonFrame = CGRectMake(contentViewSize.width - _contentMargin.right - _contentPadding.right - 70.0f, widgetY, 70.0f, 30);
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
    self.contentView.backgroundColor = [UIColor whiteColor];
}

@end


