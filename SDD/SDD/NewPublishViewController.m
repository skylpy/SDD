//
//  NewPublishViewController.m
//  SDD
//
//  Created by mac on 15/9/29.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "NewPublishViewController.h"
#import "NewPublishTableCell.h"
#import "ProjectReleViewController.h"
#import "BrankPublishViewController.h"
#import "BrankAuthenticationViewController.h"
#import "BrandReleViewController.h"

@interface NewPublishViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSDictionary *itemDic;
    
    NSArray * headerIcon;
    NSArray * headerTitle;
    NSArray * suTitleArr;
    
    NSInteger isBrandUser;      // 是否品牌商
}
@property (retain,nonatomic)UITableView * tableView;

@end

@implementation NewPublishViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self requestUserInfo];
     self.tabBarController.tabBar.viewForBaselineLayout.hidden = NO;      //  显示tabar
}

#pragma mark - 用户信息
- (void)requestUserInfo{
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/user/detail.do" params:nil success:^(id JSON) {
        //            NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSDictionary *dict = JSON[@"data"];
        
        if (![dict isEqual:[NSNull null]]) {
            
            isBrandUser = [dict[@"isBrandUser"] integerValue];
//            isHouseUser = [dict[@"isHouseUser"] integerValue];
        }
    } failure:^(NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = bgColor;
    isBrandUser = 0;
    [self setUpUI];
    [self setupNav];
}
#pragma mark - 设置导航条
- (void)setupNav{
    
    // 导航条中间视图
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 0, 120, 20);
    titleLabel.text = @"选择发布类型";
    titleLabel.font = biggestFont;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
}
-(void)setUpUI
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = bgColor;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    
    headerTitle = @[@"项目发布",
                    @"品牌发布",
                    @"敬请期待"];
    headerIcon = @[@"icon_project",
                  @"icon_brand",
                   @"icon_more"];
    suTitleArr = @[@"为您更快出租商铺",
                   @"百万用户期待您的品牌",
                   @"最新发布模块正在开发中"];
    
    
    
    
    UIButton * PhoneBtn = [[UIButton alloc] init];
    //PhoneBtn.backgroundColor = [UIColor orangeColor];
    PhoneBtn.layer.cornerRadius = 30;
    PhoneBtn.clipsToBounds = YES;
    [PhoneBtn setBackgroundImage:[UIImage imageNamed:@"call"] forState:UIControlStateNormal];
    [PhoneBtn addTarget:self action:@selector(PhoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:PhoneBtn];
    [PhoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-130);
        make.centerX.equalTo(self.view);
        make.width.equalTo(@60);
         make.height.equalTo(@60);
    }];
    
    UILabel * PhoneLabel = [[UILabel alloc] init];
    PhoneLabel.text = @"想了解更多，直接拨打热线";
    PhoneLabel.textColor = lgrayColor;
    PhoneLabel.font = titleFont_15;
    PhoneLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:PhoneLabel];
    [PhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(PhoneBtn.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
    }];
}

#pragma mark -- 拨打电话
-(void)PhoneBtnClick:(UIButton *)btn
{
    NSString *telNumber = [[NSString alloc] initWithFormat:@"telprompt://%@",@"4009918829"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telNumber]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return headerIcon.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellID = @"CellID";
    NewPublishTableCell * cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        
        cell = [[NewPublishTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.iconImage.image = [UIImage imageNamed:headerIcon[indexPath.section]];
    cell.titleLabel.text = headerTitle[indexPath.section];
    cell.subtitleLabel.text = suTitleArr[indexPath.section];
    
    if (indexPath.section < 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewController;
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        viewController = loginVC;
    }
    else {
        switch (indexPath.section) {
            case 0:
            {
                ProjectReleViewController * proVc = [[ProjectReleViewController alloc] init];
                viewController = proVc;
            }
                break;
            case 1:
            {
                BrandReleViewController * BroVc = [[BrandReleViewController alloc] init];
                viewController = BroVc;
                
            }
                break;
            default:
                break;
        }
        
    }
    if (viewController) {
        
        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - alertView代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 1:
        {
            switch (alertView.tag) {
                case 101:
                {
                    BrankAuthenticationViewController *baVC = [[BrankAuthenticationViewController alloc] init];
                    
                    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
                    [self.navigationController pushViewController:baVC animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        default:
            break;
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
