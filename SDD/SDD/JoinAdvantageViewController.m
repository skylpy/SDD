//
//  JoinAdvantageViewController.m
//  SDD
//
//  Created by hua on 15/6/24.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "JoinAdvantageViewController.h"

@interface JoinAdvantageViewController ()<UIGestureRecognizerDelegate>

@end

@implementation JoinAdvantageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 导航条
    [self setNav:@"加盟优势"];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    UILabel *content = [[UILabel alloc] init];
    content.font = midFont;
    content.textColor = lgrayColor;
    content.text = _joinAdvantageContent;
    content.numberOfLines = 0;
    [self.view addSubview:content];
    
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(10);
        make.left.equalTo(self.view.mas_left).with.offset(8);
        make.right.equalTo(self.view.mas_right).with.offset(-8);
        make.height.mas_greaterThanOrEqualTo(13);
    }];
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
