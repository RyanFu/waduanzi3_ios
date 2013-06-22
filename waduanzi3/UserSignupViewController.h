//
//  UserSignupViewController.h
//  waduanzi3
//
//  Created by chendong on 13-6-19.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  CDTextField;
@interface UserSignupViewController : UIViewController <UITextFieldDelegate>
{
    UIImageView *_logoView;
    UIView *_formView;
    CDTextField *_usernameTextField;
    CDTextField *_passwordTextField;
    UIButton *_submitButton;
}
@end
