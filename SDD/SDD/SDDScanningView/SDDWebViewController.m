//
//  SDDWebViewController.m
//  SDD
//
//  Created by mac on 15/5/18.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "SDDWebViewController.h"

@interface SDDWebViewController ()
{
    UIWebView *_webView;
}

@end

@implementation SDDWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 设置导航条
- (void)setupNav{
    
    SDDButton *button = [[SDDButton alloc]init];
    button.frame = CGRectMake(0, 0, 30, 44);
    [button setTitle:@"" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(webViewBackAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

- (void)webViewBackAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)loadWithURLString:(NSString *)urlString
{
    UIWebView *webView = [[UIWebView alloc]init];
    webView.backgroundColor = [UIColor whiteColor];
    webView.frame = CGRectMake(0, 0, viewWidth, self.view.frame.size.height-15);
    webView.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:webView];
    _webView = webView;
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *requset = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:requset];
    
    NSLog(@"=========%@",url);
    
}

@end
