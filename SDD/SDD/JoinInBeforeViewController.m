//
//  JoinInBeforeViewController.m
//  SDD
//
//  Created by hua on 15/9/15.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "JoinInBeforeViewController.h"
#import "JoinBottomButton.h"
#import "JoinIndexTableViewCell.h"
#import "FranchiseesMobel.h"
#import "RegionModel.h"
#import "FindBrankModel.h"
#import "NSString+SDD.h"
#import "ModuleButton.h"

#import "PreferentialBrandViewController.h"
#import "JoinDetailViewController.h"
#import "JoinSearchViewController.h"
#import "FindBrankViewController.h"
#import "BrankPublishViewController.h"
#import "BrankAuthenticationViewController.h"
#import "MyJoinInViewController.h"
#import "JoinInViewController.h"

#import "UIImageView+WebCache.h"
#import "MJRefresh.h"

#import "JoinPDropDownMenu.h"
#import "MyIssueViewController.h"

#import "BrandReleViewController.h"
#import "JoinInNewViewController.h"
#import "JoinDatailBrandViewController.h"  //新的品牌详情

#import "CommonBrandViewController.h"
#import "JoinInFFFViewController.h"

#import "NewJoinDatailBrandViewController.h"

#import "DirectNormalViewController.h"  //直营
#import "NormalJoinViewController.h"  //普通加盟
#import "PreferentialJoinDetailViewController.h"  //优惠加盟
#import "NormalJoinMoreViewController.h" //普通加盟更多
#import "DirectNormalMoreViewController.h"  //普通直营更多

@interface JoinInBeforeViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>{
    
    /*- ui -*/
    
    UIScrollView *top_bg;
    UITableView *table;
    UIPageControl *pagePoint;
    UIView *bottomViews;            // 底部3跳转
    
    /*- data -*/
    
    NSInteger pages;
    CGPoint startPoint;             // 记录初始点
    NSDictionary *topType;
    
    NSInteger industryCategoryId2;                // 行业id2
    NSInteger regionalLocationCategoryId;         // 区位位置id
    NSNumber *areaCategoryId;                     // 需求面积
    NSNumber *investmentAmountCategoryId;         // 投资金额
    NSNumber *characterCategoryId;                // 物业类型
    NSInteger propertyTypeCategoryId;             // 品牌性质
    NSInteger  smartSortingId;                    // 智能排序
    NSInteger industryCategoryId;
    NSInteger currentType;
    
}
//@property (nonatomic, strong) NSInteger industryCategoryId;
// 数据源
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation JoinInBeforeViewController

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
    bottomViews.hidden = NO;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

#pragma mark - 请求数据
- (void)requestData{
    
    // 请求参数
    NSDictionary *param = @{@"pageNumber":@1,
                            @"pageSize":@(pages),
                            @"params":@{
                                    @"propertyTypeCategoryId":[NSNumber numberWithInteger:propertyTypeCategoryId],
                                    @"industryCategoryId1":[NSNumber numberWithInteger:industryCategoryId],
                                    @"industryCategoryId2":[NSNumber numberWithInteger:industryCategoryId2],
                                    @"regionalLocationCategoryId":[NSNumber numberWithInteger:regionalLocationCategoryId],
                                    @"characterCategoryId":characterCategoryId,
                                    @"areaCategoryId":areaCategoryId,
                                    @"investmentAmountCategoryId":investmentAmountCategoryId,
                                    //                                    @"regionIds":@[[NSNumber numberWithInteger:]],
                                    @"type":[NSNumber numberWithInteger:currentType]
                                    }
                            };
    
    [self showLoading:2];
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brand/list.do" params:param success:^(id JSON) {
        
        NSLog(@"Json \n %@",JSON);
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
                model.f_brandType = tempDic[@"brandType"];
                
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 初始化
    pages = 10;
    topType = @{@"icon": @[@"icon_main",@"icon_cate",@"icon_hotels",@"icon_children",
                           @"dress",@"icon_fashion",@"icon_entertainment",@"materials",
                           @"life",@"car",@"icon_care",@"icon_it",
                           @"furnishing",@"brand",@"art",@"education"],
                @"title":@[@"主力店",@"餐饮美食",@"连锁酒店",@"儿童主题",
                           @"服装",@"时尚精品",@"休闲娱乐",@"家居",
                           @"生活配套",@"汽车用品",@"美容护理",@"互联网",
                           @"建材",@"品牌集合点",@"文教艺术",@"教育"],
                @"industryCategoryId":@[@(1),@(2),@(4),@(123),
                                        @(98),@(108),@(7),@(3),
                                        @(8),@(137),@(119),@(133),
                                        @(3),@(85),@(128),@(134)],
                };
    
    industryCategoryId = 0;
    industryCategoryId2 = 0;
    regionalLocationCategoryId = 0;
    areaCategoryId = @0;
    investmentAmountCategoryId = @0;
    characterCategoryId = @0;
    propertyTypeCategoryId = 0;
    smartSortingId = 0;
    currentType = 1;
    
    // 请求数据
    [self requestData];
    // 导航条
    //[self setNav:@"品牌加盟"];
    [self setupNav];
    // ui
    [self setupUI];
}

