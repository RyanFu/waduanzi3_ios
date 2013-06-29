//
//  CDQuickElements.m
//  waduanzi3
//
//  Created by chendong on 13-6-27.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDQuickElements.h"
#import "CDAppUser.h"
#import "CDUser.h"

@implementation CDQuickElements

+ (QRootElement *) createSettingElements
{
    QRootElement *root = [[QRootElement alloc] init];
    root.controllerName = @"SettingViewController";
    root.title = @"设置";
    root.grouped = YES;
    
    // section 0
    QSection *section0 = [[QSection alloc] init];
    [root addSection:section0];
    QBooleanElement *messagePush = [[QBooleanElement alloc] initWithTitle:@"消息推送" Value:0];
    messagePush.controllerAction = @"messagePushAction:";
    [section0 addElement:messagePush];
    
    // section 1
    QSection *section1 = [[QSection alloc] init];
    [root addSection:section1];
    QButtonElement *clearCacheButton = [[QButtonElement alloc] initWithTitle:@"清除缓存"];
    clearCacheButton.key = @"key_clear_cache";
    clearCacheButton.controllerAction = @"clearCacheAction:";
    [section1 addElement:clearCacheButton];
    
    // section 2
    if ([CDAppUser hasLogined]) {
        QSection *section2 = [[QSection alloc] init];
        section2.key = @"key_user_profile";
        [root addSection:section2];
        CDUser *user = [CDAppUser currentUser];
        QLabelElement *userProfileLabel = [[QLabelElement alloc] initWithTitle:@"我的资料" Value:user.username];
        userProfileLabel.controllerAction = @"userProfileAction:";
        [section2 addElement:userProfileLabel];
    }
    
    // section 3
    QSection *section3 = [[QSection alloc] init];
    [root addSection:section3];
    QLabelElement *feedbackLabel = [[QLabelElement alloc] initWithTitle:@"意见反馈" Value:nil];
    feedbackLabel.controllerAction = @"feedbackAction:";
    [section3 addElement:feedbackLabel];
    QLabelElement *starredLabel = [[QLabelElement alloc] initWithTitle:@"五星支持挖段子" Value:nil];
    starredLabel.controllerAction = @"starredAction:";
    [section3 addElement:starredLabel];
    QLabelElement *aboutLabel = [[QLabelElement alloc] initWithTitle:@"关于挖段子" Value:nil];
    [section3 addElement:aboutLabel];
    aboutLabel.controllerAction = @"aboutmeAction:";
    
    
    // section 4
    QSection *section4 = [[QSection alloc] init];
    [root addSection:section4];
    QBadgeElement *checkVersionLabel = [[QBadgeElement alloc] initWithTitle:@"当前版本" Value:APP_VERSION];
    checkVersionLabel.key = @"key_check_version";
    messagePush.controllerAction = @"checkVersionAction:";
    [section4 addElement:checkVersionLabel];
    
    section4.footer = @"waduanzi.com";
    
    return root;
}

+ (QRootElement *) createUserSignupElements
{
    QRootElement *root = [[QRootElement alloc] init];
    root.grouped = YES;
    root.title = @"注册";
    
    return root;
}

+ (QRootElement *) createUserLoginElements
{
    QRootElement *root = [[QRootElement alloc] init];
    root.grouped = YES;
    root.title = @"登录";
    root.controllerName = @"UserLoginViewController";
    
    QSection *textFieldSection = [[QSection alloc] init];
    [root addSection:textFieldSection];
    QEntryElement *usernameTextField = [[QEntryElement alloc] initWithTitle:@"账号" Value:nil Placeholder:@"邮箱/手机号/用户名"];
    usernameTextField.key = @"key_username";
    usernameTextField.keyboardType = UIKeyboardTypeEmailAddress;
    [textFieldSection addElement:usernameTextField];
    QEntryElement *passwordTextField = [[QEntryElement alloc] initWithTitle:@"密码" Value:nil Placeholder:@"密码"];
    passwordTextField.key = @"key_password";
    passwordTextField.keyboardType = UIKeyboardTypeEmailAddress;
    passwordTextField.secureTextEntry = YES;
    [textFieldSection addElement:passwordTextField];
    
    QSection *buttonSection = [[QSection alloc] init];
    [root addSection:buttonSection];
    QButtonElement *submitButton = [[QButtonElement alloc] initWithTitle:@"登录"];
    submitButton.key = @"key_submit_login";
    submitButton.controllerAction = @"userLoginAction";
    [buttonSection addElement:submitButton];
    
    UIButton *goSignupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [goSignupButton addTarget:self action:@selector(openSignupController:) forControlEvents:UIControlEventTouchUpInside];
    [goSignupButton setTitle:@"注册挖段子账户" forState:UIControlStateNormal];
    goSignupButton.backgroundColor = [UIColor blackColor];
    CGRect signupButtonFrame = buttonSection.frame;
    signupButtonFrame.origin.x = (self.view.frame.size.width - 150.0f) / 2;
    signupButtonFrame.origin.y = self.view.frame.size.height - 100.0f;
    signupButtonFrame.size.width = 150.0f;
    signupButtonFrame.size.height = 30.0f;
    goSignupButton.frame = signupButtonFrame;
    
    buttonSection.footerView = goSignupButton;
    
    return root;
}


@end

