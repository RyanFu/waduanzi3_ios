//
//  WBErrorNoticeView+WaduanziMethod.m
//  waduanzi3
//
//  Created by chendong on 13-7-29.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "WBErrorNoticeView+WaduanziMethod.h"

@implementation WBErrorNoticeView (WaduanziMethod)

+ (WBErrorNoticeView *) showErrorNoticeView:(UIView *)view title:(NSString *)title message:(NSString *)message sticky:(BOOL)sticky delay:(NSTimeInterval)delay dismissedBlock:(void (^)(BOOL))dismissedblock
{
    WBErrorNoticeView *noticeView = [WBErrorNoticeView errorNoticeInView:view title:title message:message];
    noticeView.delay = delay;
    noticeView.alpha = 0.90f;
    noticeView.sticky = sticky;
    if (dismissedblock != nil)
        [noticeView setDismissalBlock:dismissedblock];
    [noticeView show];
    
    return noticeView;
}
@end
