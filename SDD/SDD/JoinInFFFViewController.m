//
//  JoinInFFFViewController.m
//  SDD
//
//  Created by mac on 15/10/21.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "JoinInFFFViewController.h"
#import "CustomButton.h"
#import "menuButton.h"
#import "FranchiseesMobel.h"
#import "NSString+SDD.h"
#import "MJRefresh.h"
#import "JoinIndexTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "JoinDatailBrandViewController.h"
#import "CommonBrandViewController.h"
#import "FindBrankModel.h"
#import "CategoryCell.h"

@interface JoinInFFFViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView * AreaView;//区域
    UIView * ProjectView;//项目
    UIView * BigTransView;//大
    
    UIView * TypeView;//类型
    UIView * MoreView;//更多
    
    NSInteger AreaNum ;
    
    NSInteger ProjectNum ;
    
    NSInteger TypeNum ;
    
    NSInteger MoreNum ;
    
    /*- data -*/
    NSArray *sectionTitles;
    NSString *currentCity;
    
    UIScrollView *popScrollView;
    NSArray *loadingImages;
    
    NSInteger pages;
    
    // 点击顶部菜单栏的选择ID
    NSInteger typeCategoryID;
    NSInteger industryCategoryID;
    NSInteger status;
    NSInteger projectNatureCategoryId;
    //NSInteger smartSortingId;                    /**< 智能排序 */
    //NSInteger industryCategoryID;                /**< 行业类别 */
    NSInteger type;
    
    NSString * typeStr;
    NSString * moreStr;
    NSString * proStr;
    NSString * eareStr;
    
    CustomButton * menuBtn;//自定义筛选按钮
    UIView * topView;
    
    NSUserDefaults *userDefaults;
    
    NSInteger regionIds;                          // 地区
    //    NSInteger industryCategoryId1;                 // 行业id
    NSInteger industryCategoryId2;                // 行业id2
    NSInteger regionalLocationCategoryId;         // 区位位置id
    NSNumber *areaCategoryId;                     // 需求面积
    NSNumber *investmentAmountCategoryId;         // 投资金额
    NSNumber *characterCategoryId;                // 物业类型
    NSInteger propertyTypeCategoryId;             // 品牌性质
    NSInteger  smartSortingId;                    // 智能排序
    
    UIView *whiteBlock;             // 标题白条
    NSInteger currentType;
    UITableView *table;
    
    CGPoint startPoint;             // 记录初始点
    FindBrankModel *currentModel;
    
}
// 数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
// 行业类别
@property (nonatomic, strong) NSMutableArray *industryAll;
@property (nonatomic, strong) NSArray *induRRRstryAll;
// 物业类型
@property (nonatomic, strong) NSMutableArray *propertyArray;

@property (retain,nonatomic)UITableView * tableView;
@property (retain,nonatomic)NSMutableArray * dataArray;

@property (retain,nonatomic)UITableView * industryTable;
@property (retain,nonatomic)UITableView * industryRRRTable;


@property (retain,nonatomic)UITableView * ProjectTableView;
@property (retain,nonatomic)NSMutableArray * ProjectArray;

@property (retain,nonatomic)UITableView * TypeTableView;
@property (retain,nonatomic)NSMutableArray * TypeArray;

@property (retain,nonatomic)UITableView * MoreTableView;
@property (retain,nonatomic)NSMutableArray * MoreArray;
@property (retain,nonatomic)UITableView * MoreRightTableView;
@property (retain,nonatomic)NSMutableArray * MoreRightArray;
@end

@implementation JoinInFFFViewController

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}
- (NSMutableArray *)industryAll{
    if (!_industryAll) {
        _industryAll = [[NSMutableArray alloc]init];
    }
    return _industryAll;
}
-(NSMutableArray *)propertyArray{
    if (!_propertyArray) {
        _propertyArray = [[NSMutableArray alloc] init];
    }
    return _propertyArray;
}
//- (NSMutableArray *)induRRRstryAll{
//    if (!_induRRRstryAll) {
//        _induRRRstryAll = [[NSMutableArray alloc]init];
//    }
//    return _induRRRstryAll;
//}

