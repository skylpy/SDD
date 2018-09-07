//
//  SDD_UpLoadData.h
//  ShopMoreAndMore
//
//  Created by mac on 15/7/4.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHBaseViewController.h"

@interface SDD_UpLoadData : XHBaseViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
//    UIImageView * userAvatar;
    int  imageNumber;
    UIView *bgView;
    NSString *positionStr;
}
//@property( assign, nonatomic ) id< SDD_UpLoadDatadelegate > delegate;

//第一个界面的数组
@property (retain,nonatomic)NSMutableArray * BasicArray;

//第二个界面的数组
@property (retain,nonatomic)NSMutableArray * DetailsArray;


//第四个界面
@property (retain,nonatomic)NSArray * friArray;
@property (retain,nonatomic)NSArray * secArray;
@property (retain,nonatomic)NSArray * thrArray;
@property (retain,nonatomic)NSArray * fourArray;

@end
