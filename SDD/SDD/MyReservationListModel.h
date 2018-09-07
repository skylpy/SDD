//
//  MyReservationListModel.h
//  SDD
//
//  Created by hua on 15/7/31.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyReservationListModel : NSObject

@property (assign,nonatomic) NSInteger isVisited;

@property (assign,nonatomic) NSInteger appointmentVisitTime;

@property (assign,nonatomic) NSInteger area;

@property (nonatomic,retain) NSString *appointmentAreaName;
//
@property (nonatomic, assign) NSInteger houseId;
//
@property (nonatomic, strong) NSString *houseName;
//
@property (nonatomic, strong) NSString *defaultImage;
//
@property (nonatomic, assign) NSInteger price;
//
@property (nonatomic, assign) NSInteger buyPrice;
//
@property (nonatomic, assign) NSInteger rentPrice;
//
@property (nonatomic, assign) NSInteger buyPreferentialEndtime;
//
@property (nonatomic, assign) NSInteger rentPreferentialEndtime;
//
@property (nonatomic, strong) NSString *buyPreferentialContent;
//
@property (nonatomic, strong) NSString *rentPreferentialContent;
//
@property (nonatomic, assign) float latitude;
//
@property (nonatomic, assign) float longitude;
//
@property (nonatomic, strong) NSString *tel;
//
@property (nonatomic, strong) NSString *planFormat;
//
@property (nonatomic, assign) NSInteger merchantsStatus;
//
@property (nonatomic, assign) NSInteger buildingArea;
//
@property (nonatomic, assign) NSInteger houseAppointmentVisitId;
//
@property (nonatomic, assign) NSInteger activityCategoryId;



@property (nonatomic,retain) NSString *appointmentNumber;

@property (nonatomic,retain) NSString *floorName;

@property (nonatomic,assign) NSInteger floor;

@property (nonatomic,copy) NSString *industryCategoryName;

@property (nonatomic,assign) NSInteger openedTime;

@property (nonatomic,assign) NSInteger appointmentAreaId;

@property (nonatomic,assign) NSInteger industryCategoryId;

@property (nonatomic,assign) NSInteger addTime;

@property (nonatomic,assign) NSInteger visitedTime;

@property (nonatomic,copy) NSString *address;

@property (nonatomic,assign) NSInteger type;
@property (nonatomic,assign) NSInteger status;

@end
