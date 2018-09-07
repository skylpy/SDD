//
//  PreferentialDetailViewController.m
//  SDD
//
//  Created by hua on 15/8/21.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "PreferentialDetailViewController.h"

#import "ReservationController.h"

@interface PreferentialDetailViewController ()

@end

@implementation PreferentialDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNav:@"优惠详情"];
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
    titleLabel.text = @"优惠详情";
    
    [contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_top).offset(10);
        make.left.equalTo(contentView.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 15));
    }];
    
    // 内容
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = midFont;
    contentLabel.textColor = lgrayColor;
    contentLabel.text = _preferentialContent;
    contentLabel.numberOfLines = 0;
    
    [contentView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.left.equalTo(contentView.mas_left).offset(10);
        make.width.mas_equalTo(viewWidth-20);
    }];
    
    // 自动scrollview高度
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(contentLabel.mas_bottom).with.offset(65);
    }];
    
    // 预约按钮
    ConfirmButton *reservationBtn = [[ConfirmButton alloc] initWithFrame:CGRectMake(20, viewHeight-119, viewWidth - 40, 45)
                                                                title:@"预约看铺"
                                                               target:self
                                                               action:@selector(reservation)];
    [reservationBtn setBackgroundImage:[Tools_F imageWithColor:tagsColor
                                                          size:CGSizeMake(viewWidth-40, 45)]
                              forState:UIControlStateNormal];
    [reservationBtn setBackgroundImage:[Tools_F imageWithColor:lblueColor
                                                          size:CGSizeMake(viewWidth-40, 45)]
                              forState:UIControlStateDisabled];
    [reservationBtn setTitleColor:[UIColor whiteColor]
                         forState:UIControlStateDisabled];
    
    reservationBtn.enabled = _canAppointment;

    [Tools_F setViewlayer:reservationBtn cornerRadius:5 borderWidth:0 borderColor:nil];
    [self.view addSubview:reservationBtn];
    
}

- (void)reservation{
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
//    else if (!_canAppointment) {
//        
//        //
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"您已报名该预约，请勿重复报名"
//                                                       delegate:self
//                                              cancelButtonTitle:@"好"
//                                              otherButtonTitles:nil, nil];
//        [alert show];
//    }
    else {
        
        ReservationController *rVC = [[ReservationController alloc] init];
        
        rVC.houseName = _houseName;
        rVC.houseID = _houseID;
        rVC.activityCategoryId = 2;
        rVC.isOfficial = _isOfficial;
        [self.navigationController pushViewController:rVC animated:YES];
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
