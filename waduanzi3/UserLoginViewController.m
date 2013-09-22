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
#import "UserSignupViewController.h"
#import "NSString+MD5.h"
#import "CDUser.h"
#import "CDRestClient.h"
#import "CDDataCache.h"
#import "CDQuickElements.h"
#import "CDUserForm.h"
#import "CDUIKit.h"
#import "UMSocial.h"
#import "CDSocialKit.h"
#import "WBErrorNoticeView+WaduanziMethod.h"
#import "UIView+Border.h"

@interface UserLoginViewController ()
- (void) setupNavbar;
- (void) userLoginAction;
@end

@implementation UserLoginViewController

- (id) init
{
    self = [super init];
    if (self) {
        self.resizeWhenKeyboardPresented = YES;
        self.root = [CDQuickElements createUserLoginElements];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"登录";
    
    self.quickDialogTableView.delegate = self;
    
    QEntryElement *usernameElement = (QEntryElement *)[self.root elementWithKey:@"key_username"];
    QEntryElement *passwordElement = (QEntryElement *)[self.root elementWithKey:@"key_password"];
    usernameElement.delegate = passwordElement.delegate = self;
    
    [self setupNavbar];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.quickDialogTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (IS_IOS7) {
        self.quickDialogTableView.backgroundColor = [UIColor colorWithRed:0.23f green:0.35f blue:0.60f alpha:1.00f];
    }
    else
    {
        self.quickDialogTableView.backgroundColor = [UIColor clearColor];
        UIImage *backgroundImage = [UIImage imageNamed:@"login_background.png"];
        self.quickDialogTableView.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    }
    
    QEntryElement *usernameElement = (QEntryElement *)[self.root elementWithKey:@"key_username"];
    usernameElement.textValue = [[CDDataCache shareCache] fetchLoginUserName];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[RKObjectManager sharedManager] cancelAllObjectRequestOperationsWithMethod:RKRequestMethodPOST matchingPathPattern:@"/user/login"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setup subviews

- (void) setupNavbar
{
    [CDUIKit setNavigationBar:self.navigationController.navigationBar style:CDNavigationBarStyleBlack forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(dismissController)];
    
    [CDUIKit setBackBarButtionItemStyle:CDBarButtionItemStyleBlack forBarMetrics:UIBarMetricsDefault];
    [CDUIKit setBarButtionItem:self.navigationItem.rightBarButtonItem style:CDBarButtionItemStyleBlack forBarMetrics:UIBarMetricsDefault];
    
    [CDUIKit setBarButtonItem:self.navigationItem.rightBarButtonItem titleAttributes:nil forBarMetrics:UIBarMetricsDefault];
}


#pragma mark - UITableViewDelegate

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QSection *section = [self.root getVisibleSectionForIndex:indexPath.section];
    QElement *element = [section getVisibleElementForIndex: indexPath.row];
    
    if ([element.key isEqualToString:@"key_submit_login"])
        return 42.0f;
    else if ([element.key isEqualToString:@"key_go_signup"])
        return 35.0f;
    else
        return 44.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 0) ? 145.0f : 0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_logo.png"]];
        logoView.contentMode = UIViewContentModeScaleAspectFit;
        [logoView sizeToFit];
        return logoView;
    }
    else
        return nil;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    QSection *section = [self.root getVisibleSectionForIndex:indexPath.section];
    QElement *element = [section getVisibleElementForIndex: indexPath.row];
    
    if ([element.key isEqualToString:@"key_submit_login"]) {
        if (IS_IOS7) {
            cell.backgroundColor = [UIColor colorWithRed:0.31f green:0.42f blue:0.64f alpha:1.00f];
            cell.textLabel.textColor = [UIColor colorWithRed:0.91f green:0.92f blue:0.93f alpha:1.00f];
        }
        else {
            cell.backgroundColor = [UIColor clearColor];
            cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"loginPrimaryButtonBackground.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 7, 0, 7)]];
            cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"loginPrimaryButtonBackgroundPressed.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 7, 0, 7)]];
            
            cell.textLabel.shadowColor = [UIColor colorWithRed:0.86f green:0.87f blue:0.89f alpha:1.00f];
            cell.textLabel.shadowOffset = CGSizeMake(0, 2);
            
            cell.textLabel.highlightedTextColor = [UIColor colorWithRed:0.33f green:0.33f blue:0.33f alpha:1.00f];
            cell.textLabel.font = [UIFont fontWithName:FZLTHK_FONT_FAMILY size:16.0f];
            cell.textLabel.textColor = element.enabled ? [UIColor colorWithRed:0.33f green:0.33f blue:0.33f alpha:1.00f] : [UIColor colorWithRed:0.67f green:0.67f blue:0.67f alpha:1.00f];
        }
    }
    else if ([element.key isEqualToString:@"key_go_signup"]) {
        cell.backgroundColor = [UIColor clearColor];
        
        QButtonElement *buttonElement = (QButtonElement *)element;

        cell.textLabel.font = [UIFont fontWithName:FZLTHK_FONT_FAMILY size:14.0f];
        cell.textLabel.textColor = [UIColor whiteColor];

        UIView *backgroundView = [[UIView alloc] init];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"loginSignUpButtonBackground.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)]];
        [backgroundView addSubview:imageView];
        CGSize textSize = [buttonElement.title sizeWithFont:cell.textLabel.font];
        CGFloat buttonWidth = textSize.width + 40.0f;
        // FIXED: buttonWidth+cell.textLabel.frame.origin.x，这里是因为没法修改titleLabel的frame，有个bug，暂时这样调整一下样式
        imageView.frame = CGRectMake((cell.contentView.frame.size.width-buttonWidth)/2, 0, buttonWidth, 35.0f);;
        cell.backgroundView = backgroundView;
        
        UIView *selectedBackgroundView = [[UIView alloc] init];
        UIImageView *selectedImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"loginSignUpButtonBackgroundPressed.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)]];
        [selectedBackgroundView addSubview:selectedImageView];
        selectedImageView.frame = imageView.frame;
        cell.selectedBackgroundView = selectedBackgroundView;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QSection *section = [self.root getVisibleSectionForIndex:indexPath.section];
    QElement *element = [section getVisibleElementForIndex: indexPath.row];
    
    if ([element.key isEqualToString:@"key_submit_login"]) {
        [self userLoginAction];
    }
    else if ([element.key isEqualToString:@"key_go_signup"]) {
        CDLog(@"go to singup");
        UserSignupViewController *signupController = [[UserSignupViewController alloc] init];
        [self.navigationController pushViewController:signupController animated:YES];
    }
}


