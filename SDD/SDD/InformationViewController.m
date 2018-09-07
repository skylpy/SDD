//
//  InformationViewController.m
//  SDD
//  完善资料
//  Created by mac on 15/12/3.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "InformationViewController.h"
#import "SignInTopView.h"
#import "SignInBottomView.h"

#import "SignInBtn.h"
#import "PersonalTabButton.h"

@interface InformationViewController ()

@end

@implementation InformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    [self setNav:@"完善资料"];
    
    [self createUI];
}
-(void)createUI{
    
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    
    [self.view addSubview:scrollView];
    NSString * desStr = @"您可以在商多多APP我的资料中将资料完善，完善完成后奖励10积分";
    
    CGSize signSize = [Tools_F countingSize:desStr fontSize:15 width:(viewWidth-20)];
    
    SignInTopView * signView = [[SignInTopView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, signSize.height+60)];
    signView.backgroundColor = [UIColor whiteColor];
    signView.IntegralRules.text = @"积分规则";
    signView.textLabel.text = desStr;
    
    [scrollView addSubview:signView];
    
    SignInBottomView * signBottom = [[SignInBottomView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(signView.frame)+10, viewWidth, 300)];
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
    
    UILabel * titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(lineLabel1.frame)+10 , viewWidth-20, 30)];
    titleLabel1.text = @"2.点击头像与名称进入“我的资料”页面进行完善资料";
    titleLabel1.font = titleFont_15;
    titleLabel1.numberOfLines = 0;
    titleLabel1.textColor = lgrayColor;
    [signBottom addSubview:titleLabel1];
    

    UIView * tabView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel1.frame)+5, viewWidth, 70)];
    [signBottom addSubview:tabView];
    
    UIImageView * ssImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 60)];
    ssImageView.image = [UIImage imageNamed:@"pic-points5"];
    [tabView addSubview:ssImageView];
    
    
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
