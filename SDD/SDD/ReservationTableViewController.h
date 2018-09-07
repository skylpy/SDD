//
//  ReservationTableViewController.h
//  SDD
//  旧预约清单
//  Created by hua on 15/7/29.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReservationTableViewController : UIViewController


typedef NS_ENUM(NSInteger, ReservationStep)
{
    firstStep = 0,
    secondStep = 1,
    lastStep = 2
};

@property (nonatomic, assign) ReservationStep theStep;

@property (nonatomic, assign) NSInteger houseAppointmentVisitId;

@property (nonatomic, assign) BOOL isFromPersonal;

@end
