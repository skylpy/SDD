//
//  IWantToJoinViewController.m
//  SDD
//  我要加盟
//  Created by hua on 15/12/24.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "IWantToJoinViewController.h"
#import "JoinWithPersionInfoViewController.h"

@interface IWantToJoinViewController ()

/********************* UI *************************/
@property(nonatomic,strong) UILabel *successLabel;  //已有58位成功预约看铺
@property(nonatomic,strong) UITextField *phoTextField;  //请输入手机号码
@property(nonatomic,strong) UIButton *bookingBtn;   //点我预约
@property(nonatomic,strong) UIButton *bookingOnLineBtn;  //在线预约

@end

@implementation IWantToJoinViewController

#pragma mark
#pragma mark 获取数据
- (void)getData
{
    [self showLoading:0];
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/houseAppointmentVisit/countAppointmentVisit.do" params:nil success:^(id JSON) {
        
        if (![JSON isKindOfClass:[NSNull class]]) {
            if ([JSON[@"status"]intValue] == 1) {
                NSDictionary *dict = JSON[@"data"];
                NSString *successStr = [NSString stringWithFormat:@"已有%@位成功预约看铺",dict[@"appointmentVisitQty"]];
                self.successLabel.text = successStr;
            }
        }
        
        [self hideLoading];
    } failure:^(NSError *error) {
        [self hideLoading];
    }];
}

#pragma mark
#pragma mark 向服务器提交预约申请
- (void)sendBookingToServer
{
    [self showLoading:0];
    NSDictionary *postDic = @{@"objectId":self.brandId,@"reservationPhone":self.phoTextField.text,@"type":@(1)};
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/reservationVisit/save.do" params:postDic success:^(id JSON) {
        NSLog(@"%@",JSON);
        if (![JSON isKindOfClass:[NSNull class]] && [JSON[@"status"]intValue]==1) {
            
            [self showDataWithText:@"预约成功！\n我们的工作人员会尽快与您联系" buttonTitle:@"确定" buttonTag:1 target:self action:@selector(buttonClick:)];
        }else{
            NSString *message = JSON[@"message"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"预约失败"
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        [self hideLoading];
    } failure:^(NSError *error) {
        [self hideLoading];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                           message:@"联网失败"
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"确定"
                                                                 otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self viewSetup];
    [self getData];
}

- (void)viewSetup
{
    [self setNav];
    self.view.backgroundColor = bgColor;
    
    //已有58位成功预约看铺
    self.successLabel = [[UILabel alloc]init];
    self.successLabel.backgroundColor =  dblueColor;
    self.successLabel.alpha = 0.6;
    self.successLabel.font = bottomFont_12;
    self.successLabel.textAlignment = NSTextAlignmentCenter;
    self.successLabel.textColor = [UIColor whiteColor];
    self.successLabel.text = @"已有0位成功预约看铺";
    self.successLabel.layer.cornerRadius = 10;
    self.successLabel.layer.masksToBounds = YES;
    [self.view addSubview:self.successLabel];
    [self.successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(60);
        make.right.equalTo(self.view.mas_right).with.offset(-60);
        make.top.equalTo(self.view.mas_top).with.offset(15);
        make.height.equalTo(@20);
    }];
    
    //手机号码输入框
    self.phoTextField = [[UITextField alloc]init];
    self.phoTextField.layer.cornerRadius = 4;
    self.phoTextField.layer.masksToBounds = YES;
    self.phoTextField.layer.borderWidth = 0.5;
    self.phoTextField.layer.borderColor = ldivisionColor.CGColor;
    self.phoTextField.backgroundColor = [UIColor whiteColor];
    self.phoTextField.placeholder = @"请输入手机号码";
    self.phoTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoTextField.inputView.backgroundColor = [UIColor blueColor];
    self.phoTextField.font = midFont;
    self.phoTextField.leftViewMode = UITextFieldViewModeAlways;
    self.phoTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 38)];
    [self.view addSubview:self.phoTextField];
    [self.phoTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(16);
        make.right.equalTo(self.view.mas_right).with.offset(-16);
        make.top.equalTo(self.successLabel.mas_bottom).with.offset(16);
        make.height.equalTo(@38);
    }];
    
    //立即预约按钮
    self.bookingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bookingBtn setBackgroundImage:[UIImage imageNamed:@"icon-order-join"] forState:UIControlStateNormal];
    [self.bookingBtn addTarget:self action:@selector(bookingBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bookingBtn];
    [self.bookingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.phoTextField.mas_bottom).with.offset(41);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    //在线预约按钮
    NSMutableAttributedString *bookOnLineStr = [[NSMutableAttributedString alloc]initWithString:@"同时您也可以选择在线预约"];
    [bookOnLineStr addAttribute:NSForegroundColorAttributeName value:lgrayColor range:NSMakeRange(0, 8)];
    [bookOnLineStr addAttribute:NSForegroundColorAttributeName value:dblueColor range:NSMakeRange(8, 4)];
    [bookOnLineStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(8, 4)];
    self.bookingOnLineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bookingOnLineBtn.titleLabel.font = midFont;
    [self.bookingOnLineBtn setAttributedTitle:bookOnLineStr forState:UIControlStateNormal];
    [self.bookingOnLineBtn addTarget:self action:@selector(bookingOnLineBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bookingOnLineBtn];
    [self.bookingOnLineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bookingBtn.mas_bottom).with.offset(15);
        make.height.equalTo(@12);
        make.centerX.equalTo(self.view);
        make.width.greaterThanOrEqualTo(@10);
    }];
}

#pragma mark --  导航条返回按钮
-(void)setNav{
    
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"我要加盟";
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

#pragma mark
#pragma mark 点我预约按钮点击
- (void)bookingBtnClick:(UIButton*)sender
{
    [self.view endEditing:YES];
    
    if (![Tools_F validateMobile:self.phoTextField.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请填写正确手机号"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    [self sendBookingToServer];
    NSLog(@"");
}

#pragma mark
#pragma mark 在线预约按钮点击
- (void)bookingOnLineBtnClick:(UIButton*)sender
{
    JoinWithPersionInfoViewController *vc = [[JoinWithPersionInfoViewController alloc]init];
    vc.brandId = self.brandId;
    vc.brandStr = self.brandStr;
    vc.discount = self.discount;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 取消提示按钮
-(void)buttonClick:(UIButton *)btn
{
    [self.bigView removeFromSuperview];
    [self.minView removeFromSuperview];
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
