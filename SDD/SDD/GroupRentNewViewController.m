//
//  GroupRentNewViewController.m
//  SDD
//  集成新项目招商和地图在内的
//  Created by mac on 15/10/28.
//  Copyright (c) 2015年 jofly. All rights reserved.
//
#define nav_titleWidth (viewHeight == 736? 110:viewHeight == 667? 80:72)

#import "GroupRentNewViewController.h"
#import "GroupPurchaseTableViewCell.h"
#import "HouseResourcesModel.h"
#import "FindBrankModel.h"
#import "AreaSelectView.h"

#import "SearchViewController.h"
#import "GRDetailViewController.h"
#import "GRDetailNViewController.h"

#import "JoinPDropDownMenu.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "NSString+SDD.h"


//地图
#import "MMapModel.h"
#import "JoinMapModel.h"

#import "TabButton.h"


#import "GPDetailViewController.h"
#import "GRDetailViewController.h"
#import "HRDetailViewController.h"
#import "JoinDetailViewController.h"

#import "BMapKit.h"


@interface GroupRentNewViewController ()<UITableViewDataSource,UITableViewDelegate,DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,BMKMapViewDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate>{
    
    /*- ui -*/
    
    UITableView *table;
    JoinPDropDownMenu *dropMenu;
    UIView *whiteBlock;            /**< 底部白条 */
    
    /*- data -*/
    
    NSInteger pages;
    
    // 筛选维度
    NSArray *otherTitles;                        /**< 更多的标题 */
    NSArray *project;                            /**< 项目状态 */
    NSArray *smartSorting;                       /**< 智能排序 */
    
    // 对应ID
    NSInteger type;                              /**< 是否优惠项目 */
    NSInteger status;                            /**< 项目状态 */
    NSInteger typeCategoryID;                    /**< 类型 */
    NSInteger projectNatureCategoryId;           /**< 项目性质 */
    NSInteger smartSortingId;                    /**< 智能排序 */
    NSInteger industryCategoryID;                /**< 行业类别 */
    
    UIView * ProjectView;//项目视图
    UIView * MapView;//地图视图
    
    //NSInteger control;//控制
    
#pragma mark -- 百度地图
    BMKPoiSearch* _poisearch;
    BMKMapView *_mapView;
    BMKGeoCodeSearch *geocodesearch;
    UIButton *_rightBtn;
    
    /*- data-*/
    NSMutableArray *annotationArr;
    
    NSInteger isDetailRange;            // 是否楼盘
}

// 团购列表
@property (nonatomic, strong) NSMutableArray *grDataArr;
// 行业类型
@property (nonatomic, strong) NSMutableArray *allIndustry;
// 类别
@property (nonatomic, strong) NSMutableArray *allType;
// 项目性质
@property (nonatomic, strong) NSMutableArray *allNature;

#pragma mark -- 百度地图
@property (nonatomic, strong) NSMutableArray *rangeOfBuilding;
@end

@implementation GroupRentNewViewController
#pragma mark -- 百度地图
- (NSMutableArray *)rangeOfBuilding{
    if (!_rangeOfBuilding) {
        _rangeOfBuilding = [[NSMutableArray alloc]init];
    }
    return _rangeOfBuilding;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _poisearch.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [_mapView viewWillDisappear];
    
    _mapView.delegate = nil; // 不用时，置nil
    geocodesearch.delegate = nil;
    _poisearch.delegate = nil; // 不用时，置nil
}

#pragma mark -- 项目列表
- (NSMutableArray *)grDataArr{
    if (!_grDataArr) {
        _grDataArr = [[NSMutableArray alloc]init];
    }
    return _grDataArr;
}

- (NSMutableArray *)allIndustry{
    if (!_allIndustry) {
        _allIndustry = [[NSMutableArray alloc]init];
    }
    return _allIndustry;
}

- (NSMutableArray *)allType{
    if (!_allType) {
        _allType = [[NSMutableArray alloc]init];
    }
    return _allType;
}

- (NSMutableArray *)allNature{
    if (!_allNature) {
        _allNature = [[NSMutableArray alloc]init];
    }
    return _allNature;
}

