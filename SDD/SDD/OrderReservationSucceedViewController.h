//
//  OrderReservationSucceedViewController.h
//  SDD
//  登记预约成功
//  Created by hua on 15/9/9.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "XHBaseViewController.h"

@interface OrderReservationSucceedViewController : XHBaseViewController

@property (nonatomic, strong) NSString *houseName;      // 考察团名
@property (nonatomic, assign) NSString *houseId;

@property (nonatomic, assign) BOOL isOfficial;    /**< 是否正式预约 */

@end
