//
//  TaxCalculatorView.m
//  SDD
//
//  Created by hua on 15/4/18.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "TaxCalculatorView.h"

#import "Tools_F.h"

@implementation TaxCalculatorView{
    
    UIView *topView_bg;
    UIView *bottonView_bg;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 添加滚动
        _index_scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-64)];
        _index_scrollView.backgroundColor = [UIColor whiteColor];
        _index_scrollView.directionalLockEnabled=YES;
        _index_scrollView.showsHorizontalScrollIndicator = NO;
        _index_scrollView.showsVerticalScrollIndicator = NO;
        
        [self addSubview:_index_scrollView];
        
        // 标签
//        NSArray *titleArr = @[@"新房",@"二手房"];
//        for (int i = 0; i<2; i++) {
//            
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            btn.tag = 100 +i;
//            btn.backgroundColor = bgColor;
//            btn.frame = CGRectMake(0 + (viewWidth*i/2), 0, viewWidth/2, 40);
//            [btn setTitle: [titleArr objectAtIndex:i] forState:UIControlStateNormal];
//            [btn setTitleColor:deepBLack forState:UIControlStateNormal];
//            [btn setTitleColor:deepOrangeColor forState:UIControlStateSelected];
//            [btn setBackgroundImage:[UIImage imageNamed:@"personal_btn_bottonLine_red"] forState:UIControlStateSelected];
//            btn.titleLabel.font =  [UIFont systemFontOfSize:16];
//            [btn addTarget:self action:@selector(indexSelected:) forControlEvents:UIControlEventTouchUpInside];
//            
//            if (i == 0) {               // 默认选中‘全部’
//                btn.selected = YES;
//            }
//            [_index_scrollView addSubview:btn];
//        }
        
        // 上部
        topView_bg = [[UIView alloc] init];
        topView_bg.frame = CGRectMake(0, 0, viewWidth, 210);
        topView_bg.backgroundColor = [UIColor whiteColor];
        [_index_scrollView addSubview:topView_bg];
        
        UILabel *topTitleLeft = [[UILabel alloc] init];
        topTitleLeft.frame = CGRectMake(0, 15, viewWidth/3, 13);
        topTitleLeft.font = [UIFont systemFontOfSize:13];
        topTitleLeft.textAlignment = NSTextAlignmentCenter;
        topTitleLeft.text = @"参考税金";
        [topView_bg addSubview:topTitleLeft];
        
        UILabel *topTitleRight = [[UILabel alloc] init];
        topTitleRight.frame = CGRectMake(CGRectGetMaxX(topTitleLeft.frame), 15, viewWidth*2/3, 13);
        topTitleRight.font = [UIFont systemFontOfSize:13];
        topTitleRight.textAlignment = NSTextAlignmentCenter;
        topTitleRight.text = @"税金明细";
        [topView_bg addSubview:topTitleRight];
        
        // 饼图
        _chartView = [[TWRChartView alloc] initWithFrame:CGRectMake(-10, CGRectGetMaxY(topTitleLeft.frame), 130, 130)];
        _chartView.backgroundColor = [UIColor whiteColor];
        [topView_bg addSubview:_chartView];
        TWRCircularChart *pieChart = [[TWRCircularChart alloc] initWithValues:@[@40,@60]
                                                                       colors:@[setColor(253, 218, 86, 1), setColor(74, 120, 216, 1)]
                                                                         type:TWRCircularChartTypePie
                                                                     animated:YES];
        [_chartView loadCircularChart:pieChart];
        
        // 房款总价
        _totalPrice = [[UILabel alloc] init];
        _totalPrice.frame = CGRectMake(CGRectGetMaxX(_chartView.frame)+10, CGRectGetMaxY(topTitleRight.frame)+15, viewWidth*2/3-20, 13);
        _totalPrice.font = midFont;
        _totalPrice.text = @"贷款总价: 0.0万";
        [topView_bg addSubview:_totalPrice];
        
        // 5圆点
        for (int i = 0; i<5; i++) {
            
            // 支付利息
            UIView *yellowPoint = [[UIView alloc] init];
            yellowPoint.frame = CGRectMake(CGRectGetMaxX(_chartView.frame)-5, CGRectGetMaxY(_totalPrice.frame)+12+(24*i), 11, 11);
            yellowPoint.backgroundColor = RandomColor;
            [Tools_F setViewlayer:yellowPoint cornerRadius:5.5 borderWidth:0 borderColor:[UIColor clearColor]];
            [topView_bg addSubview:yellowPoint];
        }
        
        // 契税
        _deedTax = [[UILabel alloc] init];
        _deedTax.frame = CGRectMake(CGRectGetMaxX(_chartView.frame)+10, CGRectGetMaxY(_totalPrice.frame)+11, viewWidth*2/3-30, 13);
        _deedTax.font = midFont;
        _deedTax.text = @"契       税:  0元";
        [topView_bg addSubview:_deedTax];
        
        // 印花税
        _stampTax = [[UILabel alloc] init];
        _stampTax.frame = CGRectMake(CGRectGetMaxX(_chartView.frame)+10, CGRectGetMaxY(_deedTax.frame)+11, viewWidth*2/3-30, 13);
        _stampTax.font = midFont;
        _stampTax.text = @"印  花  税:  0元";
        [topView_bg addSubview:_stampTax];
        
        // 公证费
        _notarialFees = [[UILabel alloc] init];
        _notarialFees.frame = CGRectMake(CGRectGetMaxX(_chartView.frame)+10, CGRectGetMaxY(_stampTax.frame)+11, viewWidth*2/3-30, 13);
        _notarialFees.font = midFont;
        _notarialFees.text = @"公  证  费:  0元";
        [topView_bg addSubview:_notarialFees];
        
        // 委托办理产权手续费
        _delegationFee = [[UILabel alloc] init];
        _delegationFee.frame = CGRectMake(CGRectGetMaxX(_chartView.frame)+10, CGRectGetMaxY(_notarialFees.frame)+11, viewWidth*2/3-30, 13);
        _delegationFee.font = midFont;
        _delegationFee.text = @"委托办理产权手续费:  0元";
        [topView_bg addSubview:_delegationFee];
        
        // 房屋买卖手续费
        _dealFee = [[UILabel alloc] init];
        _dealFee.frame = CGRectMake(CGRectGetMaxX(_chartView.frame)+10, CGRectGetMaxY(_delegationFee.frame)+11, viewWidth*2/3-30, 13);
        _dealFee.font = midFont;
        _dealFee.text = @"房屋买卖手续费:  0元";
        [topView_bg addSubview:_dealFee];
        
        // 税金总额
        _totalFee = [[UILabel alloc] init];
        _totalFee.frame = CGRectMake(CGRectGetMaxX(_chartView.frame)+10, CGRectGetMaxY(_dealFee.frame)+11, viewWidth*2/3-30, 13);
        _totalFee.font = midFont;
        _totalFee.text = @"税金总额:  0元";
        [topView_bg addSubview:_totalFee];
        
        // 参考
        UILabel *reference = [[UILabel alloc] init];
        reference.frame = CGRectMake(10, CGRectGetMaxY(_dealFee.frame)+14, viewWidth/2, 10);
        reference.font = littleFont;
        reference.textColor = lgrayColor;
        reference.text = @"以上计算结果仅供参考";
        [topView_bg addSubview:reference];
        
        bottonView_bg = [[UIView alloc] init];
        [_index_scrollView addSubview:bottonView_bg];
        