#pragma mark - 请求筛选维度
- (void)requestDimensionality{
    
    // 项目
    project = @[@"项目",@"意向登记期",@"意向金收取期",@"转定签约期"];
    
    // 类型
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/houseCategory/typeCategorys.do" params:nil success:^(id JSON) {
        
        NSDictionary *dict = JSON[@"data"];
        if (![dict isEqual:[NSNull null]]) {
            
            [_allType removeAllObjects];
            
            // 第一个不限
            NSDictionary *firstDic = @{@"categoryName": @"类型",
                                       @"typeCategoryId": @"0"};
            [self.allType addObject:[FindBrankModel findBrankWithDict:firstDic]];
            
            for (NSDictionary *tempDic in dict) {
                FindBrankModel *model = [FindBrankModel findBrankWithDict:tempDic];
                [self.allType addObject:model];
            }
            
            [self delegateAgain];
        }
    } failure:^(NSError *error) {
        
    }];
    
    // 更多
    otherTitles = @[@"项目性质",@"智能排序",@"行业类别"];
    
    // 更多 - 项目性质
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/houseCategory/natureCategorys.do" params:nil success:^(id JSON) {
        
        NSDictionary *dict = JSON[@"data"];
        if (![dict isEqual:[NSNull null]]) {
            
            [_allNature removeAllObjects];
            
            // 第一个不限
            NSDictionary *firstDic = @{@"categoryName": @"不限",
                                       @"projectNatureCategoryId": @"0"};
            [self.allNature addObject:[FindBrankModel findBrankWithDict:firstDic]];
            
            for (NSDictionary *tempDic in dict) {
                FindBrankModel *model = [FindBrankModel findBrankWithDict:tempDic];
                [self.allNature addObject:model];
            }
            
            [self delegateAgain];
        }
    } failure:^(NSError *error) {
        
    }];
    
    // 更多 - 智能排序
    smartSorting = @[@"不限",@"人气最高",@"好评优先"];
    
    // 更多 - 行业类别
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/houseCategory/industryCategorys.do" params:nil success:^(id JSON) {
        
        NSDictionary *dict = JSON[@"data"];
        
        if (![dict isEqual:[NSNull null]]) {
            
            [_allIndustry removeAllObjects];
            
            // 第一个不限
            NSDictionary *firstDic = @{@"categoryName": @"不限",
                                       @"industryCategoryId": @"0"};
            [self.allIndustry addObject:[FindBrankModel findBrankWithDict:firstDic]];
            
            for (NSDictionary *tempDic in dict) {
                FindBrankModel *model = [FindBrankModel findBrankWithDict:tempDic];
                [self.allIndustry addObject:model];
            }
            
            [self delegateAgain];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 刷新代理（数据源）
- (void)delegateAgain{
    
    dropMenu.delegate = nil;
    dropMenu.dataSource = nil;
    dropMenu.delegate = self;
    dropMenu.dataSource = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 初始化数据
    pages = 10;
    type = 1;
    status = 0;
    typeCategoryID = 0;
    projectNatureCategoryId = 0;
    smartSorting = 0;
    industryCategoryID = 0;
    //control = 1;
    
    //百度地图
    isDetailRange = 1;
    
    // 请求筛选维度
    [self requestDimensionality];
    // 请求数据
    [self requestData];
    // 导航条
    [self setupNav];
    
    // 设置内容
    [self setupUI];
    
    //百度地图UI
    //[self setupMapUI];
    
    // 注册监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getRegionID:)
                                                 name:@"RegionID"
                                               object:nil];
}

#pragma mark - 通知
- (void)getRegionID:(NSNotification *)notification{
    
    NSLog(@"----%@",[notification object]);
    _regionId = [[notification object] integerValue];
    //regionId = [[notification object] integerValue];
    
    [dropMenu animateIdicator:0 background:dropMenu.backGroundView tableView:dropMenu.leftTableView title:nil forward:NO complecte:^{
        dropMenu.show = NO;
    }];
#pragma mark -- 选择区域的时候页启动地图搜索
    [_mapView viewWillAppear];
    
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _poisearch.delegate = self;
    
    [self requestData];
}

