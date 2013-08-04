//
//  WBSuccessNoticeView+WaduanziMethod.m
//  waduanzi3
//
//  Created by chendong on 13-7-29.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "WBSuccessNoticeView+WaduanziMethod.h"
#import "WBStickyNoticeView.h"

@implementation WBSuccessNoticeView (WaduanziMethod)

+ (void) showSuccessNoticeView:(UIView *)view title:(NSString *)title sticky:(BOOL)sticky delay:(NSTimeInterval)delay dismissedBlock:(void (^)(BOOL))dismissedblock
{
    WBSuccessNoticeView *noticeView = [WBSuccessNoticeView successNoticeInView:view title:title];
    noticeView.delay = delay;
    noticeView.alpha = 0.90f;
    noticeView.sticky = sticky;
    if (dismissedblock != nil)
        [noticeView setDismissalBlock:dismissedblock];
    [noticeView show];
}
@end
