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
#import "WCAlertView.h"
#import "NSString+MD5.h"
#import "CDUser.h"
#import "CDRestClient.h"
#import "CDDataCache.h"
#import "CDQuickElements.h"
#import "CDUIKit.h"
#import "UIImage+merge.h"

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
        self.root = [CDQuickElements createUserSignupElements];
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


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.quickDialogTableView.backgroundColor = [UIColor clearColor];
    
    UIImage *image1 = [UIImage imageNamed:@"loginTexture.png"];
    UIImage *image2 = [UIImage imageNamed:@"background.png"];
    UIImage *backgroundImage = [UIImage mergeImage:image1 withImage:image2 withAlpha:0.5];
    self.quickDialogTableView.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(dismissController)];
    
    [CDUIKit setBarButtionItem:self.navigationItem.leftBarButtonItem style:CDBarButtionItemStyleBlack forBarMetrics:UIBarMetricsDefault];
}


- (void) cell:(UITableViewCell *)cell willAppearForElement:(QElement *)element atIndexPath:(NSIndexPath *)indexPath
{
    QButtonElement *buttonElement = (QButtonElement *)element;
    
    if (indexPath.section == 1) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"loginPrimaryButtonBackground.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 7, 0, 7)]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"loginPrimaryButtonBackgroundPressed.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 7, 0, 7)]];
        
        cell.textLabel.highlightedTextColor = [UIColor colorWithRed:0.33f green:0.33f blue:0.33f alpha:1.00f];
        cell.textLabel.shadowColor = [UIColor colorWithRed:0.86f green:0.87f blue:0.89f alpha:1.00f];
        cell.textLabel.shadowOffset = CGSizeMake(0, 2);
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        cell.textLabel.textColor = element.enabled ? [UIColor colorWithRed:0.33f green:0.33f blue:0.33f alpha:1.00f] : [UIColor colorWithRed:0.67f green:0.67f blue:0.67f alpha:1.00f];
    }
    else if (indexPath.section == 2) {
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.textLabel.textColor = [UIColor whiteColor];
        
        UIView *backgroundView = [[UIView alloc] init];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"loginSignUpButtonBackground.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)]];
        [backgroundView addSubview:imageView];
        CGSize textSize = [buttonElement.title sizeWithFont:cell.textLabel.font];
        CGFloat buttonWidth = textSize.width + 40.0f;
        imageView.frame = CGRectMake((cell.contentView.frame.size.width-buttonWidth)/2, 0, buttonWidth, 35.0f);;
        cell.backgroundView = backgroundView;
        
        UIView *selectedBackgroundView = [[UIView alloc] init];
        UIImageView *selectedImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"loginSignUpButtonBackgroundPressed.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)]];
        [selectedBackgroundView addSubview:selectedImageView];
        selectedImageView.frame = imageView.frame;
        cell.selectedBackgroundView = selectedBackgroundView;
    }
}


#pragma mark - QuickDialogEntryElementDelegate

- (BOOL) QEntryShouldReturnForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell
{
    if ([element.key isEqualToString:@"key_password"])
        [self userSingupAction];
    return YES;
}

- (void) QEntryEditingChangedForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell
{
    QEntryElement *usernameElement = (QEntryElement *)[self.root elementWithKey:@"key_username"];
    QEntryElement *passwordElement = (QEntryElement *)[self.root elementWithKey:@"key_password"];
    QButtonElement *submitButton = (QButtonElement *)[self.root elementWithKey:@"key_submit_login"];
    
    if (usernameElement.textValue.length > 0 && passwordElement.textValue.length > 0)
        submitButton.enabled = YES;
    else
        submitButton.enabled = NO;
    
    [self.quickDialogTableView reloadCellForElements:submitButton, nil];
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


- (void) userSingupAction
{
    NSLog(@"user signup");
    self.navigationItem.leftBarButtonItem.enabled = NO;
}

@end
