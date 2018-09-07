//
//  ResourcesFrame.m
//  SDD
//
//  Created by JerryHe on 15/5/14.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ResourcesFrame.h"

@implementation ResourcesFrame

- (void)setResources:(ResourcesModel *)resources
{
    _resources = resources;
    
    CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat X = 10;
    CGFloat Y = 10;
    
    _imageViewFrame = CGRectMake(X, Y, 68, 60);
    
    _houseNameFrame = CGRectMake(CGRectGetMaxX(_imageViewFrame)+6, Y, cellWidth - 80, 16);
    
    _addressFrame = CGRectMake(_houseNameFrame.origin.x, CGRectGetMaxY(_houseNameFrame)+4, cellWidth - 80, 16);
    
    _priceFrame = CGRectMake(_houseNameFrame.origin.x, CGRectGetMaxY(_addressFrame)+8, cellWidth - 80, 16);
  
}

@end
