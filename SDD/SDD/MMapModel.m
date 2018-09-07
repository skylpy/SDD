//
//  MMapModel.m
//  SDD
//
//  Created by mac on 15/5/12.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "MMapModel.h"

@implementation MMapModel

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        
        NSString *numStr = [NSString stringWithFormat:@"%@",dict[@"countiesId"]];
        self.countiesID = numStr.intValue;
        NSString *numStr2 = [NSString stringWithFormat:@"%@",dict[@"qty"]];
        self.qty = numStr2.intValue;
        self.countiesName = [NSString stringWithFormat:@"%@",dict[@"countiesName"]];        
        self.latitude = dict[@"latitude"];
        self.longitude = dict[@"longitude"];
        self.houseName = dict[@"houseName"];
        self.activityCategoryId = dict[@"activityCategoryId"];
        self.houseId = dict[@"houseId"];
    }
    
    return self;
}

@end
