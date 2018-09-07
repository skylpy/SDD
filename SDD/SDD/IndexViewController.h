//
//  IndexViewController.h
//  sdd_iOS_personal
//  首页
//  Created by hua on 15/4/3.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"

@interface IndexViewController : UIViewController<BMKLocationServiceDelegate>{
    
    BMKLocationService *locService;
}


@end
