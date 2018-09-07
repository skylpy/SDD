//
//  ActivityDataViewController.m
//  SDD
//
//  Created by mac on 15/12/31.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ActivityDataViewController.h"
#import "ThemeApplyViewController.h"
#import "sponsorViewController.h"
#import "ShareHelper.h"

@interface ActivityDataViewController ()
{

    UIWebView * webView;
    NSInteger todayD;
}
@end

@implementation ActivityDataViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    
    NSDate *datenow = [NSDate date];  // 获取现在时间
    todayD = (NSInteger)[datenow timeIntervalSince1970];
    
    [self createUI];
    [self setupNav];
}
- (void)GRshareBtn{
    
    [ShareHelper shareIn:self content:[NSString stringWithFormat:@"%@/n%@",[Tools_F timeTransform:[_model.time intValue] time:minutes],_model.addressShort] url:[NSString stringWithFormat:@"http://www.91sydc.com/user_mobile/web/appActivity.do?activityForumsId=%@",_activityId] image:_model.icon title:_model.title];
    
}
-(void)setupNav{

    [self setNav:_titles];
    
    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
    share.frame = CGRectMake(0, 0, 19, 20);
    [share setBackgroundImage:[UIImage imageNamed:@"分享-图标"] forState:UIControlStateNormal];
    [share addTarget:self action:@selector(GRshareBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barShare = [[UIBarButtonItem alloc]initWithCustomView:share];
    self.navigationItem.rightBarButtonItems = @[barShare];
}
-(void)createUI{

    
    // 加载webview
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-70)];
    webView.backgroundColor = bgColor;
    webView.scrollView.directionalLockEnabled = YES;
    webView.scrollView.bounces = YES;
    webView.scalesPageToFit = YES;
    
    [self requesUrl:[NSString stringWithFormat:@"http://www.91sydc.com/user_mobile/web/appActivity.do?activityForumsId=%@",_activityId]];
    
    [self.view addSubview:webView];
    
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight-115, viewWidth, 55)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //            leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [leftButton.layer setMasksToBounds:YES];
    [leftButton.layer setCornerRadius:10.0];
    leftButton.frame = CGRectMake(20, viewHeight-110, viewWidth/2-40, 40);
    
//    NSString * strleft = todayD - [_model.time integerValue] < 0 ? @"立即报名":@"已结束";
//    leftButton.enabled = todayD - [_model.time integerValue] < 0 ? YES:NO;
//    [leftButton setTitle:strleft forState:UIControlStateNormal];
    
//    UIColor * backColor = todayD - [_model.time integerValue] < 0 ? [UIColor colorWithRed:(253/255.0) green:(149/255.0) blue:(10/255.0) alpha:(1.0)] : lgrayColor;
    
    NSString * strleft = todayD - [_model.signupTime integerValue] < 0 ? ([_model.isSignup integerValue] == 0 ?@"筹划中...":@"筹划中..."):@"筹划中...";
    leftButton.enabled = todayD - [_model.signupTime integerValue] < 0 ? ([_model.isSignup integerValue] == 0 ?NO:NO):NO;
    
    UIColor *callColor = todayD - [_model.signupTime integerValue] < 0 ?([_model.isSignup integerValue] == 0 ?lgrayColor:lgrayColor):lgrayColor;
    [leftButton setTitle:strleft forState:UIControlStateNormal];
    leftButton.backgroundColor = callColor;
//    if ([_isSignup integerValue] == 0)
//    {
//        
//        leftButton.backgroundColor  = [UIColor colorWithRed:(253/255.0) green:(149/255.0) blue:(10/255.0) alpha:(1.0)];
//        
//    }
//    else
//    {
//        [leftButton setTitle:@"已报名" forState:UIControlStateNormal];
//        leftButton.backgroundColor = lgrayColor;
//        leftButton.enabled = NO;
//        
//    }
    
    [leftButton addTarget:self action:@selector(leftButtonDDD:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
    
    UIButton *rightButton   = [UIButton buttonWithType:UIButtonTypeCustom];
    
    NSString * strright = todayD - [_model.signupTime integerValue] < 0 ? ([_model.isSponsor integerValue] == 0 ?@"我要赞助":@"已赞助"):@"已结束";
    rightButton.enabled = todayD - [_model.signupTime integerValue] < 0 ? ([_model.isSponsor integerValue] == 0 ?YES:NO):NO;
    
    UIColor *callrrColor = todayD - [_model.signupTime integerValue] < 0 ?([_model.isSponsor integerValue] == 0 ?tagsColor:lgrayColor):lgrayColor;
    [rightButton setTitle:strright forState:UIControlStateNormal];
    rightButton.backgroundColor = callrrColor;
//    NSString * strright = todayD - [_model.time integerValue] < 0 ? @"我要赞助":@"已结束";
//    rightButton.enabled = todayD - [_model.time integerValue] < 0 ? YES:NO;
//    [rightButton setTitle:strright forState:UIControlStateNormal];
//    
//    
//    if ([_isSponsor integerValue] == 0) {
//        
//        rightButton.backgroundColor  = dblueColor;//[UIColor colorWithRed:(16/255.0) green:(118/255.0) blue:(224/255.0) alpha:(1.0)];
//        
//    }
//    else
//    {
//        [rightButton setTitle:@"已赞助" forState:UIControlStateNormal];
//        rightButton.backgroundColor = lgrayColor;
//        rightButton.enabled = NO;
//    }
    //            rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rightButton.layer setMasksToBounds:YES];
    [rightButton.layer setCornerRadius:10.0];
    rightButton.frame = CGRectMake(20+viewWidth/2, viewHeight-110, viewWidth/2-40, 40);
    [rightButton addTarget:self action:@selector(rightButtonDDD:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
}

-(void)leftButtonDDD:(UIButton *)btn
{
    NSLog(@"left");

    
    NSString *confromTimespStr = [Tools_F timeTransform:[_activityTime intValue] time:minutes];//[formatter stringFromDate:confromTimesp];
    
    ThemeApplyViewController * thVc = [[ThemeApplyViewController alloc] init];
    thVc.actNum = 2;


    thVc.model = _model;
    thVc.confromTimespStr = confromTimespStr;

    thVc.str2 = _model.addressShort;

    thVc.str1 = _model.title;
    
    
    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;
    [self.navigationController pushViewController:thVc animated:YES];
}
-(void)rightButtonDDD:(UIButton *)btn
{
    NSLog(@"right");
    sponsorViewController *sVC = [[sponsorViewController alloc]init];
    sVC.model = _model;
    [self.navigationController pushViewController:sVC animated:YES];
}
#pragma mark - 加载url
- (void)requesUrl:(NSString *)url{
    
   
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [webView loadRequest:request];
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
