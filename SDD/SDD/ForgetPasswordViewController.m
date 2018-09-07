//
//  ForgetPasswordViewController.m
//  SDD
//
//  Created by hua on 15/8/10.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ForgetPasswordViewController.h"

@interface ForgetPasswordViewController ()<UITextFieldDelegate>{
    
    /*- ui -*/
    
    SDDUITextField *phoneTextfield;               /**< 手机号 */
    SDDUITextField *codeTextfield;                /**< 验证码 */
    SDDUITextField *newPasswordTextfield;         /**< 新密码 */
    ConfirmButton *commitButton;                  /**< 提交 */
    UIButton *getCode;                            /**< 获取验证码 */
    
    /*- data-*/
    
    NSTimer *_timer;           //倒计时
    int _second;               //秒数
}

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _second = 60;
    
    [self setNav:@"loginUI"];
    self.view.backgroundColor = bgColor;
    [self initUI];
}

- (void)initUI{
    
    
    // 手机号
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.frame = CGRectMake(0, 0, 70, 45);
    phoneLabel.font = titleFont_15;
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    phoneLabel.textColor = mainTitleColor;
    phoneLabel.text = @"手机号: ";
    
    phoneTextfield = [[SDDUITextField alloc] initWithFrame:CGRectMake(10, 15, viewWidth-20, 45)
                                               placeholder:@"请输入手机号"];
    phoneTextfield.keyboardType = UIKeyboardTypeNumberPad;//键盘类型
    phoneTextfield.delegate = self;
    phoneTextfield.leftView = phoneLabel;
    phoneTextfield.tag = 100;
    [self.view addSubview: phoneTextfield];
    
    // 验证码
    UILabel *codeLabel = [[UILabel alloc] init];
    codeLabel.frame = CGRectMake(0, 0, 70, 45);
    codeLabel.font = titleFont_15;
    codeLabel.textAlignment = NSTextAlignmentCenter;
    codeLabel.textColor = mainTitleColor;
    codeLabel.text = @"验证码: ";
    
    UIView *rightView_bg = [[UIView alloc] init];
    rightView_bg.frame = CGRectMake(0, 0, 100, 45);
    rightView_bg.backgroundColor = [UIColor whiteColor];
    
    UIView *cutoff = [[UIView alloc] init];
    cutoff.frame = CGRectMake(0, 10, 1, 25);
    cutoff.backgroundColor = divisionColor;
    [rightView_bg addSubview:cutoff];
    
    getCode = [UIButton buttonWithType:UIButtonTypeCustom];
    getCode.frame = CGRectMake(CGRectGetMaxX(cutoff.frame), 0, 99, 45);
    [getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getCode setTitleColor:mainTitleColor forState:UIControlStateNormal];
    getCode.titleLabel.font = midFont;
    [getCode addTarget:self action:@selector(verificationCode:) forControlEvents:UIControlEventTouchUpInside];
    [rightView_bg addSubview:getCode];
    
    codeTextfield = [[SDDUITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(phoneTextfield.frame)+10, viewWidth-20, 45)
                                               placeholder:@"请输入验证码"];
    codeTextfield.keyboardType = UIKeyboardTypeNumberPad;//键盘类型
    codeTextfield.delegate = self;
    codeTextfield.leftView = codeLabel;
    codeTextfield.rightView = rightView_bg;
    codeTextfield.tag = 101;
    [self.view addSubview:codeTextfield];
    
    // 新密码
    UILabel *npLabel = [[UILabel alloc] init];
    npLabel.frame = CGRectMake(0, 0, 70, 45);
    npLabel.font = titleFont_15;
    npLabel.textAlignment = NSTextAlignmentCenter;
    npLabel.textColor = mainTitleColor;
    npLabel.text = @"新密码: ";
    
    newPasswordTextfield = [[SDDUITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(codeTextfield.frame)+10, viewWidth-20, 45)
                                               placeholder:@"请输入6-12位数字或字母"];
    newPasswordTextfield.delegate = self;
    newPasswordTextfield.secureTextEntry = YES;
    newPasswordTextfield.leftView = npLabel;
    newPasswordTextfield.tag = 102;
    [self.view addSubview:newPasswordTextfield];
    
    //提交按钮
    commitButton = [[ConfirmButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(newPasswordTextfield.frame)+40, viewWidth - 40, 45)
                                               title:@"提交"
                                              target:self
                                              action:@selector(editPassword:)];
    [self.view addSubview: commitButton];
}


