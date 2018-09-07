//
//  DynamicDetailViewController.m
//  SDD
//
//  Created by hua on 15/6/23.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "DynamicDetailViewController.h"

@interface DynamicDetailViewController ()

@end

@implementation DynamicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 导航条
    [self setNav:@"最新动态"];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    UILabel *title = [[UILabel alloc] init];
    title.font = largeFont;
    title.text = _dynamicTitle;
    [self.view addSubview:title];
    
    UILabel *content = [[UILabel alloc] init];
    content.font = midFont;
    content.textColor = lgrayColor;
    content.text = _dynamicContent;
    content.numberOfLines = 0;
    [self.view addSubview:content];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(10);
        make.left.equalTo(self.view.mas_left).with.offset(8);
        make.size.mas_equalTo(CGSizeMake(viewWidth-16, 16));
    }];
    
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).with.offset(10);
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
