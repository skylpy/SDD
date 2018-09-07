//
//  NewAppointViewController.m
//  SDD
//
//  Created by mac on 15/11/5.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "NewAppointViewController.h"
#import "ReservationController.h"
#import "NewReservationController.h"
#import "NewReserOneViewController.h"
#import "CommonLib.h"
#import "UserInfo.h"

@interface NewAppointViewController ()
{
    NSNumber * appointmentVisitQtyp;
    UITextField * phoneText;
    
    UIButton * Telephone;
}
@end

@implementation NewAppointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    // 导航条
    [self setNav:@"预约看铺"];
    
    [self requestData];
}

#pragma mark - 设置内容
-(void)requestData
{
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/houseAppointmentVisit/countAppointmentVisit.do" params:nil success:^(id JSON) {
        
        NSLog(@"%@",JSON);
        if (![JSON[@"data"] isEqual:[NSNull null]]) {
            
            appointmentVisitQtyp = JSON[@"data"][@"appointmentVisitQty"];
        }
        // 设置内容
        [self setupUI];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    UILabel * qtypBtn = [[UILabel alloc] initWithFrame:CGRectMake(40, 60, viewWidth-80, 30)];
    
    //[qtypBtn setTitle:[NSString stringWithFormat:@"已有 %@ 位成功预约看铺",appointmentVisitQtyp] forState:UIControlStateNormal];
    qtypBtn.font = titleFont_15;
    qtypBtn.textAlignment = NSTextAlignmentCenter;
    qtypBtn.layer.cornerRadius = 15;
    qtypBtn.clipsToBounds = YES;
    qtypBtn.backgroundColor = [UIColor colorWithRed:181/255.0 green:211/255.0 blue:235/255.0 alpha:1];
    [self.view addSubview:qtypBtn];
    
    
    NSString * originalString = [NSString stringWithFormat:@"已有 %@ 位成功预约看铺",
                      appointmentVisitQtyp];
    NSMutableAttributedString * paintString = [[NSMutableAttributedString alloc] initWithString:originalString];
    [paintString addAttribute:NSForegroundColorAttributeName
                        value:tagsColor
                        range:[originalString
                               rangeOfString:[NSString stringWithFormat:@"%@",appointmentVisitQtyp]]];

    qtypBtn.textColor = [UIColor whiteColor];
    qtypBtn.attributedText = paintString;
    
    phoneText = [[UITextField alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(qtypBtn.frame)+30, viewWidth-80, 40)];
    phoneText.placeholder = @"请输入您的手机号码";
    phoneText.text = [UserInfo sharedInstance].userInfoDic[@"phone"];
    phoneText.font = midFont;
    [self.view addSubview:phoneText];
    
    UILabel * lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, CGRectGetMaxY(phoneText.frame), viewWidth-80, 1)];
    lineLabel.backgroundColor = lgrayColor;
    [self.view addSubview:lineLabel];
    
    Telephone = [UIButton buttonWithType:UIButtonTypeCustom];
    Telephone.frame = CGRectMake(viewWidth/2-30, CGRectGetMaxY(lineLabel.frame)+20, 70, 70);
    Telephone.backgroundColor = tagsColor;
    Telephone.layer.cornerRadius = 35;
    Telephone.clipsToBounds = YES;

    [Telephone setImage:[UIImage imageNamed:@"icon-book"] forState:UIControlStateNormal];
    Telephone.titleLabel.font = midFont;
    [Telephone addTarget:self action:@selector(TelephoneClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Telephone];
    
    
    UILabel * proLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(Telephone.frame)+20,viewWidth/2+30 , 20)];
    proLabel.text = @"同时您也可以选择";
    proLabel.font = midFont;
    proLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:proLabel];
    
    UIButton * onlineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    onlineBtn.frame = CGRectMake(CGRectGetMaxX(proLabel.frame), CGRectGetMaxY(Telephone.frame)+20, 60, 20);
    onlineBtn.backgroundColor = bgColor;
    [onlineBtn setTitle:@"在线预约" forState:UIControlStateNormal];;
    [onlineBtn setTitleColor:dblueColor forState:UIControlStateNormal];
    onlineBtn.titleLabel.font = midFont;
    
    [onlineBtn addTarget:self action:@selector(onlineBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:onlineBtn];
    
    UILabel * labelline = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(proLabel.frame), CGRectGetMaxY(onlineBtn.frame), 60, 1)];
    labelline.backgroundColor = dblueColor;
    [self.view addSubview:labelline];
    
    UIImageView * image_a = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(onlineBtn.frame), viewWidth, 130)];
    image_a.image = [UIImage imageNamed:@"bg-bookepage2"];
    [self.view addSubview:image_a];
    
    UIImageView * image_b = [[UIImageView alloc] init];
    image_b.image = [UIImage imageNamed:@"bg-bookpage1"];
    [self.view addSubview:image_b];
    [image_b mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(image_a.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

#pragma mark -- 设置定时器监控动画
-(void)TelephonetimeClick
{
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect framebtn = Telephone.frame;

        framebtn.origin.x -= 5;
        framebtn.origin.y -= 5;
        framebtn.size.width += 10;
        framebtn.size.height += 10;
        Telephone.frame = framebtn;

    } completion:^(BOOL finished) {

        [CommonLib runBlockAfterDelay:0.1 block:^{
            [UIView animateWithDuration:0.2 animations:^{
                CGRect framebtn = Telephone.frame;
                
                framebtn.origin.x += 5;
                framebtn.origin.y += 5;
                framebtn.size.width -= 10;
                framebtn.size.height -= 10;
                Telephone.frame = framebtn;

            } completion:^(BOOL finished) {
                
            }];
        }];
    }];
}


#pragma amrk -- 电话预约
-(void)TelephoneClick:(UIButton *)btn
{
   
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/reservationVisit/save.do" params:@{@"objectId":@([_houseID integerValue]),@"reservationPhone":phoneText.text} success:^(id JSON) {
        
        NSLog(@"%@",JSON);

        if ([JSON[@"status"] integerValue] == 1) {
            
            [phoneText resignFirstResponder];
            
            [self showDataWithText:@"提交成功！\n我们的工作人员会尽快与您联系" buttonTitle:@"确定" buttonTag:100 target:self action:@selector(buttonClick:)];
        }
        
        
        
    } failure:^(NSError *error) {
        
        
        
    }];
}

-(void)buttonClick:(UIButton *)btn
{
    [self.bigView removeFromSuperview];
    [self.minView removeFromSuperview];
    
}

#pragma amrk -- 在线预约
-(void)onlineBtnClick:(UIButton *)btn
{
    NewReserOneViewController *rVC = [[NewReserOneViewController alloc] init];
    
    rVC.houseName = _houseName;
    rVC.houseID = _houseID;
    rVC.isOfficial = YES;
    rVC.activityCategoryId = _activityCategoryId;
    [self.navigationController pushViewController:rVC animated:YES];
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
