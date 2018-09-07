//
//  PanoramicMapViewController.m
//  SDD
//
//  Created by mac on 15/11/19.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "PanoramicMapViewController.h"
#import "TabButton.h"
#import "PanoShowViewController.h"

@interface PanoramicMapViewController ()<BMKMapViewDelegate,BMKPoiSearchDelegate>
{
    BMKMapView* _mapView ;
    BMKPoiSearch * _searcher;
    BMKPoiSearch * _searcher1;
    
    BMKPointAnnotation* annotation1;
    BMKPointAnnotation* annotation2;
    BMKPinAnnotationView* newAnnotation;
    
    NSInteger i;
}
@end

@implementation PanoramicMapViewController
-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    

    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    [self setNav:_titleTStr];
    [self createView];
}

-(void)createView{
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-64)];
    _mapView.delegate = self;
    _mapView.showMapScaleBar = YES;
    [self.view addSubview:_mapView];
    _mapView.zoomLevel = 15.0;
    [_mapView zoomIn];
    _mapView.zoomEnabledWithTap = YES;
    
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = [_latitude doubleValue];//39.915;//
    coor.longitude = [_longitude doubleValue];//116.404; //
    annotation.coordinate = coor;
    annotation.title = _titleTStr;
    [_mapView addAnnotation:annotation];
/**
 *设定地图中心点坐标
 *@param coordinate 要设定的地图中心点坐标，用经纬度表示
 *@param animated 是否采用动画效果
*/
    [_mapView setCenterCoordinate:coor animated:YES];
    
    
    NSArray * title = @[@"全景",@"公交",@"地铁"];
    NSArray * image = @[@"iconfont_chakanquanjing",@"iconfont_gongjiaochaxun",@"iconfont_ditie"];
    for (int j = 0; j < title.count; j ++) {
        
        //在线咨询
        TabButton *chatButton = [[TabButton alloc] initWithFrame:CGRectMake(viewWidth-55, j*70+(viewHeight/2), 40, 60)];
        chatButton.backgroundColor = [UIColor blackColor];
        chatButton.alpha = 0.7;
        chatButton.tag = 200+j;
        chatButton.layer.cornerRadius = 5;
        chatButton.clipsToBounds = YES;
        chatButton.titleLabel.font = littleFont;
        chatButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        chatButton.isLittle = YES;
        [chatButton setTitle:title[j] forState:UIControlStateNormal];
        [chatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [chatButton setImage:[UIImage imageNamed:image[j]] forState:UIControlStateNormal];
        [chatButton addTarget:self action:@selector(chatButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:chatButton];
        
    }
    
    
}

#pragma mark -- 按钮点击事件
-(void)chatButtonClick:(TabButton *)btn{
    
    switch (btn.tag) {
        case 200:
        {
            PanoShowViewController * psVC = [[PanoShowViewController alloc] init];
            psVC.titleTStr = _titleTStr;
            psVC.showType = PanoShowTypeGEO;
            psVC.latitude = _latitude;
            psVC.longitude = _longitude;
            [self.navigationController pushViewController:psVC animated:YES];
        }
            break;
        case 201:
        {
            i = 0;
            //初始化检索对象
            _searcher =[[BMKPoiSearch alloc]init];
            _searcher.delegate = self;
            //发起检索
            BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
            option.pageIndex = 0;
            option.pageCapacity = 10;
            option.location = CLLocationCoordinate2DMake([_latitude floatValue], [_longitude floatValue]);//{39.915, 116.404}
            option.keyword = @"公交";
            BOOL flag = [_searcher poiSearchNearBy:option];
            
            if(flag)
            {
                NSLog(@"周边检索发送成功");
            }
            else
            {
                NSLog(@"周边检索发送失败");
            }
        }
            break;
        default:
        {
            i = 100;
            //初始化检索对象
            _searcher =[[BMKPoiSearch alloc]init];
            _searcher.delegate = self;
            //发起检索
            BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
            option.pageIndex = 0;
            option.pageCapacity = 10;
            option.location = CLLocationCoordinate2DMake([_latitude floatValue], [_longitude floatValue]);//{39.915, 116.404}
            option.keyword = @"地铁";
            BOOL flag = [_searcher poiSearchNearBy:option];
            
            if(flag)
            {
                NSLog(@"周边检索发送成功");
            }
            else
            {
                NSLog(@"周边检索发送失败");
            }
        }
            break;
    }
}

//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    // 清除屏幕中所有的annotation
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        //NSLog(@"正常结果 %@",poiResultList.poiInfoList);
        if (searcher == _searcher) {
            
            
            for (BMKPoiInfo * info in poiResultList.poiInfoList) {
                
                
                //BMKPoiInfo * info;
                NSLog(@"%@",info.name);
                NSLog(@"%f -- %f",info.pt.latitude,info.pt.longitude);
                annotation1 = [[BMKPointAnnotation alloc]init];
                
                CLLocationCoordinate2D coor;
                coor.latitude = info.pt.latitude;//39.915;//
                coor.longitude = info.pt.longitude;//116.404; //
                annotation1.coordinate = coor;
                annotation1.title = info.name;
                [_mapView addAnnotation:annotation1];
               
            }
            
        }else if (searcher == _searcher1){
            
            for (BMKPoiInfo * info in poiResultList.poiInfoList) {
                
                NSLog(@"%@",info.name);
                NSLog(@"%f -- %f",info.pt.latitude,info.pt.longitude);
                annotation2 = [[BMKPointAnnotation alloc]init];
                CLLocationCoordinate2D coor;
                coor.latitude = info.pt.latitude;//39.915;//
                coor.longitude = info.pt.longitude;//116.404; //
                annotation2.coordinate = coor;
                annotation2.title = info.name;
                [_mapView addAnnotation:annotation2];
            }
            
        }
        
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"起始点有歧义" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        NSLog(@"抱歉，未找到结果");
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"抱歉，未找到结果" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    //[self createView];
}

