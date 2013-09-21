//
//  CDCommentFormView.m
//  waduanzi3
//
//  Created by chendong on 13-7-9.
//  Copyright (c) 2013年 chendong. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "CDCommentFormView.h"

@interface CDCommentFormView ()
@end

@implementation CDCommentFormView

@synthesize textFieldBackgroundView = _textFieldBackgroundView;
@synthesize textField = _textField;
@synthesize submitButton = _submitButton;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75f];
        
        self.textFieldBackgroundView = [[UIImageView alloc] init];
        [self addSubview:_textFieldBackgroundView];
        
        self.textField = [[CDTextField alloc] init];
        _textField.verticalPadding = 5.0f;
        _textField.horizontalPadding = 7.5f;
        _textField.font = [UIFont systemFontOfSize:16.0f];
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.returnKeyType = UIReturnKeySend;
        _textField.placeholder = @"留下我的节操...";
        [self addSubview:_textField];
        
        self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_submitButton];
        [_submitButton setTitle:@"发送" forState:UIControlStateNormal];
        _submitButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        _submitButton.showsTouchWhenHighlighted = YES;
        UIEdgeInsets buttonImageInsets = UIEdgeInsetsMake(3, 5, 3, 5);
        UIImage *normalButtonImage = [[UIImage imageNamed:@"btn_black_normal.png"] resizableImageWithCapInsets:buttonImageInsets];
        UIImage *pressButtonImage = [[UIImage imageNamed:@"btn_black_press.png"] resizableImageWithCapInsets:buttonImageInsets];
        UIImage *disableButtonImage = [[UIImage imageNamed:@"btn_black_disable.png"] resizableImageWithCapInsets:buttonImageInsets];
        [_submitButton setBackgroundImage:normalButtonImage forState:UIControlStateNormal];
        [_submitButton setBackgroundImage:pressButtonImage forState:UIControlStateHighlighted];
        [_submitButton setBackgroundImage:disableButtonImage forState:UIControlStateDisabled];
    }
    return self;
}


- (void) layoutSubviews
{
    [super layoutSubviews];    
    CGSize viewSize = self.bounds.size;
    CGFloat contentWidth = viewSize.width - COMMENT_FORM_PADDING_LEFT_RIGHT * 3 - COMMENT_SUBMIT_BUTTON_WIDTH;
    CGFloat contentHeight = viewSize.height - COMMENT_FORM_TOP_BOTTOM * 2;
    CGRect contentFrame = CGRectMake(COMMENT_FORM_PADDING_LEFT_RIGHT, COMMENT_FORM_TOP_BOTTOM, contentWidth, contentHeight);
    _textFieldBackgroundView.frame = _textField.frame = contentFrame;
    
    if (_textFieldBackgroundView.image != nil)
        _textField.backgroundColor = [UIColor clearColor];
    
    CGFloat buttonX = contentWidth + COMMENT_FORM_PADDING_LEFT_RIGHT * 2;
    CGRect buttonFrame = CGRectMake(buttonX, COMMENT_FORM_TOP_BOTTOM, COMMENT_SUBMIT_BUTTON_WIDTH, contentHeight);
    _submitButton.frame = buttonFrame;
}

@end
