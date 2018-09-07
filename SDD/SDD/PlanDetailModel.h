//
//  PlanDetailModel.h
//  SDD
//  业态平面图详情
//  Created by hua on 15/8/26.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlanDetailModel : NSObject

@property (nonatomic, assign) NSInteger houseId;      /**< 房子id */
@property (nonatomic, assign) NSInteger floorId;      /**< 楼层id */
@property (nonatomic, assign) NSInteger floor;        /**< 楼层 */
@property (nonatomic, assign) NSInteger buildingId;   /**< 建筑id */
@property (nonatomic, assign) float floorArea;        /**< 楼层面积 */

@property (nonatomic, strong) NSString *brandName;    /**< 入驻品牌名 */
@property (nonatomic, strong) NSString *formatName;   /**< 业态名 */
@property (nonatomic, strong) NSString *floorName;    /**< 楼栋名 */

@property (nonatomic, strong) NSURL *floorImage;      /**< 图片url */

@end
