//
//  JoinMapModel.h
//  SDD
//
//  Created by hua on 15/6/26.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JoinMapModel : NSObject

@property (nonatomic, copy) NSString *brandId;
@property (nonatomic, copy) NSString *brandQty;
@property (nonatomic, copy) NSString *brandStoreRegionId;
@property (nonatomic, copy) NSString *headChar;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *regionId;
@property (nonatomic, copy) NSString *regionName;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *storesName;

+ (instancetype)joinMapWithDict:(NSDictionary *)dict;

@end
