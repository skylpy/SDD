//
//  MyPublishTableViewCell.h
//  SDD
//
//  Created by hua on 15/7/4.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPublishTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *publishStatus;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *brankName;
@property (nonatomic, strong) UILabel *investmentAmountCategoryName;
@property (nonatomic, strong) UILabel *industryCategoryName;
@property (nonatomic, strong) UILabel *storeAmount;
@property (nonatomic, assign) BOOL isNotPass;

@end
