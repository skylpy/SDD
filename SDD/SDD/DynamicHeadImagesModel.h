//
//  DynamicHeadImagesModel.h
//  SDD
//
//  Created by hua on 15/7/17.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DynamicHeadImagesModel : NSObject

@property (nonatomic, assign) NSInteger bannerId;
@property (nonatomic, strong) NSURL *bannerImage;
@property (nonatomic, assign) NSInteger objectId;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger sort;

@end
