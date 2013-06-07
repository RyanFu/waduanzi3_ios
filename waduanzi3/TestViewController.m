//
//  TestViewController.m
//  waduanzi3
//
//  Created by chendong on 13-5-29.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <RestKit/RestKit.h>

#import "TestViewController.h"
#import "CDPost.h"
#import "CDRestClient.h"
#import "CDRestError.h"
#import "CDPostTableViewCell.h"


@interface TestViewController (Private)
- (void)loadTimeline;
@end

@implementation TestViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadTimeline];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadFirstPostComments)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_statuses count];
}

- (CDPostTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"PostCell";
    CDPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (nil == cell) {
        cell = [[CDPostTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
//        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
//        cell.textLabel.numberOfLines = 0;
//        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0f];
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.detailTextLabel.textColor = [UIColor colorWithRed:0.40f green:0.40f blue:0.40f alpha:1.00f];;
        
        cell.authorTextLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        cell.authorTextLabel.textColor = [UIColor colorWithRed:0.37f green:0.75f blue:0.51f alpha:1.00f];
        
        cell.datetimeTextLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.datetimeTextLabel.textColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f];
    }
    
    CDPost *post = [_statuses objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = post.content;
    cell.authorTextLabel.text = post.author_name;
    NSLog(@"author:%@, %@", post.author_name, post.create_time_at);
    
    cell.datetimeTextLabel.text = post.create_time_at;
    
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:post.user.mini_avatar] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    if (post.small_pic.length > 0) {
        [cell.imageView setImageWithURL:[NSURL URLWithString:post.small_pic] placeholderImage:[UIImage imageNamed:@"thumb_placeholder"]];
        cell.imageView.tag = 1;
        cell.textLabel.text = nil;
    }
    else {
        cell.textLabel.text = post.title;    
        cell.imageView.image = nil;
        cell.imageView.tag = 0;
    }
        
    post = nil;
    
    return cell;
    
}



#pragma mark - Table view delegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDPost *post = [_statuses objectAtIndex:indexPath.row];
    
    CGFloat cellPadding = 12.0f;
    CGFloat contentWidth = self.view.frame.size.width - cellPadding*2;
    UIFont *titleFont = [UIFont systemFontOfSize:16.0f];
    CGSize titleLabelSize = [post.title sizeWithFont:titleFont
                                            constrainedToSize:CGSizeMake(contentWidth, 9999.0)
                                                lineBreakMode:UILineBreakModeWordWrap];

    UIFont *detailFont = [UIFont systemFontOfSize:16.0f];
    CGSize detailLabelSize = [post.content sizeWithFont:detailFont
                                   constrainedToSize:CGSizeMake(contentWidth, 9999.0)
                                       lineBreakMode:UILineBreakModeWordWrap];

    CGFloat cellHeight = cellPadding + 24.0f + cellPadding + detailLabelSize.height + cellPadding;
    if (post.small_pic.length > 0)
        cellHeight += 150.0f + cellPadding;
    else
        cellHeight +=  titleLabelSize.height + cellPadding;
    
    return cellHeight;
}









- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDPost *post = [_statuses objectAtIndex:indexPath.row];
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[post.post_id stringValue], @"post_id", nil];
    
    [objectManager.HTTPClient putPath:@"/post/up" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"response: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

- (void)tableView2:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CDPost *post = [_statuses objectAtIndex:indexPath.row];
    
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[post.post_id stringValue], @"post_id",
                            @"非常搞笑", @"content", nil];
    
    [objectManager postObject:nil path:@"/comment/create" parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"%@\n%@", operation, error);
    }];
}



- (void)loadTimeline
{
    // Load the object model via RestKit
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"channel_id", nil];
    
    [objectManager getObjectsAtPath:@"/post/timeline"
                         parameters:params
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                NSLog(@"Loaded statuses: %@", mappingResult);
                                NSArray* statuses = [mappingResult array];
                                _statuses = statuses;
                                if(self.isViewLoaded)
                                    [self.tableView reloadData];
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                message:[error localizedDescription]
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil];
                                [alert show];
                                
                                NSLog(@"Hit error: %d, %@, %@, %@", [error code], [error localizedFailureReason], [error localizedRecoveryOptions], [error localizedRecoverySuggestion]);
                            }];
}

- (void) loadFirstPostComments
{
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
 
    CDPost *post = [_statuses objectAtIndex:0];
    NSNumber *postID = post.post_id;
    NSString *path = [NSString stringWithFormat:@"/comment/show/%@", postID];
    NSLog(@"post id %@", path);
    [objectManager getObjectsAtPath:path
                         parameters:nil
                            success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                NSArray* statuses = [mappingResult array];
                                NSLog(@"Loaded statuses: %@", statuses);
                            }
                            failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                message:[error localizedDescription]
                                                                               delegate:nil
                                                                      cancelButtonTitle:@"OK"
                                                                      otherButtonTitles:nil];
                                [alert show];
                                NSLog(@"Hit error: %d, %@", [error code], [error localizedDescription]);
                            }];
}

@end
