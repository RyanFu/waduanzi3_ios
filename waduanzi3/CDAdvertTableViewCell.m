//
//  CDPostTableViewCell.m
//  waduanzi3
//
//  Created by chendong on 13-6-6.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CDAdvertTableViewCell.h"

#define ADVERT_IMAGE_HEIGHT 300.0f
#define INSTALL_VIEW_EDGEINSETS UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f)
#define INSTALL_BUTTON_SIZE  CGSizeMake(73.0f, 35.0f)


@interface CDAdvertTableViewCell ()

- (void) setupTableCellStyle;
- (void) setupSubviewsDefaultStyle;
@end

@implementation CDAdvertTableViewCell

@synthesize avatarImageView = _avatarImageView;
@synthesize authorTextLabel = _authorTextLabel;
@synthesize appNameLabel = _appNameLabel;
@synthesize installButton = _installButton;
@synthesize contentMargin = _contentMargin;
@synthesize contentPadding = _contentPadding;
@synthesize separatorHeight = _separatorHeight;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.multipleTouchEnabled = YES;
        self.userInteractionEnabled = YES;
        
        self.separatorHeight = POST_LIST_CELL_FRAGMENT_PADDING;
        self.contentMargin = POST_LIST_CELL_CONTENT_MARGIN;
        self.contentPadding = POST_LIST_CELL_CONTENT_PADDING;
        
        self.avatarImageView = [[UIImageView alloc] init];
        self.authorTextLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_avatarImageView];
        [self.contentView addSubview:_authorTextLabel];
        
        _installView = [[UIView alloc] init];
        [self.contentView addSubview:_installView];
        
        self.appNameLabel = [[UILabel alloc] init];
        [_installView addSubview:_appNameLabel];
        
        self.installButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_installView addSubview:_installButton];
        
        [self setupTableCellStyle];
        [self setupSubviewsDefaultStyle];
    }
    return self;
}

