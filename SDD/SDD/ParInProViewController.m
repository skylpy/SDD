//
//  ParInProViewController.m
//  SDD
//  参与问答
//  Created by mac on 15/12/3.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ParInProViewController.h"
#import "SignInTopView.h"
#import "SignInBottomView.h"

#import "SignInBtn.h"
#import "PersonalTabButton.h"

@interface ParInProViewController ()

@end

@implementation ParInProViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    [self setNav:@"参与问答"];
    
    [self createUI];
}
-(void)createUI{
    
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    
    [self.view addSubview:scrollView];
    
    NSString * desStr = @"您可以在商多多APP对感兴趣的问题进行回答，答案被采纳并通过审核后将获得提问者的悬赏积分";
    
    CGSize signSize = [Tools_F countingSize:desStr fontSize:15 width:(viewWidth-20)];
    
    SignInTopView * signView = [[SignInTopView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, signSize.height+60)];
    signView.backgroundColor = [UIColor whiteColor];
    signView.IntegralRules.text = @"积分规则";
    signView.textLabel.text = desStr;
    
    [scrollView addSubview:signView];
    
    SignInBottomView * signBottom = [[SignInBottomView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(signView.frame)+10, viewWidth, 430)];
    signBottom.backgroundColor = [UIColor whiteColor];
    signBottom.IntegralRules.text = @"如何点评";
    [scrollView addSubview:signBottom];
    
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,50 , viewWidth-20, 20)];
    titleLabel.text = @"1.APP首页点击问答";
    titleLabel.font = titleFont_15;
    titleLabel.textColor = lgrayColor;
    [signBottom addSubview:titleLabel];
    
    
    UIView * signBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame)+5, viewWidth, 70)];
    [signBottom addSubview:signBtnView];
    
    UIImageView * ssImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 70)];
    ssImageView.image = [UIImage imageNamed:@"pic-points6"];
    [signBtnView addSubview:ssImageView];
    
    
    UILabel * lineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(signBtnView.frame)+10, viewWidth-20, 1)];
    lineLabel1.backgroundColor = lgrayColor;
    [signBottom addSubview:lineLabel1];
    
    UILabel * titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(lineLabel1.frame)+10 , viewWidth-20, 20)];
    titleLabel1.text = @"2.选择进入项目详情";
    titleLabel1.font = titleFont_15;
    titleLabel1.textColor = lgrayColor;
    [signBottom addSubview:titleLabel1];
    
    
    UIView * tabView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel1.frame)+5, viewWidth, 70)];
    [signBottom addSubview:tabView];
    
    UIImageView * picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 70)];
    picImageView.image = [UIImage imageNamed:@"pic-points7"];
    [tabView addSubview:picImageView];
    
    
    
    UILabel * lineLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(tabView.frame)+10, viewWidth-20, 1)];
    lineLabel2.backgroundColor = lgrayColor;
    [signBottom addSubview:lineLabel2];
    
    
    
    UILabel * signinLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(lineLabel2.frame)+10 , viewWidth-20, 20)];
    signinLabel.text = @"3.点击“点评挣积分，马上点评”撰写您的点评";
    signinLabel.font = titleFont_15;
    signinLabel.textColor = lgrayColor;
    [signBottom addSubview:signinLabel];
    
    UIView * tabView1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(signinLabel.frame)+5, viewWidth, 50)];
    [signBottom addSubview:tabView1];
    
    UIImageView * picImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 50)];
    picImageView1.image = [UIImage imageNamed:@"pic-points8"];
    [tabView1 addSubview:picImageView1];
    
    UILabel * lineLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(tabView1.frame)+10, viewWidth-20, 1)];
    lineLabel3.backgroundColor = lgrayColor;
    [signBottom addSubview:lineLabel3];
    
    UILabel * signinLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(lineLabel3.frame)+10 , viewWidth-20, 40)];
    signinLabel1.text = @"4.每天首次提问、回答、答案被采纳均可获取积分";
    signinLabel1.numberOfLines = 0;
    signinLabel1.font = titleFont_15;
    signinLabel1.textColor = lgrayColor;
    [signBottom addSubview:signinLabel1];
    
    scrollView.contentSize = CGSizeMake(viewWidth, CGRectGetMaxY(signBottom.frame));
}

#pragma mark -- 签到
-(void)SignbtnClick:(UIButton *)btn{
    
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                     message:@"恭喜你签到成功"
//                                                    delegate:self
//                                           cancelButtonTitle:@"好"
//                                           otherButtonTitles:nil, nil];
//    [alert show];
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
