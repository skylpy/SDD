//
//  CalcDetailViewController.h
//  SDD
//  计算机 ——— 首付比例、按揭年数、利率等选择页面       by方
//  Created by hua on 15/5/6.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalcDetailViewController : UIViewController

/* 类型    
    0:  首付比例
    1:  按揭年数
    2:  利率
 */
@property (nonatomic, assign) int detailType;

@property (nonatomic, strong) NSString *thePlaceholder;

// block
typedef void(^ReturnValueblocks) (NSString *theValue,NSInteger theIndex);

@property (nonatomic, copy) ReturnValueblocks returnBlock;
- (void)valueReturn:(ReturnValueblocks)block;

@end
