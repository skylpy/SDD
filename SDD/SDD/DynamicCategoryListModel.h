//
//  DynamicCategoryListModel.h
//  SDD
//  资讯栏目
//  Created by hua on 15/7/16.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DynamicCategoryListModel : NSObject

@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, assign) NSInteger dynamicCategoryId;
@property (nonatomic, assign) NSInteger sort;
@property (nonatomic, strong) NSURL *url;

@end
