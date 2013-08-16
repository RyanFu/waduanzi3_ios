//
//  WBErrorNoticeView+WaduanziMethod.h
//  waduanzi3
//
//  Created by chendong on 13-7-29.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "WBErrorNoticeView.h"

@interface WBErrorNoticeView (WaduanziMethod)

+ (WBErrorNoticeView *) showErrorNoticeView:(UIView *)view title:(NSString *)title message:(NSString *)message sticky:(BOOL)sticky delay:(NSTimeInterval)delay dismissedBlock:(void (^) (BOOL dismissedInteractively))dismissedblock;
@end
