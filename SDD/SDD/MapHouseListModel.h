//
//  MapHouseListModel.h
//  SDD
//
//  Created by mac on 15/10/30.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapHouseListModel : NSObject

@property (nonatomic,copy)NSArray *cities;
@property (nonatomic,copy)NSString *hasRent;
@property (nonatomic,copy)NSString *headChar;
@property (nonatomic,copy)NSArray *houseList;

@property (nonatomic,copy)NSString *houseQty;
@property (nonatomic,copy)NSString *isGps;
@property (nonatomic,copy)NSString *latitude;
@property (nonatomic,copy)NSString *longitude;
@property (nonatomic,copy)NSString *parentId;

@property (nonatomic,copy)NSString *regionId;
@property (nonatomic,copy)NSString *regionName;
@property (nonatomic,copy)NSString *type;


@end
