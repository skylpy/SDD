//
//  PreferentialDetailViewController.h
//  SDD
//  优惠详情
//  Created by hua on 15/8/21.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreferentialDetailViewController : XHBaseViewController

@property (nonatomic, strong) NSString *preferentialContent;
@property (nonatomic, strong) NSString *houseID;
@property (nonatomic, assign) BOOL canAppointment;          /**< 可否预约 */
@property (nonatomic, strong) NSString *houseName;      // 考察团名
@property (nonatomic, assign) BOOL isOfficial;    /**< 是否正式预约 */

@end
