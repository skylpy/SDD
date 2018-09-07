//
//  RegisterViewController.m
//  SDD
//
//  Created by hua on 15/8/11.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "RegisterViewController.h"
#import "FindBrankModel.h"

#import "FSDropDownMenu.h"
@interface RegisterViewController ()<UITextFieldDelegate,FSDropDownMenuDataSource,FSDropDownMenuDelegate>{
    
    /*- ui -*/
    
    UIView *top_bg;
    UIView *bottom_bg;
    
    FSDropDownMenu *dropMenu;
    
    SDDUITextField *phoneTextfield;               /**< 手机号 */
    SDDUITextField *codeTextfield;                /**< 验证码 */
    
    UITextField *nameTextfield;                   /**< 姓名 */
    UITextField *emailTextfield;                  /**< 邮箱 */
    UITextField *industryTextfield;               /**< 行业 */
    UITextField *brandTextfield;                  /**< 品牌 */
    
    SDDUITextField *passwordTextfield;            /**< 新密码 */
    UIButton *getCode;                            /**< 获取验证码 */
    
    /*- data-*/
    
    FindBrankModel *currentModel;
    NSInteger industryCategoryId;
    NSInteger industryCategoryId2;
    
    NSTimer *_timer;           //倒计时
    int _second;               //秒数
}

// 行业类别
@property (nonatomic, strong) NSMutableArray *industryAll;

@end

@implementation RegisterViewController

- (NSMutableArray *)industryAll{
    if (!_industryAll) {
        _industryAll = [[NSMutableArray alloc]init];
    }
    return _industryAll;
}

#pragma mark - 请求数据
- (void)requestData{
    
    // 行业类别
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brandCategory/industryAllList.do" params:nil success:^(id JSON) {
        
//        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSDictionary *dict = JSON[@"data"];
        
        if (![dict isEqual:[NSNull null]]) {
            
            [_industryAll removeAllObjects];
            
            BOOL flag = NO;
            for (NSDictionary *tempDic in dict) {
                flag = YES;
                FindBrankModel *model = [FindBrankModel findBrankWithDict:tempDic];
                [self.industryAll addObject:model];
            }
            FindBrankModel *model = _industryAll[0];
            currentModel = flag?model:nil;
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    industryCategoryId = 0;
    industryCategoryId2 = 0;
    _second = 60;
    self.view.backgroundColor = bgColor;
    
    // 导航条
    [self setNav:@"注册新账号"];
    // 数据请求
    [self requestData];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    // 上方步骤
    top_bg = [[UIView alloc] init];
    top_bg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:top_bg];
    
    [top_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 45));
    }];
    
    // 下方内容
    bottom_bg = [[UIView alloc] init];
    bottom_bg.backgroundColor = bgColor;
    [self.view addSubview:bottom_bg];
    
    [bottom_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(top_bg.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(self.view.mas_width);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    NSArray *stepTitle = @[@"1、验证手机号",@"2、填写资料",@"3、设置密码"];
    
    UIButton *lastBtn;
    for (int i=0; i<stepTitle.count; i++) {
        
        // 步骤
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.font = midFont;
        btn.tag = 100+i;
        [btn setTitle:stepTitle[i] forState:UIControlStateNormal];
        [btn setTitle:stepTitle[i] forState:UIControlStateSelected];
        [btn setTitleColor:lgrayColor forState:UIControlStateNormal];
        [btn setTitleColor:mainTitleColor forState:UIControlStateSelected];
        btn.userInteractionEnabled = NO;
        [btn addTarget:self action:@selector(stepClick:) forControlEvents:UIControlEventTouchUpInside];
        [top_bg addSubview:btn];
        
        btn.selected = lastBtn?NO:YES;
        [self setupFirst];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(top_bg.mas_top);
            make.left.equalTo(lastBtn?lastBtn.mas_right:top_bg.mas_left);
            make.size.mas_equalTo(CGSizeMake(viewWidth/3, 45));
        }];
        
        if (lastBtn) {
            
            // 箭头
            UIImageView *arrow = [[UIImageView alloc] init];
            arrow.backgroundColor = [UIColor whiteColor];
            arrow.image = [UIImage imageNamed:@"home_top_arrow_deepblue"];
            arrow.contentMode = UIViewContentModeScaleAspectFit;
            [top_bg addSubview:arrow];
            
            [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(lastBtn.mas_centerY);
                make.centerX.equalTo(lastBtn.mas_right);
                make.size.mas_equalTo(CGSizeMake(13, 13));
            }];
        }
        
        lastBtn = btn;
    }
}

#pragma mark - 步骤选择
- (void)stepClick:(UIButton *)btn{
    
    btn.selected = YES;
    
    // 移除旧视图
    for (UIView *all in bottom_bg.subviews) {
        [all removeFromSuperview];
    }
    
    NSInteger index = (NSInteger)btn.tag-100;
    switch (index) {
        case 0:
        {
            [self setupFirst];
        }
            break;
        case 1:
        {
            [self setupSecond];
        }
            break;
        case 2:
        {
            [self setupLast];
        }
            break;
    }
}

