//
//  JoinContactTableViewCell.m
//  SDD
//
//  Created by hua on 15/6/25.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "JoinContactTableViewCell.h"

@implementation JoinContactTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        _peopleName = [[UILabel alloc] init];
        _peopleName.font = largeFont;
        [self addSubview:_peopleName];
        
        _peoplePosition = [[UILabel alloc] init];
        _peoplePosition.font = midFont;
        _peoplePosition.textColor = lgrayColor;
        [self addSubview:_peoplePosition];
        
        _peopleRegion = [[UILabel alloc] init];
        _peopleRegion.font = midFont;
        _peopleRegion.textColor = lgrayColor;
        [self addSubview:_peopleRegion];
        
        UIImageView *telIcon = [[UIImageView alloc] init];
        telIcon.image = [UIImage imageNamed:@"join_detail-pages_icon_tel"];
        [self addSubview:telIcon];
        
        _peopleTel = [[UILabel alloc] init];
        _peopleTel.font = midFont;
        [self addSubview:_peopleTel];
        
        UIImageView *mobileNumIcon = [[UIImageView alloc] init];
        mobileNumIcon.image = [UIImage imageNamed:@"join_detail-pages_icon_cellphone"];
        [self addSubview:mobileNumIcon];
        
        _peopleMobileNum = [[UILabel alloc] init];
        _peopleMobileNum.font = midFont;
        [self addSubview:_peopleMobileNum];
        
        UIImageView *emailIcon = [[UIImageView alloc] init];
        emailIcon.image = [UIImage imageNamed:@"join_detail-pages_icon_mailbox"];
        [self addSubview:emailIcon];
        
        _peopleEmail = [[UILabel alloc] init];
        _peopleEmail.font = midFont;
        [self addSubview:_peopleEmail];
        
        UIImageView *addressIcon = [[UIImageView alloc] init];
        addressIcon.image = [UIImage imageNamed:@"join_detail-pages_icon_site"];
        [self addSubview:addressIcon];
        
        _peopleAddress = [[UILabel alloc] init];
        _peopleAddress.font = midFont;
        [self addSubview:_peopleAddress];
        
        [_peopleName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(50);
            make.left.equalTo(self.mas_left).with.offset(12.5);
            //            make.right.equalTo(telIcon.mas_left).with.offset(-12.5);
            make.height.equalTo(@16);
        }];
        
        [_peoplePosition mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_peopleName.mas_bottom).with.offset(6);
            make.left.equalTo(self.mas_left).with.offset(12.5);
            //            make.right.equalTo(telIcon.mas_left).with.offset(-12.5);
            make.height.equalTo(@13);
        }];
        
        [_peopleRegion mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).with.offset(-50);
            make.left.equalTo(self.mas_left).with.offset(12.5);
            //            make.right.equalTo(telIcon.mas_left).with.offset(-12.5);
            make.height.equalTo(@13);
        }];
        
        [telIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(130);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        [_peopleTel mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.top.equalTo(self.mas_top).with.offset(12);
            make.left.equalTo(telIcon.mas_right).with.offset(10);
            make.right.equalTo(self.mas_right).with.offset(-12.5);
            make.height.equalTo(@13);
        }];
        
        [mobileNumIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(130);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        [_peopleMobileNum mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.top.equalTo(self.mas_top).with.offset(12);
            make.left.equalTo(mobileNumIcon.mas_right).with.offset(10);
            make.right.equalTo(self.mas_right).with.offset(-12.5);
            make.height.equalTo(@13);
        }];
        
        [emailIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(130);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        [_peopleEmail mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.top.equalTo(self.mas_top).with.offset(12);
            make.left.equalTo(emailIcon.mas_right).with.offset(10);
            make.right.equalTo(self.mas_right).with.offset(-12.5);
            make.height.equalTo(@13);
        }];
        
        [addressIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).with.offset(130);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        [_peopleAddress mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.top.equalTo(self.mas_top).with.offset(12);
            make.left.equalTo(addressIcon.mas_right).with.offset(10);
            make.right.equalTo(self.mas_right).with.offset(-12.5);
            make.height.equalTo(@13);
        }];
        
        [self distributeSpacingVerticallyWith:@[telIcon,mobileNumIcon,emailIcon,addressIcon]];
        [self distributeSpacingVerticallyWith:@[_peopleTel,_peopleMobileNum,_peopleEmail,_peopleAddress]];
    }
    return self;
}


#pragma mark - 横向或者纵向等间隙的排列一组view
- (void) distributeSpacingHorizontallyWith:(NSArray*)views
{
    NSMutableArray *spaces = [NSMutableArray arrayWithCapacity:views.count+1];
    
    for ( int i = 0 ; i < views.count+1 ; ++i )
    {
        UIView *v = [UIView new];
        [spaces addObject:v];
        [self addSubview:v];
        
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(v.mas_height);
        }];
    }
    
    UIView *v0 = spaces[0];
    
    __weak __typeof(&*self)ws = self;
    
    [v0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.mas_left);
        make.centerY.equalTo(((UIView*)views[0]).mas_centerY);
    }];
    
    UIView *lastSpace = v0;
    for ( int i = 0 ; i < views.count; ++i )
    {
        UIView *obj = views[i];
        UIView *space = spaces[i+1];
        
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastSpace.mas_right);
        }];
        
        [space mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(obj.mas_right);
            make.centerY.equalTo(obj.mas_centerY);
            make.width.equalTo(v0);
        }];
        
        lastSpace = space;
    }
    
    [lastSpace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.mas_right);
    }];
    
}

- (void)distributeSpacingVerticallyWith:(NSArray*)views
{
    
    NSMutableArray *spaces = [NSMutableArray arrayWithCapacity:views.count+1];
    
    for ( int i = 0 ; i < views.count+1 ; ++i )
    {
        UIView *v = [UIView new];
        [spaces addObject:v];
        [self addSubview:v];
        
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(v.mas_height);
        }];
    }
    
    
    UIView *v0 = spaces[0];
    
    __weak __typeof(&*self)ws = self;
    
    [v0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.mas_top);
        make.centerX.equalTo(((UIView*)views[0]).mas_centerX);
    }];
    
    UIView *lastSpace = v0;
    for ( int i = 0 ; i < views.count; ++i )
    {
        UIView *obj = views[i];
        UIView *space = spaces[i+1];
        
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastSpace.mas_bottom);
        }];
        
        [space mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(obj.mas_bottom);
            make.centerX.equalTo(obj.mas_centerX);
            make.height.equalTo(v0);
        }];
        
        lastSpace = space;
    }
    
    [lastSpace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.mas_bottom);
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
