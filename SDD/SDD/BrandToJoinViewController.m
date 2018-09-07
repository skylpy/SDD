//
//  BrandToJoinViewController.m
//  CustomIntention
//  品牌加盟
//  Created by mac on 15/7/10.
//  Copyright (c) 2015年 linpeiyu. All rights reserved.
//

#import "BrandToJoinViewController.h"
#import "UIView+ZJQuickControl.h"
#import "Httprequest.h"
#import "LPYModelTool.h"
#import "RentShopsModel.h"
#import "RentShopsCellCell.h"
#import "BrandToJoinCell.h"

@interface BrandToJoinViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    //控制选择的不限
    int num ;
    
    int PregionId;//省份
    int CregionId;//市
    int industryCategoryId1;//产品分类一级
    int industryCategoryId2;//产品分类二级级
    int regionalLocationCategoryId;//区域位置
    int areaCategoryId;//选择需求面积
    int investmentAmountCategoryId;//资金
    int propertyTypeCategoryId;//物业类型
    int characterCategoryId;//品牌性质
    
    int ControlPage;//传值控制器
    
    UIView * minRentShopsView;
    UILabel * DetIndustryShopsLabel;
    UILabel * DetTypeShopsLabel;
    UILabel * DetsTateShopsLabel;
    UILabel * DetProjectNatureShopsLabel;
    UIView * RentShopsIndustryView;
    UIView * minRentShopsIndustryView;
    
    UIView * ProvinceView;
    UIView * CityView;
    
    UIImageView * lineImageView;
    
    int parentId;
    int industryCategoryId;
    
    NSString * morePath;
}
@property (retain,nonatomic)NSMutableArray * ExpandTheAreaArray;
@property (retain,nonatomic)UITableView * ProvinceTableView;
@property (retain,nonatomic)NSMutableArray * CityArray;
@property (retain,nonatomic)UITableView * CityTableView;

@property (retain,nonatomic)NSMutableArray * NdustryTypeArray;
@property (retain,nonatomic)UITableView * NdustryTypeTableView;

@property (retain,nonatomic)NSMutableArray * NdustryTypeRightArray;
@property (retain,nonatomic)UITableView * NdustryTypeRightTableView;

@property (retain,nonatomic)NSMutableArray * GeographicalArray;
@property (retain,nonatomic)UITableView * GeographicalTableView;


@property (retain,nonatomic)NSMutableArray * MoreArray;
@property (retain,nonatomic)UITableView * MoreTableView;

@property (retain,nonatomic)NSMutableArray * MoreRightArray;
@property (retain,nonatomic)UITableView * MoreRightTableView;

@end

@implementation BrandToJoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    parentId = 0;
    industryCategoryId = 0;
    morePath = @"";
    
    num = 0;
    ControlPage = 0;
    
    PregionId = 0;
    CregionId = 0;
    industryCategoryId1 = 0;
    industryCategoryId2 = 0;
    regionalLocationCategoryId = 0;
    areaCategoryId = 0;
    investmentAmountCategoryId = 0;
    propertyTypeCategoryId = 0;
    characterCategoryId = 0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self CreateMinRentShopsView];
    
    [self createNabView];
}

#pragma mark --  导航条返回按钮
-(void)createNabView
{
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"品牌加盟";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
//    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 0, 110, 20);
//    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [backBtn setTitle:@"品牌加盟" forState:UIControlStateNormal];
//    
//    UIImageView * backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
//    backImage.image = [UIImage imageNamed:@"返回-图标.png"];
//    [backBtn addSubview: backImage];
//    
//    UIBarButtonItem * backBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = backBtnItem;
}

#pragma mark -- 导航条返回按钮点击事件

