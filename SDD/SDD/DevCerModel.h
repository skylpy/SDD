//
//  DevCerModel.h
//  SDD
//
//  Created by mac on 15/9/22.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DevCerModel : NSObject

@property (nonatomic,copy) NSNumber *projectNatureCategoryId;
@property (nonatomic,copy) NSString *categoryName;
@property (nonatomic,copy) NSString *sort;

@property (nonatomic,copy) NSNumber *industryCategoryId;

@property (nonatomic,copy) NSNumber *typeCategoryId;
@property (nonatomic,copy) NSNumber *postCategoryId;

//行业类别
@property (retain,nonatomic)NSArray * children;
@property (nonatomic,copy) NSNumber *parentId;
@end
