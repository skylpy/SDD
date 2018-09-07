//
//  JoinInViewController.m
//  SDD
//
//  Created by hua on 15/6/17.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "JoinInNewViewController.h"
#import "JoinBottomButton.h"
#import "JoinIndexTableViewCell.h"
#import "FranchiseesMobel.h"
#import "RegionModel.h"
#import "FindBrankModel.h"
#import "NSString+SDD.h"

#import "PreferentialBrandViewController.h"
#import "JoinDetailViewController.h"
#import "JoinSearchViewController.h"
#import "FindBrankViewController.h"
#import "BrankPublishViewController.h"
#import "BrankAuthenticationViewController.h"
#import "MyJoinViewController.h"
#import "MyJoinInViewController.h"

#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "AreaSelectView.h"

#import "JoinPDropDownMenu.h"
#import "JoinFilterCache.h"
#import "CategoryCell.h"

#import "BrandReleViewController.h"
#import "DOPDropDownMenu.h"

#import "JoinDatailBrandViewController.h"
#import "CommonBrandViewController.h"
#import "PreferentialJoinDetailViewController.h"
#import "DirectNormalViewController.h"
#import "NormalJoinViewController.h"

@interface JoinInNewViewController()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,
DOPDropDownMenuDataSource,DOPDropDownMenuDelegate>{
    
    /*- ui -*/
    
    JoinPDropDownMenu *dropMenu;
    //DOPDropDownMenu * dropMenu;
    UITableView *table;
    UIView *whiteBlock;             // 标题白条
    UIView *popview_bg;
    
    UIView *bottomViews;            // 底部3跳转
    
    /*- data -*/
    
    NSArray *otherTitles;           // 更多的标题
    
    NSArray * sortArray;            //排序
    
    NSInteger pages;
    NSInteger currentType;
    CGPoint startPoint;             // 记录初始点
    
    FindBrankModel *currentModel;
    
    NSInteger regionIds;                          // 地区
    //    NSInteger industryCategoryId1;                 // 行业id
    NSInteger industryCategoryId2;                // 行业id2
    NSInteger regionalLocationCategoryId;         // 区位位置id
    NSNumber *areaCategoryId;                     // 需求面积
    NSNumber *investmentAmountCategoryId;         // 投资金额
    NSNumber *characterCategoryId;                // 物业类型
    NSInteger propertyTypeCategoryId;             // 品牌性质
    NSInteger  smartSortingId;                    // 智能排序
}

// 数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
// 地区
@property (nonatomic, strong) NSMutableArray *regionData;
// 热门地区
@property (nonatomic, strong) NSMutableArray *hot_RegionData;
// 区位位置
@property (nonatomic, strong) NSMutableArray *regionalLocation;
// 行业类别
@property (nonatomic, strong) NSMutableArray *industryAll;
// 其它里的筛选
@property (nonatomic, strong) NSMutableArray *otherFilter;
// 当前选中的其它筛选
@property (nonatomic, strong) NSMutableArray *otherInFilter;
// 物业类型
@property (nonatomic, strong) NSMutableArray *propertyArray;
@end

@implementation JoinInNewViewController

-(NSMutableArray *)propertyArray{
    if (!_propertyArray) {
        _propertyArray = [[NSMutableArray alloc] init];
    }
    return _propertyArray;
}
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

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

- (NSMutableArray *)regionalLocation{
    if (!_regionalLocation) {
        _regionalLocation = [[NSMutableArray alloc]init];
    }
    return _regionalLocation;
}

- (NSMutableArray *)industryAll{
    if (!_industryAll) {
        _industryAll = [[NSMutableArray alloc]init];
    }
    return _industryAll;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
}

