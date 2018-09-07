//
//  AppDelegate.m
//  sdd_iOS_personal
//  g
//  Created by hua on 15/4/3.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "AppDelegate.h"
#import "IndexViewController.h"
#import "SDD_IssueMainViewController.h"
#import "ReservationIndexViewController.h"
#import "PersonalViewController.h"
#import "GlobalController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "MobClick.h"
#import "AppDelegate+EaseMob.h"
#import "NewFeatureViewController.h"
#import "ShareHelper.h"
#import "UIImageView+WebCache.h"
#import "NewPublishViewController.h"
#import "NewReservationIndexViewController.h"

@interface AppDelegate ()<BMKGeneralDelegate>{
    
    
    BMKMapManager *_mapManager;
    UIImageView *LaunchImage;
}
@property (nonatomic,strong)NSMutableDictionary *dic;
@property (nonatomic,strong)NSMutableArray *apsArr;
@end

@implementation AppDelegate

- (NSMutableDictionary *)dic{
    
    if (_dic == nil) {
        _dic = [[NSMutableDictionary alloc] init];
    }
    return _dic;
}
-(NSMutableArray *)apsArr{
    
    if (_apsArr == nil) {
        _apsArr = [[NSMutableArray alloc] init];
    }
    
    return _apsArr;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    /*------    初始化环信SDK，详细内容在AppDelegate+EaseMob.m 文件中   ------*/
    _connectionState = eEMConnectionConnected;
    // 初始化环信SDK，详细内容在AppDelegate+EaseMob.m 文件中
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
        
    [self loginStateChange:nil];
    
    
    //第一次打开记录
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
    
    
    /*------    沙盒路径   ------*/
    NSLog(@"沙盒路径:%@",NSHomeDirectory());
    // 获取当前的系统语言设置
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLanguage = [languages objectAtIndex:0];
//    NSLog(@"%@",currentLanguage);
    
    /*------    设置用户语言为当前系统语言   ------*/
    [defaults setObject:currentLanguage forKey:@"user_lang_string"];
    
    /*------    ShareSDK   ------*/
    [ShareSDK registerApp:@"771f01a5ecc2"];
    
//    [ShareSDK registerApp:@"api20"];//字符串api20为您的ShareSDK的AppKey
//    
//#pragma mark -- 分享修改
//    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
//                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
//                             redirectUri:@"http://www.sharesdk.cn"];
    [ShareHelper setupShareSdk];    
    
    /*------    百度地图   ------*/
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    // 团队版证书用的百度地图key UYRsUS8wyxFKv3suYgIxEGdG
//   企业 3fpLkAYppwhpp57Tz29chk5712
    BOOL ret = [_mapManager start:@"UYRsUS8wyxFKv3suYgIxEGdG"  generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    /*------    MiPush   ------*/
//    [MiPushSDK registerMiPush:self];
    [MiPushSDK registerMiPush:self type:0];
    
    /*------    友盟统计   ------*/
    [MobClick startWithAppkey:@"554c967967e58e2ddc00211e" reportPolicy:BATCH channelId:@"自有"];
    //    [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
    //    [MobClick setCrashReportEnabled:YES];
    //    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    //    [MobClick setAppVersion:version];
    
    
    
    /*------    广告页   ------*/
    
    LaunchImage = [[UIImageView alloc] init];
    LaunchImage.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    LaunchImage.image = [UIImage imageNamed:@"Default-568h"];
    [self.window addSubview:LaunchImage];
    
    UIImageView *adImage = [[UIImageView alloc] init];
    adImage.frame = CGRectMake(0, 0, viewWidth, viewHeight);//74-74*MULTIPLE
    adImage.contentMode = UIViewContentModeScaleAspectFill;
    [LaunchImage addSubview:adImage];
    
    AFHTTPRequestOperationManager *_httpManager = [AFHTTPRequestOperationManager manager];
    _httpManager.requestSerializer.timeoutInterval = 3;         //设置超时时间
    _httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
    _httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    _httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString *str = [SDD_MainURL stringByAppendingString:@"/appAd/getLast.do"];              // 拼接主路径和请求内容成完整url
    
    [_httpManager POST:str parameters:@{@"type":@1} success:^(AFHTTPRequestOperation *operation, id responseObject) {


        if (![responseObject[@"data"] isEqual:[NSNull null]]) {
            if ([responseObject[@"data"] count]>0) {
                
                [adImage sd_setImageWithURL:[NSURL URLWithString:responseObject[@"data"][0][@"url"]]];
                [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(removeLaunch) userInfo:nil repeats:NO];
                
                
            }
            else {
                
                [self loadRootViewController];
            }
        }
        else {

            [self loadRootViewController];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
//        [self LoadFailedViewController];
        [self loadRootViewController];
        NSLog(@"错误 -- %@", error);
    }];
    
    
    /*------    检测登录状态   ------*/
    
    [GlobalController checkStatus];
    
    
    return YES;
}


#pragma mark -- 最新版本下载
-(void)DownloadTheLatestVersion{

    AFHTTPRequestOperationManager *_httpManager = [AFHTTPRequestOperationManager manager];
    _httpManager.requestSerializer.timeoutInterval = 3;         //设置超时时间
    _httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
    _httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
    _httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    NSString *str = [SDD_MainURL stringByAppendingString:@"/downloadAppLog/add.do"];              // 拼接主路径和请求内容成完整url
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    [_httpManager POST:str parameters:@{@"appVersionName":app_Version,@"clientSystemType":@2,@"appType":@0} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        NSLog(@"错误 -- %@", error);
    }];
}

- (void)removeLaunch{
    
    [LaunchImage removeFromSuperview];
    [self loadRootViewController];
}

#pragma mark -- 加载失败
-(void)LoadFailedViewController{

    UIView * view1 = [[UIView alloc] initWithFrame:self.window.bounds];
    view1.backgroundColor = [UIColor whiteColor];
    [self.window addSubview:view1];
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"icon_duanwang"];
    [view1 addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(view1.mas_top).with.offset(100);
        make.centerX.equalTo(view1);
        make.size.mas_equalTo(CGSizeMake(100, 80));
    }];
    
    UILabel * titlabel = [[UILabel alloc] init];
    titlabel.text = @"世界上最遥远的距离就是没有网\n点击屏幕重新加载";
    titlabel.textAlignment = NSTextAlignmentCenter;
    titlabel.numberOfLines = 0;
    titlabel.textColor = lgrayColor;
    [view1 addSubview:titlabel];
    [titlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(imageView.mas_bottom).with.offset(20);
        make.left.equalTo(view1.mas_left).with.offset(0);
        make.right.equalTo(view1.mas_right).with.offset(0);
        make.height.equalTo(@80);
    }];
}

