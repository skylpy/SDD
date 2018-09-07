//
//  ResourcesCell.m
//  SDD
//
//  Created by JerryHe on 15/5/14.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ResourcesCell.h"
#import "ResourcesFrame.h"
#import "ResourcesModel.h"


@interface ResourcesCell()
{
    UIImageView *_imageView;
    UILabel *_houesName;
    UILabel *_address;
    UILabel *_price;
}

@end
@implementation ResourcesCell


- (id)init{
    if (self = [super init]) {
        [self addCellSubView];
    }
    return self;
}

- (void)addCellSubView
{
    _imageView = [[UIImageView alloc]init];
    [self addSubview:_imageView];
    
    _houesName = [[UILabel alloc]init];
    _houesName.textColor = [SDDColor sddBigTextColor];
    _houesName.font = [UIFont systemFontOfSize:16.0f];
    [self addSubview:_houesName];
    
    _address = [[UILabel alloc]init];
    _address.textColor = [SDDColor sddMiddleTextColor];
    _address.font = [UIFont systemFontOfSize:13.0f];
    [self addSubview:_address];
    
    _price = [[UILabel alloc]init];
    _price.textColor = [SDDColor sddRedColor];
    _price.font = [UIFont systemFontOfSize:17.0f];
    [self addSubview:_price];
}

- (void)setResourcesFrame:(ResourcesFrame *)resourcesFrame
{
    _resourcesFrame = resourcesFrame;
    ResourcesModel *model = resourcesFrame.resources;
    
    _imageView.frame = resourcesFrame.imageViewFrame;
    [SDImageTool downloadImageURL:model.defaultImage Placeholder:nil ImageView:_imageView];
    
    _houesName.frame = resourcesFrame.houseNameFrame;
    _houesName.text = model.houseName;
    
    _address.frame = resourcesFrame.addressFrame;
    _address.text = model.address;
    
    _price.frame = resourcesFrame.priceFrame;
    _price.text = [NSString stringWithFormat:@"参考价:%@元/m²",model.price];
}

@end
