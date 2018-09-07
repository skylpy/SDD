//
//  EvaluateManagerController.m
//  SDD
//  评价管理
//  Created by Cola on 15/4/16.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "EvaluateManagerController.h"
#import "GroupPurchaseTableViewCell.h"
#import "HistoryModel.h"

#import "GPDetailViewController.h"
#import "GRDetailViewController.h"
#import "HRDetailViewController.h"

#import "CWStarRateView.h"
#import "UIImageView+WebCache.h"
#import "Tools_F.h"

@interface EvaluateManagerController ()<UITableViewDelegate,UITableViewDataSource>{
    
    // 评价管理
    UITableView *table;
}

// 团购列表
@property (nonatomic, strong) NSMutableArray *emArr;

@end

@implementation EvaluateManagerController

- (NSMutableArray *)emArr{
    if (!_emArr) {
        _emArr = [[NSMutableArray alloc]init];
    }
    return _emArr;
}
#pragma mark - 请求数据
- (void)requestDataPage{
    
    NSDictionary *param = @{};
    NSString *urlString = [SDD_MainURL stringByAppendingString:@"/userComment/myComment.do"];              // 拼接主路径和请求内容成完整url
    
    [self sendRequest:param url:urlString];
    [self showLoading:1];
}
- (void)onSuccess:(AFHTTPRequestOperation *)operation context:(id)responseObject{
    
    [self hideLoading];
    NSDictionary *dict = responseObject;
    NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
    if (![dict[@"data"] isEqual:[NSNull null]]) {
        
        [_emArr removeAllObjects];
        for (NSDictionary *tempDict in dict[@"data"]) {
            
            HistoryModel *model = [[HistoryModel alloc] init];
            model.h_activityCategoryId = tempDict[@"activityCategoryId"];
            model.h_address = tempDict[@"address"];
            model.h_defaultImage = tempDict[@"defaultImage"];
            model.h_houseName = tempDict[@"houseName"];
            model.h_houseId = tempDict[@"houseId"];
            model.h_avgScore = tempDict[@"avgScore"];
            model.h_price = tempDict[@"price"];
            model.h_regionName = tempDict[@"regionName"];
            
            [self.emArr addObject:model];
        }
        
        [table reloadData];
    }
}

- (void)onFailure:(AFHTTPRequestOperation *)operation error:(NSError *)error{
    
    [self hideLoading];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNav:NSLocalizedString(@"evaluateManager", @"")];
    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;
    
    // 数据请求
    [self requestDataPage];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    // 内容
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-44) style:UITableViewStyleGrouped];
    table.backgroundColor = bgColor;
    table.delegate = self;
    table.dataSource = self;
    
    [self.view addSubview:table];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

#pragma mark -
#pragma mark UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_emArr count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - UITableView DataSource

#pragma mark - 设置cell (tableView)
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //重用标识符
    static NSString *identifier = @"CELLMARK";
    //重用机制
    GroupPurchaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
    CWStarRateView *rateView;
    if(cell == nil){
        //当不存在的时候用重用标识符生成
        cell = [[GroupPurchaseTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
        
        cell.cellType = index_gr;
        cell.privateLabel.hidden = YES;
        // 星星
        rateView = [[CWStarRateView alloc]initWithFrame:CGRectMake(0, 0, viewWidth/4-10, 12) numberOfStars:5];
        rateView.userInteractionEnabled = NO;
        rateView.hasAnimation = YES;
        [cell addSubview:rateView];
        [rateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.placeTitle.mas_bottom).offset(5);
            make.left.equalTo(cell.placeImage.mas_right).offset(10);
            make.size.mas_equalTo(CGSizeMake(viewWidth/4-10, 15));
        }];
        
    }
    
    HistoryModel *model = _emArr[indexPath.row];
    
    // 图片
    [cell.placeImage sd_setImageWithURL:[NSURL URLWithString:model.h_defaultImage] placeholderImage:[UIImage imageNamed:@"loading_l" ]];
    // 地名
    cell.placeTitle.text = model.h_houseName;
    // 地址
    //    cell.placeAdd.text = model.h_address;
    // 抵价
    cell.placeDiscount.text = model.h_regionName;
    // 得分
    rateView.scorePercent = [model.h_avgScore floatValue]/5;
    
    return cell;
}

#pragma mark - 设置section 头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 1;
}

#pragma mark - 设置section 脚高
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
}

#pragma mark - 点击cell进入详细页面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HistoryModel *model = _emArr[indexPath.row];
    
    switch ([model.h_activityCategoryId integerValue]) {
        case 1:
        {
            GPDetailViewController *gpDetail = [[GPDetailViewController alloc] init];
            gpDetail.activityCategoryId = @"1";
            gpDetail.houseID = model.h_houseId;
            [self.navigationController pushViewController:gpDetail animated:YES];
        }
            break;
        case 2:
        {
            GRDetailViewController *grDetail = [[GRDetailViewController alloc] init];
            grDetail.activityCategoryId = @"2";
            grDetail.houseID = model.h_houseId;
            [self.navigationController pushViewController:grDetail animated:YES];
        }
            break;
        case 3:
        {
            HRDetailViewController *hrDetail = [[HRDetailViewController alloc] init];
            hrDetail.activityCategoryId = @"3";
            hrDetail.hrTitle = model.h_houseName;
            hrDetail.houseID = model.h_houseId;
            [self.navigationController pushViewController:hrDetail animated:YES];
        }
            break;
            
        default:
            break;
    }
}
@end