// 根据anntation生成对应的View  大头针
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = [NSString stringWithFormat:@"renameMark%d",i];
    
    newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    // 设置颜色
    ((BMKPinAnnotationView*)newAnnotation).pinColor = BMKPinAnnotationColorPurple;
    // 从天上掉下效果
    ((BMKPinAnnotationView*)newAnnotation).animatesDrop = YES;
    // 设置可拖拽
    ((BMKPinAnnotationView*)newAnnotation).draggable = YES;
    
    if (annotation == annotation1) {
        
        //设置大头针图标
        ((BMKPinAnnotationView*)newAnnotation).image = [UIImage imageNamed:@"icon-bus"];
    }else if(annotation == annotation2){
    
        //设置大头针图标
        ((BMKPinAnnotationView*)newAnnotation).image = [UIImage imageNamed:@"icon-subway"];
    }else{
    
        //设置大头针图标
        ((BMKPinAnnotationView*)newAnnotation).image = [UIImage imageNamed:@"icon-subway"];
    }
    
    
    UIView *popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    //设置弹出气泡图片
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg-map-tip1"]];
    image.frame = CGRectMake(0, 0, 100, 40);
    [popView addSubview:image];
    //自定义显示的内容
    UILabel *driverName = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 100, 20)];
    driverName.text = annotation.title;
    driverName.backgroundColor = [UIColor clearColor];
    driverName.font = [UIFont systemFontOfSize:14];
    driverName.textColor = [UIColor whiteColor];
    driverName.textAlignment = NSTextAlignmentCenter;
    [popView addSubview:driverName];
    
//    UILabel *carName = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, 100, 20)];
//    carName.text = @"京A123456";
//    carName.backgroundColor = [UIColor clearColor];
//    carName.font = [UIFont systemFontOfSize:14];
//    carName.textColor = [UIColor whiteColor];
//    carName.textAlignment = NSTextAlignmentCenter;
//    [popView addSubview:carName];
    BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc]initWithCustomView:popView];
    pView.frame = CGRectMake(0, 0, 100, 40);
    ((BMKPinAnnotationView*)newAnnotation).paopaoView = nil;
    ((BMKPinAnnotationView*)newAnnotation).paopaoView = pView;
    i++;
    return newAnnotation;
    
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
