//
//  CommonLib.h
//  SDD
//
//  Created by mac on 15/11/6.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonLib : NSString

+ (void)runBlockAfterDelay:(double)delay block:(void (^)(void))block;

@end
