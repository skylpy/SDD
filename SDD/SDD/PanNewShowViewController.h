//
//  PanNewShowViewController.h
//  SDD
//
//  Created by mac on 15/11/20.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "PanoShowViewController.h"
#import "XHBaseViewController.h"
@interface PanNewShowViewController : XHBaseViewController

//@property(assign, nonatomic) PanoShowType showType;
//
//@property (retain,nonatomic) NSNumber * latitude;//X坐标
//@property (retain,nonatomic) NSNumber * longitude;//Y坐标
//
//@property (retain,nonatomic) NSString * titleTStr; //标题
//加载失败之后的页面
- (void)showLoadfailedWithaction:(SEL)action;
@end
