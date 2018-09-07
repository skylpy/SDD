//
//  MMapModel.h
//  SDD
//
//  Created by mac on 15/5/12.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMapModel : NSObject

@property (nonatomic, assign) int countiesID;
@property (nonatomic, copy) NSString *countiesName;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, assign) int qty;
@property (nonatomic, copy) NSString *houseName;
@property (nonatomic, copy) NSString *activityCategoryId;
@property (nonatomic, copy) NSString *houseId;

- (id)initWithDict:(NSDictionary *)dict;

@end
