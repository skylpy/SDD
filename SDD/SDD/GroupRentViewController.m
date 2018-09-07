//
//  GroupRentViewController.m
//  SDD
//
//  Created by hua on 15/4/13.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#define nav_titleWidth (viewHeight == 736? 110:viewHeight == 667? 80:72)

#import "GroupRentViewController.h"
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
#import "SDDMapViewController.h"

@interface GroupRentViewController ()<UITableViewDataSource,UITableViewDelegate,DOPDropDownMenuDataSource,DOPDropDownMenuDelegate>{
    
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
    
    AreaSelectView *location;//地区选择
}

// 团购列表
@property (nonatomic, strong) NSMutableArray *grDataArr;
// 行业类型
@property (nonatomic, strong) NSMutableArray *allIndustry;
// 类别
@property (nonatomic, strong) NSMutableArray *allType;
// 项目性质
@property (nonatomic, strong) NSMutableArray *allNature;

@property (nonatomic,strong) SDDMapViewController *mapVC;

//地图参数切换
@property (nonatomic,strong)NSDictionary *paramDic;

@end

@implementation GroupRentViewController

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
        NSLog(@"%@",dict);
        if (![dict isEqual:[NSNull null]]) {
            
            [_allType removeAllObjects];
            
            // 第一个不限
            NSDictionary *firstDic = @{@"categoryName": @"类型",
                                       @"typeCategoryId": @"0"};
            [self.allType addObject:[FindBrankModel findBrankWithDict:firstDic]];
            
            
            for (NSDictionary *tempDic in dict) {
                
                
                //排除写字楼
                if ([tempDic[@"typeCategoryId"] integerValue] != 7) {
                    
                    FindBrankModel *model = [FindBrankModel findBrankWithDict:tempDic];
                    [self.allType addObject:model];
                    
                }
                
            }
            
            [self delegateAgain];
        }
    } failure:^(NSError *error) {
        
    }];
    
    // 更多
    otherTitles = @[@"项目性质",@"智能排序",@"行业类别",@"",@"",@""];//
    
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
    
    // 请求筛选维度
    [self requestDimensionality];
    // 请求数据
    [self requestData];
    // 导航条
    [self setupNav];
    // 设置内容
    [self setupUI];
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
    [dropMenu animateIdicator:0 background:dropMenu.backGroundView tableView:dropMenu.leftTableView title:nil forward:NO complecte:^{
        dropMenu.show = NO;
    }];
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
    if (_deliverInt == 0) {
        [mapButton setImage:[UIImage imageNamed:@"index_btn_map"] forState:UIControlStateNormal];
    }
    else
    {
        [mapButton setImage:[UIImage imageNamed:@"home_top_liebiao"] forState:UIControlStateNormal];
    }
    
    //[mapButton setImage:[UIImage imageNamed:@"home_top_liebiao"] forState:UIControlStateSelected];
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
    location = [[AreaSelectView alloc] init];
    [location requestData:1];
    [dropMenu setLocation:location];
    
    [self.view addSubview:dropMenu];
    
    // 内容
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(dropMenu.frame), viewWidth, viewHeight-104) style:UITableViewStyleGrouped];
    table.backgroundColor = bgColor;
    table.delegate = self;
    table.dataSource = self;
    
    [table addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [self.view addSubview:table];
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
            default:
            {
                return [_allIndustry count];;
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
            default:
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
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"mapProject" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:status],@"status",[NSNumber numberWithInteger:typeCategoryID],@"typeCategoryID", nil]];
    
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
                default:
                {
                    // 行业
                    FindBrankModel *model = _allIndustry[indexPath.row];
                    industryCategoryID = [model.industryCategoryId integerValue];
                }
                    break;
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mapProject" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:projectNatureCategoryId],@"projectNatureCategoryId",[NSNumber numberWithInteger:smartSortingId],@"smartSortingId",[NSNumber numberWithInteger:industryCategoryID],@"industryCategoryID", nil]];

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
            merchantsStatus = @"状态: 意向登记期";
        }
            break;
        case 2:
        {
            merchantsStatus = @"状态: 意向金收取期";
        }
            break;
        case 3:
        {
            merchantsStatus = @"状态: 转定签约期";
        }
            break;
        case 4:
        {
            merchantsStatus = @"状态: 已开业";
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
        grDetail.type = 0;
        [self.navigationController pushViewController:grDetail animated:YES];
    }
    else {
        
        GRDetailViewController *grDetail = [[GRDetailViewController alloc] init];
        grDetail.activityCategoryId = @"2";
        grDetail.houseID = model.hr_houseId;
        grDetail.type = 2;
        [self.navigationController pushViewController:grDetail animated:YES];
    }
}

#pragma mark - 所有品牌
- (void)allRent:(UIButton *)btn{
    
    UIButton *otherBtn = (UIButton *)[btn.superview viewWithTag:100];
    otherBtn.selected = NO;
    btn.selected = YES;
    [location requestData:0];
    type = 0;
    [self requestData];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"projectType" object:[NSNumber numberWithInteger:type]];
}

#pragma mark - 优惠品牌
- (void)someRent:(UIButton *)btn{

    UIButton *otherBtn = (UIButton *)[btn.superview viewWithTag:101];
    otherBtn.selected = NO;
    btn.selected = YES;
    [location requestData:1];
    type = 1;
    [self requestData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"projectType" object:[NSNumber numberWithInteger:type]];

}

#pragma mark - 搜索
- (void)searchAction:(UIButton *)sender{
    
    SearchViewController *search = [[SearchViewController alloc] init];
    
    search.activityCategoryId = @"2";
    [self.navigationController pushViewController:search animated:YES];
}

#pragma mark - 地图
- (void)mapAction:(UIButton *)sender{
    
    switch (_deliverInt) {
        case 0:
            if (!sender.selected) {
                
                _mapVC = [[SDDMapViewController alloc] init];
                
                _mapVC.regionId = _regionId;
                _mapVC.type = type;
                
                _mapVC.view.frame = CGRectMake(0, 40, viewWidth, viewHeight - 40 - 64);
                
                [self addChildViewController:_mapVC];
                
                [self.view addSubview:_mapVC.view];
                
                [sender setImage:[UIImage imageNamed:@"home_top_liebiao"] forState:UIControlStateNormal];
                
                
            }else{
                
                [sender setImage:[UIImage imageNamed:@"index_btn_map"] forState:UIControlStateNormal];
                [_mapVC removeFromParentViewController];
                [_mapVC.view removeFromSuperview];
            }
            
            break;
            
        default:
        {
            
            if (!sender.selected) {
                
                [sender setImage:[UIImage imageNamed:@"index_btn_map"] forState:UIControlStateNormal];
                
                for (SDDMapViewController *mapVC in self.childViewControllers) {
                    
                    [mapVC removeFromParentViewController];
                    
                    [mapVC.view removeFromSuperview];
                }
                
                
            }else{
                
                
                _mapVC = [[SDDMapViewController alloc] init];
                
                _mapVC.regionId = _regionId;
                NSLog(@"%ld",_regionId);
                _mapVC.view.frame = CGRectMake(0, 40, viewWidth, viewHeight - 40 - 64);
                _mapVC.type = 1;
                [self addChildViewController:_mapVC];
                
                [self.view addSubview:_mapVC.view];
                
                [sender setImage:[UIImage imageNamed:@"home_top_liebiao"] forState:UIControlStateNormal];
            }
            
            
        }
            break;
    }
    
    sender.selected = !sender.selected;

   
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
