//
//  AreaSelectionViewController.m
//  SDD
//
//  Created by hua on 15/4/25.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "AreaSelectionViewController.h"
#import "RegionModel.h"

#import "BMapKit.h"

@interface AreaSelectionViewController ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,BMKGeoCodeSearchDelegate>{
 
    /*- ui -*/
    
    UITableView *table;
    UIScrollView *popScrollView;
    
    /*- data -*/
    
    NSArray *sectionTitles;
    NSString *currentProvince;
    NSString *currentCity;
    
    /*- 定位 -*/
    BMKGeoCodeSearch* geocodesearch;
}

// 地区
@property (nonatomic, strong) NSMutableArray *regionData;
// 热门地区
@property (nonatomic, strong) NSMutableArray *hot_RegionData;
 
@end

@implementation AreaSelectionViewController

- (NSMutableArray *)regionData{
    if (!_regionData) {
        _regionData = [[NSMutableArray alloc]init];
    }
    return _regionData;
}

- (NSMutableArray *)hot_RegionData{
    if (!_hot_RegionData) {
        _hot_RegionData = [[NSMutableArray alloc]init];
    }
    return _hot_RegionData;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    locService.delegate = self;
    geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated{
   
    [super viewWillDisappear:YES];
    
    locService.delegate = nil;
    geocodesearch.delegate = nil;
}

#pragma mark - 请求地区数据
- (void)requestData{
    
    // 热门城市
    NSString *urlString = [SDD_MainURL stringByAppendingString:@"/houseRegion/hotList.do"];              // 拼接主路径和请求内容成完整url
    
    [self.httpManager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = responseObject;
//        NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
        if (![dict[@"data"] isEqual:[NSNull null]]) {
            
            [self.hot_RegionData removeAllObjects];
            
            // 第一个为全国，前端写死
            RegionModel *fakeModel = [[RegionModel alloc] init];
            
            fakeModel.r_regionName = @"全国";
            [self.hot_RegionData addObject:fakeModel];
            
            for (NSDictionary *tempDict in dict[@"data"]) {
                
                RegionModel *model = [[RegionModel alloc] init];
                model.r_headChar = tempDict[@"headChar"];
                model.r_houseQty = tempDict[@"houseQty"];
                model.r_parentId = tempDict[@"parentId"];
                model.r_regionId = tempDict[@"regionId"];
                model.r_regionName = tempDict[@"regionName"];
                model.r_type = tempDict[@"type"];
                [self.hot_RegionData addObject:model];
            }
            [table reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
    
    // 全部城市
    NSDictionary *dic = @{@"parentId":@1};
    
    urlString = [SDD_MainURL stringByAppendingString:@"/houseRegion/list.do"];              // 拼接主路径和请求内容成完整url
    
    [self.httpManager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = responseObject;
//        NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
        if (![dict[@"data"] isEqual:[NSNull null]]) {
            
            [self.regionData removeAllObjects];
            for (NSDictionary *tempDict in dict[@"data"]) {
                
                RegionModel *model = [[RegionModel alloc] init];
                model.r_headChar = tempDict[@"headChar"];
                model.r_houseQty = tempDict[@"houseQty"];
                model.r_parentId = tempDict[@"parentId"];
                model.r_regionId = tempDict[@"regionId"];
                model.r_regionName = tempDict[@"regionName"];
                model.r_type = tempDict[@"type"];
                [_regionData addObject:model];
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
    self.view.backgroundColor = bgColor;
    
    currentCity = _currentCity;
    // 请求数据
    [self requestData];
    // 导航条
    [self setNav:@"选择城市"];
    // 设置内容
    [self setupUI];
    
    sectionTitles = @[@"当前定位城市",@"热门城市",@"全部城市"];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    //初始化BMKLocationService
    locService = [[BMKLocationService alloc] init];
    locService.delegate = self;
    //设置定位精确度，默认：kCLLocationAccuracyBest
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:10.f];
    //启动LocationService
    [locService startUserLocationService];
    
    geocodesearch = [[BMKGeoCodeSearch alloc]init];
    geocodesearch.delegate = self;
    
    // 内容
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-30) style:UITableViewStylePlain];
    table.backgroundColor = bgColor;
    table.delegate = self;
    table.dataSource = self;
    
    [self.view addSubview:table];
}

#pragma mark - 设置tableview头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *head_bg =[[UIView alloc] init];
    head_bg.backgroundColor = bgColor;
    
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(10, 0, viewWidth-20, 30);
    title.font = [UIFont systemFontOfSize:12];
    title.text = sectionTitles[section];
    [head_bg addSubview:title];
    
    return head_bg;
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //
    switch (indexPath.section) {
        case 0:
        {
            return 40;
        }
            break;
        case 1:
        {
            return 50;
        }
            break;
            
        default:{
            return 40;
        }
            break;
    };
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
        {
            return 1;
        }
            break;
        case 1:
        {
            return 1;
        }
            break;
            
        default:{
            return [_regionData count];
        }
            break;
    };
}

#pragma mark - 设置section数 (tableView)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 3;
}

#pragma mark - 设置section 头高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
}

#pragma mark - 设置section 脚高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}

