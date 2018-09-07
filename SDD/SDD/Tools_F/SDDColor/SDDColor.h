//
//  SDDColor.h
//  SDD
//
//  Created by mac on 15/5/12.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDDColor : NSObject

+ (UIColor *)sddRedColor;
+ (UIColor *)sddbackgroundColor;
+ (UIColor *)sddSmallTextColor;
+ (UIColor *)sddOrangeColor;
+ (UIColor *)sddLineColor;

+ (UIColor *)sddMiddleTextColor;
+ (UIColor *)sddBigTextColor;

+ (UIColor *)colorWithHexString: (NSString *)color;
@end
