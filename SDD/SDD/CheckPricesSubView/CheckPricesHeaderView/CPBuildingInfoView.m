//
//  CPBuildingInfoView.m
//  SDD
//
//  Created by mac on 15/5/13.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "CPBuildingInfoView.h"
#import "CPResultsModel.h"

@implementation CPBuildingInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        
    }
    return self;
}

- (void)setResultsBuild:(CPResultsModel *)resultsBuild
{
    _resultsBuild = resultsBuild;
    
    [self addBuildingInfoView];
}

- (void)addBuildingInfoView
{
    CGFloat viewW = [UIScreen mainScreen].bounds.size.width;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewW, 40)];
    view.backgroundColor = [SDDColor sddbackgroundColor];
    [self addSubview:view];
    
    UILabel *labelView = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, viewW, 40)];
    labelView.text = @"楼房信息";
    labelView.textColor = [SDDColor sddMiddleTextColor];
    labelView.font = [UIFont systemFontOfSize:13];
    [view addSubview:labelView];
    
    UILabel *labelAverage = [[UILabel alloc]init];
    labelAverage.frame = CGRectMake(0, CGRectGetMaxY(view.frame) + 15, viewW * 0.52, 30);
    labelAverage.text = @"";
    labelAverage.textAlignment = NSTextAlignmentCenter;
    labelAverage.textColor = [SDDColor sddSmallTextColor];
    labelAverage.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:labelAverage];

    if (_resultsBuild.avgPrice) {
        NSString *tmpAvgPrice = [NSString stringWithFormat:@"楼房均价 %d元/平米", _resultsBuild.avgPrice.intValue];
        labelAverage.text = tmpAvgPrice;
    }else{
        
    }
    
    UIView *verticalLine = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(labelAverage.frame), CGRectGetMaxY(view.frame) + 10, 1, 36)];
    verticalLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:verticalLine];
    
    UILabel *foreMonthLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(verticalLine.frame)+10, CGRectGetMaxY(view.frame), viewW *0.38, 30)];
    foreMonthLable.text = @"";
    foreMonthLable.textAlignment = NSTextAlignmentCenter;
    foreMonthLable.textColor = [SDDColor sddSmallTextColor];
    foreMonthLable.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:foreMonthLable];
    
    if (_resultsBuild.foreMonth) {
        NSString *foreMonthTmp = [NSString stringWithFormat:@"环比上月 %@%%", _resultsBuild.foreMonth];
        foreMonthLable.text = foreMonthTmp;
    }else{
        
    }
    
    UILabel *foreYearLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(verticalLine.frame)+10, CGRectGetMaxY(foreMonthLable.frame)-3, viewW *0.38, 30)];
    foreYearLabel.text = @"";
    foreYearLabel.textAlignment = NSTextAlignmentCenter;
    foreYearLabel.textColor = [SDDColor sddSmallTextColor];
    foreYearLabel.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:foreYearLabel];
    
    if (_resultsBuild.foreYear) {
        NSString *foreYearTmp = [NSString stringWithFormat:@"同比去年 %@%%",_resultsBuild.foreYear];
        foreYearLabel.text = foreYearTmp;
    }else{
        
    }

    UIView *viewLine = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(verticalLine.frame) + 8, viewW-20, 1)];
    viewLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:viewLine];
    
    UILabel *regionNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(viewLine.frame),viewW*0.5, 30)];
    [self addSubview:regionNameLabel];
    regionNameLabel.text = @"";
    regionNameLabel.textAlignment = NSTextAlignmentLeft;
    regionNameLabel.textColor = [SDDColor sddSmallTextColor];
    regionNameLabel.font = [UIFont systemFontOfSize:12.0f];
    
    if (_resultsBuild.regionName) {
        NSString *regionNameTmp = [NSString stringWithFormat:@"所在区域: %@",_resultsBuild.regionName];
        regionNameLabel.text = regionNameTmp;
    }else{
        
    }
    
    UILabel *startTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(regionNameLabel.frame), CGRectGetMaxY(viewLine.frame),viewW*0.5, 30)];
    [self addSubview:startTimeLabel];
    startTimeLabel.text = @"";
    startTimeLabel.textAlignment = NSTextAlignmentCenter;
    startTimeLabel.textColor = [SDDColor sddSmallTextColor];
    startTimeLabel.font = [UIFont systemFontOfSize:12.0f];
    
    if (_resultsBuild.buildingStartTime) {
        NSString *buildingStartTimeTmp = [NSString stringWithFormat:@"建筑年代: %@",_resultsBuild.buildingStartTime];
        startTimeLabel.text = buildingStartTimeTmp;
    }else{
        
    }
    
    CGRect selfF = self.frame;
    selfF.size.height += CGRectGetMaxY(startTimeLabel.frame)+10;
    self.frame = selfF;


}

@end