#pragma mark - 请求筛选维度
- (void)requestDimensionality{
    
    NSMutableArray *Filter,*Filter2,*Filter4;
    
   
    
    Filter = [[NSMutableArray alloc]init];
    [JoinFilterCache AreaFilterCache:Filter];
    _otherInFilter = Filter;
    [_otherFilter addObject:Filter];
    
    Filter2 = [[NSMutableArray alloc]init];
    [JoinFilterCache InvestmentFilterCache:Filter2];
    [_otherFilter addObject:Filter2];
    
    Filter4 = [[NSMutableArray alloc]init];
    [JoinFilterCache CharacterFilterCache:Filter4];
    [_otherFilter addObject:Filter4];
//    Filter3 = [[NSMutableArray alloc]init];
//    [JoinFilterCache PropertyFilterCache:Filter3];
//    [_otherFilter addObject:Filter3];
    
    
    
    NSDictionary *param = @{};    // 请求参数
    
    // 区位位置
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brandCategory/regionalLocationList.do" params:param success:^(id JSON) {
        
        //        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSArray *dict = JSON[@"data"];
        
        if (![dict isEqual:[NSNull null]]) {
            
            [_regionalLocation removeAllObjects];
            
            for (NSDictionary *tempDic in dict) {
                
                FindBrankModel *model = [FindBrankModel findBrankWithDict:tempDic];
                [self.regionalLocation addObject:model];
            }
        }
    } failure:^(NSError *error) {
        
    }];
    
    // 行业类别
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brandCategory/industryAllList.do" params:nil success:^(id JSON) {
        
        NSLog(@"%ld>>>>>>>-------------",[JSON[@"data"] count]);
        NSLog(@"%@>>>>>>>-------------",JSON[@"data"] );
        NSDictionary *dict = JSON[@"data"];
        
        if (![dict isEqual:[NSNull null]]) {
            
            [_industryAll removeAllObjects];
            
            BOOL flag = NO;
            // 第一个不限
            
            for (NSDictionary *tempDic in dict) {
                flag = YES;
                FindBrankModel *model = [[FindBrankModel alloc] init];;
                
                model = [FindBrankModel findBrankWithDict:tempDic];
                [self.industryAll addObject:model];
                
                
            }
            FindBrankModel *model = _industryAll[0];
            currentModel = flag?model:nil;

        }
    } failure:^(NSError *error) {
        
    }];
    
    
    //物业
    NSDictionary *param1 = @{};
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brandCategory/propertyTypeCategoryList.do" params:param1 success:^(id JSON) {
        
        //        NSLog(@"Json \n %@",JSON);
        NSDictionary *dict = JSON[@"data"];
        
        if (![dict isEqual:[NSNull null]]) {
            
            [_propertyArray removeAllObjects];
            for (NSDictionary *tempDic in dict) {
                
                CategoryCell *model = [[CategoryCell alloc] init];
                
                model.areaCategoryId = tempDic[@"propertyTypeCategoryId"];
                model.categoryName = tempDic[@"categoryName"];
                model.sort = tempDic[@"sort"];
                
                
                [self.propertyArray addObject:model];
            }
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
}

