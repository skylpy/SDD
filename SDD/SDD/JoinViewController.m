//
//  JoinViewController.m
//  SDD
//  //加盟商多多
//  Created by mac on 15/10/22.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "JoinViewController.h"

@interface JoinViewController ()<UIAlertViewDelegate>

@end

@implementation JoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    [self createView];
    [self createNvn];
}
#pragma mark - 设置导航条
-(void)createNvn{
    
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"加盟商多多";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
}
- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 创建View
-(void)createView
{
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"商多多商业地产网";
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(8);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
    }];
    
    UILabel * futitleLabel = [[UILabel alloc] init];
    futitleLabel.text = @"地产电商租售平台全国合伙人征召";
    [self.view addSubview:futitleLabel];
    [futitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(8);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
    }];
    
    UILabel * comLabel = [[UILabel alloc] init];
    comLabel.numberOfLines = 0;
    comLabel.font = titleFont_15;
    comLabel.textColor = lgrayColor;
    comLabel.text = @"\n行业现状\n住宅代理混战商业地产项目、项目优势难被认可\n缺乏产业内招商、销售渠道\n代理商缺乏对项目全程操控能力\n广告代理不能提供针对性的策划顾问\n住宅代理混战商业地产项目、项目优势难被认可\n缺乏产业内招商、销售渠道\n代理商缺乏对项目全程超控能力\n广告代理不能提供针对性的策划顾问\n\n\n加盟优势\n专业机构做专业事情，自然开发商放下，代理商挣钱";
    [self.view addSubview:comLabel];
    [comLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(futitleLabel.mas_bottom).with.offset(8);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
    }];
    
    UIButton * phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [phoneBtn setTitle:@"创业热线：400-911-8829" forState:UIControlStateNormal];
    [phoneBtn setTitleColor:tagsColor forState:UIControlStateNormal];
    [phoneBtn addTarget:self action:@selector(phoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:phoneBtn];
    [phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(comLabel.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
    }];
}

-(void)phoneBtnClick:(UIButton *)btn
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"拨打400-911-8829" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4009118829"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
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
