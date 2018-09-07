//
//  ApplySuccessViewController.m
//  SDD
//
//  Created by hua on 15/4/15.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ApplySuccessViewController.h"

#import "GRDetailViewController.h"
#import "BBSActivitiesViewController.h"

@interface ApplySuccessViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    /*- ui -*/
    
    UITableView *table;
    
    /*- data -*/
    
    NSArray *contentTitle;          /**< 表格标题 */
}

@end

@implementation ApplySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 导航条
    [self setNav:@""];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置导航条
- (void)setupNav{
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"报名";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

#pragma mark - 设置内容
- (void)setupUI{
    
    contentTitle = @[@"线路介绍:",@"独享优惠:",@"所属区域:",@"报名人数:",
                     @"姓名:",@"行业:",@"品牌:"];
    
    // table
    table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    table.backgroundColor = bgColor;
    table.delegate = self;
    table.dataSource = self;
    
    [self.view addSubview:table];
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // head
    UIView *headView = [[UIView alloc] init];
    headView.frame = CGRectMake(0, 0, viewWidth, 115);
    headView.backgroundColor = [UIColor whiteColor];
    
    // 恭喜标题
    UILabel *applyTitle = [[UILabel alloc] init];
    applyTitle.frame = CGRectMake(0, 0, viewWidth, 30);
    applyTitle.font = [UIFont systemFontOfSize:25];
    applyTitle.textColor = mainTitleColor;
    applyTitle.text = @"恭喜您报名成功";
    [applyTitle sizeToFit];
    applyTitle.center = CGPointMake(viewWidth/2, 35);
    [headView addSubview:applyTitle];
    
    // 图标
    UIImageView *successIcon = [[UIImageView alloc] init];
    successIcon.frame = CGRectMake(CGRectGetMinX(applyTitle.frame)-35, applyTitle.frame.origin.y+2.5, 25, 25);
    successIcon.image = [UIImage imageNamed:@"icon_ok_blue"];
    [headView addSubview:successIcon];
    
    // 详细
    UILabel *content = [[UILabel alloc] init];
    content.frame = CGRectMake(50, CGRectGetMaxY(successIcon.frame)+10, viewWidth-100, 50);
    content.textColor = lgrayColor;
    content.font = midFont;
    content.text = @"恭喜,您成功报名了看房团活动,可在“我的--活动”中查看详情情况";
    content.numberOfLines = 2;
    [headView addSubview:content];
    
    table.tableHeaderView = headView;
    
    // footer
    UIView *footer_bg = [[UIView alloc] init];
    footer_bg.frame = CGRectMake(0, 0, viewWidth, 65);
    footer_bg.backgroundColor = [UIColor whiteColor];
    
    // 报名按钮
    ConfirmButton *inMyActivityButton = [[ConfirmButton alloc] initWithFrame:CGRectMake(20, 10, viewWidth - 40, 45)
                                                                title:@"进入我的活动"
                                                               target:self
                                                               action:@selector(toMyActivity:)];
    inMyActivityButton.enabled = YES;
    [footer_bg addSubview:inMyActivityButton];
    
    table.tableFooterView = footer_bg;
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 8;
}

#pragma mark - 设置Sections数 (tableView)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

#pragma mark - 设置section 头高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

#pragma mark - 设置section 脚高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

#pragma mark - 设置cell (tableView)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //重用标识符
    static NSString *identifier = @"Getdiscount";
    //重用机制
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
    
    if (cell == nil) {
        
        // 当不存在的时候用重用标识符生成
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;                // 设置选中背景色不变
        
        cell.textLabel.font = midFont;
        cell.textLabel.textColor = mainTitleColor;
    }
    
    
    if (indexPath.row == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@考察团",_hkTitle];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    else {
        cell.textLabel.textAlignment = NSTextAlignmentLeft;

        NSString *originalStr = [NSString stringWithFormat:@"%@%@",contentTitle[indexPath.row-1],_hkInfo[indexPath.row-1]];
        NSMutableAttributedString *paintStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
        [paintStr addAttributes:@{NSForegroundColorAttributeName: lgrayColor} range:[originalStr rangeOfString:_hkInfo[indexPath.row-1]]];
        cell.textLabel.attributedText = paintStr;
    }
    
    return cell;
}

#pragma mark - 我的活动
- (void)toMyActivity:(UIButton *)btn{
    
    BBSActivitiesViewController *bbsaVC = [[BBSActivitiesViewController alloc] init];
    
    [self.navigationController pushViewController:bbsaVC animated:YES];
}

#pragma mark - leftaction
- (void)leftAction:(UIButton *)btn{
    
    NSLog(@"pop回详情页");
//    UIViewController *target = nil;
//    for (UIViewController * controller in self.navigationController.viewControllers) {   // 遍历
//        if ([controller isKindOfClass:[GRDetailViewController class]]) {                 // 这里判断想要跳转的页面
//            target = controller;
//        }
//    }
//    [self.navigationController popToViewController:target animated:YES]; //跳转
    
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
