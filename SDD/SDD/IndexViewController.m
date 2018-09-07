//
//  IndexViewController.m
//  sdd_iOS_personal
//
//  Created by hua on 15/4/3.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "IndexViewController.h"
#import "HouseResourcesModel.h"
#import "RegionSelectButton.h"
#import "ModuleButton.h"
#import "ServiceButton.h"
#import "PromotionButton.h"
#import "GroupPurchaseTableViewCell.h"

#import "Header.h"
#import "SearchViewController.h"
#import "AreaSelectionViewController.h"
#import "CalculatorsViewController.h"
#import "GPDetailViewController.h"
#import "GroupPurchaseViewController.h"
#import "GroupRentViewController.h"
#import "GroupRentNewViewController.h"
//#import "JoinInViewController.h"
#import "JoinInBeforeViewController.h"
#import "MapViewController.h"
#import "HRDetailViewController.h"
#import "GRDetailViewController.h"
#import "CheckPricesViewController.h"
#import "HouseDetailTitle.h"
#import "CustomIntentionViewController.h"
#import "DDetailViewController.h"
#import "JoinDetailViewController.h"
#import "ConsultViewController.h"
#import "FAQsViewController.h"

#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "NSString+SDD.h"
#import "SDCycleScrollView.h"
#import "PreferentialJoinDetailViewController.h"
#import "CommonBrandViewController.h"

//活动
#import "ActivityViewController.h"

#import "personalTwoViewController.h"

#import "JoinDatailBrandViewController.h"

#import "NewActivityViewController.h"
//地图
#import "SDDMapViewController.h"

#import "DirectNormalViewController.h"
#import "NormalJoinViewController.h"

typedef NS_ENUM(NSInteger, LikeType)
{
    newBuy = 1,
    newRent = 2,
    allResourse = 3,
    dynamic = 4,
    brankJoin = 5
};

@interface IndexViewController ()<UITableViewDataSource,UITableViewDelegate,BMKGeoCodeSearchDelegate,
SDCycleScrollViewDelegate>{
    
    
    /*- ui -*/
    
    // 底部纵向scrollview
    UIScrollView *bottonScrollView;
    // 顶部轮播
    SDCycleScrollView *headScrollView;
    // 热门团购/团租
    UIView *groupPurchase_Bg;
    
    // 团购团租
    UITableView *table;
    HouseDetailTitle *thingLikeTitle;
    UITableView *thingLikeTable;
    UIButton *checkMore;
    
    // 定制背景
    UIView *customization_bg;
    
    /*- data -*/
    
    NSString *currentCity;      // 当前城市
    NSArray *bannerArr;         // banner
    NSArray *adsArr;            // 4广告
    NSInteger regionId;
    
    // 展示团购/团租
    BOOL isHotBrand;
    LikeType likeType;         // 猜你喜欢类型
    
    /*- 定位 -*/
    BMKGeoCodeSearch* geocodesearch;
    

    
}

// 热门团购
@property (nonatomic, strong) NSMutableArray *hotBrandArr;
// 热门团租
@property (nonatomic, strong) NSMutableArray *hotRentArr;
// 猜你喜欢
@property (nonatomic, strong) NSMutableArray *thingYourLikeArr;

@end

@implementation IndexViewController

- (NSMutableArray *)hotBrandArr{
    if (!_hotBrandArr) {
        _hotBrandArr = [[NSMutableArray alloc]init];
    }
    return _hotBrandArr;
}

- (NSMutableArray *)hotRentArr{
    if (!_hotRentArr) {
        _hotRentArr = [[NSMutableArray alloc]init];
    }
    return _hotRentArr;
}

- (NSMutableArray *)thingYourLikeArr{
    if (!_thingYourLikeArr) {
        _thingYourLikeArr = [[NSMutableArray alloc]init];
    }
    return _thingYourLikeArr;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.viewForBaselineLayout.hidden = NO;      //  显示tabar
    locService.delegate = self;
    geocodesearch.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tuisong:) name:@"tuisong" object:nil];
    
    //    注册监听推送通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(presentVC:)
                                                 name:@"presentVC"
                                               object:nil];
    // 刷新数据
    [self requestData];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    locService.delegate = nil;
    geocodesearch.delegate = nil;
    
}

#pragma mark - 设置选择地区
- (void)starLocationIsGPS:(NSInteger )isGPS{
    
    currentCity = [currentCity isEqualToString:@"全国"]?@"中国":currentCity;
    // 参数
    NSDictionary *dic = @{@"regionName":currentCity,@"isGps":[NSNumber numberWithInteger:isGPS]};

    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/region/saveCity.do" params:dic success:^(id JSON) {
        
        NSLog(@"当前定位%@",JSON);
        if (![JSON[@"data"] isEqual:[NSNull null]]) {
            
            regionId = [JSON[@"data"][@"regionId"] integerValue];
            [self requestData];
        }
        else {
            currentCity = @"全国";            // 临时······
        }
        
        // 设置右btn
//        [self setNavRight];
    } failure:^(NSError *error) {
        
        NSLog(@"设置选择地区错误 -- %@", error);
    }];
}

