//
//  RegionModel.h
//  SDD
//
//  Created by hua on 15/4/25.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegionModel : NSObject

// 头char
@property (nonatomic, copy) NSString *r_headChar;
// 房屋数量
@property (nonatomic, copy) NSString *r_houseQty;
// 地区父id
@property (nonatomic, copy) NSString *r_parentId;
// 地区id
@property (nonatomic, copy) NSString *r_regionId;
// 地区名
@property (nonatomic, copy) NSString *r_regionName;
// 地区类型
@property (nonatomic, copy) NSString *r_type;

@end