#pragma mark -- 菜单栏请求数据
-(void)requestMumeData
{
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
    NSDictionary *param = @{@"pageNumber":@1,
                            @"pageSize":[NSNumber numberWithInteger:pages],
                            @"params":@{
                                    @"propertyTypeCategoryId":@(propertyTypeCategoryId),
                                    @"industryCategoryId1":_industryCategoryId,
                                    @"industryCategoryId2":[NSNumber numberWithInteger:industryCategoryId2],
                                    @"regionalLocationCategoryId":[NSNumber numberWithInteger:regionalLocationCategoryId],
                                    @"characterCategoryId":characterCategoryId,
                                    @"smartSorting":@(smartSortingId),
                                    @"areaCategoryId":areaCategoryId,
                                    @"investmentAmountCategoryId":investmentAmountCategoryId,
                                    @"regionIds":@(regionIds),
                                    @"type":[NSNumber numberWithInteger:currentType]
                                    }
                            };
//    NSLog(@"%@",param);
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
                
                [self.dataSource addObject:model];
            }
        
             //判断数据个数与请求个数
            if ([_dataSource count]<pages) {
                
                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                [table.footer noticeNoMoreData];
            }
            
            [self hideLoading];
            [table reloadData];
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoading];
        //[table.footer endRefreshing];
    }];
}
#pragma mark - 设置导航条
- (void)setupNav{
    
    [self setNav:@""];
    
    // 中间选择
    UIView *titleView = [[UIView alloc] init];
    titleView.frame = CGRectMake(0, 0, 200, 20);
    
    UIButton *all = [UIButton buttonWithType:UIButtonTypeCustom];
    all.frame = CGRectMake(0, 0, 100, 20);
    all.titleLabel.font = biggestFont;
    all.tag = 100;
    [all setTitle:@"推荐品牌" forState:UIControlStateNormal];
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
    
    // 右btn
    //    UIButton*cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    cancelButton.frame = CGRectMake(0, 0, 20, 20);
    //    [cancelButton setImage:[UIImage imageNamed:@"join_home_icon_seek"] forState:UIControlStateNormal];
    //    [cancelButton addTarget:self action:@selector(seekAction) forControlEvents:UIControlEventTouchUpInside];
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cancelButton];
}
#pragma mark - 优惠品牌
- (void)someBrand:(UIButton *)btn{
    
    UIButton *otherBtn = (UIButton *)[btn.superview viewWithTag:100];
    otherBtn.selected = NO;
    btn.selected = YES;
    // 移动底部白条
    [UIView animateWithDuration:0.2 animations:^{
        whiteBlock.frame = CGRectMake(btn.frame.origin.x, btn.frame.size.height+5, btn.frame.size.width, 1);
    }];
    
    currentType = 1;
    [self requestData];
}
#pragma mark - 所有品牌

