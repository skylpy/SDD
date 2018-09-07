//
//  IntroductionViewController.m
//  商多多
//
//  Created by hua on 15/4/9.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "IntroductionViewController.h"

@interface IntroductionViewController ()<UIGestureRecognizerDelegate>{
    
}

// 楼盘简介标题
@property (nonatomic, strong) UILabel *introductionTitle;
// 楼盘简介内容
@property (nonatomic, strong) UILabel *introductionContent;
// 发展商背景标题
@property (nonatomic, strong) UILabel *developerTitle;
// 发展商内容
@property (nonatomic, strong) UILabel *developerContent;

@end

@implementation IntroductionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 导航条
    [self setupNav];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置导航条
- (void)setupNav{
    
    SDDButton *button = [[SDDButton alloc]init];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"项目介绍";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

#pragma mark - 设置内容
- (void)setupUI{
    
    _introductionTitle = [[UILabel alloc] init];
    _introductionTitle.frame = CGRectMake(8, 10, viewWidth-16, 20);
    _introductionTitle.font = largeFont;
    _introductionTitle.textColor = dblueColor;
    _introductionTitle.text = @"楼盘简介";
    
    [self.view addSubview:_introductionTitle];
    
    _introductionContent = [[UILabel alloc] init];
    _introductionContent.frame = CGRectMake(8, CGRectGetMaxY(_introductionTitle.frame)+5, viewWidth-16, 13);
    _introductionContent.numberOfLines = 0;
    _introductionContent.font = midFont;
    _introductionContent.textColor = lgrayColor;
    _introductionContent.text = _introductionString;
    [_introductionContent sizeToFit];
    [self.view addSubview:_introductionContent];
    
    _developerTitle = [[UILabel alloc] init];
    _developerTitle.frame = CGRectMake(8, CGRectGetMaxY(_introductionContent.frame)+8, viewWidth-16, 20);
    _developerTitle.font = largeFont;
    _developerTitle.textColor = dblueColor;
    _developerTitle.text = @"发展商背景";
    [self.view addSubview:_developerTitle];
    
    _developerContent = [[UILabel alloc] init];
    _developerContent.frame = CGRectMake(8, CGRectGetMaxY(_developerTitle.frame)+5, viewWidth-16, 13);
    _developerContent.numberOfLines = 0;
    _developerContent.font = midFont;
    _developerContent.textColor = lgrayColor;
    _developerContent.text = _developerString;
    [_developerContent sizeToFit];
    [self.view addSubview:_developerContent];
}

#pragma mark - leftaction
- (void)leftAction:(UIButton *)btn{
    
    NSLog(@"返回");
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
