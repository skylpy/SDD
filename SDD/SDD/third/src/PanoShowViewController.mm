
//
//  PanoShowViewController.m
//  PanoramaViewDemo
//
//  Created by baidu on 15/4/10.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "PanoShowViewController.h"
#import "BaiduPanoramaView.h"
#import "BaiduPanoUtils.h"
#import "PanNewShowViewController.h"
@interface PanoShowViewController ()<BaiduPanoramaViewDelegate,BMKMapViewDelegate>
{
    BMKMapView* _mapView ;
    BMKPinAnnotationView* newAnnotation;
    NSInteger  index;
    
    PanNewShowViewController * PanNewShowView;
}
@property(strong, nonatomic) BaiduPanoramaView  *panoramaView;
@property(strong, nonatomic) UITextField *panoPidTF;
@property(strong, nonatomic) UITextField *panoCoorXTF;
@property(strong, nonatomic) UITextField *panoCoorYTF;


//滑动手势
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;

@end

@implementation PanoShowViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self showPanoViewWithLon:[_longitude doubleValue] lat:[_latitude doubleValue]];
    [_mapView viewWillAppear];
    
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav:@"全景图"];
    
    
    [self customPanoView];
    [self customInputView];
    [self showPanoViewWithPID:@"01002200001309101607372275K"];
    
    
    [self showPanoViewWithLon:[_longitude doubleValue] lat:[_latitude doubleValue]];

    [self createView];
    
//    PanNewShowView = [[PanNewShowViewController alloc] init];
//    PanNewShowView.view.frame = CGRectMake(0, 40, viewWidth, viewHeight - 40 - 64);
//    PanNewShowView.view.alpha = 0.5;
//    [self addChildViewController:PanNewShowView];
//    
//    [self.view addSubview:PanNewShowView.view];
//    [PanNewShowView showLoadfailedWithaction:@selector(handleSwipes:)];
//    PanNewShowViewController * PanNewShowView = [[PanNewShowViewController alloc] init];
//    
//    
//    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
//    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
//    
//    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
//    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
//    
//    [PanNewShowView addGestureRecognizer:self.leftSwipeGestureRecognizer];
//    [PanNewShowView addGestureRecognizer:self.rightSwipeGestureRecognizer];
    
}


-(void)createView{
    
    _mapView = [[BMKMapView alloc]init];
    _mapView.frame = CGRectMake(10, viewHeight-194, 130, 130);
    _mapView.delegate = self;
    _mapView.showMapScaleBar = YES;
    _mapView.mapScaleBarPosition = CGPointMake(10, 90);
    [self.view addSubview:_mapView];
    _mapView.zoomLevel = 15.0;
    index = 1;
    
//    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slidePanAction:)];
//    [self.panoramaView addGestureRecognizer:panRecognizer];
    
    
    UITapGestureRecognizer * mapTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTapClick:)];
    [_mapView addGestureRecognizer:mapTap];
    
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
    
    
}
- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    NSLog(@"尼玛的, 你在往左边跑啊....");

}
- (void)slidePanAction:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.panoramaView];
    
    NSLog(@"%f",translation.x);

}
/**
 *设置标注的坐标，在拖拽时会被调用.
 *@param newCoordinate 新的坐标值
 */
//- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate{
//
//    [self.panoramaView removeOverlay:@"12345"];
//    // 清除屏幕中所有的annotation
////    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
////    [_mapView removeAnnotations:array];
//
//    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
//    CLLocationCoordinate2D coor;
//    coor.latitude = newCoordinate.latitude;//39.915;//
//    coor.longitude = newCoordinate.longitude;//116.404; //
//    annotation.coordinate = coor;
//    //annotation.title = _titleTStr;
//    [_mapView addAnnotation:annotation];
//    [self showPanoViewWithLon:newCoordinate.longitude lat:newCoordinate.latitude];
//}
/**
 *长按地图时会回调此接口
 *@param mapview 地图View
 *@param coordinate 返回长按事件坐标点的经纬度
 */