#pragma mark - 请求数据
- (void)requestData{
    
    // 请求参数
//    NSDictionary *param = @{@"pageNumber":@1,
//                            @"pageSize":[NSNumber numberWithInteger:pages],
//                            @"params":@{
//                                    @"propertyTypeCategoryId":@(propertyTypeCategoryId),
//                                    @"industryCategoryId1":_industryCategoryId,
//                                    @"industryCategoryId2":[NSNumber numberWithInteger:industryCategoryId2],
//                                    @"regionalLocationCategoryId":[NSNumber numberWithInteger:regionalLocationCategoryId],
//                                    @"characterCategoryId":characterCategoryId,
//                                    @"smartSorting":@(smartSortingId),
//                                    @"areaCategoryId":areaCategoryId,
//                                    @"investmentAmountCategoryId":investmentAmountCategoryId,
//                                    @"regionIds":@(regionIds),
////                                    @"type":[NSNumber numberWithInteger:currentType]
//                                    @"brandType":[NSNumber numberWithInteger:2]
//                                    }
//                            };
    
    
    NSDictionary *param;
    if (currentType == 1) {
        param = @{@"pageNumber":@1,
                                @"pageSize":[NSNumber numberWithInteger:pages],
                                @"params":@{
                                        @"propertyTypeCategoryId":@(propertyTypeCategoryId),
                                        @"industryCategoryId1":_industryCategoryId,
                                        @"industryCategoryId2":[NSNumber numberWithInteger:industryCategoryId2],
                                        @"regionalLocationCategoryId":[NSNumber numberWithInteger:regionalLocationCategoryId],
                                        @"characterCategoryId":characterCategoryId,
                                        @"areaCategoryId":areaCategoryId,
                                        @"investmentAmountCategoryId":investmentAmountCategoryId,
                                        @"regionIds":@(regionIds),
                                        @"brandType":[NSNumber numberWithInteger:2]
                                        }
                                };
    }else if(currentType == 0){
        param = @{@"pageNumber":@1,
                                @"pageSize":[NSNumber numberWithInteger:pages],
                                @"params":@{
                                        @"propertyTypeCategoryId":@(propertyTypeCategoryId),
                                        @"industryCategoryId1":_industryCategoryId,
                                        @"industryCategoryId2":[NSNumber numberWithInteger:industryCategoryId2],
                                        @"regionalLocationCategoryId":[NSNumber numberWithInteger:regionalLocationCategoryId],
                                        @"characterCategoryId":characterCategoryId,
//                                        @"smartSorting":@(smartSortingId),
                                        @"areaCategoryId":areaCategoryId,
                                        @"investmentAmountCategoryId":investmentAmountCategoryId,
                                        @"regionIds":@(regionIds),
                                        }
                                };
    }
    [self showLoading:2];
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brand/list.do" params:param success:^(id JSON) {
        
        //        NSLog(@"Json \n %@",JSON);
        NSDictionary *dict = JSON[@"data"];
        
        if (![dict isEqual:[NSNull null]]) {
            
            [_dataSource removeAllObjects];
            [table.footer endRefreshing];
            for (NSDictionary *tempDic in dict) {
                
                FranchiseesMobel *model = [[FranchiseesMobel alloc] init];
                
                NSString *fiString = [NSString stringWithCurrentString:tempDic[@"defaultImage"] SizeWidth:viewWidth*2];
                NSString *flString = [NSString stringWithCurrentString:tempDic[@"brandLogo"] SizeWidth:55*2];
                
                model.f_brandId = tempDic[@"brandId"];
                model.f_brandLogo = flString;
                model.f_brandName = tempDic[@"brandName"];
                model.f_collectionQty = tempDic[@"collectionQty"];
                model.f_companyName = tempDic[@"companyName"];
                model.f_defaultImage = fiString;
                model.f_industryCategoryName = tempDic[@"industryCategoryName"];
                model.f_investmentAmountCategoryName = tempDic[@"investmentAmountCategoryName"];
                model.f_joinedQty = tempDic[@"joinedQty"];
                model.f_propertyTypeCategoryName = tempDic[@"propertyTypeCategoryName"];
                model.f_storeAmount = tempDic[@"storeAmount"];
                model.f_storeName = tempDic[@"storeName"];
                model.f_totalInvestmentAmount = tempDic[@"totalInvestmentAmount"];
                model.f_type = tempDic[@"type"];
                
                model.f_discount = [NSString stringWithFormat:@"%@",tempDic[@"discount"]];
                [self.dataSource addObject:model];
            }
            
            // 判断数据个数与请求个数
            if ([_dataSource count]<pages) {
                
                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                [table.footer noticeNoMoreData];
            }
            
            [self hideLoading];
            [table reloadData];
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoading];
        [table.footer endRefreshing];
    }];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%@",_industryCategoryId);
    
    // 初始化
    pages = 10;
    _otherFilter = [[NSMutableArray alloc]init];
    _otherInFilter = [[NSMutableArray alloc]init];
    otherTitles = @[@"需求面积",@"投资金额",@"品牌性质"];
    sortArray = @[@"门店最多",@"好评优先",@"加盟最多"];
    _industryCategoryId = _industryCategoryId?_industryCategoryId:0;
    industryCategoryId2 = 0;
    regionalLocationCategoryId = 0;
    areaCategoryId = @0;
    investmentAmountCategoryId = @0;
    characterCategoryId = @0;
    propertyTypeCategoryId = 0;
    smartSortingId = 0;
    
    /**  初始化显示‘加盟品牌’ **/
    currentType = 1;
//    if ([_industryCategoryId integerValue] == 2) {
//        currentType = 1;
//    }else{
//        currentType = 0;
//    }
    
    // 请求筛选维度
    [self requestDimensionality];
    // 请求数据
    [self requestData];
    // 导航条
    [self setupNav];
    // ui
    [self setupUI];
    
    // 注册监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getRegionID:)
                                                 name:@"RegionID"
                                               object:nil];
}



