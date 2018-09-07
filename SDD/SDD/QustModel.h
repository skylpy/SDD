//
//  QustModel.h
//  SDD
//
//  Created by mac on 15/10/23.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QustModel : NSObject

@property (retain,nonatomic)NSNumber * addTime;
@property (retain,nonatomic)NSNumber * isDelete;
@property (retain,nonatomic)NSArray * options;
@property (retain,nonatomic)NSString * question;
@property (retain,nonatomic)NSNumber *questionnaireId;
@property (retain,nonatomic)NSNumber *sort;
@property (retain,nonatomic)NSNumber *type;
@property (retain,nonatomic)NSNumber *userId;

@end
