//
//  BaseScrollView.m
//  SDD
//
//  Created by Cola on 15/5/5.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "UIScrollView+UITouch.h"

@implementation UIScrollView(UITouch)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"touchesEnded %@",@"touchesEnded");
    [[self nextResponder]touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //if(!self.dragging)
//    {
        [[self nextResponder] touchesMoved:touches withEvent:event];
//    }
    [super touchesMoved:touches withEvent:event];
}

@end
