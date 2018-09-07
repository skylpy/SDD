//
//  BBSActivitiesViewController.m
//  SDD
//
//  Created by hua on 15/8/31.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "BBSActivitiesViewController.h"
#import "GroupPurchaseTableViewCell.h"
#import "TagsAndTables.h"
#import "NSString+SDD.h"
#import "MyActivitiesModel.h"

#import "ActivityViewController.h"
#import "GRDetailViewController.h"
#import "HouseLookingViewController.h"

#import "UIImageView+WebCache.h"

@interface BBSActivitiesViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    
    /*- ui -*/
    
    UITableView *bbsTable;
    UITableView *projectTable;
    UITableView *houseLookingTable;
    
    NoDataTips *noBBS;
    NoDataTips *noProject;
    NoDataTips *noHouseLooking;
    
    /*- data -*/
    
    NSArray *bbs;
    NSArray *projects;
    NSArray *houseLooking;
}

@end

@implementation BBSActivitiesViewController

#pragma mark - 获取预约
- (void)requestData{
    
    // 项目活动
    NSDictionary *param = @{@"params":@{@"type":@1}};
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/userReserve/activityList.do" params:param success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSArray *arr = JSON[@"data"];
        if (![arr isEqual:[NSNull null]]) {
            if ([arr count]>0) {
                
                noProject.hidden = YES;
                projects = [MyActivitiesModel objectArrayWithKeyValuesArray:arr];
            }
        }
        else {
            
            noProject.hidden = NO;
        }
        [projectTable reloadData];
    } failure:^(NSError *error) {
        
        NSLog(@"资讯收藏列表错误 -- %@", error);
    }];
    
    // 项目考察团
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/userReserve/showingsList.do" params:@{} success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSArray *arr = JSON[@"data"];
        if (![arr isEqual:[NSNull null]]) {
            if ([arr count]>0) {
                
                noHouseLooking.hidden = YES;
                houseLooking = [MyActivitiesModel objectArrayWithKeyValuesArray:arr];
            }
        }
        else {
            
            noHouseLooking.hidden = NO;
        }
        [houseLookingTable reloadData];
    } failure:^(NSError *error) {
        
        NSLog(@"资讯收藏列表错误 -- %@", error);
    }];
    
    // 主题论坛
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/dforums/mySignupForumsList.do" params:@{} success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSArray *arr = JSON[@"data"];
        if (![arr isEqual:[NSNull null]]) {
            if ([arr count]>0) {
                
                noBBS.hidden = YES;
                bbs = [MyActivitiesModel objectArrayWithKeyValuesArray:arr];
            }
        }
        else {
            
            noBBS.hidden = NO;
        }
        [bbsTable reloadData];
    } failure:^(NSError *error) {
        
        NSLog(@"资讯收藏列表错误 -- %@", error);
    }];   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 导航条
    [self setNav:@"论坛/活动"];
    // 设置内容
    [self setupUI];
    // 获取数据
    [self requestData];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    NSArray *titles = @[@"主题论坛",@"项目活动",@"项目考察团"];
    
    bbsTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    bbsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    bbsTable.backgroundColor = bgColor;
    bbsTable.delegate = self;
    bbsTable.dataSource = self;
    
    projectTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    projectTable.backgroundColor = bgColor;
    projectTable.delegate = self;
    projectTable.dataSource = self;
    
    houseLookingTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    houseLookingTable.backgroundColor = bgColor;
    houseLookingTable.delegate = self;
    houseLookingTable.dataSource = self;
    
    TagsAndTables *baseView = [[TagsAndTables alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-64)
                                                            titles:titles
                                                             views:@[bbsTable,projectTable,houseLookingTable]];
    
    [self.view addSubview:baseView];
    
    noBBS = [[NoDataTips alloc] init];
    [noBBS setText:@"您当前还未报名活动，赶快去报名吧~"
       buttonTitle:@"马上报名"
         buttonTag:100
            target:self
            action:@selector(jumpToApply:)];
    
    [bbsTable addSubview:noBBS];
    if (iOS_version < 7.5) {
        noBBS.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    }
    else {
        [noBBS mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(bbsTable);
            make.edges.equalTo(bbsTable);
        }];
    }
    
    noProject = [[NoDataTips alloc] init];
    [noProject setText:@"您当前还未报名活动，赶快去报名吧~"
           buttonTitle:@"马上报名"
             buttonTag:101
                target:self
                action:@selector(jumpToApply:)];
    
    [projectTable addSubview:noProject];
    if (iOS_version < 7.5) {
        noProject.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    }
    else {
        [noProject mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(projectTable);
            make.edges.equalTo(projectTable);
        }];
    }
    
    noHouseLooking = [[NoDataTips alloc] init];
    [noHouseLooking setText:@"您当前还未报名活动，赶快去报名吧~"
                buttonTitle:@"马上报名"
                  buttonTag:102
                     target:self
                     action:@selector(jumpToApply:)];
    
    [houseLookingTable addSubview:noHouseLooking];
    if (iOS_version < 7.5) {
        noHouseLooking.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    }
    else {
        [noHouseLooking mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(houseLookingTable);
            make.edges.equalTo(houseLookingTable);
        }];
    }
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

#pragma mark - 设置section 头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}

#pragma mark - 设置section 脚高
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView == bbsTable) {
        return [bbs count];
    }
    else if (tableView == projectTable){
        return [projects count];
    }
    else {
        return [houseLooking count];
    }
}

#pragma mark - 设置cell (tableView)
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //重用标识符
    static NSString *identifier = @"HOUSELOOKINGMARK";
    //重用机制
    GroupPurchaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
    
    if(cell == nil){
        // 当不存在的时候用重用标识符生成
        cell = [[GroupPurchaseTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.cellType = personal_activities;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
    }
    
    MyActivitiesModel *model;
    if (tableView == bbsTable) {
        
        model = bbs[indexPath.section];
    }
    else if (tableView == projectTable){
        
        model = projects[indexPath.section];
    }
    else {
        
        model = houseLooking[indexPath.section];
    }
    
    // 图片
    [cell.placeImage sd_setImageWithURL:model.defaultImage placeholderImage:[UIImage imageNamed:@"cell_loading"]];
    // 标题
    cell.placeTitle.text = [NSString stringWithFormat:@"%@",model.showingsTitle];
    // 活动时间
    cell.placeAdd.text = [NSString stringWithFormat:@"活动时间:%@",[Tools_F timeTransform:model.addTime time:days]];
    // 活动地点
    cell.placeDiscount.text = [NSString stringWithFormat:@"活动地点%@",model.address];
    
    if (model.addTime > model.showingsEndtime) {
        cell.statusLabel.enabled = NO;
    }
    else {
        cell.statusLabel.enabled = YES;
    }
    
    return cell;
}

#pragma mark - 点击cell进入详细页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyActivitiesModel *model;
    if (tableView == bbsTable) {
        
    }
    else if (tableView == projectTable){
        
    }
    else {
        
        model = houseLooking[indexPath.section];
        
        HouseLookingViewController *houseLookingVC = [[HouseLookingViewController alloc] init];
        
        houseLookingVC.houseShowingsId = [NSString stringWithFormat:@"%d",model.houseShowingsId];
        houseLookingVC.hkTitle = model.houseName;
        houseLookingVC.isApply = YES;
        [self.navigationController pushViewController:houseLookingVC animated:YES];
    }
}

- (void)jumpToApply:(UIButton *)btn{
    
    ActivityViewController * actVc = [[ActivityViewController alloc] init];
    
    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;
    [self.navigationController pushViewController:actVc animated:YES];
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
