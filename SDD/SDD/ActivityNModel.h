//
//  ActivityNModel.h
//  SDD
//
//  Created by mac on 15/12/31.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityNModel : NSObject

@property (nonatomic,retain)NSNumber * activityId;
@property (nonatomic,retain)NSString * title;
@property (nonatomic,retain)NSString * icon;
@property (nonatomic,retain)NSNumber * time;
@property (nonatomic,retain)NSString * timeString;
@property (nonatomic,retain)NSString * address;
@property (nonatomic,retain)NSString * addressShort;
@property (nonatomic,retain)NSString * summary;
@property (nonatomic,retain)NSNumber * signupTime;
@property (nonatomic,retain)NSNumber * isSignup;
@property (nonatomic,retain)NSNumber * isSponsor;
@property (nonatomic,retain)NSNumber * type;
@property (nonatomic,retain)NSNumber * addTime;

+(instancetype)ActivityDict:(NSDictionary *)dict;

@end
