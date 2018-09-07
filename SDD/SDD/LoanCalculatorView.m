//
//  LoanCalculatorView.m
//  SDD
//
//  Created by hua on 15/4/18.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "LoanCalculatorView.h"
#import "Tools_F.h"
@implementation LoanCalculatorView{
    
    // 上部分背景
    UIView *topView;
    // 底部
    UIView *bottomView;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 添加滚动
        _index_scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-64)];
        _index_scrollView.backgroundColor = bgColor;
        _index_scrollView.directionalLockEnabled=YES;
        _index_scrollView.showsHorizontalScrollIndicator = NO;
        _index_scrollView.showsVerticalScrollIndicator = NO;
        
        [self addSubview:_index_scrollView];
        
        // 参考月供
        UILabel *monthlyPayments_title = [[UILabel alloc] init];
        monthlyPayments_title.frame = CGRectMake(10, 25, viewWidth/2, 16);
        monthlyPayments_title.font = largeFont;
        monthlyPayments_title.text = @"参考月供";
        [_index_scrollView addSubview:monthlyPayments_title];
        
        _monthlyPayments = [[UILabel alloc] init];
        _monthlyPayments.frame = CGRectMake(viewWidth/2, 25, viewWidth/2-10, 16);
        _monthlyPayments.font = largeFont;
        _monthlyPayments.text = @"0.00元/月";
        _monthlyPayments.textAlignment = NSTextAlignmentRight;
        [_index_scrollView addSubview:_monthlyPayments];
        
        // 分割线
        UIView *division_1 = [[UIView alloc] init];
        division_1.frame = CGRectMake(0, CGRectGetMaxY(_monthlyPayments.frame)+10, viewWidth, 1);
        division_1.backgroundColor = divisionColor;
        [_index_scrollView addSubview:division_1];
        
        // 上部分背景
        topView = [[UIView alloc] init];
        topView.frame = CGRectMake(0, CGRectGetMaxY(division_1.frame), viewWidth, 140);
        topView.backgroundColor = [UIColor whiteColor];
        [_index_scrollView addSubview:topView];
        
        // 饼图
        _chartView = [[TWRChartView alloc] initWithFrame:CGRectMake(0, 0, 130, 130)];
        _chartView.backgroundColor = [UIColor whiteColor];
        [topView addSubview:_chartView];
        TWRCircularChart *pieChart = [[TWRCircularChart alloc] initWithValues:@[@40,@60]
                                                                       colors:@[setColor(253, 218, 86, 1), setColor(74, 120, 216, 1)]
                                                                         type:TWRCircularChartTypePie
                                                                     animated:YES];
        [_chartView loadCircularChart:pieChart];
        
        // 明细
        _loanDetails = [[UILabel alloc] init];
        _loanDetails.frame = CGRectMake(CGRectGetMaxX(_chartView.frame)+20, 15, viewWidth/2, 13);
        _loanDetails.font = midFont;
        _loanDetails.text = @"贷款明细";
        [topView addSubview:_loanDetails];
        
        // 贷款总额
        UIView *bluePoint = [[UIView alloc] init];
        bluePoint.frame = CGRectMake(CGRectGetMaxX(_chartView.frame), CGRectGetMaxY(_loanDetails.frame)+13, 11, 11);
        bluePoint.backgroundColor = setColor(74, 120, 216, 1);
        [Tools_F setViewlayer:bluePoint cornerRadius:5.5 borderWidth:0 borderColor:[UIColor clearColor]];
        [topView addSubview:bluePoint];
        
        _loanTotal = [[UILabel alloc] init];
        _loanTotal.frame = CGRectMake(CGRectGetMaxX(_chartView.frame)+20, CGRectGetMaxY(_loanDetails.frame)+12, viewWidth/2, 13);
        _loanTotal.font = midFont;
        _loanTotal.text = @"贷款总额:  50万";
        [topView addSubview:_loanTotal];
        
        // 支付利息
        UIView *yellowPoint = [[UIView alloc] init];
        yellowPoint.frame = CGRectMake(CGRectGetMaxX(_chartView.frame), CGRectGetMaxY(_loanTotal.frame)+13, 11, 11);
        yellowPoint.backgroundColor = setColor(253, 218, 86, 1);
        [Tools_F setViewlayer:yellowPoint cornerRadius:5.5 borderWidth:0 borderColor:[UIColor clearColor]];
        [topView addSubview:yellowPoint];
        
        _interestPayment = [[UILabel alloc] init];
        _interestPayment.frame = CGRectMake(CGRectGetMaxX(_chartView.frame)+20, CGRectGetMaxY(_loanTotal.frame)+12, viewWidth/2, 13);
        _interestPayment.font = midFont;
        _interestPayment.text = @"支付利息:  0.00万";
        [topView addSubview:_interestPayment];
        
        // 利率
        _currentInterestRate = [[UILabel alloc] init];
        _currentInterestRate.frame = CGRectMake(CGRectGetMaxX(_chartView.frame)+20, CGRectGetMaxY(_interestPayment.frame)+12, viewWidth/2, 13);
        _currentInterestRate.font = midFont;
        _currentInterestRate.text = @"商业利率:  5.90%";
        [topView addSubview:_currentInterestRate];
        
        // 利率2
        _currentInterestRate2 = [[UILabel alloc] init];
        _currentInterestRate2.frame = CGRectMake(CGRectGetMaxX(_chartView.frame)+20, CGRectGetMaxY(_currentInterestRate.frame)+12, viewWidth/2, 13);
        _currentInterestRate2.font = midFont;
        _currentInterestRate2.text = @"公积金利率:  6.80%";
        _currentInterestRate2.hidden = YES;
        [topView addSubview:_currentInterestRate2];
        
        // 参考
        UILabel *reference = [[UILabel alloc] init];
        reference.frame = CGRectMake(10, topView.frame.size.height-22, viewWidth/2, 10);
        reference.font = littleFont;
        reference.textColor = lgrayColor;
        reference.text = @"以上计算结果仅供参考";
        [topView addSubview:reference];
        
        // 分割线
        UIView *division_2 = [[UIView alloc] init];
        division_2.frame = CGRectMake(0, CGRectGetMaxY(topView.frame), viewWidth, 1);
        division_2.backgroundColor = divisionColor;
        [_index_scrollView addSubview:division_2];
        
        // 标签
        NSArray *titleArr = @[@"公积金贷款",@"商业贷款",@"组合贷款"];
        for (int i = 0; i<3; i++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = 100 +i;
            btn.backgroundColor = bgColor;
            btn.frame = CGRectMake(0 + (viewWidth*i/3), CGRectGetMaxY(division_2.frame), viewWidth/3, 40);
            [btn setTitle: [titleArr objectAtIndex:i] forState:UIControlStateNormal];
            [btn setTitleColor:deepBLack forState:UIControlStateNormal];
            [btn setTitleColor:deepOrangeColor forState:UIControlStateSelected];
            [btn setBackgroundImage:[UIImage imageNamed:@"personal_btn_bottonLine_red"] forState:UIControlStateSelected];
            btn.titleLabel.font =  [UIFont systemFontOfSize:16];
            [btn addTarget:self action:@selector(indexSelected:) forControlEvents:UIControlEventTouchUpInside];
            
            if (i == 0) {               // 默认选中‘全部’
                btn.selected = YES;
            }
            [_index_scrollView addSubview:btn];
        }
        
        // 分割线
        UIView *division_3 = [[UIView alloc] init];
        division_3.frame = CGRectMake(0, CGRectGetMaxY(topView.frame)+40, viewWidth, 1);
        division_3.backgroundColor = divisionColor;
        [_index_scrollView addSubview:division_3];
        
    }
    return self;
}

