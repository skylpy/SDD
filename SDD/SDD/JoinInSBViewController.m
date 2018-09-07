//
//  JoinInSBViewController.m
//  SDD
//
//  Created by mac on 15/11/10.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "JoinInSBViewController.h"

@interface JoinInSBViewController ()
{
    UIView * botView;
}
@property (retain,nonatomic)UIScrollView * scrollView;

@end

@implementation JoinInSBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createView];
    [self createNvn];
}
#pragma mark - 设置导航条
-(void)createNvn{
    
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"加盟商多多";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
}

- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createView{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-64)];
    _scrollView.contentSize = CGSizeMake(viewWidth, (viewHeight-64)*8);
    _scrollView.backgroundColor = bgColor;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
    
    
    for (int i = 0; i < 8; i ++) {
        
        UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, i*(viewHeight-64), viewWidth, viewHeight-64)];
        imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"pic-join-%d",i+1]];
        [_scrollView addSubview:imageV];
        
    }
    
    botView = [[UIView alloc] init];
    botView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:botView];
    
    UIButton *callButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [callButton setTitle:@"立即联系" forState:UIControlStateNormal];
    [callButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [callButton addTarget:self action:@selector(takePhone:) forControlEvents:UIControlEventTouchUpInside];
    [callButton setBackgroundColor:tagsColor];
    [botView addSubview:callButton];
    
    [botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 45));
    }];
    
    [callButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(botView);
    }];
}

#pragma mark - 底部3按钮方法
- (void)takePhone:(id)sender{
    
    //联系客服

    NSString *telNumber = [[NSString alloc] initWithFormat:@"telprompt://%@",@"4009918829"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telNumber]];
    
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
