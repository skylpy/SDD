//
//  CustomIntentionViewController.m
//  CustomIntention
//
//  Created by mac on 15/7/9.
//  Copyright (c) 2015年 linpeiyu. All rights reserved.
//

#import "CustomIntentionViewController.h"
#import "MassOfRentViewController.h"
#import "UIView+ZJQuickControl.h"
#import "ABulkViewController.h"
#import "NationalProjectViewController.h"
#import "DynamicCustomzationViewController.h"
#import "BrandToJoinViewController.h"

@interface CustomIntentionViewController (){
    
     NSArray * itemArray;
}

@end

@implementation CustomIntentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    self.view.backgroundColor = [UIColor whiteColor];
    itemArray = @[@"全部项目",
                  @"全部品牌",
                  @"订阅资讯",
                  @"敬请期待"];

    [self createView];
    [self createNabView];
}

#pragma mark --  导航条返回按钮
-(void)createNabView{
    
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"定制我的意向";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

#pragma mark --  导航条返回按钮点击事件
-(void)backBtnClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 创建定制主界面UI
-(void)createView{
    self.view.backgroundColor = bgColor;
    //提示信息下的线
    UIImageView * SettingImageView =[self.view addImageViewWithFrame:CGRectMake(0,0, viewWidth, 30) image:nil];
    SettingImageView.backgroundColor = [UIColor whiteColor];
    //设置提示信息
    UILabel * SettingLabel = [SettingImageView addLabelWithFrame:CGRectMake(10, 9, viewWidth-20, 12) text:@"请设置您的意向，让商多多更懂您!"];
    SettingLabel.font = bottomFont_12;
    SettingLabel.textColor = lgrayColor;
    
    //五个定制信息按钮
    for (int i = 0; i < itemArray.count; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(35, i*62+55, viewWidth-70, 40);
        
        [button setBackgroundImage:[Tools_F imageWithColor:[UIColor whiteColor]
                                                      size:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        [button setBackgroundImage:[Tools_F imageWithColor:dblueColor
                                                      size:CGSizeMake(1, 1)] forState:UIControlStateSelected];
        [Tools_F setViewlayer:button cornerRadius:5 borderWidth:1 borderColor:dblueColor];
        [button setTitle:itemArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button setTitleColor:dblueColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i+100;
        [self.view addSubview:button];
        
        if (i == itemArray.count-1) {
            
            [button setTitleColor:lgrayColor forState:UIControlStateNormal];
            [Tools_F setViewlayer:button cornerRadius:5 borderWidth:1 borderColor:lgrayColor];
            button.enabled = NO;
        }
    }
}

#pragma mark -- 五个定制信息按钮点击事件
-(void)btnClick:(UIButton *)btn{
    
    //遍历所有按钮，让所有按钮变为不可选状态
    for (int i = 0; i < itemArray.count; i ++) {
        UIButton * button = (UIButton *)[self.view viewWithTag:100+i];
        button.selected = NO;
    }
    
    btn.selected = YES;
    
    //点击按钮触发的事件
    if (btn.tag == 100) {
        
        MassOfRentViewController * MaORVc = [[MassOfRentViewController alloc] init];
        [self.navigationController pushViewController:MaORVc animated:YES];
    }
    else if (btn.tag == 101) {
        
        BrandToJoinViewController * BTJVc = [[BrandToJoinViewController alloc] init];
        [self.navigationController pushViewController:BTJVc animated:YES];
    }
    else if (btn.tag == 102) {
        
        DynamicCustomzationViewController * DyVc = [[DynamicCustomzationViewController alloc] init];
        [self.navigationController pushViewController:DyVc animated:YES];
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
