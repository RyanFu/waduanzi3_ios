//
//  CDCommentFormView.h
//  waduanzi3
//
//  Created by chendong on 13-7-9.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDTextField.h"

const static CGFloat COMMENT_FORM_HEIGHT = 44.0f;
const static CGFloat COMMENT_FORM_PADDING_LEFT_RIGHT = 10.0f;
const static CGFloat COMMENT_FORM_TOP_BOTTOM = 7.5f;
const static CGFloat COMMENT_SUBMIT_BUTTON_WIDTH = 50.0f;

@protocol CDCommentFormDelegate <NSObject>
@end


@interface CDCommentFormView : UIView

@property (nonatomic, weak) id<CDCommentFormDelegate> delegate;
@property (nonatomic, strong) UIImageView *textFieldBackgroundView;
@property (nonatomic, strong) CDTextField *textField;
@property (nonatomic, strong) UIButton *submitButton;
@end
