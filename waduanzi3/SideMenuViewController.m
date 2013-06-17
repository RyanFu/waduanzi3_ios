//
//  SideMenuViewController.m
//  waduanzi3
//
//  Created by chendong on 13-3-4.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "CDDefine.h"
#import "SideMenuViewController.h"
#import "IIViewDeckController.h"
#import "TimelineViewController.h"
#import "MediaTypeViewController.h"

@interface SideMenuViewController ()

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.scrollsToTop = NO;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"menu_table_bg.png"]stretchableImageWithLeftCapWidth:2.0 topCapHeight:2.0f]];
    bgView.contentMode = UIViewContentModeScaleToFill;
    bgView.frame = self.tableView.frame;
    self.tableView.backgroundView = bgView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
            
            switch (indexPath.row) {
                case 0:
                    if (timelineViewController == nil)
                        timelineViewController = [[TimelineViewController alloc] init];
                    centerViewController = [[UINavigationController alloc] initWithRootViewController:timelineViewController];
                    self.viewDeckController.centerController = centerViewController;
                    break;
                    
                default:
                    break;
            }
        }
        else if (indexPath.section == 1) {
            static MediaTypeViewController *textJokeViewController;
            static MediaTypeViewController *imageJokeViewController;
            
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
    }];
    
}
@end
