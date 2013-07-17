//
//  UserSignupViewController.m
//  waduanzi3
//
//  Created by chendong on 13-6-19.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <RestKit/RestKit.h>
#import "CDDefine.h"
#import "UserSignupViewController.h"
#import "UserLoginViewController.h"
#import "WCAlertView.h"
#import "NSString+MD5.h"
#import "CDUser.h"
#import "CDRestClient.h"
#import "CDDataCache.h"
#import "CDQuickElements.h"

@interface UserSignupViewController ()
- (void) setupNavbar;
- (void) userSingupAction;
@end

@implementation UserSignupViewController

- (id) init
{
    self = [super init];
    if (self) {
        self.resizeWhenKeyboardPresented = YES;
        QRootElement *root = [CDQuickElements createUserSignupElements];
        self.root = root;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"注册";
    
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
        UIImage *bgImage = [UIImage imageWithCGImage:[[UIImage imageNamed:@"button_go_arrow.png"] CGImage] scale:1.0 orientation:UIImageOrientationDown];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:bgImage];
        CGFloat arrowX = cell.contentView.frame.size.width / 2 - textSize.width / 2 - 24.0f - 10.0f;
        CGFloat arrowY = (cell.frame.size.height - 24.0f) / 2;
        imageView.frame = CGRectMake(arrowX, arrowY, 24.0f, 24.0f);
        [bgview addSubview:imageView];
        cell.backgroundView = bgview;
        
        UIView *activeBgView = [[UIView alloc] init];
        UIImage *activeBgImage = [UIImage imageWithCGImage:[[UIImage imageNamed:@"button_go_arrow_active.png"] CGImage] scale:1.0 orientation:UIImageOrientationDown];
        UIImageView *activeImageView = [[UIImageView alloc] initWithImage:activeBgImage];
        activeImageView.frame = imageView.frame;
        [activeBgView addSubview:activeImageView];
        cell.selectedBackgroundView = activeBgView;
    }
}

#pragma mark - selector

- (void) dismissController
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [[RKObjectManager sharedManager] cancelAllObjectRequestOperationsWithMethod:RKRequestMethodPOST matchingPathPattern:@"/user/signup"];
    }];
}

- (void) retrunUserLoginAction
{
    if (self.navigationController.viewControllers.count > 1)
        [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - QuickDialogEntryElementDelegate

- (BOOL) QEntryShouldReturnForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell
{
    if ([element.key isEqualToString:@"key_password"])
        [self userSingupAction];
    return YES;
}

- (void) userSingupAction
{
    NSLog(@"user signup");
    self.navigationItem.leftBarButtonItem.enabled = NO;
}

@end
