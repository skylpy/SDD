//
//  SuccessReceiveViewController.m
//  成功领取折扣券
//
//  Created by mac on 15/7/24.
//  Copyright (c) 2015年 linpeiyu. All rights reserved.
//

#import "SuccessReceiveViewController.h"
#import "PrivilegeCell.h"
#import "successCell.h"
#import "SuccessDetailCell.h"
#import "CouponNumberCell.h"

#import "PreferentialBrandViewController.h"

@interface SuccessReceiveViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (retain,nonatomic)UITableView *tableView;
@property (retain,nonatomic)NSMutableArray *dataArray;

@end

@implementation SuccessReceiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor= [UIColor whiteColor];
    
    // 导航条
    [self setupNav];
    // 设置内容
    [self createView];
}

#pragma mark - 设置导航条
- (void)setupNav{
    
    SDDButton *button = [[SDDButton alloc]init];
    button.frame = CGRectMake(0, 0, 100, 44);
    [button setTitle:@"领取折扣券" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

- (void)createView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.backgroundColor = bgColor;
    _tableView.dataSource= self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            return 255/2;
        }
        case 1:
        {
            return 100;
        }
        case 2:
        {
            return 100;
        }
        case 3:
        {
            return 150;
        }
        default:
        {
            return 150;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            successCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
            if (cell == nil) {
                cell = [[successCell alloc] init];
                cell.selectionStyle = UITableViewCellAccessoryNone;
            }
            
            cell.ContentLabel.text = [NSString stringWithFormat:@"恭喜，您成功的领取了%@加盟折扣券",_brankName];
            
            return cell;
        }
        case 1:
        {
            SuccessDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            if (cell == nil) {
                cell = [[SuccessDetailCell alloc] init];
                cell.selectionStyle = UITableViewCellAccessoryNone;
            }
            
//            NSString *originalStr = [NSString stringWithFormat:@"%@%.1f折加盟折扣券",_brankName,
//                                     [_passValue[@"discount"] floatValue]];
//            NSMutableAttributedString *paintStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
//            [paintStr addAttribute:NSForegroundColorAttributeName
//                             value:lorangeColor
//                             range:[originalStr rangeOfString:[NSString stringWithFormat:@"%.1f折",
//                                                               [_passValue[@"discount"] floatValue]]]
//             ];
            //cell.titLabel.attributedText = paintStr;
            cell.ContentLabel.text = _passValue[@"maxPreperentialStr"];
            
            return cell;
        }
        case 2:
        {
            CouponNumberCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
            if (cell == nil) {
                cell = [[CouponNumberCell alloc] init];
                cell.selectionStyle = UITableViewCellAccessoryNone;
            }
            
            cell.CouponNumberLabel.text = [NSString stringWithFormat:@"折扣券码: %@",_passValue[@"discountNumber"]];;
            cell.EffectiveLabel.text = [NSString stringWithFormat:@"有效期至: %@",[Tools_F timeTransform:[_passValue[@"endTime"] intValue] time:days]];;
            
            return cell;
        }
        default:
        {
            PrivilegeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell5"];
            if (cell == nil) {
                cell = [[PrivilegeCell alloc] init];
                cell.selectionStyle = UITableViewCellAccessoryNone;
            }
            
            if (indexPath.section == 3) {
                cell.titLabel.text = @"优惠说明";
                cell.ContentLabel.text = _passValue[@"preferentialDescription"];
            }
            else {
                
                cell.titLabel.text = @"使用说明";
                cell.ContentLabel.text = _passValue[@"usedDescription"];
            }
            return cell;
        }
    }
}

#pragma mark - leftaction
- (void)leftAction:(UIButton *)btn{
    
    NSLog(@"pop回详情页");
    UIViewController *target = nil;
    for (UIViewController * controller in self.navigationController.viewControllers) {   // 遍历
        if ([controller isKindOfClass:[PreferentialBrandViewController class]]) {        // 这里判断想要跳转的页面
            target = controller;
        }  
    }
    [self.navigationController popToViewController:target animated:YES]; //跳转
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
