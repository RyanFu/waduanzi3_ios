//
//  UpdateProfileViewController.m
//  waduanzi3
//
//  Created by chendong on 13-7-30.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "UpdateProfileViewController.h"
#import "CDUIKit.h"
#import "CDQuickElements.h"
#import "CDUser.h"
#import "CDAppUser.h"
#import "CDDataCache.h"
#import "WBErrorNoticeView+WaduanziMethod.h"

@interface UpdateProfileViewController ()
- (void) setupNavbar;
- (void) updateUserProfileAction;
@end

@implementation UpdateProfileViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.root = [CDQuickElements createUpdateProfileElements];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.quickDialogTableView.delegate = self;
    self.quickDialogTableView.deselectRowWhenViewAppears = YES;
    
    QEntryElement *nicknameElement = (QEntryElement *)[self.root elementWithKey:@"key_update_nick_name"];
    nicknameElement.delegate = self;
    
    [self  setupNavbar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.quickDialogTableView.backgroundColor = [UIColor clearColor];
    
    self.quickDialogTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feed_table_bg.png"]];
    self.quickDialogTableView.backgroundColor = [UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
}


#pragma mark - setup subviews

- (void) setupNavbar
{
    [CDUIKit setNavigationBar:self.navigationController.navigationBar style:CDNavigationBarStyleBlack forBarMetrics:UIBarMetricsDefault];
    [CDUIKit setBackBarButtionItemStyle:CDBarButtionItemStyleBlack forBarMetrics:UIBarMetricsDefault];
    [CDUIKit setBarButtionItem:self.navigationItem.rightBarButtonItem style:CDBarButtionItemStyleBlack forBarMetrics:UIBarMetricsDefault];
}


#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QSection *section = [self.root getVisibleSectionForIndex:indexPath.section];
    QElement *element = [section getVisibleElementForIndex: indexPath.row];
    
    return ([element.key isEqualToString:@"key_save_profile"]) ? 42.0f : 44.0f;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    QSection *section = [self.root getVisibleSectionForIndex:indexPath.section];
    QElement *element = [section getVisibleElementForIndex: indexPath.row];
    
    if (indexPath.section == 0) {
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        [cell becomeFirstResponder];
    }
    else if (indexPath.section == 1) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"loginPrimaryButtonBackground.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 7, 0, 7)]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"loginPrimaryButtonBackgroundPressed.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 7, 0, 7)]];
        
        cell.textLabel.highlightedTextColor = [UIColor colorWithRed:0.33f green:0.33f blue:0.33f alpha:1.00f];
        cell.textLabel.shadowColor = [UIColor colorWithRed:0.86f green:0.87f blue:0.89f alpha:1.00f];
        cell.textLabel.shadowOffset = CGSizeMake(0, 2);
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        cell.textLabel.textColor = element.enabled ? [UIColor colorWithRed:0.33f green:0.33f blue:0.33f alpha:1.00f] : [UIColor colorWithRed:0.67f green:0.67f blue:0.67f alpha:1.00f];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QSection *section = [self.root getVisibleSectionForIndex:indexPath.section];
    QElement *element = [section getVisibleElementForIndex: indexPath.row];
    
    if ([element.key isEqualToString:@"key_save_profile"]) {
        [self updateUserProfileAction];
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL) QEntryShouldReturnForElement:(QEntryElement *)element andCell:(QEntryTableViewCell *)cell
{
    if ([element.key isEqualToString:@"key_update_nick_name"]) {
        [self updateUserProfileAction];
        return YES;
    }
    else
        return NO;
}

#pragma mark - selector

- (void) updateUserProfileAction
{
    [self.view endEditing:YES];
    
    QEntryElement *entryEelement = (QEntryElement *)[self.root elementWithKey:@"key_update_nick_name"];
    NSString *newNickname = entryEelement.textValue;
    
    if (newNickname.length > 0) {
        CDUser *sessionUser = [CDAppUser currentUser];
        if ([newNickname isEqualToString:sessionUser.screen_name]) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        RKObjectManager *objectManager = [RKObjectManager sharedManager];
        NSDictionary *parameters = @{@"user_id": sessionUser.user_id, @"screen_name" : newNickname};
        [objectManager.HTTPClient putPath:@"/user/update" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"update screen name result: %@", responseObject);
            
            sessionUser.screen_name = newNickname;
            [[CDDataCache shareCache] cacheLoginedUser:sessionUser];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"update screen name error: %@", error);
            
            NSString *noticeMessage = @"昵称已经被人抢走啦，换一个吧";
            @try {
                NSData *jsonData = [error.localizedRecoverySuggestion dataUsingEncoding:NSUTF8StringEncoding];
                NSError *jsonParserError;
                NSDictionary *errorObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&jsonParserError];
                
                if (!jsonParserError) {
                    NSInteger errorCode = [[errorObjects objectForKey:@"errcode"] integerValue];
                    if (errorCode == CDUpdateUserProfileErrorNickExist) {
                        noticeMessage = [errorObjects objectForKey:@"message"];
                        
                    }
                }
            }
            @catch (NSException *exception) {
                ;
            }
            @finally {
                [WBErrorNoticeView showErrorNoticeView:self.view title:@"提示" message:noticeMessage sticky:NO delay:1.5f dismissedBlock:nil];
            }
            
            
        }];
    }
}

@end
