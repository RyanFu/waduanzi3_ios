//
//  AMFontSizePickerValueParser.m
//  AutoMobile
//
//  Created by HiveHicks on 11.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PostFontPickerValueParser.h"

@interface PostFontPickerValueParser ()
{
    NSDictionary *_valuesMap;
}
@end


@implementation PostFontPickerValueParser

@synthesize stringValues = _stringValues;

- (id)init
{
    if (self = [super init]) {
        _valuesMap = [NSDictionary dictionaryWithObjectsAndKeys:
                      @"小", [NSNumber numberWithInteger:CDPostContentFontSizeSmall],
                      @"中", [NSNumber numberWithInteger:CDPostContentFontSizeNormal],
                      @"大", [NSNumber numberWithInteger:CDPostContentFontSizeBig],
                      @"大大", [NSNumber numberWithInteger:CDPostContentFontSizeBigBig], nil];
    }
    
    return self;
}

- (NSArray *)stringValues
{
    return @[@"小", @"中", @"大", @"大大"];
}

- (id)objectFromComponentsValues:(NSArray *)componentsValues
{
    NSString *stringFontSize = [componentsValues objectAtIndex:0];
    for (NSNumber *calendarUnitWrapper in _valuesMap) {
        if ([[_valuesMap objectForKey:calendarUnitWrapper] isEqualToString:stringFontSize]) {
            return calendarUnitWrapper;
        }
    }
    return nil;
}

- (NSArray *)componentsValuesFromObject:(id)object
{
    return [NSArray arrayWithObject:[_valuesMap objectForKey:object]];
}

- (NSString *)presentationOfObject:(id)object
{
    return [_valuesMap objectForKey:object];
}

@end
