//
//  ActivityModel.h
//  SDD
//
//  Created by mac on 15/8/28.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityModel : NSObject

@property (retain,nonatomic)NSString * address;
@property (retain,nonatomic)NSString *custom;
@property (retain,nonatomic)NSString *defaultImage;
@property (retain,nonatomic)NSString *guests;
@property (retain,nonatomic)NSNumber *id;
@property (retain,nonatomic)NSNumber *time;
@property (retain,nonatomic)NSString *title;
@property (retain,nonatomic)NSNumber *type;

@property (retain,nonatomic)NSNumber *addTime;
@property (retain,nonatomic)NSArray *brandList;
@property (retain,nonatomic)NSString *forumsAddress;
@property (retain,nonatomic)NSString *forumsDetail;
@property (retain,nonatomic)NSNumber *forumsId;
@property (retain,nonatomic)NSNumber *forumsTime;
@property (retain,nonatomic)NSArray *guestsList;
@property (retain,nonatomic)NSString *icon;
@property (retain,nonatomic)NSNumber *isDelete;
@property (retain,nonatomic)NSString *meetingProcess;
@property (retain,nonatomic)NSString *organizers;
@property (retain,nonatomic)NSNumber *peopleQty;
@property (retain,nonatomic)NSString *realName;
@property (retain,nonatomic)NSNumber *signupAmount;
@property (retain,nonatomic)NSNumber *sort;
@property (retain,nonatomic)NSString *summary;
@property (retain,nonatomic)NSNumber *userId;



@end
