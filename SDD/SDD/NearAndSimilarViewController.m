//
//  NearAndSimilarViewController.m
//  商多多
//
//  Created by hua on 15/4/9.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "NearAndSimilarViewController.h"
#import "HouseResourcesModel.h"
#import "GroupPurchaseTableViewCell.h"
#import "NSString+SDD.h"

#import "GPDetailViewController.h"
#import "GRDetailViewController.h"
#import "HRDetailViewController.h"
#import "GRDetailNViewController.h"

#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "Tools_F.h"

@interface NearAndSimilarViewController ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    UITableView *table;
}

// 网络请求
@property (nonatomic, strong) AFHTTPRequestOperationManager *httpManager;
// 房源列表
@property (nonatomic, strong) NSMutableArray *houses_DataArr;

@end

@implementation NearAndSimilarViewController

- (AFHTTPRequestOperationManager *)httpManager
{
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

- (NSMutableArray *)houses_DataArr{
    if (!_houses_DataArr) {
        _houses_DataArr = [[NSMutableArray alloc]init];
    }
    return _houses_DataArr;
}

#pragma mark - 请求数据
- (void)requestData{
    
    // 请求参数
    NSDictionary *dic = @{@"params":@{@"houseId":_houseID}};
    
    NSString *urlString;

    switch (_recommendType) {
        case similars:
        {
            urlString = [SDD_MainURL stringByAppendingString:@"/house/similars.do"];                // 拼接主路径和请求内容成完整url
        }
            break;
        case near:
        {
            urlString = [SDD_MainURL stringByAppendingString:@"/house/surroundings.do"];            // 拼接主路径和请求内容成完整url
        }
            break;
        case buy:
        {
            urlString = [SDD_MainURL stringByAppendingString:@"/house/recommendBuyList.do"];        // 拼接主路径和请求内容成完整url
        }
            break;
        case rent:
        {
            urlString = [SDD_MainURL stringByAppendingString:@"/house/recommendRentList.do"];       // 拼接主路径和请求内容成完整url
        }
            break;
    }
    
    [self.httpManager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = responseObject;
        NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
        if (![dict[@"data"] isEqual:[NSNull null]]) {
            
            [_houses_DataArr removeAllObjects];
            for (NSDictionary *tempDic in dict[@"data"]) {
                
                HouseResourcesModel *model = [HouseResourcesModel hrWithDict:tempDic];
                [self.houses_DataArr addObject:model];
            }
            [table reloadData];

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
    
    // 请求数据
    [self requestData];
    // 导航条
    [self setupNav];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置导航条
- (void)setupNav{
    
    SDDButton *button = [[SDDButton alloc]init];
    button.frame = CGRectMake(0, 0, viewWidth*2/3, 44);
    [button setTitle:_nasTitle forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

#pragma mark - 设置内容
- (void)setupUI{
 
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-15) style:UITableViewStyleGrouped];
    table.backgroundColor = setColor(240, 240, 240, 1);
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

#pragma mark - 设置行数 (tableView)
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_houses_DataArr count];
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
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
    }
    
    HouseResourcesModel *model = _houses_DataArr[indexPath.row];
    
    if ([model.hr_activityCategoryId integerValue] != 2) {
        
        cell.cellType = index_gr_noPreferential;
        // 抵价
        cell.placePrice.text = [NSString stringWithFormat:@"建筑面积:%@万m²",model.hr_buildingArea];
    }
    else {
        cell.cellType = index_gr;
        // 抵价
        cell.placePrice.text = model.hr_perferentialContent;
    }
    
    NSString *tmpStr = [NSString stringWithCurrentString:model.hr_defaultImage SizeWidth:160];
    // 图片
    [cell.placeImage sd_setImageWithURL:[NSURL URLWithString:tmpStr] placeholderImage:[UIImage imageNamed:@"loading_l" ]];
    // 地名
    cell.placeTitle.text = model.hr_houseName;
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
    
    return cell;
}

#pragma mark - 点击cell进入详细页面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HouseResourcesModel *model = _houses_DataArr[indexPath.row];
    
    if ([model.hr_activityCategoryId integerValue] != 2) {
        
        GRDetailNViewController *grDetail = [[GRDetailNViewController alloc] init];
        grDetail.activityCategoryId = @"2";
        grDetail.houseID = model.hr_houseId;
        [self.navigationController pushViewController:grDetail animated:YES];
    }
    else {
        
        GRDetailViewController *grDetail = [[GRDetailViewController alloc] init];
        grDetail.activityCategoryId = @"2";
        grDetail.houseID = model.hr_houseId;
        [self.navigationController pushViewController:grDetail animated:YES];
    }
//    switch (_recommendType) {
//        case similars:
//        {
//            GPDetailViewController *gpDetail = [[GPDetailViewController alloc] init];
//            gpDetail.activityCategoryId = @"1";
//            gpDetail.houseID = model.hr_houseId;
//            [self.navigationController pushViewController:gpDetail animated:YES];
//        }
//            break;
//        case near:
//        {
//            GPDetailViewController *gpDetail = [[GPDetailViewController alloc] init];
//            gpDetail.activityCategoryId = @"1";
//            gpDetail.houseID = model.hr_houseId;
//            [self.navigationController pushViewController:gpDetail animated:YES];
//        }
//            break;
//        case buy:
//        {
//            GPDetailViewController *gpDetail = [[GPDetailViewController alloc] init];
//            gpDetail.activityCategoryId = @"1";
//            gpDetail.houseID = model.hr_houseId;
//            [self.navigationController pushViewController:gpDetail animated:YES];
//        }
//            break;
//        case rent:
//        {
//            GRDetailViewController *grDetail = [[GRDetailViewController alloc] init];
//            grDetail.activityCategoryId = @"2";
//            grDetail.houseID = model.hr_houseId;
//            [self.navigationController pushViewController:grDetail animated:YES];
//        }
//            break;
//    }
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
