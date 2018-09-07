//
//  MyCerSlideView.h
//  SDD
//
//  Created by mac on 15/8/13.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCerSlideView : UIView

@property (assign) NSInteger tabCount;
-(instancetype)initWithFrame:(CGRect)frame WithCount: (NSInteger) count;



@property (retain,nonatomic)UITableView * DeveloperTableView;
@property (retain,nonatomic)UITableView * BrandsTableView;
//@property (retain,nonatomic)UITableView * overdueTableView;

@end
