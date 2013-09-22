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
#import "UMSocial.h"
#import "CDUserConfig.h"
#import "PostFontPickerValueParser.h"
#import "CommentFontPickerValueParser.h"
#import "QWebViewController.h"
#import "QPickerElement.h"
#import "CDDefine.h"

@implementation CDQuickElements

+ (QRootElement *) createSettingElements
{
    QRootElement *root = [[QRootElement alloc] init];
    root.controllerName = @"SettingViewController";
    root.title = @"设置";
    root.grouped = YES;
    
    root.appearance = [root.appearance copy];
    root.appearance.labelFont = [UIFont fontWithName:FZLTHK_FONT_NAME size:16.0f];
    root.appearance.labelColorEnabled = [UIColor blackColor];
    root.appearance.actionColorEnabled = [UIColor blackColor];
    root.appearance.sectionTitleFont = [UIFont fontWithName:FZLTHK_FONT_NAME size:14.0f];
    root.appearance.sectionFooterColor = [UIColor lightGrayColor];
    root.appearance.buttonAlignment = NSTextAlignmentCenter;
    root.appearance.toolbarStyle = UIBarStyleBlack;
    root.appearance.toolbarTranslucent = YES;
    [root setAppearance:root.appearance];
    
    // section 0
    QSection *section0 = [[QSection alloc] init];
    section0.title = @"基本设置";
    [root addSection:section0];
    
    PostFontPickerValueParser *postFontParser = [[PostFontPickerValueParser alloc] init];
    NSNumber *postCurrentFontSize = [NSNumber numberWithUnsignedInteger:[CDUserConfig shareInstance].postFontSize];
    QPickerElement *postFontElement = [[QPickerElement alloc] initWithTitle:@"正文字体大小"
                                                                      items:@[postFontParser.stringValues]
                                                                      value:postCurrentFontSize];
    postFontElement.valueParser = postFontParser;
    __weak QPickerElement *weakPostFontElement = postFontElement;
    postFontElement.onValueChanged = ^(QRootElement *root) {
        NSLog(@"on value cahnged");
        NSNumber *postFontSize = (NSNumber *) weakPostFontElement.value;
        [[CDUserConfig shareInstance] setPostFontSize:postFontSize.integerValue];
        [[CDUserConfig shareInstance] cache];
    };
    postFontElement.key = @"key_change_post_fonts_size";
    [section0 addElement:postFontElement];
    
    CommentFontPickerValueParser *commentFontParser = [[CommentFontPickerValueParser alloc] init];
    NSNumber *commentCurrentFontSize = [NSNumber numberWithUnsignedInteger:[CDUserConfig shareInstance].commentFontSize];
    QPickerElement *commentFontElement = [[QPickerElement alloc] initWithTitle:@"评论字体大小"
                                                                      items:@[commentFontParser.stringValues]
                                                                      value:commentCurrentFontSize];
    commentFontElement.valueParser = commentFontParser;
    __weak QPickerElement *weakCommentFontElement = commentFontElement;
    commentFontElement.onValueChanged = ^(QRootElement *root) {
        NSNumber *commentFontSize = (NSNumber *) weakCommentFontElement.value;
        [[CDUserConfig shareInstance] setCommentFontSize:commentFontSize.integerValue];
        [[CDUserConfig shareInstance] cache];
    };
    [section0 addElement:commentFontElement];
    
    QBooleanElement *messagePush = [[QBooleanElement alloc] initWithTitle:@"消息推送" Value:0];
    messagePush.key = @"key_message_push";
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
        QLabelElement *userProfileLabel = [[QLabelElement alloc] initWithTitle:@"我的账号" Value:user.username];
        userProfileLabel.key = @"key_go_user_profile";
        userProfileLabel.controllerAction = @"userProfileAction:";
        [section2 addElement:userProfileLabel];
    }
    
    // section 3
    QSection *section3 = [[QSection alloc] init];
    section3.title = @"其它";
    [root addSection:section3];
    QLabelElement *feedbackLabel = [[QLabelElement alloc] initWithTitle:@"意见反馈" Value:nil];
    feedbackLabel.key = @"key_feedback";
    feedbackLabel.controllerAction = @"feedbackAction:";
    [section3 addElement:feedbackLabel];
    QLabelElement *starredLabel = [[QLabelElement alloc] initWithTitle:@"支持挖段子" Value:nil];
    starredLabel.key = @"key_starred_app";
    starredLabel.controllerAction = @"starredAction:";
    [section3 addElement:starredLabel];
    QLabelElement *aboutLabel = [[QLabelElement alloc] initWithTitle:@"关于挖段子" Value:nil];
    aboutLabel.key = @"key_about_us";
    aboutLabel.controllerAction = @"aboutmeAction:";
    [section3 addElement:aboutLabel];
    
    
    // section 4
    QSection *section4 = [[QSection alloc] init];
    [root addSection:section4];
    QBadgeElement *checkVersionLabel = [[QBadgeElement alloc] initWithTitle:@"当前版本" Value:APP_VERSION];
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
    
    root.appearance = [root.appearance copy];
    root.appearance.entryFont = [UIFont fontWithName:FZLTHK_FONT_NAME size:16.0f];
    root.appearance.labelFont = [UIFont fontWithName:FZLTHK_FONT_NAME size:16.0f];
    root.appearance.valueAlignment = NSTextAlignmentLeft;
    root.appearance.sectionFooterColor = [UIColor lightGrayColor];
    root.appearance.sectionFooterFont = [UIFont fontWithName:FZLTHK_FONT_NAME size:12.0f];
    root.appearance.buttonAlignment = NSTextAlignmentCenter;
    root.appearance.toolbarStyle = UIBarStyleBlack;
    root.appearance.sectionTitleShadowColor = [UIColor clearColor];
    root.appearance.toolbarTranslucent = YES;
    
    QSection *textFieldSection = [[QSection alloc] init];
    [root addSection:textFieldSection];
    textFieldSection.headerImage = @"login_logo.png";
    CGRect logoViewFrame = textFieldSection.headerView.frame;
    logoViewFrame.size.height = 145.0f;
    textFieldSection.headerView.frame = logoViewFrame;
    textFieldSection.headerView.contentMode = UIViewContentModeScaleAspectFit;
    
    QEntryElement *usernameTextField = [[QEntryElement alloc] initWithTitle:nil
                                                                      Value:nil
                                                                Placeholder:[NSString stringWithFormat:@"邮箱/手机号/用户名(最少%d个字符)", USER_NAME_MIN_LENGTH]
                                        ];
    usernameTextField.key = @"key_username";
    usernameTextField.keyboardType = UIKeyboardTypeEmailAddress;
    usernameTextField.bind = @"textValue:username";
    [textFieldSection addElement:usernameTextField];
    QEntryElement *passwordTextField = [[QEntryElement alloc] initWithTitle:nil
                                                                      Value:nil
                                                                Placeholder:[NSString stringWithFormat:@"密码(最少%d位)", USER_PASSWORD_MIN_LENGTH]
                                        ];
    passwordTextField.key = @"key_password";
    passwordTextField.secureTextEntry = YES;
    passwordTextField.bind = @"textValue:password";
    passwordTextField.returnKeyType = UIReturnKeyDone;
    [textFieldSection addElement:passwordTextField];
    
    
    QSection *buttonSection = [[QSection alloc] init];
    [root addSection:buttonSection];
    QButtonElement *submitButton = [[QButtonElement alloc] initWithTitle:@"注册    "];
    submitButton.enabled = NO;
    submitButton.key = @"key_submit_signup";
    [buttonSection addElement:submitButton];
    
    
    QSection *extraButtonSection = [[QSection alloc] init];
    [root addSection:extraButtonSection];
    QButtonElement *loginButton = [[QButtonElement alloc] initWithTitle:@"已有账号，直接登录    "];
    loginButton.key = @"key_go_login";
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
    
    root.appearance = [root.appearance copy];
    root.appearance.entryFont = [UIFont fontWithName:FZLTHK_FONT_NAME size:16.0f];
    root.appearance.valueAlignment = NSTextAlignmentLeft;
    root.appearance.labelFont = [UIFont fontWithName:FZLTHK_FONT_NAME size:16.0f];
    root.appearance.sectionFooterColor = [UIColor lightGrayColor];
    root.appearance.sectionFooterFont = [UIFont fontWithName:FZLTHK_FONT_NAME size:12.0f];
    root.appearance.buttonAlignment = NSTextAlignmentCenter;
    root.appearance.toolbarStyle = UIBarStyleBlack;
    root.appearance.toolbarTranslucent = YES;
    
    
    QSection *textFieldSection = [[QSection alloc] init];
    [root addSection:textFieldSection];
    
    QEntryElement *usernameTextField = [[QEntryElement alloc] initWithTitle:nil Value:nil Placeholder:@"邮箱/手机号/用户名"];
    usernameTextField.key = @"key_username";
    usernameTextField.keyboardType = UIKeyboardTypeEmailAddress;
    usernameTextField.bind = @"textValue:username";
    QEntryElement *passwordTextField = [[QEntryElement alloc] initWithTitle:nil Value:nil Placeholder:@"密码"];
    passwordTextField.key = @"key_password";
    passwordTextField.secureTextEntry = YES;
    passwordTextField.bind = @"textValue:password";
    passwordTextField.returnKeyType = UIReturnKeyDone;
    
    if (IS_IOS7) {
        usernameTextField.title = @"  ";
        passwordTextField.title = @"  ";
    }
    
    [textFieldSection addElement:usernameTextField];
    [textFieldSection addElement:passwordTextField];

    QSection *buttonSection = [[QSection alloc] init];
    [root addSection:buttonSection];
    QButtonElement *submitButton = [[QButtonElement alloc] initWithTitle:@"登录    "];
    submitButton.key = @"key_submit_login";
    submitButton.enabled = NO;
    [buttonSection addElement:submitButton];

    QSection *extraButtonSection = [[QSection alloc] init];
    [root addSection:extraButtonSection];
    QButtonElement *signupButton = [[QButtonElement alloc] initWithTitle:@"注册挖段子账号    "];
    signupButton.key = @"key_go_signup";
    [extraButtonSection addElement:signupButton];
    
    return root;
}

