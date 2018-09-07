//
//  NSString+SDD.h
//  SDD
//
//  Created by mac on 15/5/25.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SDD)

// 修改url，取特定size的图片
+ (NSString *)stringWithCurrentString:(NSString *)currentString SizeWidth:(int)sizeWidth;
// 去除字符串的回车
+ (NSString *)getRidOfEnter:(NSString *)string;

@end