#pragma mark - 请求首页数据
- (void)requestData{
    
    // 广告
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/banner/homeBanners.do" params:nil success:^(id JSON) {
        
//        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        if (![JSON[@"data"] isEqual:[NSNull null]]) {
            
            // 设置顶部轮播
            bannerArr = JSON[@"data"];
            
            NSMutableArray *imageArr = [NSMutableArray array];
            for (NSDictionary *dict in bannerArr) {
                [imageArr addObject:dict[@"bannerImage"]];
            }
            
            headScrollView.imageURLStringsGroup = imageArr;
        }
        
        bottonScrollView.contentSize = CGSizeMake(viewWidth, CGRectGetMaxY(customization_bg.frame)+74);
    } failure:^(NSError *error) {
        
        NSLog(@"请求广告错误 -- %@", error);
    }];
    
    // 热门团租
    [HttpTool postWithBaseURL:SDD_MainURL
                         Path:@"/house/hotList.do"
                       params:@{@"pageNumber":@1,
                                @"pageSize":@5,
                                @"params":@{@"activityCategoryId":@2}
                                }
                      success:^(id JSON) {
                          
//                          NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
                          [_hotRentArr removeAllObjects];
                          if (![JSON[@"data"] isEqual:[NSNull null]]) {
                              for (NSDictionary *tempDic in JSON[@"data"]) {
                                  
                                  HouseResourcesModel *model = [HouseResourcesModel hrWithDict:tempDic];
                                  [self.hotRentArr addObject:model];
                              }
                          }
                          [table reloadData];
                          
                          bottonScrollView.contentSize = CGSizeMake(viewWidth, CGRectGetMaxY(customization_bg.frame)+74);
    } failure:^(NSError *error) {
        
        NSLog(@"请求热门团租错误 -- %@", error);
    }];
    
    
    // 热门品牌
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brand/hotList.do" params:@{@"pageNumber":@1,@"pageSize":@5} success:^(id JSON) {
        
        //NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        [_hotBrandArr removeAllObjects];
        if (![JSON[@"data"] isEqual:[NSNull null]]) {
            for (NSDictionary *tempDic in JSON[@"data"]) {
                
                HouseResourcesModel *model = [HouseResourcesModel hrWithDict:tempDic];
                [self.hotBrandArr addObject:model];
            }
        }
        //NSLog(@"%@",JSON);
        [table reloadData];
        
        bottonScrollView.contentSize = CGSizeMake(viewWidth, CGRectGetMaxY(customization_bg.frame)+74);
    } failure:^(NSError *error) {
        
        NSLog(@"请求热门品牌错误 -- %@", error);
    }];
    
    // 猜你喜欢
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/userCustomize/youLikeList.do" params:nil success:^(id JSON) {
        
//        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSDictionary *dict = JSON[@"data"];
        
        if (![dict[@"data"] isEqual:[NSNull null]]) {
            
            // 猜你喜欢类型
            likeType = [dict[@"type"] integerValue];
            
            [_thingYourLikeArr removeAllObjects];
            for (NSDictionary *tempDic in dict[@"data"]) {
                
                HouseResourcesModel *model = [HouseResourcesModel hrWithDict:tempDic];
                [self.thingYourLikeArr addObject:model];
            }
            
            thingLikeTable.frame = CGRectMake(0, CGRectGetMaxY(thingLikeTitle.frame), viewWidth, _thingYourLikeArr.count<3?_thingYourLikeArr.count*100:300);
            checkMore.frame = CGRectMake(10, CGRectGetMaxY(thingLikeTable.frame)+10, viewWidth-20, 40);
            customization_bg.frame = CGRectMake(10, CGRectGetMaxY(checkMore.frame)+10, viewWidth-20, 80);

            [thingLikeTable reloadData];

            bottonScrollView.contentSize = CGSizeMake(viewWidth, CGRectGetMaxY(customization_bg.frame)+74);
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"请求猜你喜欢错误 -- %@", error);
    }];
}

#pragma mark - 通知
- (void)regionSet:(NSNotification *)notification{
    
    [locService stopUserLocationService];           // 得到城市后停止定位
    currentCity = [notification object];

    // 设置右btn
    [self setNavRight];
    // 请求地区数据
    [self starLocationIsGPS:0];
}

#pragma mark - 设置右btn
- (void)setNavRight{
    
    // 导航条右btn
    RegionSelectButton *site = (RegionSelectButton *)self.navigationItem.titleView;
    CGSize siteSize = [Tools_F countingSize:currentCity fontSize:18*MULTIPLE height:20];
    site.frame = CGRectMake(0, 0, siteSize.width+35, siteSize.height);
    [site setTitle:currentCity forState:UIControlStateNormal];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    currentCity = @"全国";
    // 导航条
    [self setupNav];
    // 定位城市
    [self starLocationIsGPS:0];
    // 设置内容
    [self setupUI];
    // 注册监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(regionSet:)
                                                 name:@"RegionChoose"
                                               object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi" object:nil];
}
#pragma MARK - 接收推送通知
- (void)presentVC:(NSNotification *)noti{
    
    int type = [noti.userInfo[@"type"] intValue];
    
    switch (type) {
        case 101:
        {
            GRDetailViewController *gvc = [[GRDetailViewController alloc] init];
            gvc.houseID = noti.userInfo[@"id"];
            self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
            [self.navigationController pushViewController:gvc animated:YES];
            
        }
            break;
        case 102:
        {
            JoinDetailViewController *jdVC = [[JoinDetailViewController alloc] init];
            jdVC.brandId = noti.userInfo[@"id"];
            self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
            [self.navigationController pushViewController:jdVC animated:YES];
            
        }
            break;
        default:
            break;
    }
    
}
//后台运行的时候打开页面跳转到相应的详情
-(void)tuisong:(NSNotification *)notification{
    
    NSDictionary * notifDic = [notification object];
    
    if ([notifDic[@"custom_content"][@"type"] integerValue] == 101) {
        
        GRDetailViewController *grDetail = [[GRDetailViewController alloc] init];
        grDetail.activityCategoryId = @"2";
        grDetail.houseID = notifDic[@"custom_content"][@"id"];
        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
        [self.navigationController pushViewController:grDetail animated:YES];
        
    }else{
        
        JoinDetailViewController *jdVC = [[JoinDetailViewController alloc] init];
        jdVC.brandId = notifDic[@"custom_content"][@"id"];
        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
        [self.navigationController pushViewController:jdVC animated:YES];
    }
    
}