- (void)loadRootViewController{
    
    /*------    加载主视图   ------*/
    
    NSString *key = (NSString *)kCFBundleVersionKey;
    NSString *kVersion = [NSBundle mainBundle].infoDictionary[key];
    NSString *saveVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if ([kVersion isEqualToString:saveVersion]) {
        //不是第一次使用这个版本,直接到主页
        [self toMainView];
    }
    else{
        
        [[NSUserDefaults standardUserDefaults] setObject:kVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        /*-------- 记录下载量 -------*/
        [self DownloadTheLatestVersion];
        
        self.window.rootViewController = [[NewFeatureViewController alloc] init];
    }
}

- (void)toMainView{
    
    // nav & status
    [[UINavigationBar appearance] setBackgroundImage:[Tools_F imageWithColor:mainTitleColor
                                                                        size:CGSizeMake(viewWidth*2, 64*2)]
                                       forBarMetrics: UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // tab
    IndexViewController *index = [[IndexViewController alloc] init];
    //ReservationIndexViewController *reservation = [[ReservationIndexViewController alloc] init];
    NewReservationIndexViewController *reservation = [[NewReservationIndexViewController alloc] init];
    NewPublishViewController *issueVC = [[NewPublishViewController alloc] init];
    PersonalViewController *personal = [[PersonalViewController alloc] init];
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithObjects:index,reservation,issueVC,personal, nil];
    NSArray *viewControllersTitle   = @[@"首页",@"预约",@"发布",@"我的"];
    NSArray *unSelecterIcon         = @[@"tabbar_item_index_unSelected",@"tabbar_item_book_unSelected",
                                        @"tabbar_item_issue_unSelected",@"tabbar_item_mine_unSelected"];
    NSArray *selecterIcon           = @[@"tabbar_item_index_selected",@"tabbar_item_book_selected",
                                        @"tabbar_item_issue_selected",@"tabbar_item_mine_selected"];
    
    NSMutableArray *nav_vc = [NSMutableArray array];
    
    // tabbar内容
    for (int i = 0 ; i < 4; i++ ) {
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[viewControllers objectAtIndex:i]];
        
        // 适配ios7以上版本
        if (iOS_version >= 7.0){
            nav.navigationBar.translucent = NO;
        }
        
        // 未选中
        UIImage *unSelectedimage = [UIImage imageNamed:[unSelecterIcon objectAtIndex:i]];
        // 设置选中时的图标
        UIImage *selectedImage = [UIImage imageNamed:[selecterIcon objectAtIndex:i]];
        // 设置选中图片用原图(别渲染)
        selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        unSelectedimage = [unSelectedimage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        // 关联
        nav.tabBarItem = [[UITabBarItem alloc]initWithTitle:[viewControllersTitle objectAtIndex:i] image:unSelectedimage selectedImage:selectedImage];
        [nav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:dblueColor, NSForegroundColorAttributeName,nil]
                                      forState:UIControlStateSelected];        // 选中时红色
        [nav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:lgrayColor, NSForegroundColorAttributeName,nil]
                                      forState:UIControlStateNormal];          // 未选中颜色
  
        
        [nav_vc addObject:nav];
    }
    // 标签栏视图控制器
    UITabBarController *tab = [[UITabBarController alloc]init];
    tab.viewControllers = nav_vc;
    tab.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;         //跳转方式
    
    // tabbar背景白色
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 49)];
    backView.backgroundColor = [UIColor whiteColor];
    [tab.tabBar insertSubview:backView atIndex:0];
    tab.tabBar.opaque = YES;
    
    self.window.rootViewController = tab;
}

