//
//  HouseListModel.h
//  SDD
//
//  Created by mac on 15/5/12.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HouseListModel : NSObject

@property (nonatomic, copy) NSString *houseName;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) int houseId;

- (id)initWithHouseListDict:(NSDictionary *)dict;

@end
