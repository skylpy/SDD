//
//  SignInViewController.m
//  SDD
//
//  Created by mac on 15/12/2.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "SignInViewController.h"

#import "SignInTopView.h"
#import "SignInBottomView.h"

#import "SignInBtn.h"
#import "PersonalTabButton.h"

@interface SignInViewController ()

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    [self setNav:@"签到"];
    
    [self createUI];
}

-(void)createUI{

    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    
    [self.view addSubview:scrollView];
    
    NSString * desStr = @"您可以在商多多APP签到，送积分规则如下：\n1.第1天签到1积分\n2.连续签到10天，第10天得10积分，第11-19天10积分\n3.连续签到20天，第20天得20积分，第21-29天20积分\n4.连续签到30天，第30天得30积分，第31-39天30积分\n5.连续签到40天，第41天得40积分，以此类推\n（如中途断签，天数会重新累计哦）";
    
    CGSize signSize = [Tools_F countingSize:desStr fontSize:15 width:(viewWidth-20)];
    SignInTopView * signView = [[SignInTopView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, signSize.height+10)];//
    signView.backgroundColor = [UIColor whiteColor];
    signView.IntegralRules.text = @"积分规则";
    signView.textLabel.text = desStr;
    
    [scrollView addSubview:signView];
    
    
    
    SignInBottomView * signBottom = [[SignInBottomView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(signView.frame)+10, viewWidth, 360)];
    signBottom.backgroundColor = [UIColor whiteColor];
    signBottom.IntegralRules.text = @"积分规则";
    [scrollView addSubview:signBottom];
    
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,50 , viewWidth-20, 20)];
    titleLabel.text = @"1.APP首页点击“我的”";
    titleLabel.font = titleFont_15;
    titleLabel.textColor = lgrayColor;
    [signBottom addSubview:titleLabel];
    
    NSArray *unSelecterIcon         = @[@"tabbar_item_index_unSelected",@"tabbar_item_book_unSelected",
                                        @"tabbar_item_issue_unSelected",@"tabbar_item_mine_selected"];
    NSArray *viewControllersTitle   = @[@"首页",@"预约",@"发布",@"我的"];
    
    UIView * signBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame)+5, viewWidth, 50)];
    [signBottom addSubview:signBtnView];
    
    
    for (int i = 0; i < unSelecterIcon.count; i ++) {
        
        SignInBtn * signBtn = [[SignInBtn alloc] initWithFrame:CGRectMake(i * viewWidth/4, 0, viewWidth/4, 50)];
        //signBtn.backgroundColor = [UIColor blackColor];
        [signBtn setImage:[UIImage imageNamed:unSelecterIcon[i]] forState:UIControlStateNormal];
        signBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        signBtn.titleLabel.font = midFont;
        [signBtn setTitle:viewControllersTitle[i] forState:UIControlStateNormal];
        [signBtn setTitleColor:lgrayColor forState:UIControlStateNormal];
        [signBtnView addSubview:signBtn];
        if (i == 3) {
            [signBtn setTitleColor:dblueColor forState:UIControlStateNormal];
        }
    }
    
    UILabel * lineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(signBtnView.frame)+10, viewWidth-20, 1)];
    lineLabel1.backgroundColor = lgrayColor;
    [signBottom addSubview:lineLabel1];
    
    UILabel * titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(lineLabel1.frame)+10 , viewWidth-20, 20)];
    titleLabel1.text = @"2.点击积分";
    titleLabel1.font = titleFont_15;
    titleLabel1.textColor = lgrayColor;
    [signBottom addSubview:titleLabel1];
    
    UIView * signBtnView11 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel1.frame)+5, viewWidth, 70)];
    [signBottom addSubview:signBtnView11];
    
    UIImageView * ssImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 70)];
    ssImageView.image = [UIImage imageNamed:@"pic-points2"];
    [signBtnView11 addSubview:ssImageView];
    
    UILabel * lineLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(signBtnView11.frame)+10, viewWidth-20, 1)];
    lineLabel2.backgroundColor = lgrayColor;
    [signBottom addSubview:lineLabel2];
    
    UILabel * titleLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(lineLabel2.frame)+10 , viewWidth-20, 20)];
    titleLabel3.text = @"2.点击“今日签到+1”";
    titleLabel3.font = titleFont_15;
    titleLabel3.textColor = lgrayColor;
    [signBottom addSubview:titleLabel3];
    
    
    UILabel * signinLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(titleLabel3.frame)+10 , viewWidth-20, 20)];
    signinLabel.text = @"用户名称 2000 积分”";
    signinLabel.font = titleFont_15;
    signinLabel.textColor = lgrayColor;
    [signBottom addSubview:signinLabel];
    
    UIButton * Signbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    Signbtn.frame = CGRectMake(CGRectGetMaxX(signBottom.frame)-110, CGRectGetMaxY(titleLabel3.frame)+10, 90, 25);
    Signbtn.backgroundColor = tagsColor;
    Signbtn.layer.cornerRadius = 5;
    [Signbtn setTitle:@"每日签到+1" forState:UIControlStateNormal];
    Signbtn.titleLabel.font = midFont;
    Signbtn.clipsToBounds = YES;
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
