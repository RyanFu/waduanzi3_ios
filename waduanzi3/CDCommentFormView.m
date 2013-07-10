//
//  CDCommentFormView.m
//  waduanzi3
//
//  Created by chendong on 13-7-9.
//  Copyright (c) 2013年 chendong. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "CDCommentFormView.h"

@implementation CDCommentFormView

@synthesize contentField = _contentField;
@synthesize submitButton = _submitButton;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        self.contentField = [[CDTextField alloc] init];
        _contentField.backgroundColor = [UIColor whiteColor];
        _contentField.verticalPadding = 5.0f;
        _contentField.horizontalPadding = 7.5f;
        _contentField.font = [UIFont systemFontOfSize:16.0f];
        _contentField.borderStyle = UITextBorderStyleRoundedRect;
        _contentField.returnKeyType = UIReturnKeySend;
        _contentField.placeholder = @"说点什么吧...";
        [self addSubview:_contentField];
        
        self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"发布" forState:UIControlStateNormal];
        _submitButton.backgroundColor = [UIColor grayColor];
        _submitButton.layer.cornerRadius = 3.0f;
        [self addSubview:_submitButton];
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
    _contentField.frame = contentFrame;
    
    CGFloat buttonX = contentWidth + COMMENT_FORM_PADDING_LEFT_RIGHT * 2;
    CGRect buttonFrame = CGRectMake(buttonX, COMMENT_FORM_TOP_BOTTOM, COMMENT_SUBMIT_BUTTON_WIDTH, contentHeight);
    _submitButton.frame = buttonFrame;
}

@end
