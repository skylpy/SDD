//
//  HRDetailViewController.m
//  SDD
//
//  Created by hua on 15/4/14.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "HRDetailViewController.h"
#import "HouseDetialViews.h"
#import "ThumbnailButton.h"
#import "EvalutaionTableViewCell.h"
#import "ConsultantTableViewCell.h"
#import "HouseDetailModel.h"

#import "AllChildViewController.h"

#import "UUChart.h"
#import "CWStarRateView.h"
#import "Tools_F.h"
#import "TTTAttributedLabel.h"
#import "AFNetworking.h"
#import "BMapKit.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "ShareHelper.h"

@interface HRDetailViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UUChartDataSource,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>{
    
    /*- data -*/
    
    NSArray *time_X;
    NSArray *house_Y;
    NSArray *region_Y;
    
    float curLatitude;
    float curLongitude;
    
    HouseDetailModel *model;                        // 模型
    
    NSArray *paraTitle;
    NSArray *paraContent;
    
    /*- ui -*/
    
    UIScrollView *bg_scrollView;
    UIView *botView;
    HouseEvaluation *evaluationContent;
    HousePriceSwing *priceSwingContent;
    HouseRecommend *nearContent;
    HouseRecommend *sameContent;
    HouseRecommend *rentContent;
    HouseRecommend *buyContent;

    /*- 地图 -*/
    
    BMKMapView *mapView;
    BMKLocationService *locService;
    BMKGeoCodeSearch *geocodesearch;
}

// 网络请求
@property (nonatomic, strong) AFHTTPRequestOperationManager *httpManager;
// 楼盘详情
@property (nonatomic, strong) NSMutableArray *hdDataArr;

@end

@implementation HRDetailViewController

- (NSMutableArray *)hdDataArr{
    if (!_hdDataArr) {
        _hdDataArr = [[NSMutableArray alloc]init];
    }
    return _hdDataArr;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [mapView viewWillAppear];
    
    mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    locService.delegate = self;
    geocodesearch.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [mapView viewWillDisappear];
    
    mapView.delegate = nil; // 不用时，置nil
    locService.delegate = nil;
    geocodesearch.delegate = nil;
}

#pragma mark - 请求数据
- (void)requestData{
    
    [bg_scrollView removeFromSuperview];     // 移除原有视图
    [botView removeFromSuperview];
    
    [self showLoading:1];
    // 请求参数
    NSDictionary *dic = @{@"activityCategoryId":@3,@"houseId":[NSString stringWithFormat:@"%@",_houseID]};

    NSString *urlString = [SDD_MainURL stringByAppendingString:@"/house/houseDetail.do"];              // 拼接主路径和请求内容成完整url
    
    [self.httpManager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = responseObject;
        NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
        if (![dict[@"data"] isEqual:[NSNull null]]) {
            
            model = [HouseDetailModel hdWithDict:dict[@"data"]];
            
            // 导航条
            [self setupNav];
            // 加载数据
            [self setupData];
            // ui
            [self setupUI];
            // 刷新数据并回滚到最上
            [bg_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        
        [self hideLoading];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"错误 -- %@", error);
        [self hideLoading];
    }];
}

#pragma mark - 加载数据
- (void)setupData{
    
    paraTitle = @[
                  @"开盘时间",
                  @"规划业态",
                  @"建筑类型",
                  @"规划面积",
                  @"建筑面积",
                  @"公摊率",
                  @"容积率",
                  @"绿化率",
                  @"地上车位数",
                  @"地下车位数",
                  @"物业数量",
                  @"开发商",
                  @"运营管理公司",
                  @"产权年限",
                  @"开工时间",
                  @"竣工时间"
                  ];
    
    paraContent = @[
                    [model.hd_house[@"openedTime"] intValue] == 0?@"未开盘":[NSString stringWithFormat:@"%@",[Tools_F timeTransform:[model.hd_house[@"openedTime"] intValue] time:days]],
                    model.hd_house[@"planFormat"] == nil?@"暂无":[NSString stringWithFormat:@"%@",model.hd_house[@"planFormat"]],
                    model.hd_house[@"buildingType"] == nil?@"暂无":[NSString stringWithFormat:@"%@",model.hd_house[@"buildingType"]],
                    model.hd_house[@"planArea"] == nil?@"暂无":[NSString stringWithFormat:@"%@亩",model.hd_house[@"planArea"]],
                    model.hd_house[@"buildingArea"] == nil?@"暂无":[NSString stringWithFormat:@"%@m²",model.hd_house[@"buildingArea"]],
                    model.hd_house[@"publicRoundRate"] == nil || [model.hd_house[@"publicRoundRate"] isEqualToString:@""]?@"暂无":[NSString stringWithFormat:@"%@",model.hd_house[@"publicRoundRate"]],
                    model.hd_house[@"volumeRate"] == nil || [model.hd_house[@"volumeRate"] isEqualToString:@""]?@"暂无":[NSString stringWithFormat:@"%@",model.hd_house[@"volumeRate"]],
                    model.hd_house[@"greeningRate"] == nil || [model.hd_house[@"greeningRate"] isEqualToString:@"暂无"]?@"":[NSString stringWithFormat:@"%@",model.hd_house[@"greeningRate"]],
                    model.hd_house[@"groundParkingSpaces"] == nil?@"暂无":[NSString stringWithFormat:@"%@",model.hd_house[@"groundParkingSpaces"]],
                    model.hd_house[@"undergroundParkingSpaces"] == nil?@"暂无":[NSString stringWithFormat:@"%@",model.hd_house[@"undergroundParkingSpaces"]],
                    model.hd_house[@"properties"] == nil?@"暂无":[NSString stringWithFormat:@"%@",model.hd_house[@"properties"]],
                    model.hd_houseDeveloper [@"developersName"] == nil?@"暂无":[NSString stringWithFormat:@"%@",model.hd_houseDeveloper [@"developersName"]],
                    model.hd_house[@"operationsManagement"] == nil?@"暂无":[NSString stringWithFormat:@"%@",model.hd_house[@"operationsManagement"]],
                    model.hd_house[@"propertyAge"] == nil?@"暂无":[NSString stringWithFormat:@"%@",model.hd_house[@"propertyAge"]],
                    [model.hd_house[@"buildingStartTime"] intValue] == 0?@"未开工":[NSString stringWithFormat:@"%@",[Tools_F timeTransform:[model.hd_house[@"buildingStartTime"] intValue] time:days]],
                    [model.hd_house[@"buildingEndTime"] intValue] == 0?@"未竣工":[NSString stringWithFormat:@"%@",[Tools_F timeTransform:[model.hd_house[@"buildingEndTime"] intValue] time:days]]
                    ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];

    // 导航条
    [self setupNav];
    // 加载数据
    [self requestData];
}

