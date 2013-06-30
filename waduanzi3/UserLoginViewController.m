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
#import "WCAlertView.h"
#import "UserSignupViewController.h"
#import "NSString+MD5.h"
#import "CDUser.h"
#import "CDRestClient.h"
#import "CDDataCache.h"
#import "CDQuickElements.h"

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
        QRootElement *root = [CDQuickElements createUserLoginElements];
        self.root = root;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"注册";
    self.view.userInteractionEnabled = YES;
    
    self.view.backgroundColor = self.quickDialogTableView.backgroundColor = [UIColor colorWithRed:0.89f green:0.88f blue:0.83f alpha:1.00f];
    self.quickDialogTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_background.png"]];
    self.quickDialogTableView.styleProvider = self;
    
    [self setupNavbar];
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


- (void) cell:(UITableViewCell *)cell willAppearForElement:(QElement *)element atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_button_flat.png"]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_button_flat_active.png"]];
    }
    else if (indexPath.section == 2) {
        QButtonElement *buttonElement = (QButtonElement *)element;
        CGSize textSize = [buttonElement.title sizeWithFont:cell.textLabel.font forWidth:cell.textLabel.frame.size.width lineBreakMode:NSLineBreakByWordWrapping];
        UIView *bgview = [[UIView alloc] init];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_go_arrow.png"]];
        CGFloat arrowX = cell.contentView.frame.size.width / 2 + textSize.width / 2 + 10.0f;
        CGFloat arrowY = (cell.frame.size.height - 24.0f) / 2;
        imageView.frame = CGRectMake(arrowX, arrowY, 24.0f, 24.0f);
        [bgview addSubview:imageView];
        cell.backgroundView = bgview;
        
        UIView *activeBgView = [[UIView alloc] init];
        UIImageView *activeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_go_arrow_active.png"]];
        activeImageView.frame = imageView.frame;
        [activeBgView addSubview:activeImageView];
        cell.selectedBackgroundView = activeBgView;
    }
}

#pragma mark - selector

- (void) dismissController:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void) gotoUserSignupAction
{
    UserSignupViewController *signupController = [[UserSignupViewController alloc] init];
    [self.navigationController pushViewController:signupController animated:YES];
}


#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == USERNAME_TEXTFIELD_TAG) {
//        [_passwordTextField becomeFirstResponder];
        return YES;
    }
    else if (textField.tag == PASSWORD_TEXTFIELD_TAG) {
        [self userLoginAction];
        
        return YES;
    }
    else
        return NO;
}



#pragma mark - submit login

- (void) userLoginAction
{
//    if (_usernameTextField.text.length == 0 || _passwordTextField.text.length == 0) {
//        NSLog(@"please input username and password");
//        return;
//    }
    
    NSDictionary *params = nil;//[NSDictionary dictionaryWithObjectsAndKeys:_usernameTextField.text, @"username",
//                            [_passwordTextField.text md5], @"password", nil];
    
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