#pragma mark - 设置导航条
- (void)setupNav{
    
    [self setNav:@""];
    
    // 中间选择
    UIView *titleView = [[UIView alloc] init];
    titleView.frame = CGRectMake(0, 0, 200, 20);
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    titleLabel.text = @"品牌加盟";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [titleView addSubview:titleLabel];
    
    self.navigationItem.titleView = titleView;
    
    // 右btn
    UIButton*cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 0, 20, 20);
    [cancelButton setImage:[UIImage imageNamed:@"join_home_icon_seek"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(seekAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cancelButton];
}

#pragma mark - 搜索
- (void)seekAction{
    
    JoinSearchViewController *jsVC = [[JoinSearchViewController alloc] init];
    
    [self.navigationController pushViewController:jsVC animated:YES];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    UIView *header = [[UIView alloc] init];
    header.frame = CGRectMake(0, 0, viewWidth, 170);
    header.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:header];
    
    top_bg = [[UIScrollView alloc] init];
    top_bg.backgroundColor = [UIColor whiteColor];
    top_bg.pagingEnabled = YES;
    top_bg.showsHorizontalScrollIndicator = NO;
    top_bg.delegate = self;
    
    [header addSubview:top_bg];
    [top_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header.mas_top);
        make.left.equalTo(header.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 160));
    }];
    
    // 用于计算scrollview contentsize
    UIView *container = [[UIView alloc] init];
    [top_bg addSubview:container];
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(top_bg);

    }];
    
    // 按钮
    ModuleButton *lastBtn;
    for (int i=0; i<2; i++) {
        for (int j=0; j<[topType[@"title"] count]/2; j++) {
            
            ModuleButton *moduleButton = [[ModuleButton alloc]initWithFrame:CGRectMake((viewWidth/4)*(j%4)+i*viewWidth, 80*(j/4), viewWidth/4, 80)];
            CGSize btnSize = CGSizeMake(viewWidth/4, 80);
            [moduleButton setBackgroundImage:[Tools_F imageWithColor:bgColor size:btnSize] forState:UIControlStateHighlighted];
            moduleButton.icon.image = [UIImage imageNamed:topType[@"icon"][8*i+j]];
            moduleButton.tag = 8*i+j+100;
            moduleButton.bottomLabel.text = topType[@"title"][8*i+j];
            [moduleButton addTarget:self action:@selector(moduleClick:) forControlEvents:UIControlEventTouchUpInside];
            [top_bg addSubview:moduleButton];
            
            lastBtn = moduleButton;
        }
    }
    
    // 圆点
    pagePoint = [[UIPageControl alloc] init];
    pagePoint.pageIndicatorTintColor = bgColor;
    pagePoint.currentPageIndicatorTintColor = lgrayColor;
    pagePoint.numberOfPages = 2;
    [header addSubview:pagePoint];
    
    [pagePoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(top_bg.mas_bottom);
        make.left.equalTo(header.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
    }];
    
    [container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastBtn.mas_right);
    }];
    
    /*-                    table                    -*/
    
    table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    table.separatorStyle = NO;                  // 隐藏分割线
    table.delegate = self;
    table.dataSource = self;
    
    [table.panGestureRecognizer addTarget:self action:@selector(pan:)];      // 添加拖拽手势
    [table addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    table.tableHeaderView = header;
    
    [self.view addSubview:table];
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-44);
    }];
    
