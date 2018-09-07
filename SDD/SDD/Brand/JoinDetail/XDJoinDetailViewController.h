//
//  XDJoinDetailViewController.h
//  SDD
//
//  Created by hua on 15/12/29.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "XHBaseViewController.h"

@interface XDJoinDetailViewController : XHBaseViewController

//返回状态
typedef NS_ENUM(NSInteger, BackType) {
    BackTypeNormal = 0,  // 点击返回，返回到上一页
    BackTypeDetail,           // 点击返回，返回的详情页
};


//预约状态
typedef NS_ENUM(NSInteger, BookingType) {
    BookingTypeBooking = 1000,  // 预约
    BookingTypeVisit,           // 到访
    BookingTypeSigned,          // 签约
};

@property(nonatomic,strong) NSString *titleLabelStr; //九龙冰室
@property(nonatomic,strong) NSString *couponContentLabelStr; //4622623823（优惠券号内容）

@property(nonatomic,strong) NSString *discountContentLabelStr; //8.5折加盟优惠（额外优惠内容）
@property(nonatomic,strong) NSString *brandLabelStr; //品牌：蒙自源过桥米线
@property(nonatomic,strong) NSString *nameLabelStr; //姓名：刘晓光
@property(nonatomic,strong) NSString *sexLabelStr;  //性别：先生
@property(nonatomic,strong) NSString *phoNumLabelStr; //手机号：18998989898
@property(nonatomic,strong) NSString *companyLabelStr; //公司：广州市九合飞一
@property(nonatomic,strong) NSString *positionLabelStr; //职位：总经理
@property(nonatomic,strong) NSString *brandOperationLabelStr; //经营品牌：九龙冰室
@property(nonatomic,strong) NSString *industryLabelStr; //意向行业
@property(nonatomic,strong) NSString *budgetLabelStr;  //投资预算
@property(nonatomic,strong) NSString *stateImageViewStr; //显示预约状态
@property(nonatomic,strong) NSMutableArray *dataArray;   //tableView数据

@property(nonatomic,assign) BookingType bookingType;
@property(nonatomic,assign) BackType backType;
@end
