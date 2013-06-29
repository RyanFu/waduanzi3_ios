//
//  SideMenuViewController.m
//  waduanzi3
//
//  Created by chendong on 13-3-4.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CDDefine.h"
#import "SideMenuViewController.h"
#import "IIViewDeckController.h"
#import "TimelineViewController.h"
#import "MediaTypeViewController.h"
#import "UserProfileViewController.h"
#import "SettingViewController.h"
#import "UserLoginViewController.h"
#import "MyshareViewController.h"
#import "MyFavoriteViewController.h"
#import "BestViewController.h"
#import "HistoryViewController.h"
#import "CDDataCache.h"
#import "CDUser.h"
#import "CDAppUser.h"
#import "CDQuickElements.h"
#import "CDSideTableViewCell.h"

@interface SideMenuViewController ()
- (void) setupNavBarButtonItem;
@end

@implementation SideMenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        NSString * sidemenus = [[NSBundle mainBundle] pathForResource:@"sidemenus" ofType:@"plist"];
        menuData = [NSMutableArray arrayWithContentsOfFile:sidemenus];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.scrollsToTop = NO;
    self.navigationItem.hidesBackButton = YES;
    self.clearsSelectionOnViewWillAppear = NO;
    [self setupNavBarButtonItem];
 
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"menu_table_bg.png"]stretchableImageWithLeftCapWidth:2.0 topCapHeight:2.0f]];
    bgView.contentMode = UIViewContentModeScaleToFill;
    bgView.frame = self.tableView.frame;
    self.tableView.backgroundView = bgView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


#pragma mark - setup subviews

- (void) setupNavBarButtonItem
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(openUserViewController)];
    UIBarButtonItem *settingButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(openSettingController:)];
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexButton.width = DECK_LEFT_SIZE;
    NSArray *rightButtons = [NSArray arrayWithObjects:flexButton, settingButton, nil];
    self.navigationItem.rightBarButtonItems = rightButtons;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [menuData count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[menuData objectAtIndex:section] count];
}

- (CDSideTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SideMenuCell";
    CDSideTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CDSideTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar_placeholder"]];
    }
    
    NSDictionary *menu = [[menuData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = [menu objectForKey:@"name"];
    
    UIImage *bgImage = [[UIImage imageNamed:@"menu_cell_bg.png"] stretchableImageWithLeftCapWidth:2.0 topCapHeight:2.0f];
    UIImageView *bgView = [[UIImageView alloc] initWithImage:bgImage];
    bgView.contentMode = UIViewContentModeScaleToFill;
    bgView.frame = cell.contentView.frame;
    cell.backgroundView = bgView;
    
    UIView *selectedBgView = [[UIView alloc] init];
    selectedBgView.backgroundColor = [UIColor colorWithRed:205.0/255.0 green:128.0/255.0 blue:3.0/255.0 alpha:1];
    cell.selectedBackgroundView = selectedBgView;
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 0.0f : 9.0f;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_cell_separator.png"]];
    imgView.frame = CGRectMake(0, 0, tableView.frame.size.width, 9);
    return imgView;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
        UINavigationController *centerViewController;
        
        if (indexPath.section == 0) {
            static TimelineViewController *timelineViewController;
            static BestViewController *bestViewController;
            static HistoryViewController *historyViewController;
            switch (indexPath.row) {
                case 0:
                    if (timelineViewController == nil)
                        timelineViewController = [[TimelineViewController alloc] init];
                    centerViewController = [[UINavigationController alloc] initWithRootViewController:timelineViewController];
                    self.viewDeckController.centerController = centerViewController;
                    break;
                case 1:
                    if (bestViewController == nil)
                        bestViewController = [[BestViewController alloc] init];
                    centerViewController = [[UINavigationController alloc] initWithRootViewController:bestViewController];
                    self.viewDeckController.centerController = centerViewController;
                    break;
                case 2:
                    if (historyViewController == nil)
                        historyViewController = [[HistoryViewController alloc] init];
                    centerViewController = [[UINavigationController alloc] initWithRootViewController:historyViewController];
                    self.viewDeckController.centerController = centerViewController;
                default:
                    break;
            }
        }
        else if (indexPath.section == 1) {
            static MediaTypeViewController *textJokeViewController, *imageJokeViewController;
            
            switch (indexPath.row) {
                case 0:
                    if (textJokeViewController == nil) {
                        textJokeViewController = [[MediaTypeViewController alloc] initWithMediaType:MEDIA_TYPE_TEXT];
                        textJokeViewController.title = @"挖笑话";
                    }
                    centerViewController = [[UINavigationController alloc] initWithRootViewController:textJokeViewController];
                    self.viewDeckController.centerController = centerViewController;
                    break;
                case 1:
                    if (imageJokeViewController == nil) {
                        imageJokeViewController = [[MediaTypeViewController alloc] initWithMediaType:MEDIA_TYPE_IMAGE];
                        imageJokeViewController.title = @"挖趣图";
                    }
                    centerViewController = [[UINavigationController alloc] initWithRootViewController:imageJokeViewController];
                    self.viewDeckController.centerController = centerViewController;
                    break;
                default:
                    break;
            }
        }
        else if (indexPath.section == 2) {
            if (![CDAppUser hasLogined]) {
                [self performSelector:@selector(openUserLoginController)];
                return ;
            }
            CDUser *user = [CDAppUser currentUser];
            NSInteger userID = [user.user_id integerValue];
            
            static MyshareViewController *myshareController;
            static MyFavoriteViewController *favoriteController;
            switch (indexPath.row) {
                case 0:
                    if (favoriteController == nil)
                        favoriteController = [[MyFavoriteViewController alloc] initWithUserID:userID];
                    centerViewController = [[UINavigationController alloc] initWithRootViewController:favoriteController];
                    self.viewDeckController.centerController = centerViewController;
                    break;
                case 1:
                    break;
                case 2:
                    if (myshareController == nil)
                        myshareController = [[MyshareViewController alloc] initWithUserID:userID];
                    centerViewController = [[UINavigationController alloc] initWithRootViewController:myshareController];
                    self.viewDeckController.centerController = centerViewController;
                    break;
                    
                default:
                    break;
            }
        }
    }];
}


#pragma mark - button item selector

- (void) openSettingController:(id)sender
{
    SettingViewController *settingController = [[SettingViewController alloc] init];
    UINavigationController *settingNavController = [[UINavigationController alloc] initWithRootViewController:settingController];
    UIViewController *rootController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [rootController presentViewController:settingNavController animated:YES completion:^{
        ;
    }];
}

- (void) openUserViewController
{
    if ([CDAppUser hasLogined])
        [self performSelector:@selector(openUserProfileController)];
    else
        [self performSelector:@selector(openUserLoginController)];
}

- (void) openUserProfileController
{
    static UINavigationController *profileNavController;
    
    UIViewController *rootController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    UserProfileViewController *profileController = [[UserProfileViewController alloc] init];
    
    if (profileNavController == nil)
        profileNavController = [[UINavigationController alloc] initWithRootViewController:profileController];
    
    profileNavController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    [rootController presentViewController:profileNavController animated:YES completion:nil];
    
}

- (void) openUserLoginController
{
    static UINavigationController *loginNavController;
    
    UIViewController *rootController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    UserLoginViewController *loginController = [[UserLoginViewController alloc] init];
    
    if (loginNavController == nil)
        loginNavController = [[UINavigationController alloc] initWithRootViewController:loginController];
    
    loginNavController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    [rootController presentViewController:loginNavController animated:YES completion:nil];
    
}

@end


