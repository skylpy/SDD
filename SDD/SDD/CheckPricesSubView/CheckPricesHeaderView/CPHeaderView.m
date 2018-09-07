//
//  CPHeaderView.m
//  SDD
//
//  Created by mac on 15/5/13.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "CPHeaderView.h"
#import "CPResultsModel.h"

@interface CPHeaderView()

@end


@implementation CPHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        
    }
    return self;
}

- (void)setResultsM:(CPResultsModel *)resultsM
{
    _resultsM = resultsM;
    
    [self addDetailHeaderView];
    
}

- (void)addDetailHeaderView
{
    CGFloat viewW = [UIScreen mainScreen].bounds.size.width;
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 10, viewW, 30);
    label.text = @"系统评估价";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [SDDColor sddSmallTextColor];
    label.font = [UIFont systemFontOfSize:16.0f];
    [self addSubview:label];
    
    UILabel *totalPrice = [[UILabel alloc]init];
    totalPrice.frame = CGRectMake(0, CGRectGetMaxY(label.frame), viewW, 30);
    totalPrice.text = @"";
    totalPrice.textAlignment = NSTextAlignmentCenter;
    totalPrice.textColor = [SDDColor sddRedColor];
    totalPrice.font = [UIFont systemFontOfSize:28.0f];
    [self addSubview:totalPrice];
    
    if (_resultsM.totalPrice) {
        NSString *tmpStr = [NSString stringWithFormat:@"%d万", _resultsM.totalPrice.intValue / 10000];
        totalPrice.text = tmpStr;
    }else{

    }
    
    UILabel *avgPrice = [[UILabel alloc]init];
    avgPrice.frame = CGRectMake(0, CGRectGetMaxY(totalPrice.frame), viewW, 30);
    avgPrice.text = @"";
    avgPrice.textAlignment = NSTextAlignmentCenter;
    avgPrice.textColor = [SDDColor sddSmallTextColor];
    avgPrice.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:avgPrice];
    
    if (_resultsM.avgPrice) {
        NSString *tmpAvgPrice = [NSString stringWithFormat:@"%d元/平米", _resultsM.avgPrice.intValue];
        avgPrice.text = tmpAvgPrice;
    }else{
        
    }
    
    UILabel *firstPay = [[UILabel alloc]init];
    firstPay.frame = CGRectMake(50, CGRectGetMaxY(avgPrice.frame), 90, 30);
    firstPay.text = @"";
    firstPay.textAlignment = NSTextAlignmentCenter;
    firstPay.textColor = [SDDColor sddSmallTextColor];
    firstPay.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:firstPay];

    if (_resultsM.firstPay) {
        NSString *tmpfirstPay = [NSString stringWithFormat:@"首付 %d万", _resultsM.firstPay.intValue / 10000];
        firstPay.text = tmpfirstPay;
    }else{
        
    }

    UILabel *monthPay = [[UILabel alloc]init];
    monthPay.frame = CGRectMake(CGRectGetMaxX(firstPay.frame), firstPay.frame.origin.y, 150, 30);
    monthPay.text = @"";
    monthPay.textAlignment = NSTextAlignmentCenter;
    monthPay.textColor = [SDDColor sddSmallTextColor];
    monthPay.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:monthPay];
    
    if (_resultsM.monthPay) {
        NSString *tmpmonthPay = [NSString stringWithFormat:@"月供 %d元", _resultsM.monthPay.intValue];
        monthPay.text = tmpmonthPay;
    }else{
        
    }
    
    CGRect selfF = self.frame;
    selfF.size.height += CGRectGetMaxY(monthPay.frame)+10;
    self.frame = selfF;

}

@end
