//
//  UserProfileViewController.m
//  waduanzi3
//
//  Created by chendong on 13-6-19.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "UserProfileViewController.h"
#import "CDQuickElements.h"
#import <QuartzCore/QuartzCore.h>

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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissController:)];
}

#pragma mark - selector

- (void) dismissController:(id)sender
{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - QuickDialogStyleProvider
- (void) cell:(UITableViewCell *)cell willAppearForElement:(QElement *)element atIndexPath:(NSIndexPath *)indexPath
{
    if ([element.key isEqualToString:@"key_logout_button"]) {
        UIView *bgView = [[UIView alloc] initWithFrame:cell.frame];
        bgView.backgroundColor = [UIColor redColor];
        bgView.layer.cornerRadius = 6.0f;
        cell.backgroundView = bgView;
        
        UIView *selectedBgView = [[UIView alloc] initWithFrame:cell.frame];
        selectedBgView.backgroundColor = [UIColor redColor];
        selectedBgView.layer.cornerRadius = 6.0f;
        cell.selectedBackgroundView = selectedBgView;
        
        cell.textLabel.textColor = [UIColor whiteColor];
    }
}

- (void) logoutAction:(QButtonElement *)element
{
    NSLog(@"logout");
}

@end