//        _isResold? [self setupResoldHouse]:[self setupNewHouse];
        [self setupNewHouse];
    }
    return self;
}

- (void)setupNewHouse{
    NSLog(@"新房");
    
    for (int i=0; i<3; i++) {
        
        UILabel *division = [[UILabel alloc] init];
        division.frame = CGRectMake(0, i*45, viewWidth, 1);
        division.backgroundColor = divisionColor;
        [bottonView_bg addSubview:division];
    }
    
    // 面积
    _space = [[LabelTextfieldView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 45)];
    _space.titleLabel.font = midFont;
    _space.titleLabel.textColor = deepBLack;
    _space.titleLabel.text = @"面      积:";
    _space.textField.font = midFont;
    _space.textField.textColor = deepBLack;
    _space.textField.keyboardType = UIKeyboardTypeNumberPad;
    _space.textField.placeholder = @"请输入面积";
    [bottonView_bg addSubview:_space];
    
    UILabel *units1 = [[UILabel alloc] init];
    units1.frame = CGRectMake(viewWidth-60, 0, 50, 45);
    units1.textColor = deepBLack;
    units1.font = midFont;
    units1.textAlignment = NSTextAlignmentRight;
    units1.text = @"平米";
    [_space addSubview:units1];
    
    // 单价
    _unitPrice = [[LabelTextfieldView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_space.frame), viewWidth, 45)];
    _unitPrice.titleLabel.font = midFont;
    _unitPrice.titleLabel.textColor = deepBLack;
    _unitPrice.titleLabel.text = @"单      价:";
    _unitPrice.textField.font = midFont;
    _unitPrice.textField.textColor = deepBLack;
    _unitPrice.textField.keyboardType = UIKeyboardTypeNumberPad;
    _unitPrice.textField.placeholder = @"请输入单价";
    [bottonView_bg addSubview:_unitPrice];
    
    UILabel *units2 = [[UILabel alloc] init];
    units2.frame = CGRectMake(viewWidth-60, 0, 50, 45);
    units2.textColor = deepBLack;
    units2.font = midFont;
    units2.textAlignment = NSTextAlignmentRight;
    units2.text = @"元/平米";
    [_unitPrice addSubview:units2];
    
    // 开始计算
    _calculate = [UIButton buttonWithType:UIButtonTypeCustom];
    _calculate.frame = CGRectMake(30, CGRectGetMaxY(_unitPrice.frame)+30, viewWidth-60, 30);
    _calculate.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
    [_calculate setTitle:@"开始计算" forState:UIControlStateNormal];
    [_calculate setTitleColor:deepOrangeColor forState:UIControlStateNormal];
    [_calculate setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_calculate setBackgroundImage:[Tools_F imageWithColor:[UIColor whiteColor] size:CGSizeMake(viewWidth-60, 30)] forState:UIControlStateNormal];
    [_calculate setBackgroundImage:[Tools_F imageWithColor:deepOrangeColor size:CGSizeMake(viewWidth-60, 30)] forState:UIControlStateHighlighted];    [Tools_F setViewlayer:_calculate cornerRadius:4 borderWidth:1 borderColor:deepOrangeColor];
    [bottonView_bg addSubview:_calculate];
    
    bottonView_bg.frame = CGRectMake(0, CGRectGetMaxY(topView_bg.frame), viewWidth, CGRectGetMaxY(_calculate.frame)+60);
    _index_scrollView.contentSize=CGSizeMake(viewWidth, CGRectGetMaxY(bottonView_bg.frame));
    
}

