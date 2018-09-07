//
//  JoinUsViewController.m
//  SDD
//
//  Created by hua on 15/9/22.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "JoinUsViewController.h"

@interface JoinUsViewController (){
    
    /*- ui -*/
    
    UIWebView *webV;
    
}

@end

@implementation JoinUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = bgColor;
    // nav
    [self setNav:@"加入我们"];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置内容
- (void)setupUI {
    
    // 加载webview
    webV = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-20)];
    webV.backgroundColor = bgColor;
    webV.scrollView.directionalLockEnabled = YES;
    webV.scrollView.bounces = YES;
    webV.scalesPageToFit = YES;
    
    [self requesUrl:@"http://m.51job.com/search/joblist.php?jobarea=030200&keyword=%E4%B9%9D%E5%90%88%E9%A3%9E%E4%B8%80&keywordtype=2&_t=indexhistory"];
    
    //    [webV.scrollView.panGestureRecognizer addTarget:self action:@selector(pan:)];      // 添加拖拽手势
    [self.view addSubview:webV];
}

#pragma mark - 加载url
- (void)requesUrl:(NSString *)url{
    
//    NSString *urlStr = [SDD_MainURL stringByAppendingString:url];
//    NSLog(@"%@",urlStr);
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [webV loadRequest:request];
}

//#pragma mark - 设置内容
//- (void)setupUI{
//    
//    // 底部滚动
//    UIScrollView *bg_scrollView = [[UIScrollView alloc] init];
//    bg_scrollView.backgroundColor = bgColor;
//    [self.view addSubview:bg_scrollView];
//    [bg_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//    }];
//    
//    // 底部view， 用于计算scrollview高度
//    UIView *contentView = [[UIView alloc] init];
//    contentView.backgroundColor = bgColor;
//    [bg_scrollView addSubview:contentView];
//    
//    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(bg_scrollView);
//        make.width.equalTo(bg_scrollView);
//    }];
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
