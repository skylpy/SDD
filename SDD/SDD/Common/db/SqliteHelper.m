//
//  SqliteHelper.m
//  SDD
//  数据库工具
//  Created by Cola on 15/4/25.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "SqliteHelper.h"
#import <sqlite3.h> 
#define DBNAME @"sdd.sqlite"
#define SDDTABLE @"sdd"
@interface SqliteHelper ()
@property sqlite3 *db;
@end

@implementation SqliteHelper

-(void) SqliteHelper{
    [self onCreate];
}

-(void) onCreate{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:DBNAME];
    
    if (sqlite3_open([database_path UTF8String], &_db) != SQLITE_OK) {
        sqlite3_close(_db);
        NSLog(@"数据库打开失败");
    }
    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS ";
    sqlCreateTable = [sqlCreateTable stringByAppendingString:SDDTABLE];
    sqlCreateTable = [sqlCreateTable stringByAppendingString:@" (ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, context TEXT)"];
    [self execSql:sqlCreateTable];
}

-(void)execSql:(NSString *)sql
{
    char *err;
    if (sqlite3_exec(_db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(_db);
        NSLog(@"数据库操作数据失败!");
    }
}

//返回数据库句柄
-(sqlite3 *) getSqlite
{
    return _db;
}
@end
