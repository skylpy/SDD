//
//  ADelegationViewController.m
//  SDD
//
//  Created by mac on 15/8/19.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ADelegationViewController.h"

@interface ADelegationViewController ()
{
    UILabel * lineRoadLabel;
    UILabel * PreferentialLabel;
    UILabel * AveragePriceLabel;
    UILabel * AreaLabel;
    UILabel * ShopHotLineLabel;
    
     NSDictionary *tempDic;
}

@property (retain,nonatomic)UIScrollView * scrollView;
@end

@implementation ADelegationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    [self createNvn];
    [self createView];
}


-(void)createView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    lineRoadLabel = [[UILabel alloc] init];
    lineRoadLabel.font = titleFont_15;
    lineRoadLabel.text = @"线路介绍：商铺 日光 地铁沿线";
    [_scrollView addSubview:lineRoadLabel];
    [lineRoadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(8);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
    }];
    
    PreferentialLabel = [[UILabel alloc] init];
    PreferentialLabel.font = titleFont_15;
    PreferentialLabel.text = @"最高优惠：1.5万抵8万优惠";
    [_scrollView addSubview:PreferentialLabel];
    [PreferentialLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineRoadLabel.mas_bottom).with.offset(8);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
    }];
    
    AveragePriceLabel = [[UILabel alloc] init];
    AveragePriceLabel.font = titleFont_15;
    AveragePriceLabel.text = @"均价：150/m²";
    [_scrollView addSubview:AveragePriceLabel];
    [AveragePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(PreferentialLabel.mas_bottom).with.offset(8);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
    }];
    
    AreaLabel = [[UILabel alloc] init];
    AreaLabel.font = titleFont_15;
    AreaLabel.text = @"所属区域：成都";
    [_scrollView addSubview:AreaLabel];
    [AreaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(AveragePriceLabel.mas_bottom).with.offset(8);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
    }];
    
    ShopHotLineLabel = [[UILabel alloc] init];
    ShopHotLineLabel.font = titleFont_15;
    ShopHotLineLabel.text = @"看铺热线：400-000-00";
    [_scrollView addSubview:ShopHotLineLabel];
    [ShopHotLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(AreaLabel.mas_bottom).with.offset(8);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
    }];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font= largeFont ;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[Tools_F imageWithColor:dblueColor size:CGSizeMake(viewWidth-40, 45)]
                      forState:UIControlStateNormal];
    [Tools_F setViewlayer:button cornerRadius:5 borderWidth:1 borderColor:dblueColor];
    button.tag = 1000;
    [button setTitle:@"立即报名" forState:UIControlStateNormal];
    [_scrollView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ShopHotLineLabel.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
    }];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    

    UILabel * ByTheTimeLable = [[UILabel alloc] init];
    ByTheTimeLable.font =midFont;
    ByTheTimeLable.text = @"报名截止时间：6月20日";
    ByTheTimeLable.textColor = lgrayColor;
    [_scrollView addSubview:ByTheTimeLable];
    [ByTheTimeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_bottom).with.offset(12);
        make.left.equalTo(self.view.mas_left).with.offset(40);
        
    }];
    
    UILabel * SignUpLable = [[UILabel alloc] init];
    SignUpLable.font =midFont;
    SignUpLable.text = @"已报名：61人";
    SignUpLable.textColor = lgrayColor;
    SignUpLable.textAlignment = NSTextAlignmentRight;
    [_scrollView addSubview:SignUpLable];
    [SignUpLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_bottom).with.offset(12);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
        
    }];
    
    UILabel * lineLabel = [[UILabel alloc] init];
    lineLabel.backgroundColor = bgColor;
    [_scrollView addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ByTheTimeLable.mas_bottom).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.height.equalTo(@10);
    }];
    
#pragma mark -- 线路项目
    UILabel * RouteProjectLable = [[UILabel alloc] init];
    RouteProjectLable.font = midFont;
    RouteProjectLable.text = @"线路项目";
    [_scrollView addSubview:RouteProjectLable];
    [RouteProjectLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLabel.mas_bottom).with.offset(15);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
    }];
    
#pragma mark -- 线
    UILabel * minlineLabel = [[UILabel alloc] init];
    minlineLabel.backgroundColor = bgColor;
    [_scrollView addSubview:minlineLabel];
    [minlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(RouteProjectLable.mas_bottom).with.offset(15);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.equalTo(@1);
    }];
    
    UIView * RouteProView = [[UIView alloc] init];
    //RouteProView.backgroundColor = [UIColor redColor];
    [_scrollView addSubview:RouteProView];
    [RouteProView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(minlineLabel.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.equalTo(@100);
    }];
    
    UILabel * lineLabel2 = [[UILabel alloc] init];
    lineLabel2.backgroundColor = bgColor;
    [_scrollView addSubview:lineLabel2];
    [lineLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(RouteProView.mas_bottom).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.height.equalTo(@10);
    }];
    
#pragma mark -- 活动流程
    UILabel * ActiveProcessLable = [[UILabel alloc] init];
    ActiveProcessLable.font = midFont;
    ActiveProcessLable.text = @"活动流程";
    [_scrollView addSubview:ActiveProcessLable];
    [ActiveProcessLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLabel2.mas_bottom).with.offset(15);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
    }];
    
#pragma mark -- 线
    UILabel * minlineLabel1 = [[UILabel alloc] init];
    minlineLabel1.backgroundColor = bgColor;
    [_scrollView addSubview:minlineLabel1];
    [minlineLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ActiveProcessLable.mas_bottom).with.offset(15);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.equalTo(@1);
    }];
    
#pragma mark -- 免责声明
    UILabel * DisclaimerLable = [[UILabel alloc] init];
    DisclaimerLable.font = midFont;
    DisclaimerLable.text = @"免责声明";
    [_scrollView addSubview:DisclaimerLable];
    [DisclaimerLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(minlineLabel1.mas_bottom).with.offset(15);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
    }];
    
#pragma mark -- 线
    UILabel * minlineLabel2 = [[UILabel alloc] init];
    minlineLabel2.backgroundColor = bgColor;
    [_scrollView addSubview:minlineLabel2];
    [minlineLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(DisclaimerLable.mas_bottom).with.offset(15);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.equalTo(@1);
    }];
}
-(void)buttonClick:(UIButton *)btn
{
    
//    ThemeApplyViewController * thVc = [[ThemeApplyViewController alloc] init];
//    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;
//    [self.navigationController pushViewController:thVc animated:YES];
}

-(void)createNvn
{
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"中润欧洲城考察团";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
}
- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
