//
//  CDQuickElements.m
//  waduanzi3
//
//  Created by chendong on 13-6-27.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CDQuickElements.h"
#import "CDAppUser.h"
#import "CDUser.h"
#import "UIImage+merge.h"

@implementation CDQuickElements

+ (QRootElement *) createSettingElements
{
    QRootElement *root = [[QRootElement alloc] init];
    root.controllerName = @"SettingViewController";
    root.title = @"设置";
    root.grouped = YES;
    
    QAppearance *appearance = root.appearance;
    appearance.labelFont = [UIFont systemFontOfSize:16.0f];
    appearance.labelColorEnabled = [UIColor blackColor];
    appearance.actionColorEnabled = [UIColor blackColor];
    appearance.sectionFooterColor = [UIColor lightGrayColor];
    appearance.tableBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    appearance.tableBackgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundLight.png"]];
    [root setAppearance:appearance];
    
    // section 0
    QSection *section0 = [[QSection alloc] init];
    [root addSection:section0];
    QBooleanElement *messagePush = [[QBooleanElement alloc] initWithTitle:@"消息推送" Value:0];
    messagePush.controllerAction = @"messagePushAction:";
    [section0 addElement:messagePush];

    // section 1
    QSection *section1 = [[QSection alloc] init];
    [root addSection:section1];
    section1.key = @"section_key_clear_cache";
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
    root.controllerName = @"UserSingupViewController";
    
    
    UIImage *image1 = [UIImage imageNamed:@"loginTexture.png"];
    UIImage *image2 = [UIImage imageNamed:@"background.png"];
    UIImage *backgroundImage = [UIImage mergeImage:image1 withImage:image2 withAlpha:0.5];
    
    QAppearance *appearance = root.appearance;
    appearance.entryFont = [UIFont systemFontOfSize:16.0f];
    appearance.labelFont = [UIFont systemFontOfSize:16.0f];
    appearance.tableBackgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    appearance.tableGroupedBackgroundColor = [UIColor clearColor];
    [root setAppearance:appearance];
    
    
    QSection *textFieldSection = [[QSection alloc] init];
    [root addSection:textFieldSection];
    textFieldSection.headerImage = @"login_logo.png";
    CGRect logoViewFrame = textFieldSection.headerView.frame;
    logoViewFrame.size.height = 160.0f;
    textFieldSection.headerView.frame = logoViewFrame;
    textFieldSection.headerView.contentMode = UIViewContentModeScaleAspectFit;
    
    QEntryElement *usernameTextField = [[QEntryElement alloc] initWithTitle:nil Value:nil Placeholder:@"邮箱/手机号/用户名"];
    usernameTextField.key = @"key_username";
    usernameTextField.keyboardType = UIKeyboardTypeEmailAddress;
    usernameTextField.bind = @"textValue:username";
    [textFieldSection addElement:usernameTextField];
    QEntryElement *passwordTextField = [[QEntryElement alloc] initWithTitle:nil Value:nil Placeholder:@"密码"];
    passwordTextField.key = @"key_password";
    passwordTextField.secureTextEntry = YES;
    passwordTextField.bind = @"textValue:password";
    [textFieldSection addElement:passwordTextField];
    usernameTextField.height = passwordTextField.height = 44.0f;
    
    QSection *buttonSection = [[QSection alloc] init];
    [root addSection:buttonSection];
    QButtonElement *submitButton = [[QButtonElement alloc] initWithTitle:@"注册"];
    submitButton.height = 42.0f;
    submitButton.enabled = NO;
    submitButton.key = @"key_submit_signup";
    submitButton.controllerAction = @"userSignupAction";
    [buttonSection addElement:submitButton];
    
    
    QSection *extraButtonSection = [[QSection alloc] init];
    [root addSection:extraButtonSection];
    QButtonElement *loginButton = [[QButtonElement alloc] initWithTitle:@"已有账号，直接登录"];
    loginButton.height = 33.0f;
    loginButton.controllerAction = @"retrunUserLoginAction";
    [extraButtonSection addElement:loginButton];
    
    return root;
}

