//
//  TaxCalculatorView.h
//  SDD
//  税费计算器
//  Created by hua on 15/4/18.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWRChart.h"
#import "LabelTextfieldView.h"

@interface TaxCalculatorView : UIView

// 底部
@property (nonatomic, strong) UIScrollView *index_scrollView;
// 饼图
@property (nonatomic, strong) TWRChartView *chartView;
// 房款总价
@property (nonatomic, strong) UILabel *totalPrice;
// 契税
@property (nonatomic, strong) UILabel *deedTax;
// 印花税
@property (nonatomic, strong) UILabel *stampTax;
// 公证费
@property (nonatomic, strong) UILabel *notarialFees;
// 委托办理产权手续费
@property (nonatomic, strong) UILabel *delegationFee;
// 房屋买卖手续费
@property (nonatomic, strong) UILabel *dealFee;
// 税金总额
@property (nonatomic, strong) UILabel *totalFee;


// 物业类型
//@property (nonatomic, strong) LabelTextfieldView *propertyType;
//// 计算方式
//@property (nonatomic, strong) LabelTextfieldView *calcWays;
//// 是否满五年
//@property (nonatomic, strong) LabelTextfieldView *isFive;
//// 是否首次购房
//@property (nonatomic, strong) LabelTextfieldView *isFirst;
//// 是否唯一住房
//@property (nonatomic, strong) LabelTextfieldView *isUnique;
// 面积
@property (nonatomic, strong) LabelTextfieldView *space;
// 单价
@property (nonatomic, strong) LabelTextfieldView *unitPrice;
// 开始计算
@property (nonatomic, strong) UIButton *calculate;

// 新房or二手
//@property (nonatomic, assign) BOOL isResold;

@end
