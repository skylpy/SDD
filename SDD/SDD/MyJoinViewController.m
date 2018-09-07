//
//  MyJoinViewController.m
//  SDD
//
//  Created by hua on 15/6/30.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "MyJoinViewController.h"

#import "MyDataController.h"
#import "BrankAuthenticationViewController.h"
#import "ChatMessageController.h"
//#import "MyCollectionViewController.h"
#import "MyReviewViewController.h"
#import "MyPublishViewController.h"
//#import "MyJoinInViewController.h"
#import "JoinInBeforeViewController.h"

#import "UIImageView+WebCache.h"
#import "CouponViewController.h"

@interface MyJoinViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    /*- ui -*/
    
    UITableView *table;
    UILabel *tips;
    UIButton *login;
    UIImageView *avatar;
    UILabel *nickname;
    UIButton *modifyUserInfo;
    
    /*- data -*/
    
    NSArray *titleAndImage;
    NSDictionary *userInfoDic;
}

@end

@implementation MyJoinViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    // 判断是否登录状态
    if([GlobalController isLogin]){
        
        // 请求用户信息
        [self requestUserInfo];
        
        tips.hidden = YES;
        login.hidden = YES;
        avatar.hidden = NO;
        nickname.hidden = NO;
        modifyUserInfo.hidden = NO;
    }
    else{
        
        tips.hidden = NO;
        login.hidden = NO;
        avatar.hidden = YES;
        nickname.hidden = YES;
        modifyUserInfo.hidden = YES;
    }
}

#pragma mark - 用户信息
- (void)requestUserInfo{
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/user/detail.do" params:nil success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSDictionary *dict = JSON[@"data"];
        
        if (![dict isEqual:[NSNull null]]) {
            
            userInfoDic = dict;
            
            [avatar sd_setImageWithURL:[NSURL URLWithString:userInfoDic[@"icon"]]];
            nickname.text = userInfoDic[@"realName"];
        }
        
        [table reloadData];
    } failure:^(NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 导航条
    [self setNav:@"我的品牌"];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    // cell标题 & 图片
    titleAndImage = @[
                      @[@"品牌商认证",
                        @"我的消息",
                        @"我的优惠券",
                        @"品牌收藏",
                        @"我的点评",
                        @"我的发布",
                        @"我的加盟"],
                      @[@"join_my_icon_branding-business",
                        @"join_my_icon_news",
                        @"join_my_icon_collect",
                        @"join_my_icon_collect",
                        @"join_my_icon_remark-on",
                        @"join_my_icon_issue",
                        @"join_my_icon_join"],
                      ];
    
    // table头
    UIView *tableHeadView = [[UIView alloc] init];
    tableHeadView.frame = CGRectMake(0, 0, viewWidth, 110);
    tableHeadView.backgroundColor = [SDDColor colorWithHexString:@"#242424"];
    
    /*-                    非登录                    -*/
    
    tips = [[UILabel alloc] init];
    tips.textColor = lgrayColor;
    tips.font = midFont;
    tips.textAlignment = NSTextAlignmentCenter;
    tips.text = @"您还没有登录哦!";
    [tableHeadView addSubview:tips];
    
    login = [UIButton buttonWithType:UIButtonTypeCustom];
    login.backgroundColor = [SDDColor colorWithHexString:@"#242424"];
    [login setTitle:@"马上登录" forState:UIControlStateNormal];
    [login setTitleColor:[SDDColor colorWithHexString:@"#008fec"] forState:UIControlStateNormal];
    [login addTarget:self action:@selector(loginIn) forControlEvents:UIControlEventTouchUpInside];
    [tableHeadView addSubview:login];
    
    /*-                    登录                    -*/
    
    avatar = [[UIImageView alloc] init];
    avatar.contentMode = UIViewContentModeScaleAspectFill;
    [tableHeadView addSubview:avatar];
    
    nickname = [[UILabel alloc] init];
    nickname.textColor = [UIColor whiteColor];
    nickname.font = largeFont;
    [tableHeadView addSubview:nickname];
    
    modifyUserInfo = [UIButton buttonWithType:UIButtonTypeCustom];
    [modifyUserInfo setBackgroundImage:[UIImage imageNamed:@"my_image_turn_right_bg"] forState:UIControlStateNormal];
    [modifyUserInfo addTarget:self action:@selector(modifyInfo) forControlEvents:UIControlEventTouchUpInside];
    [tableHeadView addSubview:modifyUserInfo];

    [tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableHeadView.mas_top).with.offset(25);
        make.left.equalTo(tableHeadView);
        make.right.equalTo(tableHeadView);
        make.height.equalTo(@13);
    }];
    
    [login mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tableHeadView);
        make.top.equalTo(tips.mas_bottom).with.offset(10);
        make.width.equalTo(@140);
        make.height.equalTo(@38);
        [Tools_F setViewlayer:login cornerRadius:19 borderWidth:1 borderColor:[SDDColor colorWithHexString:@"#008fec"]];
    }];
    
    [avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tableHeadView);
        make.left.equalTo(tableHeadView.mas_left).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(64, 64));
        [Tools_F setViewlayer:avatar cornerRadius:32 borderWidth:1 borderColor:[UIColor whiteColor]];
    }];
    
    [nickname mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tableHeadView);
        make.left.equalTo(avatar.mas_right).with.offset(12);
        make.size.mas_equalTo(CGSizeMake(viewWidth/3, 16));
    }];

    [modifyUserInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tableHeadView);
        make.right.equalTo(tableHeadView.mas_right).with.offset(-15);
        make.size.mas_equalTo(CGSizeMake(27, 27));
    }];
    
    // table
    table = [[UITableView alloc] init];
    table.backgroundColor = bgColor;
    table.bounces = NO;
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    table.tableHeaderView = tableHeadView;
    
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 7;
}

