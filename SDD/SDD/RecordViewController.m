//
//  RecordViewController.m
//  SDD
//
//  Created by mac on 15/12/2.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "RecordViewController.h"
#import "RecordTableCell.h"
#import "IntegralModel.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"

@interface RecordViewController ()<UITableViewDataSource,UITableViewDelegate>
{

    NSInteger pages;
}
@property (retain,nonatomic)UITableView * table;
@property (retain,nonatomic)NSMutableArray * exchangeArr;
@end

@implementation RecordViewController

-(NSMutableArray *)exchangeArr{

    if (!_exchangeArr) {
        _exchangeArr = [[NSMutableArray alloc] init];
    }
    return _exchangeArr;
}

-(void)requestData{

    [self showLoading:2];
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/score/userConverGoodsLogList.do" params:@{@"pageNumber":@1,@"pageSize":@(pages)} success:^(id JSON) {
        
        NSLog(@"兑换记录%@",JSON);
        if (![JSON[@"data"] isEqual:[NSNull null]]) {
            [self.exchangeArr removeAllObjects];
            [_table.footer endRefreshing];
            for (NSDictionary * dict in JSON[@"data"]) {
                IntegralModel * model = [[IntegralModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.exchangeArr addObject:model];
            }
            // 判断数据个数与请求个数
            if ([_exchangeArr count]<pages) {
                
                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                [_table.footer noticeNoMoreData];
            }
        }
        [_table reloadData];
        [self hideLoading];
        [_table.footer endRefreshing];
        [_table.header endRefreshing];
        
    } failure:^(NSError *error) {
        
        [self hideLoading];
        [_table.header endRefreshing];
        [_table.footer endRefreshing];
    }];
}
//下拉刷新
-(void)DropDownRefresh{

    pages = 10;
    
    [self requestData];
}

//上拖加载更多
-(void)TheLoadMore{

    pages += 10;
    
    [self requestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    pages = 10;
    [self setNav:@"积分兑换"];
    [self createUI];
    [self requestData];
}

-(void)createUI{

    _table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _table.delegate = self;
    _table.dataSource = self;
    _table.backgroundColor = bgColor;
    [self.view addSubview:_table];
    
    [_table addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(TheLoadMore)];
    [_table addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(DropDownRefresh)];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return _exchangeArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section == 0) {
        return 0.01;
    }else{
    
        return 10;
        
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 140;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString * cellID = @"cellID";
    RecordTableCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[RecordTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    IntegralModel * model = _exchangeArr[indexPath.section];
    [cell.phoneImage sd_setImageWithURL:[NSURL URLWithString:model.defaultImage] placeholderImage:[UIImage imageNamed:@"cell_loading"]];
    cell.titleLable.text =model.goodsName;
    cell.timeLabel.text = [NSString stringWithFormat:@"兑换时间：%@",[Tools_F timeTransform:[model.logTime intValue] time:days]];//@"兑换时间：2015-11-12";
    cell.numLable.text = [NSString stringWithFormat:@"数量：%@",model.goodsQty];//@"数量：1";
    cell.IntegralLable.text = [NSString stringWithFormat:@"积分：%@",model.score];//@"积分： 1000";
    return cell;
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