#pragma mark - indexSelected
- (void)indexSelected:(UIButton *)sender{
    
    [bottomView removeFromSuperview];
    
    // 设置按钮选择状态
    for ( UIButton *tempBtn in _index_scrollView.subviews) {
        if ((int)tempBtn.tag > 99 && (int)tempBtn.tag < 103 ) {
            tempBtn.selected = NO;
        }
    }
    
    [self setLoanType:(int)sender.tag-100];
    sender.selected = YES;          // 当前按钮设置选中
    
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoanTypeSelect" object:nil];
    
}

#pragma mark - 类型
- (void)setLoanType:(int)loanType{
    
    _loanType = loanType;
    // 下部
    bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [_index_scrollView addSubview:bottomView];
    
    loanType<2?[self accumulationfundOrBusiness]:[self combination];
}

#pragma mark - 公积金
- (void)accumulationfundOrBusiness{
    
    _currentInterestRate2.hidden = YES;
    
    // 顶部利率
    _currentInterestRate.text = _loanType==0?@"公积金利率:  6.80%":@"商业利率:  4.70%";

    for (int i=0; i<7; i++) {
        
        UILabel *division = [[UILabel alloc] init];
        division.frame = CGRectMake(0, 45+(45*i), viewWidth, 1);
        division.backgroundColor = divisionColor;
        [bottomView addSubview:division];
    }
    
    // 还款方式
    _repaymentWays = [[LabelTextfieldView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 45)];
    _repaymentWays.titleLabel.font = midFont;
    _repaymentWays.titleLabel.textColor = deepBLack;
    _repaymentWays.titleLabel.text = @"还款方式:";
    _repaymentWays.textField.enabled = NO;
    [bottomView addSubview:_repaymentWays];
    
    // 等额本息
    _principalAndInterest = [UIButton buttonWithType:UIButtonTypeCustom];
    _principalAndInterest.frame = CGRectMake(CGRectGetMaxX(_repaymentWays.titleLabel.frame)+30, 0, viewWidth/4, 45);
    _principalAndInterest.titleLabel.font = midFont;
    [_principalAndInterest setImage:[UIImage imageNamed:@"index_icon_unselected_gray"] forState:UIControlStateNormal];
    [_principalAndInterest setImage:[UIImage imageNamed:@"index_icon_selected_gray"] forState:UIControlStateSelected];
    [_principalAndInterest setImageEdgeInsets:UIEdgeInsetsMake(15, 5, 15, 60)];
    [_principalAndInterest setTitle:@"等额本息" forState:UIControlStateNormal];
    [_principalAndInterest setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_repaymentWays addSubview:_principalAndInterest];
    
    // 等额本金
    _principal = [UIButton buttonWithType:UIButtonTypeCustom];
    _principal.frame = CGRectMake(CGRectGetMaxX(_principalAndInterest.frame), 0, viewWidth/4, 45);
    _principal.titleLabel.font = midFont;
    [_principal setImage:[UIImage imageNamed:@"index_icon_unselected_gray"] forState:UIControlStateNormal];
    [_principal setImage:[UIImage imageNamed:@"index_icon_selected_gray"] forState:UIControlStateSelected];
    [_principal setImageEdgeInsets:UIEdgeInsetsMake(15, 5, 15, 60)];
    [_principal setTitle:@"等额本金" forState:UIControlStateNormal];
    [_principal setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_repaymentWays addSubview:_principal];
    
    // 按钮方法
    _principalAndInterest.selected = YES;  // 默认选中
    [_principalAndInterest addTarget:self action:@selector(paiAction:) forControlEvents:UIControlEventTouchUpInside];
    [_principal addTarget:self action:@selector(pAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 房价总额
    _housePrice = [[LabelTextfieldView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_repaymentWays.frame), viewWidth, 45)];
    _housePrice.titleLabel.font = midFont;
    _housePrice.titleLabel.textColor = deepBLack;
    _housePrice.titleLabel.text = @"房价总额:";
    _housePrice.textField.keyboardType = UIKeyboardTypeNumberPad;
    _housePrice.textField.font = midFont;
    _housePrice.textField.textColor = deepBLack;
    _housePrice.textField.text = @"100";
    [bottomView addSubview:_housePrice];
    
    UILabel *units1 = [[UILabel alloc] init];
    units1.frame = CGRectMake(viewWidth-40, 0, 30, 45);
    units1.textColor = deepBLack;
    units1.font = midFont;
    units1.text = @"万元";
    [_housePrice addSubview:units1];
    
    // 首付比例
    _downPayment = [[LabelTextfieldView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_housePrice.frame), viewWidth, 45)];
    _downPayment.titleLabel.font = midFont;
    _downPayment.titleLabel.textColor = deepBLack;
    _downPayment.titleLabel.text = @"首付比例:";
    _downPayment.textField.enabled = NO;
    _downPayment.textField.font = midFont;
    _downPayment.textField.textColor = lgrayColor;
    _downPayment.textField.placeholder = @"五成（50万）";
    [bottomView addSubview:_downPayment];
    
    UIImageView *downPaymentArrow = [[UIImageView alloc] init];
    downPaymentArrow.frame = CGRectMake(viewWidth-30, 17, 7, 12);
    UIImage *gray_rightArrow = [UIImage imageNamed:@"gray_rightArrow"];
    downPaymentArrow.image = gray_rightArrow;
    [_downPayment addSubview:downPaymentArrow];
    
    UITapGestureRecognizer *dpTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downPaymentTap)];
    _downPayment.userInteractionEnabled = YES;
    [_downPayment addGestureRecognizer:dpTap];
    
    // 贷款总额
    _totalLoan = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_downPayment.frame), viewWidth, 45)];
    _totalLoan.font = midFont;
    _totalLoan.textColor = lgrayColor;
    _totalLoan.text = @"贷款总额:  50万";
    [bottomView addSubview:_totalLoan];
    
    // 商业贷款金额
    _businessLoan = [[LabelTextfieldView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_totalLoan.frame), viewWidth, 45)];
    _businessLoan.titleLabel.font = midFont;
    _businessLoan.titleLabel.textColor = deepBLack;
    _businessLoan.titleLabel.frame = CGRectMake(10, 0, 95, 45);
    _businessLoan.titleLabel.text = _loanType==0?@"公积金贷款金额:":@"商业贷款金额:";
    _businessLoan.textField.keyboardType = UIKeyboardTypeDecimalPad;
    _businessLoan.textField.font = midFont;
    _businessLoan.textField.textColor = deepBLack;
    _businessLoan.textField.frame = CGRectMake(CGRectGetMaxX(_businessLoan.titleLabel.frame)+5, 0, viewWidth-_businessLoan.titleLabel.frame.size.width, 45);
    _businessLoan.textField.placeholder = @"请输入贷款金额";
    [bottomView addSubview:_businessLoan];
    
    UILabel *units2 = [[UILabel alloc] init];
    units2.frame = CGRectMake(viewWidth-40, 0, 30, 45);
    units2.textColor = deepBLack;
    units2.font = midFont;
    units2.text = @"万元";
    [_businessLoan addSubview:units2];
    
    // 按揭年数
    _mortgageYears = [[LabelTextfieldView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_businessLoan.frame), viewWidth, 45)];
    _mortgageYears.titleLabel.font = midFont;
    _mortgageYears.titleLabel.textColor = deepBLack;
    _mortgageYears.titleLabel.text = @"按揭年数:";
    _mortgageYears.textField.enabled = NO;
    _mortgageYears.textField.font = midFont;
    _mortgageYears.textField.textColor = deepBLack;
    _mortgageYears.textField.text = @"15年";
    [bottomView addSubview:_mortgageYears];
    
    UIImageView *mortgageYearsArrow = [[UIImageView alloc] init];
    mortgageYearsArrow.frame = CGRectMake(viewWidth-30, 17, 7, 12);
    mortgageYearsArrow.image = gray_rightArrow;
    [_mortgageYears addSubview:mortgageYearsArrow];
    
    UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mortgageYearsTap)];
    _mortgageYears.userInteractionEnabled = YES;
    [_mortgageYears addGestureRecognizer:myTap];
    
    // 利率
    _interestRate = [[LabelTextfieldView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_mortgageYears.frame), viewWidth, 45)];
    _interestRate.titleLabel.font = midFont;
    _interestRate.titleLabel.textColor = deepBLack;
    _interestRate.titleLabel.text = @"利       率:";
    _interestRate.textField.enabled = NO;
    _interestRate.textField.font = midFont;
    _interestRate.textField.textColor = deepBLack;
    _interestRate.textField.placeholder = @"基准利率";
    [bottomView addSubview:_interestRate];
    
    UIImageView *interestRateArrow = [[UIImageView alloc] init];
    interestRateArrow.frame = CGRectMake(viewWidth-30, 17, 7, 12);
    interestRateArrow.image = gray_rightArrow;
    [_interestRate addSubview:interestRateArrow];
    
    UITapGestureRecognizer *irTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(interestRateTap)];
    _interestRate.userInteractionEnabled = YES;
    [_interestRate addGestureRecognizer:irTap];
    
    // 最底利率
    _bottonInterestRate = [[UILabel alloc] init];
    _bottonInterestRate.frame = CGRectMake(10, CGRectGetMaxY(_interestRate.frame)+7, viewWidth-20, 13);
    _bottonInterestRate.font = midFont;
    _bottonInterestRate.textColor = lgrayColor;
    _bottonInterestRate.text = _loanType==0?@"公积金贷款利率6.80%":@"商业贷款利率4.70%";
    _bottonInterestRate.textAlignment = NSTextAlignmentRight;
    [bottomView addSubview:_bottonInterestRate];
    
    // 开始计算
    _calculate = [UIButton buttonWithType:UIButtonTypeCustom];
    _calculate.frame = CGRectMake(30, CGRectGetMaxY(_interestRate.frame)+49, viewWidth-60, 30);
    _calculate.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    [_calculate setTitle:@"开始计算" forState:UIControlStateNormal];
    [_calculate setTitleColor:deepOrangeColor forState:UIControlStateNormal];
    [_calculate setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_calculate setBackgroundImage:[Tools_F imageWithColor:[UIColor whiteColor] size:CGSizeMake(viewWidth-60, 30)] forState:UIControlStateNormal];
    [_calculate setBackgroundImage:[Tools_F imageWithColor:deepOrangeColor size:CGSizeMake(viewWidth-60, 30)] forState:UIControlStateHighlighted];
    [Tools_F setViewlayer:_calculate cornerRadius:4 borderWidth:1 borderColor:deepOrangeColor];
    [_calculate addTarget:self action:@selector(calculateClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_calculate];
    
    bottomView.frame = CGRectMake(0, CGRectGetMaxY(topView.frame)+40, viewWidth, CGRectGetMaxY(_calculate.frame)+50);
    _index_scrollView.contentSize=CGSizeMake(viewWidth, CGRectGetMaxY(bottomView.frame)-50);
}

