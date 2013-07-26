//
//  SettingViewController.m
//  waduanzi3
//
//  Created by chendong on 13-6-19.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CDDefine.h"
#import "SettingViewController.h"
#import "CDDataCache.h"
#import "CDAppUser.h"
#import "CDQuickElements.h"
#import "UserProfileViewController.h"
#import "CDUIKit.h"
#import "CDWebViewController.h"
#import "TestViewController.h"

@interface SettingViewController ()
- (void) setupNavbar;
@end

@implementation SettingViewController

- (id) init
{
    self = [super init];
    if (self) {
        QRootElement *root = [CDQuickElements createSettingElements];
        self.root = root;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.quickDialogTableView.styleProvider = self;
    self.quickDialogTableView.deselectRowWhenViewAppears = YES;
    
    [self setupNavbar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.quickDialogTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundDark.png"]];
    self.quickDialogTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundLight.png"]];
    
    NSString *cacheString = [NSString stringWithFormat:@"清除缓存 %@", [CDDataCache cacheFilesTotalSize]];
    QButtonElement *clearCacheButton = (QButtonElement *)[self.root elementWithKey:@"key_clear_cache"];
    clearCacheButton.title = cacheString;
    
    QBadgeElement *userProfileElement = (QBadgeElement *)[self.root elementWithKey:@"key_user_profile"];
    userProfileElement.hidden = ![CDAppUser hasLogined];
}

- (void) setupNavbar
{
    [CDUIKit setNavigationBar:self.navigationController.navigationBar style:CDNavigationBarStyleBlack forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleBordered target:self action:@selector(closeController)];
    
    [CDUIKit setBarButtionItem:self.navigationItem.leftBarButtonItem style:CDBarButtionItemStyleBlack forBarMetrics:UIBarMetricsDefault];
}


#pragma mark - QuickDialogStyleProvider delegate

-(void) cell:(UITableViewCell *)cell willAppearForElement:(QElement *)element atIndexPath:(NSIndexPath *)indexPath
{
}


#pragma mark - selector

- (void) closeController
{
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
}


#pragma mark - QuickDialog Element Actions

- (void) clearCacheAction:(QButtonElement *)element
{
    BOOL result = [CDDataCache clearAllCacheFiles];
    if (result) {
        NSString *cacheString = [NSString stringWithFormat:@"清除缓存 %@", [CDDataCache cacheFilesTotalSize]];
        element.title = cacheString;
        [self.quickDialogTableView reloadData];
    }
    NSLog(@"clear cache files: %d", result);
}

- (void) feedbackAction:(QLabelElement *)element
{
    NSLog(@"feedback");
}

- (void) starredAction:(QLabelElement *)element
{
    [CDAPPLICATION openURL:[NSURL URLWithString:APP_STORE_URL]];
    NSLog(@"starred");
}

- (void) userProfileAction:(QLabelElement *)element
{
    [self  dismissViewControllerAnimated:YES completion:^{
        static UINavigationController *profileNavController;
        
        UserProfileViewController *profileController = [[UserProfileViewController alloc] init];
        
        if (profileNavController == nil)
            profileNavController = [[UINavigationController alloc] initWithRootViewController:profileController];
        
        profileNavController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        [ROOT_CONTROLLER presentViewController:profileNavController animated:YES completion:nil];
        
    }];
    NSLog(@"user profile");
}

- (void) aboutmeAction:(QLabelElement *)element
{
    CDWebViewController *webController = [[CDWebViewController alloc] initWithUrl:@"http://m.waduanzi.com/about" toolbarStyle:CDToolBarStyleBlack];
    [self.navigationController pushViewController:webController animated:YES];
    
    NSLog(@"aboutme");
}

- (void) messagePushAction:(QBooleanElement *)element
{
    NSLog(@"message pushed: %d", [element.numberValue integerValue]);
}



@end
