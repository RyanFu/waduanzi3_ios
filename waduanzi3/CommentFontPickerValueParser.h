//
//  AMPeriodPickerValueParser.h
//  AutoMobile
//
//  Created by HiveHicks on 11.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QPickerValueParser.h"

@interface CommentFontPickerValueParser : NSObject <QPickerValueParser>

@property (nonatomic, readonly) NSArray *stringValues;

@end