- (void)tongzhi:(NSNotification *)text{
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                     message:@"去完善个人资料，开启财富之旅吧"
                                                    delegate:self
                                           cancelButtonTitle:@"看看再说"
                                           otherButtonTitles:@"完善资料", nil];
    [alert show];
//    UIAlertView *altertView = [[UIAlertView alloc]init];
//    altertView.alertViewStyle = UIAlertViewStyleDefault;
//    altertView.title = @"提示";
//    
//    altertView.message = @"去完善个人资料，开启财富之旅吧";
//    
//    altertView.delegate = self;
//    
//    //可以不断的按钮，alterView会根据按钮的数量自动布局
//    [altertView addButtonWithTitle:@"看看再说"];
//    
//    [altertView addButtonWithTitle:@"完善资料"];
//    
//    
//    [altertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //根据点击buttonIndex来判断哪个button被点击
    NSLog(@"buttonIndex  ===  %ld",(long)buttonIndex);
    if (buttonIndex == 1) {
        NSLog(@"111111111111111111111");
        personalTwoViewController *viewController = [[personalTwoViewController alloc] init];
        
        [self.navigationController pushViewController:viewController animated:YES];
        
    }
    
}

//#pragma mark - 设置导航条

- (void)setupNav{
    
    // 导航条左
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(0, 0, 20, 20);
    [searchButton setImage:[UIImage imageNamed:@"index_btn_search"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:searchButton];
    
    // 导航条右btn
    RegionSelectButton *site = [RegionSelectButton buttonWithType:UIButtonTypeCustom];
    CGSize siteSize = [Tools_F countingSize:currentCity fontSize:18*MULTIPLE height:20];
    site.frame = CGRectMake(0, 0, siteSize.width+35, siteSize.height);
    site.titleLabel.font = biggestFont;
    site.titleLabel.textAlignment = NSTextAlignmentRight;
    site.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [site setTitle:currentCity forState:UIControlStateNormal];
    [site setImage:[UIImage imageNamed:@"index_btn_downArrow_white"] forState:UIControlStateNormal];
    [site addTarget:self action:@selector(siteAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = site;
    
    // 导航条右
    UIButton *mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mapButton.frame = CGRectMake(0, 0, 20, 20);
    [mapButton setImage:[UIImage imageNamed:@"index_btn_map"] forState:UIControlStateNormal];
    [mapButton addTarget:self action:@selector(mapAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:mapButton];
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
    
    // 底部纵向scrollview
    bottonScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, self.view.frame.size.height)];
    bottonScrollView.delegate = self;
    bottonScrollView.backgroundColor = bgColor;
    [self.view addSubview:bottonScrollView];
    
    headScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, viewWidth, viewWidth/2.15) imageURLStringsGroup:nil];
    headScrollView.autoScrollTimeInterval = 4;
    headScrollView.infiniteLoop = YES;
    headScrollView.delegate = self;
    headScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    headScrollView.dotColor = tagsColor;
    headScrollView.placeholderImage = [UIImage imageNamed:@"placeholder"];
    [bottonScrollView addSubview:headScrollView];
    
    // 四模块背景
    UIView *module_Bg = [[UIView alloc] init];
    module_Bg.frame = CGRectMake(0, CGRectGetMaxY(headScrollView.frame), viewWidth, 160);
    module_Bg.backgroundColor = [UIColor whiteColor];
    [bottonScrollView addSubview:module_Bg];
    
    // 模块点击
    NSArray *module_title = @[@"新项目招商",@"已开业项目",@"品牌加盟",@"资讯",@"问答",@"活动"];
    NSArray *module_img = @[@"index_btn_moduleRent",@"icon_project_release",
                            @"index_btn_moduleBrank",@"index_btn_moduleInfo",
                            @"index_btn_moduleQAS",@"index_btn_moduleActivity"];
    
    for (int i=0; i<6; i++) {
        
        ModuleButton *moduleButton = [[ModuleButton alloc]initWithFrame:CGRectMake((viewWidth/3)*(i%3), 80*(i/3), viewWidth/3, 80)];
        CGSize btnSize = CGSizeMake(viewWidth/3, 80);
        [moduleButton setBackgroundImage:[Tools_F imageWithColor:bgColor size:btnSize] forState:UIControlStateHighlighted];
        moduleButton.icon.image = [UIImage imageNamed:module_img[i]];
        moduleButton.tag = i+200;
        moduleButton.bottomLabel.text = module_title[i];
        [moduleButton addTarget:self action:@selector(moduleClick:) forControlEvents:UIControlEventTouchUpInside];
        [module_Bg addSubview:moduleButton];
    }
    
    // cutoff
    UIView *cutoffA = [[UIView alloc] init];
    cutoffA.frame = CGRectMake(10, 80, viewWidth-20, 1);
    cutoffA.backgroundColor = ldivisionColor;
    [module_Bg addSubview:cutoffA];
    
    UIView *cutoffB = [[UIView alloc] init];
    cutoffB.frame = CGRectMake(viewWidth/3, 10, 1, 140);
    cutoffB.backgroundColor = ldivisionColor;
    [module_Bg addSubview:cutoffB];
    
    UIView *cutoffC = [[UIView alloc] init];
    cutoffC.frame = CGRectMake(viewWidth*2/3, 10, 1, 140);
    cutoffC.backgroundColor = ldivisionColor;
    [module_Bg addSubview:cutoffC];
    
    // 热门团购/热门团租标题
    groupPurchase_Bg = [[UIView alloc] init];
    groupPurchase_Bg.frame = CGRectMake(0, CGRectGetMaxY(module_Bg.frame)+10, viewWidth, 40);
    groupPurchase_Bg.backgroundColor = [UIColor whiteColor];
    [bottonScrollView addSubview:groupPurchase_Bg];
    
    // 团购/团租
    NSArray *groupPurchaseTitle = @[@"热门团租",@"热门品牌"];
    for (int i=0; i<2; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 100, 40);
        btn.center = CGPointMake((viewWidth+i*viewWidth*2)/4, 20);
        btn.tag = 500+i;
        btn.titleLabel.font = largeFont;
        [btn setTitle:groupPurchaseTitle[i] forState:UIControlStateNormal];
        [btn setTitleColor:deepBLack forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"personal_btn_bottonLine_blue"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(indexSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {               // 默认选中1
            btn.selected = YES;
            isHotBrand = NO;
        }
        [groupPurchase_Bg addSubview:btn];
    }
    
//    HouseDetailTitle *grTitle_bg = [[HouseDetailTitle alloc] init];
//    grTitle_bg.frame = CGRectMake(0, CGRectGetMaxY(module_Bg.frame)+10, viewWidth, 40);
//    grTitle_bg.theTitle.text = @"热门招商";//团租
//    grTitle_bg.userInteractionEnabled =YES;
//    grTitle_bg.cutOff.hidden = YES;
//    grTitle_bg.backgroundColor = [UIColor whiteColor];
//    [bottonScrollView addSubview:grTitle_bg];
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(groupPurchase_Bg.frame), viewWidth, 500) style:UITableViewStyleGrouped];
    table.backgroundColor = bgColor;
    table.scrollEnabled = NO;
    table.delegate = self;
    table.dataSource = self;
    table.bounces = NO;
    
    [bottonScrollView addSubview:table];
    
    thingLikeTitle  = [[HouseDetailTitle alloc] init];
    thingLikeTitle.frame = CGRectMake(0, CGRectGetMaxY(table.frame)+8, viewWidth, 44);
    thingLikeTitle.theTitle.text = @"猜你喜欢";
    thingLikeTitle.userInteractionEnabled = YES;
    thingLikeTitle.cutOff.hidden = YES;
    thingLikeTitle.backgroundColor = [UIColor whiteColor];
    [bottonScrollView addSubview:thingLikeTitle];
    
    thingLikeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(thingLikeTitle.frame), viewWidth, 300) style:UITableViewStyleGrouped];
    thingLikeTable.backgroundColor = bgColor;
    thingLikeTable.scrollEnabled = NO;
    thingLikeTable.delegate = self;
    thingLikeTable.dataSource = self;
    thingLikeTable.bounces = NO;
    
    [bottonScrollView addSubview:thingLikeTable];
    
    // 查看更多
    checkMore = [UIButton buttonWithType:UIButtonTypeCustom];
    checkMore.frame = CGRectMake(10, CGRectGetMaxY(thingLikeTable.frame)+10, viewWidth-20, 40);
    checkMore.titleLabel.font = titleFont_15;
    checkMore.backgroundColor = [UIColor whiteColor];
    [checkMore setTitle:@"查看更多" forState:UIControlStateNormal];
    [checkMore setTitleColor:mainTitleColor forState:UIControlStateNormal];
    [Tools_F setViewlayer:checkMore cornerRadius:5 borderWidth:0 borderColor:nil];
    [checkMore addTarget:self action:@selector(lookingMore) forControlEvents:UIControlEventTouchUpInside];
    [bottonScrollView addSubview:checkMore];
    
    // 定制
    customization_bg = [[UIView alloc] init];
    customization_bg.frame = CGRectMake(10, CGRectGetMaxY(checkMore.frame)+10, viewWidth-20, 80);
    customization_bg.backgroundColor = [UIColor whiteColor];
    [Tools_F setViewlayer:customization_bg cornerRadius:5 borderWidth:0 borderColor:nil];
    [bottonScrollView addSubview:customization_bg];
    
    UILabel *customizationTitle = [[UILabel alloc] init];
    customizationTitle.frame = CGRectMake(0, 12, customization_bg.frame.size.width, 10);
    customizationTitle.font = bottomFont_12;
    customizationTitle.textColor = mainTitleColor;
    customizationTitle.textAlignment = NSTextAlignmentCenter;
    customizationTitle.text = @"猜你喜欢？不喜欢，来定制一下！";
    [customization_bg addSubview:customizationTitle];
    
    UIButton *customization = [UIButton buttonWithType:UIButtonTypeCustom];
    customization.frame = CGRectMake(10, CGRectGetMaxY(customizationTitle.frame)+10, customization_bg.frame.size.width-20, 40);
    customization.titleLabel.font = titleFont_15;
    customization.backgroundColor = [UIColor whiteColor];
    [customization setTitle:@"定制" forState:UIControlStateNormal];
    [customization setTitleColor:dblueColor forState:UIControlStateNormal];
    [Tools_F setViewlayer:customization cornerRadius:5 borderWidth:1 borderColor:dblueColor];
    [customization addTarget:self action:@selector(goToCustomization) forControlEvents:UIControlEventTouchUpInside];
    [customization_bg addSubview:customization];
    
    // 设置底部scrollview高度
    bottonScrollView.contentSize = CGSizeMake(viewWidth, CGRectGetMaxY(customization_bg.frame)+74);
}