#pragma mark - selector

- (void) dismissController
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [[RKObjectManager sharedManager] cancelAllObjectRequestOperationsWithMethod:RKRequestMethodPOST matchingPathPattern:@"/user/login"];
    }];
}

- (void) gotoUserSignupAction
{
    CDLog(@"go to singup");
    UserSignupViewController *signupController = [[UserSignupViewController alloc] init];
    [self.navigationController pushViewController:signupController animated:YES];
}


#pragma mark - QuickDialogEntryElementDelegate

- (BOOL) QEntryShouldReturnForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell
{
    if ([element.key isEqualToString:@"key_password"])
        [self userLoginAction];
    return YES;
}

- (void) QEntryEditingChangedForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell
{
    QEntryElement *usernameElement = (QEntryElement *)[self.root elementWithKey:@"key_username"];
    QEntryElement *passwordElement = (QEntryElement *)[self.root elementWithKey:@"key_password"];
    QButtonElement *submitButton = (QButtonElement *)[self.root elementWithKey:@"key_submit_login"];
    
    if (usernameElement.textValue.length < USER_NAME_MIN_LENGTH && passwordElement.textValue.length < USER_PASSWORD_MIN_LENGTH)
        submitButton.enabled = NO;
    else
        submitButton.enabled = YES;
    
    [self.quickDialogTableView reloadCellForElements:submitButton, nil];
}

- (void) QEntryDidEndEditingElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell
{
    if ([element.key isEqualToString:@"key_username"]) {
        [[CDDataCache shareCache] cacheLoginUserName:element.textValue];
    }
}


#pragma mark - submit login

- (void) userLoginAction
{
    [self.view endEditing:YES];

    CDUserForm *form = [[CDUserForm alloc] init];
    [self.root fetchValueUsingBindingsIntoObject:form];
    
    if (form.username.length < USER_NAME_MIN_LENGTH || form.password.length < USER_PASSWORD_MIN_LENGTH) {
        CDLog(@"please input username and password");
        return;
    }

    QButtonElement *submitButton = (QButtonElement *)[self.root elementWithKey:@"key_submit_login"];
    submitButton.enabled = NO;
    [self.quickDialogTableView reloadCellForElements:submitButton, nil];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:form.username, @"username",
                            [form.password md5], @"password", nil];
    
    NSDictionary *parameters = [CDRestClient requestParams:params];
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager postObject:nil path:@"/user/login" parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        submitButton.enabled = YES;
        [self.quickDialogTableView reloadCellForElements:submitButton, nil];
        
        CDUser *user = [mappingResult firstObject];
        NSLog(@"%@, %@", user.username, user.screen_name);
        if ([user isKindOfClass:[CDUser class]]) {
            [[CDDataCache shareCache] cacheLoginedUser:user];
            [self performSelector:@selector(dismissController)];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        submitButton.enabled = YES;
        [self.quickDialogTableView reloadCellForElements:submitButton, nil];
        
        if (error.code == NSURLErrorCancelled) return ;
        
        NSString *noticeMessage = @"账号或密码错误";
        if (error.code == NSURLErrorTimedOut)
            noticeMessage = @"网络超时";
        
        NSLog(@"error: %@", error);
        @try {
            NSData *jsonData = [error.localizedRecoverySuggestion dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *errorData = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
            NSLog(@"error: %@", errorData);
            NSInteger errorCode = [[errorData objectForKey:@"errcode"] integerValue];
            if (errorCode == CDUserLoginErrorUserNotAuthenticated) {
                noticeMessage = @"密码不正确";
                NSLog(@"username or password invalid");
            }
            else if (errorCode == CDUserLoginErrorUserNotExit) {
                noticeMessage = @"账号不存在";
            }
        }
        @catch (NSException *exception) {
            ;
        }
        @finally {
            [WBErrorNoticeView showErrorNoticeView:self.view title:@"提示" message:noticeMessage sticky:NO delay:1.5f dismissedBlock:nil];
        }
        
    }];
}


@end
