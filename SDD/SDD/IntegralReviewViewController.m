//
//  IntegralReviewViewController.m
//  SDD
//  积分点评
//  Created by mac on 15/12/3.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "IntegralReviewViewController.h"
#import "SignInTopView.h"
#import "SignInBottomView.h"

#import "SignInBtn.h"
#import "PersonalTabButton.h"

@interface IntegralReviewViewController ()

@end

@implementation IntegralReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    [self setNav:@"点评"];
    
    [self createUI];
}

-(void)createUI{
    
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    
    [self.view addSubview:scrollView];
    
    NSString * desStr = @"您可以在商多多APP对项目或品牌发表点评，真实表达个人观点，奖励1积分，入选精华点评奖励100积分";
    
    CGSize signSize = [Tools_F countingSize:desStr fontSize:15 width:(viewWidth-20)];
    
    SignInTopView * signView = [[SignInTopView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, signSize.height+60)];
    signView.backgroundColor = [UIColor whiteColor];
    signView.IntegralRules.text = @"积分规则";
    signView.textLabel.text = desStr;
    
    [scrollView addSubview:signView];
    
    SignInBottomView * signBottom = [[SignInBottomView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(signView.frame)+10, viewWidth, 420)];
    signBottom.backgroundColor = [UIColor whiteColor];
    signBottom.IntegralRules.text = @"如何点评";
    [scrollView addSubview:signBottom];
    
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,50 , viewWidth-20, 20)];
    titleLabel.text = @"1.APP首页搜索想要点评的项目";
    titleLabel.font = titleFont_15;
    titleLabel.textColor = lgrayColor;
    [signBottom addSubview:titleLabel];
    
    
    UIView * signBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame)+5, viewWidth, 50)];
    [signBottom addSubview:signBtnView];
    
    UIImageView * ssImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 50)];
    ssImageView.image = [UIImage imageNamed:@"pic-points3"];
    [signBtnView addSubview:ssImageView];
    
    
    UILabel * lineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(signBtnView.frame)+10, viewWidth-20, 1)];
    lineLabel1.backgroundColor = lgrayColor;
    [signBottom addSubview:lineLabel1];
    
    UILabel * titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(lineLabel1.frame)+10 , viewWidth-20, 20)];
    titleLabel1.text = @"2.选择进入项目详情";
    titleLabel1.font = titleFont_15;
    titleLabel1.textColor = lgrayColor;
    [signBottom addSubview:titleLabel1];
    

    UIView * tabView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel1.frame)+5, viewWidth, 100)];
    [signBottom addSubview:tabView];
    
    UIImageView * picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    picImageView.image = [UIImage imageNamed:@"pic-points4"];
    [tabView addSubview:picImageView];
    

    
    UILabel * lineLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(tabView.frame)+10, viewWidth-20, 1)];
    lineLabel2.backgroundColor = lgrayColor;
    [signBottom addSubview:lineLabel2];
    
    
    
    UILabel * signinLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(lineLabel2.frame)+10 , viewWidth-20, 20)];
    signinLabel.text = @"3.点击“点评挣积分，马上点评”撰写您的点评";
    signinLabel.font = titleFont_15;
    signinLabel.textColor = lgrayColor;
    [signBottom addSubview:signinLabel];
    
    UIButton * Signbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    Signbtn.frame = CGRectMake(20, CGRectGetMaxY(signinLabel.frame)+10, viewWidth-40, 35);
    Signbtn.backgroundColor = [UIColor whiteColor];
    [Tools_F setViewlayer:Signbtn cornerRadius:5 borderWidth:1 borderColor:dblueColor];
    [Signbtn setTitle:@"点评赚积分，马上点评" forState:UIControlStateNormal];
    [Signbtn setTitleColor:dblueColor forState:UIControlStateNormal];
    Signbtn.titleLabel.font = midFont;
    [Signbtn addTarget:self action:@selector(SignbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [signBottom addSubview:Signbtn];
    
    scrollView.contentSize = CGSizeMake(viewWidth, CGRectGetMaxY(signBottom.frame)+30);
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
