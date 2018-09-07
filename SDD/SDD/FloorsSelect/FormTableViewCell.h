//
//  FormTableViewCell.h
//  SDD
//  表格
//  Created by hua on 15/9/14.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPlaceholderTextView.h"

@interface FormTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *theTitle;                            /**< 表格标题 */
@property (nonatomic, strong) UILabel *theSelected;                         /**< 选择 */
@property (nonatomic, strong) UITextField *theSingleDetail;                  /**< 详情text */
@property (nonatomic, strong) LPlaceholderTextView *theMultipleDetail;      /**< 长详情text */
@property (nonatomic, strong) UIButton *getCode;                            /**< 验证码 */
@property (nonatomic, strong) UILabel *theUnits;                            /**< 单位 */
@property (nonatomic, strong) UIImageView *theIcon;                         /**< icon */

/* 表格
 
 0：什么都没
 1：详情
 2：选择内容
 3：短详情【用于加验证码按钮
 4：长详情【可换行
 5：右侧单位
 6：右侧icon
 
 */
typedef NS_ENUM(NSInteger, CellType)
{
    nothing = 0,
    withTextView = 1,
    withLabel = 2,
    withShortTextView = 3,
    withLongTextView = 4,
    withUnits = 5,
    withIcon = 6,
};

@property (nonatomic, assign) CellType cellType;

@end
