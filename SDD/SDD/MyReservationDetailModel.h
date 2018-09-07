//
//  MyReservationDetailModel.h
//  SDD
//
//  Created by hua on 15/7/31.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyReservationDetailModel : NSObject

//
@property (nonatomic, assign) NSInteger houseAppointmentVisitId;
//
@property (nonatomic, strong) NSString *appointmentAreaName;
//
@property (nonatomic, assign) NSInteger addTime;
//
@property (nonatomic, strong) NSString *appointmentNumber;
//
@property (nonatomic, assign) NSInteger appointmentAreaId;
//
@property (nonatomic, strong) NSString *brandName;
//
@property (nonatomic, assign) NSInteger appointmentVisitTime;
//
@property (nonatomic, strong) NSString *company;
//
@property (nonatomic, strong) NSString *area;
//
@property (nonatomic, strong) NSString *deptName;
//
@property (nonatomic, assign) NSInteger floor;
//
@property (nonatomic, strong) NSString *floorName;
//
@property (nonatomic, strong) NSString *houseName;
//
@property (nonatomic, assign) NSInteger houseId;
//
@property (nonatomic, strong) NSString *industryCategoryName;
//
@property (nonatomic, assign) NSInteger isVisited;
//
@property (nonatomic, strong) NSString *phone;
//
@property (nonatomic, assign) NSInteger industryCategoryId;
//
@property (nonatomic, strong) NSString *postCategoryName;
//
@property (nonatomic, assign) NSInteger postCategoryId;
//
@property (nonatomic, strong) NSString *realName;
//
@property (nonatomic, assign) NSInteger userId;
//
@property (nonatomic, strong) NSArray *userIndustryCategoryId;
//
@property (nonatomic, assign) NSInteger visitedTime;
//
@property (nonatomic, strong) NSString *userIndustryCategoryName;
//
@property (nonatomic, assign) NSInteger code;

//
@property (nonatomic, assign) NSInteger rentPrice;

//
@property (nonatomic, strong) NSString *rentPreferentialContent;

@property (nonatomic, assign) NSInteger status;
//
@property (nonatomic, assign) NSInteger paySuccessTime;
//
@property (nonatomic, assign) NSInteger signSuccessTime;
@end
