//
//  IntegralRecordViewController.m
//  SDD
//
//  Created by mac on 15/12/1.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "IntegralRecordViewController.h"
#import "IntegralRecordSlide.h"
#import "IntegralRecordTableCell.h"
#import "RecordModel.h"
#import "MJRefresh.h"

@interface IntegralRecordViewController ()<UITableViewDataSource,UITableViewDelegate>
{

    NSInteger pages1;
    NSInteger pages2;
}
@property (strong, nonatomic) IntegralRecordSlide *myIssueSlideView;
@property (assign) NSInteger tabCount;

@property (retain,nonatomic)NSMutableArray * ObtainArr;
@property (retain,nonatomic)NSMutableArray * UseArr;
@end

@implementation IntegralRecordViewController

-(NSMutableArray *)ObtainArr{

    if (!_ObtainArr) {
        _ObtainArr = [[NSMutableArray alloc] init];
    }
    return _ObtainArr;
}

-(NSMutableArray *)UseArr{
    
    if (!_UseArr) {
        _UseArr = [[NSMutableArray alloc] init];
    }
    return _UseArr;
}

//获取数据
-(void)requestData{

    //积分获取
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/score/userScoreLogList.do" params:@{@"pageNumber":@1,@"pageSize":@(pages1),@"params":@{@"type":@0}} success:^(id JSON) {
        
        NSLog(@"积分获取%@",JSON);
        
        if (![JSON[@"data"] isEqual:[NSNull null]]) {
            [self.ObtainArr removeAllObjects];
            [_myIssueSlideView.GainTableView.footer endRefreshing];
            for (NSDictionary * dict in JSON[@"data"]) {
                RecordModel * model = [[RecordModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.ObtainArr addObject:model];
            }
            // 判断数据个数与请求个数
            if ([_ObtainArr count]<pages1) {
                
                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                [_myIssueSlideView.GainTableView.footer noticeNoMoreData];
            }
        }
        [self hideLoading];
        [_myIssueSlideView.GainTableView reloadData];
        [_myIssueSlideView.GainTableView.footer endRefreshing];
        [_myIssueSlideView.GainTableView.header endRefreshing];
        
    } failure:^(NSError *error) {
       
        [self hideLoading];
        [_myIssueSlideView.GainTableView.footer endRefreshing];
        [_myIssueSlideView.GainTableView.header endRefreshing];
        
    }];
    
    //积分使用
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/score/userScoreLogList.do" params:@{@"pageNumber":@1,@"pageSize":@(pages2),@"params":@{@"type":@1}} success:^(id JSON) {
        
        NSLog(@"积分使用%@",JSON);
        
        if (![JSON[@"data"] isEqual:[NSNull null]]) {
            [self.UseArr removeAllObjects];
            [_myIssueSlideView.EmployTableView.footer endRefreshing];
            
            for (NSDictionary * dict in JSON[@"data"]) {
                RecordModel * model = [[RecordModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.UseArr addObject:model];
            }
            // 判断数据个数与请求个数
            if ([_ObtainArr count]<pages2) {
                
                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                [_myIssueSlideView.EmployTableView.footer noticeNoMoreData];
            }
        }
        [self hideLoading];
        [_myIssueSlideView.EmployTableView reloadData];
        [_myIssueSlideView.EmployTableView.footer endRefreshing];
        [_myIssueSlideView.EmployTableView.header endRefreshing];
    } failure:^(NSError *error) {
        
        [self hideLoading];
        [_myIssueSlideView.EmployTableView.footer endRefreshing];
        [_myIssueSlideView.EmployTableView.header endRefreshing];
    }];
}

#pragma mark - 上拉加载
- (void)loadRefreshData{
    
    pages1 =10;
    [self showLoading:2];
    [self requestData];
    NSLog(@"上拉加载%d个",pages1);
}
#pragma mark - 上拉加载
- (void)loadRefreshData1{
    
    pages2 =10;
    [self showLoading:2];
    [self requestData];
    NSLog(@"上拉加载%d个",pages2);
}


#pragma mark - 上拉加载
- (void)loadMoreData{
    
    pages1+=10;
    [self showLoading:2];
    [self requestData];
    NSLog(@"上拉加载%d个",pages1);
}
#pragma mark - 上拉加载
- (void)loadMoreData1{
    
    pages2+=10;
    [self showLoading:2];
    [self requestData];
    NSLog(@"上拉加载%d个",pages2);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    pages1 = 10;
    pages2 = 10;
    [self setNav:@"积分记录"];
    _tabCount = 2;
    [self initSlideWithCount:_tabCount];
    [self requestData];
}
-(void) initSlideWithCount: (NSInteger) count{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    screenBound.origin.y = 0;
    
    _myIssueSlideView = [[IntegralRecordSlide alloc] initWithFrame:screenBound WithCount:count];
    
    _myIssueSlideView.GainTableView.delegate = self;
    _myIssueSlideView.GainTableView.dataSource = self;
    _myIssueSlideView.GainTableView.backgroundColor = bgColor;
    
    [_myIssueSlideView.GainTableView registerNib:[UINib nibWithNibName:@"IntegralRecordTableCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    [_myIssueSlideView.GainTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [_myIssueSlideView.GainTableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadRefreshData)];
    
    _myIssueSlideView.EmployTableView.delegate = self;
    _myIssueSlideView.EmployTableView.dataSource = self;
    _myIssueSlideView.EmployTableView.backgroundColor = bgColor;
    
    [_myIssueSlideView.EmployTableView registerNib:[UINib nibWithNibName:@"IntegralRecordTableCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    
     [_myIssueSlideView.EmployTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData1)];
    [_myIssueSlideView.EmployTableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadRefreshData1)];
    
    [self.view addSubview:_myIssueSlideView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (tableView == _myIssueSlideView.EmployTableView) {
        
        return _UseArr.count;
    }else{
    
        return _ObtainArr.count;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString * cellID = @"cellID";
    IntegralRecordTableCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[IntegralRecordTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.timeLable.textColor = lgrayColor;
    cell.futitleLable.textColor = lgrayColor;
    if (tableView == _myIssueSlideView.EmployTableView) {
        
        RecordModel * model = _UseArr[indexPath.row];
        
        cell.titleLable.text = model.title;
        
        NSString * originalString = [NSString stringWithFormat:@"%@积分",model.score];
        NSMutableAttributedString * paintString = [[NSMutableAttributedString alloc] initWithString:originalString];
        [paintString addAttribute:NSForegroundColorAttributeName
                            value:tagsColor
                            range:[originalString
                                   rangeOfString:[NSString stringWithFormat:@"%@",model.score]]];
        
        cell.futitleLable.attributedText = paintString;
        cell.timeLable.text = [Tools_F timeTransform:[model.logTime intValue] time:seconds];
        
    }else{
    
        RecordModel * model = _ObtainArr[indexPath.row];
        
        cell.titleLable.text = model.title;
        NSString * originalString = [NSString stringWithFormat:@"+%@积分",model.score];
        NSMutableAttributedString * paintString = [[NSMutableAttributedString alloc] initWithString:originalString];
        [paintString addAttribute:NSForegroundColorAttributeName
                            value:tagsColor
                            range:[originalString
                                   rangeOfString:[NSString stringWithFormat:@"+%@",model.score]]];
        
        cell.futitleLable.attributedText = paintString;
        cell.timeLable.text = [Tools_F timeTransform:[model.logTime intValue] time:seconds];
    }
    
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
