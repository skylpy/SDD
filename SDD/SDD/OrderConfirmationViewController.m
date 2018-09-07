//
//  OrderConfirmationViewController.m
//  SDD
//
//  Created by hua on 15/4/16.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "OrderConfirmationViewController.h"
#import "UserInfo.h"

#import "SettlementViewController.h"

#import "TTTAttributedLabel.h"
#import "UIImageView+WebCache.h"

@interface OrderConfirmationViewController ()<UIGestureRecognizerDelegate,UIAlertViewDelegate>{
    
    /*- ui -*/
    
    UIView *mainView_bg;
    // 楼盘
    UILabel *building;
    // 户型
    UILabel *aldLabel;
    // 意向金
    UILabel *theMoney;
    // 姓名
    UILabel *theName;
    // 手机号
    UILabel *phoneNum;
    
    /*- data -*/
    NSString *realName;
    NSString *phone;
}

// 网络请求
@property (nonatomic, strong) AFHTTPRequestOperationManager *httpManager;

@end

@implementation OrderConfirmationViewController

- (AFHTTPRequestOperationManager *)httpManager{
    if(!_httpManager)
    {
        _httpManager = [AFHTTPRequestOperationManager manager];
        //        httpManager.requestSerializer.timeoutInterval = 15;         //设置超时时间
        _httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];        // ContentTypes 为json
    }
    return _httpManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.view.backgroundColor = bgColor;
    
    // 导航条
    [self setupNav];
    // ui
    [self setupUI];
}

