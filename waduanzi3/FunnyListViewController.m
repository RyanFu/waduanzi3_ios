//
//  FunnyListViewController.m
//  waduanzi3
//
//  Created by chendong on 13-10-21.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "UIScrollView+SVPullToRefresh.h"
#import "FunnyListViewController.h"
#import "CDDataCache.h"

@interface FunnyListViewController ()

@end

@implementation FunnyListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:@[@"文字", @"图片", @"视频"]];
    control.segmentedControlStyle = UISegmentedControlStyleBar;
    control.frame = CGRectMake(0, 0, 150, 28);
    [control addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = control;
    
    if (OS_VERSION_LESS_THAN(@"7.0"))
        control.tintColor = [UIColor colorWithRed:0.44f green:0.53f blue:0.71f alpha:1.00f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segmentedControlValueChanged:(id)sender
{
    UISegmentedControl *control = (UISegmentedControl *)sender;
    CDLog(@"control.index: %d", control.selectedSegmentIndex);

    switch (control.selectedSegmentIndex) {
        case 0:
            _mediaType = MEDIA_TYPE_TEXT;
            break;
        case 1:
            _mediaType = MEDIA_TYPE_IMAGE;
            break;
        case 2:
            _mediaType = MEDIA_TYPE_VIDEO;
            break;
        default:
            _mediaType = MEDIA_TYPE_MIXED;
            break;
    }
    
    _statuses = [self fetchCachePostsWithMediaType:_mediaType];
    
    if (_statuses.count == 0) {
        [self refreshLatestPosts];
    }
    else
        [self.tableView reloadData];
}

- (NSMutableArray *) fetchCachePostsWithMediaType:(CD_MEDIA_TYPE)media_type
{
    [NSException raise:@"Invoked abstract method" format:@"Invoked abstract method"];
    return nil;
}

@end