#pragma mark - 设置导航条
- (void)setupNav{
    
    SDDButton *button = [[SDDButton alloc]init];
    button.frame = CGRectMake(0, 0, viewWidth*2/3, 44);
    [button setTitle:model.hd_house[@"houseName"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    // 导航条右
    UIButton *star = [UIButton buttonWithType:UIButtonTypeCustom];
    star.frame = CGRectMake(0, 0, 20, 20);
    [star setBackgroundImage:[UIImage imageNamed:@"收藏-图标"] forState:UIControlStateNormal];
    [star setBackgroundImage:[UIImage imageNamed:@"收藏星星"] forState:UIControlStateSelected];
    [star addTarget:self action:@selector(starClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 判断是否收藏
    if ([model.hd_house[@"isCollectioned"] integerValue]==1) {
        star.selected = YES;
    }
    
    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
    share.frame = CGRectMake(0, 0, 19, 20);
    [share setBackgroundImage:[UIImage imageNamed:@"分享-图标"] forState:UIControlStateNormal];
    [share addTarget:self action:@selector(HRshareBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barStar = [[UIBarButtonItem alloc]initWithCustomView:star];
    UIBarButtonItem *barShare = [[UIBarButtonItem alloc]initWithCustomView:share];
    self.navigationItem.rightBarButtonItems = @[barShare,barStar];
}


- (void)HRshareBtn{
    
    [ShareHelper shareIn:self content:@"Hello" url:@"http://www.shangdodo.com"];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    // 底部滚动
    bg_scrollView = [[UIScrollView alloc] init];
    
    [self.view addSubview:bg_scrollView];
    [bg_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 底部view， 用于计算scrollview高度
    UIView* contentView = [[UIView alloc] init];
    [bg_scrollView addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bg_scrollView);
    }];
    
    /*------------------------------ 顶部图+基本参数 ------------------------------*/
    
    UIImageView *_headImage = [[UIImageView alloc] init];
    [_headImage sd_setImageWithURL:[NSURL URLWithString:model.hd_house[@"defaultImage"]] placeholderImage:[UIImage imageNamed:@"loading_b"]];
    _headImage.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *hTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topImageTap:)];
    [_headImage addGestureRecognizer:hTap];
    
    UIImageView *videoImage = [[UIImageView alloc] init];
    videoImage.image = [UIImage imageNamed:@"index_icon_video_gray"];
    
    UIImageView *imgIcon = [[UIImageView alloc] init];
    imgIcon.image = [UIImage imageNamed:@"图片-图标"];
    
    UILabel *_imageCounts = [[UILabel alloc] init];
    _imageCounts.textColor = [UIColor whiteColor];
    _imageCounts.font = midFont;
    _imageCounts.text = [NSString stringWithFormat:@"共%d张",[model.hd_images[@"activityDiagramUrls"] count]+
                         [model.hd_images[@"activityDiagramUrls"] count]+
                         [model.hd_images[@"floorPlanUrls"] count]+
                         [model.hd_images[@"formatFigureUrls"] count]+
                         [model.hd_images[@"modelMapUrls"] count]+
                         [model.hd_images[@"openHousesUrls"] count]+
                         [model.hd_images[@"panorama360Urls"] count]+
                         [model.hd_images[@"projectSiteUrls"] count]+
                         [model.hd_images[@"promotionalMaterialsUrls"] count]+
                         [model.hd_images[@"realMapUrls"] count]+
                         [model.hd_images[@"supportingMapUrls"] count]+
                         [model.hd_images[@"trafficMapUrls"] count]+
                         [model.hd_images[@"videoUrls"] count]];
    _imageCounts.textAlignment = NSTextAlignmentRight;
    
    UIView *price_bg = [[UIView alloc] init];
    price_bg.backgroundColor = [UIColor whiteColor];
    // 价格
    UILabel *_price = [[UILabel alloc] init];
    _price.textColor = deepOrangeColor;
    _price.font = largeFont;
    _price.text = [model.hd_house[@"price"] intValue] == 0?@"销售参考价: 待定":[NSString stringWithFormat:@"销售参考价: %@元/m²",model.hd_house[@"price"]];
    [_price sizeToFit];
    
    // 计算器
    UIButton *_calcButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_calcButton setImageEdgeInsets:UIEdgeInsetsMake(9, 7.5, 9, 7.5)];
    [_calcButton setImage:[UIImage imageNamed:@"计算机（纯）-图标"] forState:UIControlStateNormal];
    [_calcButton addTarget:self action:@selector(calcClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 租金参考价
    UILabel *_rentPrice = [[UILabel alloc] init];
    _rentPrice.textColor = deepOrangeColor;
    _rentPrice.font = largeFont;
    _rentPrice.text = [model.hd_house[@"rentPrice"] intValue] == 0?@"租金参考价: 未定":[NSString stringWithFormat:@"租金参考价: %@元/m²",model.hd_house[@"rentPrice"]];
    
    // 销售状态
    UILabel *_saleStatus = [[UILabel alloc] init];
    _saleStatus.textColor = lgrayColor;
    _saleStatus.font = midFont;
    [price_bg addSubview:_saleStatus];
    
    NSString *beforePaintStr = [NSString stringWithFormat:@"销售状态: %@",[model.hd_house[@"openedTime"] floatValue] == 0?@"未开业":@"已开盘"];
    NSMutableAttributedString *paintStr = [[NSMutableAttributedString alloc] initWithString:beforePaintStr];
    [paintStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:[beforePaintStr rangeOfString:@"销售状态: "]];
    _saleStatus.attributedText = paintStr;
    
    // 招商状态
    UILabel *_merchantsStatus = [[UILabel alloc] init];
    _merchantsStatus.textColor = lgrayColor;
    _merchantsStatus.font = midFont;
    
    // 状态
    switch ([model.hd_house[@"merchantsStatus"] intValue]) {
        case 1:
        {
            beforePaintStr = @"招商状态: 意向登记";
        }
            break;
        case 2:
        {
            beforePaintStr = @"招商状态: 意向租赁";
        }
            break;
        case 3:
        {
            beforePaintStr = @"招商状态: 品牌转定";
        }
            break;
        default:
        {
            beforePaintStr = @"招商状态: 未定";
        }
            break;
    }
    
    paintStr = [[NSMutableAttributedString alloc]initWithString:beforePaintStr];
    [paintStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:[beforePaintStr rangeOfString:@"招商状态: "]];
    _merchantsStatus.attributedText = paintStr;
    
    // 开盘时间
    UILabel *_opening = [[UILabel alloc] init];
    _opening.textColor = lgrayColor;
    _opening.font = midFont;
    
    beforePaintStr = [NSString stringWithFormat:@"开盘时间: %@",[model.hd_house[@"openingTime"] floatValue] == 0?@"未开盘":[Tools_F timeTransform:[model.hd_house[@"openingTime"] floatValue] time:days]];
    paintStr = [[NSMutableAttributedString alloc] initWithString:beforePaintStr];
    [paintStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:[beforePaintStr rangeOfString:@"开盘时间: "]];
    _opening.attributedText = paintStr;
    
    // 开业时间
    UILabel *labelBO = [[UILabel alloc] init];
    labelBO.textColor = lgrayColor;
    labelBO.font = midFont;
    
    beforePaintStr = [NSString stringWithFormat:@"开业时间: %@",[model.hd_house[@"openedTime"] floatValue] == 0?@"未开业":[Tools_F timeTransform:[model.hd_house[@"openedTime"] floatValue] time:days]];
    paintStr = [[NSMutableAttributedString alloc] initWithString:beforePaintStr];
    [paintStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:[beforePaintStr rangeOfString:@"开业时间: "]];
    labelBO.attributedText = paintStr;
    
    // 地址
    UILabel *_address = [[UILabel alloc] init];
    _address.textColor = lgrayColor;
    _address.font = midFont;
    
    beforePaintStr = [NSString stringWithFormat:@"地址: %@",model.hd_house[@"address"]];
    paintStr = [[NSMutableAttributedString alloc] initWithString:beforePaintStr];
    [paintStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:[beforePaintStr rangeOfString:@"地址: "]];
    _address.attributedText = paintStr;
    
    [bg_scrollView addSubview:_headImage];
    [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 240));
    }];
    
    [_headImage addSubview:videoImage];
    [videoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImage).with.offset(8);
        make.bottom.equalTo(_headImage).with.offset(-8);
        make.size.mas_equalTo(CGSizeMake(30, 15));
    }];
    
    [_headImage addSubview:imgIcon];
    [imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_headImage).with.offset(-8);
        make.bottom.equalTo(_headImage).with.offset(-8);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [_headImage addSubview:_imageCounts];
    [_imageCounts mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imgIcon.mas_left).with.offset(-5);
        make.bottom.equalTo(_headImage).with.offset(-8);
        make.size.mas_equalTo(CGSizeMake(120, 15));
    }];
    
    [bg_scrollView addSubview:price_bg];
    [price_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImage.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.right.equalTo(bg_scrollView.mas_right);
    }];
    
    [price_bg addSubview:_price];
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@12);
        make.left.equalTo(@8);
        make.height.equalTo(@16);
    }];
    
    [price_bg addSubview:_calcButton];
    [_calcButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@3);
        make.left.equalTo(_price.mas_right).with.offset(1.5);
        make.width.equalTo(@30);
        make.height.equalTo(@36);
    }];
    
    [price_bg addSubview:_rentPrice];
    [_rentPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_price.mas_bottom).with.offset(12);
        make.left.equalTo(@8);
        make.width.equalTo(bg_scrollView).with.offset(-16);
        make.height.equalTo(@13);
    }];
    
    [price_bg addSubview:_saleStatus];
    [_saleStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_rentPrice.mas_bottom).with.offset(12);
        make.left.equalTo(@8);
        make.width.equalTo(bg_scrollView).with.offset(-16);
        make.height.equalTo(@13);
    }];
    
    [price_bg addSubview:_merchantsStatus];
    [_merchantsStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_saleStatus.mas_bottom).with.offset(12);
        make.left.equalTo(@8);
        make.width.equalTo(bg_scrollView).with.offset(-16);
        make.height.equalTo(@13);
    }];
    
    [price_bg addSubview:_opening];
    [_opening mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_merchantsStatus.mas_bottom).with.offset(12);
        make.left.equalTo(@8);
        make.width.equalTo(bg_scrollView).with.offset(-16);
        make.height.equalTo(_merchantsStatus);
    }];
    
    [price_bg addSubview:labelBO];
    [labelBO mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_opening.mas_bottom).with.offset(12);
        make.left.equalTo(@8);
        make.width.equalTo(bg_scrollView).with.offset(-16);
        make.height.equalTo(_merchantsStatus);
    }];

    [price_bg addSubview:_address];
    [_address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelBO.mas_bottom).with.offset(12);
        make.left.equalTo(@8);
        make.width.equalTo(bg_scrollView).with.offset(-16);
        make.height.equalTo(_opening);
    }];
    
    [price_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_address.mas_bottom).with.offset(12);
    }];
    
    /*------------------------------ 招商对象 ------------------------------*/
    
    HouseDetailTitle *attractInvestmentObjectTitle  = [[HouseDetailTitle alloc] init];
    attractInvestmentObjectTitle.theTitle.text = @"招商对象";
    attractInvestmentObjectTitle.titleType = haveArrow;
    
    UIView *attractInvestmentObjectContent = [[UIView alloc] init];
    attractInvestmentObjectContent.backgroundColor = [UIColor whiteColor];
    
    UILabel *aiotText = [[UILabel alloc] init];
    aiotText.text = [NSString stringWithFormat:@"%@",model.hd_house[@"planFormat"] == nil?@"":model.hd_house[@"planFormat"]];
    aiotText.font = midFont;
    aiotText.textColor = lgrayColor;
    aiotText.numberOfLines = 0;
    
    [bg_scrollView addSubview:attractInvestmentObjectTitle];
    [attractInvestmentObjectTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(price_bg.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 46));
    }];
    
    [bg_scrollView addSubview:attractInvestmentObjectContent];
    [attractInvestmentObjectContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(attractInvestmentObjectTitle.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.right.equalTo(bg_scrollView.mas_right);
    }];
    
    [attractInvestmentObjectContent addSubview:aiotText];
    [aiotText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(attractInvestmentObjectContent.mas_left).with.offset(10);
        make.right.equalTo(attractInvestmentObjectContent.mas_right).with.offset(-10);
    }];
    
    [attractInvestmentObjectContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(aiotText.mas_bottom).with.offset(10);
    }];

    
    /*------------------------------ 楼盘参数 ------------------------------*/
    
    HouseDetailTitle *houseParaTitle  = [[HouseDetailTitle alloc] init];
    houseParaTitle.theTitle.text = @"楼盘参数";
    houseParaTitle.titleType = haveArrow;
    
    UITapGestureRecognizer *hdTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
    houseParaTitle.tag = 100;
    houseParaTitle.userInteractionEnabled =YES;
    [houseParaTitle addGestureRecognizer:hdTap];
    
    HouseTextWithExpand *houseParaContent = [[HouseTextWithExpand alloc] init];
    [houseParaContent.expandButton addTarget:self action:@selector(houseParaContent:) forControlEvents:UIControlEventTouchUpInside];
    
    [bg_scrollView addSubview:houseParaTitle];
    [houseParaTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(attractInvestmentObjectContent.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 46));
    }];
    
    [bg_scrollView addSubview:houseParaContent];
    [houseParaContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(houseParaTitle.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.right.equalTo(bg_scrollView.mas_right);
    }];
    
    UIView *lastView = nil;
    for (int i=0; i<4; i++) {
        
        UILabel *label = [[UILabel alloc] init];
        label.font = midFont;
        label.textColor = lgrayColor;
        label.text = [NSString stringWithFormat:@"%@: %@",paraTitle[i],paraContent[i]];
        
        [houseParaContent addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@8);
            make.right.equalTo(houseParaContent.mas_right).with.offset(-8);
            make.height.mas_equalTo(@13);
            
            if (lastView){
                make.top.mas_equalTo(lastView.mas_bottom).with.offset(8);
            }
            else {
                make.top.mas_equalTo(@8);
            }
        }];
        lastView = label;
    }
    
    [houseParaContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView.mas_bottom).with.offset(37);
    }];
    
    
    /*------------------------------ 业态平面图 ------------------------------*/
    
    HouseDetailTitle *floorPlansTitle  = [[HouseDetailTitle alloc] init];
    floorPlansTitle.theTitle.text = [NSString stringWithFormat:@"业态平面图（%d）",[model.hd_modelList count]];
    floorPlansTitle.titleType = haveArrow;
    
    UITapGestureRecognizer *aldTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
    floorPlansTitle.tag = 101;
    floorPlansTitle.userInteractionEnabled =YES;
    [floorPlansTitle addGestureRecognizer:aldTap];
    
    HouseFloorPlans *floorPlansContent = [[HouseFloorPlans alloc] init];
    
    for (int i=0; i<[model.hd_modelList count]; i++) {
        
        NSDictionary *dict = model.hd_modelList[i];
        
        ThumbnailButton *thumbanil = [[ThumbnailButton alloc] initWithFrame:CGRectMake(i*(140), 0, 140, 185)];
        
        thumbanil.tag = 300+i;
        thumbanil.imgView.contentMode = UIViewContentModeScaleAspectFill;
        
        [thumbanil.imgView sd_setImageWithURL:dict[@"modelImageUrl"] placeholderImage:[UIImage imageNamed:@"square_loading"]];
        
        thumbanil.topLabel.text = [NSString stringWithFormat:@"%@",dict[@"modelName"]];
        thumbanil.topLabel.textColor = lgrayColor;
        thumbanil.bottomLabel.text = [NSString stringWithFormat:@"%@m²",dict[@"area"]];
        thumbanil.bottomLabel.textColor = lgrayColor;
        
        [thumbanil addTarget:self action:@selector(aldClick:) forControlEvents:UIControlEventTouchUpInside];
        [floorPlansContent.aldScrollView addSubview:thumbanil];
        
        floorPlansContent.aldScrollView.contentSize = CGSizeMake(140+i*(140), 190);
    }
    
    [bg_scrollView addSubview:floorPlansTitle];
    [floorPlansTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(houseParaContent.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 46));
    }];
    
    [bg_scrollView addSubview:floorPlansContent];
    [floorPlansContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(floorPlansTitle.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 185));
    }];
    
    /*------------------------------ 配套地图 ------------------------------*/
    
    HouseDetailTitle *findTitle  = [[HouseDetailTitle alloc] init];
    findTitle.theTitle.text = @"配套地图";
    findTitle.titleType = haveArrow;
    
    UITapGestureRecognizer *fhTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
    findTitle.tag = 102;
    findTitle.userInteractionEnabled =YES;
    [findTitle addGestureRecognizer:fhTap];
    
    HouseFind *findContent = [[HouseFind alloc] init];
    [findContent.peripheralSupport setTitle:@"周边配套:地铁,公交,学校..." forState:UIControlStateNormal];
    
    mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, viewWidth-20, 150)];
    mapView.delegate = self;
    mapView.userInteractionEnabled = YES;
    mapView.zoomLevel = 18;
    mapView.showsUserLocation = NO;                            //先关闭显示的定位图层
    
    // 导航按钮
    UIButton *nav = [UIButton buttonWithType:UIButtonTypeCustom];
    nav.backgroundColor = setColor(50, 50, 50, 0.5);
    nav.titleLabel.font = midFont;
    [nav setTitle:@"导航" forState:UIControlStateNormal];
    [nav addTarget:self action:@selector(navigation:) forControlEvents:UIControlEventTouchUpInside];
    
    //初始化BMKLocationService
    locService = [[BMKLocationService alloc]init];
    locService.delegate = self;
    //设置定位精确度，默认：kCLLocationAccuracyBest
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:100.f];
    //启动LocationService
    [locService startUserLocationService];
    
    geocodesearch = [[BMKGeoCodeSearch alloc]init];
    geocodesearch.delegate = self;
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){[model.hd_house[@"latitude"] floatValue],[model.hd_house[@"longitude"] floatValue]};
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    
    BOOL flag = [geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if (flag) {
        NSLog(@"反geo检索发送成功");
    }
    else {
        NSLog(@"反geo检索发送失败");
    }
    
    [bg_scrollView addSubview:findTitle];
    [findTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(floorPlansContent.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 46));
    }];
    
    [bg_scrollView addSubview:findContent];
    [findContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(findTitle.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 200));
    }];
    
    [findContent addSubview:mapView];
    [mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(findContent).with.insets(UIEdgeInsetsMake(10, 10, 40, 10));
    }];
    
    [mapView addSubview:nav];
    [nav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(mapView).with.offset(-10);
        make.bottom.equalTo(mapView).with.offset(-10);
        make.width.equalTo(@40);
        make.height.equalTo(@20);
    }];
    
    /*------------------------------ 动态 ------------------------------*/
    
    HouseDetailTitle *dynamicTitle = [[HouseDetailTitle alloc] init];
    dynamicTitle.theTitle.text = [NSString stringWithFormat:@"动态（共%d条）",[model.hd_dynamicList count]];
    dynamicTitle.titleType = haveArrow;
    
    UITapGestureRecognizer *dynamicTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
    dynamicTitle.tag = 103;
    dynamicTitle.userInteractionEnabled =YES;
    [dynamicTitle addGestureRecognizer:dynamicTap];
    
    HouseDynamic *dyanamicContent = [[HouseDynamic alloc] init];
    
    float dynamicTitle_h = 0;
    float dyanamicContent_h = 0;
    if ([model.hd_dynamicList count]>0) {
        dyanamicContent.dynamicTitle.text = [NSString stringWithFormat:@"%@", model.hd_dynamicList[0][@"title"]];
        dyanamicContent.dynamicTime.text = [NSString stringWithFormat:@"%@", [Tools_F timeTransform:[model.hd_dynamicList[0][@"addTime"] intValue] time:days]];
        
        dynamicTitle_h = 46.f;
        dyanamicContent_h = 60.f;
    }
    
    [bg_scrollView addSubview:dynamicTitle];
    [dynamicTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(findContent.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, dynamicTitle_h));
    }];
    
    [bg_scrollView addSubview:dyanamicContent];
    [dyanamicContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dynamicTitle.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, dyanamicContent_h));
    }];
    
    /*------------------------------ 项目介绍 ------------------------------*/
    
    HouseDetailTitle *projectIntroductionTitle = [[HouseDetailTitle alloc] init];
    projectIntroductionTitle.theTitle.text = @"项目介绍";
    projectIntroductionTitle.titleType = haveArrow;
    
    UITapGestureRecognizer *introductionTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
    projectIntroductionTitle.tag = 104;
    projectIntroductionTitle.userInteractionEnabled =YES;
    [projectIntroductionTitle addGestureRecognizer:introductionTap];
    
    HouseTextWithExpand *projectIntroductionContent = [[HouseTextWithExpand alloc] init];
    [projectIntroductionContent.expandButton addTarget:self action:@selector(projectIntroductionContent:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *introductionTitle = [[UILabel alloc] init];
    introductionTitle.font = midFont;
    introductionTitle.textColor = deepOrangeColor;
    introductionTitle.text = @"楼盘介绍";
    UILabel *introductionContent = [[UILabel alloc] init];
    introductionContent.font = midFont;
    introductionContent.textColor = lgrayColor;
    introductionContent.text = [NSString stringWithFormat:@"       %@",model.hd_house[@"houseDescription"]];
    introductionContent.numberOfLines = 0;
    
    UILabel *developerTitle = [[UILabel alloc] init];
    developerTitle.font = midFont;
    developerTitle.textColor = deepOrangeColor;
    developerTitle.text = @"开发商背景";
    UILabel *developerContent = [[UILabel alloc] init];
    developerContent.font = midFont;
    developerContent.textColor = lgrayColor;
    if (![model.hd_houseDeveloper isEqual:[NSNull null]]) {
        developerContent.text = [NSString stringWithFormat:@"       %@",model.hd_houseDeveloper[@"developersDescription"]];
        developerContent.numberOfLines = 0;
    }
    
    [bg_scrollView addSubview:projectIntroductionTitle];
    [projectIntroductionTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dyanamicContent.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.right.equalTo(bg_scrollView.mas_right);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 46));
    }];
    
    [bg_scrollView addSubview:projectIntroductionContent];
    [projectIntroductionContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(projectIntroductionTitle.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.right.equalTo(bg_scrollView.mas_right);
    }];
    
    [projectIntroductionContent addSubview:introductionTitle];
    [introductionTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(@8);
        make.size.mas_equalTo(CGSizeMake(viewWidth-16, 13));
    }];
    
    [projectIntroductionContent addSubview:introductionContent];
    [introductionContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(introductionTitle.mas_bottom).with.offset(5);
        make.left.equalTo(@8);
        make.width.mas_equalTo(viewWidth-16);
    }];
    
    [projectIntroductionContent addSubview:developerTitle];
    [developerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(introductionContent.mas_bottom).with.offset(10);
        make.left.equalTo(@8);
        make.width.mas_equalTo(viewWidth-16);
    }];
    
    [projectIntroductionContent addSubview:developerContent];
    [developerContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(developerTitle.mas_bottom).with.offset(5);
        make.left.equalTo(@8);
        make.width.mas_equalTo(viewWidth-16);
    }];
    
    [projectIntroductionContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(developerContent.mas_bottom).with.offset(37);
        make.height.lessThanOrEqualTo(@240);
    }];

    /*------------------------------ 在线评房 ------------------------------*/
    
    HouseDetailTitle *evaluationTitle = [[HouseDetailTitle alloc] init];
    evaluationTitle.theTitle.text = @"在线评房";
    evaluationTitle.titleType = haveArrow;
    
    UITapGestureRecognizer *liveETap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
    evaluationTitle.tag = 105;
    evaluationTitle.userInteractionEnabled =YES;
    [evaluationTitle addGestureRecognizer:liveETap];
    
    evaluationContent = [[HouseEvaluation alloc] init];
    evaluationContent.evaluationTable.tag = 200;
    evaluationContent.evaluationTable.scrollEnabled = NO;
    evaluationContent.evaluationTable.delegate = self;
    evaluationContent.evaluationTable.dataSource = self;
    
    [evaluationContent.evaluationButton addTarget:self action:@selector(evaluationClick:) forControlEvents:UIControlEventTouchUpInside];
    
    float devaluationContent_h = 45.f;
    if ([model.hd_houseCommentDTO[@"total"] intValue] != 0) {
        
        evaluationContent.totalStar.scorePercent = [model.hd_houseCommentDTO[@"avgScore"] floatValue]/5;
        evaluationContent.totalScore.text = [NSString stringWithFormat:@"%.1f分",[model.hd_houseCommentDTO[@"avgScore"] floatValue]];
        evaluationContent.scoreDetail.text = [NSString stringWithFormat:@"价格%.1f分 地段%.1f分 交通%.1f分 环境%.1f分 配套%.1f分",
                                              [model.hd_houseCommentDTO[@"priceScore"] floatValue],
                                              [model.hd_houseCommentDTO[@"areaScore"] floatValue],
                                              [model.hd_houseCommentDTO[@"trafficScore"] floatValue],
                                              [model.hd_houseCommentDTO[@"milieuScore"] floatValue],
                                              [model.hd_houseCommentDTO[@"supportingScore"] floatValue]];
        
        devaluationContent_h += [model.hd_houseCommentDTO[@"commentList"] count]<2?[model.hd_houseCommentDTO[@"commentList"] count]*150:2*150;
    }
    else {
    
        evaluationContent.totalStar.hidden = YES;
    }
    
    [bg_scrollView addSubview:evaluationTitle];
    [evaluationTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(projectIntroductionContent.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 46));
    }];
    
    [bg_scrollView addSubview:evaluationContent];
    [evaluationContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(evaluationTitle.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, devaluationContent_h));
    }];

    /*------------------------------ 房价走势 ------------------------------*/
    
    HouseDetailTitle *priceSwingTitle = [[HouseDetailTitle alloc] init];
    priceSwingTitle.theTitle.text = @"房价走势";
    priceSwingTitle.titleType = haveButton;
    priceSwingTitle.userInteractionEnabled = YES;
    [priceSwingTitle.segmented addTarget:self action:@selector(oneOrTwo:) forControlEvents:UIControlEventValueChanged];
    
    priceSwingContent = [[HousePriceSwing alloc] init];
    
    [self oneYear];
    UUChart *chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(10, 10, viewWidth*2-40, 170)
                                                       withSource:self
                                                        withStyle:UUChartLineStyle];
    [chartView showInView:priceSwingContent.movements_bg];
    priceSwingContent.movementCity.text = [NSString stringWithFormat:@"      ·%@",_hrTitle];
    
    [bg_scrollView addSubview:priceSwingTitle];
    [priceSwingTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(evaluationContent.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 46));
    }];
    
    [bg_scrollView addSubview:priceSwingContent];
    [priceSwingContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceSwingTitle.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 220));
    }];
    
    /*------------------------------ 周边项目 ------------------------------*/
    
    HouseDetailTitle *nearTitle = [[HouseDetailTitle alloc] init];
    nearTitle.theTitle.text = @"周边项目";
    nearTitle.titleType = haveArrow;
    
    UITapGestureRecognizer *nearTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
    nearTitle.tag = 107;
    nearTitle.userInteractionEnabled = YES;
    [nearTitle addGestureRecognizer:nearTap];
    
    nearContent = [[HouseRecommend alloc] init];
    
    float nearTitle_h = 0;
    float nearContent_h = 0;
    
    if (![model.hd_surroundingsList isEqual:[NSNull null]]) {
        
        for (int i=0; i<[model.hd_surroundingsList count]; i++) {
            
            NSDictionary *dict = model.hd_surroundingsList[i];
            
            ThumbnailButton*thumbanil = [[ThumbnailButton alloc] initWithFrame:CGRectMake(i*(140), 0, 140, 190)];
            
            thumbanil.tag = 400+i;
            
            thumbanil.imgView.contentMode = UIViewContentModeScaleAspectFill;
            [thumbanil.imgView sd_setImageWithURL:dict[@"defaultImage"] placeholderImage:[UIImage imageNamed:@"square_loading"]] ;
            
            thumbanil.topLabel.text = [NSString stringWithFormat:@"%@",dict[@"houseName"]];
            thumbanil.topLabel.textColor = [UIColor blackColor];
            
            thumbanil.bottomLabel.text = [NSString stringWithFormat:@"%@元/m²",dict[@"price"]];
            thumbanil.bottomLabel.textColor = deepOrangeColor;
            
            [thumbanil addTarget:self action:@selector(nearAndSimilarClick:) forControlEvents:UIControlEventTouchUpInside];
            [nearContent.houseRecommendScrollView addSubview:thumbanil];
            
            nearContent.houseRecommendScrollView.frame = CGRectMake(0, 0, viewWidth, 190);
            nearContent.houseRecommendScrollView.contentSize = CGSizeMake(140+i*(140), 190);
            
            nearTitle_h = 46;
            nearContent_h = 190;
        }
    }
    
    [bg_scrollView addSubview:nearTitle];
    [nearTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceSwingContent.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, nearTitle_h));
    }];
    
    [bg_scrollView addSubview:nearContent];
    [nearContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nearTitle.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, nearContent_h));
    }];
    
    /*------------------------------ 同类项目 ------------------------------*/
    
    HouseDetailTitle *sameTitle = [[HouseDetailTitle alloc] init];
    sameTitle.theTitle.text = @"同类项目";
    sameTitle.titleType = haveArrow;
    
    UITapGestureRecognizer *similarTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
    sameTitle.tag = 108;
    sameTitle.userInteractionEnabled =YES;
    [sameTitle addGestureRecognizer:similarTap];
    
    sameContent = [[HouseRecommend alloc] init];
    
    float sameTitle_h = 0;
    float sameContent_h = 0;
    
    if (![model.hd_similarsList isEqual:[NSNull null]]) {
        
        for (int i=0; i<[model.hd_similarsList count]; i++) {
            
            NSDictionary *dict = model.hd_similarsList[i];
            
            ThumbnailButton *thumbanil = [[ThumbnailButton alloc] initWithFrame:CGRectMake(i*(140), 0, 140, 190)];
            
            thumbanil.tag = 500+i;
            
            thumbanil.imgView.contentMode = UIViewContentModeScaleAspectFill;
            [thumbanil.imgView sd_setImageWithURL:dict[@"defaultImage"] placeholderImage:[UIImage imageNamed:@"square_loading"]] ;
            
            thumbanil.topLabel.text = [NSString stringWithFormat:@"%@",dict[@"houseName"]];
            thumbanil.topLabel.textColor = [UIColor blackColor];
            
            thumbanil.bottomLabel.text = [NSString stringWithFormat:@"%@元/m²",dict[@"price"]];
            thumbanil.bottomLabel.textColor = deepOrangeColor;
            
            [thumbanil addTarget:self action:@selector(nearAndSimilarClick:) forControlEvents:UIControlEventTouchUpInside];
            [sameContent.houseRecommendScrollView addSubview:thumbanil];
            
            sameContent.houseRecommendScrollView.frame = CGRectMake(0, 0, viewWidth, 190);
            sameContent.houseRecommendScrollView.contentSize = CGSizeMake(140+i*(140), 190);
            
            sameTitle_h = 46;
            sameContent_h = 190;
        }
    }
    
    [bg_scrollView addSubview:sameTitle];
    [sameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nearContent.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, sameTitle_h));
    }];
    
    [bg_scrollView addSubview:sameContent];
    [sameContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sameTitle.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, sameContent_h));
    }];
    
    // 自动scrollview高度
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(sameContent.mas_bottom).with.offset(40);
    }];
    
    // 底部按钮
    botView = [[UIView alloc] init];
    botView.frame = CGRectMake(0, viewHeight-104, viewWidth, 40);
    botView.backgroundColor = setColor(50, 50, 50, 0.5);
    
    [self.view addSubview:botView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(5, 5, viewWidth-10, 30);
    btn.backgroundColor = deepOrangeColor;
    btn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];;
    [btn setTitle:@"打电话" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [Tools_F setViewlayer:btn cornerRadius:3 borderWidth:0 borderColor:[UIColor clearColor]];
    [btn addTarget:self action:@selector(callClick:) forControlEvents:UIControlEventTouchUpInside];
    [botView addSubview:btn];
    
    UIImageView *callImg = [[UIImageView alloc] init];
    callImg.frame = CGRectMake(viewWidth/2-60, 5, 20, 20);
    callImg.image = [UIImage imageNamed:@"index_btn_call_white"];
    [btn addSubview:callImg];
}

