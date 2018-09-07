//
//  GetCouponTableViewCell.h
//  SDD
//
//  Created by hua on 15/7/23.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPlaceholderTextView.h"

@interface GetCouponTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *theTitle;                     /**< 表格标题 */
@property (nonatomic, strong) UILabel *theSelected;                  /**< 选择 */
@property (nonatomic, strong) LPlaceholderTextView *theTextView;     /**< text */

/* 表格类型
 
 0：什么都没
 1：textview
 2：弹出选择
 3：单选
 */
typedef NS_ENUM(NSInteger, CellType)
{
    nothing = 0,
    withTextView = 1,
    withLabel = 2,
    withShortTextView = 3,
    withLongTextView = 4,
};

@property (nonatomic, assign) CellType cellType;

@end