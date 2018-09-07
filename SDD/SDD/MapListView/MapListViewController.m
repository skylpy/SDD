//
//  MapListViewController.m
//  SDD
//
//  Created by mac on 15/11/3.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "MapListViewController.h"
#import "MapListCell.h"
#import "NSString+SDD.h"
#import "UIImageView+WebCache.h"
#import "GRDetailViewController.h"
#import "GroupPurchaseTableViewCell.h"
#import "MapListMenu.h"
@interface MapListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableView;
@end

@implementation MapListViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    [self createMainView];
    // Do any additional setup after loading the view.
}
//表格视图懒加载
-(UITableView *)tableView{
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 200) style: UITableViewStylePlain];
        
        [self.view addSubview:_tableView];
    }
    
    return _tableView;
}


- (void)createMainView{
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
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
    
    

    
    NSDictionary *dic = self.dataArray[indexPath.row];
    
  
    
    NSString *imageStr = dic[@"defaultImage"];
    //    NSString *tmpStr = [NSString st]
    NSString *tmpStr = [NSString stringWithCurrentString:imageStr SizeWidth:80*2];        // 请求适应图片
    [cell.placeImage sd_setImageWithURL:[NSURL URLWithString:tmpStr] placeholderImage:[UIImage imageNamed:@"cell_loading"]];
    // 地名
    cell.placeTitle.text = [NSString stringWithFormat:@"%@",dic[@"houseName"]];
    
    
    // 招商对象
    cell.placeAdd.text = [NSString stringWithFormat:@"业态:%@",dic[@"planFormat"]];
    // 招商状态
    // 状态
    NSString *merchantsStatus;
    switch ([dic[@"merchantsStatus"] intValue]) {
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
    
    if ([dic[@"activityCategoryId"] integerValue] != 2 ) {
        
        cell.cellType = index_gr_noPreferential;
        // 抵价
        cell.placePrice.text = [NSString stringWithFormat:@"建筑面积:%@万m²",dic[@"buildingArea"]];
    }
    else {
        cell.cellType = index_gr;
        // 抵价
        cell.placePrice.text = cell.placePrice.text = dic[@"rentPreferentialContent"];
        
        NSLog(@"%@",dic[@"rentContent"]);
    }

    
    

    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GRDetailViewController *grDetail = [[GRDetailViewController alloc] init];
    
     NSDictionary *dic = self.dataArray[indexPath.row];
    grDetail.activityCategoryId = dic[@"activityCategoryId"];
    grDetail.houseID = dic[@"houseId"];
    grDetail.deliverInt = 1;
    [self.navigationController pushViewController:grDetail animated:YES];
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:grDetail];
    nvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nvc animated:YES completion:nil];

//    [self.navigationController pushViewController:nvc animated:YES];
    
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