#pragma mark - 设置导航条
- (void)setupNav{
    
    SDDButton *back = [[SDDButton alloc]init];
    back.frame = CGRectMake(0, 0, 40, 40);
    [back addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    
    // 中间选择
    UIView *titleView = [[UIView alloc] init];
    titleView.frame = CGRectMake(0, 0, nav_titleWidth*2, 30);
    
    [Tools_F setViewlayer:titleView cornerRadius:15 borderWidth:1 borderColor:[UIColor whiteColor]];
    
    UIButton *favorable = [UIButton buttonWithType:UIButtonTypeCustom];
    favorable.frame = CGRectMake(0, 0, nav_titleWidth, 30);
    favorable.clipsToBounds = YES;
    favorable.tag = 100;
    [Tools_F commonWithButton:favorable font:biggestFont
                        title:@"优惠项目" selectedTitle:nil
                   titleColor:[UIColor whiteColor]
           selectedtitleColor:mainTitleColor
                backgroundImg:[Tools_F imageWithColor:mainTitleColor size:CGSizeMake(1, 1)]
        selectedBackgroundImg:[Tools_F imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)]
                       target:self
                       action:@selector(someRent:)];
    favorable.titleLabel.font = midFont;
    [titleView addSubview:favorable];
    
    UIButton *all = [UIButton buttonWithType:UIButtonTypeCustom];
    all.frame = CGRectMake(CGRectGetMaxX(favorable.frame), 0, nav_titleWidth, 30);
    all.clipsToBounds = YES;
    all.tag = 101;
    [Tools_F commonWithButton:all font:biggestFont
                        title:@"全部项目"
                selectedTitle:nil
                   titleColor:[UIColor whiteColor]
           selectedtitleColor:mainTitleColor
                backgroundImg:[Tools_F imageWithColor:mainTitleColor size:CGSizeMake(1, 1)]
        selectedBackgroundImg:[Tools_F imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)]
                       target:self
                       action:@selector(allRent:)];
    all.titleLabel.font = midFont;
    [titleView addSubview:all];
    
    favorable.selected = YES;
    self.navigationItem.titleView = titleView;
    
    // 导航条右
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(0, 0, 30, 30);
    [searchButton setImage:[UIImage imageNamed:@"index_btn_search"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mapButton.frame = CGRectMake(0, 0, 30, 30);
    [mapButton setImage:[UIImage imageNamed:@"index_btn_map"] forState:UIControlStateNormal];
    [mapButton addTarget:self action:@selector(mapAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barSearch = [[UIBarButtonItem alloc]initWithCustomView:searchButton];
    UIBarButtonItem *barMap = [[UIBarButtonItem alloc]initWithCustomView:mapButton];
    self.navigationItem.rightBarButtonItems = @[barSearch,barMap];
}

#pragma mark - 设置内容
- (void)setupUI {
    
    // 添加下拉菜单
    dropMenu = [[JoinPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:40];
    dropMenu.indicatorColor = lgrayColor;
    dropMenu.textColor = deepBLack;
    [dropMenu setMoreSelectMode:TRUE:3];  //设置多选模式
    AreaSelectView *location = [[AreaSelectView alloc] init];
    [dropMenu setLocation:location];
    
    [self.view addSubview:dropMenu];
    
    ProjectView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(dropMenu.frame), viewWidth, viewHeight-104)];
    
    [self.view addSubview:ProjectView];
    
    MapView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(dropMenu.frame), viewWidth, viewHeight-104)];
    
    [self.view addSubview:MapView];
    
    if (_enterType == 1) {
        ProjectView.hidden = NO;
        MapView.hidden = YES;
    }
    else
    {
        ProjectView.hidden = YES;
        MapView.hidden = NO;
    }
    
//    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 20)];
//    label.text = @"hhahhahhah a ahhashxhashxs";
//    [MapView addSubview:label];
    
    // 内容
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-104) style:UITableViewStyleGrouped];
    table.backgroundColor = bgColor;
    table.delegate = self;
    table.dataSource = self;
    
    [table addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [ProjectView addSubview:table];
    
    
    // 初始化地图
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-64)];
    _mapView.showsUserLocation = NO;                            //先关闭显示的定位图层
    [MapView addSubview:_mapView];
    
    // 地理编码
    geocodesearch = [[BMKGeoCodeSearch alloc]init];
    
    switch (_fromIndex) {
        case 0:                      // 具体楼盘
        {
            NSLog(@"经度：%f纬度：%f",_theLongitude,_theLatitude);
            
            // 先放大比例尺
            _mapView.zoomLevel = 11;
            
            // 初始化poi搜索
            _poisearch = [[BMKPoiSearch alloc]init];
            
            CLLocationCoordinate2D pt = (CLLocationCoordinate2D){_theLatitude, _theLongitude};
            
            BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
            reverseGeocodeSearchOption.reverseGeoPoint = pt;
            
            BOOL flag = [geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
            if(flag) {
                
                NSLog(@"反geo检索发送成功");
            }
            else {
                NSLog(@"反geo检索发送失败");
            }
            
            [self setupPOIButton];
        }
            break;
        case 1:                      // 区级
        {
            // 正向geo
            BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
            geocodeSearchOption.city = _currentCity;
            geocodeSearchOption.address = _currentCity;
            BOOL flag = [geocodesearch geoCode:geocodeSearchOption];
            
            if(flag){
                
                NSLog(@"%@geo检索发送成功",_currentCity);
                [self mapWithLoadDataType:1 longitude:0 latitude:0];         // 查找区/县楼盘数量统计
            }
            else {
                
                NSLog(@"geo检索发送失败");
            }
        }
            break;
        case 2:                       // 市级
        {
            [self getCityType:1 CityId:0 CityName:@""];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 上拉加载
- (void)loadMoreData{
    
    pages+=10;
    [self showLoading:2];
    [self requestData];
    NSLog(@"上拉加载%d个",pages);
}

#pragma mark - 可视栏目数
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu{
    
    return 4;
}

#pragma mark - 各栏目一级个数
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column{
    
    if (column == 0) {
        
        return 1;
        //        return [_allIndustry count];
    }
    else if (column == 1){
        
        return [project count];
    }
    else if (column == 2){
        
        return [_allType count];
    }
    else {
        
        return [otherTitles count];
    }
}

#pragma mark - 返回栏目一级标题
- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath{
    
    if (indexPath.column == 0) {
        
        return @"区域";
        //        FindBrankModel *model = _allIndustry[indexPath.row];
        //        return model.categoryName;
    }
    else if (indexPath.column == 1){
        
        return project[indexPath.row];
    }
    else if (indexPath.column == 2){
        
        FindBrankModel *model = _allType[indexPath.row];
        return model.categoryName;
    }
    else {
        
        return [otherTitles objectAtIndex:indexPath.row];
    }
}

#pragma mark - 栏目内二级个数
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column{
    
    if (column == 3) {
        switch (row) {
            case 0:
            {
                return [_allNature count];
            }
                break;
            case 1:
            {
                return [smartSorting count];
            }
                break;
            case 2:
            {
                return [_allIndustry count];
            }
                break;
        }
    }
    return 0;
}

#pragma mark - 返回栏目二级标题
- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath{
    
    if (indexPath.column == 3) {
        switch (indexPath.row) {
            case 0:
            {
                FindBrankModel *model = _allNature[indexPath.item];
                return model.categoryName;
            }
                break;
            case 1:
            {
                return smartSorting[indexPath.item];
            }
                break;
            case 2:
            {
                // 行业
                FindBrankModel *model = _allIndustry[indexPath.item];
                return model.categoryName;
            }
                break;
        }
    }
    return nil;
}

#pragma mark - 点击代理，点击了第column 第row 或者item项，如果 item >=0
- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath{
    
    if (indexPath.item >= 0) {
        
        NSLog(@"点击了 %ld - %d - %d 项目",(long)indexPath.column,(int)indexPath.row,(int)indexPath.item);
    }
    else {
        
        NSLog(@"点击了 %d - %d 项目",(int)indexPath.column,(int)indexPath.row);
        switch (indexPath.column) {
            case 1:
            {
                // 项目状态
                status = indexPath.row;
                [self requestData];
                
            }
                break;
            case 2:
            {
                //类型
                FindBrankModel *model = _allType[indexPath.row];
                typeCategoryID = [model.typeCategoryId integerValue];
                [self requestData];
            }
                break;
        }
    }
}

#pragma mark - 菜单多选功能
-(void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPaths:(NSMutableArray *)indexPaths{
    
    // 重置
    projectNatureCategoryId = 0;
    smartSortingId = 0;
    industryCategoryID = 0;
    
    for (int i = 0; i < [indexPaths count]; i++) {
        NSMutableArray *mu = [indexPaths objectAtIndex:i];
        NSLog(@"~~~~%d有%d个",i,[mu count]);
        for (NSIndexPath *indexPath in mu) {
            switch (i) {
                case 0:
                {
                    // 项目性质
                    FindBrankModel *model = _allNature[indexPath.item];
                    projectNatureCategoryId = [model.projectNatureCategoryId integerValue];
                }
                    break;
                case 1:
                {
                    // 智能排序
                    smartSortingId = indexPath.item;
                }
                    break;
                case 2:
                {
                    // 行业
                    FindBrankModel *model = _allIndustry[indexPath.row];
                    industryCategoryID = [model.industryCategoryId integerValue];
                }
                    break;
            }
        }
    }
    [self requestData];
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

#pragma mark - 设置行数 (tableView)
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_grDataArr count];
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
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //重用标识符
    static NSString *identifier = @"CELLMARK";
    //重用机制
    GroupPurchaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
    
    if(cell == nil){
        //当不存在的时候用重用标识符生成
        cell = [[GroupPurchaseTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
    }
    
    HouseResourcesModel *model = _grDataArr[indexPath.row];
    
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
    
    if ([model.hr_activityCategoryId integerValue] != 2 && type == 0) {
        
        cell.cellType = index_gr_noPreferential;
        // 抵价
        cell.placePrice.text = [NSString stringWithFormat:@"建筑面积:%@万m²",model.hr_buildingArea];
    }
    else {
        cell.cellType = index_gr;
        // 抵价
        cell.placePrice.text = model.hr_rentPreferentialContent;
    }
    return cell;
}

#pragma mark - 点击cell进入详细页面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HouseResourcesModel *model = _grDataArr[indexPath.row];
    
    self.hidesBottomBarWhenPushed = YES;
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
}

#pragma mark - 所有品牌
- (void)allRent:(UIButton *)btn{
    
    UIButton *otherBtn = (UIButton *)[btn.superview viewWithTag:100];
    otherBtn.selected = NO;
    btn.selected = YES;
    
    type = 0;
    [self requestData];
}

#pragma mark - 优惠品牌
- (void)someRent:(UIButton *)btn{
    
    UIButton *otherBtn = (UIButton *)[btn.superview viewWithTag:101];
    otherBtn.selected = NO;
    btn.selected = YES;
    
    type = 1;
    [self requestData];
}

#pragma mark - 搜索
- (void)searchAction:(UIButton *)sender{
    
    SearchViewController *search = [[SearchViewController alloc] init];
    
    search.activityCategoryId = @"2";
    [self.navigationController pushViewController:search animated:YES];
}

#pragma mark - 地图
- (void)mapAction:(UIButton *)sender{
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                    message:@"施工中…"
//                                                   delegate:nil
//                                          cancelButtonTitle:@"确定"
//                                          otherButtonTitles:nil, nil];
//    [alert show];
    _enterType *= -1;
    if (_enterType == -1) {
        MapView.hidden = NO;
        ProjectView.hidden = YES;
    }else
    {
        MapView.hidden = YES;
        ProjectView.hidden = NO;
    }
}

#pragma mark - 网络请求
- (void)requestData{
    
    [self showLoading:2];
    // 请求参数
    NSDictionary *dic = @{@"pageNumber":@1,
                          @"pageSize":[NSNumber numberWithInteger:pages],
                          @"params":@{@"typeCategoryId":typeCategoryID == 0?
                                      [NSNull null]:[NSNumber numberWithInteger:typeCategoryID],
                                      @"industryCategoryId":industryCategoryID == 0?
                                      [NSNull null]:[NSNumber numberWithInteger:industryCategoryID],
                                      @"merchantsStatus":status== 0?
                                      [NSNull null]:[NSNumber numberWithInteger:status],
                                      @"activityCategoryId":@2,
                                      @"projectNatureCategoryId":projectNatureCategoryId == 0?
                                      [NSNull null]:[NSNumber numberWithInteger:projectNatureCategoryId],
                                      @"isOpenedProject":@0,
                                      @"type":[NSNumber numberWithInteger:type],
                                      @"regionId":_regionId == 0?
                                      [NSNull null]:[NSNumber numberWithInteger:_regionId],
                                      @"smartSorting":smartSortingId == 0?
                                      [NSNull null]:[NSNumber numberWithInteger:smartSortingId]
                                      }
                          };
    
    NSLog(@"传参：%@", dic);
    
    NSString *urlString = [SDD_MainURL stringByAppendingString:@"/house/search.do"];              // 拼接主路径和请求内容成完整url
    
    [self.httpManager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = responseObject;
        NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
        
        if (![dict[@"data"] isEqual:[NSNull null]]) {
            
            [_grDataArr removeAllObjects];
            [table.footer endRefreshing];
            for (NSDictionary *tempDic in dict[@"data"]) {
                
                HouseResourcesModel *model = [HouseResourcesModel hrWithDict:tempDic];
                [self.grDataArr addObject:model];
            }
            
            // 判断数据个数与请求个数
            if ([_grDataArr count]<pages) {
                
                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                [table.footer noticeNoMoreData];
            }
            [table reloadData];
            [self hideLoading];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [table.footer endRefreshing];
        [self hideLoading];
        NSLog(@"错误 -- %@", error);
    }];
}
#pragma mark - leftaction
- (void)leftAction:(UIButton *)btn{
    
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}




#pragma mark -- 设置百度地图
#pragma mark - 设置内容
- (void)setupMapUI{
    
    // 初始化地图
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-64)];
    _mapView.showsUserLocation = NO;                            //先关闭显示的定位图层
    [MapView addSubview:_mapView];
    
    // 地理编码
    geocodesearch = [[BMKGeoCodeSearch alloc]init];
    
    switch (_fromIndex) {
        case 0:                      // 具体楼盘
        {
            NSLog(@"经度：%f纬度：%f",_theLongitude,_theLatitude);
            
            // 先放大比例尺
            _mapView.zoomLevel = 11;
            
            // 初始化poi搜索
            _poisearch = [[BMKPoiSearch alloc]init];
            
            CLLocationCoordinate2D pt = (CLLocationCoordinate2D){_theLatitude, _theLongitude};
            
            BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
            reverseGeocodeSearchOption.reverseGeoPoint = pt;
            
            BOOL flag = [geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
            if(flag) {
                
                NSLog(@"反geo检索发送成功");
            }
            else {
                NSLog(@"反geo检索发送失败");
            }
            
            [self setupPOIButton];
        }
            break;
        case 1:                      // 区级
        {
            // 正向geo
            BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
            geocodeSearchOption.city = _currentCity;
            geocodeSearchOption.address = _currentCity;
            BOOL flag = [geocodesearch geoCode:geocodeSearchOption];
            
            if(flag){
                
                NSLog(@"%@geo检索发送成功",_currentCity);
                [self mapWithLoadDataType:1 longitude:0 latitude:0];         // 查找区/县楼盘数量统计
            }
            else {
                
                NSLog(@"geo检索发送失败");
            }
        }
            break;
        case 2:                       // 市级
        {
            [self getCityType:1 CityId:0 CityName:@""];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 下方poi按钮
- (void)setupPOIButton{
    
    // 下方poi选项
    UIView *view_bg = [[UIView alloc] init];
    view_bg.frame = CGRectMake(0, viewHeight-144, viewWidth, 40);
    view_bg.backgroundColor = bgColor;
    [MapView addSubview:view_bg];
    
    NSArray *poiTitle = @[
                          @"公车",
                          @"地铁",
                          @"学校",
                          @"项目",//楼盘
                          @"医院",
                          @"银行",
                          @"购物",
                          ];
    
    NSArray *poiImagesUnselected = @[
                                     @"index_btn_bus_unSelected",
                                     @"index_btn_metro_unSelected",
                                     @"index_btn_school_unSelected",
                                     @"index_btn_building_unSelected",
                                     @"index_btn_hospital_unSelected",
                                     @"index_btn_bank_unSelected",
                                     @"index_btn_shopping_unSelected",
                                     ];
    
    NSArray *poiImagesSelected = @[
                                   @"index_btn_bus_selected",
                                   @"index_btn_metro_selected",
                                   @"index_btn_school_selected",
                                   @"index_btn_building_selected",
                                   @"index_btn_hospital_selected",
                                   @"index_btn_bank_selected",
                                   @"index_btn_shopping_selected",
                                   ];
    
    for (int i=0; i<7; i++) {
        
        TabButton *btn = [TabButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0+viewWidth/7*i, 0, viewWidth/7, 40);
        btn.tag = 100+i;
        btn.titleLabel.font = midFont;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitle:poiTitle[i] forState:UIControlStateNormal];
        [btn setTitleColor:lblueColor forState:UIControlStateNormal];
        [btn setTitleColor:dblueColor forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:poiImagesUnselected[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:poiImagesSelected[i]] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(poiClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [view_bg addSubview:btn];
    }
}

#pragma mark - 市/县级搜索
- (void)getCityType:(NSInteger)type CityId:(NSInteger)cityId CityName:(NSString *)cityName{
    
    switch (type) {
        case 1:{
            
            NSDictionary *dict = @{@"params":@{@"parentId":_currentProvinceId,@"brandId":_brankId}};
            
            NSLog(@"%@",dict);
            [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brandRegion/cityList.do" params:dict success:^(id JSON) {
                
                NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
                NSArray *regionArr = JSON[@"data"];
                
                if (![dict isEqual:[NSNull null]]) {
                    
                    isDetailRange  =  type;
                    
                    if ([regionArr count]>0) {
                        NSDictionary *tempDic = regionArr[0];
                        
                        // 正向geo
                        BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
                        geocodeSearchOption.city = tempDic[@"regionName"];
                        geocodeSearchOption.address = tempDic[@"regionName"];
                        [geocodesearch geoCode:geocodeSearchOption];
                    }
                    
                    for (NSDictionary *tempDic in regionArr) {
                        
                        JoinMapModel *model = [JoinMapModel joinMapWithDict:tempDic];
                        
                        [self.rangeOfBuilding addObject:model];
                    }
                }
            } failure:^(NSError *error) {
                
                NSLog(@"%@",error);
            }];
        }
            break;
        default:{
            
            NSDictionary *dict = @{@"params":@{@"cityId":[NSNumber numberWithInteger:cityId],@"brandId":_brankId}};
            
            NSLog(@"%@",dict);
            [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brandStore/listByCityIdAndBrandId.do" params:dict success:^(id JSON) {
                
                NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
                NSArray *regionArr = JSON[@"data"];
                
                if (![dict isEqual:[NSNull null]]) {
                    
                    [_rangeOfBuilding removeAllObjects];
                    
                    isDetailRange = type;
                    
                    for (NSDictionary *tempDic in regionArr) {
                        
                        JoinMapModel *model = [JoinMapModel joinMapWithDict:tempDic];
                        
                        [self.rangeOfBuilding addObject:model];
                    }
                    
                    // 正向geo
                    BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
                    geocodeSearchOption.city = cityName;
                    geocodeSearchOption.address = cityName;
                    [geocodesearch geoCode:geocodeSearchOption];
                }
            } failure:^(NSError *error) {
                
                NSLog(@"%@",error);
            }];
        }
            break;
    }
}

#pragma mark - 市/县级搜索
- (void)mapWithLoadDataType:(NSInteger)type longitude:(float)longitude latitude:(float)latitude{
    
    NSDictionary *dict = @{@"params":@{
                                   @"regionName":_currentCity,
                                   @"type":[NSNumber numberWithInteger:type],
                                   @"activityCategoryId":@0,
                                   @"longitude":[NSNumber numberWithFloat:longitude],
                                   @"latitude":[NSNumber numberWithFloat:latitude]
                                   }
                           };
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/house/mapList.do" params:dict success:^(id JSON) {
        
        NSDictionary *getDic = JSON;
        NSLog(@"%@",getDic);
        if (![getDic[@"data"] isEqual:[NSNull null]]) {
            
            [_rangeOfBuilding removeAllObjects];
            for (NSDictionary *tempDic in getDic[@"data"]) {
                
                MMapModel *model = [[MMapModel alloc] initWithDict:tempDic];
                
                [self.rangeOfBuilding addObject:model];
            }
            
            isDetailRange = type;
            // 正向geo
            BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
            geocodeSearchOption.city = _currentCity;
            geocodeSearchOption.address = _currentCity;
            [geocodesearch geoCode:geocodeSearchOption];
        }
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
    }];
}

#pragma mark - 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"annotationViewID";
    //根据指定标识查找一个可被复用的标注View，一般在delegate中使用，用此函数来代替新申请一个View
    BMKAnnotationView *annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
        ((BMKPinAnnotationView*)annotationView).animatesDrop = _fromIndex == 1? NO:YES;
        //        ((BMKPinAnnotationView*)annotationView).animatesDrop = NO;
    }
    
    //    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    annotationView.canShowCallout = NO;
    
    if (_fromIndex != 0) {
        annotationView.image = [UIImage imageNamed:@"map_label"];
        
        if (isDetailRange == 1) {
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.frame = CGRectMake(0, 5, annotationView.frame.size.width, 13);
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = midFont;
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.text = annotation.title;
            [annotationView addSubview:titleLabel];
            
            UILabel *subTitle = [[UILabel alloc] init];
            subTitle.frame = CGRectMake(0, CGRectGetMaxY(titleLabel.frame)+5, annotationView.frame.size.width, 13);
            subTitle.textAlignment = NSTextAlignmentCenter;
            subTitle.font = midFont;
            subTitle.textColor = [UIColor whiteColor];
            subTitle.text = annotation.subtitle;
            [annotationView addSubview:subTitle];
        }
        else {
            
            // 动态高度
            NSString *content = annotation.title;
            CGSize contentSize = [Tools_F countingSize:content fontSize:viewHeight == 736? 17:viewHeight == 667? 15:13
                                                 width:viewWidth*2/3];
            
            annotationView.frame = CGRectMake(0, 0, contentSize.width+20, contentSize.height+20);
            annotationView.center = annotationView.center;
            
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.frame = CGRectMake(5, 5, contentSize.width, contentSize.height);
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = midFont;
            titleLabel.numberOfLines = 0;
            
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.text = annotation.title;
            [annotationView addSubview:titleLabel];
        }
    }
    
    return annotationView;
}

#pragma mark - 点击大头针
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    
    NSLog(@"click");
    if (_fromIndex == 1 && isDetailRange == 1) {
        
        // 先放大到13级后 再加载详情楼盘
        mapView.zoomLevel = 13;
        [self mapWithLoadDataType:2 longitude:view.annotation.coordinate.longitude latitude:view.annotation.coordinate.latitude];
    }
    
    if (_fromIndex == 1 && isDetailRange == 2) {   // 首页且是显示楼盘的时候
        
        // 以逗号分开activityCategoryId 和 houseid
        NSArray *arr=[view.annotation.subtitle componentsSeparatedByString:@","];
        
        //        switch ([arr[0] integerValue]) {
        //            case 1:
        //            {
        //                GPDetailViewController *gpDetail = [[GPDetailViewController alloc] init];
        //                gpDetail.activityCategoryId = arr[0];
        //                gpDetail.houseID = arr[1];
        //                [self.navigationController pushViewController:gpDetail animated:YES];
        //            }
        //                break;
        //            case 2:
        //            {
        GRDetailViewController *grDetail = [[GRDetailViewController alloc] init];
        grDetail.activityCategoryId = @"2";
        grDetail.houseID = arr[1];
        [self.navigationController pushViewController:grDetail animated:YES];
        //            }
        //                break;
        //            case 3:
        //            {
        //                HRDetailViewController *hrDetail = [[HRDetailViewController alloc] init];
        //
        //                hrDetail.activityCategoryId = arr[0];
        //                hrDetail.hrTitle = view.annotation.title;
        //                hrDetail.houseID = arr[1];
        //                [self.navigationController pushViewController:hrDetail animated:YES];
        //            }
        //                break;
        //
        //            default:
        //                break;
        //        }
    }
    
    if (_fromIndex == 2 && isDetailRange == 1) {   // 显示加盟商
        
        // 先放大到13级后 再加载详情楼盘
        mapView.zoomLevel = 13;
        
        for (JoinMapModel *model in _rangeOfBuilding) {
            if ([model.regionName isEqualToString:view.annotation.title]) {
                
                [self getCityType:2 CityId:[model.regionId integerValue] CityName:model.regionName];
            }
        }
    }
    
    if (_fromIndex == 2 && isDetailRange == 2) {   // 进入加盟商
        
        
        //        JoinDetailViewController *jdVC = [[JoinDetailViewController alloc] init];
        ////        jdVC.brandId = model.f_brandId;
        //        [self.navigationController pushViewController:jdVC animated:YES];
    }
    
}

