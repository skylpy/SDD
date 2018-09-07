//
//  registrTwoViewController.m
//  SDD
//
//  Created by hua on 15/10/27.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "registrTwoViewController.h"
#import "registrThreeViewController.h"

@interface registrTwoViewController ()<UITextFieldDelegate>
{
    UIButton *getCode;                            /**< 获取验证码 */
    SDDUITextField *codeTextfield;                /**< 验证码 */
    NSMutableArray *dataSource;
    
    NSTimer *_timer;           //倒计时
    int _second;               //秒数
}
@property (nonatomic, strong)NSString *codeStrrr;
@end

@implementation registrTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:(234/255.0) green:((234)/255.0) blue:((234)/255.0) alpha:(1.0)];
    dataSource = [[NSMutableArray alloc] initWithCapacity:10];
    [self createNvn];
    
    [self createUI];
    
    // Do any additional setup after loading the view.
}

-(void)createUI
{
    
    UILabel *titLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, viewWidth - 20, 25)];
    titLabel.font = midFont;
    titLabel.textAlignment = NSTextAlignmentCenter;
    titLabel.text = [NSString stringWithFormat:@"验证码已发送到手机：%@",_phoneStr];
    [self.view addSubview:titLabel];
    
    [self verificationCode:_phoneStr];
    
    codeTextfield = [[SDDUITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titLabel.frame)+25, viewWidth-20, 45)
                                              placeholder:@"请输入验证码"];
    codeTextfield.keyboardType = UIKeyboardTypeNumberPad;//键盘类型
    codeTextfield.hidden = YES;
    [codeTextfield addTarget:self action:@selector(txchange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:codeTextfield];
    [codeTextfield becomeFirstResponder];
    
    
    for (int i = 0; i < 4; i++)
    {
        UITextField *pwdLabel = [[UITextField alloc] initWithFrame:CGRectMake((viewWidth - 45*4)/2 + 46*i, CGRectGetMaxY(titLabel.frame)+25, 45, 45)];
//        pwdLabel.layer.borderColor = [UIColor redColor].CGColor;
        pwdLabel.backgroundColor = [UIColor whiteColor];
        pwdLabel.enabled = NO;
        pwdLabel.textAlignment = NSTextAlignmentCenter;//居中
        pwdLabel.secureTextEntry = NO;//设置密码模式
//        pwdLabel.layer.borderWidth = 1;
        
        [self.view addSubview:pwdLabel];
        
        [dataSource addObject:pwdLabel];
    }
    
    //下一步按钮
    ConfirmButton *nextButton = [[ConfirmButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(codeTextfield.frame)+25, viewWidth - 20, 45)
                                                               title:@"下一步"
                                                              target:self
                                                              action:@selector(secondStep)];
    nextButton.enabled = YES;
    [self.view addSubview:nextButton];
    
    getCode = [UIButton buttonWithType:UIButtonTypeCustom];
    getCode.frame = CGRectMake(10, CGRectGetMaxY(nextButton.frame)+25, viewWidth - 20, 25);
    [getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getCode setTitleColor:mainTitleColor forState:UIControlStateNormal];
    getCode.titleLabel.font = midFont;
    [getCode addTarget:self action:@selector(verificationCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getCode];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timingOfSixtySecond) userInfo:nil repeats:YES];
}


#pragma mark 文本框内容改变

NSString *password = @"";
- (void)txchange:(UITextField *)tx
{
    if(tx.text.length > 4)
    {
        tx.text = password;
        return;
    }
    password = tx.text;
    for (int i = 0; i < dataSource.count; i++)
    {
        UITextField *pwdtx = [dataSource objectAtIndex:i];
        if (i < password.length)
        {
            NSString *pwd = [password substringWithRange:NSMakeRange(i, 1)];
            pwdtx.text = pwd;
        }
        else
        {
            pwdtx.text = @"";
        }
    }
    
//    if (password.length == 4)
//    {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入的密码是" message:password  delegate:nil cancelButtonTitle:@"完成" otherButtonTitles:nil, nil];
//        [alert show];
//    }
}

-(void)secondStep
{
    if (codeTextfield.text.length != 4) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请输入4位验证码"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else {
        registrThreeViewController *viewController = [[registrThreeViewController alloc] init];
        viewController.phoneStr = _phoneStr;
        viewController.codeStr = codeTextfield.text;
        viewController.num = _num;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}

#pragma mark - 获取验证码
- (void)verificationCode:(id)sender{
    

    NSDictionary *dic = @{@"phone":_phoneStr};
    NSLog(@"%@",_phoneStr);
    
    NSString *urlString = [SDD_MainURL stringByAppendingString:@"/sms/sendVerificationCode.do"];              // 拼接主路径和请求内容成完整url
    [self sendRequest:dic url:urlString];
    
}

- (void)timingOfSixtySecond{
    
    getCode.userInteractionEnabled = NO;
    NSString *secondStr = [NSString stringWithFormat:@"重新获取验证码(%d)",((_second--) - 1)+60];
    [getCode setTitleColor:[SDDColor sddSmallTextColor] forState:UIControlStateNormal];
    [getCode setTitle:secondStr forState:UIControlStateNormal];
    if (_second == -60) {
        [_timer invalidate];
        _timer = nil;
        _second = 0;
        [getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        [getCode setTitleColor:mainTitleColor forState:UIControlStateNormal];
        getCode.userInteractionEnabled = YES;
    }
}



-(void)createNvn
{
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"填写验证码";
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
