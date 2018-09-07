//
//  SDD_DetailValueCell.h
//  ShopMoreAndMore
//
//  Created by mac on 15/7/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDD_DetailValueCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic, strong)UILabel *nameLable;
@property (nonatomic, strong)UILabel *chooseLable;
@property (nonatomic, strong)UITextField *textField;
@property (nonatomic, strong)UILabel *starLable;
@end
