//
//  CalculatorsViewController.m
//  SDD
//
//  Created by hua on 15/4/18.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "CalculatorsViewController.h"
#import "LabelTextfieldView.h"
#import "LoanCalculatorView.h"
#import "TaxCalculatorView.h"

#import "CalcDetailViewController.h"

#import "Tools_F.h"
#import "ProgressHUD.h"

@interface CalculatorsViewController ()<UIGestureRecognizerDelegate,UIScrollViewDelegate,UITextFieldDelegate,LoanCalculatorViewDelegate>{
    
    /*- data -*/
    
    // 房贷计算
    double calcPrice;                           // 计算金额
    NSInteger loanPeriod;                       // 贷款期限
    double interestRate;                        // 月利率
    BOOL isPrincipalAndInterest;                // 是否等额本金
    
    float downPayment;                          // 首付比例
    
    // 税费计算
    double houseUnitPrice;                          // 房屋单价
    double houseArea;                           // 房屋面积
    
    // 三维数组坐标
    NSInteger x;
    NSInteger y;
    NSInteger z;
    
    float interestRateArr[17][3][11];           // 利率
}

// 房贷计算器
@property (nonatomic, strong) LoanCalculatorView *loanView;
// 税收计算器
@property (nonatomic, strong) TaxCalculatorView *taxView;
// 房屋总款
@property (nonatomic, assign) double houseTotalPrice;
// 契税额
@property (nonatomic, assign) double deedTaxAmount;
// 买卖手续费
@property (nonatomic, assign) NSInteger closingCosts;

@end

@implementation CalculatorsViewController

