//
//  WBSuccessNoticeView+WaduanziMethod.h
//  waduanzi3
//
//  Created by chendong on 13-7-29.
//  Copyright (c) 2013年 chendong. All rights reserved.
//

#import "WBSuccessNoticeView.h"

@interface WBSuccessNoticeView (WaduanziMethod)

+ (void) showSuccessNoticeView:(UIView *)view title:(NSString *)title sticky:(BOOL)sticky delay:(NSTimeInterval)delay dismissedBlock:(void (^) (BOOL dismissedInteractively))dismissedblock;
@end
