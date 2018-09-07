//
//  ButtonWithNumber.m
//  tempTest
//
//  Created by hua on 15/6/25.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ButtonWithNumber.h"
#import "Masonry.h"

@implementation ButtonWithNumber{
    
    CGRect _imageFrame;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    else {
        
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.titleLabel.numberOfLines = 1;
    
        return self;
    }
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state{
    
    [super setTitleColor:color forState:state];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state{
    
    [super setImage:image forState:state];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    CGFloat X = 0;
    CGFloat Y = 0;
    CGFloat imageW = 13;
    CGFloat imageH = contentRect.size.height;
    _imageFrame.size.width = imageW;
    return CGRectMake(X, Y, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    CGFloat titleH = contentRect.size.height ;
    CGFloat Y = 0;
    CGFloat titleW = contentRect.size.width;
    CGFloat X = CGRectGetMaxX(_imageFrame);
    return CGRectMake(X+8, Y, titleW, titleH);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
