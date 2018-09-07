//
//  SDDColor.m
//  SDD
//
//  Created by mac on 15/5/12.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "SDDColor.h"

@implementation SDDColor

+ (UIColor *)sddRedColor
{
    UIColor *color = [self colorWithHexString:@"#e73820"];
    return color;
}

+ (UIColor *)sddbackgroundColor
{
    UIColor *color = [self colorWithHexString:@"#EEEEEE"];
    return color;
}

+ (UIColor *)sddSmallTextColor
{
    UIColor *color = [self colorWithHexString:@"#999999"];
    return color;
}

+ (UIColor *)sddOrangeColor
{
    UIColor *color = [self colorWithHexString:@"#fb5d06"];
    return color;
}
+ (UIColor *)sddLineColor
{
    UIColor *color = [self colorWithHexString:@"#e5e5e5"];
    return color;
}

+ (UIColor *)sddMiddleTextColor
{
    UIColor *color = [self colorWithHexString:@"#666666"];
    return color;
}
+ (UIColor *)sddBigTextColor
{
    UIColor *color = [self colorWithHexString:@"#000000"];
    return color;
}

#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *)colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    //    NSLog(@"%u,%u,%u",r, g, b);
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

@end
