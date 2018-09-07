//
//  QueAndAnsTableViewCell.m
//  SDD
//
//  Created by mac on 15/7/27.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "QueAndAnsTableViewCell.h"

@implementation QueAndAnsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

-(void)createView
{
    //self.contentView.frame = CGRectMake(0, 0, viewWidth, 150);
    
    //头像
    _HeadImageView = [[UIImageView alloc] init];
    _HeadImageView.image = [UIImage imageNamed:@"logo.png"];
    _HeadImageView.layer.cornerRadius = 17;
    _HeadImageView.clipsToBounds = YES;
    //_HeadImageView.backgroundColor = [UIColor redColor];
    [self addSubview:_HeadImageView];
    
    [_HeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(8);
        make.width.equalTo(@35);
        make.height.equalTo(@35);
    }];
    
    //用户名
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text = @"王尼玛";
    [self addSubview:_nameLabel];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(20);
        make.left.equalTo(_HeadImageView.mas_right).with.offset(10);
        make.width.equalTo(@150);
        make.height.equalTo(@15);
    }];
    
    //评论
    _comLabel = [[UILabel alloc] init];
    _comLabel.font = [UIFont systemFontOfSize:15];
    _comLabel.numberOfLines = 0;
    _comLabel.text = @"哈哈哈哈哈哈，你太帅了";
    [self addSubview:_comLabel];
    
    [_comLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_HeadImageView.mas_bottom).with.offset(9);
        make.left.equalTo(self.mas_left).with.offset(10);
        make.right.equalTo(self.mas_right).with.offset(-10);
            //make.height.equalTo(@15);
    }];
    
    //时间
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor grayColor];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.text = @"2015-07-25 10:13:50";
    [self addSubview:_timeLabel];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_comLabel.mas_bottom).with.offset(15);
        make.left.equalTo(self.mas_left).with.offset(10);
            //make.right.equalTo(self.mas_right).with.offset(-80);
            //make.height.equalTo(@15);
    }];
    
    
    //评论标志
    _coinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(270, 80, 20, 20)];
    _coinImageView.image = [UIImage imageNamed:@"answer_icon1"];
    [self addSubview:_coinImageView];
    
//        [_coinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_comLabel.mas_bottom).with.offset(8);
//            make.right.equalTo(self.mas_right).with.offset(-40);
//            make.width.equalTo(@20);
//            make.height.equalTo(@20);
//        }];
    
    
    
    UIButton * reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reportBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [reportBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[reportBtn setTitle:@"举报" forState:UIControlStateNormal];
    reportBtn.tag = 1003;
    [self addSubview:reportBtn];
    
    [reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_comLabel.mas_bottom).with.offset(15);
        make.left.equalTo(_timeLabel.mas_right).with.offset(25);
        make.width.equalTo(@40);
        make.height.equalTo(@15);
    }];
    
    UIButton * noPraiseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //noPraiseButton.frame = CGRectMake(460/2-10, 80, 15, 15);
    [noPraiseButton setBackgroundImage:[UIImage imageNamed:@"icon_bad"] forState:UIControlStateNormal];
    noPraiseButton.tag = 1000;
    [self addSubview:noPraiseButton];
    
    [noPraiseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_comLabel.mas_bottom).with.offset(15);
        make.left.equalTo(reportBtn.mas_right).with.offset(30);
        make.width.equalTo(@15);
        make.height.equalTo(@15);
    }];
    
    _noLabel = [[UILabel alloc] init];
    _noLabel.font = [UIFont systemFontOfSize:13];
    _noLabel.textColor = [UIColor grayColor];
    _noLabel.text = @"8";
    [self addSubview:_noLabel];
    
    [_noLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_comLabel.mas_bottom).with.offset(15);
        make.left.equalTo(noPraiseButton.mas_right).with.offset(8);
        // make.right.equalTo(self.mas_right).with.offset(-10);
        //make.height.equalTo(@15);
    }];

    
    UIButton * PraiseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //PraiseButton.frame = CGRectMake(460/2+40, 80, 15, 15);
    [PraiseButton setBackgroundImage:[UIImage imageNamed:@"some_praise_icon"] forState:UIControlStateNormal];
    PraiseButton.tag = 1001;
    [self addSubview:PraiseButton];
    
    [PraiseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_comLabel.mas_bottom).with.offset(15);
        make.left.equalTo(_noLabel.mas_right).with.offset(8);
        make.width.equalTo(@15);
        make.height.equalTo(@15);
    }];
    
    //赞数量
    _numLabel = [[UILabel alloc] init];
    _numLabel.font = [UIFont systemFontOfSize:13];
    _numLabel.textColor = [UIColor grayColor];
    _numLabel.text = @"12";
    [self addSubview:_numLabel];
    
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_comLabel.mas_bottom).with.offset(15);
        make.left.equalTo(PraiseButton.mas_right).with.offset(10);
        // make.right.equalTo(self.mas_right).with.offset(-10);
        //make.height.equalTo(@15);
    }];
    
    
    
    
    UIButton * AdoptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    AdoptBtn.frame = CGRectMake(viewWidth-50, 20, 50, 20);
    [AdoptBtn setTitle:@"采纳" forState:UIControlStateNormal];
    [AdoptBtn setTitleColor:[SDDColor colorWithHexString:@"#3366FF"] forState:UIControlStateNormal];
    AdoptBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    AdoptBtn.tag = 1002;
    [self addSubview:AdoptBtn];
    
    
    _AdoptImageView = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth-40, 0, 40, 40)];
    //_AdoptImageView.backgroundColor = [UIColor redColor];
    _AdoptImageView.image = [UIImage imageNamed:@"has_been _adopted_icon"];
    [self addSubview:_AdoptImageView];
    
    
    UIImageView * footImage = [[UIImageView alloc] init];
    footImage.backgroundColor = [SDDColor colorWithHexString:@"#F8F8FF"];
    [self addSubview:footImage];
    
    [footImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeLabel.mas_bottom).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        //make.width.equalTo(@320);
        make.height.equalTo(@10);
    }];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