-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 租商铺视图详细信息
-(void)CreateMinRentShopsView
{
    minRentShopsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, self.view.frame.size.height)];
    minRentShopsView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:minRentShopsView];
    
    NSArray * DetailsArray = @[@"拓展区域",@"行业类型",@"区域位置",@"更多"];
    NSArray * DetItemArray = @[@"请选择拓展区域",@"请选择行业类型",@"请选择区域位置",@""];
    for (int i = 0; i < DetailsArray.count; i ++) {
        
        //每一行的信息（添加手势）
        UIImageView * DetailsImageView = [minRentShopsView addImageViewWithFrame:CGRectMake(0, 44*i, viewWidth, 44) image:nil];
        [DetailsImageView addImageViewWithFrame:CGRectMake(0, 43, viewWidth, 1) image:@"line.png"];
        [DetailsImageView addLabelWithFrame:CGRectMake(10, 15, 80, 14) text:DetailsArray[i]];
        DetailsImageView.tag = 130+i;
        
        //在每个DetailsImageView上添加手势
        UITapGestureRecognizer * DetailsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DetailsTapClick:)];
        [DetailsImageView addGestureRecognizer:DetailsTap];
        
        //跳转页面箭头
        [DetailsImageView addImageViewWithFrame:CGRectMake(viewWidth-25, 16, 8, 12) image:@"the next_icon.png"];
        
        if (i == 0) {
            DetIndustryShopsLabel = [DetailsImageView addLabelWithFrame:CGRectMake(viewWidth-150, 15, 100, 14) text:DetItemArray[i]];
            DetIndustryShopsLabel.textAlignment = NSTextAlignmentRight;
            DetIndustryShopsLabel.textColor = [UIColor lightGrayColor];
            DetIndustryShopsLabel.font = [UIFont systemFontOfSize:14];
        }
        if (i == 1) {
            DetTypeShopsLabel = [DetailsImageView addLabelWithFrame:CGRectMake(viewWidth-150, 15, 100, 14) text:DetItemArray[i]];
            DetTypeShopsLabel.textAlignment = NSTextAlignmentRight;
            DetTypeShopsLabel.textColor = [UIColor lightGrayColor];
            DetTypeShopsLabel.font = [UIFont systemFontOfSize:14];
        }
        if (i == 2) {
            DetsTateShopsLabel = [DetailsImageView addLabelWithFrame:CGRectMake(viewWidth-150, 15, 100, 14) text:DetItemArray[i]];
            DetsTateShopsLabel.textAlignment = NSTextAlignmentRight;
            DetsTateShopsLabel.textColor = [UIColor lightGrayColor];
            DetsTateShopsLabel.font = [UIFont systemFontOfSize:14];
        }
        if (i == 3) {
            DetProjectNatureShopsLabel =[DetailsImageView addLabelWithFrame:CGRectMake(viewWidth-150, 15, 110, 14) text:nil];
            DetProjectNatureShopsLabel.textAlignment = NSTextAlignmentRight;
            DetProjectNatureShopsLabel.textColor = [UIColor lightGrayColor];
            DetProjectNatureShopsLabel.font = [UIFont systemFontOfSize:14];
        }
    }
    
    //尾部视图
    UIImageView * FootImageView = [minRentShopsView addImageViewWithFrame:CGRectMake(0, 175, viewWidth, minRentShopsView.frame.size.height-175) image:@"rent shops_frame2.png"];
    
    //定制我的意向按钮
    UIButton * CustomIntentionBtn =[FootImageView addImageButtonWithFrame:CGRectMake(10, 20, viewWidth-20, 44) title:nil backgroud:nil action:^(UIButton *button) {
        
        NSDictionary * dict = @{
                                @"brandAreaCategoryId":@(areaCategoryId),
                                @"brandCharacterCategoryId":@(characterCategoryId),
                                @"brandCityId":@(CregionId),
                                @"brandIndustryCategoryId1":@(industryCategoryId1),
                                @"brandIndustryCategoryId2":@(industryCategoryId2),
                                @"brandInvestmentAmountCategoryId":@(investmentAmountCategoryId),
                                @"brandPropertyTypeCategoryId":@(propertyTypeCategoryId),
                                @"brandProvinceId":@(PregionId),
                                @"brandRegionalLocationCategoryId":@(regionalLocationCategoryId),
                                @"type":@5
                                };
        
        // 定制
        [HttpTool postWithBaseURL:SDD_MainURL Path:@"/userCustomize/save.do" params:dict success:^(id JSON) {
            
            NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
            
            if ([JSON[@"status"] intValue] == 1) {
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:JSON[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
            
        } failure:^(NSError *error) {
            
        }];
    }];
    [CustomIntentionBtn setTitle:@"定制我的意向" forState:UIControlStateNormal];
    [CustomIntentionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [CustomIntentionBtn setBackgroundImage:[Tools_F imageWithColor:dblueColor size:CGSizeMake(viewWidth-40, 45)]forState:UIControlStateNormal];
    CustomIntentionBtn.layer.cornerRadius = 5;
    CustomIntentionBtn.clipsToBounds = YES;
}

#pragma maek -- 取消视图
-(void)tapRClick:(UITapGestureRecognizer *)tap {
    
    [RentShopsIndustryView removeFromSuperview];
    [minRentShopsIndustryView removeFromSuperview];
}

#pragma mark -- 租商铺视图详细信息手势
-(void)DetailsTapClick:(UITapGestureRecognizer *)tap
{
    
    NSLog(@"%ld",tap.view.tag);
    RentShopsIndustryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    RentShopsIndustryView.backgroundColor = [UIColor blackColor];
    RentShopsIndustryView.alpha = 0.5;
    [self.view addSubview:RentShopsIndustryView];
    
    UITapGestureRecognizer * tapR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRClick:)];
    [RentShopsIndustryView addGestureRecognizer:tapR];
    
#pragma mark -- 选择品牌加盟视图的三个自定义View
    [self createBrandToJoinTableView];
    
#pragma mark -- 拓展区域
    if (tap.view.tag == 130) {
        num = 130;
        [self createExpandTheAreaShopsDownLoad];
        
    }
#pragma mark -- 行业类型
    else if (tap.view.tag == 131)
    {
        num = 131;
        [self createIndustryTypeDownLoad];
        [self createIndustryTypeTableView];
        
    }
#pragma mark -- 区位位置
    else if (tap.view.tag == 132)
    {
        num = 132;
        [ProvinceView removeFromSuperview];
        [CityView removeFromSuperview];
        [lineImageView removeFromSuperview];
        [self createGeographicalDownLoad];
        
        [self createGeographicalTableView];
    }
#pragma mark -- 更多
    else if (tap.view.tag == 133)
    {
        num = 133;
        _MoreArray = [[NSMutableArray alloc] initWithObjects:@"需求面积",@"投资金额",@"物业类型",@"品牌性质", nil];
        [self createMoreView];
        [self createMoreLightTableView];
    }
}

