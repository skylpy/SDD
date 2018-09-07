//
//  IntegralRecordSlide.h
//  SDD
//
//  Created by mac on 15/12/1.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntegralRecordSlide : UIView

@property (assign) NSInteger tabCount;
-(instancetype)initWithFrame:(CGRect)frame WithCount: (NSInteger) count;



@property (retain,nonatomic)UITableView * GainTableView;
@property (retain,nonatomic)UITableView * EmployTableView;

@end