#pragma mark - 展开楼盘参数
- (void)houseParaContent:(UIButton *)btn{
    
    NSLog(@"展开楼盘参数");
    HouseTextWithExpand *houseParaContent = (HouseTextWithExpand *)btn.superview;
    
    for (UIView *oldView in houseParaContent.subviews) {
        [oldView removeFromSuperview];
    }
    
    UIView *lastView = nil;
    for (int i=0; i<16; i++) {
        
        UILabel *label = [[UILabel alloc] init];
        label.font = midFont;
        label.textColor = lgrayColor;
        label.text = [NSString stringWithFormat:@"%@: %@",paraTitle[i],paraContent[i]];
        
        [houseParaContent addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(houseParaContent.mas_left).with.offset(8);
            make.right.equalTo(houseParaContent.mas_right).with.offset(-8);
            make.height.mas_equalTo(@13);
            
            if (lastView){
                make.top.mas_equalTo(lastView.mas_bottom).with.offset(8);
            }
            else {
                make.top.mas_equalTo(@8);
            }
        }];
        lastView = label;
    }
    
    [houseParaContent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView.mas_bottom).with.offset(17);
    }];
}

#pragma mark - 展开项目介绍
- (void)projectIntroductionContent:(UIButton *)btn{
    
    NSLog(@"展开项目介绍");
    
    if (iOS_version < 7.5) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"适配低版本中……" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        
        HouseTextWithExpand *projectIntroductionContent = (HouseTextWithExpand *)btn.superview;
        
        for (UIView *oldView in projectIntroductionContent.subviews) {
            [oldView removeFromSuperview];
        }
        
        UILabel *introductionTitle = [[UILabel alloc] init];
        introductionTitle.font = midFont;
        introductionTitle.textColor = deepOrangeColor;
        introductionTitle.text = @"楼盘介绍";
        UILabel *introductionContent = [[UILabel alloc] init];
        introductionContent.font = midFont;
        introductionContent.textColor = lgrayColor;
        introductionContent.text = [NSString stringWithFormat:@"       %@",model.hd_house[@"houseDescription"]];
        introductionContent.numberOfLines = 0;
        
        UILabel *developerTitle = [[UILabel alloc] init];
        developerTitle.font = midFont;
        developerTitle.textColor = deepOrangeColor;
        developerTitle.text = @"开发商背景";
        UILabel *developerContent = [[UILabel alloc] init];
        developerContent.font = midFont;
        developerContent.textColor = lgrayColor;
        
        if (![model.hd_houseDeveloper isEqual:[NSNull null]]) {
            developerContent.text = [NSString stringWithFormat:@"       %@",model.hd_houseDeveloper[@"developersDescription"]];
            developerContent.numberOfLines = 0;
        }
        
        [projectIntroductionContent addSubview:introductionTitle];
        [introductionTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@10);
            make.left.equalTo(@8);
            make.size.mas_equalTo(CGSizeMake(viewWidth-16, 13));
        }];
        
        [projectIntroductionContent addSubview:introductionContent];
        [introductionContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(introductionTitle.mas_bottom).with.offset(5);
            make.left.equalTo(@8);
            make.width.mas_equalTo(viewWidth-16);
        }];
        
        [projectIntroductionContent addSubview:developerTitle];
        [developerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(introductionContent.mas_bottom).with.offset(10);
            make.left.equalTo(@8);
            make.width.mas_equalTo(viewWidth-16);
        }];
        
        [projectIntroductionContent addSubview:developerContent];
        [developerContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(developerTitle.mas_bottom).with.offset(5);
            make.left.equalTo(@8);
            make.width.mas_equalTo(viewWidth-16);
        }];
        
        [projectIntroductionContent mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(developerContent.mas_bottom).with.offset(17);
            make.height.lessThanOrEqualTo(@MAXFLOAT);
        }];
    }
}

