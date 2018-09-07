//
//  NoDataTips.h
//  SDD
//
//  Created by hua on 15/8/21.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoDataTips : UIView

- (void)setText:(NSString *)text
    buttonTitle:(NSString *)title
      buttonTag:(NSInteger)theTag
         target:(id)target
         action:(SEL)action;

- (void)setText:(NSString *)text;
@end