//- (void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate{
//    
//    [self.panoramaView removeOverlay:@"12345"];
//    // 清除屏幕中所有的annotation
//    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
//    [_mapView removeAnnotations:array];
//    
//    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
//    CLLocationCoordinate2D coor;
//    coor.latitude = coordinate.latitude;//39.915;//
//    coor.longitude = coordinate.longitude;//116.404; //
//    annotation.coordinate = coor;
//    //annotation.title = _titleTStr;
//    [_mapView addAnnotation:annotation];
//    [self showPanoViewWithLon:coordinate.longitude lat:coordinate.latitude];
//}

/**
 *拖动annotation view时，若view的状态发生变化，会调用此函数。ios3.2以后支持
 *@param mapView 地图View
 *@param view annotation view
 *@param newState 新状态
 *@param oldState 旧状态
 */
- (void)mapView:(BMKMapView *)mapView annotationView:(BMKAnnotationView *)view didChangeDragState:(BMKAnnotationViewDragState)newState
   fromOldState:(BMKAnnotationViewDragState)oldState{
    
    [self.panoramaView removeOverlay:@"12345"];
#pragma mark -- 拖动大头针的时候调用
    CLLocationCoordinate2D coor = [view.annotation coordinate];
    [self showPanoViewWithLon:coor.longitude lat:coor.latitude];
}


-(void)mapTapClick:(UITapGestureRecognizer *)tap{
    
    index *= -1;
    if (index == -1) {
        
        _mapView.frame = CGRectMake(10, viewHeight-194, viewWidth-20, 130);
    }else{
    
        _mapView.frame = CGRectMake(10, viewHeight-194, 130, 130);
    }
    
}

// 根据anntation生成对应的View  大头针
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = [NSString stringWithFormat:@"renameMark"];
    
    newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    // 设置颜色
    ((BMKPinAnnotationView*)newAnnotation).pinColor = BMKPinAnnotationColorPurple;
    // 从天上掉下效果
    ((BMKPinAnnotationView*)newAnnotation).animatesDrop = NO;
    // 设置可拖拽
    ((BMKPinAnnotationView*)newAnnotation).draggable = YES;
    
    //设置大头针图标
    ((BMKPinAnnotationView*)newAnnotation).image = [UIImage imageNamed:@"icon-camera"];
    
    
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
    
    BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc]initWithCustomView:popView];
    pView.frame = CGRectMake(0, 0, 100, 40);
    ((BMKPinAnnotationView*)newAnnotation).paopaoView = nil;
    ((BMKPinAnnotationView*)newAnnotation).paopaoView = pView;
    
    return newAnnotation;
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.panoramaView.delegate = nil;
    
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}
- (void)dealloc {
    [self.panoramaView removeFromSuperview];
    self.panoramaView = nil;
}
- (void)customInputView {
    
    
    BaiduPanoLabelOverlay *textOverlay = [[BaiduPanoLabelOverlay alloc] init];
    textOverlay.overlayKey = @"12345";
    textOverlay.coordinate = CLLocationCoordinate2DMake([_latitude doubleValue], [_longitude doubleValue]);
    
    textOverlay.height         = 10.0f;
    
    
    // 背景颜色
    textOverlay.backgroundColor = dblueColor;
    // 字体颜色
    textOverlay.textColor = [UIColor whiteColor];
    //textOverlay.type = BaiduPanoOverlayTypeImage;
    textOverlay.fontSize  = 10;
    // 支持换行
    textOverlay.text      = _titleTStr;
    // 边缘距
    textOverlay.edgeInsets = UIEdgeInsetsMake(2, 3, 4, 5);
    [self.panoramaView addOverlay:textOverlay];
    
    
//    BaiduPanoImageOverlay *imageOverlay = [[BaiduPanoImageOverlay alloc] init];
//    imageOverlay.overlayKey = @"12345";
//    imageOverlay.coordinate = CLLocationCoordinate2DMake([_latitude doubleValue], [_longitude doubleValue]);
//    imageOverlay.height         = 100;
//    imageOverlay.size = CGSizeMake(200, 50);
//    imageOverlay.image = [UIImage imageNamed:@"bg-map-tiptt1"];
//    
//    [self.panoramaView addOverlay:imageOverlay];
    

}