#pragma mark - 设置导航条
- (void)setupNav{
    
    [self setNav:@""];
    
    //[self setNav:@""];
    
    /*** 所有进来的页面都显示 ‘加盟品牌’ 和 ‘全部品牌’ ***/
    // 中间选择
    UIView *titleView = [[UIView alloc] init];
    titleView.frame = CGRectMake(0, 0, 200, 20);
    
    UIButton *all = [UIButton buttonWithType:UIButtonTypeCustom];
    all.frame = CGRectMake(0, 0, 100, 20);
    all.titleLabel.font = biggestFont;
    all.tag = 100;
    [all setTitle:@"加盟品牌" forState:UIControlStateNormal];
    [all setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [all setTitleColor:lblueColor forState:UIControlStateNormal];
    all.selected = YES;
    [all addTarget:self action:@selector(someBrand:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:all];
    
    UIButton *some = [UIButton buttonWithType:UIButtonTypeCustom];
    some.frame = CGRectMake(CGRectGetMaxX(all.frame)+10, 0, 100, 20);
    some.titleLabel.font = biggestFont;
    some.tag = 101;
    [some setTitle:@"全部品牌" forState:UIControlStateNormal];
    [some setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [some setTitleColor:lblueColor forState:UIControlStateNormal];
    [some addTarget:self action:@selector(allBrand:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:some];
    
    whiteBlock = [[UIView alloc] init];
    whiteBlock.frame = CGRectMake(titleView.frame.origin.x, titleView.frame.size.height+5, all.frame.size.width, 1);
    whiteBlock.backgroundColor = [UIColor whiteColor];
    [titleView addSubview:whiteBlock];
    
    self.navigationItem.titleView = titleView;
    
//    if ([_industryCategoryId integerValue] == 2) {
//
//        // 中间选择
//        UIView *titleView = [[UIView alloc] init];
//        titleView.frame = CGRectMake(0, 0, 200, 20);
//        
//        UIButton *all = [UIButton buttonWithType:UIButtonTypeCustom];
//        all.frame = CGRectMake(0, 0, 100, 20);
//        all.titleLabel.font = biggestFont;
//        all.tag = 100;
//        [all setTitle:@"加盟品牌" forState:UIControlStateNormal];
//        [all setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//        [all setTitleColor:lblueColor forState:UIControlStateNormal];
//        all.selected = YES;
//        [all addTarget:self action:@selector(someBrand:) forControlEvents:UIControlEventTouchUpInside];
//        [titleView addSubview:all];
//        
//        UIButton *some = [UIButton buttonWithType:UIButtonTypeCustom];
//        some.frame = CGRectMake(CGRectGetMaxX(all.frame)+10, 0, 100, 20);
//        some.titleLabel.font = biggestFont;
//        some.tag = 101;
//        [some setTitle:@"全部品牌" forState:UIControlStateNormal];
//        [some setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//        [some setTitleColor:lblueColor forState:UIControlStateNormal];
//        [some addTarget:self action:@selector(allBrand:) forControlEvents:UIControlEventTouchUpInside];
//        [titleView addSubview:some];
//        
//        whiteBlock = [[UIView alloc] init];
//        whiteBlock.frame = CGRectMake(titleView.frame.origin.x, titleView.frame.size.height+5, all.frame.size.width, 1);
//        whiteBlock.backgroundColor = [UIColor whiteColor];
//        [titleView addSubview:whiteBlock];
//        
//        self.navigationItem.titleView = titleView;
//        
//    }else{
//    
//        // 中间选择
//        UIView *titleView = [[UIView alloc] init];
//        titleView.frame = CGRectMake(0, 0, viewWidth, 20);
//        
//        
//        UIButton *some = [UIButton buttonWithType:UIButtonTypeCustom];
//        some.frame = CGRectMake(0, 0, 100, 20);
//        some.titleLabel.font = biggestFont;
//        some.tag = 101;
//        some.selected = YES;
//        [some setTitle:@"全部品牌" forState:UIControlStateNormal];
//        [some setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//        [some setTitleColor:lblueColor forState:UIControlStateNormal];
//        //[some addTarget:self action:@selector(allBrand:) forControlEvents:UIControlEventTouchUpInside];
//        [titleView addSubview:some];
//        
//        self.navigationItem.titleView = titleView;
//        
//    }
    
    
    // 右btn
    UIButton*cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 0, 20, 20);
    [cancelButton setImage:[UIImage imageNamed:@"join_home_icon_seek"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(seekAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cancelButton];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    /*-                    添加下拉菜单                    -*/
    // 添加下拉菜单
    //dropMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:40];
    dropMenu = [[JoinPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:40];
    dropMenu.indicatorColor = lgrayColor;
    dropMenu.textColor = deepBLack;
    [dropMenu setMoreSelectMode:TRUE:2];  //设置多选模式
//    AreaSelectView *location = [[AreaSelectView alloc] init];
//    [dropMenu setLocation:location];
    dropMenu.delegate = self;
    dropMenu.dataSource = self;
    [self.view addSubview:dropMenu];
    
    /*-                    table                    -*/
    table = [[UITableView alloc] init];
    table.separatorStyle = NO;                  // 隐藏分割线
    table.delegate = self;
    table.dataSource = self;
    
    [table.panGestureRecognizer addTarget:self action:@selector(pan:)];      // 添加拖拽手势
    [table addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.view addSubview:table];
    
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dropMenu.mas_bottom);
        make.right.equalTo(self.view);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);//-44
    }];
    
    /*-                    底部                    -*/  //注释不要显示底部内容
//    bottomViews = [[UIView alloc] init];
//    bottomViews.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:bottomViews];
    
//    JoinBottomButton *findBrank = [[JoinBottomButton alloc] init];
//    findBrank.titleLabel.font = midFont;
//    [findBrank setTitle:@"一键找品牌" forState:UIControlStateNormal];
//    [findBrank setTitleColor:lgrayColor forState:UIControlStateNormal];
//    findBrank.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
//    findBrank.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    findBrank.titleEdgeInsets = UIEdgeInsetsMake(0, -22, 2, 0);
//    [findBrank setImage:[UIImage imageNamed:@"brand_zhaopingpai1"] forState:UIControlStateNormal];
//    //    [findBrank setImage:[UIImage imageNamed:@"brand_zhaopingpai2"] forState:UIControlStateHighlighted];
//    [findBrank addTarget:self action:@selector(findBrank:) forControlEvents:UIControlEventTouchUpInside];
//    [bottomViews addSubview:findBrank];
//    
//    JoinBottomButton *publish = [[JoinBottomButton alloc] init];
//    publish.titleLabel.font = midFont;
//    [publish setTitle:@"发布" forState:UIControlStateNormal];
//    [publish setTitleColor:lgrayColor forState:UIControlStateNormal];
//    publish.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
//    publish.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    publish.titleEdgeInsets = UIEdgeInsetsMake(0, -22, 2, 0);
//    [publish setImage:[UIImage imageNamed:@"join_home_btn_issue"] forState:UIControlStateNormal];
//    //    [publish setImage:[UIImage imageNamed:@"join_home_btn_issue2"] forState:UIControlStateHighlighted];
//    [publish addTarget:self action:@selector(brankPublish:) forControlEvents:UIControlEventTouchUpInside];
//    [bottomViews addSubview:publish];
//    
//    JoinBottomButton *myBrank = [[JoinBottomButton alloc] init];
//    myBrank.titleLabel.font = midFont;
//    [myBrank setTitle:@"我的品牌" forState:UIControlStateNormal];
//    [myBrank setTitleColor:lgrayColor forState:UIControlStateNormal];
//    myBrank.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
//    myBrank.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    myBrank.titleEdgeInsets = UIEdgeInsetsMake(0, -22, 2, 0);
//    [myBrank setImage:[UIImage imageNamed:@"tabbar_item_mine_unSelected"] forState:UIControlStateNormal];
//    //    [myBrank setImage:[UIImage imageNamed:@"tabbar_item_mine_selected"] forState:UIControlStateHighlighted];
//    [myBrank addTarget:self action:@selector(myBrank:) forControlEvents:UIControlEventTouchUpInside];
//    [bottomViews addSubview:myBrank];
    
//    [bottomViews mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view.mas_bottom);
//        make.left.equalTo(self.view.mas_left);
//        make.right.equalTo(self.view.mas_right);
//        make.height.equalTo(@44);
//    }];
//    
//    [findBrank mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bottomViews.mas_top);
//        make.left.equalTo(bottomViews.mas_left);
//        make.right.equalTo(publish.mas_left);
//        make.bottom.equalTo(bottomViews.mas_bottom);
//        make.size.equalTo(@[publish,myBrank]);
//    }];
//    
//    [publish mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bottomViews.mas_top);
//        make.left.equalTo(findBrank.mas_right);
//        make.right.equalTo(myBrank.mas_left);
//        make.bottom.equalTo(bottomViews.mas_bottom);
//        make.size.equalTo(@[findBrank,myBrank]);
//    }];
//    
//    [myBrank mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bottomViews.mas_top);
//        make.left.equalTo(publish.mas_right);
//        make.right.equalTo(bottomViews.mas_right);
//        make.bottom.equalTo(bottomViews.mas_bottom);
//        make.size.equalTo(@[publish,findBrank]);
//    }];
}

#pragma mark - 上拉加载
- (void)loadMoreData{
    
    pages+=10;
    [self requestData];
}

#pragma mark - 通知
- (void)getRegionID:(NSNotification *)notification{
    
    NSLog(@"----%@",[notification object]);
    regionIds = [[notification object] integerValue];
    [dropMenu animateIdicator:0 background:dropMenu.backGroundView tableView:dropMenu.leftTableView title:nil forward:NO complecte:^{
        dropMenu.show = NO;
    }];
    [self requestData];
}
#pragma mark - ScrollView拖拽
- (void)pan:(UIPanGestureRecognizer *)panParam{
    
    
    if (panParam.state == UIGestureRecognizerStateBegan){          //条件内：每次移动只调用一次
        
        startPoint = [panParam locationInView:self.view];          //记录起始点
    }
    else {
        
        CGPoint newPoint=[panParam locationInView:self.view];      //记录当前点
        //得到y的偏移量
        CGFloat contextOffY = newPoint.y-startPoint.y;
        if (contextOffY > 20) {
            //        NSLog(@"往下拖拽显示");
            bottomViews.hidden = NO;
            
            [table mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.bottom.equalTo(self.view.mas_bottom).with.offset(0);//-44
            }];
        } else if (contextOffY < -20) {
            //        NSLog(@"往上拖拽隐藏");
            bottomViews.hidden = YES;
            [table mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.bottom.equalTo(self.view.mas_bottom);
            }];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 滚动停止显示
    bottomViews.hidden = NO;
    [table mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);//-44
    }];
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 230;
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

#pragma mark - 设置Sections数 (tableView)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [self.dataSource count];
}

