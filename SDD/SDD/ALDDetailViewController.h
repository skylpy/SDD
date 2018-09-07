//
//  ALDDetailViewController.h
//  商多多
//  团购、团租、房源 - 业态平面图详情
//  Created by hua on 15/4/9.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALDDetailViewController : XHBaseViewController

// 标题
@property (nonatomic, strong) NSString *theTitle;
// id
@property (nonatomic, assign) NSInteger buildingId;

@property (nonatomic, assign) BOOL canAppointment;    /**< 可否预约 */

@property (nonatomic, assign) BOOL isOfficial;    /**< 是否正式预约 */
@end
