//
//  SDImageTool.m
//  oniontrip
//
//  Created by Mac on 15-4-22.
//  Copyright (c) 2015年 LVTU. All rights reserved.
//

#import "SDImageTool.h"
#import "UIImageView+WebCache.h"

@implementation SDImageTool

+ (void)downloadImageURL:(NSString *)url Placeholder:(UIImage *)place ImageView:(UIImageView *)imageView
{
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:place options:SDWebImageRetryFailed | SDWebImageHighPriority];
}

+ (void)clear
{
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
}

+ (void)cancelDownload
{
    [[SDWebImageManager sharedManager] cancelAll];
}

@end
