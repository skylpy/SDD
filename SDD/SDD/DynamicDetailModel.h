//
//  DynamicDetailModel.h
//  SDD
//
//  Created by hua on 15/7/17.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DynamicDetailModel : NSObject

@property (nonatomic, assign) NSInteger dynamicId;

@property (nonatomic, assign) NSInteger addTime;

@property (nonatomic, copy) NSString *author;

@property (nonatomic, assign) NSInteger dynamicCategoryId;

@property (nonatomic, assign) NSInteger lastUpdate;

@property (nonatomic, copy) NSDictionary *data;

@property (nonatomic, copy) NSString *detail;

@property (nonatomic, copy) NSString *comeFrom;

@property (nonatomic, assign) NSInteger topSort;

@property (nonatomic, copy) NSString *source;

@property (nonatomic, copy) NSString *summary;

@property (nonatomic, assign) NSInteger tag;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, assign) NSInteger isCollection;

@property (nonatomic, strong) NSURL *icon;


@end
