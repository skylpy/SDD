//
//  WebviewController.m
//  SDD
//  浏览器 Controller 父类
//  Created by Cola on 15/4/22.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "WebviewController.h"

@interface WebviewController ()<UIWebViewDelegate>

@end

@implementation WebviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    
    statusBarView.backgroundColor = deepOrangeColor;
    
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    [self initWebview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initWebview{
    
    _dynamicWebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, viewWidth, viewHeight-70)];
    _dynamicWebview.scalesPageToFit =YES;
    _dynamicWebview.delegate =self;
    
    [self.view addSubview:_dynamicWebview];
}

@end