#pragma mark - 设置cell (tableView)
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=nil;
    //重用标识符
    NSString *identifier = [NSString stringWithFormat:@"TimeLineCell%d%d",(int)indexPath.section,(int)indexPath.row];
    if (cell == nil) {
        //当不存在的时候用重用标识符生成
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
    }
    
    switch (indexPath.section) {
        case 0:
        {
            if (currentCity) {
                cell.textLabel.text = [NSString stringWithFormat:@"%@",currentCity];
            }
            
            UIButton *remove = (UIButton *)[cell viewWithTag:100];
            [remove removeFromSuperview];
            
            UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
            refreshButton.frame = CGRectMake(viewWidth-45, 0, 35, 40);
            refreshButton.titleLabel.font = midFont;
            refreshButton.tag = 100;
            [refreshButton setTitle:@"刷新" forState:UIControlStateNormal];
            [refreshButton setTitleColor:deepOrangeColor forState:UIControlStateNormal];
            [refreshButton addTarget:self action:@selector(positioning:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:refreshButton];
        }
            break;
        case 1:
        {
            for (UILabel *label in cell.subviews) {
                [label removeFromSuperview];
            }
            
            int hotCity = (int)[_hot_RegionData count];
            
            for (int i=0; i<hotCity; i++) {
                
                // 取模型
                RegionModel *model = _hot_RegionData[i];
                
                if (i<3) {
                    
                    UILabel *city = [[UILabel alloc] init];
                    city.frame = CGRectMake(10+(viewWidth/3)*(i%3), 10+40*(i/3), viewWidth/4, 30);
                    city.userInteractionEnabled = YES;
                    city.backgroundColor = bgColor;
                    city.font = midFont;
                    city.textAlignment = NSTextAlignmentCenter;
                    city.text = model.r_regionName;
                    [Tools_F setViewlayer:city cornerRadius:5 borderWidth:0 borderColor:nil];
                    [cell addSubview:city];
                    
                    UITapGestureRecognizer *hotCityTap = [[UITapGestureRecognizer alloc] init];
                    [hotCityTap addTarget:self action:@selector(hotCityTap:)];
                    [city addGestureRecognizer:hotCityTap];
                }
            }
        }
            break;
        case 2:
        {
            RegionModel *model = _regionData[indexPath.row];
            cell.textLabel.font = midFont;
            cell.textLabel.text = [NSString stringWithFormat:@"%@",model.r_regionName];
            
            UIView *division = [[UIView alloc] init];
            division.frame = CGRectMake(viewWidth/3+10, 0, 0.5, cell.frame.size.height);
            division.backgroundColor = divisionColor;
            [cell addSubview:division];
        }
            break;
            
        default:
            break;
    }
    
    // 移除旧
    if (popScrollView) {
        [popScrollView removeFromSuperview];
    }
    
    return cell;
}

#pragma mark - 点击cell (tableView)
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];     // 获得cell
    
    if (indexPath.section == 0) {
        
        // 代理传值
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RegionChoose" object:cell.textLabel.text];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (indexPath.section == 2) {
        
        RegionModel *model = _regionData[indexPath.row];
        
        currentProvince = model.r_regionName;
        [self requsetCurrentRegion:model.r_regionId cell:cell];
    }
}

#pragma mark - 请求市并加载视图
- (void)requsetCurrentRegion:(NSString *)region cell:(UITableViewCell *)cell{

    // 全部
    NSDictionary *dic = @{@"parentId":region};
    
    NSString *urlString = [SDD_MainURL stringByAppendingString:@"/houseRegion/list.do"];              // 拼接主路径和请求内容成完整url
    
    [self.httpManager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = responseObject;
        NSLog(@"%@\n%@\n%@>>>>>>>%@",urlString,dic,dict[@"message"],dict);
        if (![dict[@"data"] isEqual:[NSNull null]]) {
            
            // 移除旧
            if (popScrollView) {
                [popScrollView removeFromSuperview];
            }
            
            popScrollView = [[UIScrollView alloc] init];
            NSInteger h = [dict[@"data"] count]<5?[dict[@"data"] count]:5;
            popScrollView.frame = CGRectMake(viewWidth/3+11, cell.frame.origin.y,
                                             viewWidth-cell.textLabel.frame.size.width-10, (h+1)*39);
            popScrollView.backgroundColor = [UIColor whiteColor];
            popScrollView.delegate = self;
            for (int i=0; i<[dict[@"data"] count]+1; i++) {
                
                UIButton *cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
                cityButton.frame = CGRectMake(10, 40*i, viewWidth-cell.textLabel.frame.size.width-10, 39);
                cityButton.titleLabel.font = midFont;
                cityButton.backgroundColor = [UIColor whiteColor];
                cityButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [cityButton setTitle:i==0?@"不限":dict[@"data"][i-1][@"regionName"] forState:UIControlStateNormal];
                [cityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [cityButton addTarget:self action:@selector(cityChoose:) forControlEvents:UIControlEventTouchUpInside];
                [popScrollView addSubview:cityButton];
                
                popScrollView.contentSize = CGSizeMake(viewWidth-cell.textLabel.frame.size.width-10, 40*(i+1));
            }
            [table addSubview:popScrollView];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
}

- (void)willStartLocatingUser{
    NSLog(@"定位开始");
    
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{

    NSLog(@"定位坐标 %f,%f",userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    [geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    currentCity = result.addressDetail.province;
    NSLog(@"定位结果%@",result.address);
    if (currentCity.length > 0) {
        [locService stopUserLocationService];           // 得到城市后停止定位
        [table reloadData];
    }
}


#pragma mark - 定位
- (void)positioning:(UIButton *)btn{
    //开始定位
    [locService startUserLocationService];
}

#pragma mark - 手选城市选择
- (void)cityChoose:(UIButton *)btn{
    
    // 代理传值
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RegionChoose"
                                                        object:[btn.titleLabel.text isEqualToString:@"不限"]?
                                               currentProvince:btn.titleLabel.text];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 热门城市选择
- (void)hotCityTap:(UITapGestureRecognizer *)tap{
    
    UILabel *label = (UILabel *)tap.view;
    // 代理传值
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RegionChoose" object:label.text];
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
