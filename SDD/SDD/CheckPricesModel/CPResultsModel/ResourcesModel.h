//
//  ResourcesModel.h
//  SDD
//
//  Created by JerryHe on 15/5/14.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResourcesModel : NSObject

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *houseId;
@property (nonatomic, strong) NSString *houseName;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *defaultImage;

- (id)initWithResourcesDict:(NSDictionary *)dict;
@end
