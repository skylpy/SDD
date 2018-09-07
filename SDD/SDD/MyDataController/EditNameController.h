//
//  EditNameController.h
//  SDD
//
//  Created by Cola on 15/4/18.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBaseViewController.h"

@interface EditNameController : XHBaseViewController

// 用户名
@property (nonatomic, strong) NSString *theNickname;
// block
typedef void(^ReturnNickname) (NSString *theName);

@property (nonatomic, copy) ReturnNickname returnBlock;
- (void)valueReturn:(ReturnNickname)block;

@end
