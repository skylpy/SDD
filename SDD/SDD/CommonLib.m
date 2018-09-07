//
//  CommonLib.m
//  SDD
//
//  Created by mac on 15/11/6.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "CommonLib.h"

@implementation CommonLib

+ (void)runBlockAfterDelay:(double)delay block:(void (^)(void))block {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (block) {
            block();
        }
    });
}

@end
