//
//  JoinPDropDownMenu.m
//  SDD
//  加盟里的筛选菜单
//  Created by Cola on 15/7/9.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "JoinPDropDownMenu.h"
@interface JoinPDropDownMenu()
{
    
}

//位置选择模块
@property(nonatomic) UIView* mLocation;
@end

@implementation JoinPDropDownMenu

#pragma mark - gesture handle
- (void)menuTapped:(UITapGestureRecognizer *)paramSender {
    
    if (super.dataSource == nil) {
        return;
    }
    CGPoint touchPoint = [paramSender locationInView:self];
    //calculate index
    NSInteger tapIndex = touchPoint.x / (self.frame.size.width / super.numOfMenu);
    for (int i = 0; i < super.numOfMenu; i++) {
        if (i != tapIndex) {
            [self animateIndicator:super.indicators[i] Forward:NO complete:^{
                [self animateTitle:super.titles[i] show:NO complete:^{
                    
                }];
            }];
        }
    }
    
    if (tapIndex == super.currentSelectedMenudIndex && super.show) {

        [self animateIdicator:super.indicators[super.currentSelectedMenudIndex] background:super.backGroundView tableView:super.leftTableView title:super.titles[super.currentSelectedMenudIndex] forward:NO complecte:^{
            super.currentSelectedMenudIndex = tapIndex;
            super.show = NO;
        }];
    } else {
        
        [_mLocation removeFromSuperview];
        super.currentSelectedMenudIndex = tapIndex;
        [super.leftTableView reloadData];
        if (super.dataSource && _dataSourceFlags.numberOfItemsInRow) {
            [super.rightTableView reloadData];
        }
        
        [self animateIdicator:super.indicators[tapIndex] background:super.backGroundView tableView:super.leftTableView title:super.titles[tapIndex] forward:YES complecte:^{
            super.show = YES;
        }];
    }
}

- (void)animateTableView:(UITableView *)tableView show:(BOOL)show complete:(void(^)())complete {
    
    BOOL haveItems = NO;
    
    if (super.dataSource) {
        NSInteger num = [super.leftTableView numberOfRowsInSection:0];
        
        for (NSInteger i = 0; i<num;++i) {
            if (_dataSourceFlags.numberOfItemsInRow
                && [super.dataSource menu:self numberOfItemsInRow:i column:super.currentSelectedMenudIndex] > 0) {
                haveItems = YES;
                break;
            }
        }
    }
    
    if (show) {
        if (haveItems) {
            super.leftTableView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width/2, 0);
            super.rightTableView.frame = CGRectMake(self.origin.x + self.frame.size.width/2, self.frame.origin.y + self.frame.size.height, self.frame.size.width/2, 0);
            [self.superview addSubview:super.leftTableView];
            [self.superview addSubview:super.rightTableView];
            
            if(super.moreSelectModel && super.moreSelectPosition == super.currentSelectedMenudIndex){
                super.moreContainer.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, kButtomMoreAreaHeight);
                [self.superview addSubview:super.moreContainer];
            }
        } else {
            if (super.currentSelectedMenudIndex == 0) {
                _mLocation.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.superview.bounds.size.height - 100);
                [self.superview addSubview:_mLocation];
            }else{
            super.leftTableView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0);
//            super.rightTableView.frame = CGRectMake(self.origin.x + self.frame.size.width/2, self.frame.origin.y + self.frame.size.height, self.frame.size.width/2, 0);
            
            [self.superview addSubview:super.leftTableView];
            }
        }
        
        NSInteger num = [super.leftTableView numberOfRowsInSection:0];
        CGFloat tableViewHeight = num * kTableViewCellHeight > kTableViewHeight+1 ? kTableViewHeight:num*kTableViewCellHeight+1;
        
        [UIView animateWithDuration:0.2 animations:^{
            if (haveItems) {
                super.leftTableView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width/2, tableViewHeight);
                
                super.rightTableView.frame = CGRectMake(self.origin.x + self.frame.size.width/2, self.frame.origin.y + self.frame.size.height, self.frame.size.width/2, tableViewHeight);
                
                if(super.moreSelectPosition == super.currentSelectedMenudIndex)
                super.moreContainer.frame = CGRectMake(self.origin.x, CGRectGetMaxY(super.leftTableView.frame)-2, self.frame.size.width, kButtomMoreAreaHeight);
                else if([super.moreContainer superview]){
                    [super.moreContainer removeFromSuperview];
                }
            } else {
                super.leftTableView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, tableViewHeight);
            }

        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            if (haveItems) {
                super.leftTableView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width/2, 0);
                
                super.rightTableView.frame = CGRectMake(self.origin.x + self.frame.size.width/2, self.frame.origin.y + self.frame.size.height, self.frame.size.width/2, 0);
            } else {
                super.leftTableView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0);
            }

        } completion:^(BOOL finished) {
            if (super.rightTableView.superview) {
                [super.rightTableView removeFromSuperview];
                
            }
            [super.moreContainer removeFromSuperview];
            [super.leftTableView removeFromSuperview];
            [super.buttomImageView removeFromSuperview];
            [_mLocation removeFromSuperview];
        }];
    }
    complete();
}

//- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height
//{
//    _moreContainer = [[UIView alloc] init];
//    _moreContainer.bounds = CGRectMake(0, 0, self.bounds.size.width, kButtomMoreAreaHeight);
//    _moreContainer.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    return  [super initWithOrigin:origin andHeight:height];
//}

-(void)setLocation:(UIView *) location;
{
    _mLocation = location;
}
@end
