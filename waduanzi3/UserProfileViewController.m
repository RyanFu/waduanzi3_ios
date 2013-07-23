//
//  UserProfileViewController.m
//  waduanzi3
//
//  Created by chendong on 13-6-19.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UserProfileViewController.h"
#import "CDQuickElements.h"
#import "CDAppUser.h"
#import "CDUIKit.h"

@interface UserProfileViewController ()
- (void) setupNavbar;
@end

@implementation UserProfileViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.root = [CDQuickElements createUserProfileElements];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.quickDialogTableView.backgroundView = nil;
    self.quickDialogTableView.backgroundColor = [UIColor colorWithRed:0.89f green:0.88f blue:0.83f alpha:1.00f];
    self.quickDialogTableView.styleProvider = self;
    self.quickDialogTableView.deselectRowWhenViewAppears = YES;

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
    [CDUIKit setNavigationBar:self.navigationController.navigationBar style:CDNavigationBarStyleSearch forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleBordered target:self action:@selector(dismissController)];
    
    [CDUIKit setBarButtionItem:self.navigationItem.leftBarButtonItem style:CDBarButtionItemStyleSearch forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - selector

- (void) dismissController
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - QuickDialogStyleProvider
- (void) cell:(UITableViewCell *)cell willAppearForElement:(QElement *)element atIndexPath:(NSIndexPath *)indexPath
{
    if ([element.key isEqualToString:@"key_logout_button"]) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"common_button_red_nor.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 6.0f, -1.0f, 6.0f)]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"common_button_red_press.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 6.0f, -1.0f, 6.0f)]];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    }
}

- (void) logoutAction:(QButtonElement *)element
{
    element.enabled = NO;
    __weak UserProfileViewController *weakSelf = self;
    [CDAppUser logoutWithCompletion:^(CDUser *user) {
        [weakSelf performSelector:@selector(dismissController)];
    }];
}

@end
