//
//  StatementViewController.m
//  SDD
//
//  Created by hua on 15/4/17.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "StatementViewController.h"

@interface StatementViewController ()

@end

@implementation StatementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = bgColor;
    // 导航条
    [self setNav:NSLocalizedString(@"toolDisclaimer", @"")];
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
    titleLabel.text = @"免责声明";
    
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
    contentLabel.text = @"        1.商多多已尽力确保所有资料是准确、完整及最新的。就该资料的针对性、精确性以及特定用途的适合性而言，本网站不可能也无义务做出最对应和最有成效的方案。所以对本网站所引用的资料，本网站概不承诺对其针对性、精确性以及特定用途的适合性负责，同时因依赖该资料所至的任何损失，本网站亦不承担任何法律责任。\n        2. 商多多不保证所有信息、文本、图形、链接及其它项目的绝对准确性和完整性，故仅供访问者参照使用。其中政策法规中文本不得作为正式法规文本使用。\n        3. 如果单位或个人认为本网站某部分内容有侵权嫌疑，敬请立即通知我们，我们将第一时间予以更该或删除。本网站并不承担查清事情的责任和证实事情公正性和合法性的责任，同时在事情查清前保留对该部分内容继续刊载的权利。\n        4. 若商多多已经明示其网络服务提供方式发生变更并提醒普通会员应当注意事项，普通会员未按要求操作所产生的一切后果由普通会员自行承担。\n        5. 普通会员明确同意其使用商多多络服务所存在的风险将完全由其自己承担；因其使用商多多服务而产生的一切后果也由其自己承担，商多多对普通会员不承担任何责任。\n        6. 普通会员同意保障和维护商多多及其他普通会员的利益，由于普通会员登录网站内容违法、不真实、不正当、侵犯第三方合法权益，或普通会员违反本协议项下的任何条款而给商多多或任何其他第三人造成损失，普通会员同意承担由此造成的损害赔偿责任。\n        7. 以上信息均为转载自相关品牌商网站，商多多无法保证上述信息的真实性与准确性。如有任何疑问请咨询相关品牌商。";
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
