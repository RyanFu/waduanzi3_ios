//
//  LeftViewController.m
//  waduanzi3
//
//  Created by chendong on 13-7-10.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CDDefine.h"
#import "LeftViewController.h"
#import "MGScrollView.h"
#import "MGBox.h"
#import "MGLineStyled.h"
#import "MGTableBoxStyled.h"

#define PHOTO
#define GRID_CELL_SIZE (CGSize){170, 180}

@interface LeftViewController () {
    MGBox *photoGrid, *tableGrid;
    MGTableBox  *menuTable;
}
@end


@implementation LeftViewController

@synthesize scroller = _scroller;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGRect scrollerFrame = self.view.bounds;
    scrollerFrame.size.width -= DECK_LEFT_SIZE;
    self.scroller = [[MGScrollView alloc] initWithFrame:scrollerFrame];
    [self.view addSubview:_scroller];
    
    
    photoGrid = [MGBox boxWithSize:CGSizeMake(_scroller.size.width, 0)];
    photoGrid.contentLayoutMode = MGLayoutGridStyle;
    [self.scroller.boxes addObject:photoGrid];
    
    tableGrid = [MGBox boxWithSize:CGSizeMake(_scroller.size.width, 0)];
    tableGrid.contentLayoutMode = MGLayoutGridStyle;
    [self.scroller.boxes addObject:tableGrid];
    
    menuTable = [MGTableBox boxWithSize:CGSizeMake(_scroller.size.width, 0)];
    [tableGrid.boxes addObject:menuTable];
    
    CGSize menuSize = CGSizeMake(menuTable.frame.size.width, 44.0f);
    MGLine *menuFavorite = [MGLine lineWithLeft:@"我收藏的" right:@"xxx" size:menuSize];
    [menuTable.topLines addObject:menuFavorite];
    MGLine *menuPublish = [MGLine lineWithLeft:@"我发表的" right:@"xxx" size:menuSize];
    [menuTable.topLines addObject:menuPublish];
    MGLine *menuJoin = [MGLine lineWithLeft:@"我参与的" right:@"xxx" size:menuSize];
    [menuTable.topLines addObject:menuJoin];
    [menuTable layout];
    
    [tableGrid layout];
    [_scroller layout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
