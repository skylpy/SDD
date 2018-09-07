//
//  PlanModel.h
//  SDD
//  业态平面图列表
//  Created by hua on 15/8/26.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlanModel : NSObject

@property (nonatomic, assign) float buildingArea;       /**< 面积 */
@property (nonatomic, assign) NSInteger buildingId;     /**< 建筑id */
@property (nonatomic, strong) NSURL *buildingImage;     /**< 图片url */
@property (nonatomic, strong) NSString *buildingName;   /**< 楼栋名 */
@property (nonatomic, strong) NSString *formatName;     /**< 业态名 */
@property (nonatomic, assign) NSInteger houseId;        /**< 房子id */

@end
