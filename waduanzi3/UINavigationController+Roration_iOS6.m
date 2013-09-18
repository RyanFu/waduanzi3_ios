//
//  UINavigationController+Roration_iOS6.m
//  waduanzi3
//
//  Created by chendong on 13-9-18.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "UINavigationController+Roration_iOS6.h"

@implementation UINavigationController (Roration_iOS6)

-(BOOL)shouldAutorotate
{
    return [[self.viewControllers lastObject] shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return [[self.viewControllers lastObject] shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

@end