+ (QRootElement *) createUserProfileElements
{
    QRootElement *root = [[QRootElement alloc] init];
    root.presentationMode = QPresentationModeModalPage;
    root.grouped = YES;
    root.title = @"我的资料";
    root.controllerName = @"UserProfileViewController";
    
    
    root.appearance = [root.appearance copy];
    root.appearance.labelFont = [UIFont fontWithName:FZLTHK_FONT_NAME size:16.0f];
    root.appearance.entryFont = [UIFont fontWithName:FZLTHK_FONT_NAME size:14.0f];
    root.appearance.sectionTitleFont = [UIFont fontWithName:FZLTHK_FONT_NAME size:14.0f];
    root.appearance.sectionFooterColor = [UIColor lightGrayColor];
    root.appearance.buttonAlignment = NSTextAlignmentCenter;
    
    CDUser *user = [CDAppUser currentUser];
    
    QSection *section1 = [[QSection alloc] initWithTitle:@"个人信息"];
    [root addSection:section1];
    QLabelElement *accountLabel = [[QLabelElement alloc] initWithTitle:@"账号" Value:user.username];
    accountLabel.key = @"key_user_account";
    [section1 addElement:accountLabel];
    QBadgeElement *scoreLabel = [[QBadgeElement alloc] initWithTitle:@"积分" Value:[user.score stringValue]];
    scoreLabel.key = @"key_user_score";
    [section1 addElement:scoreLabel];
    QLabelElement *nicknameLabel = [[QLabelElement alloc] initWithTitle:@"昵称" Value:user.screen_name];
    nicknameLabel.key = @"key_nickname";
    nicknameLabel.controllerAction = @"updateNickname:";
    [section1 addElement:nicknameLabel];
//    QLabelElement *websiteLabel = [[QLabelElement alloc] initWithTitle:@"主页" Value:user.website];
//    [section1 addElement:websiteLabel];
    
    QSection *shareSection = [[QSection alloc] initWithTitle:@"分享账号"];
    [root addSection:shareSection];
    QBooleanElement *sinaElement = [[QBooleanElement alloc] initWithTitle:@"新浪微博" BoolValue:NO];
    sinaElement.key = @"key_share_sina_weibo";
    QBooleanElement *qzoneElement = [[QBooleanElement alloc] initWithTitle:@"QQ空间" BoolValue:NO];
    qzoneElement.key = @"key_share_qzone";
    QBooleanElement *tencentElement = [[QBooleanElement alloc] initWithTitle:@"腾讯微博" BoolValue:NO];
    tencentElement.key = @"key_share_tencent";
    sinaElement.onImage = qzoneElement.onImage = tencentElement.onImage = [UIImage imageNamed:@"imgOn.png"];
    sinaElement.offImage = qzoneElement.offImage = tencentElement.offImage = [UIImage imageNamed:@"imgOff.png"];
    sinaElement.controllerAction = @"sinaWeiboLoginAction:";
    qzoneElement.controllerAction = @"qzoneLoginAction:";
    tencentElement.controllerAction = @"tencentLoginAction:";
    sinaElement.controllerAccessoryAction = qzoneElement.controllerAccessoryAction = tencentElement.controllerAccessoryAction = @"snsLoginStatusAction:";
    [shareSection addElement:sinaElement];
    [shareSection addElement:qzoneElement];
    [shareSection addElement:tencentElement];
    
    QSection *section2 = [[QSection alloc] initWithTitle:@"个人介绍"];
    [root addSection:section2];
    QTextElement *descText = [[QTextElement alloc] initWithText:user.desc];
    descText.color = [UIColor grayColor];
    [section2 addElement:descText];
    
    QSection *section3 = [[QSection alloc] init];
    [root addSection:section3];
    QButtonElement *logoutButton = [[QButtonElement alloc] initWithTitle:@"退出当前账号"];
    logoutButton.key = @"key_logout_button";
    logoutButton.controllerAction = @"logoutAction:";
    logoutButton.height = 43.0f;
    [section3 addElement:logoutButton];
    
    return root;
}

