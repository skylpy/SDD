//
//  AllPhotoViewController.h
//  SDD
//  项目相册
//  Created by hua on 15/5/12.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllPhotoViewController : XHBaseViewController

// 图片
@property (nonatomic, strong) NSDictionary *imageDict;
// 房子id
@property (nonatomic, strong) NSString *paramID;

/* 图片来源
 
 0：首页-团租
 1：首页-品牌
 */
typedef NS_ENUM(NSInteger, ImageFrom)
{
    Rent = 0,
    Brand = 1
};
@property (nonatomic, assign) ImageFrom imageFrom;

// block
typedef void(^ReturnImages) (NSArray *theValue);

@property (nonatomic, copy) ReturnImages returnBlock;
- (void)valueReturn:(ReturnImages)block;

@end
