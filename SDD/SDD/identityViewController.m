//
//  identityViewController.m
//  SDD
//
//  Created by hua on 15/10/27.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "identityViewController.h"
#import "registrOneViewController.h"
#import "registrFourViewController.h"

@interface identityViewController ()

@end

@implementation identityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 导航条
    [self createNvn];
    
    [self createUI];
    
    // Do any additional setup after loading the view.
}

-(void)createUI
{
    self.view.backgroundColor = lgrayColor;
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(10, 15, viewWidth-20, viewHeight - 150)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    UILabel *titLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, backView.frame.size.width, 30)];
    titLabel.text = @"选择您的身份，选择后不能修改";
    titLabel.font = midFont;
    titLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:titLabel];
    
    //发展商
    UIButton *oneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    oneButton.showsTouchWhenHighlighted = YES;
    [oneButton addTarget:self action:@selector(oneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    oneButton.frame = CGRectMake(10, 40, backView.frame.size.width - 20, (backView.frame.size.height - 80)/4);
    //设置button图片
    [oneButton setBackgroundImage:[UIImage imageNamed:@"fazhanshang"] forState:UIControlStateNormal];
    [backView addSubview:oneButton];
    UILabel *oneLabelA = [[UILabel alloc]initWithFrame:CGRectMake(oneButton.frame.size.width/2, oneButton.frame.size.height/2 - 20, oneButton.frame.size.width/2, 30)];
    oneLabelA.text = @"我是发展商";
    oneLabelA.font = titleFont_15;
    oneLabelA.textAlignment = NSTextAlignmentLeft;
    [oneButton addSubview:oneLabelA];
    UILabel *oneLabelB = [[UILabel alloc]initWithFrame:CGRectMake(oneButton.frame.size.width/2, oneButton.frame.size.height/2, oneButton.frame.size.width/2, 30)];
    oneLabelB.text = @"千万品牌等您邀约";
    oneLabelB.textColor = lgrayColor;
    oneLabelB.font = midFont;
    oneLabelB.textAlignment = NSTextAlignmentLeft;
    [oneButton addSubview:oneLabelB];
    
    //经销商
    UIButton *twoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    twoButton.showsTouchWhenHighlighted = YES;
    [twoButton addTarget:self action:@selector(twoButtonClick) forControlEvents:UIControlEventTouchUpInside];
    twoButton.frame = CGRectMake(10, 50 + (backView.frame.size.height - 80)/4, backView.frame.size.width - 20, (backView.frame.size.height - 80)/4);
    //设置button图片
    [twoButton setBackgroundImage:[UIImage imageNamed:@"jingxiaoshang"] forState:UIControlStateNormal];
    [backView addSubview:twoButton];
    UILabel *twoLabelA = [[UILabel alloc]initWithFrame:CGRectMake(twoButton.frame.size.width/2, twoButton.frame.size.height/2 - 20, twoButton.frame.size.width/2, 30)];
    twoLabelA.text = @"我是品牌商";
    twoLabelA.font = titleFont_15;
    twoLabelA.textAlignment = NSTextAlignmentLeft;
    [twoButton addSubview:twoLabelA];
    UILabel *twoLabelB = [[UILabel alloc]initWithFrame:CGRectMake(twoButton.frame.size.width/2, twoButton.frame.size.height/2, twoButton.frame.size.width/2, 30)];
    twoLabelB.text = @"优质项目等您入驻";
    twoLabelB.textColor = lgrayColor;
    twoLabelB.font = midFont;
    twoLabelB.textAlignment = NSTextAlignmentLeft;
    [twoButton addSubview:twoLabelB];
    
    //品牌商
    UIButton *threeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    threeButton.showsTouchWhenHighlighted = YES;
    [threeButton addTarget:self action:@selector(threeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    threeButton.frame = CGRectMake(10, 60 + (backView.frame.size.height - 80)/4*2, backView.frame.size.width - 20, (backView.frame.size.height - 80)/4);
    //设置button图片
    [threeButton setBackgroundImage:[UIImage imageNamed:@"pinpaishang"] forState:UIControlStateNormal];
    [backView addSubview:threeButton];
    UILabel *threeLabelA = [[UILabel alloc]initWithFrame:CGRectMake(threeButton.frame.size.width/2, threeButton.frame.size.height/2 - 20, threeButton.frame.size.width/2, 30)];
    threeLabelA.text = @"我是经销商";
    threeLabelA.font = titleFont_15;
    threeLabelA.textAlignment = NSTextAlignmentLeft;
    [threeButton addSubview:threeLabelA];
    UILabel *threeLabelB = [[UILabel alloc]initWithFrame:CGRectMake(threeButton.frame.size.width/2, threeButton.frame.size.height/2, threeButton.frame.size.width/2, 30)];
    threeLabelB.text = @"省心省力更省钱";
    threeLabelB.textColor = lgrayColor;
    threeLabelB.font = midFont;
    threeLabelB.textAlignment = NSTextAlignmentLeft;
    [threeButton addSubview:threeLabelB];
    
    //其他
    UIButton *fourButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fourButton.showsTouchWhenHighlighted = YES;
    [fourButton addTarget:self action:@selector(fourButtonClick) forControlEvents:UIControlEventTouchUpInside];
    fourButton.frame = CGRectMake(10, 70 + (backView.frame.size.height - 80)/4*3, backView.frame.size.width - 20, (backView.frame.size.height - 80)/4);
    //设置button图片
    [fourButton setBackgroundImage:[UIImage imageNamed:@"qita"] forState:UIControlStateNormal];
    [backView addSubview:fourButton];
    UILabel *fourLabelA = [[UILabel alloc]initWithFrame:CGRectMake(fourButton.frame.size.width/2, fourButton.frame.size.height/2 - 20, fourButton.frame.size.width/2, 30)];
    fourLabelA.text = @"其他";
    fourLabelA.font = titleFont_15;
    fourLabelA.textAlignment = NSTextAlignmentLeft;
    [fourButton addSubview:fourLabelA];
    UILabel *fourLabelB = [[UILabel alloc]initWithFrame:CGRectMake(fourButton.frame.size.width/2, fourButton.frame.size.height/2, fourButton.frame.size.width/2, 30)];
    fourLabelB.text = @"我要赚更多的钱";
    fourLabelB.textColor = lgrayColor;
    fourLabelB.font = midFont;
    fourLabelB.textAlignment = NSTextAlignmentLeft;
    [fourButton addSubview:fourLabelB];
    
}

-(void)oneButtonClick
{
    registrOneViewController *viewController = [[registrOneViewController alloc] init];
    viewController.num = 0;
    [self.navigationController pushViewController:viewController animated:YES];
//    registrFourViewController *fVC = [[registrFourViewController alloc]init];
//    fVC.num = 0;
    
}

-(void)twoButtonClick
{
    registrOneViewController *viewController = [[registrOneViewController alloc] init];
    viewController.num = 1;
    [self.navigationController pushViewController:viewController animated:YES];
//    registrFourViewController *fVC = [[registrFourViewController alloc]init];
//    fVC.num = 1;
}

-(void)threeButtonClick
{
    registrOneViewController *viewController = [[registrOneViewController alloc] init];
    viewController.num = 2;
    [self.navigationController pushViewController:viewController animated:YES];
//    registrFourViewController *fVC = [[registrFourViewController alloc]init];
//    fVC.num = 2;
}

-(void)fourButtonClick
{
    registrOneViewController *viewController = [[registrOneViewController alloc] init];
    viewController.num = 3;
    [self.navigationController pushViewController:viewController animated:YES];
//    registrFourViewController *fVC = [[registrFourViewController alloc]init];
//    fVC.num = 3;
}

-(void)createNvn
{
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"新用户注册";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    //    UIButton * rightBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    //    rightBtn.frame = CGRectMake(0, 0, 15, 15);
    //    [rightBtn setBackgroundImage:[UIImage imageNamed:@"分享-图标"] forState:UIControlStateNormal];
    //
    //    UIBarButtonItem * rigItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    //    self.navigationItem.rightBarButtonItem = rigItem;
    
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
