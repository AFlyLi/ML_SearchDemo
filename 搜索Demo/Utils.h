//
//  Utils.h
//  QuickCure
//
//  Created by 马文星 on 16/4/25.
//  Copyright © 2016年 Demos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject

/*!
 *  汉字转拼音
 */
+ (NSString *)getPinyinWithString:(NSString *)string;

/*!
 *  获取字符串首字母，如果首字母非字母，则返回"~"
 */
+ (NSString *)getFirstLetterWithString:(NSString *)string;

@end