#pragma mark - 利率表
- (void)arrayInitialization{
    
    // 默认值
    calcPrice = 70;                     // 计算金额
    loanPeriod = 15*12;                 // 还款期限
    interestRate = 6.80;                // 月利率
    isPrincipalAndInterest = NO;        // 是否本金
    downPayment = 0.5;                  // 首付比例
    
    x = 1;
    y = 2;
    z = 10;
    
    // 12年6月8日基准利率
    interestRateArr[1][1][1]   = 0.0631;//商贷1年 6.31%
    interestRateArr[1][1][3]   = 0.0640;//商贷1〜3年 6.4%
    interestRateArr[1][1][5]   = 0.0665;//商贷 3〜5年 6.65%
    interestRateArr[1][1][10]  = 0.0680;//商贷 5-30年 6.8%
    interestRateArr[1][2][5]   = 0.0420;//公积金 1〜5年 4.2%
    interestRateArr[1][2][10]  = 0.0470;//公积金 5-30年 4.7%
    
    // 12年6月8日利率下限（7折）
    interestRateArr[2][1][1]   = 0.04417;//商贷1年 4.417%
    interestRateArr[2][1][3]   = 0.0448;//商贷1〜3年 4.48%
    interestRateArr[2][1][5]   = 0.04655;//商贷 3〜5年 4.655%
    interestRateArr[2][1][10]  = 0.0476;//商贷 5-30年 4.76%
    interestRateArr[2][2][5]   = 0.0420;//公积金 1〜5年 4.2%
    interestRateArr[2][2][10]  = 0.0470;//公积金 5-30年 4.7%
    
    // 12年6月8日利率下限（85折）
    interestRateArr[3][1][1]   = 0.053635;//商贷1年 5.3635%
    interestRateArr[3][1][3]   = 0.0544;//商贷1〜3年 5.44%
    interestRateArr[3][1][5]   = 0.056525;//商贷 3〜5年 5.6525%
    interestRateArr[3][1][10]  = 0.0578;//商贷 5-30年 5.78%
    interestRateArr[3][2][5]   = 0.0420;//公积金 1〜5年 4.2%
    interestRateArr[3][2][10]  = 0.0470;//公积金 5-30年 4.7%
    
    // 12年6月8日利率上限（1.1倍）
    interestRateArr[4][1][1]   = 0.06941;//商贷1年 6.941%
    interestRateArr[4][1][3]   = 0.0704;//商贷1〜3年 7.04%
    interestRateArr[4][1][5]   = 0.07315;//商贷 3〜5年 7.315%
    interestRateArr[4][1][10]  = 0.0748;//商贷 5-30年 7.48%
    interestRateArr[4][2][5]   = 0.0420;//公积金 1〜5年 4.2%
    interestRateArr[4][2][10]  = 0.0470;//公积金 5-30年 4.7%
    
    // 12年7月6日基准利率
    interestRateArr[5][1][1]   = 0.0600;//商贷1年 6%
    interestRateArr[5][1][3]   = 0.0615;//商贷1〜3年 6.15%
    interestRateArr[5][1][5]   = 0.0640;//商贷 3〜5年 6.4%
    interestRateArr[5][1][10]  = 0.0655;//商贷 5-30年 6.55%
    interestRateArr[5][2][5]   = 0.0400;//公积金 1〜5年 4%
    interestRateArr[5][2][10]  = 0.0450;//公积金 5-30年 4.5%
    
    // 12年7月6日利率下限（7折）
    interestRateArr[6][1][1]   = 0.042;//商贷1年 4.2%
    interestRateArr[6][1][3]   = 0.04305;//商贷1〜3年 4.305%
    interestRateArr[6][1][5]   = 0.0448;//商贷 3〜5年 4.48%
    interestRateArr[6][1][10]  = 0.04585;//商贷 5-30年 4.585%
    interestRateArr[6][2][5]   = 0.0400;//公积金 1〜5年 4%
    interestRateArr[6][2][10]  = 0.0450;//公积金 5-30年 4.5%
    
    // 12年7月6日利率下限（85折）
    interestRateArr[7][1][1]   = 0.051;//商贷1年 5.1%
    interestRateArr[7][1][3]   = 0.052275;//商贷1〜3年 5.2275%
    interestRateArr[7][1][5]   = 0.0544;//商贷 3〜5年 5.44%
    interestRateArr[7][1][10]  = 0.055675;//商贷 5-30年 5.5675%
    interestRateArr[7][2][5]   = 0.0400;//公积金 1〜5年 4%
    interestRateArr[7][2][10]  = 0.0450;//公积金 5-30年 4.5%
    
    // 12年7月6日利率上限（1.1倍）
    interestRateArr[8][1][1]   = 0.066;//商贷1年 6.6%
    interestRateArr[8][1][3]   = 0.06765;//商贷1〜3年 6.765%
    interestRateArr[8][1][5]   = 0.0704;//商贷 3〜5年 7.04%
    interestRateArr[8][1][10]  = 0.07205;//商贷 5-30年 7.205%
    interestRateArr[8][2][5]   = 0.0400;//公积金 1〜5年 4%
    interestRateArr[8][2][10]  = 0.0450;//公积金 5-30年 4.5%
    
    // 14年11月22日基准利率
    interestRateArr[9][1][1]   = 0.0560;//商贷1年 6%
    interestRateArr[9][1][3]   = 0.0600;//商贷1〜3年 6%
    interestRateArr[9][1][5]   = 0.0600;//商贷 3〜5年 6%
    interestRateArr[9][1][10]  = 0.0615;//商贷 5-30年 6.15%
    interestRateArr[9][2][5]   = 0.0375;//公积金 1〜5年 4%
    interestRateArr[9][2][10]  = 0.0425;//公积金 5-30年 4.5%
    
    // 14年11月22日利率下限（7折）
    interestRateArr[10][1][1]  = 0.0420;//商贷1年 6%
    interestRateArr[10][1][3]  = 0.0420;//商贷1〜3年 6%
    interestRateArr[10][1][5]  = 0.0420;//商贷 3〜5年 6%
    interestRateArr[10][1][10] = 0.04305;//商贷 5-30年 6.15%
    interestRateArr[10][2][5]  = 0.02625;//公积金 1〜5年 4%
    interestRateArr[10][2][10] = 0.02975;//公积金 5-30年 4.5%
    
    // 14年11月22日利率下限（85折）
    interestRateArr[11][1][1]  = 0.051;//商贷1年 5.1%
    interestRateArr[11][1][3]  = 0.051;//商贷1〜3年 5.2275%
    interestRateArr[11][1][5]  = 0.051;//商贷 3〜5年 5.44%
    interestRateArr[11][1][10] = 0.052275;//商贷 5-30年 5.5675%
    interestRateArr[11][2][5]  = 0.031875;//公积金 1〜5年 4%
    interestRateArr[11][2][10] = 0.036125;//公积金 5-30年 4.5%
    
    // 14年11月22日利率上限（1.1倍）
    interestRateArr[12][1][1]  = 0.066;//商贷1年 6.6%
    interestRateArr[12][1][3]  = 0.066;//商贷1〜3年 6.765%
    interestRateArr[12][1][5]  = 0.066;//商贷 3〜5年 7.04%
    interestRateArr[12][1][10] = 0.06765;//商贷 5-30年 7.205%
    interestRateArr[12][2][5]  = 0.04125;//公积金 1〜5年 4%
    interestRateArr[12][2][10] = 0.04675;//公积金 5-30年 4.5%
    
    // 2015年3月1日基准利率
    interestRateArr[13][1][1]  = 0.0535;//商贷1年 6%
    interestRateArr[13][1][3]  = 0.0575;//商贷1〜3年 6%
    interestRateArr[13][1][5]  = 0.0575;//商贷 3〜5年 6%
    interestRateArr[13][1][10] = 0.0590;//商贷 5-30年 6.15%
    interestRateArr[13][2][5]  = 0.0350;//公积金 1〜5年 4%
    interestRateArr[13][2][10] = 0.0400;//公积金 5-30年 4.5%
    
    // 2015年3月1日利率下限（7折）
    interestRateArr[14][1][1]  = 0.03745;//商贷1年 6%
    interestRateArr[14][1][3]  = 0.04025;//商贷1〜3年 6%
    interestRateArr[14][1][5]  = 0.04025;//商贷 3〜5年 6%
    interestRateArr[14][1][10] = 0.04130;//商贷 5-30年 6.15%
    interestRateArr[14][2][5]  = 0.02450;//公积金 1〜5年 4%
    interestRateArr[14][2][10] = 0.02800;//公积金 5-30年 4.5%
    
    // 2015年3月1日利率下限（85折）
    interestRateArr[15][1][1]  = 0.045475;//商贷1年 5.1%
    interestRateArr[15][1][3]  = 0.0488750;//商贷1〜3年 5.2275%
    interestRateArr[15][1][5]  = 0.0488750;//商贷 3〜5年 5.44%
    interestRateArr[15][1][10] = 0.05015;//商贷 5-30年 5.5675%
    interestRateArr[15][2][5]  = 0.02975;//公积金 1〜5年 4%
    interestRateArr[15][2][10] = 0.03400;//公积金 5-30年 4.5%
    
    // 2015年3月1日利率上限（1.1倍）
    interestRateArr[16][1][1]  = 0.05885;//商贷1年 6.6%
    interestRateArr[16][1][3]  = 0.06325;//商贷1〜3年 6.765%
    interestRateArr[16][1][5]  = 0.06325;//商贷 3〜5年 7.04%
    interestRateArr[16][1][10] = 0.0649;//商贷 5-30年 7.205%
    interestRateArr[16][2][5]  = 0.03850;//公积金 1〜5年 4%
    interestRateArr[16][2][10] = 0.0440;//公积金 5-30年 4.5%
}

