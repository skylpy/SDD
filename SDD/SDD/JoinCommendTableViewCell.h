//
//  JoinCommendTableViewCell.h
//  SDD
//  加盟详情 - 加盟点评cell
//  Created by hua on 15/6/26.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CWStarRateView.h"
#import "ButtonWithNumber.h"

@interface JoinCommendTableViewCell : UITableViewCell

//
@property (nonatomic, strong) UILabel *theName;
//
@property (nonatomic, strong) UIImageView *theAvatar;
//
@property (nonatomic, strong) CWStarRateView *theStar;
//
@property (nonatomic, strong) UILabel *theCommend;
//
@property (nonatomic, strong) UILabel *theTime;
//
@property (nonatomic, strong) UILabel *theAppraise;
//
@property (nonatomic, strong) ButtonWithNumber *theLike;

@end