//    UIView * viewfoot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 60)];
//    table.tableFooterView = viewfoot;
//    
//    UIButton * footerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    footerBtn.frame = CGRectMake(10,10 , viewWidth-20, 40);
//    footerBtn.backgroundColor =[UIColor whiteColor];
//    [footerBtn setTitleColor:lgrayColor forState:UIControlStateNormal];
//    footerBtn.layer.cornerRadius = 5;
//    footerBtn.clipsToBounds = YES;
//    [footerBtn setTitle:@"加载更多" forState:UIControlStateNormal];
//    [viewfoot addSubview:footerBtn];
    
    
    /*-                    底部                    -*/
    bottomViews = [[UIView alloc] init];
    bottomViews.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomViews];
    
    JoinBottomButton *findBrank = [[JoinBottomButton alloc] init];
    findBrank.titleLabel.font = midFont;
    [findBrank setTitle:@"一键找品牌" forState:UIControlStateNormal];
    [findBrank setTitleColor:lgrayColor forState:UIControlStateNormal];
    findBrank.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    findBrank.imageView.contentMode = UIViewContentModeScaleAspectFit;
    findBrank.titleEdgeInsets = UIEdgeInsetsMake(0, -22, 2, 0);
    [findBrank setImage:[UIImage imageNamed:@"brand_zhaopingpai1"] forState:UIControlStateNormal];
//    [findBrank setImage:[UIImage imageNamed:@"brand_zhaopingpai2"] forState:UIControlStateHighlighted];
    [findBrank addTarget:self action:@selector(findBrank:) forControlEvents:UIControlEventTouchUpInside];
    [bottomViews addSubview:findBrank];
    
    JoinBottomButton *publish = [[JoinBottomButton alloc] init];
    publish.titleLabel.font = midFont;
    [publish setTitle:@"发布" forState:UIControlStateNormal];
    [publish setTitleColor:lgrayColor forState:UIControlStateNormal];
    publish.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    publish.imageView.contentMode = UIViewContentModeScaleAspectFit;
    publish.titleEdgeInsets = UIEdgeInsetsMake(0, -22, 2, 0);
    [publish setImage:[UIImage imageNamed:@"join_home_btn_issue"] forState:UIControlStateNormal];
//    [publish setImage:[UIImage imageNamed:@"join_home_btn_issue2"] forState:UIControlStateHighlighted];
    [publish addTarget:self action:@selector(brankPublish:) forControlEvents:UIControlEventTouchUpInside];
    [bottomViews addSubview:publish];
    
    JoinBottomButton *myBrank = [[JoinBottomButton alloc] init];
    myBrank.titleLabel.font = midFont;
    [myBrank setTitle:@"我的" forState:UIControlStateNormal];
    [myBrank setTitleColor:lgrayColor forState:UIControlStateNormal];
    myBrank.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    myBrank.imageView.contentMode = UIViewContentModeScaleAspectFit;
    myBrank.titleEdgeInsets = UIEdgeInsetsMake(0, -22, 2, 0);
    [myBrank setImage:[UIImage imageNamed:@"tabbar_item_mine_unSelected"] forState:UIControlStateNormal];
//    [myBrank setImage:[UIImage imageNamed:@"tabbar_item_mine_selected"] forState:UIControlStateHighlighted];
    [myBrank addTarget:self action:@selector(myBrank:) forControlEvents:UIControlEventTouchUpInside];
    [bottomViews addSubview:myBrank];
    
    [bottomViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@44);
    }];
    
    [findBrank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomViews.mas_top);
        make.left.equalTo(bottomViews.mas_left);
        make.right.equalTo(publish.mas_left);
        make.bottom.equalTo(bottomViews.mas_bottom);
        make.size.equalTo(@[publish,myBrank]);
    }];
    
    [publish mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomViews.mas_top);
        make.left.equalTo(findBrank.mas_right);
        make.right.equalTo(myBrank.mas_left);
        make.bottom.equalTo(bottomViews.mas_bottom);
        make.size.equalTo(@[findBrank,myBrank]);
    }];
    
    [myBrank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomViews.mas_top);
        make.left.equalTo(publish.mas_right);
        make.right.equalTo(bottomViews.mas_right);
        make.bottom.equalTo(bottomViews.mas_bottom);
        make.size.equalTo(@[publish,findBrank]);
    }];
}

