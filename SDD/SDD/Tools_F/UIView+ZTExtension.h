//
//  UIView+ZTExtension.h
//  blockUseDemo
//
//  Created by 张杰 on 15/7/15.
//  Copyright (c) 2015年 张杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZTExtension)
@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic,assign) CGSize size;
@property (nonatomic,assign) CGPoint origin;

- (void)setCornerRadius:(CGFloat)radius;
@end
