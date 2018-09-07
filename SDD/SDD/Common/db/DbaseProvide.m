//
//  DbaseProvide.m
//  SDD
//  数据库封装工具
//  Created by Cola on 15/4/25.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "DbaseProvide.h"
#import "SqliteHelper.h"

@interface DbaseProvide()
@property(nonatomic,strong) SqliteHelper *sqlite;
@end

@implementation DbaseProvide
- (void) initDbaseProvide
{
    _sqlite = [SqliteHelper alloc];
    [_sqlite SqliteHelper];
}

-(void) insert:(NSString *) table fields: (NSArray *) fields values:(NSArray *) values
{
    NSString * tmp = @"INSERT INTO ";
    tmp = [tmp stringByAppendingString:table];
    tmp = [tmp stringByAppendingString:@" ("];
    
    int len = [fields count];
    for (int n = 0; n < len; n++) {
        tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"%@,",fields[n]]];
    }
    
    tmp = [tmp substringToIndex:tmp.length - 1];
    tmp = [tmp stringByAppendingString:@") VALUES ("];
    
    [tmp substringToIndex:tmp.length - 1];
    len = [values count];
    for (int n = 0; n < len; n++) {
        tmp = [tmp stringByAppendingString:[NSString stringWithFormat:@"%@,",values[n]]];
    }
    
    tmp = [tmp substringToIndex:tmp.length - 1];
    tmp = [tmp stringByAppendingString:@")"];
    NSLog(@"inser%@",tmp);
//    NSString *sql=[NSString stringWithFormat:@"INSERT INTO t_students (name,age) VALUES ('%@',%d);",name,age];
}

-(NSMutableArray *) query:(NSString *) table condition:(NSString *) where{
    
    return nil;
}
@end