#pragma mark - 房屋总价
- (double)houseTotalPrice{
    
    _houseTotalPrice = houseUnitPrice*houseArea;
    return _houseTotalPrice;
}

#pragma mark - 契税额
- (double)deedTaxAmount{
    
    if (houseUnitPrice <= 9432) {
        _deedTaxAmount = self.houseTotalPrice * 0.015;
    }
    else {
        _deedTaxAmount = self.houseTotalPrice * 0.03;
    }
    
    return _deedTaxAmount;
}

#pragma mark - 买卖手续费
- (NSInteger)closingCosts{
    
    if (houseArea <= 120) {
        _closingCosts = 500;
    }
    else if (houseArea <= 5000) {
        _closingCosts = 1500;
    }
    else {
        _closingCosts = 5000;
    }
    
    return _closingCosts;
}

#pragma mark - 累计支付利息
- (double)payInterestCount{
    double payInterest = 0;
    for (int i = 1; i <= loanPeriod; i++){
        payInterest += [self repayInterest:i];
    }
    return payInterest;
}

#pragma mark - 累计还款总额
- (double)repayment{
    
    return calcPrice+[self payInterestCount];
}

#pragma mark - 偿还本息
- (double)repayPrincipalAndInterest:(NSInteger)sender{
    
    return [self repayInterest:sender]+[self repayPrincipal:sender];
}