#pragma mark -- 更多表格视图
-(void)createMoreLightTableView
{
    _MoreTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 120, 352-44) style:UITableViewStylePlain];
    _MoreTableView.delegate = self;
    _MoreTableView.dataSource = self;
    [ProvinceView addSubview:_MoreTableView];
    
    [self setExtraCellLineHidden:_MoreTableView];
}

#pragma mark -- 品牌加盟更多数据下载

-(void)createMoreDownLoad
{
    //NSString * url = @"http://192.168.1.234:8180/user_mobile";
    NSDictionary * dic = @{@"pageNumber":@1,@"pageSize":@10};
    
    _MoreRightArray = [[NSMutableArray alloc] init];
    [HttpRequest postWithNewIssueURL:SDD_MainURL path:morePath parameter:dic success:^(id Josn) {
        
        NSDictionary * dict = Josn;
        NSArray * ShopsArray = dict[@"data"];
        NSLog(@"%@",dict);
        
        for (NSDictionary * ShopsDict in ShopsArray) {
            
            RentShopsModel * model = [[RentShopsModel alloc] init];
            [model setValuesForKeysWithDictionary:ShopsDict];
            [_MoreRightArray addObject:model];
        }
        [self createMoreTableView];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -- 品牌加盟更多表格显示

-(void)createMoreTableView
{
    _MoreRightTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth-120, 352-44) style:UITableViewStylePlain];
    _MoreRightTableView.delegate = self;
    _MoreRightTableView.dataSource = self;
    [CityView addSubview:_MoreRightTableView];
    
    [self setExtraCellLineHidden:_MoreRightTableView];
}


#pragma mark -- 更多视图

-(void)createMoreView
{
    lineImageView.frame =CGRectMake(119,0 , 1, 352-43);
    ProvinceView.frame = CGRectMake(0, 0, 120, 352-43);
    CityView.frame =CGRectMake(120, 0, viewWidth-120, 352-43);

    UIImageView * crossLineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,352-43 , viewWidth, 1)];
    crossLineImage.image = [UIImage imageNamed:@"line.png"];
    [minRentShopsIndustryView addSubview:crossLineImage];
    
    NSArray * btnArray = @[@"重选",@"确定"];
    
    for (int i = 0; i < btnArray.count; i ++) {
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(45+i*(viewWidth-184), 313, 103, 34);
        [button setTitle:btnArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
        [button setBackgroundImage:[UIImage imageNamed:@"today's headline_frame.png"] forState:UIControlStateNormal];
        
        button.tag = 300+i;
        [button addTarget:self action:@selector(button1Click:) forControlEvents:UIControlEventTouchUpInside];
        [minRentShopsIndustryView  addSubview:button];
        
        if (button.tag == 301) {
            [button setTitleColor:dblueColor forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"custom_frame.png"] forState:UIControlStateNormal];
            [Tools_F setViewlayer:button cornerRadius:0 borderWidth:1 borderColor:dblueColor];
        }
    }
}

