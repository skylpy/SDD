//
//  EditMailViewController.m
//  SDD
//
//  Created by hua on 15/8/20.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "EditMailViewController.h"

@interface EditMailViewController (){
    
    SDDUITextField *mailTextfield;
}

@end

@implementation EditMailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // nav
    
    self.view.backgroundColor = bgColor;
    [self setNav:@"邮箱修改"];
    
    
    // 导航条右btn
    UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    completeButton.frame = CGRectMake(0, 0, 40, 20);
    completeButton.titleLabel.font = titleFont_15;
    [completeButton setTitle:@"完成" forState:UIControlStateNormal];
    [completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [completeButton addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:completeButton];;
    
    // ui
    mailTextfield = [[SDDUITextField alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 40)
                                                  placeholder:_theMail];
    mailTextfield.textColor = lgrayColor;      //设置textview里面的字体颜色
    mailTextfield.clearButtonMode = UITextFieldViewModeAlways;
    [self.view addSubview:mailTextfield];
}

- (void)complete{
    
    if ([Tools_F validateEmail:mailTextfield.text]) {
        [self showLoading:0];
        NSDictionary *param = @{@"email":mailTextfield.text};
        
        [HttpTool postWithBaseURL:SDD_MainURL Path:@"/user/modify_email.do" params:param success:^(id JSON) {
            
            NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
            if ([JSON[@"status"] intValue] == 1) {
                
                // block回传
                if (self.returnBlock != nil) {
                    
                    self.returnBlock(mailTextfield.text);
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
    else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请填写正确的邮箱"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }    
}

- (void)valueReturn:(ReturnMail)block{
    
    self.returnBlock = block;
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
