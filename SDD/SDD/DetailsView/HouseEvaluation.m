//
//  HouseEvaluation.m
//  SDD
//
//  Created by ; on 15/6/12.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "HouseEvaluation.h"

@implementation HouseEvaluation

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    else {
        
        self.clipsToBounds = YES;
        
        _evaluationTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, 270) style:UITableViewStyleGrouped];
        _evaluationTable.backgroundColor = bgColor;
        [self addSubview:_evaluationTable];
        
        // 在线评房table头
        UIView *evalutaionTopView = [[UIView alloc] init];
        evalutaionTopView.frame = CGRectMake(0, 0, viewWidth, 75);
        evalutaionTopView.backgroundColor = [UIColor whiteColor];
        
        _totalStar = [[CWStarRateView alloc] initWithFrame:CGRectMake(0, 10, viewWidth*0.7, 30) numberOfStars:5];
        _totalStar.scorePercent = 0.0f;
        _totalStar.userInteractionEnabled = NO;     // 只作显示用
        _totalStar.hasAnimation = YES;
        [evalutaionTopView addSubview:_totalStar];
        
        // 右分割线
        UIView *cutOff = [[UIView alloc] init];
        cutOff.frame = CGRectMake(CGRectGetMaxX(_totalStar.frame), 10, 1, 30);
        cutOff.backgroundColor = divisionColor;
        [self addSubview:cutOff];
        
        // 平均分
        _totalScore = [[UILabel alloc] init];
        _totalScore.frame = CGRectMake(CGRectGetMaxX(cutOff.frame), 0, viewWidth*0.3, 50);
        _totalScore.font = largeFont;
        _totalScore.textColor = tagsColor;
        _totalScore.text = @"0.0分";
        _totalScore.textAlignment = NSTextAlignmentCenter;
        [evalutaionTopView addSubview:_totalScore];
        
        _scoreDetail = [[UILabel alloc] init];
        _scoreDetail.frame = CGRectMake(10, CGRectGetMaxY(_totalStar.frame), viewWidth-20, 42);
        _scoreDetail.font = littleFont;
        _scoreDetail.textColor = lblueColor;
        _scoreDetail.text = @"价格0.0分 低端0.0分 配套0.0分 交通0.0分 政策0.0分 竞争0.0分";
        [evalutaionTopView addSubview:_scoreDetail];
        
        _evaluationTable.tableHeaderView = evalutaionTopView;
        
        // 在线评房table脚
        UIView *evaluation_Foot = [[UIView alloc] init];
        evaluation_Foot.frame = CGRectMake(0, 0, viewWidth, 65);
        evaluation_Foot.backgroundColor = [UIColor whiteColor];
        
        _evaluationButton = [UIButton buttonWithType:UIButtonTypeCustom];
        // 点评按钮
        _evaluationButton = [[ConfirmButton alloc] initWithFrame:CGRectMake(20, 10, viewWidth - 40, 45)
                                                           title:@"马上点评"
                                                          target:nil
                                                          action:nil];
        _evaluationButton.enabled = YES;
        
        [_evaluationButton setTitleColor:dblueColor forState:UIControlStateNormal];
        [_evaluationButton setBackgroundImage:[Tools_F imageWithColor:[UIColor whiteColor]
                                                    size:CGSizeMake(viewWidth-40, 45)]
                        forState:UIControlStateNormal];
        [evaluation_Foot addSubview:_evaluationButton];
        
        _evaluationTable.tableFooterView = evaluation_Foot;
        
        return self;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
