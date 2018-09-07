//
//  ResourcesModel.m
//  SDD
//
//  Created by JerryHe on 15/5/14.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ResourcesModel.h"

@implementation ResourcesModel

- (id)initWithResourcesDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.defaultImage = dict[@"defaultImage"];
        self.houseId = dict[@"houseId"];
        self.houseName = dict[@"houseName"];
        self.address = dict[@"address"];
        self.price = dict[@"price"];
    }
    
    return self;
}

@end
