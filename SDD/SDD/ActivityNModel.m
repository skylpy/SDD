//
//  ActivityNModel.m
//  SDD
//
//  Created by mac on 15/12/31.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ActivityNModel.h"

@implementation ActivityNModel

+(instancetype)ActivityDict:(NSDictionary *)dict{

    ActivityNModel * model = [[self alloc] init];
    
    model.activityId = dict[@"activityId"];
    model.title = dict[@"title"];
    model.icon = dict[@"icon"];
    model.time = dict[@"time"];
    model.timeString = dict[@"timeString"];
    model.address = dict[@"address"];
    model.addressShort = dict[@"addressShort"];
    model.summary = dict[@"summary"];
    model.signupTime = dict[@"signupTime"];
    model.isSignup = dict[@"isSignup"];
    model.isSponsor = dict[@"isSponsor"];
    model.type = dict[@"type"];
    model.addTime = dict[@"addTime"];

    
    return model;
}

@end
