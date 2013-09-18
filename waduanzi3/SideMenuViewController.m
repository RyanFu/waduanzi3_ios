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
#import "CDUIKit.h"
#import "MyFeedbackViewController.h"
#import "FocusListViewController.h"
#import "CDNavigationController.h"

@interface SideMenuViewController ()
{
    UIBarButtonItem *_settingButton;
    NSArray *_sectionHeaderTitles;
}
- (void) setupNavBarButtonItem;
@end

@implementation SideMenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _sectionHeaderTitles = @[@"", @"分类", @"我的"];
        
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
 
    UIImageView *tableBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"FBSideBarCellBackground.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(1.0f, 0, 1.0f, 0)]];
    self.tableView.backgroundView = tableBackgroundView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


#pragma mark - setup subviews

- (void) setupNavBarButtonItem
{
    [CDUIKit setNavigationBar:self.navigationController.navigationBar style:CDNavigationBarStyleBlack forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStyleBordered target:self action:@selector(openUserViewController)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    _settingButton = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleBordered target:self action:@selector(openSettingController:)];
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flexButton.width = DECK_LEFT_SIZE;
    NSArray *rightButtons = [NSArray arrayWithObjects:flexButton, _settingButton, nil];
    self.navigationItem.rightBarButtonItems = rightButtons;
    
    [CDUIKit setBarButtionItem:self.navigationItem.leftBarButtonItem style:CDBarButtionItemStyleBlack forBarMetrics:UIBarMetricsDefault];
    [CDUIKit setBarButtionItem:_settingButton style:CDBarButtionItemStyleBlack forBarMetrics:UIBarMetricsDefault];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *leftButtonTitle = [CDAppUser hasLogined] ? [CDAppUser currentUser].screen_name : @"登录";
    self.navigationItem.leftBarButtonItem.title = leftButtonTitle;
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
    }
    
    NSDictionary *menu = [[menuData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = [menu objectForKey:@"name"];
    if ([menu objectForKey:@"icon"] != nil)
        cell.imageView.image = [UIImage imageNamed:[menu objectForKey:@"icon"]];
    else
        cell.imageView.image = nil;
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 0.0f : 32.0f;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FBMenuSectionHeaderBackground.png"]];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 100, 32.0f)];
    titleLabel.text = [_sectionHeaderTitles objectAtIndex:section];
    titleLabel.font = [UIFont fontWithName:FZLTHK_FONT_NAME size:14.0f];
    titleLabel.textColor = [UIColor colorWithRed:0.61f green:0.64f blue:0.70f alpha:1.00f];
    titleLabel.backgroundColor = [UIColor clearColor];
    [imgView addSubview:titleLabel];
    
    return imgView;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && ![CDAppUser hasLogined]) {
        [self performSelector:@selector(openUserLoginController)];
        return ;
    }
    
    [self.viewDeckController closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
        CDNavigationController *centerViewController;
        
        if (indexPath.section == 0) {
            static TimelineViewController *timelineViewController;
            static BestViewController *bestViewController;
            static HistoryViewController *historyViewController;
            switch (indexPath.row) {
                case 0:
                    if (timelineViewController == nil)
                        timelineViewController = [[TimelineViewController alloc] init];
                    centerViewController = [[CDNavigationController alloc] initWithRootViewController:timelineViewController];
                    self.viewDeckController.centerController = centerViewController;
                    break;
                case 1:
                    if (bestViewController == nil)
                        bestViewController = [[BestViewController alloc] init];
                    centerViewController = [[CDNavigationController alloc] initWithRootViewController:bestViewController];
                    self.viewDeckController.centerController = centerViewController;
                    break;
                case 2:
                    if (historyViewController == nil)
                        historyViewController = [[HistoryViewController alloc] init];
                    historyViewController.forceRefresh = YES;
                    centerViewController = [[CDNavigationController alloc] initWithRootViewController:historyViewController];
                    self.viewDeckController.centerController = centerViewController;
                default:
                    break;
            }
        }
        else if (indexPath.section == 1) {
            static MediaTypeViewController *textJokeViewController, *imageJokeViewController, *videoJokeViewController;
            static FocusListViewController *articleViewController;
            
            switch (indexPath.row) {
                case 0:
                    if (textJokeViewController == nil) {
                        textJokeViewController = [[MediaTypeViewController alloc] initWithMediaType:MEDIA_TYPE_TEXT];
                        textJokeViewController.title = @"挖笑话";
                    }
                    centerViewController = [[CDNavigationController alloc] initWithRootViewController:textJokeViewController];
                    self.viewDeckController.centerController = centerViewController;
                    break;
                case 1:
                    if (imageJokeViewController == nil) {
                        imageJokeViewController = [[MediaTypeViewController alloc] initWithMediaType:MEDIA_TYPE_IMAGE];
                        imageJokeViewController.title = @"挖趣图";
                    }
                    centerViewController = [[CDNavigationController alloc] initWithRootViewController:imageJokeViewController];
                    self.viewDeckController.centerController = centerViewController;
                    break;
                case 2:
                    if (videoJokeViewController == nil) {
                        videoJokeViewController = [[MediaTypeViewController alloc] initWithMediaType:MEDIA_TYPE_VIDEO];
                        videoJokeViewController.title = @"挖视频";
                    }
                    centerViewController = [[CDNavigationController alloc] initWithRootViewController:videoJokeViewController];
                    self.viewDeckController.centerController = centerViewController;
                    break;
                case 3:
                    if (articleViewController == nil) {
                        articleViewController = [[FocusListViewController alloc] init];
                        articleViewController.title = @"挖热门";
                    }
                    centerViewController = [[CDNavigationController alloc] initWithRootViewController:articleViewController];
                    self.viewDeckController.centerController = centerViewController;
                    break;
                default:
                    break;
            }
        }
        else if (indexPath.section == 2) {
            static MyshareViewController *myshareController;
            static MyFavoriteViewController *favoriteController;
            static MyFeedbackViewController *feedbackController;
            switch (indexPath.row) {
                case 0:
                    if (favoriteController == nil)
                        favoriteController = [[MyFavoriteViewController alloc] init];
                    favoriteController.forceRefresh = YES;
                    centerViewController = [[CDNavigationController alloc] initWithRootViewController:favoriteController];
                    self.viewDeckController.centerController = centerViewController;
                    break;
                case 1:
                    if (feedbackController == nil)
                        feedbackController = [[MyFeedbackViewController alloc] init];
                    feedbackController.forceRefresh = YES;
                    centerViewController = [[CDNavigationController alloc] initWithRootViewController:feedbackController];
                    self.viewDeckController.centerController = centerViewController;
                    break;
                case 2:
                    if (myshareController == nil)
                        myshareController = [[MyshareViewController alloc] init];
                    myshareController.forceRefresh = YES;
                    centerViewController = [[CDNavigationController alloc] initWithRootViewController:myshareController];
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
    CDNavigationController *settingNavController = [[CDNavigationController alloc] initWithRootViewController:settingController];

    [ROOT_CONTROLLER presentViewController:settingNavController animated:YES completion:^{
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
    UserProfileViewController *profileController = [[UserProfileViewController alloc] init];
    CDNavigationController *profileNavController = [[CDNavigationController alloc] initWithRootViewController:profileController];
    
    [ROOT_CONTROLLER presentViewController:profileNavController animated:YES completion:nil];
    
}

- (void) openUserLoginController
{
    UserLoginViewController *loginController = [[UserLoginViewController alloc] init];
    CDNavigationController *loginNavController = [[CDNavigationController alloc] initWithRootViewController:loginController];    
    [self presentViewController:loginNavController animated:YES completion:nil];
    
}

@end


