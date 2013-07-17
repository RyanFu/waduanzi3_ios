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
#import "CDUserForm.h"

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
    self.title = @"登录";

    self.quickDialogTableView.styleProvider = self;
    QEntryElement *usernameElement = (QEntryElement *)[self.root elementWithKey:@"key_username"];
    QEntryElement *passwordElement = (QEntryElement *)[self.root elementWithKey:@"key_password"];
    usernameElement.delegate = passwordElement.delegate = self;
    
    [self setupNavbar];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setup subviews

- (void) setupNavbar
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(dismissController)];
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

- (void) dismissController
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [[RKObjectManager sharedManager] cancelAllObjectRequestOperationsWithMethod:RKRequestMethodPOST matchingPathPattern:@"/user/login"];
    }];
}

- (void) gotoUserSignupAction
{
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



#pragma mark - submit login

- (void) userLoginAction
{
    self.navigationItem.leftBarButtonItem.enabled = NO;
    
    CDUserForm *form = [[CDUserForm alloc] init];
    [self.root fetchValueUsingBindingsIntoObject:form];
    
    if (form.username.length == 0 || form.password.length == 0) {
        NSLog(@"please input username and password");
        self.navigationItem.leftBarButtonItem.enabled = YES;
        return;
    }
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:form.username, @"username",
                            [form.password md5], @"password", nil];
    
    NSDictionary *parameters = [CDRestClient requestParams:params];
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    [objectManager postObject:nil path:@"/user/login" parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        CDUser *user = [mappingResult firstObject];
        NSLog(@"%@, %@", user.username, user.screen_name);
        if ([user isKindOfClass:[CDUser class]]) {
            [[CDDataCache shareCache] cacheLoginedUser:user];
            [[CDDataCache shareCache] removeMySharePosts];
            [[CDDataCache shareCache] removeFavoritePosts];
            self.navigationItem.leftBarButtonItem.enabled = YES;
            [self performSelector:@selector(dismissController)];
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        self.navigationItem.leftBarButtonItem.enabled = YES;
        NSLog(@"error: %@", error);
        NSData *jsonData = [error.localizedRecoverySuggestion dataUsingEncoding:NSUTF8StringEncoding];
        NSError *_error;
        NSDictionary *errorData = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&_error];
        NSLog(@"error: %@", errorData);
        if ([[errorData objectForKey:@"errcode"] integerValue] == USER_NOT_AUTHENTICATED)
            NSLog(@"username or password invalid");
    }];
}


@end
