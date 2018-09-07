//
//  MyActivitiesModel.h
//  SDD
//  3活动模型
//  Created by hua on 15/8/31.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyActivitiesModel : NSObject


/* - - - - - - - 主题论坛 - - - - - - - */

@property (nonatomic, assign) NSInteger addTime;          /**< 时间 */
@property (nonatomic, strong) NSArray *brandList;         /**< 品牌列表 */
@property (nonatomic, strong) NSString *custom;           /**< 自定义 */
@property (nonatomic, strong) NSString *forumsAddress;    /**< 地址 */
@property (nonatomic, strong) NSString *forumsDetail;     /**< 详情 */
@property (nonatomic, assign) NSInteger forumsId;         /**< 活动id */
@property (nonatomic, assign) NSInteger forumsTime;       /**< 活动时间 */
@property (nonatomic, strong) NSString *guests;           /**< 嘉宾 */
@property (nonatomic, strong) NSArray *guestsList;        /**< 嘉宾列表 */
@property (nonatomic, strong) NSURL *icon;                /**< 图片url */
@property (nonatomic, assign) BOOL isDelete;              /**< 是否删除 */
@property (nonatomic, strong) NSString *meetingProcess;   /**< 流程 */
@property (nonatomic, strong) NSString *organizers;       /**< 公司 */
@property (nonatomic, assign) NSInteger peopleQty;        /**< 人数 */
@property (nonatomic, strong) NSString *realName;         /**< 真实姓名 */
@property (nonatomic, assign) NSInteger signupAmount;     /**< 注册数量 */
@property (nonatomic, strong) NSString *summary;          /**< 总结 */
@property (nonatomic, strong) NSString *title;            /**< 标题 */
@property (nonatomic, assign) NSInteger userId;           /**< id */

/* - - - - - - - 项目活动 - - - - - - - */

@property (nonatomic, assign) NSInteger activityId;       /**< 活动id */
@property (nonatomic, strong) NSString *activityAddress;  /**< 活动地址 */
@property (nonatomic, strong) NSString *activityDetail;   /**< 活动详情 */
@property (nonatomic, strong) NSURL *activityImage;       /**< 活动图片 */
@property (nonatomic, strong) NSString *activityObject;   /**< 活动对象 */
@property (nonatomic, assign) NSInteger activityTime;     /**< 活动时间 */
@property (nonatomic, strong) NSString *houseDetail;      /**< 房子详情 */
@property (nonatomic, strong) NSURL *houseImages;         /**< 房子图片 */
@property (nonatomic, assign) float houseLatitude;        /**< 纬度 */
@property (nonatomic, assign) float houseLongitude;       /**< 经度 */
@property (nonatomic, strong) NSArray *houseModels;       /**< 房子模型 */
@property (nonatomic, assign) NSInteger peopleAmount;     /**< 人数 */
@property (nonatomic, assign) NSInteger projectId;        /**< 项目id */
@property (nonatomic, strong) NSString *projectName;      /**< 项目名 */
@property (nonatomic, assign) NSInteger publishTime;      /**< 发布时间 */
@property (nonatomic, strong) NSString *remark;           /**< 备注 */
@property (nonatomic, assign) NSInteger type;             /**< 类型 */

/* - - - - - - - 项目考察团 - - - - - - - */

@property (nonatomic, assign) NSInteger activityCategoryId;         /**< 时间 */
@property (nonatomic, strong) NSString *address;          /**< 地址 */
@property (nonatomic, assign) NSInteger applyAmount;      /**< 数量 */
@property (nonatomic, assign) NSInteger applyPeopleQty;   /**< 参加人数 */
@property (nonatomic, strong) NSURL *defaultImage;        /**< 图片url */
@property (nonatomic, assign) NSInteger houseId;          /**< 房子id */
@property (nonatomic, strong) NSString *houseName;        /**< 房子名 */
@property (nonatomic, assign) NSInteger houseShowingsId;  /**< 考察团id */
@property (nonatomic, assign) float latitude;             /**< 纬度 */
@property (nonatomic, assign) float longitude;            /**< 经度 */
@property (nonatomic, assign) NSInteger phone;            /**< 电话 */
@property (nonatomic, assign) NSInteger price;            /**< 价格 */
@property (nonatomic, strong) NSString *showingsActivityProcess;    /**< 活动流程 */
@property (nonatomic, assign) NSInteger showingsApplyId;  /**< 参加id */
@property (nonatomic, assign) NSInteger showingsEndtime;  /**< 结束时间 */
@property (nonatomic, strong) NSString *showingsLineIntroduction;   /**< 线路介绍 */
@property (nonatomic, strong) NSString *showingsMaxPreferential;    /**< 最高优惠 */
@property (nonatomic, strong) NSString *showingsTitle;    /**< 标题 */
@property (nonatomic, strong) NSString *tel;              /**< 电话 */
@property (nonatomic, assign) NSInteger totalPeopleQty;   /**< 总人数 */
@property (nonatomic, assign) NSInteger time;   /**< 时间 */

//@property (nonatomic, assign) BOOL isDelete;
//@property (nonatomic, assign) float price;        /**< 楼层面积 */
//@property (nonatomic, strong) NSString *tel;    /**< 入驻品牌名 */
//@property (nonatomic, strong) NSURL *defaultImage;      /**< 图片url */
//@property (nonatomic, strong) NSArray *houseModels;      /**< 图片url */


@end