#pragma mark - 组合
- (void)combination{
    
    _currentInterestRate2.hidden = NO;
    
    // 顶部利率
    _currentInterestRate.text = @"商业利率:  4.70%";
    
    for (int i=0; i<8; i++) {
        
        UILabel *division = [[UILabel alloc] init];
        division.frame = CGRectMake(0, 45+(45*i), viewWidth, 1);
        division.backgroundColor = divisionColor;
        [bottomView addSubview:division];
    }
    
    // 还款方式
    _repaymentWays = [[LabelTextfieldView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 45)];
    _repaymentWays.titleLabel.font = midFont;
    _repaymentWays.titleLabel.textColor = deepBLack;
    _repaymentWays.titleLabel.text = @"还款方式:";
    _repaymentWays.textField.enabled = NO;
    [bottomView addSubview:_repaymentWays];
    
    // 等额本息
    _principalAndInterest = [UIButton buttonWithType:UIButtonTypeCustom];
    _principalAndInterest.frame = CGRectMake(CGRectGetMaxX(_repaymentWays.titleLabel.frame)+30, 0, viewWidth/4, 45);
    _principalAndInterest.titleLabel.font = midFont;
    [_principalAndInterest setImage:[UIImage imageNamed:@"index_icon_unselected_gray"] forState:UIControlStateNormal];
    [_principalAndInterest setImage:[UIImage imageNamed:@"index_icon_selected_gray"] forState:UIControlStateSelected];
    [_principalAndInterest setImageEdgeInsets:UIEdgeInsetsMake(15, 5, 15, 60)];
    [_principalAndInterest setTitle:@"等额本息" forState:UIControlStateNormal];
    [_principalAndInterest setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_repaymentWays addSubview:_principalAndInterest];
    
    // 等额本金
    _principal = [UIButton buttonWithType:UIButtonTypeCustom];
    _principal.frame = CGRectMake(CGRectGetMaxX(_principalAndInterest.frame), 0, viewWidth/4, 45);
    _principal.titleLabel.font = midFont;
    [_principal setImage:[UIImage imageNamed:@"index_icon_unselected_gray"] forState:UIControlStateNormal];
    [_principal setImage:[UIImage imageNamed:@"index_icon_selected_gray"] forState:UIControlStateSelected];
    [_principal setImageEdgeInsets:UIEdgeInsetsMake(15, 5, 15, 60)];
    [_principal setTitle:@"等额本金" forState:UIControlStateNormal];
    [_principal setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_repaymentWays addSubview:_principal];
    
    // 按钮方法
    _principalAndInterest.selected = YES;  // 默认选中
    [_principalAndInterest addTarget:self action:@selector(paiAction:) forControlEvents:UIControlEventTouchUpInside];
    [_principal addTarget:self action:@selector(pAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 房价总额
    _housePrice = [[LabelTextfieldView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_repaymentWays.frame), viewWidth, 45)];
    _housePrice.titleLabel.font = midFont;
    _housePrice.titleLabel.textColor = deepBLack;
    _housePrice.titleLabel.text = @"房价总额:";
    _housePrice.textField.keyboardType = UIKeyboardTypeNumberPad;
    _housePrice.textField.font = midFont;
    _housePrice.textField.textColor = deepBLack;
    _housePrice.textField.text = @"100";
    [bottomView addSubview:_housePrice];
    
    UILabel *units1 = [[UILabel alloc] init];
    units1.frame = CGRectMake(viewWidth-40, 0, 30, 45);
    units1.textColor = deepBLack;
    units1.font = midFont;
    units1.text = @"万元";
    [_housePrice addSubview:units1];
    
    // 首付比例
    _downPayment = [[LabelTextfieldView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_housePrice.frame), viewWidth, 45)];
    _downPayment.titleLabel.font = midFont;
    _downPayment.titleLabel.textColor = deepBLack;
    _downPayment.titleLabel.text = @"首付比例:";
    _downPayment.textField.enabled = NO;
    _downPayment.textField.font = midFont;
    _downPayment.textField.textColor = lgrayColor;
    _downPayment.textField.placeholder = @"五成（50万）";
    [bottomView addSubview:_downPayment];
    
    UITapGestureRecognizer *dpTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downPaymentTap)];
    _downPayment.userInteractionEnabled = YES;
    [_downPayment addGestureRecognizer:dpTap];
    
    UIImageView *downPaymentArrow = [[UIImageView alloc] init];
    downPaymentArrow.frame = CGRectMake(viewWidth-30, 17, 7, 12);
    UIImage *gray_rightArrow = [UIImage imageNamed:@"gray_rightArrow"];
    downPaymentArrow.image = gray_rightArrow;
    [_downPayment addSubview:downPaymentArrow];
    
    // 贷款总额
    _totalLoan = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_downPayment.frame), viewWidth, 45)];
    _totalLoan.font = midFont;
    _totalLoan.textColor = lgrayColor;
    _totalLoan.text = @"贷款总额:  50万";
    [bottomView addSubview:_totalLoan];
    
    // 商业贷款金额
    _businessLoan = [[LabelTextfieldView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_totalLoan.frame), viewWidth, 45)];
    _businessLoan.titleLabel.font = midFont;
    _businessLoan.titleLabel.textColor = deepBLack;
    _businessLoan.titleLabel.frame = CGRectMake(10, 0, 82, 45);
    _businessLoan.titleLabel.text = @"商业贷款金额:";
    _businessLoan.textField.keyboardType = UIKeyboardTypeNumberPad;
    _businessLoan.textField.font = midFont;
    _businessLoan.textField.textColor = deepBLack;
    _businessLoan.textField.frame = CGRectMake(CGRectGetMaxX(_businessLoan.titleLabel.frame)+5, 0, viewWidth-_businessLoan.titleLabel.frame.size.width, 45);
    _businessLoan.textField.placeholder = @"请输入贷款金额";
    [bottomView addSubview:_businessLoan];
    
    UILabel *units2 = [[UILabel alloc] init];
    units2.frame = CGRectMake(viewWidth-40, 0, 30, 45);
    units2.textColor = deepBLack;
    units2.font = midFont;
    units2.text = @"万元";
    [_businessLoan addSubview:units2];
    
    // 公积金贷款金额
    _accumulationFundLoan = [[LabelTextfieldView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_businessLoan.frame), viewWidth, 45)];
    _accumulationFundLoan.titleLabel.font = midFont;
    _accumulationFundLoan.titleLabel.textColor = deepBLack;
    _accumulationFundLoan.titleLabel.frame = CGRectMake(10, 0, 95, 45);
    _accumulationFundLoan.titleLabel.text = @"公积金贷款金额:";
    _accumulationFundLoan.textField.keyboardType = UIKeyboardTypeNumberPad;
    _accumulationFundLoan.textField.font = midFont;
    _accumulationFundLoan.textField.textColor = deepBLack;
    _accumulationFundLoan.textField.frame = CGRectMake(CGRectGetMaxX(_accumulationFundLoan.titleLabel.frame)+5, 0, viewWidth-_accumulationFundLoan.titleLabel.frame.size.width, 45);
    _accumulationFundLoan.textField.placeholder = @"请输入贷款金额";
    [bottomView addSubview:_accumulationFundLoan];
    
    UILabel *units3 = [[UILabel alloc] init];
    units3.frame = CGRectMake(viewWidth-40, 0, 30, 45);
    units3.textColor = deepBLack;
    units3.font = midFont;
    units3.text = @"万元";
    [_accumulationFundLoan addSubview:units3];
    
    // 按揭年数
    _mortgageYears = [[LabelTextfieldView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_accumulationFundLoan.frame), viewWidth, 45)];
    _mortgageYears.titleLabel.font = midFont;
    _mortgageYears.titleLabel.textColor = deepBLack;
    _mortgageYears.titleLabel.text = @"按揭年数:";
    _mortgageYears.textField.enabled = NO;
    _mortgageYears.textField.font = midFont;
    _mortgageYears.textField.textColor = deepBLack;
    _mortgageYears.textField.placeholder = @"15年";
    [bottomView addSubview:_mortgageYears];
    
    UIImageView *mortgageYearsArrow = [[UIImageView alloc] init];
    mortgageYearsArrow.frame = CGRectMake(viewWidth-30, 17, 7, 12);
    mortgageYearsArrow.image = gray_rightArrow;
    [_mortgageYears addSubview:mortgageYearsArrow];
    
    UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mortgageYearsTap)];
    _mortgageYears.userInteractionEnabled = YES;
    [_mortgageYears addGestureRecognizer:myTap];
    
    // 利率
    _interestRate = [[LabelTextfieldView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_mortgageYears.frame), viewWidth, 45)];
    _interestRate.titleLabel.font = midFont;
    _interestRate.titleLabel.textColor = deepBLack;
    _interestRate.titleLabel.text = @"利       率:";
    _interestRate.textField.enabled = NO;
    _interestRate.textField.font = midFont;
    _interestRate.textField.textColor = deepBLack;
    _interestRate.textField.placeholder = @"基准利率";
    [bottomView addSubview:_interestRate];
    
    UIImageView *interestRateArrow = [[UIImageView alloc] init];
    interestRateArrow.frame = CGRectMake(viewWidth-30, 17, 7, 12);
    interestRateArrow.image = gray_rightArrow;
    [_interestRate addSubview:interestRateArrow];
    
    UITapGestureRecognizer *irTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(interestRateTap)];
    _interestRate.userInteractionEnabled = YES;
    [_interestRate addGestureRecognizer:irTap];
    
    // 最底利率
    _bottonInterestRate = [[UILabel alloc] init];
    _bottonInterestRate.frame = CGRectMake(10, CGRectGetMaxY(_interestRate.frame)+7, viewWidth-20, 13);
    _bottonInterestRate.font = midFont;
    _bottonInterestRate.textColor = lgrayColor;
    _bottonInterestRate.text = @"公积金贷款利率6.15% 商业贷款利率4.70%";
    _bottonInterestRate.textAlignment = NSTextAlignmentRight;
    [bottomView addSubview:_bottonInterestRate];
    
    // 开始计算
    _calculate = [UIButton buttonWithType:UIButtonTypeCustom];
    _calculate.frame = CGRectMake(30, CGRectGetMaxY(_interestRate.frame)+49, viewWidth-60, 30);
    _calculate.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    [_calculate setTitle:@"开始计算" forState:UIControlStateNormal];
    [_calculate setTitleColor:deepOrangeColor forState:UIControlStateNormal];
    [Tools_F setViewlayer:_calculate cornerRadius:4 borderWidth:1 borderColor:deepOrangeColor];
    [_calculate addTarget:self action:@selector(calculateClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_calculate];
    
    bottomView.frame = CGRectMake(0, CGRectGetMaxY(topView.frame)+40, viewWidth, CGRectGetMaxY(_calculate.frame)+50);
    _index_scrollView.contentSize=CGSizeMake(viewWidth, CGRectGetMaxY(bottomView.frame)-50);
}

#pragma mark - 本息
- (void)paiAction:(UIButton *)btn{
    
    btn.selected = YES;
    _principal.selected = NO;
}

#pragma mark - 本金
- (void)pAction:(UIButton *)btn{
    
    btn.selected = YES;
    _principalAndInterest.selected = NO;
}

#pragma mark - 代理
- (void)calculateClick{
    
    [_delegate toCalculate];
}

- (void)downPaymentTap{
    
    [_delegate theDownPayment];
}

- (void)mortgageYearsTap{
    
    [_delegate theMortgageYears];
}

- (void)interestRateTap{
    
    [_delegate theInterestRate];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
