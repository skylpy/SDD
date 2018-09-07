//
//  LoanCalculatorView.h
//  SDD
//
//  Created by hua on 15/4/18.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWRChart.h"
#import "LabelTextfieldView.h"

//@class LabelTextfieldView;

@protocol LoanCalculatorViewDelegate

// 首付比例
- (void)theDownPayment;
// 按揭年数
- (void)theMortgageYears;
// 利率
- (void)theInterestRate;
// 开始计算
- (void)toCalculate;

@end

@interface LoanCalculatorView : UIView

// 底部
@property (nonatomic, strong) UIScrollView *index_scrollView;
// 月供
@property (nonatomic, strong) UILabel *monthlyPayments;
// 饼图
@property (nonatomic, strong) TWRChartView *chartView;
// 贷款明细
@property (nonatomic, strong) UILabel *loanDetails;
// 贷款总额
@property (nonatomic, strong) UILabel *loanTotal;
// 支付利息
@property (nonatomic, strong) UILabel *interestPayment;
// 利率
@property (nonatomic, strong) UILabel *currentInterestRate;
// 利率
@property (nonatomic, strong) UILabel *currentInterestRate2;
// 还款方式
@property (nonatomic, strong) LabelTextfieldView *repaymentWays;
// 等额本息
@property (nonatomic, strong) UIButton *principalAndInterest;
// 等额本金
@property (nonatomic, strong) UIButton *principal;
// 房价总额
@property (nonatomic, strong) LabelTextfieldView *housePrice;
// 首付比例
@property (nonatomic, strong) LabelTextfieldView *downPayment;
// 贷款总额
@property (nonatomic, strong) UILabel *totalLoan;
// 商业贷款金额
@property (nonatomic, strong) LabelTextfieldView *businessLoan;
// 公积金贷款金额
@property (nonatomic, strong) LabelTextfieldView *accumulationFundLoan;
// 按揭年数
@property (nonatomic, strong) LabelTextfieldView *mortgageYears;
// 利率
@property (nonatomic, strong) LabelTextfieldView *interestRate;
// 组合利率
@property (nonatomic, strong) UILabel *bottonInterestRate;
// 开始计算
@property (nonatomic, strong) UIButton *calculate;
// 贷款类型
@property (nonatomic, assign) int loanType;

// 代理
@property (assign, nonatomic) id<LoanCalculatorViewDelegate>delegate;

@end
