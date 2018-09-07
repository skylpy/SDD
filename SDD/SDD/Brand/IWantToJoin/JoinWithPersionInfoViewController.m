//
//  JoinWithPersionInfoViewController.m
//  SDD
//  预约加盟 - （第一步）填写用户信息
//  Created by hua on 15/12/24.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "JoinWithPersionInfoViewController.h"
#import "JoinWithCompanyInfoViewController.h"
#import "UserInfo.h"

typedef NS_ENUM(NSInteger, Sex) {
    SexMan = 1,  //男
    SexWoman = 0,  //女
};

@interface JoinWithPersionInfoViewController ()

/********************* UI *************************/
@property(nonatomic,strong) UITextField *nameTextField; //姓名输入框
@property(nonatomic,strong) UITextField *phoTextField; //手机号输入框
@property(nonatomic,strong) UIButton *manBtn;  //先生
@property(nonatomic,strong) UIButton *womanBtn;  //女士


/********************* Data *************************/
@property(nonatomic,assign) Sex sex;  //性别


@end

@implementation JoinWithPersionInfoViewController

- (void)getData
{
    UserInfo *user = [UserInfo sharedInstance];
    NSDictionary *userDic = user.userInfoDic;
    self.nameTextField.text = userDic[@"realName"];
    self.phoTextField.text = userDic[@"phone"];
    
    //默认选中‘先生’
    self.sex = SexMan;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self viewSetUp];
    
    [self getData];
}


#pragma mark
#pragma mark 设置性别
- (void)setSex:(Sex )sex
{
    _sex = sex;
    
    if (sex == SexMan) {
        self.manBtn.selected = YES;
        self.womanBtn.selected = NO;
    }else if (sex == SexWoman) {
        self.manBtn.selected = NO;
        self.womanBtn.selected = YES;
    }
}

- (void)viewSetUp
{
    self.view.backgroundColor = bgColor;
    [self setNav];
    
    //白色背景+分割线
    UIView *bgView = [self bgView];
    
    //姓名
    UILabel *nameLab = [self labelWithString:@"姓名:" superView:bgView];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).with.offset(0);
    }];
    
    //姓名输入框
    self.nameTextField = [self textFieldWithText:@"刘晓光" placeholder:@"请输入姓名"];
    [bgView addSubview:self.nameTextField];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@45);
        make.left.equalTo(nameLab.mas_right);
        make.right.equalTo(bgView.mas_right).with.offset(-45);
        make.top.equalTo(bgView.mas_top);
    }];
    
    //姓名输入框删除
    UIButton *nameTextDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    [nameTextDelete addTarget:self action:@selector(nameTextDeleteClick) forControlEvents:UIControlEventTouchUpInside];
    [nameTextDelete setImage:[UIImage imageNamed:@"icon-bran-clear"] forState:UIControlStateNormal];
    [bgView addSubview:nameTextDelete];
    [nameTextDelete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameTextField.mas_right);
        make.right.equalTo(bgView.mas_right);
        make.top.equalTo(bgView.mas_top);
        make.height.equalTo(@45);
    }];
    
    //性别
    UILabel *sexLab = [self labelWithString:@"性别:" superView:bgView];
    [sexLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).with.offset(45);
    }];
    
    self.manBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.manBtn setTitle:@"先生" forState:UIControlStateNormal];
    [self.manBtn setImage:[UIImage imageNamed:@"icon--choosesex-unact"] forState:UIControlStateNormal];
    [self.manBtn setImage:[UIImage imageNamed:@"icon--choosesex-act"] forState:UIControlStateSelected];
    [self.manBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    [self.manBtn setTitleColor:mainTitleColor forState:UIControlStateNormal];
    self.manBtn.titleLabel.font = midFont;
    [self.manBtn addTarget:self action:@selector(manBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.manBtn];
    [self.manBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sexLab.mas_right);
        make.centerY.equalTo(sexLab.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 45));
    }];
    
    self.womanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.womanBtn setTitle:@"女士" forState:UIControlStateNormal];
    [self.womanBtn setImage:[UIImage imageNamed:@"icon--choosesex-unact"] forState:UIControlStateNormal];
    [self.womanBtn setImage:[UIImage imageNamed:@"icon--choosesex-act"] forState:UIControlStateSelected];
    [self.womanBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
    [self.womanBtn setTitleColor:mainTitleColor forState:UIControlStateNormal];
    self.womanBtn.titleLabel.font = midFont;
    [self.womanBtn addTarget:self action:@selector(womanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:self.womanBtn];
    [self.womanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.manBtn.mas_right).with.offset(40);
        make.centerY.equalTo(sexLab.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 45));
    }];
    
    //手机号
    UILabel *phoNumLab = [self labelWithString:@"手机号:" superView:bgView];
    [phoNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top).with.offset(90);
    }];
    
    //手机号输入框
    self.phoTextField = [self textFieldWithText:@"" placeholder:@"请输入手机号"];
    [bgView addSubview:self.phoTextField];
    self.phoTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.phoTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@45);
        make.left.equalTo(nameLab.mas_right);
        make.top.equalTo(bgView.mas_top).with.offset(90);
    }];
    
    //手机号输入框删除
    UIButton *phoTextDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    [phoTextDelete addTarget:self action:@selector(phoTextDeleteClick) forControlEvents:UIControlEventTouchUpInside];
    [phoTextDelete setImage:[UIImage imageNamed:@"icon-bran-clear"] forState:UIControlStateNormal];
    [bgView addSubview:phoTextDelete];
    [phoTextDelete mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameTextField.mas_right);
        make.right.equalTo(bgView.mas_right);
        make.top.equalTo(bgView.mas_top).with.offset(90);
        make.height.equalTo(@45);
    }];
    
    //下一步按钮
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setBackgroundColor:dblueColor];
    nextBtn.titleLabel.font = largeFont;
    nextBtn.layer.cornerRadius = 5;
    nextBtn.layer.masksToBounds = YES;
    [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
        make.top.equalTo(bgView.mas_bottom).with.offset(15);
        make.height.equalTo(@45);
    }];
}

