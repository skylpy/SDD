//
//  SDDMapViewController.m
//  SDD
//
//  Created by mac on 15/10/29.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "SDDMapViewController.h"

//#import "BMKClusterManager.h"

#import "MapHouseListModel.h"
#import "MapDetailModel.h"
#import "MapListMenu.h"
#import "MapListViewController.h"
/*
 *点聚合Annotation
 */
@interface ClusterAnnotation : BMKPointAnnotation

///所包含annotation个数
@property (nonatomic, assign) NSInteger size;
//传输数据
@property (nonatomic,strong)NSDictionary *dataDict;


@property (nonatomic,strong)MapHouseListModel *model;

@end

@implementation ClusterAnnotation

@synthesize size = _size;

@end

/*
 *点聚合AnnotationView
 */
@interface ClusterAnnotationView : BMKPinAnnotationView {
    
}

@property (nonatomic, assign) NSInteger size;
@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UILabel *nameLabel;
@end

@implementation ClusterAnnotationView

@synthesize size = _size;
@synthesize label = _label;

@synthesize nameLabel = _nameLabel;

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBounds:CGRectMake(0.f, 0.f, 40.f, 40.f)];
   
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 80)];
        
        [self addSubview:backView];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 40.f, 40.f)];
        _label.textColor = [UIColor whiteColor];
        [Tools_F setViewlayer:_label cornerRadius:20 borderWidth:1 borderColor:[UIColor clearColor]];
        _label.backgroundColor = dblueColor;
        _label.font = [UIFont systemFontOfSize:15];
        _label.textAlignment = NSTextAlignmentCenter;
  
        [backView addSubview:_label];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(-8.f, 43.f, 60.f, 30.f)];
        _nameLabel.backgroundColor = dblueColor;
        _nameLabel.textColor = [UIColor whiteColor];
        
        [Tools_F setViewlayer:_nameLabel cornerRadius:5 borderWidth:1 borderColor:[UIColor clearColor]];
        
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        
        [backView addSubview:_nameLabel];

 
//        self.alpha = 0.85;
    }
    return self;
}



@end

@interface SDDMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>
{
    
    BMKMapView *_mapView; //地图
    
    BMKLocationService *_locService; //定位服务
    
//    BMKClusterManager *_clusterManager;//点聚合管理类
    NSInteger _clusterZoom;//聚合级别
    NSMutableArray *_clusterCaches;//点聚合缓存标注

}
//存储城市数据
@property (nonatomic,strong)NSMutableArray *houseListArr;

//显示选中项目
@property (nonatomic,strong) MapListMenu *listMenu;

@property (nonatomic,strong)NSMutableArray *houseDetailArr;

@property (nonatomic,strong)NSMutableArray *projectArr;

//切换城市数据
@property (nonatomic,strong)NSDictionary *currentCityDic;


//保存当前城市id
@property (nonatomic,assign)NSInteger currentRegionId;
@end

@implementation SDDMapViewController

-(NSMutableArray *)houseListArr{

    if (_houseListArr == nil) {
        _houseListArr = [[NSMutableArray alloc] init];
    }
    return _houseListArr;
}

-(NSMutableArray *)houseDetailArr{
    
    if (_houseDetailArr == nil) {
        _houseDetailArr = [[NSMutableArray alloc] init];
    }
    return _houseDetailArr;
}

- (NSMutableArray *)projectArr{

    if (_projectArr == nil) {
        _projectArr = [[NSMutableArray alloc] init];
    }
    return _projectArr;
}
-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    
    [_listMenu dismiss];
    
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    
     [_listMenu dismiss];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}