#pragma mark - banner点击
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{

    UIViewController *viewController;
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        viewController = loginVC;
    }
    else
    {
        NSDictionary *dic = bannerArr[index];
        
        GRDetailViewController *grDetail = [[GRDetailViewController alloc] init];
        grDetail.activityCategoryId = @"2";
        grDetail.houseID = dic[@"objectId"];
        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
        [self.navigationController pushViewController:grDetail animated:YES];
    }
    if (viewController) {
        
        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - 六模块点击
- (void)moduleClick:(UIButton *)btn{
    
    UIViewController *viewController;
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        viewController = loginVC;
    }
    else {
        switch (btn.tag) {
            case 200:
            {
                GroupRentViewController *groupRentVC = [[GroupRentViewController alloc] init];
                //GroupRentNewViewController *groupRentVC = [[GroupRentNewViewController alloc] init];
                groupRentVC.activityCategoryId = 2;
                groupRentVC.regionId = regionId;
                
                //groupRentVC.enterType = 1;
                self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
                [self.navigationController pushViewController:groupRentVC animated:YES];
            }
                break;
            case 201:
            {
                GroupPurchaseViewController *groupRentVC = [[GroupPurchaseViewController alloc] init];
                groupRentVC.activityCategoryId = 2;
                groupRentVC.regionId = regionId;
                self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
                [self.navigationController pushViewController:groupRentVC animated:YES];
            }
                break;
            case 202:
            {
                JoinInBeforeViewController *joinVC = [[JoinInBeforeViewController alloc] init];
                
                self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
                [self.navigationController pushViewController:joinVC animated:YES];
            }
                break;
            case 203:
            {
                ConsultViewController *consultVC = [[ConsultViewController alloc] init];
                
                self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
                [self.navigationController pushViewController:consultVC animated:YES];
            }
                break;
            case 204:
            {
                FAQsViewController *FAQsVC = [[FAQsViewController alloc] init];
                
                self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;
                [self.navigationController pushViewController:FAQsVC animated:YES];
            }
                break;
            case 205:
            {
//                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                 message:@"正在开发中"
//                                                                delegate:self
//                                                       cancelButtonTitle:@"好"
//                                                       otherButtonTitles:nil, nil];
//                [alert show];
                NewActivityViewController *actVc = [[NewActivityViewController alloc] init];
//                ActivityViewController * actVc = [[ActivityViewController alloc] init];
                
                self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;
                [self.navigationController pushViewController:actVc animated:YES];
            }
        }
    }
    
    if (viewController) {
        
        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

#pragma mark - 设置行数 (tableView)
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == thingLikeTable) {
        
        return [_thingYourLikeArr count]<5? [_thingYourLikeArr count]:5;
    }
    else {
        
        if (isHotBrand) {
            
            return [_hotBrandArr count]<5? [_hotBrandArr count]:5;
        }
        else {
            
            return [_hotRentArr count]>2? [_hotRentArr count]:2;
        }
    }
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
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == thingLikeTable) {
        
        //重用标识符
        static NSString *identifier = @"ThingYourLike";
        //重用机制
        GroupPurchaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
        HouseResourcesModel *model = _thingYourLikeArr[indexPath.row];
        
        if(cell == nil){
            //当不存在的时候用重用标识符生成
            cell = [[GroupPurchaseTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
        }
        
        switch (likeType) {
            case newBuy:
            {
                cell.cellType = index_gr;
                
                // 图片
                NSString *tmpStr = [NSString stringWithCurrentString:model.hr_defaultImage SizeWidth:160];
                [cell.placeImage sd_setImageWithURL:[NSURL URLWithString:tmpStr] placeholderImage:[UIImage imageNamed:@"loading_l" ]];
                // 地名
                cell.placeTitle.text = model.hr_houseName;
                // 地址
                cell.placeAdd.text = model.hr_address;
                // 抵价
                cell.placeDiscount.text = model.hr_perferentialContent;
                // 价格
                cell.placePrice.text = [model.hr_price intValue] == 0?@"待定":[NSString stringWithFormat:@"%@元/m²",model.hr_price];
            }
                break;
            case newRent:
            {
                cell.cellType = index_gr;
                
                NSString *tmpStr = [NSString stringWithCurrentString:model.hr_defaultImage SizeWidth:160];
                // 图片
                [cell.placeImage sd_setImageWithURL:[NSURL URLWithString:tmpStr] placeholderImage:[UIImage imageNamed:@"loading_l" ]];
                // 地名
                cell.placeTitle.text = model.hr_houseName;
                // 招商对象
                cell.placeAdd.text = [NSString stringWithFormat:@"业态:%@",model.hr_planFormat];
                // 招商状态
                NSString *merchantsStatus;
                switch ([model.hr_merchantsStatus intValue]) {
                    case 1:
                    {
                        merchantsStatus = @"状态: 意向登记期";
                        //merchantsStatus = @"状态: 意向登记";
                    }
                        break;
                    case 2:
                    {
                        merchantsStatus = @"状态: 意向金收取期";
                        //merchantsStatus = @"状态: 意向租赁";
                    }
                        break;
                    case 3:
                    {
                        merchantsStatus = @"状态: 转定签约期";
                        //merchantsStatus = @"状态: 品牌转定";
                    }
                        break;
                    case 4:
                    {
                        
                        merchantsStatus = @"状态: 已开业";
                        //merchantsStatus = @"状态: 已开业项目";
                    }
                        break;
                    default:
                    {
                        merchantsStatus = @"状态: 未定";
                    }
                        break;
                }
                cell.teamImg.image = [UIImage imageNamed:@"index_btn_rent_tag"];
                cell.placeDiscount.text = merchantsStatus;
                // 抵价
                cell.placePrice.text = model.hr_perferentialContent;
            }
                break;
            case allResourse:
            {
                cell.cellType = index_hr;               
                
                // 图片尺寸设定
                NSString *tmpStr = [NSString stringWithCurrentString:model.hr_defaultImage SizeWidth:160];
                
                [cell.placeImage sd_setImageWithURL:[NSURL URLWithString:tmpStr] placeholderImage:[UIImage imageNamed:@"loading_l"]];
                // 地名
                cell.placeTitle.text = model.hr_houseName;
                // 招商对象
                cell.placeAdd.text = [NSString stringWithFormat:@"招商对象:%@",model.hr_planFormat];
                // 销售参考价 暂无
                cell.placeDiscount.text = [model.hr_price intValue] == 0?@"销售参考价:待定":[NSString stringWithFormat:@"销售参考价:%@元/m²",model.hr_price];
                // 租金参考价
                cell.placePrice.text = [model.hr_rentPrice intValue] == 0?@"租金参考价:待定":[NSString stringWithFormat:@"租金参考价:%@元/m²",model.hr_rentPrice];
            }
                break;
            case dynamic:
            {
                cell.cellType = index_dy;
                
                // 图片尺寸设定
                NSString *tmpStr = [NSString stringWithCurrentString:model.hr_icon SizeWidth:160];
                
                [cell.placeImage sd_setImageWithURL:[NSURL URLWithString:tmpStr] placeholderImage:[UIImage imageNamed:@"loading_l"]];
                cell.placeTitle.text = model.hr_title;
                cell.placeAdd.text = model.hr_summary;
                [cell.placeAdd sizeToFit];
            }
                break;
            case brankJoin:
            {
                cell.cellType = index_hr;

                cell.teamImg.image = [UIImage imageNamed:@"icon-tip1"];
                /*- 推荐 -*///model.f_type
                cell.isRecommend = [model.hr_type integerValue]==1?YES:NO;
                // 图片尺寸设定
                NSString *tmpStr = [NSString stringWithCurrentString:model.hr_defaultImage SizeWidth:160];
                
                [cell.placeImage sd_setImageWithURL:[NSURL URLWithString:tmpStr] placeholderImage:[UIImage imageNamed:@"loading_l"]];
                // 品牌商名
                cell.placeTitle.text = model.hr_brandName;
                // 投资额度
                cell.placeAdd.text = [NSString stringWithFormat:@"投资额度:%@",model.hr_totalInvestmentAmount];
                // 行业
                cell.placeDiscount.text = model.hr_industryCategoryName == nil?@"行业: ":[NSString stringWithFormat:@"行业:%@",model.hr_industryCategoryName];
                // 门店数量
                cell.placePrice.text = [model.hr_storeAmount intValue] == 0?@"门店数量:暂无":[NSString stringWithFormat:@"门店数量:%@",model.hr_storeAmount];
            }
                break;
        }
        
        return cell;
    }
    else {
        
        //重用标识符
        static NSString *identifier = @"RentAndBuy";
        //重用机制
        GroupPurchaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
        
        if(cell == nil){
            //当不存在的时候用重用标识符生成
            cell = [[GroupPurchaseTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
        }
        
        HouseResourcesModel *model = isHotBrand == YES?_hotBrandArr[indexPath.row]:_hotRentArr[indexPath.row];
        cell.cellType = isHotBrand == YES? index_hr:index_gr;
        
        // 图片
        NSString *tmpStr = [NSString stringWithCurrentString:model.hr_defaultImage SizeWidth:80*2];        // 请求适应图片
        [cell.placeImage sd_setImageWithURL:[NSURL URLWithString:tmpStr] placeholderImage:[UIImage imageNamed:@"cell_loading"]];
        // 地名
        cell.placeTitle.text = [NSString stringWithFormat:@"%@",model.hr_houseName];
        
        if (isHotBrand) {
            
            // 图片尺寸设定
            NSString *tmpStr = [NSString stringWithCurrentString:model.hr_defaultImage SizeWidth:160];
            
            [cell.placeImage sd_setImageWithURL:[NSURL URLWithString:tmpStr] placeholderImage:[UIImage imageNamed:@"loading_l"]];
            // 品牌商名
            
            cell.placeTitle.text = model.hr_brandName;
            
            cell.teamImg.image = [UIImage imageNamed:@"icon-tip1"];
            /*- 推荐 -*///model.f_type
            cell.isRecommend = [model.hr_type integerValue]==1?YES:NO;
            
            // 行业
            cell.placeAdd.text = model.hr_industryCategoryName == nil?@"所属行业: ":[NSString stringWithFormat:@"所属行业:%@",model.hr_industryCategoryName];
            // 门店数量
            
            cell.placeDiscount.text = [model.hr_storeAmount intValue] == 0?@"门店数量:暂无":[NSString stringWithFormat:@"门店数量(约):%@",model.hr_storeAmount];
            // 投资额度
            cell.placePrice.text = [NSString stringWithFormat:@"投资额度:%@",model.hr_totalInvestmentAmount];
        }
        else {
            
            // 招商对象
            cell.placeAdd.text = [NSString stringWithFormat:@"业态:%@",model.hr_planFormat];
            cell.teamImg.image = [UIImage imageNamed:@"index_btn_rent_tag"];
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
            // 抵价
            cell.placePrice.text = model.hr_rentPreferentialContent;
        }
        return cell;
    }
}

#pragma mark - 点击cell进入详细页面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIViewController *viewController;
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        viewController = loginVC;
    }
    else{
    
        if (tableView == thingLikeTable) {
            
            HouseResourcesModel *model = _thingYourLikeArr[indexPath.row];
            
            switch (likeType) {
                case newBuy:
                {
                    GPDetailViewController *gpDetail = [[GPDetailViewController alloc] init];
                    gpDetail.activityCategoryId = @"1";
                    gpDetail.houseID = model.hr_houseId;
                    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
                    [self.navigationController pushViewController:gpDetail animated:YES];
                }
                    break;
                case newRent:
                {
                    GRDetailViewController *grDetail = [[GRDetailViewController alloc] init];
                    grDetail.activityCategoryId = @"2";
                    grDetail.houseID = model.hr_houseId;
                    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
                    [self.navigationController pushViewController:grDetail animated:YES];
                }
                    break;
                case allResourse:
                {
                    HRDetailViewController *hrDetail = [[HRDetailViewController alloc] init];
                    hrDetail.activityCategoryId = @"3";
                    hrDetail.hrTitle = model.hr_houseName;
                    hrDetail.houseID = model.hr_houseId;
                    [self.navigationController pushViewController:hrDetail animated:YES];
                }
                    break;
                case dynamic:
                {
                    DDetailViewController *ddVC = [[DDetailViewController alloc] init];
                    ddVC.dynamicId = [model.hr_dynamicId integerValue];
                    
                    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
                    [self.navigationController pushViewController:ddVC animated:YES];
                }
                    break;
                case brankJoin:
                {
                    NSInteger brandType = [model.hr_type integerValue];
                    if (brandType == 1) {
                        //1跳转优惠加盟
                        PreferentialJoinDetailViewController *jdVC = [[PreferentialJoinDetailViewController alloc]init];
                        jdVC.brandId = model.hr_brandId;
                        jdVC.brandType = brandType;
                        self.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:jdVC animated:YES];
                    }else if (brandType == 3){
                        //3跳转普通直营
                        DirectNormalViewController *dirVc = [[DirectNormalViewController alloc]init];
                        dirVc.brandId = model.hr_brandId;
                        dirVc.brandType = brandType;
                        self.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:dirVc animated:YES];
                    }else if (brandType == 0 || brandType ==2){
                        //0、2跳转普通加盟
                        
                        NormalJoinViewController *norVc = [[NormalJoinViewController alloc]init];
                        norVc.brandId = model.hr_brandId;
                        norVc.brandType = brandType;
                        self.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:norVc animated:YES];
                        
                    }
//                    if (brandType == 1) {
//                     
//                        PreferentialJoinDetailViewController *jdVC = [[PreferentialJoinDetailViewController alloc]init];
//                        jdVC.brandId = model.hr_brandId;
//                        jdVC.brandType = brandType;
//                        self.hidesBottomBarWhenPushed = YES;
//                        [self.navigationController pushViewController:jdVC animated:YES];
//                    }else{
//                        
//                        CommonBrandViewController *jdVC = [[CommonBrandViewController alloc] init];
//                        jdVC.brandId = model.hr_brandId;
//                        jdVC.brandType = brandType;
//                        
//                        self.hidesBottomBarWhenPushed = YES;
//                        [self.navigationController pushViewController:jdVC animated:YES];
//                    }
//                    JoinDatailBrandViewController *jdVC = [[JoinDatailBrandViewController alloc] init];
//                    jdVC.brandId = model.hr_brandId;
//                    //jdVC.brandType = brandType;
//                    
//                    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
//                    [self.navigationController pushViewController:jdVC animated:YES];

//                    JoinDetailViewController *jdVC = [[JoinDetailViewController alloc] init];
//                    jdVC.brandId = model.hr_brandId;
//                    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
//                    [self.navigationController pushViewController:jdVC animated:YES];
                }
                    break;
            }
        }
        else {
            
            self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
            
            HouseResourcesModel *model = isHotBrand?_hotBrandArr[indexPath.row]:_hotRentArr[indexPath.row];
            
            if (isHotBrand) {
                
                NSInteger brandType = [model.hr_type integerValue];
                if (brandType == 1) {
                    //1跳转优惠加盟
                    PreferentialJoinDetailViewController *jdVC = [[PreferentialJoinDetailViewController alloc]init];
                    jdVC.brandId = model.hr_brandId;
                    jdVC.brandType = brandType;
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:jdVC animated:YES];
                }else if (brandType == 3){
                    //3跳转普通直营
                    DirectNormalViewController *dirVc = [[DirectNormalViewController alloc]init];
                    dirVc.brandId = model.hr_brandId;
                    dirVc.brandType = brandType;
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:dirVc animated:YES];
                }else if (brandType == 0 || brandType ==2){
                    //0、2跳转普通加盟
                    
                    NormalJoinViewController *norVc = [[NormalJoinViewController alloc]init];
                    norVc.brandId = model.hr_brandId;
                    norVc.brandType = brandType;
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:norVc animated:YES];
                    
                }