#pragma mark -- 点击事件
-(void)button1Click:(UIButton *)btn
{
    
    if (btn.tag == 300) {
        NSLog(@"重置");
        PregionId = 0;
        CregionId = 0;
        industryCategoryId1 = 0;
        industryCategoryId2 = 0;
        regionalLocationCategoryId = 0;
        areaCategoryId = 0;
        investmentAmountCategoryId = 0;
        propertyTypeCategoryId = 0;
        characterCategoryId = 0;
        
    }
    if(btn.tag == 301)
    {
        NSLog(@"确定");
        [RentShopsIndustryView removeFromSuperview];
        [minRentShopsIndustryView removeFromSuperview];

    }
    
}

#pragma mark -- 区位位置

-(void)createGeographicalTableView
{
    _GeographicalTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 352) style:UITableViewStylePlain];
    _GeographicalTableView.delegate = self;
    _GeographicalTableView.dataSource = self;
    [minRentShopsIndustryView addSubview:_GeographicalTableView];
    
    UIView * NoLimitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    UILabel * NoLimitLabel = [NoLimitView addLabelWithFrame:CGRectMake(15, 10, 120, 25) text:@"不限"];
    NoLimitLabel.font = [UIFont systemFontOfSize:18];
    [NoLimitView addImageViewWithFrame:CGRectMake(12,43 ,viewWidth-12 , 1) image:@"line.png"];
    //NoLimitLabel.textColor = [UIColor redColor];
    _GeographicalTableView.tableHeaderView = NoLimitView;
    
    UITapGestureRecognizer * NoLimitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(NoLimitTapClick:)];
    [NoLimitView addGestureRecognizer:NoLimitTap];
}

#pragma mark -- 品牌加盟区位位置数据下载

