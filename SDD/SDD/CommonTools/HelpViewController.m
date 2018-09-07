//
//  HelpViewController.m
//  SDD
//
//  Created by hua on 15/4/17.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = bgColor;
    // 导航条
    [self setNav:NSLocalizedString(@"toolHelp", @"")];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    // 底部滚动
    UIScrollView *bg_scrollView = [[UIScrollView alloc] init];
    bg_scrollView.backgroundColor = bgColor;
    [self.view addSubview:bg_scrollView];
    [bg_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 底部view， 用于计算scrollview高度
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = bgColor;
    [bg_scrollView addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bg_scrollView);
        make.width.equalTo(bg_scrollView);
    }];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = titleFont_15;
    titleLabel.textColor = mainTitleColor;
    titleLabel.text = @"使用帮助";
    
    [bg_scrollView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_top).offset(10);
        make.left.equalTo(contentView.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 15));
    }];
    
    // 内容
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = midFont;
    contentLabel.textColor = lgrayColor;
    contentLabel.text = @"1.搜索房源\n首页提供各种类型的房源进行搜索，包括“团购、团租、特价铺抢购、房源”等，也可以在搜索处直接搜索“楼盘名称、开发商”。\n2.获取优惠/在线选房\n点击“团购、团租、特价铺”的楼盘详情，即可查看商多多提供的各种优惠，团购预约获取，线下兑现，团租可线上在线选房提交意向金，特价铺抢购可秒杀指定房源，直接线上下定金。\n3.看房团\n线上申请看房活动，申请成功之后会有专业工作人员联系看房\n4.在线咨询\n微聊、语音，电话等多种通讯方式让您直面开发商\n5.动态\n提供最新最全的行业新闻，及时便捷的帮您掌控整个商业地产的新动向。";
    contentLabel.numberOfLines = 0;
    
    [bg_scrollView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.left.equalTo(contentView.mas_left).offset(10);
        make.width.mas_equalTo(viewWidth-20);
    }];
    
    // 自动scrollview高度
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentLabel.mas_bottom).with.offset(65);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
