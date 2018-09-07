//
//  OrderReservationSucceedViewController.m
//  SDD
//
//  Created by hua on 15/9/9.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "OrderReservationSucceedViewController.h"

#import "GRDetailViewController.h"
#import "GPDetailViewController.h"

@interface OrderReservationSucceedViewController ()

@end

@implementation OrderReservationSucceedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = bgColor;
    // 导航条
    [self setNav:@"登记成功"];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    // head
    UIView *headView = [[UIView alloc] init];
    headView.frame = CGRectMake(0, 0, viewWidth, 115);
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    
    // 恭喜标题
    UILabel *applyTitle = [[UILabel alloc] init];
    applyTitle.frame = CGRectMake(0, 0, viewWidth, 30);
    applyTitle.font = [UIFont systemFontOfSize:25];
    applyTitle.textColor = dblueColor;
    applyTitle.text = @"恭喜您登记成功!";
    [applyTitle sizeToFit];
    applyTitle.center = CGPointMake(viewWidth/2, 35);
    [headView addSubview:applyTitle];
    
    // 图标
    UIImageView *successIcon = [[UIImageView alloc] init];
    successIcon.frame = CGRectMake(CGRectGetMinX(applyTitle.frame)-35, applyTitle.frame.origin.y+2.5, 25, 25);
    successIcon.image = [UIImage imageNamed:@"icon_ok_blue"];
    [headView addSubview:successIcon];
    
    // 详细
    UILabel *content = [[UILabel alloc] init];
    content.frame = CGRectMake(50, CGRectGetMaxY(successIcon.frame)+10, viewWidth-100, 50);
    content.textColor = mainTitleColor;
    content.font = midFont;
    content.text = [NSString stringWithFormat:@"恭喜，您成功报名了%@",_houseName];
    content.numberOfLines = 2;
    [headView addSubview:content];
    
    // 退出按钮
    ConfirmButton *back = [[ConfirmButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(headView.frame)+20, viewWidth - 40, 45)
                                                                title:@"项目详情"
                                                               target:self
                                                               action:@selector(back)];
    back.enabled = YES;
    [self.view addSubview:back];
}

#pragma mark - 返回
- (void)back{
    
    if (_isOfficial) {
        
        GRDetailViewController *grDetail = [[GRDetailViewController alloc] init];
        grDetail.activityCategoryId = @"2";
        grDetail.houseID = _houseId;
        [self.navigationController pushViewController:grDetail animated:YES];
    }
    else {
        
        GPDetailViewController *gpDetail = [[GPDetailViewController alloc] init];
        gpDetail.activityCategoryId = @"2";
        gpDetail.houseID = _houseId;
        [self.navigationController pushViewController:gpDetail animated:YES];
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
