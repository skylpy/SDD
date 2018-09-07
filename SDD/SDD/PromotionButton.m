//
//  PromotionButton.m
//  sdd_iOS_personal
//
//  Created by hua on 15/4/6.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "PromotionButton.h"
#import "Tools_F.h"

@implementation PromotionButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
    
        // 大标题
        _topLabel = [[UILabel alloc] init];
        _topLabel.frame = CGRectMake(self.frame.size.height/5, self.frame.size.height/5, self.frame.size.width-self.frame.size.height, 16);
        _topLabel.font = largeFont;
        [self addSubview:_topLabel];
        
        // 小标题
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.frame = CGRectMake(self.frame.size.height/5, CGRectGetMaxY(_topLabel.frame)+6, self.frame.size.width-self.frame.size.height, 10);
        _bottomLabel.textColor = setColor(180, 180, 180, 1);
        _bottomLabel.font = midFont;
        [self addSubview:_bottomLabel];
        
        // icon
        _icon = [[UIImageView alloc] init];
        _icon.frame = CGRectMake(self.frame.size.width-self.frame.size.height*9/10, self.frame.size.height/10, self.frame.size.height*4/5, self.frame.size.height*4/5);
        _icon.clipsToBounds = YES;
        _icon.contentMode = UIViewContentModeScaleAspectFill;
//        [Tools_F setViewlayer:_icon cornerRadius:self.frame.size.height*2/5 borderWidth:0 borderColor:[UIColor clearColor]];
        _icon.backgroundColor = bgColor;
        [self addSubview:_icon];
        
    }
    return self;
}



@end
