//
//  SDD_TextViewCell.h
//  ShopMoreAndMore
//
//  Created by mac on 15/7/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPlaceholderTextView.h"
@interface SDD_TextViewCell : UITableViewCell
@property (nonatomic, strong)UILabel    *label;
@property (nonatomic, strong)LPlaceholderTextView *textView;
@end
