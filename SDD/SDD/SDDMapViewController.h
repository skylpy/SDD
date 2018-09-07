//
//  SDDMapViewController.h
//  SDD
//
//  Created by mac on 15/10/29.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBaseViewController.h"
//#import <BaiduMapAPI_Map/BMKMapComponent.h>
//#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
//#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
//#import <BaiduMapAPI_Location/BMKLocationService.h>
#import "BMapKit.h"
@interface SDDMapViewController : XHBaseViewController
//城市id
@property (nonatomic,assign)NSInteger regionId;

@property (nonatomic,assign)NSInteger type;


@property (nonatomic,assign)NSInteger industryCategoryId;


@property (nonatomic,assign)NSInteger typeCategoryId;


@property (nonatomic,assign)NSInteger smartSorting;


@property (nonatomic,assign)NSInteger projectNatureCategoryId;


@property (nonatomic,assign)NSInteger merchantsStatus;




@end