- (void)allBrand:(UIButton *)btn{
    
    UIButton *otherBtn = (UIButton *)[btn.superview viewWithTag:101];
    otherBtn.selected = NO;
    btn.selected = YES;
    // 移动底部白条
    [UIView animateWithDuration:0.2 animations:^{
        whiteBlock.frame = CGRectMake(btn.frame.origin.x, btn.frame.size.height+5, btn.frame.size.width, 1);
    }];
    
    currentType = 0;
    [self requestData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    // 初始化
    pages = 10;
    currentType = 1;
    
    _industryCategoryId = _industryCategoryId?_industryCategoryId:0;
    industryCategoryId2 = 0;
    regionalLocationCategoryId = 0;
    areaCategoryId = @0;
    investmentAmountCategoryId = @0;
    characterCategoryId = @0;
    propertyTypeCategoryId = 0;
    smartSortingId = 0;
    
    AreaNum = 1;
    ProjectNum = 1;
    TypeNum = 1;
    MoreNum = 1;
    [self requestData];
    [self requestMumeData];
    [self initData];
    [self createMenu];
    [self setupNav];
    
    // 注册监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getRegionID:)
                                                 name:@"RegionID"
                                               object:nil];
}
-(void)initData
{
    eareStr = @"行业";
    proStr = @"物业";
    typeStr = @"排序";
    moreStr = @"更多";
   
    
}
#pragma mark - 通知
- (void)getRegionID:(NSNotification *)notification{
    
    NSLog(@"----%@",[notification object]);
    regionIds = [[notification object] integerValue];

    [self requestData];
}
#pragma mark -- 创建顶部菜单栏
-(void)createMenu
{
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 40)];
    topView.backgroundColor = bgColor;
    topView.tag = 1000;
    [self.view addSubview:topView];
    //eareStr
    NSArray * menuTitleArr = @[eareStr,proStr,moreStr,typeStr];
    for (int i = 0; i < menuTitleArr.count; i ++) {
        //menuButton
        menuBtn = [[CustomButton alloc] initWithFrame:CGRectMake(i * (viewWidth/4), 0, viewWidth/4-1, 39)];
        //menuBtn.bottomLabel.text = menuTitleArr[i];
        menuBtn.backgroundColor = [UIColor whiteColor];
        [menuBtn setTitle:menuTitleArr[i] forState:UIControlStateNormal];
        [menuBtn setTitleColor:[SDDColor sddMiddleTextColor] forState:UIControlStateNormal];
        [menuBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        menuBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        menuBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        menuBtn.titleLabel.font = midFont;
        menuBtn.tag = 100+i;
        [menuBtn addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [menuBtn setImage:[UIImage imageNamed:@"icon-triangle-n@2x"] forState:UIControlStateNormal];
        [menuBtn setImage:[UIImage imageNamed:@"icon-triangle-s@2x"] forState:UIControlStateSelected];
        //image = [UIImage imageNamed:@"icon-triangle-n@2x"];
        
        [topView addSubview:menuBtn];
        
    }
    
    /*-                    table                    -*/
    table = [[UITableView alloc] init];
    table.separatorStyle = NO;                  // 隐藏分割线
    table.delegate = self;
    table.dataSource = self;
    
    [table.panGestureRecognizer addTarget:self action:@selector(pan:)];      // 添加拖拽手势
    [table addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.view addSubview:table];
    
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.right.equalTo(self.view);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);//-44
    }];
    
}
#pragma mark - 上拉加载
- (void)loadMoreData{
    
    pages+=10;
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
            //bottomViews.hidden = NO;
            
            [table mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.bottom.equalTo(self.view.mas_bottom).with.offset(0);//-44
            }];
        } else if (contextOffY < -20) {
            //        NSLog(@"往上拖拽隐藏");
            //bottomViews.hidden = YES;
            [table mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.bottom.equalTo(self.view.mas_bottom);
            }];
        }
    }
}
#pragma mark -- 顶部菜单点击事件
-(void)menuBtnClick:(menuButton *)btn
{
    NSLog(@"%ld",btn.tag);
    [AreaView removeFromSuperview];
    
    [BigTransView removeFromSuperview];
    [ProjectView removeFromSuperview];
    
    [TypeView removeFromSuperview];
    
    [MoreView removeFromSuperview];
    
    switch (btn.tag) {
        case 100:
        {
            AreaNum *= -1;
            if (AreaNum == -1) {
                [self createAreaView];
                ProjectNum = 1;
                TypeNum = 1;
                MoreNum = 1;
                
            }
            
        }
            
            break;
        case 101:
        {
            ProjectNum *= -1;
            if (ProjectNum == -1) {
                [self createProjectView];
                AreaNum = 1;
                TypeNum = 1;
                MoreNum = 1;
            }
            
        }
            
            break;
        case 102:
        {
            TypeNum *= -1;
            if (TypeNum == -1) {
                [self createTypeView];
                AreaNum = 1;
                ProjectNum = 1;
                MoreNum = 1;
            }
            
        }
            
            break;
        default:
        {
            MoreNum *= -1;
            if (MoreNum == -1) {
                [self createMoreView];
                AreaNum = 1;
                ProjectNum = 1;
                TypeNum= 1;
            }
            
        }
            break;
    }
    for (int i = 0; i < 4; i ++) {
        menuButton * button = (menuButton *)[self.view viewWithTag:100+i];
        button.selected = NO;

    }

    btn.selected = YES;
}