#pragma mark - 设置section 头高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

#pragma mark - 设置section 脚高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}

#pragma mark - 设置cell (tableView)
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //重用标识符
    static NSString *identifier = @"JoinList";
    //重用机制
    JoinIndexTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
    
    if (cell == nil) {
        //当不存在的时候用重用标识符生成
        cell = [[JoinIndexTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
    }else{
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager cancelAll];
        cell.franchiseesImage.image = [UIImage imageNamed:@"loading_b"];
    }
    
    FranchiseesMobel *model = _dataSource[indexPath.section];
    
    /*- 图片+logo -*/
    [cell.franchiseesImage sd_setImageWithURL:[NSURL URLWithString:model.f_defaultImage]  placeholderImage:[UIImage imageNamed:@"loading_b"]];
    [cell.franchiseesLogo sd_setImageWithURL:[NSURL URLWithString:model.f_brandLogo]  placeholderImage:[UIImage imageNamed:@"loading_l"]];
    /*- 加盟商名 -*/
    cell.franchiseesName.text = model.f_brandName;
    /*- 推荐 -*/
    cell.isRecommend = [model.f_type integerValue]==1?YES:NO;
    /*- 投资额度 -*/
    cell.investmentAmounts.text = model.f_industryCategoryName;
    /*- 行业 -*/
    cell.industry.text = [NSString stringWithFormat:@"%@",model.f_storeAmount];
    /*- 门店数量 -*/
    //cell.franchiseesAmounts.text = [NSString stringWithFormat:@"%@",model.f_investmentAmountCategoryName];
//    if ([model.f_type integerValue]==1) {
//        cell.franchiseesAmounts_unit.text = @"加盟优惠";//@"优惠额度";
//        cell.franchiseesAmounts.text = [NSString stringWithFormat:@"%@折",model.f_discount];
//    }
//    else
//    {
//        cell.franchiseesAmounts_unit.text = @"投资额度";//(万)
//        cell.franchiseesAmounts.text = [NSString stringWithFormat:@"%@",model.f_investmentAmountCategoryName];
//    }
    
    cell.franchiseesAmounts_unit.text = @"投资额度";
    cell.franchiseesAmounts.text = [NSString stringWithFormat:@"%@",model.f_investmentAmountCategoryName];
    
    return cell;
}

