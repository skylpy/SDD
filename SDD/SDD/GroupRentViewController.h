//
//  GroupRentViewController.h
//  SDD
//  新项目团租
//  Created by hua on 15/4/13.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AreaSelectView.h"
@interface GroupRentViewController : XHBaseViewController

@property (assign,nonatomic) NSInteger activityCategoryId;
@property (assign,nonatomic) NSInteger regionId;

@property (retain,nonatomic)AreaSelectView * delegate;



//哪个界面传递
@property (nonatomic,assign)NSInteger deliverInt;
@end
