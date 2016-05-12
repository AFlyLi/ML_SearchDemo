//
//  Utils.m
//  QuickCure
//
//  Created by 马文星 on 16/4/25.
//  Copyright © 2016年 Demos. All rights reserved.
//

#import "Utils.h"

@implementation Utils


+ (NSString *)getPinyinWithString:(NSString *)string
{
    NSString *pinyin;
    if ([string length]) {
        NSMutableString *ms = [[NSMutableString alloc] initWithString:string];
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
            
        }
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
            
        }
        pinyin = ms;
    }
    return pinyin;
}

+ (NSString *)getFirstLetterWithString:(NSString *)string
{
    NSString *regex = @"^[a-zA-Z]*$";
    NSString *firstLetter = [string substringToIndex:1];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([predicate evaluateWithObject:firstLetter] == YES) {
        return [firstLetter uppercaseString];
    }else {
        return @"~";
    }
}


@end
