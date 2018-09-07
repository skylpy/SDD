//
//  CertifySecondStep.h
//  ShopMoreAndMore
//
//  Created by mac on 15/7/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CertifyFirstStep.h"
@interface CertifySecondStep : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UITableView *positionTable;
@property (nonatomic, strong)NSMutableArray *positionArr;
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)CertifyFirstStep *certifyFirstS;

@property (nonatomic,retain)NSString * companyDescription;
@property (nonatomic,retain)NSMutableArray * dataArray1;
@property (nonatomic,retain)NSMutableArray * dataArray2;
@property (nonatomic,retain)NSMutableArray * dataArray3;
@property(nonatomic,assign)NSInteger typeCategoryId;
@property(nonatomic,assign)NSInteger projectNatureCategoryId;

@end
