//
//  sponsorSucceedViewController.m
//  SDD
//
//  Created by hua on 15/10/14.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "sponsorSucceedViewController.h"

@interface sponsorSucceedViewController ()

@end

@implementation sponsorSucceedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = bgColor;
    
    [self createNvn];
    [self createView];
    // Do any additional setup after loading the view.
}

-(void)createNvn
{
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.hidesBackButton = YES;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"申请赞助成功";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

//导航条返回键
- (void)leftButtonClick
{
    
    //通过viewControllers获取到加入导航栏中的所有viewController
//    NSLog(@"%@",self.navigationController.viewControllers);
    
    //返回的是viewController数组，先加进去的在最里面
    //第一个vc是数组的0位置
    //跳转中间的界面都会被销毁
    UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:2];
    
    [self.navigationController popToViewController:vc animated:YES];
//    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)createView
{
    UIView *tV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, 150)];
    tV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tV];
    
    UILabel *titLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 25, viewWidth-60, 40)];
    titLabel.font = ([UIFont systemFontOfSize:24*MULTIPLE]);
    titLabel.textColor = [UIColor orangeColor];
    titLabel.text = @"恭喜您申请赞助成功!";
    titLabel.textAlignment = NSTextAlignmentCenter;
    [tV addSubview:titLabel];
    
    UIImageView *riImage = [[UIImageView alloc]initWithFrame:CGRectMake(35, 30, 30, 30)];
    [riImage setImage:[UIImage imageNamed:@"sponsorSucceedicon"]];
    [tV addSubview:riImage];
    
    UILabel *abLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 70, viewWidth-50, 70)];
    abLabel.font = midFont;
    abLabel.textColor = deepBLack;
    abLabel.text = @"恭喜，您成功申请赞助主题论坛活动， 我们将会对您提交的资料进行审核，请耐心等候。";
    abLabel.textAlignment = NSTextAlignmentCenter;
    abLabel.numberOfLines = 0;
    [tV addSubview:abLabel];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //            leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [leftButton setTitle:@"返回活动详情" forState:UIControlStateNormal];
    [leftButton.layer setMasksToBounds:YES];
    [leftButton.layer setCornerRadius:10.0];
    leftButton.frame = CGRectMake(20, 190, viewWidth-40, 40);
    leftButton.backgroundColor  = [UIColor colorWithRed:(16/255.0) green:(118/255.0) blue:(224/255.0) alpha:(1.0)];
    [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
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
