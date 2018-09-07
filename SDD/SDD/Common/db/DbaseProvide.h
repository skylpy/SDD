//
//  DbaseProvide.h
//  SDD
//
//  Created by Cola on 15/4/25.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DbaseProvide : NSObject

-(void) initDbaseProvide;
//插入数据
-(void) insert:(NSString *) table fields: (NSArray *) fields values:(NSArray *) values;
//查询表数据
-(NSMutableArray *) query:(NSString *) table condition:(NSString *) where;

@end
