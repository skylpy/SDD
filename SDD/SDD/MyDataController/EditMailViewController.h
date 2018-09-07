//
//  EditMailViewController.h
//  SDD
//  游戏修改
//  Created by hua on 15/8/20.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "XHBaseViewController.h"

@interface EditMailViewController : XHBaseViewController

// 用户名
@property (nonatomic, strong) NSString *theMail;
// block
typedef void(^ReturnMail) (NSString *theMail);

@property (nonatomic, copy) ReturnMail returnBlock;
- (void)valueReturn:(ReturnMail)block;

@end