#pragma mark - UIApplicationDelegate0
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    // 注册APNS成功, 注册deviceToken
    NSLog(@"APNS token: %@",[deviceToken description]);
    [MiPushSDK bindDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err{
    // 注册APNS失败
    // 自行处理
    NSLog(@"APNS error: %@", err);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    NSLog(@"Receive msg :%@",userInfo);

//    //创建通知
//    NSNotification *notification =[NSNotification notificationWithName:@"tuisong" object:userInfo];
//    //通过通知中心发送通知
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
//    [MiPushSDK handleReceiveRemoteNotification:userInfo];
    
    
    
    [self.apsArr insertObject:userInfo atIndex:0];
    
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    //    [userDefaults setObject:userInfo[@"aps"][@"alert"] forKey:@"MiPushTitle"];
    //    [userDefaults setObject:userInfo[@"custom_content"] forKey:@"MiPushMessage"];
    [userDefaults setObject:self.apsArr forKey:@"MiPushArr"];
    [userDefaults synchronize];
    
    if (![userInfo[@"custom_content"] isEqual:[NSNull null]]) {
        NSDictionary *dic = [Tools_F dictionaryWithJsonString:userInfo[@"custom_content"]];
        
        int type = [dic[@"type"] intValue];
        switch (type) {
            case -1:
                [self showAlert:dic[@"other"]];
                break;
                
            case 1:
            {
                [self showAlert:dic[@"other"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"certify" object:dic[@"other"]];
            }
                break;
            case -2:
                [self showAlert:dic[@"other"]];
                break;
            case 2:
            {
                [self showAlert:dic[@"other"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"certify" object:dic[@"other"]];
            }
                break;
            case -3:
                [self showAlert:dic[@"other"]];
                break;
            case 3:
            {
                [self showAlert:dic[@"other"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"certify" object:dic[@"other"]];
            }
                break;
            case 4:
            {
                NSString *jsonContent = dic[@"other"];
                NSDictionary *dict = [Tools_F dictionaryWithJsonString:jsonContent];
                [self showAlert:dict[@"content"]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"states" object:nil userInfo:dict];
            }
                break;
            case 101:
            {
                //                GRDetailViewController *gvc = [[GRDetailViewController alloc] init];
                //                gvc.houseID = dic[@"id"];
                
                //                [_tab.navigationController pushViewController:gvc animated:YES];
                //                self.window.rootViewController = gvc;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"presentVC" object:nil userInfo:dic];
                
                
            }
                
                break;
            case 102:
            {
                //                BrandDetailViewController *bvc = [[BrandDetailViewController alloc] init];
                //                bvc.brandID = dic[@"id"];
                //                [_tab.navigationController pushViewController:bvc animated:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"presentVC" object:nil userInfo:dic];
            }
                break;
                
            default:
                break;
        }
        
        NSLog(@"%@",dic);
        
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [BMKMapView willBackGround];
}

#pragma mark - 强制竖屏
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [BMKMapView didForeGround];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Memory management
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

#pragma mark - 百度地图
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

#pragma mark - 支付宝
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    //跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService]
         processOrderWithPaymentResult:url
         standbyCallback:^(NSDictionary *resultDic) {
             NSLog(@"result = %@", resultDic);
         }];
    }
    
    //shareSDK
    BOOL result = [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
    
    return result;
}

#pragma mark - 登陆状态改变
- (void)loginStateChange:(NSNotification *)notification{
    
    BOOL isAutoLogin = [[[EaseMob sharedInstance] chatManager] isAutoLoginEnabled];
    BOOL loginSuccess = [notification.object boolValue];
    
    if (isAutoLogin || loginSuccess) { //登陆成功加载主窗口控制器
        
        NSLog(@"环信自动登录成功");
    }
    else { //登陆失败加载登陆页面控制器
        
        NSLog(@"非自动登录状态");
    }
}

#pragma mark -- 必选的没选提示按钮
- (void)showAlert:(NSString *) _message{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}
- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}

@end
