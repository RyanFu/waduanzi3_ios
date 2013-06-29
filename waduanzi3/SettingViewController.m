//
//  SettingViewController.m
//  waduanzi3
//
//  Created by chendong on 13-6-19.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "SettingViewController.h"
#import "CDDataCache.h"
#import "CDAppUser.h"
#import "CDQuickElements.h"

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
    self.quickDialogTableView.backgroundView = nil;
    self.quickDialogTableView.backgroundColor = [UIColor colorWithRed:0.89f green:0.88f blue:0.83f alpha:1.00f];
    self.quickDialogTableView.styleProvider = self;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(closeController)];
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
    cell.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.91f alpha:1.00f];
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
    NSLog(@"clear cache files: %d", result);
}

- (void) feedbackAction:(QLabelElement *)element
{
    NSLog(@"feedback");
}

- (void) starredAction:(QLabelElement *)element
{
    NSLog(@"starred");
}

- (void) userProfileAction:(QLabelElement *)element
{
    NSLog(@"user profile");
}

- (void) aboutmeAction:(QLabelElement *)element
{
    NSLog(@"aboutme");
}

- (void) messagePushAction:(QBooleanElement *)element
{
    NSLog(@"message pushed: %d", [element.numberValue integerValue]);
}



@end
