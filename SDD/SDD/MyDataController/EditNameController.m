//
//  EditNameController.m
//  SDD
//  真实姓名
//  Created by Cola on 15/4/18.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "EditNameController.h"

@interface EditNameController (){
    
    SDDUITextField *userNameTextfield;
}

@end

@implementation EditNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // nav
    
    self.view.backgroundColor = bgColor;
    [self setNav:@"真实姓名修改"];
    
    
    // 导航条右btn
    UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    completeButton.frame = CGRectMake(0, 0, 40, 20);
    completeButton.titleLabel.font = titleFont_15;
    [completeButton setTitle:@"完成" forState:UIControlStateNormal];
    [completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [completeButton addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:completeButton];;
    
    // ui
    userNameTextfield = [[SDDUITextField alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 40)
                                                  placeholder:_theNickname ];
    userNameTextfield.textColor = lgrayColor;      //设置textview里面的字体颜色
    userNameTextfield.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:userNameTextfield];
}

- (void)complete{
    
    [self showLoading:0];
    NSDictionary *param = @{@"realName":userNameTextfield.text};
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/user/modify_real_name.do" params:param success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        if ([JSON[@"status"] intValue] == 1) {
            
            // block回传
            if (self.returnBlock != nil) {
                
                self.returnBlock(userNameTextfield.text);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            
            [self showSuccessWithText:JSON[@"message"]];
        }
        [self hideLoading];
    } failure:^(NSError *error) {
        [self hideLoading];
        NSLog(@"修改姓名失败");
    }];
}

- (void)valueReturn:(ReturnNickname)block{
    
    self.returnBlock = block;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
