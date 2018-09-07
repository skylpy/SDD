//
//  HistoryModel.h
//  SDD
//
//  Created by hua on 15/5/13.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HistoryModel : NSObject

/*- 楼盘 -*/
// 栏目id
@property (nonatomic, strong) NSString *h_activityCategoryId;
// 地址
@property (nonatomic, copy) NSString *h_address;
// 默认图片
@property (nonatomic, copy) NSString *h_defaultImage;
// 发展id
@property (nonatomic, copy) NSString *h_developersId;
// 房id
@property (nonatomic, copy) NSString *h_houseId;
// 房名
@property (nonatomic, copy) NSString *h_houseName;
// 内容
@property (nonatomic, copy) NSString *h_perferentialContent;
// 结束时间
@property (nonatomic, copy) NSString *h_preferentialEndtime;
// 价格
@property (nonatomic, copy) NSString *h_price;
// 电话
@property (nonatomic, copy) NSString *h_tel;
// 纬度
@property (nonatomic, copy) NSString *h_latitude;
// 经度
@property (nonatomic, copy) NSString *h_longitude;
// 地区
@property (nonatomic, copy) NSString *h_regionName;

/*- 活动 -*/

// 活动id
@property (nonatomic, strong) NSString *h_activityId;
// 图片
@property (nonatomic, strong) NSString *h_icon;
// 标题
@property (nonatomic, strong) NSString *h_title;
// 摘要
@property (nonatomic, strong) NSString *h_summary;
// 发布时间
@property (nonatomic, strong) NSString *h_publishTime;
// 活动图片
@property (nonatomic, strong) NSString *h_activityImage;
// 活动详情
@property (nonatomic, strong) NSString *h_activityDetail;
// 活动时间
@property (nonatomic, strong) NSString *h_activityTime;
// 活动地址
@property (nonatomic, strong) NSString *h_activityAddress;
// 活动对象
@property (nonatomic, strong) NSString *h_activityObject;
// 人数
@property (nonatomic, strong) NSString *h_peopleAmount;
// 备注
@property (nonatomic, strong) NSString *h_remark;
//
@property (nonatomic, strong) NSString *h_projectId;
// 参加人数
@property (nonatomic, strong) NSString *h_signupAmount;
//
@property (nonatomic, strong) NSString *h_browseLogId;
//
@property (nonatomic, strong) NSString *h_objectId;
//
@property (nonatomic, strong) NSString *h_type;
// 截止时间
@property (nonatomic, strong) NSString *h_lastTime;
//
@property (nonatomic, strong) NSString *h_userId;
// 
@property (nonatomic, strong) NSString *h_browseQty;
// url
@property (nonatomic, strong) NSString *h_url;

/*- 评价管理 -*/

// 平均分
@property (nonatomic, strong) NSString *h_avgScore;

@end
