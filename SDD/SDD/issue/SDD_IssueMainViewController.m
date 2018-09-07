//
//  SDD_IssueMainViewController.m
//  SDD
//
//  Created by mac on 15/7/7.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "SDD_IssueMainViewController.h"
#import "Header.h"
#import "CertifyFirstStep.h"
#import "ModuleButton.h"

#import "ProjectPublishViewController.h"
#import "BrankPublishViewController.h"
#import "BrankAuthenticationViewController.h"
#import "DevCerViewController.h"


@interface SDD_IssueMainViewController ()<UIAlertViewDelegate>{
    
    NSInteger isHouseUser;      // 是否发展商
    NSInteger isBrandUser;      // 是否品牌商
}

@end

@implementation SDD_IssueMainViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.viewForBaselineLayout.hidden = NO;      //  显示tabar
    
    [self requestUserInfo];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = bgColor;
    
    isHouseUser = 0;
    isBrandUser = 0;
    
    // 导航条
    [self setupNav];
    [self createTopView];
}

#pragma mark - 用户信息
- (void)requestUserInfo{
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/user/detail.do" params:nil success:^(id JSON) {
        //            NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSDictionary *dict = JSON[@"data"];
        
        if (![dict isEqual:[NSNull null]]) {
            
            isBrandUser = [dict[@"isBrandUser"] integerValue];
            isHouseUser = [dict[@"isHouseUser"] integerValue];
        }
    } failure:^(NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
}

#pragma mark - 设置导航条
- (void)setupNav{
    
    // 导航条中间视图
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 0, 120, 20);
    titleLabel.text = @"选择发布类型";
    titleLabel.font = biggestFont;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
}

- (void)createTopView{
    
//    UILabel *tips = [[UILabel alloc] init];
//    tips.frame = CGRectMake(10, 0, viewWidth-20, 30);
//    tips.text = @"品牌发布程序猿们正在通宵开发中,敬请期待";
//    tips.font = midFont;
//    tips.textColor = lgrayColor;
//    [self.view addSubview:tips];
    
    NSDictionary *itemDic  = @{@"headerTitle": @[@"项目发布",
                                                 @"品牌发布",
                                                 @"敬请期待"],
                               @"headerIcon": @[@"icon_project_release",
                                                @"icon_brand_release",
                                                @"stay_tuned_for_icon"]
                               };
    
    UIView *view_bg = [[UIView alloc] init];
    view_bg.frame = CGRectMake(0, 0, viewWidth, 110);
    view_bg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view_bg];
    
    for (int i=0; i<3; i++) {
        
        ModuleButton *moduleButton = [[ModuleButton alloc] initWithFrame:CGRectMake((viewWidth/3)*(i%3), 110*(i/3), viewWidth/3, 110)];
        CGSize btnSize = CGSizeMake(viewWidth/3, 110);
        [moduleButton setBackgroundImage:[Tools_F imageWithColor:bgColor size:btnSize] forState:UIControlStateHighlighted];
        moduleButton.icon.image = [UIImage imageNamed:itemDic[@"headerIcon"][i]];
        moduleButton.tag = i+100;
        moduleButton.bottomLabel.text = itemDic[@"headerTitle"][i];
        moduleButton.bottomLabel.font = titleFont_15;
        moduleButton.bottomLabel.textColor = [UIColor blackColor];
        [moduleButton addTarget:self action:@selector(pageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [view_bg addSubview:moduleButton];
        
        if (i>1) {
            
            moduleButton.bottomLabel.textColor = lgrayColor;
            moduleButton.enabled = NO;
        }
    }
    
    UIView *cutoff = [[UIView alloc] init];
    cutoff.frame = CGRectMake(viewWidth/3, 10, 1, 90);
    cutoff.backgroundColor = ldivisionColor;
    [view_bg addSubview:cutoff];
    
    UIView *cutoff2 = [[UIView alloc] init];
    cutoff2.frame = CGRectMake(viewWidth*2/3, 10, 1, 90);
    cutoff2.backgroundColor = ldivisionColor;
    [view_bg addSubview:cutoff2];
}

- (void)leftButtonClick:(UIButton*)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pageButtonClick:(UIButton*)sender{
    
//    ProjectPublishViewController *loginVC = [[ProjectPublishViewController alloc] init];
//    
//    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
//    [self.navigationController pushViewController:loginVC animated:YES];
    
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        
        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else {
        
        switch (sender.tag) {
            case 100:{
                if (isHouseUser == 0) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"大人！您还没认证，请先去认证再来发布吧！" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                    alert.tag = 100;
                    [alert show];
                }
                else if (isHouseUser == 1){
                    
                    SDD_BasicInformation *itemVC  =[[SDD_BasicInformation alloc] init];
                    
                    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
                    [self.navigationController pushViewController:itemVC animated:YES];
                }
                else {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的认证正在审核中哦" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
                break;
            case 101:{
                
                if (isBrandUser == 0) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您当前非认证品牌商，认证后可发布品牌加盟，是否认证？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                    alert.tag = 101;
                    [alert show];
                }
                else if (isBrandUser == 1){
                    
                    BrankPublishViewController *bpVC = [[BrankPublishViewController alloc] init];
                    
                    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
                    [self.navigationController pushViewController:bpVC animated:YES];
                }
                else {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的认证正在审核中哦" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
                break;                
            default:
                break;
        }
    }
}

#pragma mark - alertView代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 1:
        {
            switch (alertView.tag) {
                case 100:
                {
                    
                    //CertifyFirstStep * cerVc = [[CertifyFirstStep alloc] init];
                    DevCerViewController * cerVc = [[DevCerViewController alloc] init];
                    
                    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
                    [self.navigationController pushViewController:cerVc animated:YES];
                }
                    break;
                case 101:
                {
                    BrankAuthenticationViewController *baVC = [[BrankAuthenticationViewController alloc] init];
                    
                    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
                    [self.navigationController pushViewController:baVC animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

//#pragma mark -- 必选的没选提示按钮
//- (void)showAlert:(NSString *) _message{
//    
//    //时间
//    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
//    [NSTimer scheduledTimerWithTimeInterval:1.5f
//                                     target:self
//                                   selector:@selector(timerFireMethod:)
//                                   userInfo:promptAlert
//                                    repeats:YES];
//    [promptAlert show];
//}
//
//- (void)timerFireMethod:(NSTimer*)theTimer{
//    
//    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
//    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
//    promptAlert =NULL;
//}

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