#pragma mark -- 区域View
-(void)createAreaView
{
    AreaView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, viewWidth, viewHeight-100)];
    AreaView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:AreaView];
    
    _industryTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth/2, viewHeight/2) style:UITableViewStylePlain];
    _industryTable.delegate = self;
    _industryTable.dataSource = self;
    [AreaView addSubview:_industryTable];
    
    _industryRRRTable = [[UITableView alloc] initWithFrame:CGRectMake(viewWidth/2, 0, viewWidth/2, viewHeight/2) style:UITableViewStylePlain];
    _industryRRRTable.delegate = self;
    _industryRRRTable.dataSource = self;
    [AreaView addSubview:_industryRRRTable];
    
}
#pragma mark -- 项目View
-(void)createProjectView
{
    BigTransView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, viewWidth, viewHeight-100)];
    BigTransView.backgroundColor = [UIColor blackColor];
    BigTransView.alpha = 0.7;
    [self.view addSubview:BigTransView];
    
    ProjectView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, viewWidth, 44*4)];
    ProjectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:ProjectView];
    
    _ProjectTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 44*4) style:UITableViewStylePlain];
    _ProjectTableView.dataSource = self;
    _ProjectTableView.delegate = self;
    [ProjectView addSubview:_ProjectTableView];
}
#pragma mark -- 类型View
-(void)createTypeView
{
    
    BigTransView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, viewWidth, viewHeight-100)];
    BigTransView.backgroundColor = [UIColor blackColor];
    BigTransView.alpha = 0.7;
    [self.view addSubview:BigTransView];
    
    TypeView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, viewWidth, viewHeight-300)];
    TypeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:TypeView];
    
    _TypeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-300) style:UITableViewStylePlain];
    _TypeTableView.delegate = self;
    _TypeTableView.dataSource = self;
    [TypeView addSubview:_TypeTableView];
}
#pragma mark -- 更多View
-(void)createMoreView
{
    BigTransView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, viewWidth, viewHeight-100)];
    BigTransView.backgroundColor = [UIColor blackColor];
    BigTransView.alpha = 0.7;
    [self.view addSubview:BigTransView];
    
    MoreView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, viewWidth, viewHeight-300)];
    MoreView.backgroundColor = bgColor;
    [self.view addSubview:MoreView];
    
    _MoreTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth/2-1, viewHeight-350) style:UITableViewStylePlain];
    _MoreTableView.delegate = self;
    _MoreTableView.dataSource = self;
    [MoreView addSubview:_MoreTableView];
    
    _MoreRightTableView = [[UITableView alloc] initWithFrame:CGRectMake(viewWidth/2, 0, viewWidth/2, viewHeight-350) style:UITableViewStylePlain];
    _MoreRightTableView.delegate = self;
    _MoreRightTableView.dataSource = self;
    [MoreView addSubview:_MoreRightTableView];
    
    UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0,viewHeight-349 , viewWidth, 49)];
    footView.backgroundColor = [UIColor whiteColor];
    [MoreView addSubview:footView];
    
    NSArray * titArray = @[@"重置",@"确定"];
    for (int i = 0;i < 2; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:titArray[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1000+i;
        [footView addSubview:button];
        if (i == 0) {
            [button setTitleColor:dblueColor forState:UIControlStateNormal];
            [button setBackgroundImage:[Tools_F imageWithColor:[SDDColor colorWithHexString:@"006699"]
                                                          size:CGSizeMake(100, 45)]
                              forState:UIControlStateHighlighted];
            [Tools_F setViewlayer:button cornerRadius:5 borderWidth:1 borderColor:dblueColor];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(footView.mas_top).with.offset(10);
                make.left.equalTo(footView.mas_left).with.offset(50);
                make.width.equalTo(@80);
                make.height.equalTo(@30);
            }];
            
        }
        else
        {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundImage:[Tools_F imageWithColor:dblueColor
                                                          size:CGSizeMake(100, 45)]
                              forState:UIControlStateNormal];
            
            [button setBackgroundImage:[Tools_F imageWithColor:[SDDColor colorWithHexString:@"006699"]
                                                          size:CGSizeMake(100, 45)]
                              forState:UIControlStateHighlighted];
            [Tools_F setViewlayer:button cornerRadius:5 borderWidth:1 borderColor:dblueColor];
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(footView.mas_top).with.offset(10);
                make.right.equalTo(footView.mas_right).with.offset(-50);
                make.width.equalTo(@80);
                make.height.equalTo(@30);
            }];
        }
    }
}

