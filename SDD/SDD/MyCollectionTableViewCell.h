//
//  MyCollectionTableViewCell.h
//  SDD
//  我的品牌收藏cell
//  Created by hua on 15/7/2.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectionTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *brankName;
@property (nonatomic, strong) UILabel *investmentAmountCategoryName;
@property (nonatomic, strong) UILabel *industryCategoryName;
@property (nonatomic, strong) UILabel *storeAmount;
@property (nonatomic, strong) UILabel *time;

@end