-(void)createGeographicalDownLoad
{
    //NSString * url = @"http://192.168.1.234:8180/user_mobile";
    NSString * path = @"/brandCategory/regionalLocationList.do";
    NSDictionary * dic = @{@"pageNumber":@1,@"pageSize":@10};
    
    _GeographicalArray = [[NSMutableArray alloc] init];
    [HttpRequest postWithNewIssueURL:SDD_MainURL path:path parameter:dic success:^(id Josn) {
        
        NSDictionary * dict = Josn;
        NSArray * ShopsArray = dict[@"data"];
        NSLog(@"%@",dict);
        
        for (NSDictionary * ShopsDict in ShopsArray) {
            
            RentShopsModel * model = [[RentShopsModel alloc] init];
            [model setValuesForKeysWithDictionary:ShopsDict];
            [_GeographicalArray addObject:model];
            
        }
        [_GeographicalTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark -- 行业类型视图

-(void)createIndustryTypeTableView
{
    _NdustryTypeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 120, 352) style:UITableViewStylePlain];
    _NdustryTypeTableView.delegate = self;
    _NdustryTypeTableView.dataSource = self;
    [_NdustryTypeTableView registerNib:[UINib nibWithNibName:@"BrandToJoinCell" bundle:nil] forCellReuseIdentifier:@"MYCellID"];
    [ProvinceView addSubview:_NdustryTypeTableView];
    
    UIView * NoLimitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    UILabel * NoLimitLabel = [NoLimitView addLabelWithFrame:CGRectMake(15, 10, 120, 25) text:@"不限"];
    NoLimitLabel.font = [UIFont systemFontOfSize:18];
    [NoLimitView addImageViewWithFrame:CGRectMake(12,43 ,viewWidth-12 , 1) image:@"line.png"];
    //NoLimitLabel.textColor = [UIColor redColor];
    _NdustryTypeTableView.tableHeaderView = NoLimitView;
    
    UITapGestureRecognizer * NoLimitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(NoLimitTapClick:)];
    [NoLimitView addGestureRecognizer:NoLimitTap];
}

#pragma mark -- 品牌加盟行业类型数据下载

-(void)createIndustryTypeDownLoad
{
    //NSString * url = @"http://192.168.1.234:8180/user_mobile";
    NSString * path = @"/brandCategory/industryList.do";
    NSDictionary * dic = @{@"pageNumber":@1,@"pageSize":@10,@"params":@{@"parentId":@0}};
    
    _NdustryTypeArray = [[NSMutableArray alloc] init];
    [HttpRequest postWithNewIssueURL:SDD_MainURL path:path parameter:dic success:^(id Josn) {
        
        NSDictionary * dict = Josn;
        NSArray * ShopsArray = dict[@"data"];
        
        NSLog(@"%@",dict);
        
        for (NSDictionary * ShopsDict in ShopsArray) {
            
            RentShopsModel * model = [[RentShopsModel alloc] init];
            [model setValuesForKeysWithDictionary:ShopsDict];
            [_NdustryTypeArray addObject:model];
        }
        [_NdustryTypeTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -- 品牌加盟行业右边表格显示

-(void)createIndustryRightTableView
{
    _NdustryTypeRightTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth-120, 352) style:UITableViewStylePlain];
    _NdustryTypeRightTableView.delegate = self;
    _NdustryTypeRightTableView.dataSource = self;
    [CityView addSubview:_NdustryTypeRightTableView];
    
    [self setExtraCellLineHidden:_NdustryTypeRightTableView];
}

#pragma mark -- 品牌加盟二级行业类型数据下载

-(void)createIndustryTypeRightDownLoad
{
    //NSString * url = @"http://192.168.1.234:8180/user_mobile";
    NSString * path = @"/brandCategory/industryList.do";
    NSDictionary * dic = @{@"pageNumber":@1,@"pageSize":@10,@"params":@{@"parentId":@(industryCategoryId)}};
    
    _NdustryTypeRightArray = [[NSMutableArray alloc] init];
    [HttpRequest postWithNewIssueURL:SDD_MainURL path:path parameter:dic success:^(id Josn) {
        
        NSDictionary * dict = Josn;
        NSArray * ShopsArray = dict[@"data"];
        NSLog(@"%@",dict);
        
        for (NSDictionary * ShopsDict in ShopsArray) {
            
            RentShopsModel * model = [[RentShopsModel alloc] init];
            [model setValuesForKeysWithDictionary:ShopsDict];
            [_NdustryTypeRightArray addObject:model];
        }
        [self createIndustryRightTableView];
    } failure:^(NSError *error) {
        
    }];
}





#pragma mark -- 选择品牌加盟视图的三个自定义View

-(void)createBrandToJoinTableView
{
    
    minRentShopsIndustryView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight-430, viewWidth, 430)];
    minRentShopsIndustryView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:minRentShopsIndustryView];
    
    ProvinceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 430)];
    [minRentShopsIndustryView addSubview:ProvinceView];
    
    lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(119,0 , 1, 430)];
    lineImageView.image = [UIImage imageNamed:@"slide wire_btn.png"];
    
    [minRentShopsIndustryView addSubview:lineImageView];
    
    CityView = [[UIView alloc] initWithFrame:CGRectMake(120, 0, 200, 430)];
    [minRentShopsIndustryView addSubview:CityView];
   
}