#pragma mark - 顶部图片点击
- (void)topImageTap:(id)sender{
    
    FullScreenViewController *fsVC = [[FullScreenViewController alloc] init];
    fsVC.imagesFrom = 0;
    fsVC.paramID = model.hd_house[@"houseId"];
    fsVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UINavigationController *nav_houseLookingVC = [[UINavigationController alloc]initWithRootViewController:fsVC];
    
    [self presentViewController:nav_houseLookingVC animated:YES completion:nil];
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 150;
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [model.hd_houseCommentDTO[@"commentList"] count]<2?[model.hd_houseCommentDTO[@"commentList"] count]:2;
}

#pragma mark - 设置section 头高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

#pragma mark - 设置section 脚高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

#pragma mark - 设置cell (tableView)
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //重用标识符
    static NSString *identifier = @"evaluation";
    //重用机制
    EvalutaionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];      //带标识符的出列
    
    if (cell == nil) {
        //当不存在的时候用重用标识符生成
        cell = [[EvalutaionTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
    }
    
    if (!model) {
        return cell;
    }
    else {
        
        NSDictionary *dict = model.hd_houseCommentDTO[@"commentList"][indexPath.row];
        
        [cell.avatar sd_setImageWithURL:dict[@"icon"]];
        cell.nickname.text = [NSString stringWithFormat:@"%@",dict[@"realName"]];
        cell.starRate.scorePercent = [dict[@"avgScore"] floatValue]/5;
        cell.userType = 1;
        cell.comment.text = [NSString stringWithFormat:@"%@",dict[@"description"]];
        cell.commentTime.text = [Tools_F timeTransform:[dict[@"addTime"] floatValue] time:seconds];
        
        return cell;
    }
}

#pragma mark - 点击cell (tableView)
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


- (void)oneOrTwo:(UISegmentedControl *)segment{
    
    NSLog(@"switchYears");
    if (segment.selectedSegmentIndex == 0) {
        
        [self oneYear];
    }
    else {
        
        [self twoYear];
    }
    // 房价走势
    for (UIView *view in priceSwingContent.movements_bg.subviews) {
        
        [view removeFromSuperview];     // 移除原有视图
    }
    
    UUChart *chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(10, 10, ((segment.selectedSegmentIndex+1)*2*viewWidth)-40, 170)
                                                       withSource:self
                                                        withStyle:UUChartLineStyle];
    [chartView showInView:priceSwingContent.movements_bg];
    priceSwingContent.movements_bg.contentSize = CGSizeMake((segment.selectedSegmentIndex+1)*2*viewWidth, 170);
    [priceSwingContent.movements_bg setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)oneYear{
    
    /*-            X坐标           -*/
    // 获取当前年月
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    int year =  (int)[dateComponent year];
    int month = (int)[dateComponent month];
    
    NSMutableArray *xTitles = [NSMutableArray array];
    for (int i=0; i<12; i++) {
        
        NSString *str;
        if (month-i>0) {
            
            str = [NSString stringWithFormat:@"%d-%d",year,month-i];
        }
        else {
            
            str = [NSString stringWithFormat:@"%d-%d",year-1,12+month-i];
        }
        [xTitles addObject:str];
    }
    
    time_X = xTitles;
    
    /*-            Y坐标           -*/
    if (![model.hd_priceMap[@"one"][@"house"] isEqual:[NSNull null]]) {
        
        NSMutableArray *muArr = [[NSMutableArray alloc] init];
        
        for (id something in model.hd_priceMap[@"one"][@"house"]) {
            
            if (![something isEqual:[NSNull null]]) {
                
                [muArr addObject:something];
            }
        }
        
        house_Y = muArr;
        //        house_Y = model.hd_priceMap[@"one"][@"house"];
    }
    if (![model.hd_priceMap[@"one"][@"region"] isEqual:[NSNull null]]) {
        
        NSMutableArray *muArr = [[NSMutableArray alloc] init];
        
        for (id something in model.hd_priceMap[@"one"][@"region"]) {
            
            if (![something isEqual:[NSNull null]]) {
                
                [muArr addObject:something];
            }
        }
        
        region_Y = muArr;
        //        region_Y = model.hd_priceMap[@"one"][@"region"];
    }
}

- (void)twoYear{
    
    /*-            X坐标           -*/
    // 获取当前年月
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    int year =  (int)[dateComponent year];
    int month = (int)[dateComponent month];
    
    NSMutableArray *xTitles = [NSMutableArray array];
    for (int i=0; i<24; i++) {
        
        NSString *str;
        if (month-i>0) {
            
            str = [NSString stringWithFormat:@"%d-%d",year,month-i];
        }
        else if (12+month-i>0){
            
            str = [NSString stringWithFormat:@"%d-%d",year-1,12+month-i];
        }
        else {
            
            str = [NSString stringWithFormat:@"%d-%d",year-2,24+month-i];
        }
        [xTitles addObject:str];
    }
    
    time_X = xTitles;
    
    /*-            Y坐标           -*/
    if (![model.hd_priceMap[@"two"][@"house"] isEqual:[NSNull null]]) {
        
        NSMutableArray *muArr = [[NSMutableArray alloc] init];
        
        for (id something in model.hd_priceMap[@"two"][@"house"]) {
            
            if (![something isEqual:[NSNull null]]) {
                
                [muArr addObject:something];
            }
        }
        house_Y = muArr;
        //        house_Y = model.hd_priceMap[@"two"][@"house"];
    }
    if (![model.hd_priceMap[@"two"][@"region"] isEqual:[NSNull null]]) {
        
        NSMutableArray *muArr = [[NSMutableArray alloc] init];
        
        for (id something in model.hd_priceMap[@"two"][@"region"]) {
            
            if (![something isEqual:[NSNull null]]) {
                
                [muArr addObject:something];
            }
        }
        region_Y = muArr;
        //        region_Y = model.hd_priceMap[@"two"][@"region"];
    }
}

#pragma mark - 走势图@required
//横坐标标题数组
- (NSArray *)UUChart_xLableArray:(UUChart *)chart{
    
    return time_X;
}

//数值多重数组
- (NSArray *)UUChart_yValueArray:(UUChart *)chart{
    
    return @[house_Y,region_Y];
}

//颜色数组
- (NSArray *)UUChart_ColorArray:(UUChart *)chart{
    
    return @[UUGreen,UURed];
}

//判断显示横线条
- (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index{
    
    return YES;
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
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    annotationView.canShowCallout = TRUE;
    
    return annotationView;
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
    NSArray* array = [NSArray arrayWithArray:mapView.annotations];
    [mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:mapView.overlays];
    [mapView removeOverlays:array];
    
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        
        [mapView addAnnotation:item];
        mapView.centerCoordinate = result.location;
    }
}

#pragma mark - 标题点击
- (void)titleTap:(UIGestureRecognizer *)tap{
    
    UILabel *label = (UILabel *)tap.view;
    int titleTag = (int)label.tag;
    NSLog(@"标题点击%d",titleTag);
    switch (titleTag) {
        case 100:
        {
            HouseParameterViewController *hpVC = [[HouseParameterViewController alloc] init];
            hpVC.theTitle = @"楼盘详情";
            hpVC.theContent = model.hd_house;
            hpVC.theDevelopersName = model.hd_houseDeveloper [@"developersName"] == nil?@"暂无":[NSString stringWithFormat:@"%@",model.hd_houseDeveloper [@"developersName"]];

            [self.navigationController pushViewController:hpVC animated:YES];
        }
            break;
        case 101:
        {

        }
            break;
        case 102:
        {
            MapViewController *mapVC = [[MapViewController alloc] init];
            
            mapVC.fromIndex = 0;
            mapVC.theLatitude = [model.hd_house[@"latitude"] floatValue];
            mapVC.theLongitude = [model.hd_house[@"longitude"] floatValue];
            [self.navigationController pushViewController:mapVC animated:YES];
        }
            break;
        case 103:
        {
            HouseDynamicViewController *houseDynamicVC = [[HouseDynamicViewController alloc] init];
            
            houseDynamicVC.houseID = model.hd_house[@"houseId"];
            [self.navigationController pushViewController:houseDynamicVC animated:YES];
        }
            break;
        case 104:
        {
            IntroductionViewController *introductionVC = [[IntroductionViewController alloc] init];
            
            introductionVC.introductionString = [NSString stringWithFormat:@"%@",model.hd_house[@"houseDescription"]];
            introductionVC.developerString = [NSString stringWithFormat:@"%@",model.hd_houseDeveloper[@"developersDescription"]];
            [self.navigationController pushViewController:introductionVC animated:YES];
        }
            break;
        case 105:
        {
            EvaluationViewController *evaluationVC = [[EvaluationViewController alloc] init];
            
            evaluationVC.houseID = model.hd_house[@"houseId"];
            [self.navigationController pushViewController:evaluationVC animated:YES];
        }
            break;
        case 106:
        {

        }
            break;
        case 107:
        {
            NearAndSimilarViewController *nasVC = [[NearAndSimilarViewController alloc] init];
            nasVC.houseID = model.hd_house[@"houseId"];
            nasVC.nasTitle = @"周边项目";
            nasVC.recommendType = near;
            [self.navigationController pushViewController:nasVC animated:YES];
        }
            break;
        case 108:
        {
            NearAndSimilarViewController *nasVC = [[NearAndSimilarViewController alloc] init];
            nasVC.houseID = model.hd_house[@"houseId"];
            nasVC.nasTitle = @"同类项目";
            nasVC.recommendType = similars;
            [self.navigationController pushViewController:nasVC animated:YES];
        }
            break;
        case 109:
        {
            NearAndSimilarViewController *nasVC = [[NearAndSimilarViewController alloc] init];
            nasVC.houseID = model.hd_house[@"houseId"];
            nasVC.nasTitle = @"相关团购推荐";
            nasVC.recommendType = buy;
            [self.navigationController pushViewController:nasVC animated:YES];
        }
            break;
        case 110:
        {
            NearAndSimilarViewController *nasVC = [[NearAndSimilarViewController alloc] init];
            nasVC.houseID = model.hd_house[@"houseId"];
            nasVC.nasTitle = @"相关团租推荐";
            nasVC.recommendType = rent;
            [self.navigationController pushViewController:nasVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 马上点评
- (void)evaluationClick:(UIButton *)btn{
    
    NSLog(@"马上点评");
    
    ReviewViewController *reviewVC = [[ReviewViewController alloc] init];
    reviewVC.houseID = _houseID;
    [self.navigationController pushViewController:reviewVC animated:YES];
}

#pragma mark - 周边/同类/相关项目
- (void)nearAndSimilarClick:(UIButton *)btn{
    
    if (btn.superview == nearContent.houseRecommendScrollView) {
        
        NSDictionary *dict = model.hd_surroundingsList[(int)btn.tag-400];
        _houseID = [NSString stringWithFormat:@"%@",dict[@"houseId"]];
        
        NSLog(@"周边houseid%@",dict);
    }
    else if (btn.superview == sameContent.houseRecommendScrollView) {
        
        NSDictionary *dict = model.hd_similarsList[(int)btn.tag-500];
        _houseID = [NSString stringWithFormat:@"%@",dict[@"houseId"]];
        
        NSLog(@"同类houseid%@",dict);
    }
    
    [self requestData];
}

#pragma mark - 打电话
- (void)callClick:(UIButton *)sender{
    
    //联系客服
    UIWebView*callWebview =[[UIWebView alloc] init];
    
    NSString *telNumber;
    if ([model.hd_house[@"telExtra"] isEqual:[NSNull null]]) {
        
        telNumber = [NSString stringWithFormat:@"tel:%@",model.hd_house[@"tel"]];
    }
    else {
        
        telNumber = [NSString stringWithFormat:@"tel:%@,,%@",model.hd_house[@"tel"],model.hd_house[@"telExtra"]];
    }
    
    // 去空格
    telNumber = [telNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"%@",telNumber);
    
    NSURL *telURL = [NSURL URLWithString:telNumber];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
    
//    if (![GlobalController isLogin]) {
//        
//        LoginController *loginVC = [LoginController alloc];
//        [self.navigationController pushViewController:loginVC animated:YES];
//    }
//    else {
//        
//        // 销售电话
//        NSString *saleStr = [NSString stringWithFormat:@"销售电话: %@",[model.hd_house[@"salesPhone"] isEqual:[NSNull null]]?@"":model.hd_house[@"salesPhone"]];
    
//        // 招商电话
//        NSString *merchantsStr = [NSString stringWithFormat:@"销售电话: %@",[model.hd_house[@"merchantsPhone"] isEqual:[NSNull null]]?@"":model.hd_house[@"merchantsPhone"]];
//        
//        UIActionSheet *shotOrAlbums = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:saleStr otherButtonTitles:merchantsStr, nil];
//        [shotOrAlbums showInView:self.view];
//    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    //联系客服
    UIWebView*callWebview =[[UIWebView alloc] init];
    
    NSString *telNumber;
    
    //before animation and hiding view
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"销售");
            if (![model.hd_house[@"salesPhone"] isEqual:[NSNull null]]) {
                
                telNumber = [NSString stringWithFormat:@"tel://%@",model.hd_house[@"salesPhone"]];
            }
        }
            break;
        case 1:
        {
            NSLog(@"招商");
            if (![model.hd_house[@"merchantsPhone"] isEqual:[NSNull null]]) {
                
                telNumber = [NSString stringWithFormat:@"tel://%@",model.hd_house[@"merchantsPhone"]];
            }
        }
            break;
        default:
            break;
    }
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:telNumber]]];
    [self.view addSubview:callWebview];
}

