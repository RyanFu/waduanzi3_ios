//
//  FunnyListViewController.m
//  waduanzi3
//
//  Created by chendong on 13-10-21.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "FunnyListViewController.h"

@interface FunnyListViewController ()

@end

@implementation FunnyListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:@[@"文字", @"图片", @"视频"]];
    control.frame = CGRectMake(0, 0, 150, 28);
    control.selectedSegmentIndex = 0;
    [control addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = control;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segmentedControlValueChanged:(id)sender
{
    UISegmentedControl *control = (UISegmentedControl *)sender;
    NSLog(@"selected index: %d", control.selectedSegmentIndex);
}

@end