#pragma mark - 正编码
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    
    [_mapView reloadInputViews];
    NSLog(@"chushi调用>>>>>>>>>>>>>>>>>>%s",__FUNCTION__);
    
    if (error == 0) {
        
        annotationArr = [[NSMutableArray alloc] init];
        for (int i=0; i< _rangeOfBuilding.count; i++) {
            
            switch (_fromIndex) {
                case 1:{
                    
                    MMapModel *model = _rangeOfBuilding[i];
                    BMKPointAnnotation *item = [[BMKPointAnnotation alloc]init];
                    
                    if (![model.latitude isEqual:[NSNull null]] && ![model.longitude isEqual:[NSNull null]]) {
                        
                        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){[model.latitude floatValue], [model.longitude floatValue]};
                        
                        item.coordinate = pt;
                        item.title = isDetailRange == 1? model.countiesName:model.houseName;
                        item.subtitle = isDetailRange == 1? [NSString stringWithFormat:@"%d",model.qty]:[NSString stringWithFormat:@"%@,%@",model.activityCategoryId,model.houseId];
                        
                        [_mapView addAnnotation:item];
                        // 视图中心
                        _mapView.centerCoordinate = result.location;
                    }
                }
                    break;
                case 2:{
                    
                    JoinMapModel *model = _rangeOfBuilding[i];
                    BMKPointAnnotation *item = [[BMKPointAnnotation alloc]init];
                    
                    if (![model.latitude isEqual:[NSNull null]] && ![model.longitude isEqual:[NSNull null]]) {
                        
                        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){[model.latitude floatValue], [model.longitude floatValue]};
                        
                        item.coordinate = pt;
                        item.title = isDetailRange == 1?model.regionName:model.storesName;
                        item.subtitle = isDetailRange == 1?[NSString stringWithFormat:@"%@",model.brandQty]:[NSString stringWithFormat:@"%@",model.brandId];
                        
                        NSLog(@"title%@ subtitle%@",model.storesName,[NSString stringWithFormat:@"%@",model.brandId]);
                        
                        [_mapView addAnnotation:item];
                        // 视图中心
                        _mapView.centerCoordinate = result.location;
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
}

#pragma mark - 反编码
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    NSLog(@"初始>>>>>>>>>>>>>>>>>>%s",__FUNCTION__);
    
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        _currentCity = result.addressDetail.city;               // 设置当前城市
        
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
    }
}

