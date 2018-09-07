//
//  ContactModel.m
//  SDD
//
//  Created by hua on 15/6/25.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ContactModel.h"

@implementation ContactModel

+ (instancetype)contactWithDict:(NSDictionary *)dict{
    
    ContactModel *model = [[self alloc] init];
    
    model.peopleName = dict[@"brandContacts"];
    model.peoplePosition = dict[@"jobTitle"];
    model.peopleRegion = dict[@"precinct"];
    model.peopleTel = dict[@"tel"];
    model.peopleMobileNum = dict[@"phone"];
    model.peopleEmail = dict[@"email"];
    model.peopleAddress = dict[@"address"];
    
    
    return model;
}

@end
