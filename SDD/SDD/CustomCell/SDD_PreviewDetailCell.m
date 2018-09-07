//
//  SDD_PreviewDetailCell.m
//  ShopMoreAndMore
//
//  Created by mac on 15/7/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SDD_PreviewDetailCell.h"
#import "SDDColor.h"
@implementation SDD_PreviewDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *basicArr = [NSArray arrayWithObjects:@"参考均价:",@"参考租金:",@"招商状态节点:",@"开盘时间:",@"开业时间:",@"规划面积:",@"建筑面积:",@"业态规划:",@"项目类型:", nil];
        for (int i=0; i<basicArr.count; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 17+i*24, 80, 11)];
            label.text = basicArr[i];
            label.textColor = [SDDColor colorWithHexString:@"#999999"];
            label.font = [UIFont systemFontOfSize:12];
            [self addSubview:label];
            
            UILabel *contextLa = [[UILabel alloc] initWithFrame:CGRectMake(90,17+i*24, 230, 11)];
            contextLa.font = [UIFont systemFontOfSize:12];
            contextLa.numberOfLines = 0;
            contextLa.tag = 200+i;
            [self addSubview:contextLa];
        }
    }
    return self;
}
@end
