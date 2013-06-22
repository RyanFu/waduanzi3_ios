//
//  UserSignupViewController.m
//  waduanzi3
//
//  Created by chendong on 13-6-19.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CDDefine.h"
#import "UserSignupViewController.h"
#import "CDTextField.h"
#import "WCAlertView.h"

@interface UserSignupViewController ()
- (void) setupNavbar;
- (void) setupLogoView;
- (void) setupFormView;
@end

@implementation UserSignupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"登录";

	self.view.backgroundColor = [UIColor grayColor];
    self.view.userInteractionEnabled = YES;
    
    [self setupNavbar];
    [self setupLogoView];
    [self setupFormView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.phase == UITouchPhaseBegan) {
        for (UIView *subView in _formView.subviews) {
            if (subView.isFirstResponder)
                [subView resignFirstResponder];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - setup subviews

- (void) setupNavbar
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissController:)];
}

- (void)setupLogoView
{
    CGRect logoViewFrame = CGRectMake(VIEW_PADDING, LOGOVIEW_MARGIN_TOP, self.view.frame.size.width - VIEW_PADDING*2, LOGOVIEW_HEIGHT);
    _logoView = [[UIImageView alloc] initWithFrame:logoViewFrame];
    _logoView.contentMode = UIViewContentModeScaleAspectFit;
    _logoView.image = [UIImage imageNamed:@"Icon.png"];
    
    [self.view addSubview:_logoView];
}

- (void) setupFormView
{
    CGFloat formWidth = self.view.frame.size.width - VIEW_PADDING*2;
    CGFloat formViewFrameY = _logoView.frame.origin.y + _logoView.frame.size.height + LOGOVIEW_FORMVIEW_MARGIN;
    CGRect formViewFrame = CGRectMake(VIEW_PADDING, formViewFrameY, formWidth, FORMVIEW_HEIGHT);
    _formView = [[UIView alloc] initWithFrame:formViewFrame];
    _formView.backgroundColor = [UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f];
    _formView.layer.cornerRadius = 10.0f;
    _formView.layer.masksToBounds = YES;
    _formView.clipsToBounds = YES;
    _formView.layer.borderColor = [[UIColor grayColor] CGColor];
    _formView.layer.borderWidth = 1.0f;
    
    CGRect usernameFrame = CGRectMake(0, 0, formWidth, FORMVIEW_HEIGHT/2-0.65f);
    _usernameTextField = [[CDTextField alloc] initWithFrame:usernameFrame];
    CGRect passwordFrame = CGRectMake(0, FORMVIEW_HEIGHT/2+0.65f, formWidth, FORMVIEW_HEIGHT/2-0.65f);
    _passwordTextField = [[CDTextField alloc] initWithFrame:passwordFrame];
    
    _usernameTextField.contentVerticalAlignment = _passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _usernameTextField.horizontalPadding = _passwordTextField.horizontalPadding = 15.0f;
    _usernameTextField.clearButtonMode = _passwordTextField.clearButtonMode = UITextFieldViewModeAlways;
    _usernameTextField.delegate = _passwordTextField.delegate = self;
    
    _usernameTextField.placeholder = @"用户名/邮箱/手机号";
    _usernameTextField.backgroundColor = _passwordTextField.backgroundColor = [UIColor whiteColor];
    _usernameTextField.keyboardType = UIKeyboardTypeEmailAddress;
    _usernameTextField.returnKeyType = UIReturnKeyNext;
    _usernameTextField.tag = USERNAME_TEXTFIELD_TAG;
    
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.placeholder = @"密码";
    _passwordTextField.returnKeyType = UIReturnKeyDone;
    _passwordTextField.tag = PASSWORD_TEXTFIELD_TAG;
    
    [_formView addSubview:_usernameTextField];
    [_formView addSubview:_passwordTextField];
    
    [self.view addSubview:_formView];
    
    CGFloat submitButtonFrameY = _formView.frame.origin.y + _formView.frame.size.height + FORMVIEW_SUBMITBUTTON_MARGIN;
    CGRect submitButtonFrame = CGRectMake(VIEW_PADDING, submitButtonFrameY, formWidth, 40.0f);
    _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitButton.frame = submitButtonFrame;
    _submitButton.backgroundColor = [UIColor lightGrayColor];
    [_submitButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addSubview:_submitButton];
    
    UIButton *goLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [goLoginButton addTarget:self action:@selector(backLoginController:) forControlEvents:UIControlEventTouchUpInside];
    [goLoginButton setTitle:@"注册挖段子账户" forState:UIControlStateNormal];
    goLoginButton.backgroundColor = [UIColor blackColor];
    CGRect signupButtonFrame = self.view.frame;
    signupButtonFrame.origin.x = (self.view.frame.size.width - 150.0f) / 2;
    signupButtonFrame.origin.y = self.view.frame.size.height - 100.0f;
    signupButtonFrame.size.width = 150.0f;
    signupButtonFrame.size.height = 30.0f;
    goLoginButton.frame = signupButtonFrame;
    [self.view addSubview:goLoginButton];
}

#pragma mark - selector

- (void) dismissController:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void) backLoginController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == USERNAME_TEXTFIELD_TAG) {
        [_passwordTextField becomeFirstResponder];
        return YES;
    }
    else if (textField.tag == PASSWORD_TEXTFIELD_TAG) {
        [WCAlertView showAlertWithTitle:@"登录" message:@"测试登录" customizationBlock:^(WCAlertView *alertView) {
            alertView.style = WCAlertViewStyleWhite;
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            ;
        } cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
        
        return YES;
    }
    else
        return NO;
}


#pragma mark - keyboard show/hide

- (void) keyboardWillShow
{
    NSLog(@"keyboard will show");
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    CGRect logoViewFrame = _logoView.frame;
    logoViewFrame.origin.y = LOGOVIEW_MARGIN_TOP / 2;
    _logoView.frame = logoViewFrame;
    
    CGFloat formMarginTop = LOGOVIEW_HEIGHT + LOGOVIEW_MARGIN_TOP / 2 + LOGOVIEW_FORMVIEW_MARGIN / 2;
    CGRect formViewFrame = _formView.frame;
    formViewFrame.origin.y = formMarginTop;
    _formView.frame = formViewFrame;
    
    CGRect submitFrame = _submitButton.frame;
    submitFrame.origin.y = formMarginTop + FORMVIEW_HEIGHT + FORMVIEW_SUBMITBUTTON_MARGIN;
    _submitButton.frame = submitFrame;
    
    [UIView commitAnimations];
}

- (void) keyboardWillHide
{
    NSLog(@"keybaord will hide");
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    CGRect logoViewFrame = _logoView.frame;
    logoViewFrame.origin.y = LOGOVIEW_MARGIN_TOP;
    _logoView.frame = logoViewFrame;
    
    CGFloat formMarginTop = LOGOVIEW_HEIGHT + LOGOVIEW_MARGIN_TOP + LOGOVIEW_FORMVIEW_MARGIN;
    CGRect formViewFrame = _formView.frame;
    formViewFrame.origin.y = formMarginTop;
    _formView.frame = formViewFrame;
    
    CGRect submitFrame = _submitButton.frame;
    submitFrame.origin.y = formMarginTop + FORMVIEW_HEIGHT + FORMVIEW_SUBMITBUTTON_MARGIN;
    _submitButton.frame = submitFrame;
    
    [UIView commitAnimations];
}

@end
