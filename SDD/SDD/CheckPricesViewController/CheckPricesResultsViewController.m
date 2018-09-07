//
//  CheckPricesResultsViewController.m
//  SDD
//
//  Created by mac on 15/5/13.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "CheckPricesResultsViewController.h"
#import "CPResultsModel.h"
#import "CPHeaderView.h"
#import "CPBuildingInfoView.h"
#import "ResourcesModel.h"
#import "ResourcesCell.h"
#import "ResourcesFrame.h"

#import "GPDetailViewController.h"

@interface CheckPricesResultsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    CPHeaderView *_headerView;
    CPBuildingInfoView *_buildingInfoView;
    UITableView *_relatedView;
}

@property (nonatomic, assign) NSInteger houesId;
@property (nonatomic, assign) NSInteger area;
@property (nonatomic, assign) NSInteger towardsId;
@property (nonatomic, strong) NSString *houseName;

@property (nonatomic, strong) NSMutableArray *resultsData;
@property (nonatomic, strong) CPResultsModel *resultsModel;

@property (nonatomic, strong) ResourcesModel *resourcesModel;
@property (nonatomic, strong) NSMutableArray *resourcesData;

@end

@implementation CheckPricesResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadDetailData];
    
    [self addHeaderView];
    
    [self setupNaviBar];
    
    [self addBuildingInfoView];
    
    [self addHouseTabelView];
}

#pragma make -- 传值 楼盘ID
- (void)saveWithHouseName:(NSString *)houseName HouseID:(NSInteger)houesId Area:(NSInteger)area TowardsID:(NSInteger)towardsId;
{
//    NSNumber *houesIdNum = [NSNumber numberWithInteger:houesId];
//    NSNumber *areaNum = [NSNumber numberWithInteger:area];
//    NSNumber *towardsIdNum = [NSNumber numberWithInteger:towardsId];
    
    _houesId = houesId;
    _area    = area;
    _towardsId = towardsId;
    _houseName = houseName;
}

#pragma make -- 导航栏
- (void)setupNaviBar{

    SDDButton *button = [[SDDButton alloc]init];
    button.frame = CGRectMake(0, 0, viewWidth*2/3, 44);
    [button setTitle:_houseName forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftBackAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];    
}

- (void)leftBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma make -- 数据请求
- (void)loadDetailData
{

    self.resultsData = [NSMutableArray array];
    self.resourcesData = [NSMutableArray array];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(_towardsId) forKey:@"tagId"];
    [dict setObject:@(_houesId) forKey:@"houseId"];
    [dict setObject:@(_area) forKey:@"modelArea"];
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/house/priceSearch.do" params:dict success:^(id JSON) {
        
        NSLog(@"Json \n %@",JSON[@"data"]);
        _resultsModel = [[CPResultsModel alloc]initWithCPResultsDict:JSON[@"data"]];
        _headerView.resultsM = _resultsModel;
        _buildingInfoView.resultsBuild = _resultsModel;
        
        NSArray *array = JSON[@"data"][@"similarsList"];
        for (NSDictionary *dic in array) {
            _resourcesModel = [[ResourcesModel alloc]initWithResourcesDict:dic];
            [self.resourcesData addObject:_resourcesModel];
        }
        [_relatedView reloadData];
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma make -- headerView
- (void)addHeaderView
{
    CPHeaderView *headerView = [[CPHeaderView alloc]init];
    [self.view addSubview:headerView];
    headerView.resultsM = _resultsModel;
    headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, headerView.frame.size.height);
    _headerView = headerView;
}

#pragma make -- 楼盘价格
- (void)addBuildingInfoView
{
    CPBuildingInfoView *buildingInfo = [[CPBuildingInfoView alloc]init];
    [self.view addSubview:buildingInfo];
    buildingInfo.resultsBuild = _resultsModel;
    buildingInfo.frame = CGRectMake(0, CGRectGetMaxY(_headerView.frame), self.view.frame.size.width, buildingInfo.frame.size.height);
    _buildingInfoView = buildingInfo;
}

#pragma make -- 其他团购列表
- (void)addHouseTabelView
{
    
    CGFloat viewheight = CGRectGetMaxY(_buildingInfoView.frame);
    
    UIView *ViewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, viewheight, self.view.frame.size.width, 40)];
    ViewHeader.backgroundColor = [SDDColor sddbackgroundColor];
    [self.view addSubview:ViewHeader];
    
    UILabel *viewLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, 40)];
    viewLabel.text = @"团购";
    viewLabel.textColor = [SDDColor sddMiddleTextColor];
    viewLabel.textAlignment = NSTextAlignmentLeft;
    viewLabel.font = [UIFont systemFontOfSize:13];
    [ViewHeader addSubview:viewLabel];
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(ViewHeader.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(ViewHeader.frame)-60)];;
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    _relatedView = tableView;
     
}

#pragma make -- tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.resourcesData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"resultsCell";
    ResourcesCell *resourcesCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!resourcesCell) {
        resourcesCell = [[ResourcesCell alloc]init];
    }
    
    ResourcesFrame *f = [[ResourcesFrame alloc]init];
    f.resources = self.resourcesData[indexPath.row];
    resourcesCell.resourcesFrame = f;
    
    
    return resourcesCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ResourcesModel *model = self.resourcesData[indexPath.row];
    
    GPDetailViewController *gpDetailView = [[GPDetailViewController alloc] init];
    gpDetailView.activityCategoryId = @"2";
    gpDetailView.houseID = model.houseId;
    [self.navigationController pushViewController:gpDetailView animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