//- (void)setupResoldHouse{
//    NSLog(@"2手房");
//    
//    for (int i=0; i<8; i++) {
//        
//        UILabel *division = [[UILabel alloc] init];
//        division.frame = CGRectMake(0, i*45, viewWidth, 1);
//        division.backgroundColor = divisionColor;
//        [bottonView_bg addSubview:division];
//    }
//    
//    // 物业类型
//    _propertyType = [[LabelTextfieldView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 45)];
//    _propertyType.titleLabel.font = midFont;
//    _propertyType.titleLabel.textColor = deepBLack;
//    _propertyType.titleLabel.text = @"物业类型:";
//    _propertyType.textField.font = midFont;
//    _propertyType.textField.textColor = deepBLack;
//    _propertyType.textField.textAlignment = NSTextAlignmentCenter;
//    _propertyType.textField.placeholder = @"普通住宅";
//    [bottonView_bg addSubview:_propertyType];
//    
//    // 计算方式
//    _calcWays = [[LabelTextfieldView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_propertyType.frame), viewWidth, 45)];
//    _calcWays.titleLabel.font = midFont;
//    _calcWays.titleLabel.textColor = deepBLack;
//    _calcWays.titleLabel.text = @"计算方式:";
//    _calcWays.textField.font = midFont;
//    _calcWays.textField.textColor = deepBLack;
//    _calcWays.textField.textAlignment = NSTextAlignmentCenter;
//    _calcWays.textField.placeholder = @"按总价计算";
//    [bottonView_bg addSubview:_calcWays];
//    
//    // 是否满五
//    _isFive = [[LabelTextfieldView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_calcWays.frame), viewWidth, 45)];
//    _isFive.titleLabel.font = midFont;
//    _isFive.titleLabel.textColor = deepBLack;
//    _isFive.titleLabel.frame = CGRectMake(10, 0, 109, 45);
//    _isFive.titleLabel.text = @"房产证是否满五年:";
//    _isFive.textField.enabled = NO;
//    [bottonView_bg addSubview:_isFive];
//    
//    // 是否首次
//    _isFirst = [[LabelTextfieldView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_isFive.frame), viewWidth, 45)];
//    _isFirst.titleLabel.font = midFont;
//    _isFirst.titleLabel.textColor = deepBLack;
//    _isFirst.titleLabel.frame = CGRectMake(10, 0, 82, 45);
//    _isFirst.titleLabel.text = @"是否首次购房:";
//    _isFirst.textField.enabled = NO;
//    [bottonView_bg addSubview:_isFirst];
//    
//    // 是否唯一
//    _isUnique = [[LabelTextfieldView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_isFirst.frame), viewWidth, 45)];
//    _isUnique.titleLabel.font = midFont;
//    _isUnique.titleLabel.textColor = deepBLack;
//    _isUnique.titleLabel.frame = CGRectMake(10, 0, 82, 45);
//    _isUnique.titleLabel.text = @"是否唯一住房:";
//    _isUnique.textField.enabled = NO;
//    [bottonView_bg addSubview:_isUnique];
//    
//    // 面积
//    _space = [[LabelTextfieldView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_isUnique.frame), viewWidth, 45)];
//    _space.titleLabel.font = midFont;
//    _space.titleLabel.textColor = deepBLack;
//    _space.titleLabel.text = @"面      积:";
//    _space.textField.font = midFont;
//    _space.textField.textColor = deepBLack;
//    _space.textField.placeholder = @"请输入面积";
//    [bottonView_bg addSubview:_space];
//    
//    // 单价
//    _unitPrice = [[LabelTextfieldView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_space.frame), viewWidth, 45)];
//    _unitPrice.titleLabel.font = midFont;
//    _unitPrice.titleLabel.textColor = deepBLack;
//    _unitPrice.titleLabel.text = @"单      价:";
//    _unitPrice.textField.font = midFont;
//    _unitPrice.textField.textColor = deepBLack;
//    _unitPrice.textField.placeholder = @"请输入单价";
//    [bottonView_bg addSubview:_unitPrice];
//    
//    // 开始计算
//    _calculate = [UIButton buttonWithType:UIButtonTypeCustom];
//    _calculate.frame = CGRectMake(30, CGRectGetMaxY(_unitPrice.frame)+30, viewWidth-60, 30);
//    _calculate.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
//    [_calculate setTitle:@"开始计算" forState:UIControlStateNormal];
//    [_calculate setTitleColor:deepOrangeColor forState:UIControlStateNormal];
//    [Tools_F setViewlayer:_calculate cornerRadius:4 borderWidth:1 borderColor:deepOrangeColor];
//    [bottonView_bg addSubview:_calculate];
//    
//    bottonView_bg.frame = CGRectMake(0, CGRectGetMaxY(topView_bg.frame), viewWidth, CGRectGetMaxY(_calculate.frame)+60);
//    _index_scrollView.contentSize=CGSizeMake(viewWidth, CGRectGetMaxY(bottonView_bg.frame));
//}

#pragma mark - indexSelected
//- (void)indexSelected:(UIButton *)sender{
//    
//    [bottonView_bg removeFromSuperview];
//    
//    if ((int)sender.tag == 100) {
//        _isResold = NO;
//    } else {
//        _isResold = YES;
//    }
//    
//    // 设置按钮选择状态
//    for ( UIButton *tempBtn in _index_scrollView.subviews) {
//        if (tempBtn.tag >99 && tempBtn.tag < 104) {
//            tempBtn.selected = NO;      // 全部设置未选中
//        }
//    }
//    
//    sender.selected = YES;          // 当前按钮设置选中
//    bottonView_bg = [[UIView alloc] init];
//    [_index_scrollView addSubview:bottonView_bg];
//    _isResold? [self setupResoldHouse]:[self setupNewHouse];
//
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
