//
//  PanoDataViewController.m
//  PanoramaViewDemo
//
//  Created by baidu on 15/4/13.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "PanoDataViewController.h"
#import "BaiduPanoramaView.h"
#import "BaiduPanoDataFetcher.h"
#import "BaiduPoiPanoData.h"
#import "BaiduLocationPanoData.h"
@interface PanoDataViewController ()<BaiduPanoramaViewDelegate>

@property(strong, nonatomic) BaiduPanoramaView  *panoramaView;

@end

@implementation PanoDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"获取全景图数据";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self customPanoView];
    CGFloat offsety = 20;
    CGRect btnFrame = CGRectMake(60, offsety, 200, 30);
    UIButton *btn = [self createButton:@"根据POI获取" target:@selector(onGetDataButtonClicked:) frame:btnFrame];
    btn.tag = 0;
    [self.view addSubview:btn];
    offsety += 40;
    CGRect btnFrame1 = CGRectMake(60, offsety, 200, 30);
    UIButton *btn1 = [self createButton:@"根据经纬度获取" target:@selector(onGetDataButtonClicked:) frame:btnFrame1];
    btn1.tag = 1;
    [self.view addSubview:btn1];
    offsety += 40;
    CGRect btnFrame2 = CGRectMake(60, offsety, 200, 30);
    UIButton *btn2 = [self createButton:@"根据墨卡托获取" target:@selector(onGetDataButtonClicked:) frame:btnFrame2];
    btn2.tag = 2;
    [self.view addSubview:btn2];
    offsety += 40;
    CGRect btnFrame3 = CGRectMake(60, offsety, 200, 30);
    UIButton *btn3 = [self createButton:@"获取室内信息" target:@selector(onGetDataButtonClicked:) frame:btnFrame3];
    btn3.tag = 3;
    [self.view addSubview:btn3];
    offsety += 40;
    CGRect btnFrame4 = CGRectMake(60, offsety, 200, 30);
    UIButton *btn4 = [self createButton:@"获取周边推荐服务信息" target:@selector(onGetDataButtonClicked:) frame:btnFrame4];
    btn4.tag = 4;
    [self.view addSubview:btn4];
}

- (void)dealloc {
    self.panoramaView.delegate = nil;
}


- (void)onGetDataButtonClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 0: {
            // 根据POI 的唯一ID获取全景数据
            BaiduPoiPanoData *data = [BaiduPanoDataFetcher requestPanoramaInfoWithUid:@"5c2dc21d1edf15046ec02caa"];
            
        }
            break;
        case 1: {
             BaiduLocationPanoData *data = [BaiduPanoDataFetcher requestPanoramaInfoWithLon:116.4034 Lat:39.914134];
        }
            break;
        case 2: {
             BaiduLocationPanoData *data = [BaiduPanoDataFetcher requestPanoramaInfoWithX:12948170 Y:4845075];
        }
            break;
        case 3: {
            NSString *jsonStr = [BaiduPanoDataFetcher requestPanoramaIndoorDataWithIid:@"13daddcacb839f158605bf0e"];
        }
            break;
        case 4: {
            NSString *jsonStr = [BaiduPanoDataFetcher requestPanoramaRecommendationServiceDataWithPid:@"1000220000150113115957235IN"];
            
        }
            break;
        default:
            break;
    }
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



- (void)customPanoView {
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth([self getFixedScreenFrame]), CGRectGetHeight([self getFixedScreenFrame]));
    
    // key 为在百度LBS平台上统一申请的接入密钥ak 字符串
    self.panoramaView = [[BaiduPanoramaView alloc] initWithFrame:frame key:@"h32BfIVTwddG8P68o2gGoCHL"];
    // 为全景设定一个代理
    self.panoramaView.delegate = self;
    [self.view addSubview:self.panoramaView];
    // 设定全景的清晰度， 默认为middle
    [self.panoramaView setPanoramaImageLevel:ImageDefinitionMiddle];
    // 设定全景的pid， 这是指定显示某地的全景，也可以通过百度坐标进行显示全景
    [self.panoramaView setPanoramaWithUid:@"5c2dc21d1edf15046ec02caa" type:BaiduPanoramaTypeInterior];
//    [self.panoramaView setPanoramaWithPid:@"28e700f15aae5418085cb3a7"];
    
}

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
