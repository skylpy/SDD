//
//  MyCollectionViewController.m
//  SDD
//
//  Created by hua on 15/8/28.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "DynamicListTableViewCell.h"
#import "GroupPurchaseTableViewCell.h"
#import "CategoryContentListModel.h"
#import "HouseResourcesModel.h"
#import "TagsAndTables.h"
#import "NSString+SDD.h"

#import "DDetailViewController.h"
#import "GRDetailViewController.h"

#import "UIImageView+WebCache.h"
@interface MyCollectionViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    
    /*- ui -*/
    
    UITableView *rentTable;
    UITableView *consultTable;
    
    NoDataTips *noRent;
    NoDataTips *noConsult;
    
    /*- data -*/
    
    NSMutableArray *rents;
    NSArray *consults;
}

@end

@implementation MyCollectionViewController

#pragma mark - 获取预约
- (void)requestData{
    
    NSDictionary *param = @{@"params":@{@"activityCategoryId":@2}};
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/userCollection/houseCollection.do" params:param success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSArray *arr = JSON[@"data"];
        if (![arr isEqual:[NSNull null]]) {
            if ([arr count]>0) {
                
                noRent.hidden = YES;
                
                rents = [NSMutableArray array];
                for (NSDictionary *tempDic in arr) {
                    
                    HouseResourcesModel *model = [HouseResourcesModel hrWithDict:tempDic];
                    [rents addObject:model];
                }
            }
        }
        else {
            noRent.hidden = NO;
        }
        [rentTable reloadData];
    } failure:^(NSError *error) {
        
        NSLog(@"团租收藏列表错误 -- %@", error);
    }];
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/userCollection/dynamicCollection.do" params:@{} success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSArray *arr = JSON[@"data"];
        if (![arr isEqual:[NSNull null]]) {
            if ([arr count]>0) {
                
                noConsult.hidden = YES;
                consults = [CategoryContentListModel objectArrayWithKeyValuesArray:arr];
            }
        }
        else {

            noConsult.hidden = NO;
        }
        [consultTable reloadData];
    } failure:^(NSError *error) {
        
        NSLog(@"资讯收藏列表错误 -- %@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 导航条
    [self setNav:@"收藏"];
    // 设置内容
    [self setupUI];
    // 获取数据
    [self requestData];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    NSArray *titles = @[@"项目",@"资讯"];
    
    rentTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    rentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    rentTable.backgroundColor = bgColor;
    rentTable.delegate = self;
    rentTable.dataSource = self;
    
    consultTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    consultTable.backgroundColor = bgColor;
    consultTable.delegate = self;
    consultTable.dataSource = self;
    
    TagsAndTables *baseView = [[TagsAndTables alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-64)
                                                            titles:titles
                                                             views:@[rentTable,consultTable]];
    
    [self.view addSubview:baseView];
    
    noRent = [[NoDataTips alloc] init];
    [noRent setText:@"暂无收藏记录"
           buttonTitle:nil
             buttonTag:0
                target:nil
                action:nil];
    
    [rentTable addSubview:noRent];
    
    if (iOS_version < 7.5) {
        noRent.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    }
    else {
        [noRent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(rentTable);
            make.edges.equalTo(rentTable);
        }];
    }
    
    noConsult = [[NoDataTips alloc] init];
    [noConsult setText:@"暂无收藏记录"
         buttonTitle:nil
           buttonTag:0
              target:nil
              action:nil];
    
    [consultTable addSubview:noConsult];
    if (iOS_version < 7.5) {
        noConsult.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    }
    else {
        [noConsult mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(consultTable);
            make.edges.equalTo(consultTable);
        }];
    }
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 100;
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (tableView == rentTable) {
        return [rents count];
    }
    return [consults count];
}

#pragma mark - 设置section 头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.1;
}

#pragma mark - 设置section 脚高
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.1;
}

#pragma mark - 设置cell (tableView)
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView == rentTable) {
        //重用标识符
        static NSString *identifier = @"RENTMARK";
        //重用机制
        GroupPurchaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
        
        if(cell == nil){
            //当不存在的时候用重用标识符生成
            cell = [[GroupPurchaseTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            cell.cellType = index_gr;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
        }
        
        HouseResourcesModel *model = rents[indexPath.row];
        // 图片
        NSString *tmpStr = [NSString stringWithCurrentString:model.hr_defaultImage SizeWidth:80*2];        // 请求适应图片
        [cell.placeImage sd_setImageWithURL:[NSURL URLWithString:tmpStr] placeholderImage:[UIImage imageNamed:@"cell_loading"]];
        // 地名
        cell.placeTitle.text = [NSString stringWithFormat:@"%@",model.hr_houseName];
        // 招商对象
        cell.placeAdd.text = [NSString stringWithFormat:@"业态:%@",model.hr_planFormat];
        // 招商状态
        // 状态
        NSString *merchantsStatus;
        switch ([model.hr_merchantsStatus intValue]) {
            case 1:
            {
                merchantsStatus = @"状态: 意向登记";
            }
                break;
            case 2:
            {
                merchantsStatus = @"状态: 意向租赁";
            }
                break;
            case 3:
            {
                merchantsStatus = @"状态: 品牌转定";
            }
                break;
            case 4:
            {
                merchantsStatus = @"状态: 已开业项目";
            }
                break;
            default:
            {
                merchantsStatus = @"状态: 未定";
            }
                break;
        }
        cell.placeDiscount.text = merchantsStatus;
        // 抵价
        cell.placePrice.text = model.hr_perferentialContent;
        
        return cell;
    }
    else {
        
        //重用标识符
        static NSString *identifier = @"CONSULTMARK";
        //重用机制
        DynamicListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
        
        if(cell == nil){
            //当不存在的时候用重用标识符生成
            cell = [[DynamicListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
        }
        
        CategoryContentListModel *model = consults[indexPath.row];
        
        [cell.listImage sd_setImageWithURL:model.icon placeholderImage:[UIImage imageNamed:@"loading_l"]];
        cell.listTitle.text = model.title;
        cell.listSummary.text = model.summary;
        
        return cell;
    }
}

#pragma mark - 点击cell进入详细页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView == rentTable) {
        
        HouseResourcesModel *model = rents[indexPath.row];
        
        GRDetailViewController *grDetail = [[GRDetailViewController alloc] init];
        grDetail.activityCategoryId = @"2";
        grDetail.houseID = model.hr_houseId;
        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
        [self.navigationController pushViewController:grDetail animated:YES];
    }
    else {
        
        CategoryContentListModel *model = consults[indexPath.row];
        
        DDetailViewController *ddVC = [[DDetailViewController alloc] init];
        ddVC.dynamicId = model.dynamicId;
        
        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
        [self.navigationController pushViewController:ddVC animated:YES];
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