- (void) setupSubviewsDefaultStyle
{
    self.contentView.layer.cornerRadius = 3.0f;
    self.contentView.layer.borderColor = [UIColor colorWithRed:0.76f green:0.77f blue:0.78f alpha:1.00f].CGColor;
    self.contentView.layer.borderWidth = 1.0f;
    
    CGFloat contentBlockWidth = self.frame.size.width - _contentMargin.left - _contentMargin.right  - _contentPadding.left - _contentPadding.right;
    
    // avatarImageView
    _avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    _avatarImageView.opaque = YES;
    _avatarImageView.layer.cornerRadius = 3.0f;
    _avatarImageView.clipsToBounds = YES;
    
    // authorTextLabel
    _authorTextLabel.backgroundColor = [UIColor clearColor];
    _authorTextLabel.textColor = POST_TEXT_COLOR;
    
    // textLabel
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.numberOfLines = 0;
    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.textLabel.textColor = POST_TEXT_COLOR;
    
    //detailTextLabel
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.numberOfLines = 0;
    self.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.detailTextLabel.textColor = POST_TEXT_COLOR;
    
    // imageView
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    self.imageView.opaque = YES;
    
    _installView.frame = CGRectMake(_contentPadding.left, 0, contentBlockWidth, INSTALL_BUTTON_SIZE.height + INSTALL_VIEW_EDGEINSETS.top + INSTALL_VIEW_EDGEINSETS.bottom);
    _installView.backgroundColor = [UIColor colorWithRed:0.94f green:0.95f blue:0.96f alpha:1.00f];
    _appNameLabel.frame = CGRectMake(INSTALL_VIEW_EDGEINSETS.left,
                                     INSTALL_VIEW_EDGEINSETS.top,
                                     contentBlockWidth - INSTALL_VIEW_EDGEINSETS.left*2 - INSTALL_VIEW_EDGEINSETS.right-INSTALL_BUTTON_SIZE.width,
                                     INSTALL_BUTTON_SIZE.height);
    _appNameLabel.backgroundColor = [UIColor clearColor];
    _appNameLabel.textColor = POST_TEXT_COLOR;
    _appNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _appNameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    
    _installButton.frame = CGRectMake(contentBlockWidth - INSTALL_VIEW_EDGEINSETS.right - INSTALL_BUTTON_SIZE.width,
                                      INSTALL_VIEW_EDGEINSETS.top,
                                      INSTALL_BUTTON_SIZE.width,
                                      INSTALL_BUTTON_SIZE.height);
    UIImage *buttonBackgroundImage = [[UIImage imageNamed:@"installnow_gray_button_background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(25, 5, 5, 5)];
    [_installButton setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    _installButton.userInteractionEnabled = NO;
    [_installButton setTitle:@"立即安装" forState:UIControlStateNormal];
    [_installButton setTitleColor:POST_TEXT_COLOR forState:UIControlStateNormal];
    _installButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
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
    
    
    CGSize contentViewSize = contentViewFrame.size;
    CGFloat contentBlockWidth = contentViewSize.width  - _contentPadding.left - _contentPadding.right;
    
    CGFloat widgetY = _contentPadding.top;
    CGFloat widgetHeight = POST_AVATAR_SIZE.height;
    
    // avatarImageView
    CGRect avatarViewFrame = CGRectMake(_contentPadding.left, widgetY, POST_AVATAR_SIZE.width, POST_AVATAR_SIZE.height);
    [_avatarImageView setFrame:avatarViewFrame];
    
    // authorLabel
    CGRect authorLabelFrame = CGRectMake(_contentPadding.left + widgetHeight + _separatorHeight, widgetY, 0, 0);
    [self.authorTextLabel setFrame:authorLabelFrame];
    [_authorTextLabel sizeToFit];

    
    widgetY += widgetHeight + _separatorHeight;
    
    // textLabel
    if (self.textLabel.text.length > 0) {
        CGSize titleLabelSize = [self.textLabel.text sizeWithFont:self.textLabel.font
                                                       constrainedToSize:CGSizeMake(contentBlockWidth, 9999.0)
                                                           lineBreakMode:NSLineBreakByWordWrapping];
        
        widgetHeight = titleLabelSize.height;
        CGRect titleLabelFrame = CGRectMake(_contentPadding.left, widgetY, contentBlockWidth, widgetHeight);
        [self.textLabel setFrame:titleLabelFrame];
        
        widgetY += widgetHeight + _separatorHeight;
    }
    
    // detailLabel
    if (self.detailTextLabel.text.length > 0) {
        CGSize detailLabelSize = [self.detailTextLabel.text sizeWithFont:self.detailTextLabel.font
                                                constrainedToSize:CGSizeMake(contentBlockWidth, 9999.0)
                                                    lineBreakMode:NSLineBreakByWordWrapping];
        widgetHeight = detailLabelSize.height;
        CGRect detailLabelFrame = CGRectMake(_contentPadding.left, widgetY, contentBlockWidth, widgetHeight);
        [self.detailTextLabel setFrame:detailLabelFrame];
        
        widgetY += widgetHeight + _separatorHeight;
    }
    
    // imageView
    if (self.imageView.image) {
        widgetHeight = ADVERT_IMAGE_HEIGHT;
        CGRect imageViewFrame = CGRectMake(_contentPadding.left, widgetY, contentBlockWidth, widgetHeight);
        [self.imageView setFrame: imageViewFrame];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(advertImageViewDidTapFinished:)]) {
            self.imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.delegate action:@selector(advertImageViewDidTapFinished:)];
            self.imageView.userInteractionEnabled = YES;
            tapGestureRecognizer.numberOfTapsRequired = 1;
            [self.imageView addGestureRecognizer:tapGestureRecognizer];
        }
        else
            self.imageView.userInteractionEnabled = NO;
        
        widgetY += widgetHeight; // 安装按钮紧跟图片下方，所以此处不加 _separatorHeight
    }
    
    CGRect installViewFrame = _installView.frame;
    installViewFrame.origin.y = widgetY;
    _installView.frame = installViewFrame;

}

- (void) setupTableCellStyle
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.contentMode = UIViewContentModeTopLeft;
    self.contentView.backgroundColor = [UIColor whiteColor];
}



- (CGFloat) realHeight
{
    CGFloat contentBlockWidth = self.frame.size.width - _contentMargin.left - _contentMargin.right  - _contentPadding.left - _contentPadding.right;
    
    CGFloat height = _contentMargin.top + _contentPadding.top + POST_AVATAR_SIZE.height + _separatorHeight;
    
    // textLabel
    if (self.textLabel.text.length > 0) {
        CGSize titleLabelSize = [self.textLabel.text sizeWithFont:self.textLabel.font
                                                constrainedToSize:CGSizeMake(contentBlockWidth, 9999.0)
                                                    lineBreakMode:NSLineBreakByWordWrapping];
        
        height += titleLabelSize.height + _separatorHeight;
    }
    
    // detailLabel
    if (self.detailTextLabel.text.length > 0) {
        CGSize detailLabelSize = [self.detailTextLabel.text sizeWithFont:self.detailTextLabel.font
                                                       constrainedToSize:CGSizeMake(contentBlockWidth, 9999.0)
                                                           lineBreakMode:NSLineBreakByWordWrapping];
        height += detailLabelSize.height + _separatorHeight;
    }
    
    // imageView
    if (self.imageView.image)
        height += ADVERT_IMAGE_HEIGHT + _separatorHeight;
    else
        height += _separatorHeight;
    
    // buttons
    height += _installView.frame.size.height; // 最后一个不加 _separatorHeight
    
    return height + _contentPadding.bottom + _contentMargin.bottom;
}

@end




