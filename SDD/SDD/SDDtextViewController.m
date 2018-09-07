//
//  SDDtextViewController.m
//  SDD
//
//  Created by mac on 15/11/17.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "SDDtextViewController.h"

@interface SDDtextViewController ()
{
    UIScrollView * _scrollView;
    
    UIWebView * myWebView;
}
@end

@implementation SDDtextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNav:@""];
    self.view.backgroundColor = bgColor;
    [self createView];
}

-(void)createView
{
    //取得欲读取档案的位置与文件名
    
    NSString *resourcePath = [ [NSBundle mainBundle] resourcePath];
    
    NSString *filePath = [resourcePath stringByAppendingPathComponent:@"sdd_coupon_protocol.html"];
    
    
    
    // encoding:NSUTF8StringEncoding error:nil 这一段一定要加，不然中文字会乱码
    
    NSString *htmlstring=[[NSString alloc] initWithContentsOfFile:filePath  encoding:NSUTF8StringEncoding error:nil];
    
    myWebView= [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-20)];
    myWebView.backgroundColor = bgColor;
    myWebView.scrollView.directionalLockEnabled = YES;
    myWebView.scrollView.bounces = YES;
    myWebView.scalesPageToFit = YES;
    
    [self.view addSubview:myWebView];
    [myWebView loadHTMLString:htmlstring  baseURL:[NSURL fileURLWithPath:[ [NSBundle mainBundle] bundlePath]]];
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