#pragma mark - 点击cell (tableView)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FranchiseesMobel *model = _dataSource[indexPath.section];
//    NSLog(@"%@",model.f_type);
//    return;
    NSInteger brandType = [model.f_type integerValue];
    
    //    if (brandType == 1) {
    //
    
    //    }
    //    else {
    
//    PreferentialBrandViewController *pbVC = [[PreferentialBrandViewController alloc] init];
//    pbVC.brandId = model.f_brandId;
//    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:pbVC animated:YES];
    
//    JoinDetailViewController *jdVC = [[JoinDetailViewController alloc] init];
//    jdVC.brandId = model.f_brandId;
//    jdVC.brandType = brandType;
//    
//    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:jdVC animated:YES];
    //    }
    if (brandType == 1) {
        //1跳转优惠加盟
        PreferentialJoinDetailViewController *jdVC = [[PreferentialJoinDetailViewController alloc]init];
        jdVC.brandId = model.f_brandId;
        jdVC.brandType = brandType;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:jdVC animated:YES];
    }else if (brandType == 3){
        //3跳转普通直营
        DirectNormalViewController *dirVc = [[DirectNormalViewController alloc]init];
        dirVc.brandId = model.f_brandId;
        dirVc.brandType = brandType;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:dirVc animated:YES];
    }else if (brandType == 0 || brandType ==2){
        //0、2跳转普通加盟
        
        NormalJoinViewController *norVc = [[NormalJoinViewController alloc]init];
        norVc.brandId = model.f_brandId;
        norVc.brandType = brandType;
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:norVc animated:YES];
        
    }
}

