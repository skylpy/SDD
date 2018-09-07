//
//  PurchaseShopViewController.m
//  SDD
//
//  Created by mac on 15/12/28.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "PurchaseShopViewController.h"
#import "GroupPurchaseTableViewCell.h"
#import "ShopForDetailsViewController.h"
#import "LPYModelTool.h"
#import "PurchaseModel.h"
#import "UIImageView+EMWebCache.h"
#import "MJRefresh.h"

@interface PurchaseShopViewController ()<UITableViewDataSource,UITableViewDelegate>{

    /*- data -*/
    NSInteger pages;
    
    UITableView * table;
}

@property (retain,nonatomic)NSMutableArray * dataArray;
@end

@implementation PurchaseShopViewController

-(NSMutableArray *)dataArray{

    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

//请求网络数据
-(void)requestData{

    [self showLoading:2];
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/houseStore/list.do" params:@{@"pageNumber":@1,@"pageSize":@(pages),@"params":@{@"houseId":@([_houseID integerValue])}} success:^(id JSON) {
        
        NSLog(@"%@",JSON);
        if (![JSON[@"data"] isEqual:[NSNull null]]) {
            
            [table.footer endRefreshing];
            [self.dataArray removeAllObjects];
            for (NSDictionary * dict in JSON[@"data"]) {

                PurchaseModel * model = [PurchaseModel PurchaseDict:dict];
                [self.dataArray addObject:model];
            }
            if ([_dataArray count] < pages) {
                
                [table.footer noticeNoMoreData];
            }
        }
        [table.footer endRefreshing];
        [self hideLoading];
        [table reloadData];
        
    } failure:^(NSError *error) {
        
        [table.footer endRefreshing];
        [self hideLoading];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    
    pages = 10;
    [self setNav:@"铺位招商"];
    [self setupUI];
    [self requestData];
}
#pragma mark - 上拉加载
- (void)loadMoreData{
    
    pages+=10;
    
    [self requestData];
    NSLog(@"上拉加载%ld个",pages);
}
-(void)setupUI{

    table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    [table addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    UIView * footer = [[UIView alloc] init];
    table.tableFooterView = footer;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    //重用标识符
    static NSString *identifier = @"CELLMARK";
    //重用机制
    GroupPurchaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
    
    if(cell == nil){
        //当不存在的时候用重用标识符生成
        cell = [[GroupPurchaseTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
    }
    cell.cellType = perchase_shop;
    PurchaseModel *model = _dataArray[indexPath.row];
    
    //NSString *tmpStr = [NSString stringWithCurrentString:model.hr_defaultImage SizeWidth:160];
    // 图片
    [cell.placeImage sd_setImageWithURL:[NSURL URLWithString:model.defaultImage] placeholderImage:[UIImage imageNamed:@"loading_l"]];//.image = [UIImage imageNamed:@"loading_l"];
    // 地名
    cell.placeTitle.text = model.storeName;
    // 招商对象
    cell.placeAdd.text = [NSString stringWithFormat:@"业态:%@",model.categoryName];
    // 招商状态

    cell.placeDiscount.text = [NSString stringWithFormat:@"面积: %@",model.storeArea];//@"面积: 品牌转定";
    cell.placePrice.text = [NSString stringWithFormat:@"铺位编号: %@",model.storeSn];//@"铺位编号: 品牌转定";
    cell.placePrice.textColor = lgrayColor;

    NSString * surroundingString1 = [NSString stringWithFormat:@"%@元/㎡/月",model.storeRentPrice];
    NSMutableAttributedString * surroundString2 = [[NSMutableAttributedString alloc] initWithString:surroundingString1];
    [surroundString2 addAttribute:NSForegroundColorAttributeName
                            value:tagsColor
                            range:[[NSString stringWithFormat:@"%@",model.storeRentPrice]
                                   rangeOfString:[NSString stringWithFormat:@"%@",model.storeRentPrice]]];
    
     cell.rentalLabel.attributedText = surroundString2;
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    PurchaseModel * model = _dataArray[indexPath.row];
    ShopForDetailsViewController * sdVc = [[ShopForDetailsViewController alloc] init];
    sdVc.storeId = model.storeId;
    sdVc.houseID = _houseID;
    sdVc.canAppointmentSign = _canAppointmentSign;
    sdVc.hr_activityCategoryId = _hr_activityCategoryId;
    sdVc.type = _type;
    [self.navigationController pushViewController:sdVc animated:YES];
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
