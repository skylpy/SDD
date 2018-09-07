//
//  HouseListFrame.m
//  SDD
//
//  Created by mac on 15/5/13.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "HouseListFrame.h"
#import "HouseListModel.h"

@implementation HouseListFrame

- (void)setListModel:(HouseListModel *)listModel
{
    _listModel = listModel;
    
    CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat X = 10;
    
    _titleFrame = CGRectMake(X, 2, cellWidth, 20);
    _subtitleFrame = CGRectMake(X, CGRectGetMaxY(_titleFrame), cellWidth, 20);
    
    
    
}

@end
