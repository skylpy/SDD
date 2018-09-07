//
//  registrFourViewController.m
//  SDD
//
//  Created by hua on 15/10/28.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "registrFourViewController.h"
#import "personalTwoViewController.h"

@interface registrFourViewController ()
{
    SDDUITextField *passwordTwoTextfield;
    
    SDDUITextField *passwordTextfield;            /**< 新密码 */
}

@end

@implementation registrFourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%d",_num);
    
    self.view.backgroundColor = [UIColor colorWithRed:(234/255.0) green:((234)/255.0) blue:((234)/255.0) alpha:(1.0)];
    
    [self createNvn];
    
    [self createUI];
    // Do any additional setup after loading the view.
}

-(void)createUI
{
    UILabel *titlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, viewWidth - 20, 35)];
    titlabel.text = @"设置密码后，您可以用手机号及密码登陆商多多电脑版和手机版";
    titlabel.textAlignment = NSTextAlignmentCenter;
    titlabel.numberOfLines = 0;
    titlabel.font = midFont;
    [self.view addSubview:titlabel];
    
    // 密码
    passwordTwoTextfield = [[SDDUITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titlabel.frame)+15, viewWidth-20, 45)
                                                  placeholder:@"请输入6-12位数字或字母"];
    //    passwordTextfield.leftView = passwordLabel;
    passwordTwoTextfield.secureTextEntry = NO;
    [self.view addSubview: passwordTwoTextfield];
    
    passwordTextfield = [[SDDUITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(passwordTwoTextfield.frame)+25, viewWidth-20, 45)
                                                  placeholder:@"请再次输入密码"];
//    passwordTextfield.leftView = passwordLabel;
    passwordTextfield.secureTextEntry = NO;
    [self.view addSubview: passwordTextfield];
    
    UISwitch *mySwitch = [[UISwitch alloc]init];
    mySwitch.center = CGPointMake(viewWidth - 40 , CGRectGetMaxY(passwordTextfield.frame)+25);
    mySwitch.on = YES;
    
    
    
    [mySwitch addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:mySwitch];
    
    UILabel *passLabel = [[UILabel alloc]initWithFrame:CGRectMake(viewWidth-200, (CGRectGetMaxY(passwordTextfield.frame)+10), 120, 35)];
    passLabel.textAlignment = NSTextAlignmentRight;
    passLabel.font = midFont;
    passLabel.text = @"显示密码";
    [self.view addSubview:passLabel];
    
    // 注册
    ConfirmButton *nextButton = [[ConfirmButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(mySwitch.frame)+10, viewWidth - 20, 45)
                                                               title:@"进入商多多"
                                                              target:self
                                                              action:@selector(finishRegister)];
    nextButton.enabled = YES;
    [self.view addSubview:nextButton];
    
}

-(void)switchClick:(UISwitch *)mySwitch{
    NSLog(@"%d",mySwitch.on);
    if (passwordTwoTextfield.secureTextEntry == YES || passwordTextfield.secureTextEntry == YES) {
        passwordTwoTextfield.secureTextEntry = NO;
        passwordTextfield.secureTextEntry = NO;
    }
    else{
        passwordTwoTextfield.secureTextEntry = YES;
        passwordTextfield.secureTextEntry = YES;
    }
    
}

#pragma mark - 完成注册
- (void)finishRegister{
    
    if (![Tools_F validatePassword:passwordTextfield.text] || ![Tools_F validatePassword:passwordTwoTextfield.text] ) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请输入6-12位有效的密码"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if (passwordTextfield.text == passwordTwoTextfield.text)
    {
        NSLog(@"%@",passwordTextfield.text);
        NSLog(@"%@",passwordTwoTextfield.text);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"两次输入密码不一致，请重新输入"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else {
        
        // 读取小米推送ID
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *miID = [defaults objectForKey:@"MiPushUserId"]?[defaults objectForKey:@"MiPushUserId"]:@"";
        
//        NSLog(@"%@",miID);
//        NSDictionary *dic = @{
//                              @"realName":[NSString stringWithFormat:@"%@",_nameStr],
//                              @"userName":[NSString stringWithFormat:@"%@",_phoneStr],
//                              @"code":[NSString stringWithFormat:@"%@",_codeStr],
//                              @"lastUserType":[NSNumber numberWithInteger:*(_num)],
//                              @"password":[Tools_F Newmd5:passwordTextfield.text],
////                              @"extraPushId":miID
//                              };
        NSArray *arr = @[@0,@1,@2,@3];
        NSDictionary *dic = @{
                              @"realName":[NSString stringWithFormat:@"%@",_nameStr],
                              @"userName":[NSString stringWithFormat:@"%@",_phoneStr],
                              @"code":[NSString stringWithFormat:@"%@",_codeStr],
                              @"lastUserType":arr[_num],
                              @"password":[Tools_F Newmd5:passwordTextfield.text],
                              @"extraPushId":miID
                              };
        
        [HttpTool postWithBaseURL:SDD_MainURL Path:@"/user/register.do" params:dic success:^(id JSON) {
            
            NSLog(@"param %@\n%@>>>>>>>%@",dic,JSON[@"message"],JSON);
            NSInteger theStatus = [JSON[@"status"] integerValue];
            
            UIAlertView *alert;
            if (theStatus == 1) {
                
                // 设置登录状态
                [GlobalController setLoginStatus:YES];
                
                NSString *userName = [NSString stringWithFormat:@"%@",JSON[@"data"][@"userId"]];
                NSString *password = [NSString stringWithFormat:@"%@",passwordTextfield.text];
                
                // 登录成功后设置自动登录
                [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:userName password:[Tools_F Newmd5:password] completion:^(NSDictionary *loginInfo, EMError *error) {
                    
                    [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];   // 自动登录
                    // 发送自动登陆状态通知
                    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
                } onQueue:nil];
                
                //发送自动登陆状态通知
                [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
                // 返回
                
                //创建通知
                NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil ];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                   message:JSON[@"message"]
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            else {
                
                alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                   message:JSON[@"message"]
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
                
//                UIButton *btn = (UIButton *)[top_bg viewWithTag:100];
//                [self stepClick:btn];
            }
            
            [alert show];
        } failure:^(NSError *error) {
            //
            NSLog(@"错误 -- %@", error);
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
    titleLabel.text = @"设置密码";
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
