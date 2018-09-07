//
//  HouseListFrame.h
//  SDD
//
//  Created by mac on 15/5/13.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HouseListModel;
@interface HouseListFrame : NSObject

@property (nonatomic, strong) HouseListModel *listModel;

@property (nonatomic, readonly) CGRect titleFrame;
@property (nonatomic, readonly) CGRect subtitleFrame;

@property (nonatomic, readonly) CGFloat CellHeight;

@end
