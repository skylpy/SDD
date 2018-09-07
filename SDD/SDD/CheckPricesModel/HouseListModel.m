//
//  HouseListModel.m
//  SDD
//
//  Created by mac on 15/5/12.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "HouseListModel.h"

@implementation HouseListModel

- (id)initWithHouseListDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        NSString *intStr = [NSString stringWithFormat:@"%@",dict[@"houseId"]];
        self.houseId = intStr.intValue;
        
        self.houseName = dict[@"houseName"];
        self.address   = dict[@"address"];
    }

    return self;
}

@end
