//
//  AreaSelectionViewController.h
//  SDD
//  地区选择
//  Created by hua on 15/4/25.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface AreaSelectionViewController : XHBaseViewController<BMKLocationServiceDelegate>{
    
    BMKLocationService *locService;
}
@property (retain,nonatomic)NSString * currentCity;
@end