#pragma mark
#pragma mark 输入框
- (UITextField*)textFieldWithText:(NSString*)text placeholder:(NSString*)placeholder
{
    UITextField *textField = [[UITextField alloc]init];
    textField.text = text;
    textField.placeholder = placeholder;
    textField.textColor = mainTitleColor;
    textField.font = midFont;
    return textField;
}

#pragma mark
#pragma mark 姓名、性别、手机号label
- (UILabel*)labelWithString:(NSString*)title superView:(UIView*)superView
{
    UILabel *label = [[UILabel alloc]init];
    label.text = title;
    label.textColor = mainTitleColor;
    label.font = midFont;
    [superView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView).with.offset(10);
        make.width.equalTo(@53);
        make.height.equalTo(@45);
    }];
    return label;
}

#pragma mark
#pragma mark 白色View + 横划线
- (UIView*)bgView
{
    UIView *bgView = [[UIView alloc]init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.equalTo(@135);
    }];
    
    for (int i =0; i<2; i++) {
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = divisionColor;
        [bgView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bgView);
            make.right.equalTo(bgView);
            make.top.equalTo(bgView.mas_top).with.offset(45*(i+1));
            make.height.equalTo(@0.5);
        }];
    }
    return bgView;
}

#pragma mark
#pragma mark 下一步按钮点击
- (void)nextBtnClick
{
    
    NSString *name = self.nameTextField.text;
    NSString *phoneNumber = self.phoTextField.text;
    if(name.length>0 && phoneNumber.length>0){
        JoinWithCompanyInfoViewController *vc = [[JoinWithCompanyInfoViewController alloc]init];
        vc.name = name;
        vc.sex = self.sex;
        vc.phoneNumber = [phoneNumber integerValue];
        vc.discount = self.discount;
        vc.brandId = self.brandId;
        vc.brandStr = self.brandStr;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入完整信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark
#pragma mark 先生按钮点击
- (void)manBtnClick:(UIButton*)sender
{
    self.sex = SexMan;
}

#pragma mark 女士按钮点击
- (void)womanBtnClick:(UIButton*)sender
{
    self.sex = SexWoman;
}

#pragma mark
#pragma mark 姓名输入框删除按钮点击
- (void)nameTextDeleteClick
{
    self.nameTextField.text = @"";
}
#pragma mark
#pragma mark 手机号输入框删除按钮点击
- (void)phoTextDeleteClick
{
    self.phoTextField.text = @"";
}

#pragma mark --  导航条返回按钮
-(void)setNav{
    
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"预约加盟";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

#pragma mark 返回按钮点击
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
