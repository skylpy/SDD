//
//  VIPhotoView.h
//  VIPhotoViewDemo
//  图片缩放功能
//  Created by Vito on 1/7/15.
//  Copyright (c) 2015 vito. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VIPhotoViewDelegate

- (void)moving:(BOOL)isMoving;

@end

@interface VIPhotoView : UIScrollView

- (instancetype)initWithFrame:(CGRect)frame andImageView:(UIImageView *)imageView;
@property (assign, nonatomic) id<VIPhotoViewDelegate>movingDelegate;

- (void)updateImageSize:(CGSize)size;

@end