#pragma mark - 收藏
- (void)starClick:(UIButton *)btn{
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else {
        
        if (!btn.isSelected){
            
            // 操作
            NSString *str = [SDD_MainURL stringByAppendingString:@"/user/house/collection.do"];              // 拼接主路径和请求内容成完整url
            NSDictionary *dic = @{@"activityCategoryId":_activityCategoryId,@"houseId":_houseID};
            [self addOrCancelFavorite:str param:dic button:btn];
            
        }
        else {
            
            // 操作
            NSString *str = [SDD_MainURL stringByAppendingString:@"/user/house/deleteCollection.do"];              // 拼接主路径和请求内容成完整url
            NSDictionary *dic = @{@"activityCategoryId":_activityCategoryId,@"houseId":_houseID};
            [self addOrCancelFavorite:str param:dic button:btn];
        }
    }
}


#pragma mark - 取消、添加收藏网络请求
- (void)addOrCancelFavorite:(NSString *)url param:(NSDictionary *)dic button:(UIButton *)btn{
    
    [self.httpManager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = responseObject;
        if ([dict[@"status"] intValue] == 1) {
            
            btn.selected = !btn.selected;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
}

#pragma mark - 计算器
- (void)calcClick:(UIButton *)btn{
    
    CalculatorsViewController *calc = [[CalculatorsViewController alloc] init];
    calc.calculatorType = 0;
    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
    [self.navigationController pushViewController:calc animated:YES];
}
#pragma mark - 定位
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation{
    
    curLatitude = userLocation.location.coordinate.latitude;
    curLongitude = userLocation.location.coordinate.longitude;
    
    if (curLatitude != 0 && curLongitude != 0) {
        [locService stopUserLocationService];
    }
}

#pragma mark - 导航
- (void)navigation:(UIButton *)btn{
    
    NSLog(@"开始导航");
    
    //初始化调启导航时的参数管理类
    BMKNaviPara* para = [[BMKNaviPara alloc]init];
    //指定导航类型
    para.naviType = BMK_NAVI_TYPE_WEB;
    
    //初始化起点节点
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    //指定起点经纬度
    CLLocationCoordinate2D coor1;
    coor1.latitude = curLatitude;
    coor1.longitude = curLongitude;
    start.pt = coor1;
    //指定起点名称
    start.name = @"当前位置";
    //指定起点
    para.startPoint = start;
    
    //初始化终点节点
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    CLLocationCoordinate2D coor2;
    coor2.latitude = [model.hd_house[@"latitude"] floatValue];
    coor2.longitude = [model.hd_house[@"longitude"] floatValue];
    end.pt = coor2;
    para.endPoint = end;
    //指定终点名称
    end.name = model.hd_house[@"houseName"];
    //指定调启导航的app名称
    para.appName = [NSString stringWithFormat:@"%@", @"SDD"];
    //调启web导航
    [BMKNavigation openBaiduMapNavigation:para];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
