//
//  LPYModelTool.h
//  MyDaMai
//
//  Created by qf on 15-5-28.
//  Copyright (c) 2015年 qq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPYModelTool : NSObject

//代码创建model类
+(void)createModelWithDictionary:(NSDictionary *)dict modelName:(NSString *)modelName;
@end
