//
//  ThemeApplyCell.h
//  SDD
//
//  Created by mac on 15/8/19.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeApplyCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic, strong)UILabel *nameLable;
@property (nonatomic, strong)UILabel *chooseLable;
@property (nonatomic, strong)UITextField *textField;
@property (nonatomic, strong)UILabel *starLable;

@property (nonatomic, strong)UILabel *MchooseLable;
@end
