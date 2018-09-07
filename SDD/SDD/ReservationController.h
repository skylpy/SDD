//
//  ReservationController.h
//  SDD
//  预约
//  Created by Cola on 15/4/12.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReservationController : XHBaseViewController

@property (nonatomic, strong) NSString *houseName;      // 考察团名

@property (nonatomic, retain) NSString *houseID;

@property (nonatomic, assign) NSInteger activityCategoryId;

@property (nonatomic, assign) BOOL isOfficial;    /**< 是否正式预约 */

@end