#pragma mark - 偿还利息
- (double)repayInterest:(NSInteger)sender{
    if (sender > loanPeriod || sender <= 0) {
        
        return 0;
    }
    
    double interest = 0;
    if (isPrincipalAndInterest){
        interest = ((calcPrice - [self repayPrincipal:1]*(sender - 1)) * interestRate);
    } else {
        interest = calcPrice * interestRate
        * (pow(1 + interestRate, loanPeriod) - pow(1 + interestRate, sender - 1))
        / (pow(1 + interestRate, loanPeriod) - 1);
    }
    return interest;
}

#pragma mark - 偿还本金
- (double)repayPrincipal:(NSInteger)sender{
    
    if (sender > loanPeriod || sender <= 0) {
        
        return 0;
    }
    
    double principal = 0;
    if (isPrincipalAndInterest) {
        principal = calcPrice / loanPeriod;
    }else{
        principal = [self payPrincipalAndInterest] - [self repayInterest:sender];
    }
    return principal;
}

#pragma mark - 等额本息
- (double)payPrincipalAndInterest{
    
    double a = interestRate * pow(1 + interestRate, loanPeriod);
    double b = pow(1 + interestRate, loanPeriod) - 1;
    return calcPrice * (a / b);
}

#pragma mark - 剩余本金
- (double)surplusPrincipal:(NSInteger)sender{
    
    if (sender > loanPeriod || sender <= 0) {
        
        return 0;
    }
    
    double surplusPrincipal = calcPrice;
    for (int i = 1; i <= sender; i++) {
        surplusPrincipal -= [self repayPrincipal:i];
    }
    return surplusPrincipal;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    // 导航条
    [self setupNav];
    // 设置内容
    [self setupUI];
    
    // 监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loanTypeSelect) name:@"LoanTypeSelect" object:nil];
}

- (TaxCalculatorView *)taxView{
    if (!_taxView) {
        _taxView = [[TaxCalculatorView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-64)];
    }
    return _taxView;
}

- (LoanCalculatorView *)loanView{
    if (!_loanView) {
        _loanView = [[LoanCalculatorView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-64)];
        _loanView.delegate = self;
        _loanView.loanType = 0;         // 默认公积金贷款
    }
    return _loanView;
}

