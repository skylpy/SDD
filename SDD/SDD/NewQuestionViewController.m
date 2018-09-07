//
//  NewQuestionViewController.m
//  SDD
//
//  Created by hua on 15/7/28.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "NewQuestionViewController.h"

#import "NewQuestionTagsViewController.h"

#import "LPlaceholderTextView.h"


@interface NewQuestionViewController ()<UIGestureRecognizerDelegate,UITextViewDelegate>{
    
    // 问题描述
    LPlaceholderTextView *questionDescribe;
    
    UITextField * IntegralField;
    
    NSDictionary * dictD;
}

@end

@implementation NewQuestionViewController
-(void)reqtestData{
    
    //我的积分 + 是否已签到
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/score/myScoreAndCheckSignup.do" params:nil success:^(id JSON) {
        
        NSLog(@"%@",JSON);
        if (![JSON[@"data"] isEqual:[NSNull null]]) {
            
            dictD = JSON[@"data"];
        }
        [self setupUI];
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.view.backgroundColor = bgColor;
    
    // 导航条
    [self setNav:@"我要提问"];
    [self reqtestData];
    // 设置内容
    
    [self setupNav];
}

#pragma mark - 设置导航条
- (void)setupNav{
    
    // 导航条右btn
    UIButton *nextStep = [UIButton buttonWithType:UIButtonTypeCustom];
    nextStep.frame = CGRectMake(0, 0, 70, 20);
    nextStep.titleLabel.font = biggestFont;
    [nextStep setTitle:@"下一步" forState:UIControlStateNormal];
    [nextStep addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:nextStep];;
}

#pragma mark - 设置内容
- (void)setupUI{
    
    questionDescribe = [[LPlaceholderTextView alloc] init];
    questionDescribe.placeholderText = @"请描述您的问题，提高悬赏积分，可以更快得到答案~";
    questionDescribe.font = midFont;
    [self.view addSubview:questionDescribe];
    
    [questionDescribe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.size.mas_equalTo(CGSizeMake(viewWidth, viewHeight/3));
    }];
    
    UILabel * myIntegraLable = [[UILabel alloc] init];//WithFrame:CGRectMake(10, viewHeight/3+10, viewWidth/2.5, 20)
    myIntegraLable.textColor = tagsColor;
    myIntegraLable.font = titleFont_15;
    [self.view addSubview:myIntegraLable];
    
    
    NSString * originalString = [NSString stringWithFormat:@"我的积分:  %@",
                      dictD[@"score"]];
    NSMutableAttributedString *paintString = [[NSMutableAttributedString alloc] initWithString:originalString];
    [paintString addAttribute:NSForegroundColorAttributeName
                        value:lgrayColor
                        range:[originalString
                               rangeOfString:@"我的积分:  "]];
    myIntegraLable.attributedText = paintString;
    
    [myIntegraLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.top.equalTo(questionDescribe.mas_bottom).with.offset(8);
        make.size.mas_equalTo(CGSizeMake(viewWidth/2.5, 20));
    }];
    
    UILabel * intgLabel = [[UILabel alloc] init];
    intgLabel.textColor = lgrayColor;
    intgLabel.font = titleFont_15;
    intgLabel.text = @"积分";
    [self.view addSubview:intgLabel];
    
    [intgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.top.equalTo(self.view.mas_top).with.offset(viewHeight/3+10);
        //make.width.equalTo(@40);
    }];
    
    IntegralField = [[UITextField alloc] init];
    IntegralField.borderStyle = UITextBorderStyleRoundedRect;
    IntegralField.text = @"0";
    IntegralField.keyboardType = UIKeyboardTypeNumberPad;   //设置键盘的样式
    [self.view addSubview:IntegralField];
    [IntegralField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(intgLabel.mas_left).with.offset(-8);
        make.top.equalTo(questionDescribe.mas_bottom).with.offset(5);
        make.height.equalTo(@25);
        make.width.equalTo(@60);
    }];
    
    UILabel * xshLabel = [[UILabel alloc] init];
    xshLabel.textColor = lgrayColor;
    xshLabel.font = titleFont_15;
    xshLabel.text = @"悬赏";
    [self.view addSubview:xshLabel];
    
    [xshLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(IntegralField.mas_left).with.offset(-10);
        make.top.equalTo(questionDescribe.mas_bottom).with.offset(8);
        
    }];
}

#pragma mark - leftaction
- (void)leftAction:(UIButton *)btn{
    
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 下一步
- (void)next:(UIButton *)btn{
    
    if (questionDescribe.text.length < 5) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"问题描述最少5个字" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (iOS_version < 7.5) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"适配低版本中……" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        
        NewQuestionTagsViewController *nqtVC = [[NewQuestionTagsViewController alloc] init];
        nqtVC.questionDescribe = questionDescribe.text;
        nqtVC.integralStr = IntegralField.text;
        [self.navigationController pushViewController:nqtVC animated:YES];
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