- (void)customPanoView {
    
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth([self getFixedScreenFrame]), CGRectGetHeight([self getFixedScreenFrame]));
     //h32BfIVTwddG8P68o2gGoCHL
    // key 为在百度LBS平台上统一申请的接入密钥ak 字符串
    self.panoramaView = [[BaiduPanoramaView alloc] initWithFrame:frame key:@"UYRsUS8wyxFKv3suYgIxEGdG"];
    // 为全景设定一个代理
    self.panoramaView.delegate = self;
    self.panoramaView.userInteractionEnabled = YES;
    [self.view addSubview:self.panoramaView];
    // 设定全景的清晰度， 默认为middle
    [self.panoramaView setPanoramaImageLevel:ImageDefinitionMiddle];
    // 设定全景的pid， 这是指定显示某地的全景，也可以通过百度坐标进行显示全景
    //[self.panoramaView setPanoramaWithPid:@"01002200001309101607372275K"];
    UITapGestureRecognizer * mapTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    [self.panoramaView addGestureRecognizer:mapTap];
    
}

#pragma mark -- 通过pid获取
- (void)showPanoViewWithPID:(NSString *)pid {
    [self.panoramaView setPanoramaWithPid:pid];
}

#pragma mark -- 通过地理坐标获取
- (void)showPanoViewWithLon:(double)lon lat:(double)lat {
    [self.panoramaView setPanoramaWithLon:lon lat:lat];
}

#pragma mark -- 通过百度坐标获取
- (void)showPanoViewWithX:(int)x Y:(int)y {
    [self.panoramaView setPanoramaWithX:x Y:y];
}

- (void)refreshPanoViewData {
    if (self.showType == PanoShowTypePID) {
        if (self.panoPidTF.text.length>0) {
            [self showPanoViewWithPID:self.panoPidTF.text];
        }
        [self.panoPidTF resignFirstResponder];
    }else if (self.showType == PanoShowTypeGEO) {
        if (self.panoCoorXTF.text.length>0 && self.panoCoorYTF.text.length>0) {
            [self showPanoViewWithLon:[self.panoCoorXTF.text doubleValue] lat:[self.panoCoorYTF.text doubleValue]];
        }
        [self.panoCoorXTF resignFirstResponder];
        [self.panoCoorYTF resignFirstResponder];
    }else {
        if (self.panoCoorXTF.text.length>0 && self.panoCoorYTF.text.length>0) {
            [self showPanoViewWithX:[self.panoCoorXTF.text intValue] Y:[self.panoCoorYTF.text intValue]];
        }
        [self.panoCoorXTF resignFirstResponder];
        [self.panoCoorYTF resignFirstResponder];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - panorama view delegate

- (void)panoramaWillLoad:(BaiduPanoramaView *)panoramaView {
   
}

- (void)panoramaDidLoad:(BaiduPanoramaView *)panoramaView descreption:(NSString *)jsonStr {
    
}


- (void)panoramaLoadFailed:(BaiduPanoramaView *)panoramaView error:(NSError *)error {

}

- (void)panoramaView:(BaiduPanoramaView *)panoramaView overlayClicked:(NSString *)overlayId {
  
}

#pragma mark - other func 
- (UIButton *)createButton:(NSString *)title target:(SEL)selector frame:(CGRect)frame {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        [button setBackgroundColor:[UIColor whiteColor]];
    }else {
        [button setBackgroundColor:[UIColor clearColor]];
    }
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

//获取设备bound方法
- (BOOL)isPortrait {
    UIInterfaceOrientation orientation = [self getStatusBarOritation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return YES;
    }
    return NO;
}
- (UIInterfaceOrientation)getStatusBarOritation {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    return orientation;
}
- (CGRect)getFixedScreenFrame {
    CGRect mainScreenFrame = [UIScreen mainScreen].bounds;
#ifdef NSFoundationVersionNumber_iOS_7_1
    if(![self isPortrait]&& (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1)) {
        mainScreenFrame = CGRectMake(0, 0, mainScreenFrame.size.height, mainScreenFrame.size.width);
    }
#endif
    return mainScreenFrame;
    
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