#pragma mark - 设置导航条
- (void)setupNav{
    
    SDDButton *button = [[SDDButton alloc]init];
    button.frame = CGRectMake(0, 0, 100, 44);
    [button setTitle:@"计算器" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    // 导航条右btn
    UIButton*commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(0, 0, 72, 20);
    commitButton.titleLabel.font = biggestFont;
    [commitButton setTitle:@"税费计算" forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(viewSwitch:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:commitButton];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    _calculatorType == 0? [self showLoanView]:[self showTaxView];
}

#pragma mark - 房贷计算
- (void)showLoanView{
    
    // 加载利率表
    [self arrayInitialization];
    
    [self.view addSubview:self.loanView];
    
    [self loanTypeSelect];
}

- (void)loanTypeSelect{
    
    // 设置代理
    _loanView.housePrice.textField.delegate = self;
    _loanView.businessLoan.textField.delegate = self;
    _loanView.accumulationFundLoan.textField.delegate = self;
    
    [self calcInterestRate];
}

#pragma mark - 税费计算
- (void)showTaxView{
    
    [self.view addSubview:self.taxView];
    
    [_taxView.calculate addTarget:self action:@selector(taxCalc) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 计算器切换
- (void)viewSwitch:(UIButton *)btn{
    
    switch (_calculatorType) {
        case 0:
        {
            [_loanView removeFromSuperview];
        }
            break;
        case 1:
        {
            [_taxView removeFromSuperview];
        }
            break;
            
        default:
            break;
    }
    
    // 导航条右btn变化
    NSString *title = _calculatorType == 0?@"房贷计算":@"税费计算";
    
    UIButton*commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(0, 0, 72, 20);
    commitButton.titleLabel.font = biggestFont;
    [commitButton setTitle:title forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(viewSwitch:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:commitButton];
    
    // 切换状态
    _calculatorType = _calculatorType == 0?1:0;
    _calculatorType == 0? [self showLoanView]:[self showTaxView];
}

#pragma mark - >>>>>>>>>房贷计算<<<<<<<<<
- (void)toCalculate{
    
    calcPrice = [_loanView.businessLoan.textField.text intValue];
    isPrincipalAndInterest = _loanView.principal.selected;
    NSLog(@"计算金额%f 是否等额本金%hhd 贷款月利率%f 贷款期限%d",calcPrice,isPrincipalAndInterest,interestRate,loanPeriod);
    NSLog(@"累计支付利息%f",[self payInterestCount]);
    
    // 滚到顶部
    [_loanView.index_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    // 月供
    _loanView.monthlyPayments.text = [NSString stringWithFormat:@"%.2f元/月",[self repayment]/loanPeriod*10000];
    // 支付利息
    _loanView.interestPayment.text = [NSString stringWithFormat:@"支付利息:  %.3f万",[self payInterestCount]];
    // 饼图变化
    float lx = [self payInterestCount]/[self payInterestCount]+[self calcDownPaymentPercentage];
    float ze = [self calcDownPaymentPercentage]/[self payInterestCount]+[self calcDownPaymentPercentage];
    TWRCircularChart *pieChart = [[TWRCircularChart alloc] initWithValues:@[
                                                                            [NSNumber numberWithFloat:lx],
                                                                            [NSNumber numberWithFloat:ze]
                                                                            ]
                                                                   colors:@[
                                                                            setColor(253, 218, 86, 1),
                                                                            setColor(74, 120, 216, 1)
                                                                            ]
                                                                     type:TWRCircularChartTypePie
                                                                 animated:YES];
    [_loanView.chartView loadCircularChart:pieChart];
    
}

#pragma mark - >>>>>>>>>税费计算<<<<<<<<<
- (void)taxCalc{
    
    houseArea = [_taxView.space.textField.text doubleValue];
    houseUnitPrice = [_taxView.unitPrice.textField.text doubleValue];
    
    // 房贷总价
    _taxView.totalPrice.text = [NSString stringWithFormat:@"房款总价:  %.2f万",self.houseTotalPrice/10000];
    // 契税
    _taxView.deedTax.text = [NSString stringWithFormat:@"契       税:  %.0f元",round(self.deedTaxAmount*100)/100];
    // 印花税
    _taxView.stampTax.text = [NSString stringWithFormat:@"印  花  税:  %.0f元",round(self.houseTotalPrice*0.0005*100)/100];
    // 公证费
    _taxView.notarialFees.text = [NSString stringWithFormat:@"公  证  费:  %.0f元",round(self.houseTotalPrice*0.003*100)/100];
    // 委托办理产权手续费
    _taxView.delegationFee.text = [NSString stringWithFormat:@"委托办理产权手续费:  %.0f元",round(self.houseTotalPrice*0.003*100)/100];
    // 房屋买卖手续费
    _taxView.dealFee.text = [NSString stringWithFormat:@"房屋买卖手续费:  %.0f元",round(self.closingCosts*100)/100];
    // 税金总额
    _taxView.totalFee.text = [NSString stringWithFormat:@"税金总额:  %.0f元",round(self.deedTaxAmount*100)/100+
                              round(_houseTotalPrice*0.0005*100)/100+
                              round(_houseTotalPrice*0.003*100)/100+
                              round(_houseTotalPrice*0.003*100)/100+
                              round(_closingCosts*100)/100];
    
}

#pragma mark - 首付比例
- (void)theDownPayment{
    
    CalcDetailViewController *cd = [[CalcDetailViewController alloc] init];
    
    cd.detailType = 0;
    [cd valueReturn:^(NSString *theValue, NSInteger theIndex) {

        _loanView.downPayment.textField.text = [NSString stringWithFormat:@"%@（%.0f万）",theValue,[_loanView.housePrice.textField.text intValue]*(theIndex+1)/10.0];
        downPayment = 1-(theIndex+1)/10.0;
        [self calcDownPaymentPercentage];           // 算房贷总额
    }];
    [self.navigationController pushViewController:cd animated:YES];
}

#pragma mark - 算房贷总额
- (float)calcDownPaymentPercentage{
    
    int housePrice = [_loanView.housePrice.textField.text intValue];
    
    _loanView.loanTotal.text = [NSString stringWithFormat:@"贷款总额:  %.0f万",housePrice*downPayment];
    _loanView.totalLoan.text = [NSString stringWithFormat:@"贷款总额:  %.0f万",housePrice*downPayment];
    _loanView.businessLoan.textField.text = [NSString stringWithFormat:@"%.0f",housePrice*downPayment];
    
    return housePrice*downPayment;
}
#pragma mark - 按揭年数
- (void)theMortgageYears{
    
    CalcDetailViewController *cd = [[CalcDetailViewController alloc] init];
    
    cd.detailType = 1;
    [cd valueReturn:^(NSString *theValue, NSInteger theIndex) {
        
        _loanView.mortgageYears.textField.text = theValue;
        loanPeriod = (theIndex +1)*12;
        
        if (theIndex<1) {
            z = 1;
            if (_loanView.loanType == 0) {
                z = 5;
            }
        }
        else if (theIndex<3) {
            z = 3;
            if (_loanView.loanType == 0) {
                z = 5;
            }
        }
        else if (theIndex<5){
            z = 5;
        }
        else {
            z = 10;
        }
        // 算利率
        [self calcInterestRate];
    }];
    [self.navigationController pushViewController:cd animated:YES];
}

#pragma mark - 利率
- (void)theInterestRate{
    
    CalcDetailViewController *cd = [[CalcDetailViewController alloc] init];
    
    cd.detailType = 2;
    [cd valueReturn:^(NSString *theValue, NSInteger theIndex) {
        
        _loanView.interestRate.textField.text = theValue;
        x = theIndex+1;         // 因为表是从1开始，因此加1
        // 算利率
        [self calcInterestRate];
    }];
    [self.navigationController pushViewController:cd animated:YES];
}

- (void)calcInterestRate{
    
    if (_loanView.loanType == 0) {              // 公积金
        
        y = 2;
        _loanView.bottonInterestRate.text = [NSString stringWithFormat:@"公积金贷款利率%.2f%%",interestRateArr[x][y][z]*100];
        _loanView.currentInterestRate.text = [NSString stringWithFormat:@"公积金利率:  %.2f%%",interestRateArr[x][y][z]*100];
    }
    else if (_loanView.loanType == 1){          // 商业贷款
        
        y = 1;
        _loanView.bottonInterestRate.text = [NSString stringWithFormat:@"商业贷款利率%.2f%%",interestRateArr[x][y][z]*100];
        _loanView.currentInterestRate.text = [NSString stringWithFormat:@"商业利率:  %.2f%%",interestRateArr[x][y][z]*100];
    }
    else {                                      // 组合贷款
        
        y = 1;      // 暂时
        _loanView.bottonInterestRate.text = [NSString stringWithFormat:@"公积金贷款利率%.2f%% 商业贷款利率%.2f%%",interestRateArr[x][y+1][z]*100,interestRateArr[x][y][z]*100];
        
        _loanView.currentInterestRate.text = [NSString stringWithFormat:@"商业利率:  %.2f%%",interestRateArr[x][y][z]*100];
        _loanView.currentInterestRate2.text = [NSString stringWithFormat:@"公积金利率:  %.2f%%",interestRateArr[x][y+1][z]*100];
    }
    
    interestRate = (interestRateArr[x][y][z])/12;
    
}

#pragma mark - textfield代理
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSInteger amount = [textField.text integerValue];
    
    // 输入完房价总额后
    if (textField == _loanView.housePrice.textField) {
        
        // 算房价总额
        [self calcDownPaymentPercentage];
    }
    
    // 输入完贷款金额
    if (textField == _loanView.businessLoan.textField) {
        
        int housePrice = [_loanView.housePrice.textField.text intValue];
        
        if (amount + [_loanView.accumulationFundLoan.textField.text integerValue] > housePrice*downPayment) {
            [ProgressHUD showSuccess:@"超出贷款金额"];
            textField.text = @"";
        }
    }
    
    // 输入完贷款金额2
    if (textField == _loanView.accumulationFundLoan.textField) {
        
        int housePrice = [_loanView.housePrice.textField.text intValue];
        
        if (amount + [_loanView.businessLoan.textField.text integerValue] > housePrice*downPayment) {
            [ProgressHUD showSuccess:@"超出贷款金额"];
            textField.text = @"";
        }
    }
}

#pragma mark - leftaction
- (void)leftAction:(UIButton *)btn{
    
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
