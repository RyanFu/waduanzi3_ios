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

@interface CDPostDetailView ()
- (void) setupSubviewsDefaultStyle;
@end

@implementation CDPostDetailView

@synthesize padding = _padding;
@synthesize imageSize = _imageSize;
@synthesize actualHeight = _actualHeight;
@synthesize isVideo = _isVideo;

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
    
    self.isVideo = NO;
    self.padding = 7.5f;
    self.imageSize = CGSizeMake(self.frame.size.width, DETAIL_THUMB_HEIGHT);
    
    self.textLabel = [[UILabel alloc] init];
    self.detailTextLabel = [[UILabel alloc] init];
    self.imageView = [[UIImageView alloc] init];
    self.avatarImageView = [[UIImageView alloc] init];
    self.authorTextLabel = [[UILabel alloc] init];
    self.datetimeTextLabel = [[UILabel alloc] init];
    
    [self addSubview:_avatarImageView];
    [self addSubview:_authorTextLabel];
    [self addSubview:_datetimeTextLabel];
    
    _videoIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newsfeedVideoPlayIcon.png"] highlightedImage:[UIImage imageNamed:@"newsfeedVideoPlayIconPressed.png"]];
    [_videoIconView sizeToFit];
    
    [self setupSubviewsDefaultStyle];
}

- (void) setupSubviewsDefaultStyle
{
    _datetimeTextLabel.contentMode = UIViewContentModeTopRight;
    _datetimeTextLabel.font = [UIFont systemFontOfSize:12.0f];
    _datetimeTextLabel.textColor = [UIColor colorWithRed:0.65f green:0.65f blue:0.65f alpha:1.00f];
    
    _authorTextLabel.contentMode = UIViewContentModeTopLeft;
    _authorTextLabel.backgroundColor = [UIColor clearColor];
    _authorTextLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    _authorTextLabel.textColor = POST_TEXT_COLOR;
    
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    _avatarImageView.opaque = YES;
    _avatarImageView.layer.cornerRadius = 3.0f;
    _avatarImageView.clipsToBounds = YES;
    _datetimeTextLabel.contentMode = UIViewContentModeRight;
    _datetimeTextLabel.backgroundColor = [UIColor clearColor];
    
    // textLabel
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.numberOfLines = 0;
    _textLabel.lineBreakMode = UILineBreakModeWordWrap;
    _textLabel.font = [UIFont systemFontOfSize:16.0f];
    _textLabel.textColor = POST_TEXT_COLOR;
    
    // detailLabel
    _detailTextLabel.backgroundColor = [UIColor clearColor];
    _detailTextLabel.numberOfLines = 0;
    _detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
    _detailTextLabel.font = [UIFont systemFontOfSize:16.0f];
    _detailTextLabel.textColor = POST_TEXT_COLOR;
    
    // imageView
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.clipsToBounds = YES;
    _imageView.opaque = YES;
    _imageView.userInteractionEnabled = YES;
}

- (void) layoutSubviews
{
    [super layoutSubviews];

    CGFloat contentViewX = _padding;
    CGSize viewSize = self.frame.size;
    CGFloat contentViewWidth = viewSize.width - _padding*2;
    
    CGFloat avatarWidth = POST_AVATAR_SIZE.width;
    CGFloat avatarHeight = POST_AVATAR_SIZE.height;
    
    CGFloat widgetY = _padding;
    CGFloat widgetHeight = avatarHeight;
    
    // avatarImageView
    CGRect avatarViewFrame = CGRectMake(_padding, widgetY, avatarWidth, widgetHeight);
    [_avatarImageView setFrame:avatarViewFrame];
    
    // timeLabel
    CGSize timeLabelSize = [_datetimeTextLabel.text sizeWithFont:_datetimeTextLabel.font
                                                   constrainedToSize:CGSizeMake(contentViewWidth, 9999.0)
                                                       lineBreakMode:UILineBreakModeWordWrap];
    CGRect timeLabelFrame = CGRectMake(viewSize.width - _padding - timeLabelSize.width, widgetY, timeLabelSize.width, widgetHeight);
    [_datetimeTextLabel setFrame:timeLabelFrame];
    [_datetimeTextLabel sizeToFit];
    
    // authorLabel
    CGFloat authorLabelWidth = contentViewWidth - timeLabelSize.width - widgetHeight - _padding*2;
    CGRect authorLabelFrame = CGRectMake(_padding + widgetHeight + _padding, widgetY, authorLabelWidth, widgetHeight);
    [_authorTextLabel setFrame:authorLabelFrame];
    [_authorTextLabel sizeToFit];
    
    widgetY += widgetHeight + _padding;
    
    // textLabel
    if (_textLabel.text.length > 0) {
        CGSize titleLabelSize = [_textLabel.text sizeWithFont:_textLabel.font
                                                constrainedToSize:CGSizeMake(contentViewWidth, 9999.0)
                                                    lineBreakMode:UILineBreakModeWordWrap];
        
        widgetHeight = titleLabelSize.height;
        CGRect titleLabelFrame = CGRectMake(contentViewX, widgetY, contentViewWidth, widgetHeight);
        [_textLabel setFrame:titleLabelFrame];
        [self addSubview:_textLabel];
        
        widgetY += widgetHeight + _padding;
    }
    
    // detailLabel
    if (_detailTextLabel.text.length > 0) {
        CGSize detailLabelSize = [_detailTextLabel.text sizeWithFont:_detailTextLabel.font
                                                       constrainedToSize:CGSizeMake(contentViewWidth, 9999.0)
                                                           lineBreakMode:UILineBreakModeWordWrap];
        widgetHeight = detailLabelSize.height;
        CGRect detailLabelFrame = CGRectMake(contentViewX, widgetY, contentViewWidth, widgetHeight);
        [_detailTextLabel setFrame:detailLabelFrame];
        [self addSubview:_detailTextLabel];
        
        widgetY += widgetHeight + _padding;
    }
    
    // imageView
    if (_imageView.image) {
        widgetHeight = _imageSize.height;
        CGRect imageViewFrame = CGRectMake(_padding, widgetY, _imageSize.width, _imageSize.height);
        [_imageView setFrame: imageViewFrame];
        [self addSubview:_imageView];
        
        if (_isVideo) {
            CGRect videoImageFrame = _videoIconView.frame;
            videoImageFrame.origin.x = self.imageView.frame.size.width/2 - videoImageFrame.size.width/2;
            videoImageFrame.origin.y = self.imageView.frame.size.height/2 - videoImageFrame.size.height/2;
            _videoIconView.frame = videoImageFrame;
            [self.imageView addSubview:_videoIconView];
        }
        
        widgetY += widgetHeight + _padding;
    }
    
    self.actualHeight = widgetY;
    
    CGRect viewFrame = self.frame;
    viewFrame.size.height = _actualHeight;
    self.frame = viewFrame;
}

@end
