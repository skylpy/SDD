//
//  SDDButton.m
//  LTButton
//
//  Created by mac on 15/5/22.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SDDButton.h"

#define kTitleRatio 0.8


@implementation SDDButton

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:lgrayColor forState:UIControlStateHighlighted];
        [self setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"icon_back_gray"] forState:UIControlStateHighlighted];
        
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        
        self.titleLabel.font = biggestFont;
        
        self.imageView.contentMode = UIViewContentModeLeft;
        
        self.titleLabel.textColor = [UIColor whiteColor];
        
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        self.titleLabel.numberOfLines = 1;
    }
    return self;
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state{
    
    [super setTitleColor:color forState:state];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state{
    
    [super setImage:image forState:state];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat X = 0;
    CGFloat Y = 0;
    CGFloat imageW = 25;
    CGFloat imageH = contentRect.size.height;
    _imageFrame.size.width = imageW;
    return CGRectMake(X, Y, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    
    CGFloat titleH = contentRect.size.height ;
    CGFloat Y = 0;
    CGFloat titleW = contentRect.size.width;
    CGFloat X = CGRectGetMaxX(_imageFrame);
    return CGRectMake(X, Y, titleW, titleH);

}

@end