#pragma mark - 可视栏目数
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu{
    
    return 4;
}

#pragma mark - 各栏目一级个数
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column{
    
    switch (column) {
        case 0:
        {
            
            return [_industryAll count];
        }
        case 1:
        {
            return _propertyArray.count+1;
            //return [_regionalLocation count]+1;
        }
        case 3:
        {
            return sortArray.count+1;
        }
        default:
        {
            return [otherTitles count]+1;
        }
    }
}

#pragma mark - 返回栏目一级标题
- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath{
    
    switch (indexPath.column) {

        case 0:
        {
            if (indexPath.row == 0) {
                return @"行业";
            }else{
                FindBrankModel *model = _industryAll[indexPath.row];
                return model.categoryName;
            }
        }
        case 1:
        {
            if (indexPath.row == 0) {
                return @"物业";
            }
            else {
                //_regionalLocation
                FindBrankModel *model = _propertyArray[indexPath.row-1];
                return model.categoryName;
            }
        }
        case 2:
        {
            if (indexPath.row == 0) {
                return @"更多";
            }
            else {
                return [otherTitles objectAtIndex:indexPath.row-1];
            }
        }
        default:
        {
            if (indexPath.row == 0) {
                return @"排序";
            }
            else
            {
                return [sortArray objectAtIndex:indexPath.row-1];
            }
            
        }
    }
}

#pragma mark - 栏目内二级个数
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column{
    
    switch (column) {
        case 0:
        {
            return [currentModel.children count];
        }
        case 1:
        {
            return 0;
        }
        case 2:
        {
            if (row == 0) {
                return 1;
            }
            else
            {
                return [_otherInFilter count];
            }
        }
        default:
        {
            return 0;
        }
    }
}

#pragma mark - 返回栏目二级标题
- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath{
    
    switch (indexPath.column) {

        case 0:
        {
            NSDictionary *tempDic = currentModel.children[indexPath.item];
            return tempDic[@"categoryName"];
            
        }
        case 1:
        {
            return nil;
        }
        case 3:
        {
            return nil;
        }
        default:
        {
            if (indexPath.row == 0) {
                return @"";
            }
            else
            {
                return ((CategoryCell*)[_otherInFilter objectAtIndex:indexPath.item]).categoryName;
            }
            
        }
    }
}

#pragma mark - 点击代理，点击了第column 第row 或者item项，如果 item >=0
- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath{
    
    if (indexPath.item >= 0) {
        
        if (indexPath.column == 0) {
            
            NSDictionary *tempDic = currentModel.children[indexPath.item];
            industryCategoryId2 = [tempDic[@"industryCategoryId"] integerValue];
            [self requestData];
        }
    }
    else {
        
        if (indexPath.column == 0) {
            
            FindBrankModel *model = _industryAll[indexPath.row];
            currentModel = model;
            _industryCategoryId = [NSNumber numberWithInteger:[model.industryCategoryId integerValue]];
            //[self requestData];
        }
        else if (indexPath.column == 1){
            
            if (indexPath.row == 0) {
                
                propertyTypeCategoryId = 0;
            }
            else {
                
                CategoryCell *model = _propertyArray[indexPath.row-1];
                propertyTypeCategoryId = [model.areaCategoryId integerValue];
            }
            
            [self requestData];
        }
        else if (indexPath.column == 2) {
            if (indexPath.row != 0) {
                _otherInFilter = [_otherFilter objectAtIndex:indexPath.row-1];
            }
            
        }
        else if (indexPath.column == 3) {
            
            if (indexPath.row == 0) {
                
                smartSortingId = 0;
            }
            else {
                smartSortingId = indexPath.row;
//                FindBrankModel *model = _regionalLocation[indexPath.row-1];
//                regionalLocationCategoryId = [model.regionalLocationCategoryId integerValue];
            }
            
            [self requestData];
        }
    }
}

