//
//  RecordModel.h
//  SDD
//
//  Created by mac on 15/12/16.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordModel : NSObject

@property (retain,nonatomic)NSString * content;
@property (retain,nonatomic)NSNumber * logId;
@property (retain,nonatomic)NSNumber * logTime;
@property (retain,nonatomic)NSNumber * score;
@property (retain,nonatomic)NSString * title;
@property (retain,nonatomic)NSNumber * type;
@property (retain,nonatomic)NSNumber * userId;

@end
