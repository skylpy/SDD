//
//  PanoShowViewController.h
//  PanoramaViewDemo
//
//  Created by baidu on 15/4/10.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBaseViewController.h"

typedef enum : NSUInteger {
    PanoShowTypePID,
    PanoShowTypeGEO,
    PanoShowTypeXY,
} PanoShowType;
@interface PanoShowViewController : XHBaseViewController

@property(assign, nonatomic) PanoShowType showType;

@property (retain,nonatomic) NSNumber * latitude;//X坐标
@property (retain,nonatomic) NSNumber * longitude;//Y坐标

@property (retain,nonatomic) NSString * titleTStr; //标题

@end
