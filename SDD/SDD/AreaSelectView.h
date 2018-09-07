//
//  AreaSelectView.h
//  SDD
//
//  Created by Cola on 15/7/10.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AreaSelectView : UIView

@property (nonatomic, strong) UITableView *table;

@property (nonatomic, assign) NSInteger  typeId;

-(void)requestData:(NSInteger) typeIds;

@end