#pragma mark - poi
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error{
    
    // 清除屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        for (int i = 0; i < result.poiInfoList.count; i++) {
            
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            [_mapView addAnnotation:item];
            if(i == 0)
            {
                //将第一个点的坐标移到屏幕中央
                _mapView.centerCoordinate = poi.pt;
            }
        }
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    } else {
        // 各种情况的判断。。。
    }
}

/**
 *地图区域改变完成后会调用此接口
 *@param mapview 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    if (_fromIndex==1 && mapView.zoomLevel > 13 && isDetailRange == 1) {
        
        // 当放大到13级后 加载详情楼盘
        [self mapWithLoadDataType:2 longitude:mapView.centerCoordinate.longitude latitude:mapView.centerCoordinate.latitude];
    }
    else if (_fromIndex==1 && mapView.zoomLevel < 13 && isDetailRange == 2){
        
        // 加载市县级
        [self mapWithLoadDataType:1 longitude:0 latitude:0];         // 查找区/县楼盘数量统计
    }
}

#pragma mark - poi检索
- (void)poiClick:(UIButton *)btn{
    
    for (int i =100; i<107; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:i];
        btn.selected = NO;
    }
    
    btn.selected = !btn.selected;
    
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc] init];
    citySearchOption.pageIndex = 0;
    citySearchOption.pageCapacity = 20;
    citySearchOption.city = _currentCity;
    citySearchOption.keyword = btn.titleLabel.text;
    
    BOOL flag = [_poisearch poiSearchInCity:citySearchOption];
    
    if (flag) {
        
        NSLog(@"城市内检索发送成功");
    }
    else {
        
        NSLog(@"城市内检索发送失败");
    }
}

#pragma mark - 动态高度
+ (CGSize)countingSize:(NSString *)str fontSize:(int)fontSize width:(float)width{
    
    //高度估计文本大概要显示几行，宽度根据需求自己定义。 MAXFLOAT 可以算出具体要多高
    // label 可设置的最大高度和宽度
    CGSize size = CGSizeMake(width, MAXFLOAT);
    // 获取当前文本的属性
    NSDictionary *tdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName,nil];
    
    CGSize actualsize = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil].size;
    
    return actualsize;
}

#pragma mark - leftaction
//- (void)leftAction:(UIButton *)btn{
//    
//    NSLog(@"返回");
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    if (_poisearch != nil) {
        _poisearch = nil;
    }
    if (_mapView) {
        _mapView = nil;
    }
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
