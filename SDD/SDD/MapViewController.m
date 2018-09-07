//
//  MapViewController.m
//  SDD
//
//  Created by hua on 15/4/14.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "MapViewController.h"
#import "MMapModel.h"
#import "JoinMapModel.h"

#import "TabButton.h"


#import "GPDetailViewController.h"
#import "GRDetailViewController.h"
#import "HRDetailViewController.h"
#import "JoinDetailViewController.h"

#import "BMapKit.h"
#import "PeripheralSupportViewController.h"

@interface MapViewController ()<BMKMapViewDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate>{
    
    BMKPoiSearch* _poisearch;
    BMKMapView *_mapView;
    BMKGeoCodeSearch *geocodesearch;
    UIButton *_rightBtn;
    
    /*- data-*/
    NSMutableArray *annotationArr;
    
    NSInteger isDetailRange;            // 是否楼盘
    PeripheralSupportViewController * PerSuppVc ;
}

@property (nonatomic, strong) NSMutableArray *rangeOfBuilding;

@end

@implementation MapViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isDetailRange = 1;
    // 导航条
    [self setNav:@"地图"];
    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
    share.frame = CGRectMake(0, 0, 60, 30);
    //[share setBackgroundImage:[UIImage imageNamed:@"分享-图标"] forState:UIControlStateNormal];
    [share setTitle:@"说明" forState:UIControlStateNormal];
    [share setTitle:@"地图" forState:UIControlStateSelected];
    [share addTarget:self action:@selector(mapClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barShare = [[UIBarButtonItem alloc]initWithCustomView:share];
    self.navigationItem.rightBarButtonItems = @[barShare];
    // 设置内容
    [self setupUI];
}
-(void)mapClick:(UIButton *)sender{
    
    if (!sender.selected) {
        
        PerSuppVc = [[PeripheralSupportViewController alloc] init];
        
        //_mapVC.regionId = _regionId;
        PerSuppVc.theLatitude = _theLatitude;
        PerSuppVc.theLongitude = _theLongitude;
        //_mapVC.fromIndex = 0;
        
        PerSuppVc.view.frame = CGRectMake(0, 0, viewWidth, viewHeight - 40 - 64);
        
        [self addChildViewController:PerSuppVc];
        
        [self.view addSubview:PerSuppVc.view];
        
        sender.selected = YES;
        //[sender setImage:[UIImage imageNamed:@"home_top_liebiao"] forState:UIControlStateNormal];
        
        
    }else{
        
        //[sender setImage:[UIImage imageNamed:@"index_btn_map"] forState:UIControlStateNormal];
        [PerSuppVc removeFromParentViewController];
        [PerSuppVc.view removeFromSuperview];
        sender.selected = NO;
    }
}
#pragma mark - 设置内容
- (void)setupUI{
    
    // 初始化地图
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-64)];
    _mapView.showsUserLocation = NO;                            //先关闭显示的定位图层
    [self.view addSubview:_mapView];
    
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
    view_bg.frame = CGRectMake(0, viewHeight-104, viewWidth, 40);
    view_bg.backgroundColor = bgColor;
    view_bg.userInteractionEnabled = YES;
    [self.view addSubview:view_bg];
    
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
- (void)poiClick:(TabButton *)btn{
    
    for (int i =100; i<107; i++) {
        TabButton *btn = (TabButton *)[self.view viewWithTag:i];
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
- (void)leftAction:(UIButton *)btn{
    
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}

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

@end
