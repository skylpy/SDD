//
//  CategoryContentListModel.h
//  SDD
//  资讯栏目内容
//  Created by hua on 15/7/16.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryContentListModel : NSObject

@property (nonatomic, assign) NSInteger dynamicId;
@property (nonatomic, assign) NSInteger addTime;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, assign) NSInteger dynamicCategoryId;
@property (nonatomic, copy) NSString *comeFrom;
@property (nonatomic, strong) NSURL *icon;
@property (nonatomic, assign) NSInteger lastUpdate;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *realName;

@end
