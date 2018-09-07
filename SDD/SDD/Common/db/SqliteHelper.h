//
//  SqliteHelper.h
//  SDD
//
//  Created by Cola on 15/4/25.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h> 

@interface SqliteHelper : NSObject
-(void) SqliteHelper;
-(sqlite3 *) getSqlite;
@end
