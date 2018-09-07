//
//  HouseConsultant.m
//  SDD
//  
//  Created by hua on 15/6/12.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "HouseConsultant.h"

@implementation HouseConsultant

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    else {
        
        self.clipsToBounds = YES;
        
        _consultantTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, 210) style:UITableViewStyleGrouped];
        _consultantTable.backgroundColor = bgColor;
        [self addSubview:_consultantTable];
        
        return self;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
