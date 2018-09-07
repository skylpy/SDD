//
//  CPResultsModel.m
//  SDD
//
//  Created by mac on 15/5/13.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "CPResultsModel.h"

@implementation CPResultsModel

- (id)initWithCPResultsDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        
        NSString *startTime = dict[@"buildingStartTime"];
        self.buildingStartTime = [self dateString:startTime];
        
        self.avgPrice = dict[@"avgPrice"];
        self.firstPay = dict[@"firstPay"];
        self.totalPrice = dict[@"totalPrice"];
        self.monthPay = dict[@"monthPay"];
        self.regionName = dict[@"regionName"];
        self.foreYear = dict[@"foreYear"];
        self.foreMonth = dict[@"foreMonth"];
        
    }
    return self;
}

- (NSString *)dateString:(NSString *)tmpDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM"];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[tmpDate intValue]];
    NSString *dateStr = [df stringFromDate:date];
    
    return dateStr;
}

@end