#pragma mark - 获取全部项目经纬度
-(void)requestData
{
   
    [self showLoading:2];
    NSDictionary *paramsDic = @{@"params":@{ @"type":[NSNumber numberWithInteger:_type],
                                             @"regionId":@(_regionId),
//                                             [NSNull null]:[NSNumber numberWithInteger:_regionId],
                                            @"industryCategoryId":_industryCategoryId == 0? [NSNull null]:[NSNumber numberWithInteger:_industryCategoryId],
                                            @"typeCategoryId":_typeCategoryId == 0?[NSNull null]:[NSNumber numberWithInteger:_typeCategoryId],
                                             @"smartSorting":_smartSorting == 0?
                                             [NSNull null]:[NSNumber numberWithInteger:_smartSorting],
                                             @"projectNatureCategoryId":_projectNatureCategoryId == 0?
                                             [NSNull null]:[NSNumber numberWithInteger:_projectNatureCategoryId],
                                             @"merchantsStatus":_merchantsStatus== 0?
                                             [NSNull null]:[NSNumber numberWithInteger:_merchantsStatus]}};
//    NSLog(@"参数%@",paramsDic);
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/house/newMapList.do" params:paramsDic success:^(id JSON) {
 
        
        
        
        [_houseListArr removeAllObjects];
        
        [_projectArr removeAllObjects];
        

        NSArray *annoArr = [[NSArray alloc] initWithArray:_mapView.annotations];
        [_mapView removeAnnotations:annoArr];
   
        if (![JSON[@"data"] isEqual:[NSNull null]]) {
        
            NSLog(@"-*-*-*%@",JSON[@"data"]);
            
            NSArray *data = JSON[@"data"][@"sub"];
            
            NSDictionary *cityDic = JSON[@"data"][@"current"];
        
            NSLog(@"789-*-*-*%@",cityDic);
            
            if (![cityDic isEqual:[NSNull null]]) {

             self.currentCityDic = @{@"lat":cityDic[@"latitude"],@"lon":cityDic[@"longitude"],@"regionName":cityDic[@"regionName"],@"type":cityDic[@"type"]};
                
                 NSLog(@"789-*-*-*%@",self.currentCityDic);
                
                if ([cityDic[@"type"] isEqualToNumber:@(1)]) {
                    
                    self.currentRegionId = [cityDic[@"regionId"] integerValue];
                    
                     NSLog(@"123-*-*-*%ld",self.currentRegionId);
                }
            
             CLLocationCoordinate2D loc = CLLocationCoordinate2DMake([self.currentCityDic[@"lat"] doubleValue], [self.currentCityDic[@"lon"] doubleValue]);
                _mapView.centerCoordinate = loc;
               
            }
            
            if ([cityDic[@"type"] isEqualToNumber:@(0)]) {
                _mapView.zoomLevel = 6;
            }
            if ([cityDic[@"type"] isEqualToNumber:@(1)]) {
                _mapView.zoomLevel = 8;
            }
            if ([cityDic[@"type"] isEqualToNumber:@(2)]) {
                _mapView.zoomLevel = 12;
            }


            self.houseListArr = (NSMutableArray *)[MapHouseListModel objectArrayWithKeyValuesArray:data];
    
            for (NSInteger i = 0; i < self.houseListArr.count; i++) {
                    MapHouseListModel *model = self.houseListArr[i];
    //                NSDictionary *dic = self.projectArr[i];
    
                    double lat =  [model.latitude doubleValue];
                    double lon =  [model.longitude doubleValue];
    
                    ClusterAnnotation *clusterItem = [[ClusterAnnotation alloc] init];
    
                    clusterItem.coordinate = CLLocationCoordinate2DMake(lat, lon);
                    clusterItem.title = model.regionName;
                    clusterItem.model = model;
                
//                    [_clusterManager addClusterItem:clusterItem];
                    [_mapView addAnnotation:clusterItem];
                }
     
//            刷新地图
//            [_mapView mapForceRefresh];
            
           
            
            [self hideLoading];
        }
    }
   
        
     failure:^(NSError *error) {
        
        [self hideLoading];
        
    }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav:@"地图"];
   
    //_type = 1;
    _merchantsStatus = 0;
    _typeCategoryId = 0;
    _projectNatureCategoryId = 0;
    _smartSorting = 0;
    _industryCategoryId = 0;
    
    
    // 初始化地图
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-64)];
    
    _mapView.zoomLevel = 8;
    [self.view addSubview:_mapView];

   
    //定位开始
    [self location];
    
    [self requestData];
    
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
  
    /**
     *
     *
     *  @param getRegionId: 注册通知
     *
     *  @return 接收筛选城市通知
     */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(getRegionId:)
                                             name:@"RegionID"
                                           object:nil];
    
//    是否优惠项目
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(projectType:)
                                                 name:@"projectType"
                                               object:nil];
//    筛选维度
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pamar:)
                                                 name:@"mapProject"
                                               object:nil];
    // Do any additional setup after loading the view.
}
#pragma mark - 城市切换通知方法实现
- (void)getRegionId:(NSNotification *)notification{

    NSLog(@"%@",notification.object);

    _regionId = [notification.object integerValue];
    
    [self requestData];
}
#pragma mark - 是否优惠切换通知方法实现
- (void)projectType:(NSNotification *)notification{
    
    NSLog(@"%@",notification.object);
    
    _type = [notification.object integerValue];
    
    [self requestData];
}