#pragma mark - 更多按钮点击事件
-(void)buttonClick:(UIButton *)btn
{
    if (btn.tag == 1000) {
        industryCategoryID = 0;
        projectNatureCategoryId = 0;
    }
    else
    {
        [self requestData];
        //[self createMenu];
        CustomButton * custBtn = (CustomButton *)[topView viewWithTag:103];
        [custBtn setTitle:moreStr forState:UIControlStateNormal];
        
        [AreaView removeFromSuperview];
        
        [BigTransView removeFromSuperview];
        [ProjectView removeFromSuperview];
        
        [TypeView removeFromSuperview];
        
        [MoreView removeFromSuperview];
    }
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == table) {
        
        return 230;
    }
    else
    {
        return 44;
    }
    
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (table == tableView) {
        return 1;
    }
    else if(tableView == _industryTable)
    {
        return _industryAll.count;
    }
    else
    {
        return _induRRRstryAll.count+1;
    }
    
}

#pragma mark - 设置Sections数 (tableView)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView == table) {
        return [self.dataSource count];
    }
    else
    {
        return 1;
    }
    
}

#pragma mark - 设置section 头高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (table == tableView) {
        if (section == 0) {
            return 0.01;
        }
        else
        {
            return 10;
        }
        
    }
    else
    {
        return 0.01;
    }
    
}

#pragma mark - 设置section 脚高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}

#pragma mark - 设置cell (tableView)
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == table) {
        
        //重用标识符
        static NSString *identifier = @"JoinList";
        //重用机制
        JoinIndexTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
        
        if (cell == nil) {
            //当不存在的时候用重用标识符生成
            cell = [[JoinIndexTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
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
        cell.franchiseesAmounts.text = [NSString stringWithFormat:@"%@",model.f_investmentAmountCategoryName];
        
        return cell;
    }
    else if(tableView == _industryTable)
    {
        static NSString * cellId = @"cellId";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        FindBrankModel *model = _industryAll[indexPath.row];
        cell.textLabel.text = model.categoryName;
        return cell;
    }
    else
    {
        static NSString * cellId = @"cellId";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"不限";
        }
        else
        {
            NSDictionary * dict = _induRRRstryAll[indexPath.row-1];
            cell.textLabel.text = dict[@"categoryName"];
        }
       
        return cell;
    }
    
}

#pragma mark - 点击cell (tableView)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == table) {
        FranchiseesMobel *model = _dataSource[indexPath.section];
        
        NSInteger brandType = [model.f_type integerValue];
        
        
        if (brandType == 1) {
            
            JoinDatailBrandViewController *jdVC = [[JoinDatailBrandViewController alloc] init];
            jdVC.brandId = model.f_brandId;
            jdVC.brandType = brandType;
            
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:jdVC animated:YES];
        }
        else
        {
            CommonBrandViewController *jdVC = [[CommonBrandViewController alloc] init];
            jdVC.brandId = model.f_brandId;
            jdVC.brandType = brandType;
            
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:jdVC animated:YES];
        }
    }
    else if(tableView == _industryTable)
    {
        FindBrankModel *model = _industryAll[indexPath.row];
        _induRRRstryAll = model.children;
        NSLog(@"%@",_induRRRstryAll);
        [_industryRRRTable reloadData];
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