+ (QRootElement *) createUserLoginElements
{
    QRootElement *root = [[QRootElement alloc] init];
    root.presentationMode = QPresentationModeModalForm;
    root.grouped = YES;
    root.title = @"登录";
    root.controllerName = @"UserLoginViewController";
    
    UIImage *image1 = [UIImage imageNamed:@"loginTexture.png"];
    UIImage *image2 = [UIImage imageNamed:@"background.png"];
    UIImage *backgroundImage = [UIImage mergeImage:image1 withImage:image2 withAlpha:0.5];
    
    QAppearance *appearance = root.appearance;
    appearance.entryFont = [UIFont systemFontOfSize:16.0f];
    appearance.labelFont = [UIFont systemFontOfSize:16.0f];
    appearance.tableBackgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    appearance.tableGroupedBackgroundColor = [UIColor clearColor];
    [root setAppearance:appearance];
    
    
    QSection *textFieldSection = [[QSection alloc] init];
    [root addSection:textFieldSection];
    textFieldSection.headerImage = @"login_logo.png";
    CGRect logoViewFrame = textFieldSection.headerView.frame;
    logoViewFrame.size.height = 160.0f;
    textFieldSection.headerView.frame = logoViewFrame;
    textFieldSection.headerView.contentMode = UIViewContentModeScaleAspectFit;
    
    QEntryElement *usernameTextField = [[QEntryElement alloc] initWithTitle:nil Value:nil Placeholder:@"邮箱/手机号/用户名"];
    usernameTextField.key = @"key_username";
    usernameTextField.keyboardType = UIKeyboardTypeEmailAddress;
    usernameTextField.bind = @"textValue:username";
    QEntryElement *passwordTextField = [[QEntryElement alloc] initWithTitle:nil Value:nil Placeholder:@"密码"];
    passwordTextField.key = @"key_password";
    passwordTextField.secureTextEntry = YES;
    passwordTextField.bind = @"textValue:password";
    [textFieldSection addElement:usernameTextField];
    usernameTextField.height = passwordTextField.height = 44.0f;
    [textFieldSection addElement:passwordTextField];

    QSection *buttonSection = [[QSection alloc] init];
    [root addSection:buttonSection];
    QButtonElement *submitButton = [[QButtonElement alloc] initWithTitle:@"登录"];
    submitButton.key = @"key_submit_login";
    submitButton.controllerAction = @"userLoginAction";
    submitButton.height = 42.0f;
    submitButton.enabled = NO;
    [buttonSection addElement:submitButton];
    
    QSection *extraButtonSection = [[QSection alloc] init];
    [root addSection:extraButtonSection];
    QButtonElement *signupButton = [[QButtonElement alloc] initWithTitle:@"注册挖段子账号"];
    signupButton.controllerAction = @"gotoUserSignupAction";
    signupButton.height = 33.0f;
    [extraButtonSection addElement:signupButton];
    
    return root;
}

+ (QRootElement *) createUserProfileElements
{
    QRootElement *root = [[QRootElement alloc] init];
    root.presentationMode = QPresentationModeModalForm;
    root.grouped = YES;
    root.title = @"我的资料";
    root.controllerName = @"UserProfileViewController";
    
    
    QAppearance *appearance = root.appearance;
    appearance.entryFont = [UIFont systemFontOfSize:18.0f];
    appearance.labelFont = [UIFont systemFontOfSize:18.0f];
    appearance.tableBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundDark.png"]];
    appearance.tableBackgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundLight.png"]];
    [root setAppearance:appearance];
    
    CDUser *user = [CDAppUser currentUser];
    
    QSection *section1 = [[QSection alloc] initWithTitle:@"个人信息"];
    [root addSection:section1];
    QBadgeElement *scoreLabel = [[QBadgeElement alloc] initWithTitle:@"我的积分" Value:[user.score stringValue]];
    scoreLabel.key = @"key_user_score";
    [section1 addElement:scoreLabel];
    QLabelElement *websiteLabel = [[QLabelElement alloc] initWithTitle:@"主页" Value:user.website];
    [section1 addElement:websiteLabel];
    
    QSection *section2 = [[QSection alloc] initWithTitle:@"个人介绍"];
    [root addSection:section2];
    QTextElement *descText = [[QTextElement alloc] initWithText:user.desc];
    [section2 addElement:descText];
    
    QSection *section3 = [[QSection alloc] init];
    [root addSection:section3];
    QButtonElement *logoutButton = [[QButtonElement alloc] initWithTitle:@"退出当前账号"];
    logoutButton.key = @"key_logout_button";
    logoutButton.controllerAction = @"logoutAction:";
    [section3 addElement:logoutButton];
    
    return root;
}


@end