- (void)setupFirst{
    
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
    phoneTextfield.leftView = phoneLabel;
    [bottom_bg addSubview: phoneTextfield];
    
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
    codeTextfield.leftView = codeLabel;
    codeTextfield.rightView = rightView_bg;
    [bottom_bg addSubview:codeTextfield];
    
    //下一步按钮
    ConfirmButton *nextButton = [[ConfirmButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(codeTextfield.frame)+40, viewWidth - 40, 45)
                                                                 title:@"下一步"
                                                                target:self
                                                                action:@selector(secondStep)];
    nextButton.enabled = YES;
    [bottom_bg addSubview:nextButton];
}

- (void)setupSecond{
    
    UIView *second_bg = [[UIView alloc] init];
    second_bg.backgroundColor = [UIColor whiteColor];
    [bottom_bg addSubview:second_bg];
    
    [second_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottom_bg.mas_top).offset(10);
        make.left.equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 45*4));
    }];
    
    // 栏目选择
    dropMenu = [[FSDropDownMenu alloc] initWithOrigin:CGPointMake(0, viewHeight-364) andHeight:300];
    dropMenu.dataSource = self;
    dropMenu.delegate = self;
    [self.view addSubview:dropMenu];
    
    UILabel *lastLabel;
    for (int i=0; i<4; i++) {
        
        // 标题
        UILabel *label = [[UILabel alloc] init];
        label.font = midFont;
        label.textColor = mainTitleColor;
        label.backgroundColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentRight;
        [second_bg addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastLabel?lastLabel.mas_bottom:second_bg.mas_top);
            make.left.equalTo(self.view.mas_left).offset(10);
            make.size.mas_equalTo(CGSizeMake(40, 45));
        }];
        
        // 内容
        UITextField *textfield = [[UITextField alloc] init];
        textfield.font = midFont;
        textfield.textColor = mainTitleColor;
        textfield.backgroundColor = [UIColor whiteColor];
        [second_bg addSubview:textfield];
        
        [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastLabel?lastLabel.mas_bottom:second_bg.mas_top);
            make.left.equalTo(label.mas_right).offset(10);
            make.size.mas_equalTo(CGSizeMake(viewWidth-70, 45));
        }];
        
        // 分割线
        if (lastLabel) {
            UIView *cutoff = [[UIView alloc] init];
            cutoff.backgroundColor = bgColor;
            [second_bg addSubview:cutoff];
            
            [cutoff mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastLabel.mas_bottom);
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
                textfield.placeholder = @"必填";
                nameTextfield = textfield;
            }
                break;
            case 1:
            {
                NSString *originalStr = @"*邮箱:";
                NSMutableAttributedString *paintStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
                [paintStr addAttribute:NSForegroundColorAttributeName
                                 value:tagsColor
                                 range:[originalStr rangeOfString:@"*"]
                 ];
                label.attributedText = paintStr;
                textfield.placeholder = @"必填";
                emailTextfield = textfield;
            }
                break;
            case 2:
            {
                UIImageView *arrow = [[UIImageView alloc] init];
                arrow.frame = CGRectMake(0, (45-13)/2, 18, 13);
                arrow.backgroundColor = [UIColor whiteColor];
                arrow.image = [UIImage imageNamed:@"gray_rightArrow"];
                arrow.contentMode = UIViewContentModeScaleAspectFit;
                textfield.rightView = arrow;
                textfield.rightViewMode = UITextFieldViewModeAlways;
                
                label.text = @"行业:";
                textfield.placeholder = @"请选择你的行业";
                textfield.textAlignment = NSTextAlignmentRight;
                textfield.delegate = self;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(industrySelected)];
                [textfield addGestureRecognizer:tap];
                
                industryTextfield = textfield;
            }
                break;
            case 3:
            {
                label.text = @"品牌:";
                textfield.placeholder = @"请填写您的品牌名称";
                brandTextfield = textfield;
            }
                break;
        }
        
        lastLabel = label;
    }
    
    // 提示
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.backgroundColor = bgColor;
    tipsLabel.font = midFont;
    tipsLabel.textColor = lgrayColor;
    tipsLabel.numberOfLines = 0;
    tipsLabel.text = @"商多多提示:  选择行业和输入品牌更容易得到您想要的信息哦~";
    
    [bottom_bg addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastLabel.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.width.mas_equalTo(viewWidth-30);
        make.height.greaterThanOrEqualTo(@13);
    }];
    
    // 下一步
    ConfirmButton *nextButton = [[ConfirmButton alloc] initWithFrame:CGRectZero
                                                               title:@"下一步"
                                                              target:self
                                                              action:@selector(lastStep)];
    nextButton.enabled = YES;
    [bottom_bg addSubview:nextButton];
    
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsLabel.mas_bottom).offset(40);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(viewWidth-40, 45));
    }];
}