#pragma mark - 设置section 头高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

#pragma mark - 设置section 脚高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}

#pragma mark - 设置cell (tableView)
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    //重用标识符
//    static NSString *identifier = @"MyBrank";
//    //重用机制
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
    
    UITableViewCell *cell=nil;
    //重用标识符
    NSString *identifier = [NSString stringWithFormat:@"MyBrank%d%d",(int)indexPath.section,(int)indexPath.row];
    
    UILabel *label;
    if (cell == nil) {
        // 当不存在的时候用重用标识符生成
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = midFont;
        
        if (label == nil) {
            label = [[UILabel alloc] init];
            label.font = midFont;
            label.textAlignment = NSTextAlignmentRight;
        }
    }
    
    NSString *title = titleAndImage[0][indexPath.row];
    cell.textLabel.text = title;
    NSString *imageName = titleAndImage[1][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:imageName];
    
    if (indexPath.row == 0) {
        
        if ([userInfoDic[@"isBrandUser"] integerValue] == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            label.textColor = lgrayColor;
            label.text = @"未认证";
            
            [cell addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.mas_top).with.offset(10);
                make.bottom.equalTo(cell.mas_bottom).with.offset(-10);
                make.left.equalTo(cell.mas_left).with.offset(viewWidth*3/10);
                make.right.equalTo(cell.mas_right).with.offset(-30);
            }];
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
            NSLog(@"已认证");
            label.textColor = [SDDColor colorWithHexString:@"#008fec"];
            label.text = @"已认证";
            
            [cell addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.mas_top).with.offset(10);
                make.bottom.equalTo(cell.mas_bottom).with.offset(-10);
                make.left.equalTo(cell.mas_left).with.offset(viewWidth*3/10);
                make.right.equalTo(cell.mas_right).with.offset(-15);
            }];
        }
    }
    
    return cell;
}

#pragma mark - 点击cell (tableView)
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else {
        switch (indexPath.row) {
            case 0:
            {
                if ([userInfoDic[@"isBrandUser"] integerValue] == 0) {
                    
                    BrankAuthenticationViewController *baVC = [[BrankAuthenticationViewController alloc] init];
                    [self.navigationController pushViewController:baVC animated:YES];
                }
            }
                break;
            case 1:
            {
                ChatMessageController *viewController = [ChatMessageController alloc];
                self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
                [self.navigationController pushViewController:viewController animated:YES];
            }
                break;
            case 2:
            {
                CouponViewController * couVc= [[CouponViewController alloc] init];
                //self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
                [self.navigationController pushViewController:couVc animated:YES];
            }
                break;
            case 3:
            {
//                MyCollectionViewController *mcVC = [[MyCollectionViewController alloc] init];
//                self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
//                [self.navigationController pushViewController:mcVC animated:YES];
            }
                break;
            case 4:
            {
                MyReviewViewController *mrVC = [[MyReviewViewController alloc] init];
                self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
                [self.navigationController pushViewController:mrVC animated:YES];
            }
                break;
            case 5:
            {
                MyPublishViewController *mpVC = [[MyPublishViewController alloc] init];
                self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
                [self.navigationController pushViewController:mpVC animated:YES];
            }
                break;
            default:
            {
                JoinInBeforeViewController *jiVC = [[JoinInBeforeViewController alloc] init];
                self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
                [self.navigationController pushViewController:jiVC animated:YES];
            }
                break;
        }
    }
}

#pragma mark - 登录
- (void)loginIn{
    
    LoginController *loginVC = [[LoginController alloc] init];
    
    [self.navigationController pushViewController:loginVC animated:YES];
}

#pragma mark - 修改信息
- (void)modifyInfo{
    
    MyDataController *myDataVC = [[MyDataController alloc] init];
    myDataVC.userInfoDic = userInfoDic;
    
    [self.navigationController pushViewController:myDataVC animated:YES];
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
