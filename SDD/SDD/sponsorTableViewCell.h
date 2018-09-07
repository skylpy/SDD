//
//  sponsorTableViewCell.h
//  SDD
//
//  Created by hua on 15/10/14.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface sponsorTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, strong)UILabel *nameLable;
@property (nonatomic, strong)UILabel *chooseLable;
@property (nonatomic, strong)UITextField *textField;
@property (nonatomic, strong)UILabel *starLable;
//@property (nonatomic, strong)UILabel *mailLabel;

@end
