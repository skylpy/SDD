//
//  NewAppointViewController.h
//  SDD
//
//  Created by mac on 15/11/5.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBaseViewController.h"

@interface NewAppointViewController : XHBaseViewController

@property (nonatomic, strong) NSString *houseName;      // 考察团名

@property (nonatomic, retain) NSString *houseID;

@property (nonatomic, assign) NSInteger activityCategoryId;

@property (nonatomic, assign) BOOL isOfficial;    /**< 是否正式预约 */

@end
