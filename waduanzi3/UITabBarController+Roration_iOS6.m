//
//  UITabBarController+Roration_iOS6.m
//  waduanzi3
//
//  Created by chendong on 13-10-27.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "UITabBarController+Roration_iOS6.h"

@implementation UITabBarController (Roration_iOS6)

-(BOOL)shouldAutorotate
{
    return [self.selectedViewController shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return [self.selectedViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

@end
