//
//  registrOneViewController.m
//  SDD
//
//  Created by hua on 15/10/27.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "registrOneViewController.h"
#import "registrTwoViewController.h"

@interface registrOneViewController ()
{
    SDDUITextField *phoneTextfield;               /**< 手机号 */
}

@end

@implementation registrOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:(234/255.0) green:((234)/255.0) blue:((234)/255.0) alpha:(1.0)];
    [self createNvn];
    
    [self createUI];
    // Do any additional setup after loading the view.
}

-(void)createUI
{
    phoneTextfield = [[SDDUITextField alloc] initWithFrame:CGRectMake(10, 25, viewWidth-20, 45)
                                               placeholder:@"请输入手机号"];
    phoneTextfield.keyboardType = UIKeyboardTypeNumberPad;//键盘类型
//    phoneTextfield.leftView = phoneLabel;
    [self.view addSubview: phoneTextfield];
    
    //下一步按钮
    ConfirmButton *nextButton = [[ConfirmButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(phoneTextfield.frame)+25, viewWidth - 20, 45)
                                                               title:@"下一步"
                                                              target:self
                                                              action:@selector(secondStep)];
    nextButton.enabled = YES;
    [self.view addSubview:nextButton];
    
    UILabel *hintLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(nextButton.frame)+25, viewWidth - 20, 20)];
    hintLabel.text = @"点击上面按钮“下一步”即表示同意";
    hintLabel.textColor = lgrayColor;
    hintLabel.font = littleFont;
    hintLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:hintLabel];
    
    UILabel *AgreementLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(hintLabel.frame)+10, viewWidth - 20, 20)];
    AgreementLabel.text = @"《商多多用户服务协议》";
    AgreementLabel.textColor = [UIColor colorWithRed:(0/255.0) green:((115)/255.0) blue:((226)/255.0) alpha:(1.0)];
    AgreementLabel.font = littleFont;
    AgreementLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:AgreementLabel];
    
}

- (void)secondStep{
    
    if (![Tools_F validateMobile:phoneTextfield.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请输入11位手机号码"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }

    else {
        
        NSDictionary *dic = @{@"phone":phoneTextfield.text};
        [HttpTool postWithBaseURL:SDD_MainURL Path:@"/sms/sendVerificationCode.do" params:dic success:^(id JSON) {
            
            NSLog(@"param %@\n%@>>>>>>>%@",dic,JSON[@"message"],JSON);
            NSInteger theStatus = [JSON[@"status"] integerValue];
            
            if (theStatus == 1) {
                
                NSLog(@"%@",JSON[@"message"]);
                registrTwoViewController *viewController = [[registrTwoViewController alloc] init];
                viewController.phoneStr = phoneTextfield.text;
                viewController.num = _num;
                [self.navigationController pushViewController:viewController animated:YES];

            }
            else
            {
                NSLog(@"message  ===========  %@",JSON[@"message"]);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:JSON[@"message"]
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];
                
            }
        }failure:^(NSError *error) {
            //
            NSLog(@"错误 -- %@", error);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"网络错误，请稍后重试"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            
        }];
        
    }
}



-(void)createNvn
{
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"新用户注册";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    //    UIButton * rightBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    //    rightBtn.frame = CGRectMake(0, 0, 15, 15);
    //    [rightBtn setBackgroundImage:[UIImage imageNamed:@"分享-图标"] forState:UIControlStateNormal];
    //
    //    UIBarButtonItem * rigItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    //    self.navigationItem.rightBarButtonItem = rigItem;
    
}

- (void)leftButtonClick
{
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
