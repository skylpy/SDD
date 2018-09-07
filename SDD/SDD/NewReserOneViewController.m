//
//  NewReserOneViewController.m
//  SDD
//
//  Created by mac on 15/11/5.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "NewReserOneViewController.h"
#import "NewReserTwoViewController.h"
#import "UserInfo.h"

@interface NewReserOneViewController ()
{
    UITextField *nameTextfield;                   /**< 姓名 */
    UITextField *phoneTextfield;                  /**< 手机号 */
    UITextField *codeTextfield;                   /**< 验证码 */
    
    UIButton *getCode;                            /**< 获取验证码 */
    
    NSTimer *_timer;                              /**< 倒计时 */
    int _second;                                  /**< 秒数 */
}
@end

@implementation NewReserOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    _second = 60;
    [self setNav:@"在线预约看铺"];
    [self setupFirst];
}
#pragma mark - 第一步
- (void)setupFirst{
    
    //first_bottombg.hidden = NO;
    
    UITextField *lastTextField;
    for (int i=0; i<3; i++) {
        
        // 标题
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 0, 70, 45);
        label.font = midFont;
        label.textColor = mainTitleColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        
        // 内容
        UITextField *textfield = [[UITextField alloc] init];
        textfield.font = midFont;
        textfield.textColor = mainTitleColor;
        textfield.backgroundColor = [UIColor whiteColor];
        textfield.leftView = label;
        textfield.leftViewMode = UITextFieldViewModeAlways;
        textfield.rightViewMode = UITextFieldViewModeAlways;
        [self.view addSubview:textfield];
        
        [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastTextField?lastTextField.mas_bottom:self.view.mas_top);
            make.left.equalTo(self.view.mas_left);
            make.size.mas_equalTo(CGSizeMake(viewWidth, 45));
        }];
        
        // 分割线
        if (lastTextField) {
            
            UIView *cutoff = [[UIView alloc] init];
            cutoff.backgroundColor = ldivisionColor;
            [self.view addSubview:cutoff];
            
            [cutoff mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastTextField.mas_bottom);
                make.left.equalTo(self.view.mas_left);
                make.size.mas_equalTo(CGSizeMake(viewWidth, 1));
            }];
        }
        
        switch (i) {
            case 0:
            {
                NSString *originalStr = @"*姓名:";
                NSMutableAttributedString *paintStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
                [paintStr addAttribute:NSForegroundColorAttributeName
                                 value:tagsColor
                                 range:[originalStr rangeOfString:@"*"]
                 ];
                label.attributedText = paintStr;
                textfield.placeholder = @"请输入您的姓名";
                textfield.text = [UserInfo sharedInstance].userInfoDic[@"realName"];
                nameTextfield = textfield;
            }
                break;
            case 1:
            {
                NSString *originalStr = @"*手机号:";
                NSMutableAttributedString *paintStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
                [paintStr addAttribute:NSForegroundColorAttributeName
                                 value:tagsColor
                                 range:[originalStr rangeOfString:@"*"]
                 ];
                label.attributedText = paintStr;
                textfield.placeholder = @"请输入您的手机号";
                textfield.text = [UserInfo sharedInstance].userInfoDic[@"phone"];
                phoneTextfield = textfield;
                phoneTextfield.keyboardType = UIKeyboardTypeNumberPad;//键盘类型
            }
                break;
            case 2:
            {
                NSString *originalStr = @"*验证码:";
                NSMutableAttributedString *paintStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
                [paintStr addAttribute:NSForegroundColorAttributeName
                                 value:tagsColor
                                 range:[originalStr rangeOfString:@"*"]
                 ];
                label.attributedText = paintStr;
                textfield.placeholder = @"请输入验证码";
                codeTextfield = textfield;
                
                UIView *rightView_bg = [[UIView alloc] init];
                rightView_bg.frame = CGRectMake(0, 0, 115, 45);
                rightView_bg.backgroundColor = [UIColor whiteColor];
                
                UIView *cutoff = [[UIView alloc] init];
                cutoff.frame = CGRectMake(0, 10, 1, 25);
                cutoff.backgroundColor = divisionColor;
                [rightView_bg addSubview:cutoff];
                
                getCode = [UIButton buttonWithType:UIButtonTypeCustom];
                getCode.frame = CGRectMake(CGRectGetMaxX(cutoff.frame), 0, 105, 45);
                [getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                [getCode setTitleColor:mainTitleColor forState:UIControlStateNormal];
                getCode.titleLabel.font = midFont;
                [getCode addTarget:self action:@selector(verificationCode:) forControlEvents:UIControlEventTouchUpInside];
                [rightView_bg addSubview:getCode];
                
                textfield.rightView = rightView_bg;
                codeTextfield = textfield;
                codeTextfield.keyboardType = UIKeyboardTypeNumberPad;//键盘类型
            }
                break;
        }
        
        lastTextField = textfield;
    }
    
    // 下一步
    ConfirmButton *nextButton = [[ConfirmButton alloc] initWithFrame:CGRectZero
                                                               title:@"下一步"
                                                              target:self
                                                              action:@selector(toSecond)];
    nextButton.enabled = YES;
    [self.view addSubview:nextButton];
    
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastTextField.mas_bottom).offset(40);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(viewWidth-40, 45));
    }];
}
#pragma mark - 跳第二步
- (void)toSecond{
   
    if ([nameTextfield.text isEqualToString:@""]) {
        
        [self showErrorWithText:@"请输入姓名"];
    }
    else if (![Tools_F validateMobile:phoneTextfield.text]){
        
        [self showErrorWithText:@"请填写11位的手机号"];
    }
    else if ([codeTextfield.text isEqualToString:@""]){
        
        [self showErrorWithText:@"请输入验证码"];
        
    }
    else{
        
        NewReserTwoViewController *rVC = [[NewReserTwoViewController alloc] init];
        rVC.phoneStr = phoneTextfield.text;
        rVC.codeStr = codeTextfield.text;
        rVC.nameStr = nameTextfield.text;
        rVC.houseID = _houseID;
        rVC.houseName = _houseName;
        rVC.activityCategoryId = _activityCategoryId;
        [self.navigationController pushViewController:rVC animated:YES];
        
    }
    
}
#pragma mark - 获取验证码
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
    
    NSString *urlString = [SDD_MainURL stringByAppendingString:@"/sms/user/sendAppointmentVisitCode.do"];              // 拼接主路径和请求内容成完整url
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
