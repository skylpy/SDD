//
//  LoginController.m
//  SDD
//  登陆界面
//  Created by Cola on 15/4/16.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "UserInfo.h"
#import "LoginController.h"
#import "ForgetPasswordViewController.h"
#import "RegisterViewController.h"

#import "identityViewController.h"

@interface LoginController ()<UIAlertViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) SDDUITextField *userNameView;
@property (nonatomic, strong) UITextField *password;
@property (nonatomic, strong) ConfirmButton *loginBtn;
// 放用户输入的内容
@property (nonatomic, strong) NSMutableArray *lableContext;

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav:@"loginUI"];
    _lableContext =[[NSMutableArray alloc ]initWithObjects:@"",@"",nil];
    
    self.view.backgroundColor = bgColor;
    [self initUI];
}

- (void)initUI{
    
    //帐户名
    _userNameView = [[SDDUITextField alloc] initWithFrame:CGRectMake(10, 15, viewWidth-20, 45)
                                              placeholder:@"请输入手机号"];
    _userNameView.keyboardType = UIKeyboardTypeNumberPad;//键盘类型
    _userNameView.delegate = self;
    [_userNameView setTag:1001];
    [self.view addSubview: _userNameView];
    
    //密码
    _password = [[SDDUITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_userNameView.frame)+10, viewWidth-20, 45)
                                          placeholder:@"请输入密码"];
    _password.secureTextEntry = YES; // 隐藏输入
    _password.delegate = self;
    [_password setTag:1002];
    [self.view addSubview: _password];
    
    //找回密码
    NSString * tmp = NSLocalizedString(@"register", @"");
    
    UIButton * _passwordTipLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    _passwordTipLabel.frame = CGRectMake(25, CGRectGetMaxY(_password.frame)+25, 100, 20);
    _passwordTipLabel.titleLabel.font = titleFont_15;
    _passwordTipLabel.titleLabel.textAlignment = NSTextAlignmentRight;
    [_passwordTipLabel setTitle:NSLocalizedString(@"findPassword", @"") forState:UIControlStateNormal];
    [_passwordTipLabel setTitleColor:lgrayColor forState:UIControlStateNormal];
    [_passwordTipLabel setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.view addSubview: _passwordTipLabel];
    
    UITapGestureRecognizer *findOutClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(findOutPassword:)];
    [_passwordTipLabel addGestureRecognizer:findOutClick];
    
    //注册新帐号
    tmp = NSLocalizedString(@"register", @"");
    UIButton * _registerLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerLabel.frame = CGRectMake(viewWidth-125, CGRectGetMaxY(_password.frame)+25, 100, 20);
    _registerLabel.titleLabel.font = titleFont_15;
    _registerLabel.titleLabel.text = tmp;
    [_registerLabel setTitle:tmp forState:UIControlStateNormal];
    [_registerLabel setTitleColor:lgrayColor forState:UIControlStateNormal];
    [_registerLabel setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
    [self.view addSubview: _registerLabel];
    
    UITapGestureRecognizer *registerClick = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(registerUser:)];
    [_registerLabel addGestureRecognizer:registerClick];
    
    // 登录按钮
    _loginBtn = [[ConfirmButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_passwordTipLabel.frame)+40, viewWidth - 40, 45)
                                               title:@"登录"
                                              target:self
                                              action:@selector(loginAccounts:)];
    [self.view addSubview: _loginBtn];
    
}

- (void)registerUser:(UITapGestureRecognizer *)sender{
    
    //RegisterViewController *viewController = [[RegisterViewController alloc] init];
    identityViewController *viewController = [[identityViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)findOutPassword:(UITapGestureRecognizer *)sender{
    
    ForgetPasswordViewController *viewController = [[ForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)finish{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - textfield代理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (range.length != 1) {
        // 这不是删除键
        if (_userNameView == textField) {
            
            _loginBtn.enabled = _password.text.length >0? YES:NO;
        }
        else {
            
            _loginBtn.enabled = _userNameView.text.length >0? YES:NO;
        }
    }
    else {
        
        _loginBtn.enabled = (_userNameView.text.length >1 && _password.text.length >1)? YES:NO;
    }

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if ([_userNameView isEqual:textField]) {
        
        [_lableContext replaceObjectAtIndex:0 withObject:textField.text];
    }
    else {
        
        if (![Tools_F validatePassword:textField.text]) {
            
            [self showErrorWithText:@"输入的密码不规范，请检查"];
        }
        else {
            
            [_lableContext replaceObjectAtIndex:1 withObject:textField.text];
        }
    }
}

#pragma mark - 登录
- (void)loginAccounts:(id)sender{
    
    [self.view endEditing:YES];
    
    // 读取小米推送ID
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *miID = [defaults objectForKey:@"MiPushUserId"]?[defaults objectForKey:@"MiPushUserId"]:@"";
    
    NSDictionary *dic = @{@"userName":[_lableContext objectAtIndex:0],
                          @"password":[Tools_F Newmd5:[_lableContext objectAtIndex:1]],
                          @"clientType":@2,
                          @"extraPushId":miID
                          };
    
    NSLog(@"%@",dic);
    NSString *urlString = [SDD_MainURL stringByAppendingString:@"/user/login.do"];              // 拼接主路径和请求内容成完整url
    [self sendRequest:dic url:urlString];
    [self showLoading:0];
}

- (void)onSuccess:(AFHTTPRequestOperation *)operation context:(id) responseObject{
    
    [self hideLoading];
    
    NSDictionary *dict = responseObject;
    NSString *tmp = dict[@"message"];
    NSRange foundObj= [tmp rangeOfString:@"登录成功"];
    
//    UIAlertView *alert;
    if (foundObj.length > 0) {
        
        // 用户信息
        [UserInfo sharedInstance].userInfoDic = dict[@"data"];
        // 设置登录状态
        [GlobalController setLoginStatus:YES];
        
        NSString *userId = [NSString stringWithFormat:@"%@",dict[@"data"][@"userId"]];
        NSString *password = [NSString stringWithFormat:@"%@",[_lableContext objectAtIndex:1]];
        
        // 登录成功后设置自动登录
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:userId password:[Tools_F Newmd5:password] completion:^(NSDictionary *loginInfo, EMError *error) {
            
            [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];   // 自动登录
            //发送自动登陆状态通知
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
        } onQueue:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                           message:dict[@"message"]
                                          delegate:nil
                                 cancelButtonTitle:@"确定"
                                 otherButtonTitles:nil];
        
        [alert show];
    }
}

- (void)onFailure:(AFHTTPRequestOperation *) operation error: (NSError *) error{
    
    [self hideLoading];
    NSLog(@"错误 -- %@", error);
}

- (void)alertViewCancel:(UIAlertView *)alertView{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
