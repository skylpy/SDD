//
//  DevelopersViewController.h
//  SDD
//  开发商列表
//  Created by hua on 15/9/18.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "XHBaseViewController.h"

@interface DevelopersViewController : XHBaseViewController

// block
typedef void(^ReturnDevelopersInfo) (NSString *developerName,NSNumber *developerId);

@property (nonatomic, copy) ReturnDevelopersInfo returnBlock;
- (void)valueReturn:(ReturnDevelopersInfo)block;

@end
