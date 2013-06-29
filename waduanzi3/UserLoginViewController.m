//
//  UserLoginViewController.m
//  waduanzi3
//
//  Created by chendong on 13-6-19.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <RestKit/RestKit.h>
#import "CDDefine.h"
#import "UserLoginViewController.h"
#import "CDTextField.h"
#import "WCAlertView.h"
#import "UserSignupViewController.h"
#import "NSString+MD5.h"
#import "CDUser.h"
#import "CDRestClient.h"
#import "CDDataCache.h"
#import "CDQuickElements.h"

@interface UserLoginViewController ()
- (void) setupNavbar;
- (void) setupLogoView;
- (void) setupFormView;
- (void) submitLogin;
@end

@implementation UserLoginViewController

- (id) init
{
    self = [super init];
    if (self) {
        QRootElement *root = [CDQuickElements createUserLoginElements];
        self.root = root;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"注册";
    
    self.view.backgroundColor = [UIColor grayColor];
    self.view.userInteractionEnabled = YES;
    
    [self setupNavbar];
//    [self setupLogoView];
//    [self setupFormView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.phase == UITouchPhaseBegan) {
        for (UIView *subView in self.quickDialogTableView.subviews) {
            if (subView.isFirstResponder)
                [subView resignFirstResponder];
        }
    }
}

- (void)viewWillAppear2:(BOOL)animated
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

- (void)viewWillDisappear2:(BOOL)animated
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
    [_submitButton addTarget:self action:@selector(submitLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitButton];
    
    UIButton *goSignupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [goSignupButton addTarget:self action:@selector(openSignupController:) forControlEvents:UIControlEventTouchUpInside];
    [goSignupButton setTitle:@"注册挖段子账户" forState:UIControlStateNormal];
    goSignupButton.backgroundColor = [UIColor blackColor];
    CGRect signupButtonFrame = self.view.frame;
    signupButtonFrame.origin.x = (self.view.frame.size.width - 150.0f) / 2;
    signupButtonFrame.origin.y = self.view.frame.size.height - 100.0f;
    signupButtonFrame.size.width = 150.0f;
    signupButtonFrame.size.height = 30.0f;
    goSignupButton.frame = signupButtonFrame;
    [self.view addSubview:goSignupButton];
}

#pragma mark - selector

- (void) dismissController:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void) openSignupController:(id)sender
{
    UserSignupViewController *signupController = [[UserSignupViewController alloc] init];
    [self.navigationController pushViewController:signupController animated:YES];
}


#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == USERNAME_TEXTFIELD_TAG) {
        [_passwordTextField becomeFirstResponder];
        return YES;
    }
    else if (textField.tag == PASSWORD_TEXTFIELD_TAG) {
        [self submitLogin];
        
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

#pragma mark - submit login

- (void) submitLogin
{
    if (_usernameTextField.text.length == 0 || _passwordTextField.text.length == 0) {
        NSLog(@"please input username and password");
        return;
    }
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:_usernameTextField.text, @"username",
                            [_passwordTextField.text md5], @"password", nil];
    
    NSDictionary *parameters = [CDRestClient requestParams:params];
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager postObject:nil path:@"/user/login" parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//        NSLog(@"%@", mappingResult);
        CDUser *user = [mappingResult firstObject];
        if ([user isKindOfClass:[CDUser class]]) {
            [[CDDataCache shareCache] cacheLoginedUser:user];
            [[CDDataCache shareCache] removeMySharePosts];
            [[CDDataCache shareCache] removeFavoritePosts];
            
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                NSLog(@"user logined");
            }];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSData *jsonData = [error.localizedRecoverySuggestion dataUsingEncoding:NSUTF8StringEncoding];
        NSError *_error;
        NSDictionary *errorData = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&_error];
        NSLog(@"error: %@", errorData);
        if ([[errorData objectForKey:@"errcode"] integerValue] == USER_NOT_AUTHENTICATED)
            NSLog(@"username or password invalid");
    }];
}


@end
