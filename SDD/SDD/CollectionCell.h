//
//  CollectionCell.h
//  SDD
//
//  Created by mac on 15/12/8.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttongood;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
//@property (weak, nonatomic) IBOutlet UILabel *numberlabel1;
@property (weak, nonatomic) IBOutlet UIImageView *iconimage;
@property (weak, nonatomic) IBOutlet UIImageView *iconimage1;
@property (weak, nonatomic) IBOutlet UILabel *numberlabel1;

@end
