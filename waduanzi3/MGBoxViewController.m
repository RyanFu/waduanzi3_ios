//
//  MGBoxViewController.m
//  waduanzi3
//
//  Created by chendong on 13-6-30.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "MGBoxViewController.h"
#import "MGScrollView.h"
#import "MGTableBoxStyled.h"
#import "MGLineStyled.h"
#import "MGLayoutBox.h"

#define HEADER_FONT     [UIFont fontWithName:@"HelveticaNeue" size:18]

@interface MGBoxViewController ()
{
    UIImage *_arrow;
}

@end

@implementation MGBoxViewController

@synthesize scroller = _scroller;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    _arrow = [UIImage imageNamed:@"accessory_arrow"];
    
    self.scroller = [MGScrollView scrollerWithSize:self.view.bounds.size];
    [self.view addSubview:_scroller];
    
    MGTableBoxStyled *tableBox = [MGTableBoxStyled box];
    tableBox.borderStyle = MGBorderEtchedAll;
    [_scroller.boxes addObject:tableBox];
    
    CGSize rowSize = (CGSize){304, 40};
    MGLineStyled *header = [MGLineStyled lineWithLeft:@"My First Table" right:_arrow size:rowSize];
    header.font = HEADER_FONT;;
    __weak MGLineStyled *wheader = header;
    header.onTap = ^{
        wheader.backgroundColor = [UIColor lightGrayColor];
        [self.view trigger:@"touch"];
        self.view.height -= 100.0f;
    };
    [tableBox.topLines addObject:header];

    MGLineStyled *row1 = [MGLineStyled lineWithLeft:@"Left Middle Right" right:_arrow size:rowSize];
    row1.multilineLeft = @"left multiline";
    row1.multilineMiddle = @"middle";
    row1.multilineRight = @"right";
    [tableBox.topLines addObject:row1];
    
    MGLineStyled *row2 = [MGLineStyled lineWithLeft:@"middle test" right:_arrow size:rowSize];
    [tableBox.middleLines addObject:row2];

    MGLineStyled *row3 = [MGLineStyled lineWithLeft:@"top test" right:_arrow size:rowSize];
    row3.borderStyle = MGBorderEtchedAll;
    [tableBox.topLines addObject:row3];
    
    [_scroller layoutWithSpeed:0.5 completion:nil];
    
    [self.view on:@"touch" do:^{
        NSLog(@"self.view touched");
    }];
}



@end
