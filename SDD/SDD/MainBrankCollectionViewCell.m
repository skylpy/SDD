//
//  MainBrankCollectionViewCell.m
//  SDD
//
//  Created by hua on 15/8/3.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "MainBrankCollectionViewCell.h"

@implementation MainBrankCollectionViewCell

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _mainButton = [MainBrankButton buttonWithType:UIButtonTypeCustom];
        _mainButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _mainButton.titleLabel.font = largeFont;
        _mainButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [Tools_F setViewlayer:_mainButton.imageView cornerRadius:0 borderWidth:1 borderColor:divisionColor];
        [_mainButton setTitleColor:lgrayColor forState:UIControlStateNormal];
        
        [self addSubview:_mainButton];
        [_mainButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

@end
