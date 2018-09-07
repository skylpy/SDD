//
//  CPPCell.m
//  SDD
//
//  Created by mac on 15/5/13.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "CPPCell.h"
#import "HouseListModel.h"
#import "HouseListFrame.h"

@implementation CPPCell
{
    UILabel *_title;
    UILabel *_subTitle;
}

- (id)init{
    if (self = [super init]) {
        [self addCellSubView];
    }
    return self;
}

- (void)addCellSubView
{
    _title = [[UILabel alloc]init];
    _title.textColor = [UIColor blackColor];
    _title.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:_title];
    
    _subTitle = [[UILabel alloc]init];
    _subTitle.textColor = [UIColor lightGrayColor];
    _subTitle.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:_subTitle];
}

- (void)setListFrame:(HouseListFrame *)listFrame
{
    _listFrame = listFrame;
    
    HouseListModel *listModel = listFrame.listModel;
    
    _title.frame = listFrame.titleFrame;
    _title.text  = listModel.houseName;
    
    _subTitle.frame = listFrame.subtitleFrame;
    _subTitle.text  = listModel.address;

}

@end