#pragma mark - 菜单多选功能
-(void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPaths:(NSMutableArray *)indexPaths{
    
    // 重置属性
    areaCategoryId = @0;
    investmentAmountCategoryId = @0;
    characterCategoryId = @0;
    propertyTypeCategoryId = 0;
    
    for (int i = 0; i < [indexPaths count]; i++) {
        NSMutableArray *mu = [indexPaths objectAtIndex:i];
        NSLog(@"%d有%ld个",i,[mu count]);
        for (NSIndexPath *indexPath in mu) {
            switch (i) {
                case 0:
                {
                    areaCategoryId = ((CategoryCell *)[[_otherFilter objectAtIndex:0]
                                                       objectAtIndex:indexPath.item]).areaCategoryId;
                }
                    break;
                case 1:
                {
                    investmentAmountCategoryId = ((CategoryCell *)[[_otherFilter objectAtIndex:0]
                                                                   objectAtIndex:indexPath.item]).areaCategoryId;
                }
                    break;
//                case 2:
//                {
//                    characterCategoryId = ((CategoryCell *)[[_otherFilter objectAtIndex:0]
//                                                            objectAtIndex:indexPath.item]).areaCategoryId;
//                }
//                    break;
                case 2:
                {
                    propertyTypeCategoryId = [((CategoryCell *)[[_otherFilter objectAtIndex:0] objectAtIndex:indexPath.item]).areaCategoryId integerValue];
                }
                    break;
            }
        }
    }
    [self requestData];
}

#pragma mark - 一键找品牌
- (void)findBrank:(UIButton *)btn{
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else {
        
        FindBrankViewController *fbVC = [[FindBrankViewController alloc] init];
        [self.navigationController pushViewController:fbVC animated:YES];
    }
}

#pragma mark - 品牌发布
- (void)brankPublish:(UIButton *)btn{
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else {
        
        [HttpTool postWithBaseURL:SDD_MainURL Path:@"/user/detail.do" params:nil success:^(id JSON) {
            
            //            NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
            NSDictionary *dict = JSON[@"data"];
            
            if (![dict isEqual:[NSNull null]]) {
                
                if ([dict[@"isBrandUser"] integerValue] == 0) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您当前非认证品牌商，认证后可发布品牌加盟，是否认证？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                    [alert show];
                } else {
                    BrandReleViewController *bpVC = [[BrandReleViewController alloc] init];
                    [self.navigationController pushViewController:bpVC animated:YES];
                    //                    BrankPublishViewController *bpVC = [[BrankPublishViewController alloc] init];
                    //                    [self.navigationController pushViewController:bpVC animated:YES];
                }
            }
            
        } failure:^(NSError *error) {
            
            NSLog(@"错误 -- %@", error);
        }];
    }
}

#pragma mark - alertView代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 1:
        {
            BrankAuthenticationViewController *baVC = [[BrankAuthenticationViewController alloc] init];
            [self.navigationController pushViewController:baVC animated:YES];
        }
            break;
        default:
            
            break;
    }
}

#pragma mark - 我的品牌
- (void)myBrank:(UIButton *)btn{
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else {
        MyJoinInViewController *jiVC = [[MyJoinInViewController alloc] init];
        [self.navigationController pushViewController:jiVC animated:YES];
    }
}

#pragma mark - 所有品牌

- (void)allBrand:(UIButton *)btn{
    
    UIButton *otherBtn = (UIButton *)[btn.superview viewWithTag:100];
    otherBtn.selected = NO;
    btn.selected = YES;
    // 移动底部白条
    [UIView animateWithDuration:0.2 animations:^{
        whiteBlock.frame = CGRectMake(btn.frame.origin.x, btn.frame.size.height+5, btn.frame.size.width, 1);
    }];
    
    currentType = 0;
    [self requestData];
}

#pragma mark - 优惠品牌
- (void)someBrand:(UIButton *)btn{
    
    UIButton *otherBtn = (UIButton *)[btn.superview viewWithTag:101];
    otherBtn.selected = NO;
    btn.selected = YES;
    // 移动底部白条
    [UIView animateWithDuration:0.2 animations:^{
        whiteBlock.frame = CGRectMake(btn.frame.origin.x, btn.frame.size.height+5, btn.frame.size.width, 1);
    }];
    
    currentType = 1;
    [self requestData];
}

#pragma mark - 搜索
- (void)seekAction{
    
    JoinSearchViewController *jsVC = [[JoinSearchViewController alloc] init];
    
    [self.navigationController pushViewController:jsVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
