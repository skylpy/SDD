//
//  SettlementViewController.m
//  SDD
//
//  Created by hua on 15/4/16.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "SettlementViewController.h"

#import "TTTAttributedLabel.h"
#import "Tools_F.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"

#import <AlipaySDK/AlipaySDK.h>

@interface SettlementViewController ()<UIGestureRecognizerDelegate>{
    
    /*- ui -*/
    // 意向金
    UILabel *theMoney;
    // 楼盘
    UILabel *building;
    // 户型
    UILabel *ald;
    // 姓名
    UILabel *orderNum;
    
    /*- data -*/
    NSDictionary *orderInfo;
}

// 网络请求
@property (nonatomic, strong) AFHTTPRequestOperationManager *httpManager;

@end

@implementation SettlementViewController

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

#pragma mark - 请求数据
- (void)requestData{
    
    // 请求参数
    NSDictionary *dic = [_orderType isEqualToString:@"1"]?@{@"houseId":_houseID,
                                                            @"phone":_phone,
                                                            @"realName":_realName,
                                                            @"unitIds":_unitArr
                                                            }:@{@"phone":_phone,
                                                                @"realName":_realName,
                                                                @"unitId":_unit};
    
    NSLog(@"生成订单参数： %@",dic);
    
    NSString *urlString = [_orderType isEqualToString:@"1"]?[SDD_MainURL stringByAppendingString:@"/userOrder/addRentOrder.do"]:[SDD_MainURL stringByAppendingString:@"/userOrder/addHouseActivityOrder.do"];              // 拼接主路径和请求内容成完整url
    
    [self.httpManager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = responseObject;
        NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
        if (![dict[@"data"] isEqual:[NSNull null]]) {
            
            orderInfo = dict[@"data"];
            
            theMoney.text = [_orderType isEqualToString:@"1"]?[NSString stringWithFormat:@"意向金:￥%@",orderInfo[@"totalPrice"]]:[NSString stringWithFormat:@"订金:￥%@",orderInfo[@"earnestMoney"]];
            building.text = [NSString stringWithFormat:@"楼盘:%@",_grTitle];
            ald.text = [_orderType isEqualToString:@"1"]?[NSString stringWithFormat:@"户型:%@",[_unitArr componentsJoinedByString:@","]]:[NSString stringWithFormat:@"户型:%@",orderInfo[@"buildingName"]];   // 将数组合成字符串
            orderNum.text = [NSString stringWithFormat:@"订单号:%@",orderInfo[@"orderNumber"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;

    // 加载数据
    [self requestData];
    // 导航条
    [self setupNav];
    // ui
    [self setupUI];
}

#pragma mark - 设置导航条
- (void)setupNav{
    
    SDDButton *button = [[SDDButton alloc]init];
    button.frame = CGRectMake(0, 0, 80, 44);
    [button setTitle:@"结算" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    // 右btn
    UIButton*cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 0, 40, 20);
    cancelButton.titleLabel.font = biggestFont;
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cancelButton];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    self.view.backgroundColor = bgColor;

    UIView *mainView_bg = [[UIView alloc] init];
    mainView_bg.frame = CGRectMake(0, 40, viewWidth, 234);
    mainView_bg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mainView_bg];
    
    theMoney = [[UILabel alloc] init];
    theMoney.frame =CGRectMake(viewWidth/5, 40, viewWidth*2/3, 16);
    theMoney.textColor = lorangeColor;
    theMoney.font = largeFont;
    [mainView_bg addSubview:theMoney];
    
    UILabel *theTips = [[UILabel alloc] init];
    theTips.frame =CGRectMake(viewWidth/5, CGRectGetMaxY(theMoney.frame)+15, viewWidth*4/5-10, 13);
    theTips.textColor = lgrayColor;
    theTips.font = midFont;
    theTips.text = @"订单提交成功，请您尽快付款！";
    [mainView_bg addSubview:theTips];
    
    building = [[UILabel alloc] init];
    building.frame =CGRectMake(viewWidth/5, CGRectGetMaxY(theTips.frame)+15, viewWidth*4/5-10, 13);
    building.textColor = lgrayColor;
    building.font = midFont;
    [mainView_bg addSubview:building];
    
    ald = [[UILabel alloc] init];
    ald.frame =CGRectMake(viewWidth/5, CGRectGetMaxY(building.frame)+15, viewWidth*4/5-10, 13);
    ald.textColor = lgrayColor;
    ald.font = midFont;
    [mainView_bg addSubview:ald];
    
    orderNum = [[UILabel alloc] init];
    orderNum.frame =CGRectMake(viewWidth/5, CGRectGetMaxY(ald.frame)+15, viewWidth*4/5-10, 13);
    orderNum.textColor = lgrayColor;
    orderNum.font = midFont;
    [mainView_bg addSubview:orderNum];

    UILabel *payWays = [[UILabel alloc] init];
    payWays.frame = CGRectMake(10, CGRectGetMaxY(mainView_bg.frame)+10, viewWidth-20, 30);
    payWays.textColor = lgrayColor;
    payWays.font = midFont;
    payWays.text = @"支付方式";
    [self.view addSubview:payWays];
    
    UIView *division_long = [[UIView alloc] init];
    division_long.frame = CGRectMake(0, CGRectGetMaxY(payWays.frame), viewWidth, 1);
    division_long.backgroundColor = divisionColor;
    [self.view addSubview:division_long];
    
    UILabel *alipay = [[UILabel alloc] init];
    alipay.frame = CGRectMake(10, CGRectGetMaxY(division_long.frame), viewWidth-20, 30);
    alipay.textColor = deepBLack;
    alipay.font = midFont;
    alipay.text = @"支付宝";
    [self.view addSubview:alipay];
    
    UIView *division_short = [[UIView alloc] init];
    division_short.frame = CGRectMake(10, CGRectGetMaxY(alipay.frame), viewWidth-10, 1);
    division_short.backgroundColor = divisionColor;
    [self.view addSubview:division_short];
    
    UILabel *bankingWeb = [[UILabel alloc] init];
    bankingWeb.frame = CGRectMake(10, CGRectGetMaxY(division_short.frame), viewWidth-20, 30);
    bankingWeb.textColor = deepBLack;
    bankingWeb.font = midFont;
    bankingWeb.text = @"网银支付";
    [self.view addSubview:bankingWeb];
    
    // 提醒
    TTTAttributedLabel *payTips = [[TTTAttributedLabel alloc] init];
    payTips.frame = CGRectMake(10, CGRectGetMaxY(bankingWeb.frame)+10, viewWidth-20, 50);
    payTips.textColor = lgrayColor;
    payTips.font = midFont;
    payTips.lineSpacing = 5;
    payTips.text = @"请在90分钟内完成支付，否则订单会自动取消\n付款成功后7个工作日内无条件退款";
    payTips.numberOfLines = 0;
    [self.view addSubview:payTips];
    
    // 确认订单
    UIButton *settlement = [UIButton buttonWithType:UIButtonTypeCustom];
    settlement.frame = CGRectMake(0, viewHeight-104, viewWidth, 40);
    settlement.backgroundColor = deepOrangeColor;
    [settlement setTitle:@"立即支付" forState:UIControlStateNormal];
    [settlement setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    settlement.titleLabel.font = [UIFont systemFontOfSize:16];
    [settlement addTarget:self action:@selector(settlementClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settlement];
    
}

#pragma mark - 对接数据
- (void)connect{
    
}

#pragma mark - settlementClick
- (void)settlementClick:(UIButton *)btn{
    
    // 请求参数
    NSDictionary *dic = @{@"orderType":_orderType,@"payType":@1,@"orderId":orderInfo[@"orderId"]};
    
    NSString *urlString = [SDD_MainURL stringByAppendingString:@"/pay/order.do"];              // 拼接主路径和请求内容成完整url
    NSLog(@"支付参数 %@",dic);
    [self.httpManager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = responseObject;
        NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
        if (![dict[@"data"] isEqual:[NSNull null]]) {
            
            [[AlipaySDK defaultService] payOrder:dict[@"data"] fromScheme:@"SDD" callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
                
//                self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            }];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
}

#pragma mark - cancelAction
- (void)cancelAction:(UIButton *)btn{
    
    NSLog(@"取消订单");
    if (self.presentingViewController) {
        
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - leftaction
- (void)leftAction:(UIButton *)btn{
    
    NSLog(@"返回");
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