//                if (brandType == 1) {
//                    
//                    PreferentialJoinDetailViewController *jdVC = [[PreferentialJoinDetailViewController alloc]init];
//                    jdVC.brandId = model.hr_brandId;
//                    jdVC.brandType = brandType;
//                    self.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:jdVC animated:YES];
//                    
//                }else{
//                    
//                    CommonBrandViewController *jdVC = [[CommonBrandViewController alloc] init];
//                    jdVC.brandId = model.hr_brandId;
//                    jdVC.brandType = brandType;
//                    
//                    self.hidesBottomBarWhenPushed = YES;
//                    [self.navigationController pushViewController:jdVC animated:YES];
//                }
                
//                JoinDatailBrandViewController *jdVC = [[JoinDatailBrandViewController alloc] init];
//                jdVC.brandId = model.hr_brandId;
//                //jdVC.brandType = brandType;
//                
//                self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
//                [self.navigationController pushViewController:jdVC animated:YES];
//                JoinDetailViewController *jdVC = [[JoinDetailViewController alloc] init];
//                jdVC.brandId = model.hr_brandId;
//                self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
//                [self.navigationController pushViewController:jdVC animated:YES];
            }
            else {
                
                GRDetailViewController *grDetail = [[GRDetailViewController alloc] init];
                grDetail.activityCategoryId = @"2";
                grDetail.houseID = model.hr_houseId;
                [self.navigationController pushViewController:grDetail animated:YES];
            }
        }

    }
    if (viewController) {
        
        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}