#pragma mark - textfield代理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.length != 1) {
        // 这不是删除键
        NSInteger validCount = 0;
        for (int i = 100; i<103; i++) {
            SDDUITextField *theTextfield = (SDDUITextField *)[self.view viewWithTag:i];
            if (theTextfield.text.length>0 && theTextfield !=textField) {
                validCount++;
            }
        }
        commitButton.enabled = validCount>1?YES:NO;
    }
    else {
        commitButton.enabled = (phoneTextfield.text.length >1 &&
                                codeTextfield.text.length >1 &&
                                newPasswordTextfield.text.length >1)? YES:NO;
    }
    return YES;
}

#pragma -mark 提交按钮
- (void)editPassword:(id)sender{
    
    if (![Tools_F validateMobile:phoneTextfield.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请输入11位手机号码"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if (codeTextfield.text.length != 4) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请输入4位验证码"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if (![Tools_F validatePassword:newPasswordTextfield.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请输入6-12位有效的密码"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    else {
        
        NSDictionary *dic = @{@"newPassword":[Tools_F Newmd5:newPasswordTextfield.text],
                              @"code":codeTextfield.text
                              };
        
        [HttpTool postWithBaseURL:SDD_MainURL Path:@"/user/resetPassword.do" params:dic success:^(id JSON) {
            
            NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
            NSInteger theStatus = [JSON[@"status"] integerValue];
            
            if (theStatus == 1) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:JSON[@"message"]
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];
            
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(NSError *error) {
            //
            NSLog(@"错误 -- %@", error);
        }];
    }
}

- (void)verificationCode:(id)sender{
    
    if (![Tools_F validateMobile:phoneTextfield.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请填写手机号"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSDictionary *dic = @{@"phone":phoneTextfield.text};
    
    NSString *urlString = [SDD_MainURL stringByAppendingString:@"/sms/sendResetPasswordCode.do"];              // 拼接主路径和请求内容成完整url
    [self sendRequest:dic url:urlString];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timingOfSixtySecond) userInfo:nil repeats:YES];
    
}

- (void)timingOfSixtySecond{
    
    getCode.userInteractionEnabled = NO;
    NSString *secondStr = [NSString stringWithFormat:@"%d秒后重新获取",(_second--) - 1];
    [getCode setTitleColor:[SDDColor sddSmallTextColor] forState:UIControlStateNormal];
    [getCode setTitle:secondStr forState:UIControlStateNormal];
    if (_second == 0) {
        [_timer invalidate];
        _timer = nil;
        _second = 60;
        [getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        [getCode setTitleColor:mainTitleColor forState:UIControlStateNormal];
        getCode.userInteractionEnabled = YES;
    }
}

- (void)onSuccess:(AFHTTPRequestOperation *)operation context:(id) responseObject{
    
    NSDictionary *dict = responseObject;
    
    NSInteger theStatus = [dict[@"status"] integerValue];
    if (theStatus != 1) {
        
        [_timer invalidate];
        _timer = nil;
        _second = 60;
        [getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        [getCode setTitleColor:mainTitleColor forState:UIControlStateNormal];
        getCode.userInteractionEnabled = YES;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:dict[@"message"]
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    
    [alert show];
}

- (void)onFailure:(AFHTTPRequestOperation *) operation error: (NSError *) error{
    
    NSLog(@"错误 -- %@", error);
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
