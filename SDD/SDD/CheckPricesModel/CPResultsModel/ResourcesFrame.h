//
//  ResourcesFrame.h
//  SDD
//
//  Created by JerryHe on 15/5/14.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ResourcesModel;
@interface ResourcesFrame : NSObject

@property (nonatomic, strong) ResourcesModel *resources;

@property (nonatomic, assign) CGRect imageViewFrame;
@property (nonatomic, assign) CGRect houseNameFrame;
@property (nonatomic, assign) CGRect addressFrame;
@property (nonatomic, assign) CGRect priceFrame;

@property (nonatomic, readonly) CGFloat CellHeight;


@end