#pragma mark -- 品牌加盟区域拓展数据下载

-(void)createExpandTheCityShopsDownLoad
{
   // NSString * url = @"http://192.168.1.234:8180/user_mobile";
    NSString * path = @"/brandRegion/list.do";
    NSDictionary * dic = @{@"parentId":@(parentId)};
    
    NSLog(@"%@",dic);
    
    _CityArray = [[NSMutableArray alloc] init];
    [HttpRequest postWithNewIssueURL:SDD_MainURL path:path parameter:dic success:^(id Josn) {
        
        NSDictionary * dict = Josn;
         NSLog(@"%@",dict);
        NSArray * ShopsArray = dict[@"data"];
        NSLog(@"%ld",ShopsArray.count);
        
        for (NSDictionary * ShopsDict in ShopsArray) {
            RentShopsModel * model = [[RentShopsModel alloc] init];
            [model setValuesForKeysWithDictionary:ShopsDict];
            [_CityArray addObject:model];
        }
        [_CityTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -- 品牌加盟区域拓展左边表格显示

-(void)createRightTableView
{
    _CityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth-120, 352) style:UITableViewStylePlain];
    _CityTableView.delegate = self;
    _CityTableView.dataSource = self;
    [CityView addSubview:_CityTableView];
    
    [self setExtraCellLineHidden:_CityTableView];
    
}

#pragma mark -- UITableView隐藏多余的分割线

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

#pragma mark -- 品牌加盟区域拓展数据下载

-(void)createExpandTheAreaShopsDownLoad
{
    //NSString * url = @"http://192.168.1.234:8180/user_mobile";
    NSString * path = @"/brandRegion/list.do";
    NSDictionary * dic = @{@"parentId":@1};
    
    _ExpandTheAreaArray = [[NSMutableArray alloc] init];
    [HttpRequest postWithNewIssueURL:SDD_MainURL path:path parameter:dic success:^(id Josn) {
        
        NSDictionary * dict = Josn;
        NSArray * ShopsArray = dict[@"data"];
        NSLog(@"%@",dict);
        
        for (NSDictionary * ShopsDict in ShopsArray) {
            
            RentShopsModel * model = [[RentShopsModel alloc] init];
            [model setValuesForKeysWithDictionary:ShopsDict];
            [_ExpandTheAreaArray addObject:model];
        }
        [self createMinTableView];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -- 品牌加盟区域拓展左边表格显示

-(void)createMinTableView
{
    _ProvinceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 120, 352) style:UITableViewStylePlain];
    _ProvinceTableView.delegate = self;
    _ProvinceTableView.dataSource = self;
    [_ProvinceTableView registerNib:[UINib nibWithNibName:@"BrandToJoinCell" bundle:nil] forCellReuseIdentifier:@"MYCellID"];
    //_ProvinceTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [ProvinceView addSubview:_ProvinceTableView];
    
    UIView * NoLimitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    UILabel * NoLimitLabel = [NoLimitView addLabelWithFrame:CGRectMake(10, 10, 120, 25) text:@"不限"];
    NoLimitLabel.font = [UIFont systemFontOfSize:18];
    [NoLimitView addImageViewWithFrame:CGRectMake(10,43 ,300 , 1) image:@"line.png"];
    //NoLimitLabel.textColor = [UIColor redColor];
    _ProvinceTableView.tableHeaderView = NoLimitView;
    
    UITapGestureRecognizer * NoLimitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(NoLimitTapClick:)];
    [NoLimitView addGestureRecognizer:NoLimitTap];
}
#pragma mark -- 创建TableView头部视图的点击手势

-(void)NoLimitTapClick:(UITapGestureRecognizer *)tap
{
    if (num == 130) {
        DetIndustryShopsLabel.text = @"不限";
    }
    if (num == 131) {
        DetTypeShopsLabel.text = @"不限";
    }
    if (num == 132) {
        DetsTateShopsLabel.text = @"不限";
    }
    if (num == 133) {
        DetProjectNatureShopsLabel.text = @"不限";
    }
    
    [minRentShopsIndustryView removeFromSuperview];
    [RentShopsIndustryView removeFromSuperview];
}


//上个cell颜色还原
#pragma mark -- 还原上个cell颜色还原

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor blackColor];
    
    if(tableView == _ProvinceTableView)
    {
        BrandToJoinCell *cell = (BrandToJoinCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.Province.textColor = [UIColor blackColor];
    }
    
}





#pragma mark -- 点击事件代理方法

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = dblueColor;
    
    //        PregionId
    //        CregionId
    //        industryCategoryId1
    //        industryCategoryId2
    
    
    //        regionalLocationCategoryId
    
    

    
    
    if (tableView == _ProvinceTableView) {
        BrandToJoinCell *cell = (BrandToJoinCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.Province.textColor = dblueColor;
        
        RentShopsModel * model = _ExpandTheAreaArray[indexPath.row];
        parentId = [[NSString stringWithFormat:@"%@",model.regionId] intValue];
        
        PregionId = [[NSString stringWithFormat:@"%@",model.regionId] intValue];
        
        NSLog(@"PregionId=%d",PregionId);
        
        NSLog(@"%d",parentId);
        NSLog(@"%@",model.regionId);
        [self createExpandTheCityShopsDownLoad];
        [self createRightTableView];
    }
    else if(tableView == _CityTableView) {
        RentShopsModel * model = _CityArray[indexPath.row];
        DetIndustryShopsLabel.text = model.regionName;
        
        CregionId = [[NSString stringWithFormat:@"%@",model.regionId] intValue];
        
        NSLog(@"CregionId = %d",CregionId);
        
        [RentShopsIndustryView removeFromSuperview];
        [minRentShopsIndustryView removeFromSuperview];
    }
    else if(tableView == _NdustryTypeTableView)
    {
        
        RentShopsModel * model = _NdustryTypeArray[indexPath.row];
        industryCategoryId = [[NSString stringWithFormat:@"%@",model.industryCategoryId] intValue];
        NSLog(@"%d",industryCategoryId);
        
        industryCategoryId1 = [[NSString stringWithFormat:@"%@",model.industryCategoryId] intValue];
        
        NSLog(@"industryCategoryId1=%d",industryCategoryId1);
        
        [self createIndustryTypeRightDownLoad];
        
    }else if(tableView == _NdustryTypeRightTableView)
    {
        RentShopsModel * model = _NdustryTypeRightArray[indexPath.row];
        DetTypeShopsLabel.text = model.categoryName;
        
        industryCategoryId2 = [[NSString stringWithFormat:@"%@",model.industryCategoryId] intValue];
        
        NSLog(@"industryCategoryId2=%d",industryCategoryId2);
        
        [RentShopsIndustryView removeFromSuperview];
        [minRentShopsIndustryView removeFromSuperview];
    }
    else if(tableView == _GeographicalTableView)
    {
        RentShopsModel * model = _GeographicalArray[indexPath.row];
        DetsTateShopsLabel.text =model.categoryName;
        
        regionalLocationCategoryId = [[NSString stringWithFormat:@"%@",model.regionalLocationCategoryId] intValue];
        
        NSLog(@"regionalLocationCategoryId=%d",regionalLocationCategoryId);
        
        [RentShopsIndustryView removeFromSuperview];
        [minRentShopsIndustryView removeFromSuperview];
    }
    
    else if (tableView == _MoreTableView)
    {

        
        if (indexPath.row == 0) {
            ControlPage = 1;
           morePath = @"/brandCategory/areaCategoryList.do";
        }
        if (indexPath.row == 1) {
            ControlPage = 2;
            morePath = @"/brandCategory/investmentAmountCategoryList.do";
        }
        if (indexPath.row == 2) {
            ControlPage = 3;
            morePath = @"/brandCategory/propertyTypeCategoryList.do";
        }
        if (indexPath.row == 3) {
            ControlPage = 4;
           morePath = @"/brandCategory/characterCategoryList.do";
        }
        [self createMoreDownLoad];
    }
    else if (tableView == _MoreRightTableView)
    {
        RentShopsModel * model = _MoreRightArray[indexPath.row];
        DetProjectNatureShopsLabel.text =model.categoryName;
        
        if (ControlPage == 1) {
            areaCategoryId = [[NSString stringWithFormat:@"%@",model.areaCategoryId] intValue];
            NSLog(@"areaCategoryId=%d",areaCategoryId);
        }
        if (ControlPage == 2) {
            investmentAmountCategoryId = [[NSString stringWithFormat:@"%@",model.investmentAmountCategoryId] intValue];
            NSLog(@"investmentAmountCategoryId=%d",investmentAmountCategoryId);

        }
        if (ControlPage == 3) {
            propertyTypeCategoryId = [[NSString stringWithFormat:@"%@",model.propertyTypeCategoryId] intValue];
            NSLog(@"propertyTypeCategoryId=%d",propertyTypeCategoryId);
        }
        if (ControlPage == 4) {
            characterCategoryId = [[NSString stringWithFormat:@"%@",model.characterCategoryId] intValue];
            NSLog(@"characterCategoryId=%d",characterCategoryId);
        }
        

    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _ProvinceTableView)
    {
        return _ExpandTheAreaArray.count;
    }
    else if(tableView == _CityTableView)
    {
        return _CityArray.count;
    }
    else if (tableView == _NdustryTypeTableView)
    {
        return _NdustryTypeArray.count;
    }
    else if (tableView == _NdustryTypeRightTableView)
    {
        return _NdustryTypeRightArray.count;
    }
    else if (tableView == _GeographicalTableView)
    {
        return _GeographicalArray.count;
    }
    else if (tableView == _MoreTableView)
    {
        return _MoreArray.count;
    }
    else if (tableView == _MoreRightTableView)
    {
        return _MoreRightArray.count;
    }
    return 0;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _ProvinceTableView) {
        static NSString * cellID = @"MYCellID";
        BrandToJoinCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (cell == nil) {
            cell = [[BrandToJoinCell alloc] init];
        }
        RentShopsModel * model = _ExpandTheAreaArray[indexPath.row];
        cell.Province.text =model.regionName;
        
        return cell;
    }
    else if(tableView == _CityTableView)
    {
        static NSString * CellId = @"CityCellId";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] init];
        }
        RentShopsModel * model = _CityArray[indexPath.row];
        cell.textLabel.text = model.regionName;
        return cell;
        
    }
    else if(tableView == _NdustryTypeTableView){
        static NSString * CellId = @"CellId";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] init];
        }
        RentShopsModel * model = _NdustryTypeArray[indexPath.row];
        cell.textLabel.text = model.categoryName;
        return cell;
    }
    else if (tableView == _GeographicalTableView)
    {
        static NSString * CellId = @"CellId";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] init];
        }
        RentShopsModel * model = _GeographicalArray[indexPath.row];
        cell.textLabel.text = model.categoryName;
        return cell;
    }
    else if (tableView == _MoreTableView)
    {
        static NSString * CellId = @"CellId";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellId];
       // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] init];
        }
        cell.textLabel.text = _MoreArray[indexPath.row];
        return cell;
    }
    else if (tableView == _MoreRightTableView)
    {
        static NSString * CellId = @"CellId";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] init];
        }
        RentShopsModel * model = _MoreRightArray[indexPath.row];
        cell.textLabel.text = model.categoryName;
        return cell;
    }
    else
    {
        static NSString * CellId = @"CellId";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellId];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] init];
        }
        RentShopsModel * model = _NdustryTypeRightArray[indexPath.row];
        cell.textLabel.text = model.categoryName;
        return cell;
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
