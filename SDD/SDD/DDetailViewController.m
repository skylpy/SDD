//
//  DDetailViewController.m
//  SDD
//
//  Created by hua on 15/7/17.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "DDetailViewController.h"
#import "DynamicDetailModel.h"

#import "ShareHelper.h"

@interface DDetailViewController ()<UIWebViewDelegate>{
    
    /*- ui -*/
    
    UIWebView *webV;
    
    /*- data -*/
    
    NSMutableArray *dataSource;
    DynamicDetailModel *ddmodel;
}

@end

@implementation DDetailViewController

#pragma mark - 请求数据
- (void)requestData{
    
    NSDictionary *param = @{@"dynamicId":[NSNumber numberWithInteger:_dynamicId]};
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/dynamic/detail.do" params:param success:^(id JSON) {
        
        //        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSArray *dict = JSON[@"data"];
        
        if (![dict isEqual:[NSNull null]]) {
            
            ddmodel = [DynamicDetailModel objectWithKeyValues:dict];
            
            // 导航条
            [self setupNav];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 请求数据
    [self requestData];
    // ui
    [self setupUI];
}

#pragma mark - 设置导航条
- (void)setupNav{
    
    //[self setNav:_categoryTitle];
    [self setNav:@"详情"];
    
    // 导航条右
    UIButton *star = [UIButton buttonWithType:UIButtonTypeCustom];
    star.frame = CGRectMake(0, 0, 20, 20);
    [star setBackgroundImage:[UIImage imageNamed:@"收藏-图标"] forState:UIControlStateNormal];
    [star setBackgroundImage:[UIImage imageNamed:@"收藏星星"] forState:UIControlStateSelected];
    [star addTarget:self action:@selector(starClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 判断是否收藏
    if (ddmodel.isCollection == 1) {
        star.selected = YES;
    }
    
//    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
//    share.frame = CGRectMake(0, 0, 19, 20);
//    [share setBackgroundImage:[UIImage imageNamed:@"分享-图标"] forState:UIControlStateNormal];
//    [share addTarget:self action:@selector(GPshareBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barStar = [[UIBarButtonItem alloc]initWithCustomView:star];
    //UIBarButtonItem *barShare = [[UIBarButtonItem alloc]initWithCustomView:share];
    self.navigationItem.rightBarButtonItems = @[barStar];
}

#pragma mark - 设置内容
- (void)setupUI {
    
    // 加载webview
    webV = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-20)];
    webV.backgroundColor = bgColor;
    webV.delegate = self;
    webV.scrollView.directionalLockEnabled = YES;
    webV.scrollView.bounces = YES;
    ///    webV.scalesPageToFit = YES;
    
    [self requesUrl:[NSString stringWithFormat:@"/dynamic/dynamicDetail.do?dynamicId=%@",@(_dynamicId)]];
    
//    [webV.scrollView.panGestureRecognizer addTarget:self action:@selector(pan:)];      // 添加拖拽手势
    [self.view addSubview:webV];
}

#pragma mark - 加载url
- (void)requesUrl:(NSString *)url{
    
    NSString *urlStr = [SDD_MainURL stringByAppendingString:url];
    NSLog(@"%@",urlStr);
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [webV loadRequest:request];
}

#pragma mark - webview代理 根据url进行跳转
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSLog(@" 跳向url ==========%@",request.URL);
    
    if ([[NSString stringWithFormat:@"%@",request.URL] isEqualToString:@"http://www.baidu.com/"]) {
        
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    return YES;
}

- (void)GPshareBtn{
    //[NSString stringWithFormat:@"%@",self.model.icon]self.model.title
    [ShareHelper shareIn:self content:[NSString stringWithFormat:@"%@ %@  http://www.shangdodo.com",self.model.title,self.model.icon] url:@"http://www.shangdodo.com"];
}

#pragma mark - 收藏/取消收藏
- (void)starClick:(UIButton *)btn{
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else {
        
        NSDictionary *dic = @{
                              @"dynamicId":[NSNumber numberWithInteger:_dynamicId],
                              @"isCollection":btn.isSelected?@0:@1
                              };
        [self addOrCancelFavorite:[SDD_MainURL stringByAppendingString:@"/dynamicCollection/save.do"] param:dic button:btn];
    }
}

- (void)addOrCancelFavorite:(NSString *)url param:(NSDictionary *)dic button:(UIButton *)btn{
    
    [self.httpManager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = responseObject;
        if ([dict[@"status"] intValue] == 1) {
            
            [self showSuccessWithText:dict[@"message"]];
            btn.selected = !btn.selected;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
}

#pragma mark - leftaction
- (void)leftAction:(UIButton *)btn{
    
    NSLog(@"返回");
    if (self.presentingViewController) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
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
