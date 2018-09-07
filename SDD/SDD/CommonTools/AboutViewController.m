//
//  AboutViewController.m
//  SDD
//
//  Created by hua on 15/4/17.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = bgColor;
    
    // 导航条
    [self setNav:NSLocalizedString(@"aboutOurs", @"")];
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
    
    //logo
    UIImageView * logoImage = [[UIImageView alloc] init];
    logoImage.image = [UIImage imageNamed:@"shanglogo"];
    logoImage.contentMode = UIViewContentModeScaleToFill;
    
    [bg_scrollView addSubview:logoImage];
    [logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_top).offset(25);
        make.centerX.equalTo(contentView);
        make.width.equalTo(@(viewWidth/3));
        make.height.equalTo(@45);
    }];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = titleFont_15;
    titleLabel.textColor = mainTitleColor;
    titleLabel.text = @"关于商多多";
    
    [bg_scrollView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logoImage.mas_bottom).offset(10);
        make.left.equalTo(contentView.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 15));
    }];
    
    // 内容
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = midFont;
    contentLabel.textColor = lgrayColor;
    contentLabel.text = @"关于商多多\n        商多多是广州市九合飞一网络科技有限公司旗下地产O2O平台，定位为专业的商业地产租售交易首选平台，秉承“让地产商、品牌商、经销商、经纪人放下猜忌，直面沟通”的理念，打造一个真正透明、公开的租售环境，让地产商卖的更省心、品牌商进的更安心、经销商买（租）的更放心、经纪人做的更舒心。商多多力求将中国商业版图形象细化为“九州之大·一点之间”的模式，广揽精英，持续打造企业竞争力，旨在通过互联网、IT与传统营销相结合，成就“最可信赖的商业地产互联网服务平台”。";
    contentLabel.numberOfLines = 0;
    
    [bg_scrollView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.left.equalTo(contentView.mas_left).offset(10);
        make.width.mas_equalTo(viewWidth-20);
    }];
    
    //电话号码
    UILabel * tellLabel = [[UILabel alloc] init];
    tellLabel.font = titleFont_15;
    tellLabel.textColor = mainTitleColor;
    tellLabel.text = @"电话号码：";
    
    [bg_scrollView addSubview:tellLabel];
    [tellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabel.mas_bottom).offset(20);
        make.left.equalTo(contentView.mas_left).offset(10);
    }];
    
    //点击打电话
    UIButton * tellBtn = [[UIButton alloc] init];
    [tellBtn setTitleColor:dblueColor forState:UIControlStateNormal];
    [tellBtn setTitle:@"400-991-8829" forState:UIControlStateNormal];
    tellBtn.titleLabel.font = titleFont_15;
    tellBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [bg_scrollView addSubview:tellBtn];
    
    [tellBtn addTarget:self action:@selector(tellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [tellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabel.mas_bottom).offset(15);
        make.left.equalTo(tellLabel.mas_right).offset(0);
    }];
    
    UILabel * urlLabel = [[UILabel alloc] init];
    urlLabel.font = titleFont_15;
    urlLabel.textColor = mainTitleColor;
    urlLabel.text = @"手机访问：";
    
    [bg_scrollView addSubview:urlLabel];
    [urlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tellLabel.mas_bottom).offset(10);
        make.left.equalTo(contentView.mas_left).offset(10);
    }];
    
    UIButton * urlBtn = [[UIButton alloc] init];
    [urlBtn setTitleColor:dblueColor forState:UIControlStateNormal];
    [urlBtn setTitle:@"shangdodo.com" forState:UIControlStateNormal];
    urlBtn.titleLabel.font = titleFont_15;
    urlBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [bg_scrollView addSubview:urlBtn];
    
    [urlBtn addTarget:self action:@selector(urlBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [urlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tellLabel.mas_bottom).offset(5);
        make.left.equalTo(urlLabel.mas_right).offset(0);
    }];
    
    NSString * VersionStr = [NSString stringWithFormat:@"当前版本： v%@ for IOS",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
    UILabel * VersionLable = [[UILabel alloc] init];
    VersionLable.textColor = mainTitleColor;
    VersionLable.text = VersionStr;
    VersionLable.font = titleFont_15;
    [bg_scrollView addSubview:VersionLable];
    [VersionLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(urlLabel.mas_bottom).offset(10);
        make.left.equalTo(contentView.mas_left).offset(10);
        make.width.equalTo(@(viewWidth));
    }];
    
    UILabel * mainLable = [[UILabel alloc] init];
    mainLable.textAlignment = NSTextAlignmentCenter;
    mainLable.text = @"Copyright@2015商多多版权所有";
    [bg_scrollView addSubview:mainLable];
    [mainLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(VersionLable.mas_bottom).offset(25);
        make.left.equalTo(contentView.mas_left).offset(10);
        make.width.equalTo(@(viewWidth));
    }];
    
    // 自动scrollview高度
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(mainLable.mas_bottom).with.offset(65);
    }];
}

//打开网页
-(void)urlBtnClick:(UIButton *)btn
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.shangdodo.com"]];
}

//打电话
-(void)tellBtnClick:(UIButton *)btn
{
    NSString *telNumber = [[NSString alloc] initWithFormat:@"telprompt://%@",@"4009918829"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telNumber]];
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
