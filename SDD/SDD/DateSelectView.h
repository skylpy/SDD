//
//  DateSelectView.h
//  SDD
//
//  Created by hua on 15/7/30.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateSelectView : UIView

@property (nonatomic, strong) UILabel *theTitle;
@property (nonatomic, strong) UIDatePicker *theDatePicker;
@property (nonatomic, strong) ConfirmButton *confirmButton;

@end
