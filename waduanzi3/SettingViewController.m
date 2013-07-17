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

@interface SettingViewController ()

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
	// Do any additional setup after loading the view.
    self.quickDialogTableView.backgroundColor = [UIColor colorWithRed:0.89f green:0.88f blue:0.83f alpha:1.00f];
//    self.quickDialogTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundDark.png"]];
    self.quickDialogTableView.styleProvider = self;
    self.quickDialogTableView.deselectRowWhenViewAppears = YES;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleBordered target:self action:@selector(closeController)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *cacheString = [NSString stringWithFormat:@"清除缓存 %@", [CDDataCache cacheFilesTotalSize]];
    QButtonElement *clearCacheButton = (QButtonElement *)[self.root elementWithKey:@"key_clear_cache"];
    clearCacheButton.title = cacheString;
    
    QBadgeElement *userProfileElement = (QBadgeElement *)[self.root elementWithKey:@"key_user_profile"];
    userProfileElement.hidden = ![CDAppUser hasLogined];
}


#pragma mark - QuickDialogStyleProvider delegate

-(void) cell:(UITableViewCell *)cell willAppearForElement:(QElement *)element atIndexPath:(NSIndexPath *)indexPath
{
//    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundLight.png"]];
//    cell.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.91f alpha:1.00f];
//    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundLight.png"]];
//    cell.backgroundView.layer.cornerRadius = 5.0f;
//    cell.backgroundView.layer.borderColor = [UIColor grayColor].CGColor;
//    cell.backgroundView.layer.borderWidth = 1.5f;
//    cell.backgroundView.layer.shadowColor = [UIColor redColor].CGColor;
//    cell.backgroundView.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
//    cell.backgroundView.layer.shadowRadius = 5.0f;
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
    QWebViewController *webController = [[QWebViewController alloc] initWithUrl:@"http://m.waduanzi.com/about"];
    webController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webController animated:YES];
    
    NSLog(@"aboutme");
}

- (void) messagePushAction:(QBooleanElement *)element
{
    NSLog(@"message pushed: %d", [element.numberValue integerValue]);
}



@end
