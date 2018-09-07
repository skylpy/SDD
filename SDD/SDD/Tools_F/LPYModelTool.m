//
//  LPYModelTool.m
//  MyDaMai
//
//  Created by qf on 15-5-28.
//  Copyright (c) 2015年 qq. All rights reserved.
//

#import "LPYModelTool.h"

@implementation LPYModelTool

+(void)createModelWithDictionary:(NSDictionary *)dict modelName:(NSString *)modelName
{
    printf("\n@interface %s :NSObject\n",modelName.UTF8String);
    for (NSString * key in dict) {
        NSString *type = ([dict[key] isKindOfClass:[NSNumber class]])?@"NSNumber":@"NSString";
        printf("@property (nonatomic,copy) %s *%s;\n",type.UTF8String,key.UTF8String);
    }
    printf("@end\n");
    
}

@end
