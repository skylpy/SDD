//
//  MyReviewTableViewCell.h
//  SDD
//  我的点评cell
//  Created by hua on 15/7/2.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWStarRateView.h"

@interface MyReviewTableViewCell : UITableViewCell

//
@property (nonatomic, strong) UIImageView *imgView;
// 
@property (nonatomic, strong) UILabel *brankName;
//
@property (nonatomic, strong) CWStarRateView *theStar;
//
@property (nonatomic, strong) UILabel *theAppraise;

@end
