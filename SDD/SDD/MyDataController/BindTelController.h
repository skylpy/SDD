//
//  BindTelController.h
//  SDD
//
//  Created by Cola on 15/4/18.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBaseViewController.h"

@interface BindTelController : XHBaseViewController

// 手机号
@property (nonatomic, strong) NSString *thePhoneNum;

// block
typedef void(^ReturnPhoneNum) (NSString *thePhoneNum);

@property (nonatomic, copy) ReturnPhoneNum returnBlock;
- (void)valueReturn:(ReturnPhoneNum)block;
@end
