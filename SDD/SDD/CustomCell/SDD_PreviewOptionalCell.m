//
//  SDD_PreviewOptionalCell.m
//  ShopMoreAndMore
//
//  Created by mac on 15/7/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SDD_PreviewOptionalCell.h"
#import "SDDColor.h"
@implementation SDD_PreviewOptionalCell

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
        NSArray *basicArr = [NSArray arrayWithObjects:@"项目性质:",@"开工时间:",@"产权年限:",@"公摊率:",@"绿化率:",@"容积率:",@"物业数量:",@"地上停车位:",@"地下停车位:",@"周边竞品资料:",@"周边商户对项目评价:", nil];
        for (int i=0; i<basicArr.count; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 17+i*24, 115, 11)];
            label.text = basicArr[i];
            label.textColor = [SDDColor colorWithHexString:@"#999999"];
            label.font = [UIFont systemFontOfSize:12];
            [self addSubview:label];
            
            UILabel *contextLa = [[UILabel alloc] initWithFrame:CGRectMake(125,17+i*24, 195, 11)];
            contextLa.font = [UIFont systemFontOfSize:12];
            contextLa.numberOfLines = 0;
            contextLa.tag = 300+i;
            [self addSubview:contextLa];
        }
    }
    return self;
}
@end