+ (QRootElement *) createPublishElements
{
    QRootElement *root = [[QRootElement alloc] init];
    root.presentationMode = QPresentationModeModalForm;
    root.grouped = YES;
    root.title = @"我的账号";
    root.controllerName = @"PublishViewController";
    
    
    root.appearance = [root.appearance copy];
    root.appearance.labelFont = [UIFont fontWithName:FZLTHK_FONT_NAME size:16.0f];
    root.appearance.entryFont = [UIFont fontWithName:FZLTHK_FONT_NAME size:14.0f];
    root.appearance.sectionTitleFont = [UIFont fontWithName:FZLTHK_FONT_NAME size:14.0f];
    root.appearance.sectionFooterColor = [UIColor lightGrayColor];
    root.appearance.toolbarStyle = UIBarStyleBlack;
    root.appearance.toolbarTranslucent = YES;
    
    QSection *section = [[QSection alloc] init];
    [root addSection:section];
    QTextElement *contentElement = [[QTextElement alloc] initWithText:@"xx"];
    contentElement.height = 100;
    [section addElement:contentElement];
    
    return root;
}

+ (QRootElement *) createUpdateProfileElements
{
    QRootElement *root = [[QRootElement alloc] init];
    root.presentationMode = QPresentationModeModalForm;
    root.grouped = YES;
    root.title = @"修改资料";
    root.controllerName = @"UpdateProfileViewController";
    
    
    root.appearance = [root.appearance copy];
    root.appearance.labelFont = [UIFont fontWithName:FZLTHK_FONT_NAME size:16.0f];
    root.appearance.entryFont = [UIFont fontWithName:FZLTHK_FONT_NAME size:14.0f];
    root.appearance.sectionTitleFont = [UIFont fontWithName:FZLTHK_FONT_NAME size:14.0f];
    root.appearance.sectionFooterColor = [UIColor lightGrayColor];
    root.appearance.toolbarStyle = UIBarStyleBlack;
    root.appearance.toolbarTranslucent = YES;
    root.appearance.buttonAlignment = NSTextAlignmentCenter;
    [root setAppearance:root.appearance];
    
    CDUser *user = [CDAppUser currentUser];
    
    QSection *section1 = [[QSection alloc] init];
    [root addSection:section1];
    QEntryElement *nicknameElement = [[QEntryElement alloc] initWithTitle:nil Value:user.screen_name Placeholder:@"请输入昵称"];
    nicknameElement.key = @"key_update_nick_name";
    nicknameElement.returnKeyType = UIReturnKeyDone;
    nicknameElement.hiddenToolbar = YES;
    [section1 addElement:nicknameElement];
    QSection *section2 = [[QSection alloc] init];
    
    [root addSection:section2];
    QButtonElement *submitButton = [[QButtonElement alloc] initWithTitle:@"保存"];
    submitButton.key = @"key_save_profile";
    submitButton.controllerAction = @"updateUserProfileAction";
    [section2 addElement:submitButton];
    
    return root;
}


@end

