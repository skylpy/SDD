//
//  NSString+SDD.m
//  SDD
//
//  Created by mac on 15/5/25.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "NSString+SDD.h"

@implementation NSString (SDD)

+ (NSString *)stringWithCurrentString:(NSString *)currentString SizeWidth:(int)sizeWidth{

    NSString *str = currentString;
    NSArray *arr = [str componentsSeparatedByString:@"/"];
    NSString *stra = @"";
    for (int i =0; i<arr.count; i++) {
        stra = i == arr.count-1?[stra stringByAppendingString:[NSString stringWithFormat:@"%d_%d_%@",sizeWidth,sizeWidth,arr[i]]]:[stra stringByAppendingString:[NSString stringWithFormat:@"%@/",arr[i]]];
    }
  
    return stra;
}

+ (NSString *)getRidOfEnter:(NSString *)string{
    
    string = [string stringByReplacingOccurrencesOfString: @"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString: @"\n" withString:@""];
    
    return string;
}

@end
