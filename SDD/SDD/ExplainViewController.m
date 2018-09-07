//
//  ExplainViewController.m
//  SDD
//  说明
//  Created by mac on 15/12/1.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ExplainViewController.h"

@interface ExplainViewController ()

@end

@implementation ExplainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNav:@"说明"];
    [self setupUI];
}

-(void)setupUI{

    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *contentView = UIView.new;
    [scrollView addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    
    UILabel *content = [[UILabel alloc] init];
    content.font = midFont;
    content.textColor = lgrayColor;
    content.text = @"一、积分获取\n1）签到：\n您可以在商多多APP签到，送积分规则如下：\n1.第1天签到1积分\n2.连续签到10天，第10天得10积分，第11-19天10积分\n3.连续签到20天，第20天得20积分，第21-29天20积分\n4.连续签到30天，第30天得30积分，第31-39天30积分\n5.连续签到40天，第41天得40积分，以此类推\n（如中途断签，天数会重新累计哦）\n2）点评：\n您可以在商多多APP对项目或品牌发表点评，真实表达个人观点，奖励1积分，入选精华点评奖励100积分\n3）完善资料：\n您可以在商多多APP我的资料中将资料完善，完善完成后奖励10积分\n4）参与问答：\n您可以在商多多APP对感兴趣的问题进行回答，答案被采纳并通过审核后将获得提问者的悬赏积分\n\n二、积分使用\n1）提问\n用户自定义悬赏分数，悬赏积分最小0，最大不限，依据用户自身积分判断，大于自身积分提示积分不足，\n2）兑换商品\n根据商品所需积分兑换，兑换成功扣除用户相对应的积分\n\n三、声明\n1）本活动最终解释权归商多多";
    content.numberOfLines = 0;
    [contentView addSubview:content];
    
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_top).with.offset(10);
        make.left.equalTo(contentView.mas_left).with.offset(8);
        make.right.equalTo(contentView.mas_right).with.offset(-8);
        make.height.mas_greaterThanOrEqualTo(13);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(content.mas_bottom).with.offset(45);
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
