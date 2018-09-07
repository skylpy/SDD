//
//  NearAndSimilarViewController.h
//  商多多
//  团购、团租、房源 -> 同类、周边项目列表
//  Created by hua on 15/4/9.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearAndSimilarViewController : UIViewController

// 标题
@property (nonatomic, retain) NSString *nasTitle;
// 房子id
@property (nonatomic, strong) NSString *houseID;
// 推荐类型
typedef NS_ENUM(NSInteger, RecommendType){
    
    similars = 0,
    near = 1,
    buy = 2,
    rent = 3
};
@property (nonatomic, assign) RecommendType recommendType;

@end
