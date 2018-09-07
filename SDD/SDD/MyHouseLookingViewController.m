//
//  MyHouseLookingViewController.m
//  SDD
//
//  Created by hua on 15/7/29.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "MyHouseLookingViewController.h"
#import "ReservationModel.h"
#import "GroupPurchaseTableViewCell.h"

#import "HKDetailViewController.h"

#import "UIImageView+WebCache.h"

@interface MyHouseLookingViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView *table;
}

// 列表
@property (nonatomic, strong) NSMutableArray *reservationArr;

@end

@implementation MyHouseLookingViewController

- (NSMutableArray *)reservationArr{
    if (!_reservationArr) {
        _reservationArr = [[NSMutableArray alloc]init];
    }
    return _reservationArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNav:@"项目考察团"];
    
    // 请求数据
    NSDictionary *param = @{};
    NSString *urlString = [SDD_MainURL stringByAppendingString:@"/userReserve/showingsList.do"];              // 拼接主路径和请求内容成完整url
    
    [self sendRequest:param url:urlString];
    [self showLoading:1];
    // 设置ui
    [self setupUI];
}


- (void)setupUI{
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight) style:UITableViewStyleGrouped];
    table.backgroundColor = [UIColor whiteColor];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
}

- (void)onSuccess:(AFHTTPRequestOperation *)operation context:(id)responseObject{
    
    [self hideLoading];
    NSDictionary *dict = responseObject;
//    NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
    if (![dict[@"data"] isEqual:[NSNull null]]) {
        
        [_reservationArr removeAllObjects];
        for (NSDictionary *tempDict in dict[@"data"]) {
            
            ReservationModel *model = [[ReservationModel alloc] init];
            model.r_activityCategoryId = tempDict[@"activityCategoryId"];
            model.r_addTime = tempDict[@"addTime"];
            model.r_defaultImage = tempDict[@"defaultImage"];
            model.r_houseId = tempDict[@"houseId"];
            model.r_houseName = tempDict[@"houseName"];
            model.r_latitude = tempDict[@"latitude"];
            model.r_longitude = tempDict[@"longitude"];
            model.r_applyPeopleQty = tempDict[@"applyPeopleQty"];
            model.r_price = tempDict[@"price"];
            model.r_showingsEndtime = tempDict[@"showingsEndtime"];
            model.r_showingsLineIntroduction = tempDict[@"showingsLineIntroduction"];
            model.r_showingsMaxPreferential = tempDict[@"showingsMaxPreferential"];
            
            [self.reservationArr addObject:model];
        }
        
        [table reloadData];
    }
}

- (void)onFailure:(AFHTTPRequestOperation *)operation error:(NSError *)error{
    
    [self hideLoading];
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

#pragma mark - 设置行数 (tableView)
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_reservationArr count];
}

#pragma mark - 设置section 头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

#pragma mark - 设置section 脚高
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

#pragma mark - 设置cell (tableView)
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //重用标识符
    static NSString *identifier = @"CELLMARK";
    //重用机制
    GroupPurchaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
    
    if(cell == nil){
        //当不存在的时候用重用标识符生成
        cell = [[GroupPurchaseTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.cellType = index_gr;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
    }
    
    ReservationModel *model = _reservationArr[indexPath.row];
    // 图片
    [cell.placeImage sd_setImageWithURL:[NSURL URLWithString:model.r_defaultImage] placeholderImage:[UIImage imageNamed:@"loading_l" ]];
    // 楼盘名
    cell.placeTitle.text = model.r_houseName;
    // 时间
    cell.placeAdd.text = [Tools_F timeTransform:[model.r_addTime intValue] time:days];
    
    return cell;
}

#pragma mark - 点击cell进入详细页面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ReservationModel *model = _reservationArr[indexPath.row];
    
    HKDetailViewController *hkdVC = [[HKDetailViewController alloc] init];
    hkdVC.model = model;
    
    [self.navigationController pushViewController:hkdVC animated:YES];
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