#pragma mark - 十六模块点击
- (void)moduleClick:(UIButton *)btn{
    
    NSInteger currentIndex = (NSInteger)btn.tag-100;
    
    NSLog(@"~~~%@",topType[@"industryCategoryId"][currentIndex]);
    //JoinInViewController *jiVC = [[JoinInViewController alloc] init];
    JoinInNewViewController *jiVC = [[JoinInNewViewController alloc] init];
    //JoinInFFFViewController *jiVC = [[JoinInFFFViewController alloc] init];
    jiVC.industryCategoryId = topType[@"industryCategoryId"][currentIndex];
    bottomViews.hidden = YES;
    [self.navigationController pushViewController:jiVC animated:YES];
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
            bottomViews.hidden = NO;
            
            [table mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.bottom.equalTo(self.view.mas_bottom).with.offset(-44);
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
    
    if (scrollView == top_bg) {
        
        CGPoint point = scrollView.contentOffset; //记录滑动
        pagePoint.currentPage=(int)fabs(point.x/viewWidth);
    }
    else {
        
        // 滚动停止显示
        bottomViews.hidden = NO;
        [table mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).with.offset(-44);
        }];
    }
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
    
    return [_dataSource count];
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
    }
    
    FranchiseesMobel *model = _dataSource[indexPath.section];
    
    /*- 图片+logo -*/
    
    [cell.franchiseesImage sd_setImageWithURL:[NSURL URLWithString:model.f_defaultImage]  placeholderImage:[UIImage imageNamed:@"loading_b"]];
    [cell.franchiseesLogo sd_setImageWithURL:[NSURL URLWithString:model.f_brandLogo]  placeholderImage:[UIImage imageNamed:@"loading_l"]];
    /*- 加盟商名 -*/
    cell.franchiseesName.text = model.f_brandName;
    /*- 推荐 -*/
    cell.isRecommend = [model.f_type integerValue]==1?YES:NO;
    /*- 投资额度 (所属行业)-*/
    cell.investmentAmounts.text = model.f_industryCategoryName;
    /*- 行业 （门店数量）-*/
    cell.industry.text = [NSString stringWithFormat:@"%@",model.f_storeAmount];
    /*- 门店数量（投资额度） -*/
//    if ([model.f_type integerValue]==1) {
//        cell.franchiseesAmounts_unit.text = @"加盟优惠";//@"优惠额度";
//        cell.franchiseesAmounts.text = [NSString stringWithFormat:@"%@折",model.f_discount];
//    }
//    else
//    {
//        
//    }
    cell.franchiseesAmounts_unit.text = @"投资额度";//(万)
    cell.franchiseesAmounts.text = [NSString stringWithFormat:@"%@",model.f_investmentAmountCategoryName];
    
    return cell;
}

#pragma mark - 点击cell (tableView)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FranchiseesMobel *model = _dataSource[indexPath.section];
    
    NSInteger brandType = [model.f_type integerValue];
    
//    if (brandType == 1) {
    
//        PreferentialBrandViewController *pbVC = [[PreferentialBrandViewController alloc] init];
//        pbVC.brandId = model.f_brandId;
//        self.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:pbVC animated:YES];
//    }
//    else {
    
        //JoinDetailViewController *jdVC = [[JoinDetailViewController alloc] init];
    
    
//    }
    if (brandType == 1) {
        
//        NewJoinDatailBrandViewController *jdVC = [[NewJoinDatailBrandViewController alloc] init];
//        NormalJoinMoreViewController *jdVC = [[NormalJoinMoreViewController alloc] init];
        
//        NormalJoinViewController *jdVC = [[NormalJoinViewController alloc] init];
//        DirectNormalViewController *jdVC = [[DirectNormalViewController alloc] init];
        
        PreferentialJoinDetailViewController *jdVC = [[PreferentialJoinDetailViewController alloc]init];
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
//        MyJoinInViewController *jiVC = [[MyJoinInViewController alloc] init];
//        [self.navigationController pushViewController:jiVC animated:YES];
        MyIssueViewController * myisVc = [[MyIssueViewController alloc] init];
        [self.navigationController pushViewController:myisVc animated:YES];
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