#pragma mark - 设置导航条
- (void)setupNav{
    
    SDDButton *button = [[SDDButton alloc]init];
    button.frame = CGRectMake(0, 0, viewWidth*2/3, 44);
    [button setTitle:_theTitle forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    realName = [UserInfo sharedInstance].userInfoDic[@"userName"];
    phone = [UserInfo sharedInstance].userInfoDic[@"phone"];
    
    // 上方
    mainView_bg = [[UIView alloc] init];
    mainView_bg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mainView_bg];
    
    // 判断订单来源
    if ([_orderType isEqualToString:@"1"]) {
        
        [self orderFromRent];
    }
    else {
        
        [self orderFromDiscountShop];
    }
    
    // 提示
    TTTAttributedLabel *theTips = [[TTTAttributedLabel alloc] init];
    theTips.frame = CGRectMake(8, CGRectGetMaxY(mainView_bg.frame)+8, viewWidth+16, 60);
    theTips.textColor = lgrayColor;
    theTips.font = midFont;
    theTips.lineSpacing = 5;                // 行距
    theTips.text = @"提示:\n1.7个工作日内无条件退款\n2.支付租房定金后，会有专业客服与你联系";
    theTips.numberOfLines = 0;
    [self.view addSubview:theTips];
    
    // 确认订单
    UIButton *orderConfirmation = [UIButton buttonWithType:UIButtonTypeCustom];
    orderConfirmation.frame = CGRectMake(0, viewHeight-104, viewWidth, 40);
    orderConfirmation.backgroundColor = deepOrangeColor;
    [orderConfirmation setTitle:@"确认订单" forState:UIControlStateNormal];
    [orderConfirmation setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    orderConfirmation.titleLabel.font = [UIFont systemFontOfSize:16];
    [orderConfirmation addTarget:self action:@selector(confirmation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:orderConfirmation];
}

#pragma mark - 团租在线选房
- (void)orderFromRent{
    
    NSArray *titles = @[@"楼盘: ",
                        @"业态: ",
                        @"品牌: ",
                        @"楼座: ",
                        @"楼层: ",
                        @"铺位: ",
                        @"面积: ",
                        @"姓名: ",
                        @"手机号: "
                        ];
    
    for (int i = 0; i < [titles count]; i++) {
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(70, 30+(26*i), viewWidth-80, 16);
        label.tag = 100+i;
        label.font = midFont;
        label.textColor = lgrayColor;
        [mainView_bg addSubview:label];
    }
    
    // 楼盘
    UILabel *label_a = (UILabel *)[mainView_bg viewWithTag:100];
    label_a.text = [titles[0] stringByAppendingString:_theTitle];
    
    // 业态
    UILabel *label_b = (UILabel *)[mainView_bg viewWithTag:101];
    label_b.text = [titles[1] stringByAppendingString:_commonData[0]];
    
    // 品牌
    UILabel *label_c = (UILabel *)[mainView_bg viewWithTag:102];
    label_c.text = [titles[2] stringByAppendingString:_commonData[6]];
    
    // 楼座
    UILabel *label_d = (UILabel *)[mainView_bg viewWithTag:103];
    label_d.text = [titles[3] stringByAppendingString:_commonData[1]];
    
    // 楼层
    UILabel *label_e = (UILabel *)[mainView_bg viewWithTag:104];
    label_e.text = [titles[4] stringByAppendingString:_commonData[2]];
    
    // 铺位+面积
    NSMutableString *stores = [[NSMutableString alloc] init];
    NSMutableString *areas = [[NSMutableString alloc] init];
    for (int i = 0; i < [_storesData count]; i++) {
        
        NSArray *arr = [_storesData[i] componentsSeparatedByString:@"                 "];
        if ([arr count]>1) {
            
            [stores appendFormat:@"%@ ",arr[0]];
            [areas appendFormat:@"%@ ",arr[1]];
        }
    }
    
    UILabel *label_f = (UILabel *)[mainView_bg viewWithTag:105];
    label_f.text = [titles[5] stringByAppendingString:stores];
    
    UILabel *label_g = (UILabel *)[mainView_bg viewWithTag:106];
    label_g.text = [titles[6] stringByAppendingString:areas];
    
    // 姓名
    UILabel *label_h = (UILabel *)[mainView_bg viewWithTag:107];
    label_h.font = largeFont;
    label_h.textColor = [UIColor blackColor];
    label_h.text = [titles[7] stringByAppendingString:_commonData[8]];
    
    // 手机号
    UILabel *label_i = (UILabel *)[mainView_bg viewWithTag:108];
    label_i.font = largeFont;
    label_i.textColor = [UIColor blackColor];
    label_i.text = [titles[8] stringByAppendingString:_commonData[10]];
    
    mainView_bg.frame = CGRectMake(0, 0, viewWidth, CGRectGetMaxY(label_i.frame)+15);

}

#pragma mark - 团购特价铺
- (void)orderFromDiscountShop{
    
    // 楼盘名
    building = [[UILabel alloc] init];
    building.frame =CGRectMake(viewWidth/5, 30, viewWidth*2/3, 13);
    building.textColor = lgrayColor;
    building.font = midFont;
    building.text = [NSString stringWithFormat:@"楼盘:%@",_theTitle];
    [mainView_bg addSubview:building];
    
    // 户型
    aldLabel = [[UILabel alloc] init];
    aldLabel.frame = CGRectMake(viewWidth/5, CGRectGetMaxY(building.frame)+10, viewWidth*2/3, 13);
    aldLabel.textColor = lgrayColor;
    aldLabel.font = midFont;
    aldLabel.text = [NSString stringWithFormat:@"户型:%@",_ald];
    [mainView_bg addSubview:aldLabel];
    
    // 优惠价
    UILabel *ppLabel = [[UILabel alloc] init];
    ppLabel.frame = CGRectMake(viewWidth/5, CGRectGetMaxY(aldLabel.frame)+10, viewWidth*2/3, 16);
    ppLabel.textColor = lgrayColor;
    ppLabel.font = midFont;
    ppLabel.text =[NSString stringWithFormat:@"优惠价:%@",_preferentialPrice];
    [mainView_bg addSubview:ppLabel];
    
    // 意向金
    theMoney = [[UILabel alloc] init];
    theMoney.frame = CGRectMake(viewWidth/5, CGRectGetMaxY(ppLabel.frame)+10, viewWidth*2/3, 16);
    theMoney.textColor = lorangeColor;
    theMoney.font = largeFont;
    theMoney.text = [NSString stringWithFormat:@"定金:%@",_orderMoney];
    [mainView_bg addSubview:theMoney];
    
    // 名字
    theName = [[UILabel alloc] init];
    theName.frame =CGRectMake(viewWidth/5, CGRectGetMaxY(theMoney.frame)+10, viewWidth*2/3, 13);
    theName.textColor = deepBLack;
    theName.font = largeFont;
    theName.text = [NSString stringWithFormat:@"租房人:%@",realName];
    [mainView_bg addSubview:theName];
    
    // 手机
    phoneNum = [[UILabel alloc] init];
    phoneNum.frame =CGRectMake(viewWidth/5, CGRectGetMaxY(theName.frame)+10, viewWidth*2/3, 13);
    phoneNum.textColor = deepBLack;
    phoneNum.font = largeFont;
    phoneNum.text = [NSString stringWithFormat:@"手机号:%@",phone];
    [mainView_bg addSubview:phoneNum];
    
//    UIButton *resetInfo = [UIButton buttonWithType:UIButtonTypeCustom];
//    resetInfo.frame = CGRectMake(viewWidth/2-85, mainView_bg.frame.size.height-50, 70, 25);
//    [Tools_F setViewlayer:resetInfo cornerRadius:4 borderWidth:1 borderColor:deepOrangeColor];
//    [resetInfo setTitle:@"重置信息" forState:UIControlStateNormal];
//    [resetInfo setTitleColor:deepOrangeColor forState:UIControlStateNormal];
//    resetInfo.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
//    [resetInfo addTarget:self action:@selector(resetClick:) forControlEvents:UIControlEventTouchUpInside];
//    [mainView_bg addSubview:resetInfo];
    
    UIButton *modifyInfo = [UIButton buttonWithType:UIButtonTypeCustom];
    modifyInfo.frame = CGRectMake(0, 0, 70, 25);
    modifyInfo.center = CGPointMake(viewWidth/2, CGRectGetMaxY(phoneNum.frame)+30);
    [Tools_F setViewlayer:modifyInfo cornerRadius:4 borderWidth:1 borderColor:deepOrangeColor];
    [modifyInfo setTitle:@"修改信息" forState:UIControlStateNormal];
    [modifyInfo setTitleColor:deepOrangeColor forState:UIControlStateNormal];
    modifyInfo.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    [modifyInfo addTarget:self action:@selector(modifyClick:) forControlEvents:UIControlEventTouchUpInside];
    [mainView_bg addSubview:modifyInfo];
    
    mainView_bg.frame = CGRectMake(0, 0, viewWidth, CGRectGetMaxY(modifyInfo.frame)+15);
}

#pragma mark - 重置信息
- (void)resetClick:(UIButton *)btn{
    
    NSLog(@"重置信息");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - 修改信息
- (void)modifyClick:(UIButton *)btn{
    
    NSLog(@"修改信息");
    UIAlertView *infoModify = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    
    infoModify.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    
    //设置输入框的键盘类型
    UITextField *phoneNum_A = [infoModify textFieldAtIndex:0];
    phoneNum_A.placeholder = @"请填写租房人手机号";
    phoneNum_A.keyboardType = UIKeyboardTypeNumberPad;
    
    UITextField *buyerName = [infoModify textFieldAtIndex:1];
    buyerName.secureTextEntry = NO;
    buyerName.placeholder = @"请填写租房人姓名";
    
    [infoModify show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        UITextField *ptextField = [alertView textFieldAtIndex:0];
        UITextField *ntextField = [alertView textFieldAtIndex:1];
        
        realName = ntextField.text;
        theName.text = [NSString stringWithFormat:@"租房人:%@",realName];
        phone = ptextField.text;
        phoneNum.text = [NSString stringWithFormat:@"手机号:%@",phone];
    }
}

#pragma mark - 确认订单
- (void)confirmation:(UIButton *)btn{
    
    NSLog(@"确认订单");
    if ([_orderType isEqualToString:@"1"]) {
        
        // 计算拼接spces
        NSMutableArray *spces = [NSMutableArray array];
        for (int i=0; i<[_storesData count]; i++) {
            
            NSArray *arr = [_storesData[i] componentsSeparatedByString:@"                 "];
            if ([arr count]>1) {
                
                NSDictionary *dic = @{@"area": arr[1],
                                      @"unitId":_currentUnitId[i]
                                      };
                [spces addObject:dic];
            }
        }
        
        // 请求参数
        NSDictionary *dic = @{@"brand":[NSString stringWithFormat:@"%@",_commonData[6]],
                              @"company":[NSString stringWithFormat:@"%@",_commonData[5]],
                              @"houseId":_houseID,
                              @"industryCategoryId":@1,
                              @"industryCategoryName":[NSString stringWithFormat:@"%@",_commonData[0]],
                              @"phone":[NSString stringWithFormat:@"%@",_commonData[10]],
                              @"post":[NSString stringWithFormat:@"%@",_commonData[9]],
                              @"realName":[NSString stringWithFormat:@"%@",_commonData[8]],
                              @"specs":spces,
                              @"typeCategoryId":@1,
                              @"typeCategoryName":[NSString stringWithFormat:@"%@",_commonData[7]]
                              };
        
        NSString *urlString = [SDD_MainURL stringByAppendingString:@"/userOrder/addRentOrder.do"];              // 拼接主路径和请求内容成完整url
        
        [self.httpManager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *dict = responseObject;
            NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            if ([dict[@"status"] intValue] == 1) {
                
                self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"错误 -- %@", error);
        }];
        
    }
    else {
        
        // 现在无支付， 直接生成订单
//        SettlementViewController *settlementVC = [[SettlementViewController alloc] init];
//        
//        settlementVC.houseID = _houseID;
//        settlementVC.grTitle = _theTitle;
//        settlementVC.unitArr = _unitArr;
//        settlementVC.unit = _unit;
//        settlementVC.realName = realName;
//        settlementVC.phone = phone;
//        settlementVC.orderType = _orderType;
//        [self.navigationController pushViewController:settlementVC animated:YES];
        
        // 请求参数
        NSDictionary *dic = @{@"phone":phone,
                              @"realName":realName,
                              @"unitId":_unit};
        
        NSString *urlString = [SDD_MainURL stringByAppendingString:@"/userOrder/addHouseActivityOrder.do"];              // 拼接主路径和请求内容成完整url
        
        [self.httpManager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *dict = responseObject;
            NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            if ([dict[@"status"] intValue] == 1) {
                
                self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"错误 -- %@", error);
        }];
    }
}

#pragma mark - leftaction
- (void)leftAction:(UIButton *)btn{
    
    NSLog(@"返回");
    if ([_orderType isEqualToString:@"2"]) {
        
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
    
        [self.navigationController popViewControllerAnimated:YES];
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
