//
//  CDPostDetailView.m
//  waduanzi3
//
//  Created by chendong on 13-6-10.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CDPostDetailView.h"
#import "CDDefine.h"

@implementation CDPostDetailView

@synthesize padding = _padding;
@synthesize imageSize = _imageSize;
@synthesize actualHeight = _actualHeight;

@synthesize textLabel = _textLabel;
@synthesize detailTextLabel = _detailTextLabel;
@synthesize imageView = _imageView;
@synthesize avatarImageView = _avatarImageView;
@synthesize authorTextLabel = _authorTextLabel;
@synthesize datetimeTextLabel = _datetimeTextLabel;

- (id)init
{
    self = [super init];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}


- (void)initSubViews
{
    self.multipleTouchEnabled = YES;
    self.userInteractionEnabled = YES;
    
    self.padding = 7.5f;
    self.imageSize = CGSizeMake(self.frame.size.width, THUMB_HEIGHT);
    
    self.textLabel = [[UILabel alloc] init];
    self.detailTextLabel = [[UILabel alloc] init];
    self.imageView = [[UIImageView alloc] init];
    self.avatarImageView = [[UIImageView alloc] init];
    self.authorTextLabel = [[UILabel alloc] init];
    self.datetimeTextLabel = [[UILabel alloc] init];
    
    [self addSubview:_avatarImageView];
    [self addSubview:_authorTextLabel];
    [self addSubview:_datetimeTextLabel];
}

- (void) layoutSubviews
{
    [super layoutSubviews];

    CGFloat contentViewX = _padding;
    CGSize viewSize = self.frame.size;
    CGFloat contentViewWidth = viewSize.width - _padding*2;
    
    CGFloat avatarWidth = POST_AVATAR_WIDTH;
    CGFloat avatarHeight = POST_AVATAR_WIDTH;
    
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
    self.datetimeTextLabel.font = [UIFont systemFontOfSize:14.0f];
    self.datetimeTextLabel.textColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f];
    CGSize timeLabelSize = [self.datetimeTextLabel.text sizeWithFont:self.datetimeTextLabel.font
                                                   constrainedToSize:CGSizeMake(contentViewWidth, 9999.0)
                                                       lineBreakMode:UILineBreakModeWordWrap];
    CGRect timeLabelFrame = CGRectMake(viewSize.width - _padding - timeLabelSize.width, widgetY, timeLabelSize.width, widgetHeight);
    [_datetimeTextLabel setFrame:timeLabelFrame];
    _datetimeTextLabel.contentMode = UIViewContentModeRight;
    [_datetimeTextLabel sizeToFit];
    _datetimeTextLabel.backgroundColor = [UIColor clearColor];
    
    // authorLabel
    CGFloat authorLabelWidth = contentViewWidth - timeLabelSize.width - widgetHeight - _padding*2;
    CGRect authorLabelFrame = CGRectMake(_padding + widgetHeight + _padding, widgetY, authorLabelWidth, widgetHeight);
    [self.authorTextLabel setFrame:authorLabelFrame];
    [_authorTextLabel sizeToFit];
    _authorTextLabel.backgroundColor = [UIColor clearColor];
    self.authorTextLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    self.authorTextLabel.textColor = [UIColor colorWithRed:0.37f green:0.75f blue:0.51f alpha:1.00f];
    
    widgetY += widgetHeight + _padding;
    
    // textLabel
    if (self.textLabel.text.length > 0) {
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.numberOfLines = 0;
        self.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        self.textLabel.font = [UIFont systemFontOfSize:16.0f];
        self.textLabel.textColor = [UIColor colorWithRed:0.01f green:0.01f blue:0.01f alpha:1.00f];
        CGSize titleLabelSize = [self.textLabel.text sizeWithFont:self.textLabel.font
                                                constrainedToSize:CGSizeMake(contentViewWidth, 9999.0)
                                                    lineBreakMode:UILineBreakModeWordWrap];
        
        widgetHeight = titleLabelSize.height;
        CGRect titleLabelFrame = CGRectMake(contentViewX, widgetY, contentViewWidth, widgetHeight);
        [self.textLabel setFrame:titleLabelFrame];
        [self addSubview:_textLabel];
        
        widgetY += widgetHeight + _padding;
    }
    
    // detailLabel
    if (self.detailTextLabel.text.length > 0) {
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
        self.detailTextLabel.font = [UIFont systemFontOfSize:16.0f];
        self.detailTextLabel.textColor = [UIColor colorWithRed:0.01f green:0.01f blue:0.01f alpha:1.00f];
        CGSize detailLabelSize = [self.detailTextLabel.text sizeWithFont:self.detailTextLabel.font
                                                       constrainedToSize:CGSizeMake(contentViewWidth, 9999.0)
                                                           lineBreakMode:UILineBreakModeWordWrap];
        widgetHeight = detailLabelSize.height;
        CGRect detailLabelFrame = CGRectMake(contentViewX, widgetY, contentViewWidth, widgetHeight);
        [self.detailTextLabel setFrame:detailLabelFrame];
        [self addSubview:_detailTextLabel];
        
        widgetY += widgetHeight + _padding;
    }
    
    // imageView
    if (self.imageView.image) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.opaque = YES;
        self.imageView.userInteractionEnabled = YES;
        widgetHeight = _imageSize.height;
        CGRect imageViewFrame = CGRectMake(_padding, widgetY, _imageSize.width, _imageSize.height);
        [self.imageView setFrame: imageViewFrame];
        [self addSubview:_imageView];
        
        widgetY += widgetHeight + _padding;
    }
    
    self.actualHeight = widgetY;
    
    CGRect viewFrame = self.frame;
    viewFrame.size.height = _actualHeight;
    self.frame = viewFrame;
}

@end
