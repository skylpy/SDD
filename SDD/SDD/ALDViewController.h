//
//  ALDViewController.h
//  商多多
//  团购、团租、房源 - 户型图列表
//  Created by hua on 15/4/9.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALDViewController : XHBaseViewController

// 房子id
@property (nonatomic, strong) NSString *houseID;
// 图片
@property (nonatomic, strong) NSURL *imageUrl;

@property (nonatomic, assign) BOOL canAppointment;    /**< 可否预约 */

@property (nonatomic, assign) BOOL isOfficial;    /**< 是否正式预约 */

@end