#pragma mark - 筛选维度切换通知方法实现
- (void)pamar:(NSNotification *)notification{
    
    NSLog(@"%@",notification.userInfo);
    
//    _type = [notification.object integerValue];
    _smartSorting = [notification.userInfo[@"smartSortingId"] integerValue];
    
    _industryCategoryId = [notification.userInfo[@"industryCategoryID"] integerValue];
    
    _projectNatureCategoryId = [notification.userInfo[@"projectNatureCategoryId"] integerValue];
    
    _merchantsStatus = [notification.userInfo[@"status"] integerValue];
    
    _typeCategoryId = [notification.userInfo[@"typeCategoryID"] integerValue];
    
    
    NSLog(@"%ld===%ld====%ld===%ld===%ld===%ld",_smartSorting,_industryCategoryId,_projectNatureCategoryId,_merchantsStatus,_typeCategoryId);
    
    [self requestData];
}
#pragma mark - 定位
- (void)location{

     _locService = [[BMKLocationService alloc]init];
    
    [_locService startUserLocationService];
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
}

/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
//    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{

//        NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
//    _mapView.centerCoordinate = userLocation.location.coordinate;

}

#pragma mark - BMKMapViewDelegate

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    //普通annotation
  
    NSString *AnnotationViewID = @"ClusterMark";
    ClusterAnnotation *cluster = (ClusterAnnotation*)annotation;

    ClusterAnnotationView *annotationView = [[ClusterAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];

        annotationView.label.text = cluster.model.houseQty;

    if ([cluster.model.hasRent isEqualToString:@"1"]) {
        annotationView.label.backgroundColor = [UIColor orangeColor];
        
        annotationView.nameLabel.backgroundColor = [UIColor orangeColor];
    } else {
        
        annotationView.label.backgroundColor = dblueColor;
        annotationView.nameLabel.backgroundColor = dblueColor;
    }
    
    
    
    annotationView.nameLabel.text = cluster.title;
//    
//    CGSize size = [Tools_F countingSize:cluster.title fontSize:15 height:30];
//    
//    annotationView.nameLabel.frame = CGRectMake(-5.f, 43.f, size.width + 10, size.height + 10);

    annotationView.draggable = NO;
    annotationView.annotation = cluster;

    return annotationView;
    
}

/**
 *当点击annotation view弹出的泡泡时，调用此接口
 *@param mapView 地图View
 *@param view 泡泡所属的annotation view
 */
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view {
    if ([view isKindOfClass:[ClusterAnnotationView class]]) {
        ClusterAnnotation *clusterAnnotation = (ClusterAnnotation*)view.annotation;
        if ([self.currentCityDic[@"type"] isEqualToNumber:@(1)]) {
            
            _regionId = [clusterAnnotation.model.regionId integerValue];
            
            NSLog(@"%ld",_regionId);
            [self requestData];
        }
        else if ([self.currentCityDic[@"type"] isEqualToNumber:@(2)]){
            
            NSLog(@"进来了");
            _listMenu = [MapListMenu menu];
            
            MapListViewController *mvc = [[MapListViewController alloc] init];
            
            mvc.view.height = 200;
            
            mvc.view.width = viewWidth;

            mvc.dataArray = clusterAnnotation.model.houseList;
            
            NSLog(@"------%@",mvc.dataArray);
            _listMenu.contentController = mvc;
            
            [self.view addSubview:_listMenu];
            [_listMenu showFrom:self.view];
            
        }
        
    }
    
}

/**
 *  定位点气泡显示
 *
 *  @return return value description
 */
-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    
    
     NSLog(@"%@",self.currentCityDic[@"type"]);
    
    if ([view isKindOfClass:[ClusterAnnotationView class]]) {
        ClusterAnnotation *clusterAnnotation = (ClusterAnnotation*)view.annotation;
        if ([self.currentCityDic[@"type"] isEqualToNumber:@(1)] || [self.currentCityDic[@"type"] isEqualToNumber:@(0)]) {
            
            _regionId = [clusterAnnotation.model.regionId integerValue];

            [self requestData];
    }
        else if ([self.currentCityDic[@"type"] isEqualToNumber:@(2)]){
       
            NSLog(@"进来了");
            _listMenu = [MapListMenu menu];
    
            MapListViewController *mvc = [[MapListViewController alloc] init];

            mvc.view.height = 200;
  
            mvc.view.width = viewWidth;

            mvc.dataArray = clusterAnnotation.model.houseList;
            
            NSLog(@"------%@",mvc.dataArray);
            _listMenu.contentController = mvc;

             [self.view addSubview:_listMenu];
            [_listMenu showFrom:self.view];
        
        }

    }
}

/**
 *地图初始化完毕时会调用此接口
 *@param mapview 地图View
 */
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
//    [self updateClusters];
}

/**
 *地图渲染每一帧画面过程中，以及每次需要重绘地图时（例如添加覆盖物）都会调用此接口
 *@param mapview 地图View
 *@param status 此时地图的状态
 */
- (void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus *)status {

}


/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}


- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
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