- (void)setupLast{
    
    // 密码
    UILabel *passwordLabel = [[UILabel alloc] init];
    passwordLabel.frame = CGRectMake(0, 0, 70, 45);
    passwordLabel.font = titleFont_15;
    passwordLabel.textAlignment = NSTextAlignmentCenter;
    passwordLabel.textColor = mainTitleColor;
    passwordLabel.text = @"密码: ";
    
    passwordTextfield = [[SDDUITextField alloc] initWithFrame:CGRectMake(10, 15, viewWidth-20, 45)
                                               placeholder:@"请输入6-12位数字或字母"];
    passwordTextfield.leftView = passwordLabel;
    passwordTextfield.secureTextEntry = YES;
    [bottom_bg addSubview: passwordTextfield];
    
    // 注册
    ConfirmButton *nextButton = [[ConfirmButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(passwordTextfield.frame)+40, viewWidth - 40, 45)
                                                               title:@"注册并登录"
                                                              target:self
                                                              action:@selector(finishRegister)];
    nextButton.enabled = YES;
    [bottom_bg addSubview:nextButton];
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
    
    NSString *urlString = [SDD_MainURL stringByAppendingString:@"/sms/sendVerificationCode.do"];              // 拼接主路径和请求内容成完整url
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

#pragma mark - 跳到第二步
- (void)secondStep{
    
    if (![Tools_F validateMobile:phoneTextfield.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请输入11位手机号码"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if (codeTextfield.text.length != 4) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请输入4位验证码"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else {
        
        UIButton *btn = (UIButton *)[top_bg viewWithTag:101];
        [self stepClick:btn];
    }
}

#pragma mark - 跳到第三步
- (void)lastStep{
    
    
    if (nameTextfield.text.length<1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请填写姓名"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if (![Tools_F validateEmail:emailTextfield.text]){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请填写正确的邮箱"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else {
        UIButton *btn = (UIButton *)[top_bg viewWithTag:102];
        [self stepClick:btn];
    }
}

#pragma mark - 完成注册
- (void)finishRegister{
    
    if (![Tools_F validatePassword:passwordTextfield.text]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请输入6-12位有效的密码"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else {
        
        // 读取小米推送ID
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *miID = [defaults objectForKey:@"MiPushUserId"]?[defaults objectForKey:@"MiPushUserId"]:@"";
        
        NSDictionary *dic = @{
                              @"realName":[NSString stringWithFormat:@"%@",nameTextfield.text],
                              @"userName":[NSString stringWithFormat:@"%@",phoneTextfield.text],
                              @"code":[NSString stringWithFormat:@"%@",codeTextfield.text],
                              @"email":emailTextfield.text,
                              @"industryCategoryId":[NSNumber numberWithInteger:industryCategoryId2],
                              @"brand":brandTextfield.text,
                              @"password":[Tools_F Newmd5:passwordTextfield.text],
                              @"clientType":@2,
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
                
                UIButton *btn = (UIButton *)[top_bg viewWithTag:100];
                [self stepClick:btn];
            }
            
            [alert show];
        } failure:^(NSError *error) {
            //
            NSLog(@"错误 -- %@", error);
        }];
    }
}

#pragma mark - 行业选择
- (void)industrySelected{
    
    [self.view endEditing:YES];
    [dropMenu.rightTableView reloadData];
    [dropMenu menuTapped];
}

#pragma mark - FSDropDown datasource & delegate
- (NSInteger)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == menu.leftTableView) {
        if (currentModel) {
            
            return [currentModel.children count]+1;
        }
        else {
            return 0;
        }
    }
    else {
        
        return [_industryAll count];
    }
}

- (NSString *)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView titleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == menu.leftTableView) {
        
        if (indexPath.row == 0) {
            return @"不限";
        }
        else {
            
            NSDictionary *tempDic = currentModel.children[indexPath.row-1];
            return tempDic[@"categoryName"];
        }
    }
    else{
        
        FindBrankModel *model = _industryAll[indexPath.row];
        return model.categoryName;
    }
}

- (void)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == menu.leftTableView) {
        
        if (indexPath.row == 0) {
            
            industryTextfield.text = [NSString stringWithFormat:@"%@-不限",currentModel.categoryName];
            industryCategoryId2 = 0;
        }
        else {
            
            NSDictionary *tempDic = currentModel.children[indexPath.row-1];
            industryTextfield.text = tempDic[@"categoryName"];
            industryCategoryId2 = [tempDic[@"industryCategoryId"] integerValue];
        }
    }
    else{
        
        FindBrankModel *model = _industryAll[indexPath.row];
        industryCategoryId = [model.industryCategoryId integerValue];
        currentModel = model;
        [menu.leftTableView reloadData];
    }
}

#pragma mark - textField代理
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField == industryTextfield) {
        return NO;
    }
    return YES;
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