#pragma mark - 查看更多
- (void)lookingMore{
    
    UIViewController *viewController;
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        viewController = loginVC;
    }
    else{
        switch (likeType) {
            case newBuy:
            {
                GroupPurchaseViewController *groupPurchaseVC = [[GroupPurchaseViewController alloc] init];
                
                self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
                [self.navigationController pushViewController:groupPurchaseVC animated:YES];
            }
                break;
            case newRent:
            {
                GroupRentViewController *groupRentVC = [[GroupRentViewController alloc] init];
                
                self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
                [self.navigationController pushViewController:groupRentVC animated:YES];
            }
                break;
            case allResourse:
            {
                
            }
                break;
            case dynamic:
            {
                ConsultViewController *consultVC = [[ConsultViewController alloc] init];
                
                self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
                [self.navigationController pushViewController:consultVC animated:YES];
            }
                break;
            case brankJoin:
            {
                JoinInBeforeViewController *joinVC = [[JoinInBeforeViewController alloc] init];
                
                self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
                [self.navigationController pushViewController:joinVC animated:YES];
            }
                break;
        }
    }
    
    if (viewController) {
        
        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - 去定制
- (void)goToCustomization{
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        
        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else {
        
        CustomIntentionViewController *ciVC = [[CustomIntentionViewController alloc] init];
        
        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
        [self.navigationController pushViewController:ciVC animated:YES];
    }
}

#pragma mark - indexSelected
- (void)indexSelected:(UIButton *)sender{
    
//    // 设置按钮选择状态
    for ( UIButton *tempBtn in groupPurchase_Bg.subviews) {
        if (tempBtn.tag > 499 && tempBtn.tag < 502) {
            tempBtn.selected = NO;      // 全部设置未选中
        }
    }
    
    isHotBrand = (NSInteger)sender.tag == 500?NO:YES;
    sender.selected = YES;              // 当前按钮设置选中
    [table reloadData];
}

#pragma mark - 地区选择
- (void)siteAction:(UIButton *)sender{
    
    UIViewController *viewController;
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        viewController = loginVC;
    }
    else{
        AreaSelectionViewController *areaChoose = [[AreaSelectionViewController alloc] init];
        areaChoose.currentCity = currentCity;
        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
        [self.navigationController pushViewController:areaChoose animated:YES];
    }
    if (viewController) {
        
        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}

#pragma mark - 搜索
- (void)searchAction:(UIButton *)sender{
    
    UIViewController *viewController;
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        viewController = loginVC;
    }
    else{
        SearchViewController *search = [[SearchViewController alloc] init];
        
        search.activityCategoryId = @"0";
        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
        [self.navigationController pushViewController:search animated:YES];
    }
    if (viewController) {
        
        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - 地图
- (void)mapAction:(UIButton *)sender{
    
    UIViewController *viewController;
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        viewController = loginVC;
    }
    else{
        GroupRentViewController *grentVC = [[GroupRentViewController alloc] init];
        
        grentVC.regionId = regionId;
        grentVC.deliverInt = 1;
        
        SDDMapViewController *mapVC = [[SDDMapViewController alloc] init];
        
        mapVC.regionId = regionId;
        mapVC.type = 1;
        
        mapVC.view.frame = CGRectMake(0, 40, viewWidth, viewHeight - 40 - 64);
        
        [grentVC addChildViewController:mapVC];
        
        [grentVC.view addSubview:mapVC.view];
        
        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
        [self.navigationController pushViewController:grentVC animated:YES];
    }
    if (viewController) {
        
        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - 定位反编译
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    [geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    currentCity = result.addressDetail.province;
    
    [self setNavRight];
    [self starLocationIsGPS:0];
//    NSLog(@"定位结果 %@%@%@%@%@",result.addressDetail.province,
//          result.addressDetail.city,
//          result.addressDetail.district,
//          result.addressDetail.streetName,
//          result.addressDetail.streetNumber);
    
    UIAlertView *alert = [[UIAlertView alloc ] initWithTitle:nil
                                                     message:[NSString stringWithFormat:@"%@%@%@%@%@",result.addressDetail.province,
                                                                          result.addressDetail.city,
                                                                          result.addressDetail.district,
                                                                          result.addressDetail.streetName,
                                                                          result.addressDetail.streetNumber]
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:nil, nil];
    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:alert
                                    repeats:YES];
    [alert show];
    
    if (currentCity.length > 0) {
        
        [self starLocationIsGPS:1];
        [locService stopUserLocationService];           // 得到城市后停止定位
    }
}

- (void)timerFireMethod:(NSTimer*)theTimer{
    
    //弹出框
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert = NULL;
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
