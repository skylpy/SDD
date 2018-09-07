//
//  Cursor.h
//  SDD
//
//  Created by Cola on 15/4/26.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cursor : NSObject
@property (nonatomic,strong) NSString * no;
//字段名
@property (nonatomic,strong) NSString * field;
//值
@property (nonatomic,strong) NSString * value;
@end
