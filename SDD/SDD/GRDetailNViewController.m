//
//  GRDetailNViewController.m
//  SDD
//
//  Created by hua on 15/9/1.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "GRDetailNViewController.h"
#import "NSString+SDD.h"
#import "HouseDetialViews.h"
#import "ThumbnailButton.h"
#import "MainBrankButton.h"
#import "EvalutaionTableViewCell.h"
#import "ConsultantTableViewCell.h"
#import "HouseDetailModel.h"
#import "TabButton.h"

#import "AllChildViewController.h"

#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "ShareHelper.h"

#import "GRDetailViewController.h"
#import "SelectBtn.h"
#import "ProjectCoopViewController.h"
#import "ProjectCViewController.h"
#import "PurchaseShopViewController.h"
#import "ShopForDetailsViewController.h"

@interface GRDetailNViewController ()<UIScrollViewDelegate,
UITableViewDataSource,UITableViewDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,
BMKGeoCodeSearchDelegate,UIAlertViewDelegate>{
    
    /*- data -*/
    
    NSArray *time_X;
    NSArray *house_Y;
    NSArray *region_Y;
    
    float curLatitude;
    float curLongitude;
    
    HouseDetailModel *model;                        // 模型
    
    NSArray *paraTitle;
    NSArray *paraContent;
    
    NSString *originalString;                       // 原文本
    NSMutableAttributedString *paintString;         // 富文本
    
    NSInteger todayD;
    
    /*- ui -*/
    
    UIScrollView *bg_scrollView;
    UIView *botView;
    HouseEvaluation *evaluationContent;
    HouseConsultant *consultantContent;
    HousePriceSwing *priceSwingContent;
    HouseRecommend *nearContent;
    HouseRecommend *sameContent;
    HouseRecommend *rentContent;
    
    SelectBtn * SelectButton;
    NSInteger pectIndex;
    NSInteger selIndex;
}

// 楼盘详情
@property (nonatomic, strong) NSMutableArray *grDataArr;

@end

@implementation GRDetailNViewController

- (NSMutableArray *)grDataArr{
    if (!_grDataArr) {
        _grDataArr = [[NSMutableArray alloc]init];
    }
    return _grDataArr;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    
}

#pragma mark - 请求数据
- (void)requestData{
    
    [bg_scrollView removeFromSuperview];     // 移除原有视图
    [botView removeFromSuperview];
    
    [self showLoading:1];
    
    // 请求参数
    NSDictionary *dic = @{@"activityCategoryId":@2,@"houseId":[NSString stringWithFormat:@"%@",_houseID]};
    
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

#pragma mark - 设置项目参数
- (void)setupData{
    
    paraTitle = @[
                  @"商业面积",
                  @"楼   层",
                  @"租   期"
                  ];
    
    paraContent = @[
                    model.hd_house[@"commercialArea"] == [NSNull null]?
                    @"暂无":[NSString stringWithFormat:@"%@ m²",model.hd_house[@"commercialArea"] ],
                    model.hd_house[@"floor"] == [NSNull null]?
                    @"暂无":[NSString stringWithFormat:@"%@",model.hd_house[@"floor"]],
                    model.hd_house[@"lease"] == [NSNull null]?
                    @"暂无":[NSString stringWithFormat:@"%@亩",model.hd_house[@"lease"]]
                    ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSDate *datenow = [NSDate date];  // 获取现在时间
    todayD = (NSInteger)[datenow timeIntervalSince1970];
    pectIndex = 1;
    selIndex = 0;
    
    // 导航条
    [self setupNav];
    // 加载数据
    [self requestData];
}

-(void)nearAndSimilarClick:(ThumbnailButton *)btn{
    
    ShopForDetailsViewController * sdVc = [[ShopForDetailsViewController alloc] init];
    sdVc.storeId = model.hd_houseStoreList[btn.tag-700][@"storeId"];
    sdVc.canAppointmentSign = model.hd_house[@"canAppointmentSign"];
    sdVc.hr_activityCategoryId = _hr_activityCategoryId;
    sdVc.type = _type;
    [self.navigationController pushViewController:sdVc animated:YES];
}
#pragma mark - 设置导航条
- (void)setupNav{
    
    [self setNav:model.hd_house[@"houseName"]];
    
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
    [share addTarget:self action:@selector(GRshareBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barStar = [[UIBarButtonItem alloc]initWithCustomView:star];
    UIBarButtonItem *barShare = [[UIBarButtonItem alloc]initWithCustomView:share];
    self.navigationItem.rightBarButtonItems = @[barShare,barStar];
}

- (void)GRshareBtn{
    

    NSInteger  houseID  = [_houseID integerValue];
    [ShareHelper shareIn: self content:[NSString stringWithFormat:@"%@   %@",model.hd_house[@"houseName"],[model.hd_house[@"rentPriceMin"] intValue] == 0?@"待定":[NSString stringWithFormat:@"%@-%@元/m²/月",model.hd_house[@"rentPriceMin"],model.hd_house[@"rentPriceMax"]]] url:[NSString stringWithFormat:@"http://www.91sydc.com/user_mobile/web/projectShare.do?houseId=%ld",houseID] image:model.hd_house[@"defaultImage"] title:model.hd_house[@"houseName"]];
}

#pragma mark - 设置内容
- (void)setupUI {
    
    // 底部滚动
    bg_scrollView = [[UIScrollView alloc] init];
    bg_scrollView.backgroundColor = bgColor;
    [self.view addSubview:bg_scrollView];
    [bg_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    if (selIndex == 1) {
        [bg_scrollView setContentOffset:CGPointMake(0, 600) animated:YES];
    }
    
    // 底部view， 用于计算scrollview高度
    UIView* contentView = [[UIView alloc] init];
    contentView.backgroundColor = bgColor;
    [bg_scrollView addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bg_scrollView);
        make.width.equalTo(bg_scrollView);
    }];
    
    /*------------------------------ 顶部图+基本参数 ------------------------------*/
    
    UIImageView *_headImage = [[UIImageView alloc] init];
    [_headImage sd_setImageWithURL:[NSURL URLWithString:model.hd_house[@"defaultImage"]] placeholderImage:[UIImage imageNamed:@"loading_b"]];
    _headImage.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *hTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topImageTap:)];
    [_headImage addGestureRecognizer:hTap];
    
    UIView *gray_bg = [[UIView alloc] init];
    gray_bg.backgroundColor = [UIColor blackColor];
    gray_bg.alpha = 0.5;
    
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
                         [model.hd_images[@"videoUrls"] count]+
                         [model.hd_images[@"renderingUrls"] count]];
    _imageCounts.textAlignment = NSTextAlignmentRight;
    
    UIView *price_bg = [[UIView alloc] init];
    price_bg.backgroundColor = [UIColor whiteColor];
    
    // 价格
    UILabel *_price = [[UILabel alloc] init];
    _price.textColor = tagsColor;
    _price.font = biggestFont;
    _price.text =  [model.hd_house[@"rentPriceMin"] intValue] == 0?@"待定":[NSString stringWithFormat:@"%@-%@元/m²/月",model.hd_house[@"rentPriceMin"],model.hd_house[@"rentPriceMax"]];
    
    UILabel *_priceDescribe = [[UILabel alloc] init];
    _priceDescribe.font = midFont;
    _priceDescribe.textColor = lgrayColor;
    _priceDescribe.text = @"租金参考价";
    
    // 下分割线
    UIView *cutOff = [[UIView alloc] init];
    cutOff.backgroundColor = divisionColor;
    
    // 项目定位
    UILabel *projectPositioning = [[UILabel alloc] init];
    projectPositioning.textColor = lgrayColor;
    projectPositioning.font = midFont;
    
    originalString = [NSString stringWithFormat:@"项目定位:  %@",
                      model.hd_house[@"houseLocation"] == nil? @"":[NSString getRidOfEnter:model.hd_house[@"houseLocation"]]];
    paintString = [[NSMutableAttributedString alloc] initWithString:originalString];
    [paintString addAttribute:NSForegroundColorAttributeName
                        value:mainTitleColor
                        range:[originalString
                               rangeOfString:@"项目定位:  "]];
    projectPositioning.attributedText = paintString;

    // 面积
    UILabel *area = [[UILabel alloc] init];
    area.textColor = lgrayColor;
    area.font = midFont;
    
    originalString = [NSString stringWithFormat:@"建筑面积:  %@万m²",
                      model.hd_house[@"buildingArea"] == nil? @"":model.hd_house[@"buildingArea"]];
    paintString = [[NSMutableAttributedString alloc] initWithString:originalString];
    [paintString addAttribute:NSForegroundColorAttributeName
                        value:mainTitleColor
                        range:[originalString
                               rangeOfString:@"建筑面积:  "]];
    area.attributedText = paintString;
    
    // 招商状态
    UILabel *_merchanStatus = [[UILabel alloc] init];
    _merchanStatus.textColor = lgrayColor;
    _merchanStatus.font = midFont;
    
    switch ([model.hd_house[@"merchantsStatus"] intValue]) {
        case 1: originalString = @"招商状态:  意向登记期";
            break;
        case 2: originalString = @"招商状态:  意向租赁期";
            break;
        case 3: originalString = @"招商状态:  品牌转定期";
            break;
        case 4: originalString = @"招商状态:  已开业";
            break;
        default: originalString = @"招商状态:  未定";
            break;
    }
    
    paintString = [[NSMutableAttributedString alloc]initWithString:originalString];
    [paintString addAttribute:NSForegroundColorAttributeName
                        value:mainTitleColor
                        range:[originalString
                               rangeOfString:@"招商状态:  "]];
    _merchanStatus.attributedText = paintString;
    
    // 开业时间
    UILabel *_opening = [[UILabel alloc] init];
    _opening.textColor = lgrayColor;
    _opening.font = midFont;
    
    
    if ([model.hd_house[@"openedTime"] integerValue] == 0) {
        
        originalString = @"预计开业时间:  待定";
    }
    else if (todayD-[model.hd_house[@"openedTime"] integerValue]>0){
        
        originalString = @"预计开业时间:  已开业";
    }
    else {
        
        originalString = [NSString stringWithFormat:@"预计开业时间:  %@",[Tools_F timeTransform:[model.hd_house[@"openedTime"] floatValue] time:days]];
    }
    
    paintString = [[NSMutableAttributedString alloc] initWithString:originalString];
    [paintString addAttribute:NSForegroundColorAttributeName
                        value:mainTitleColor
                        range:[originalString rangeOfString:@"预计开业时间:  "]];
    _opening.attributedText = paintString;
    
    // 地址
    UILabel *_address = [[UILabel alloc] init];
    _address.textColor = lgrayColor;
    _address.font = midFont;
    
    originalString = [NSString stringWithFormat:@"地址:  %@",[NSString getRidOfEnter:model.hd_house[@"address"]]];
    paintString = [[NSMutableAttributedString alloc] initWithString:originalString];
    [paintString addAttribute:NSForegroundColorAttributeName
                        value:mainTitleColor
                        range:[originalString
                               rangeOfString:@"地址:  "]];
    _address.attributedText = paintString;
    
    // 所属商圈
    UILabel *businessCircles = [[UILabel alloc] init];
    businessCircles.textColor = lgrayColor;
    businessCircles.font = midFont;
    
    originalString = [NSString stringWithFormat:@"所属商圈:  %@",
                      model.hd_house[@"projectCircleDescription"] == nil? @"":model.hd_house[@"projectCircleDescription"]];
    paintString = [[NSMutableAttributedString alloc] initWithString:originalString];
    paintString = [[NSMutableAttributedString alloc] initWithString:originalString];
    [paintString addAttribute:NSForegroundColorAttributeName
                        value:mainTitleColor
                        range:[originalString
                               rangeOfString:@"所属商圈:  "]];
    businessCircles.attributedText = paintString;
    
    // 下分割线
    UIView *cutOff2 = [[UIView alloc] init];
    cutOff2.backgroundColor = divisionColor;
    
    [bg_scrollView addSubview:_headImage];
    [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 240));
    }];
    
    [_headImage addSubview:gray_bg];
    [gray_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_headImage).with.offset(-15);
        make.bottom.equalTo(_headImage).with.offset(-15);
        make.size.mas_equalTo(CGSizeMake(75, 20));
    }];
    
    [gray_bg addSubview:imgIcon];
    [imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(gray_bg.mas_left).with.offset(5);
        make.centerY.equalTo(gray_bg.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [gray_bg addSubview:_imageCounts];
    [_imageCounts mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(gray_bg.mas_right).with.offset(-5);
        make.centerY.equalTo(gray_bg.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(65, 15));
    }];
    
    [bg_scrollView addSubview:price_bg];
    [price_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImage.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.width.equalTo(bg_scrollView);
    }];
    
    [price_bg addSubview:_price];
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(@10);
        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 20));
    }];
    
    [price_bg addSubview:_priceDescribe];
    [_priceDescribe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_price.mas_bottom).offset(5);
        make.left.equalTo(@10);
        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 13));
    }];
    
    [price_bg addSubview:cutOff];
    [cutOff mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceDescribe.mas_bottom).offset(15);
        make.left.equalTo(@10);
        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 1));
    }];
    
    [price_bg addSubview:projectPositioning];
    [projectPositioning mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cutOff.mas_bottom).offset(15);
        make.left.equalTo(@10);
        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 13));
    }];
    
    [price_bg addSubview:_merchanStatus];
    [_merchanStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(projectPositioning.mas_bottom).offset(10);
        make.left.equalTo(@10);
        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 13));
    }];
    
    [price_bg addSubview:area];
    [area mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_merchanStatus.mas_bottom).offset(10);
        make.left.equalTo(@10);
        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 13));
    }];
    
    [price_bg addSubview:_opening];
    [_opening mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(area.mas_bottom).offset(10);
        make.left.equalTo(@10);
        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 13));
    }];
    
    [price_bg addSubview:_address];
    [_address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_opening.mas_bottom).offset(10);
        make.left.equalTo(@10);
        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 13));
    }];
    
    [price_bg addSubview:businessCircles];
    [businessCircles mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_address.mas_bottom).offset(10);
        make.left.equalTo(@10);
        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 13));
    }];
    
    // 标签
    if (![model.hd_tagList isEqual:[NSNull null]]) {
        
        [price_bg addSubview:cutOff2];
        [cutOff2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(businessCircles.mas_bottom).offset(15);
            make.left.equalTo(@10);
            make.size.mas_equalTo(CGSizeMake(viewWidth-20, 1));
        }];
        
        NSMutableArray *arr = [NSMutableArray array];
        for (int i=0; i<[model.hd_tagList count]; i++) {
            
            [arr addObject:model.hd_tagList[i][@"tagName"]];
        }
        
        DWTagList *tagList = [[DWTagList alloc] initWithFrame:CGRectMake(0, 0, viewWidth-20, 25)];
        tagList.backgroundColor = [UIColor whiteColor];
        tagList.userInteractionEnabled = NO;
        [tagList setAutomaticResize:YES];
        [tagList setTags:arr];          // 对入数据
        
        // Customisation
        [tagList setTagBackgroundColor:[UIColor whiteColor]];
        [tagList setCornerRadius:5];
        [tagList setTextColor:dblueColor];
        [tagList setBorderColor:dblueColor];
        [tagList setBorderWidth:1.0f];
        
        [price_bg addSubview:tagList];
        [tagList mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cutOff2.mas_bottom).with.offset(10);
            make.left.equalTo(@10);
            make.size.mas_equalTo(CGSizeMake(viewWidth-20, 25));
        }];
        
        [price_bg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(tagList.mas_bottom).with.offset(8);
        }];
    }
    else {
        
        [price_bg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(businessCircles.mas_bottom).with.offset(10);
        }];
    }
    
    /*------------------------------ 铺位招商 ------------------------------*/
    
    HouseDetailTitle *rentTitle = [[HouseDetailTitle alloc] init];
    rentTitle.theTitle.text = [NSString stringWithFormat:@"铺位招商(%@)",model.hd_houseStoreTotalSize];
    rentTitle.titleType = haveArrow;
    
    UITapGestureRecognizer *recommendListTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
    rentTitle.tag = 1110;
    rentTitle.userInteractionEnabled =YES;
    [rentTitle addGestureRecognizer:recommendListTap];
    
    rentContent = [[HouseRecommend alloc] init];
    
    float rentTitle_h = 0;
    float rentContent_h = 0;
    
    if (![model.hd_houseStoreList isEqual:[NSNull null]]) {
        
        for (int i=0; i<[model.hd_houseStoreList count]; i++) {
            
            NSDictionary *dict = model.hd_houseStoreList[i];
            
            ThumbnailButton *thumbanil = [[ThumbnailButton alloc] initWithFrame:CGRectMake(i*(130), 0, 130, 165)];
            
            thumbanil.tag = 700+i;
            
            thumbanil.imgView.contentMode = UIViewContentModeScaleAspectFill;
            [thumbanil.imgView sd_setImageWithURL:dict[@"defaultImage"] placeholderImage:[UIImage imageNamed:@"square_loading"]] ;
            
            thumbanil.topLabel.text = [NSString stringWithFormat:@"%@",dict[@"storeName"]];
            thumbanil.midLabel.text = [NSString stringWithFormat:@"业态:%@",dict[@"categoryName"]];
            thumbanil.bottomLabel.text = [NSString stringWithFormat:@"面积:%@m²",dict[@"storeArea"]];
            [thumbanil addTarget:self action:@selector(nearAndSimilarClick:) forControlEvents:UIControlEventTouchUpInside];
            [rentContent.houseRecommendScrollView addSubview:thumbanil];
            
            rentContent.houseRecommendScrollView.frame = CGRectMake(0, 0, viewWidth, 165);
            rentContent.houseRecommendScrollView.contentSize = CGSizeMake(130+i*(130), 165);
            
            rentTitle_h = 40;
            rentContent_h = 165;
        }
    }
    
    [bg_scrollView addSubview:rentTitle];
    [rentTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(price_bg.mas_bottom).offset(rentTitle_h==0?0:10);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, rentTitle_h));
    }];
    
    [bg_scrollView addSubview:rentContent];
    [rentContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rentTitle.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, rentContent_h));
    }];
    
    /*------------------------------ 项目参数 ------------------------------*/
    
    HouseDetailTitle *houseParaTitle  = [[HouseDetailTitle alloc] init];
    houseParaTitle.theTitle.text = @"项目参数";
    houseParaTitle.titleType = haveArrow;
    
    UITapGestureRecognizer *hdTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
    houseParaTitle.tag = 100;
    houseParaTitle.userInteractionEnabled =YES;
    [houseParaTitle addGestureRecognizer:hdTap];
    
    UIView *houseParaContent = [[UIView alloc] init];
    houseParaContent.backgroundColor = [UIColor whiteColor];
    
    [bg_scrollView addSubview:houseParaTitle];
    [houseParaTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rentContent.mas_bottom).offset(10);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 40));
    }];
    
    [bg_scrollView addSubview:houseParaContent];
    [houseParaContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(houseParaTitle.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.width.equalTo(bg_scrollView.mas_width);
    }];
    
    UIView *lastView = nil;
    for (int i=0; i<[paraTitle count]; i++) {
        
        UILabel *label = [[UILabel alloc] init];
        label.font = midFont;
        label.textColor = lgrayColor;
        //label.text = [NSString stringWithFormat:@"%@: %@",paraTitle[i],paraContent[i]];
        label.numberOfLines = 0;
        NSString * surroundingString1 = [NSString stringWithFormat:@"%@: %@",
                                         paraTitle[i],paraContent[i]];
        NSMutableAttributedString * surroundString2 = [[NSMutableAttributedString alloc] initWithString:surroundingString1];
        [surroundString2 addAttribute:NSForegroundColorAttributeName
                                value:mainTitleColor
                                range:[paraTitle[i]
                                       rangeOfString:paraTitle[i]]];
        label.attributedText = surroundString2;
        [houseParaContent addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.right.equalTo(houseParaContent.mas_right).with.offset(-10);
            //make.height.mas_equalTo(@13);
            if (lastView){
                make.top.mas_equalTo(lastView.mas_bottom).with.offset(8);
            }
            else {
                make.top.mas_equalTo(@15);
            }
        }];
        lastView = label;
    }
    
    UIView * viewbg_sel = [[UIView alloc] init];
    viewbg_sel.backgroundColor = [UIColor whiteColor];
    [bg_scrollView addSubview:viewbg_sel];
    [viewbg_sel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(houseParaContent.mas_bottom).offset(0);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 20));
    }];
    
    SelectButton = [SelectBtn buttonWithType:UIButtonTypeCustom] ;
    SelectButton.backgroundColor = [UIColor whiteColor];
    SelectButton.titleLabel.font = midFont;
    [SelectButton setTitleColor:dblueColor forState:UIControlStateNormal];
    //[SelectButton setTitle:@"查看更多信息" forState:UIControlStateNormal];
    [SelectButton setImage:[UIImage imageNamed:@"icon-chevron-down"] forState:UIControlStateNormal];
    [SelectButton setImage:[UIImage imageNamed:@"icon-chevron-up"] forState:UIControlStateSelected];
    
    
    [SelectButton addTarget:self action:@selector(desBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [viewbg_sel addSubview:SelectButton];
    
    [houseParaContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView.mas_bottom).with.offset(15);
    }];
    if (pectIndex == 1) {
        SelectButton.selected = NO;
        [SelectButton setTitle:@"查看更多信息" forState:UIControlStateNormal];
        //SelectButton.frame = CGRectMake(0, CGRectGetMaxY(houseParaContent.frame), 110, 20);
        [SelectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(houseParaContent.mas_bottom).offset(0);
            make.left.equalTo(bg_scrollView.mas_left);
            make.size.mas_equalTo(CGSizeMake(120, 15));
        }];
    }else{
        
        SelectButton.selected = YES;
        [SelectButton setTitle:@"收起" forState:UIControlStateNormal];
        //SelectButton.frame = CGRectMake(0, CGRectGetMaxY(houseParaContent.frame), 50, 20);
        [SelectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(houseParaContent.mas_bottom).offset(0);
            make.left.equalTo(bg_scrollView.mas_left);
            make.size.mas_equalTo(CGSizeMake(60, 15));
        }];
    }
    
    /*------------------------------ 招商业态 ------------------------------*/
    
    HouseDetailTitle *attractInvestmentObjectTitle  = [[HouseDetailTitle alloc] init];
    attractInvestmentObjectTitle.theTitle.text = @"招商业态";
    
    UIView *attractInvestmentObjectContent = [[UIView alloc] init];
    attractInvestmentObjectContent.backgroundColor = [UIColor whiteColor];
    
    UILabel *aiotText = [[UILabel alloc] init];
    aiotText.text = [NSString stringWithFormat:@"%@",model.hd_house[@"planFormat"] == nil?@"":model.hd_house[@"planFormat"]];
    aiotText.font = midFont;
    aiotText.textColor = lgrayColor;
    aiotText.numberOfLines = 0;
    
    float  attractInvestmentTitle_h = 0;
    float  attractInvestmentContent_h = 0;
    if (![model.hd_house[@"planFormat"] isEqual:[NSNull null]]) {
        
        if (![model.hd_house[@"planFormat"] isEqualToString:@""]) {
            
            attractInvestmentTitle_h = 40;
            attractInvestmentContent_h = 10;
        }
        
    }
    
    
    [bg_scrollView addSubview:attractInvestmentObjectTitle];
    [attractInvestmentObjectTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(SelectButton.mas_bottom).offset(attractInvestmentContent_h);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, attractInvestmentTitle_h));
    }];
    
    [bg_scrollView addSubview:attractInvestmentObjectContent];
    [attractInvestmentObjectContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(attractInvestmentObjectTitle.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.width.equalTo(bg_scrollView.mas_width);
    }];
    
    [attractInvestmentObjectContent addSubview:aiotText];
    [aiotText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(attractInvestmentContent_h));
        make.left.equalTo(attractInvestmentObjectContent.mas_left).with.offset(10);
        make.right.equalTo(attractInvestmentObjectContent.mas_right).with.offset(-10);
    }];
    
    [attractInvestmentObjectContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(aiotText.mas_bottom).with.offset(attractInvestmentContent_h);
    }];
    
    /*------------------------------ 最新动态 ------------------------------*/
    
    HouseDetailTitle *dynamicTitle = [[HouseDetailTitle alloc] init];
    dynamicTitle.theTitle.text = @"最新动态";
    dynamicTitle.titleType = haveArrow;
    
    UITapGestureRecognizer *dynamicTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
    dynamicTitle.tag = 103;
    dynamicTitle.userInteractionEnabled =YES;
    [dynamicTitle addGestureRecognizer:dynamicTap];
    
    HouseDynamic *dyanamicContent = [[HouseDynamic alloc] init];
    HouseDynamic *dyanamicContent1 = [[HouseDynamic alloc] init];
    
    float dynamicTitle_h = 0;
    float dyanamicContent_h = 0;
    float dyanamicContent_h1 = 0;
    if ([model.hd_dynamicList count]>0) {
        dyanamicContent.dynamicTitle.text = [NSString stringWithFormat:@"%@", model.hd_dynamicList[0][@"title"]];
        dyanamicContent.dynamicTitle.font = titleFont_15;
        dyanamicContent.dynamicTitle.textColor = [UIColor blackColor];
        dyanamicContent.dynamicTime.text = [NSString stringWithFormat:@"%@", [Tools_F timeTransform:[model.hd_dynamicList[0][@"addTime"] intValue] time:days]];
        
        if ([model.hd_dynamicList count] > 1) {
            
            dyanamicContent1.dynamicTitle.text = [NSString stringWithFormat:@"%@", model.hd_dynamicList[1][@"title"]];
            dyanamicContent1.dynamicTitle.numberOfLines = 0;
            dyanamicContent1.dynamicTitle.font = titleFont_15;
            dyanamicContent1.dynamicTitle.textColor = [UIColor blackColor];
            dyanamicContent1.dynamicTime.text = [NSString stringWithFormat:@"%@", [Tools_F timeTransform:[model.hd_dynamicList[1][@"addTime"] intValue] time:days]];
            dyanamicContent_h1 = 60.f;
        }
        dynamicTitle_h = 40.f;
        dyanamicContent_h = 60.f;
    }
    
    [bg_scrollView addSubview:dynamicTitle];
    [dynamicTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(attractInvestmentObjectContent.mas_bottom).offset(dynamicTitle_h==0?:attractInvestmentContent_h);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, dynamicTitle_h));
    }];
    
    [bg_scrollView addSubview:dyanamicContent];
    [dyanamicContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dynamicTitle.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, dyanamicContent_h));
    }];
    [bg_scrollView addSubview:dyanamicContent1];
    [dyanamicContent1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dyanamicContent.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, dyanamicContent_h1));
    }];
    
    
    /*------------------------------ 业态平面图 ------------------------------*/
    
    HouseDetailTitle *floorPlansTitle  = [[HouseDetailTitle alloc] init];
    floorPlansTitle.theTitle.text = @"业态规划平面图";
    floorPlansTitle.titleType = haveArrow;
    
    UITapGestureRecognizer *aldTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
    floorPlansTitle.tag = 101;
    floorPlansTitle.userInteractionEnabled =YES;
    [floorPlansTitle addGestureRecognizer:aldTap];
    
    UIButton *floorPlansContent = [UIButton buttonWithType:UIButtonTypeCustom];
    [floorPlansContent sd_setBackgroundImageWithURL:[NSURL URLWithString:model.hd_house[@"onlineImage"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading_b"]];
    [floorPlansContent addTarget:self action:@selector(jumpFloorPlan) forControlEvents:UIControlEventTouchUpInside];
    
    float floorPlansTitle_h = 40;
    float floorPlansContent_h = 200;
    
    [bg_scrollView addSubview:floorPlansTitle];
    [floorPlansTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dyanamicContent1.mas_bottom).offset(10);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, floorPlansTitle_h));
    }];
    
    [bg_scrollView addSubview:floorPlansContent];
    [floorPlansContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(floorPlansTitle.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, floorPlansContent_h));
    }];
    
    /*------------------------------ 360全景 ------------------------------*/
    
    HouseDetailTitle *quanjingTitle  = [[HouseDetailTitle alloc] init];
    quanjingTitle.theTitle.text = @"项目商圈";
    quanjingTitle.titleType = haveArrow;
    
    [bg_scrollView addSubview:quanjingTitle];
    
    UITapGestureRecognizer *qjTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
    quanjingTitle.tag = 130;
    quanjingTitle.userInteractionEnabled =YES;
    [quanjingTitle addGestureRecognizer:qjTap];
    
    
    
    UIImageView * mapViewImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(quanjingTitle.frame), viewWidth, 350)];
    float mapViewImageFloat = 0;
    float quanjingTitlefloat = 0;
    if (![model.hd_images[@"trafficMapUrls"] isEqual:[NSNull null]]) {
        if ([model.hd_images[@"trafficMapUrls"] count] > 0) {
            
            [mapViewImage sd_setImageWithURL:model.hd_images[@"trafficMapUrls"][0] placeholderImage:[UIImage imageNamed:@"cell_loading"]];
            mapViewImageFloat = 350;
            quanjingTitlefloat = 40;
        }
    }
    
    [bg_scrollView addSubview:mapViewImage];
    
    [quanjingTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(floorPlansContent.mas_bottom).offset(10);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, quanjingTitlefloat));
    }];
    
    [mapViewImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(quanjingTitle.mas_bottom).offset(0);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, mapViewImageFloat));
    }];
    
    /*------------------------------ 在线点评 ------------------------------*/
    
    HouseDetailTitle *evaluationTitle = [[HouseDetailTitle alloc] init];
    evaluationTitle.theTitle.text = @"在线点评";
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
    
    float devaluationContent_h = 140.f;
    if ([model.hd_houseCommentDTO[@"total"] intValue] != 0) {
        // 未对数据
        evaluationContent.totalStar.scorePercent = [model.hd_houseCommentDTO[@"avgScore"] floatValue]/5;
        evaluationContent.totalScore.text = [NSString stringWithFormat:@"%.1f分",[model.hd_houseCommentDTO[@"avgScore"] floatValue]];
        evaluationContent.scoreDetail.text = [NSString stringWithFormat:@"价格%.1f分 地段%.1f分 配套%.1f分 交通%.1f分 政策%.1f分 竞争%.1f分",
                                              [model.hd_houseCommentDTO[@"priceScore"] floatValue],
                                              [model.hd_houseCommentDTO[@"areaScore"] floatValue],
                                              [model.hd_houseCommentDTO[@"supportingScore"] floatValue],
                                              [model.hd_houseCommentDTO[@"trafficScore"] floatValue],
                                              [model.hd_houseCommentDTO[@"policyScore"] floatValue],
                                              [model.hd_houseCommentDTO[@"competeScore"] floatValue]];
        
        devaluationContent_h = 270.f;
    }
    
    [bg_scrollView addSubview:evaluationTitle];
    [evaluationTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mapViewImage.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 40));
        make.left.equalTo(bg_scrollView.mas_left);
    }];
    
    [bg_scrollView addSubview:evaluationContent];
    [evaluationContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(evaluationTitle.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, devaluationContent_h));
    }];
    
    /*------------------------------ 已入驻品牌+最近品牌 ------------------------------*/
    
    HouseDetailTitle *mainStoreListTitle  = [[HouseDetailTitle alloc] init];
    mainStoreListTitle.theTitle.text = @"主力品牌进驻";
    mainStoreListTitle.titleType = haveArrow;
    
    UITapGestureRecognizer *mslTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
    mainStoreListTitle.tag = 200;
    mainStoreListTitle.userInteractionEnabled =YES;
    [mainStoreListTitle addGestureRecognizer:mslTap];
    
    HouseRecommend *mainStoreListContent = [[HouseRecommend alloc] init];
    
    float mainStoreListTitle_h = 0;
    float mainStoreListContent_h = 0;
    
    if (![model.hd_mainBrandList isEqual:[NSNull null]]) {
        
        if ([model.hd_mainBrandList count] != 0) {
            
            for (int i=0; i<[model.hd_mainBrandList count]; i++) {
                
                NSDictionary *dict = model.hd_mainBrandList[i];
                
                MainBrankButton *mainBrankButton = [[MainBrankButton alloc] initWithFrame:CGRectMake(i*(viewWidth/3), 0, viewWidth/3, 90)];
                mainBrankButton.tag = 100+i;
                mainBrankButton.titleLabel.font = largeFont;
                mainBrankButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
                [mainBrankButton sd_setImageWithURL:dict[@"objectLogo"]
                                           forState:UIControlStateNormal
                                   placeholderImage:[UIImage imageNamed:@"square_loading"]];
                [mainBrankButton setTitle:dict[@"objectName"] forState:UIControlStateNormal];
                [mainBrankButton setTitleColor:lgrayColor forState:UIControlStateNormal];
                [Tools_F setViewlayer:mainBrankButton.imageView cornerRadius:0 borderWidth:1 borderColor:divisionColor];
                mainBrankButton.titleLabel.textAlignment = NSTextAlignmentCenter;
                //            [thumbanil addTarget:self action:@selector(mainStoreListClick:) forControlEvents:UIControlEventTouchUpInside];
                
                [mainStoreListContent.houseRecommendScrollView addSubview:mainBrankButton];
                mainStoreListContent.houseRecommendScrollView.frame = CGRectMake(0, 0, viewWidth, 90);
                mainStoreListContent.houseRecommendScrollView.contentSize = CGSizeMake(viewWidth/3+i*(viewWidth/3), 90);
                
                mainStoreListTitle_h = 40;
                mainStoreListContent_h = 90;
            }
        }

    }

//    [bg_scrollView addSubview:mainStoreListTitle];
//    [mainStoreListTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(consultantContent.mas_bottom).offset(mainStoreListTitle_h==0?0:10);
//        make.left.equalTo(bg_scrollView.mas_left);
//        make.size.mas_equalTo(CGSizeMake(viewWidth, mainStoreListTitle_h));
//    }];
    
    [bg_scrollView addSubview:mainStoreListTitle];//
    [mainStoreListTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(evaluationContent.mas_bottom).offset(mainStoreListTitle_h==0?0:10);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, mainStoreListTitle_h));
    }];
    
    [bg_scrollView addSubview:mainStoreListContent];
    [mainStoreListContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainStoreListTitle.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, mainStoreListContent_h));
    }];
    
    HouseDetailTitle *latelyListTitle  = [[HouseDetailTitle alloc] init];
    latelyListTitle.theTitle.text = @"已进驻品牌";
    latelyListTitle.titleType = haveArrow;
    
    UITapGestureRecognizer *llTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
    latelyListTitle.tag = 201;
    latelyListTitle.userInteractionEnabled =YES;
    [latelyListTitle addGestureRecognizer:llTap];
    
    HouseRecommend *latelyListContent = [[HouseRecommend alloc] init];
    
    float latelyListTitle_h = 0;
    float latelyListContent_h = 0;
    
    if (![model.hd_newBrandList isEqual:[NSNull null]]) {
        
        for (int i=0; i<[model.hd_newBrandList count]; i++) {
            
            NSDictionary *dict = model.hd_newBrandList[i];
            
            MainBrankButton *mainBrankButton = [[MainBrankButton alloc] initWithFrame:CGRectMake(i*(viewWidth/3), 0, viewWidth/3, 90)];
            mainBrankButton.tag = 100+i;
            mainBrankButton.titleLabel.font = largeFont;
            mainBrankButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [mainBrankButton sd_setImageWithURL:dict[@"objectLogo"]
                                       forState:UIControlStateNormal
                               placeholderImage:[UIImage imageNamed:@"square_loading"]];
            [mainBrankButton setTitle:dict[@"objectName"] forState:UIControlStateNormal];
            [mainBrankButton setTitleColor:lgrayColor forState:UIControlStateNormal];
            [Tools_F setViewlayer:mainBrankButton.imageView cornerRadius:0 borderWidth:1 borderColor:divisionColor];
            mainBrankButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            
            [latelyListContent.houseRecommendScrollView addSubview:mainBrankButton];
            latelyListContent.houseRecommendScrollView.frame = CGRectMake(0, 0, viewWidth, 90);
            latelyListContent.houseRecommendScrollView.contentSize = CGSizeMake(viewWidth/3+i*(viewWidth/3), 90);
            
            latelyListTitle_h = 40;
            latelyListContent_h = 90;
        }
    }
    
    [bg_scrollView addSubview:latelyListTitle];
    [latelyListTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(mainStoreListContent.mas_bottom).offset(latelyListTitle_h==0?0:10);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, latelyListTitle_h));
    }];
    
    [bg_scrollView addSubview:latelyListContent];
    [latelyListContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(latelyListTitle.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, latelyListContent_h));
    }];
    
    /*------------------------------ 查看更多 ------------------------------*/
    
//    UIButton *checkMore = [UIButton buttonWithType:UIButtonTypeCustom];
//    checkMore.titleLabel.font = titleFont_15;
//    checkMore.backgroundColor = [UIColor whiteColor];
//    [checkMore setTitle:@"查看更多项目详情" forState:UIControlStateNormal];
//    [checkMore setTitleColor:mainTitleColor forState:UIControlStateNormal];
//    [Tools_F setViewlayer:checkMore cornerRadius:5 borderWidth:0 borderColor:nil];
//    [checkMore addTarget:self action:@selector(lookingMore) forControlEvents:UIControlEventTouchUpInside];
//    [bg_scrollView addSubview:checkMore];
    
    HouseDetailTitle *checkMore  = [[HouseDetailTitle alloc] init];
    checkMore.theTitle.text = @"查看更多项目详情";
    checkMore.titleType = haveArrow;
    checkMore.cutOff.hidden = YES;
    [bg_scrollView addSubview:checkMore];
    
    UITapGestureRecognizer *cmTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
    checkMore.tag = 1000;
    checkMore.userInteractionEnabled = YES;
    [checkMore addGestureRecognizer:cmTap];
    
    [checkMore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(latelyListContent.mas_bottom).offset(10);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 40));
    }];
    
    // 自动scrollview高度
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(checkMore.mas_bottom).with.offset(55);
    }];
    
    /*------------------------------ 底部按钮 ------------------------------*/
    
    botView = [[UIView alloc] init];
    botView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:botView];
    
    UIButton *callButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [callButton setTitle:@"立即联系" forState:UIControlStateNormal];
    [callButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [callButton addTarget:self action:@selector(takePhone:) forControlEvents:UIControlEventTouchUpInside];
    [callButton setBackgroundColor:tagsColor];
    [botView addSubview:callButton];
    
    [botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 45));
    }];
    
    [callButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(botView);
    }];
}

#pragma mark - 业态平面图
- (void)jumpFloorPlan{
    
    ALDViewController *aldVC = [[ALDViewController alloc] init];
    
    aldVC.imageUrl = [NSURL URLWithString:model.hd_house[@"onlineImage"]];
    aldVC.houseID = model.hd_house[@"houseId"];
    aldVC.canAppointment = [model.hd_house[@"canAppointment"] integerValue] == 1? YES:NO;
    aldVC.isOfficial = NO;
    [self.navigationController pushViewController:aldVC animated:YES];
}

#pragma mark -- 项目参数按钮
-(void)desBtnClick:(UIButton *)btn{
    
    [botView removeFromSuperview];
    [bg_scrollView removeFromSuperview];
    selIndex = 1;
    pectIndex *= -1;
    if (pectIndex == -1) {
        paraTitle = @[
                      @"商业面积",
                      @"楼   层",
                      @"租   期",
                      @"建筑类型",
                      @"规划业态",
                      @"管 理 费",
                      @"商铺数量",
                      @"占地面积",
                      //                      @"建筑面积",

                      //                      @"绿化率",
                      @"地上车位数",
                      @"地下车位数",
                      
                      
                      @"实用率",
                      @"容积率",
                      
                      @"开发商",
                      @"运营管理公司",
                      @"产权年限",
                      @"开工时间",
                      @"竣工时间",
                      @"进场装修时间"
                      ];
        
        paraContent = @[
                        model.hd_house[@"commercialArea"] == [NSNull null]?
                        @"暂无":[NSString stringWithFormat:@"%@ m²",model.hd_house[@"commercialArea"] ],
                        model.hd_house[@"floor"] == [NSNull null]?
                        @"暂无":[NSString stringWithFormat:@"%@",model.hd_house[@"floor"]],
                        model.hd_house[@"lease"] == [NSNull null]?
                        @"暂无":[NSString stringWithFormat:@"%@",model.hd_house[@"lease"]],
                        model.hd_house[@"buildingType"] == [NSNull null]?
                        @"暂无":[NSString stringWithFormat:@"%@",model.hd_house[@"buildingType"]],
                        model.hd_house[@"planFormat"] == [NSNull null]?
                        @"暂无":[NSString stringWithFormat:@"%@",model.hd_house[@"planFormat"]],
                        
                        model.hd_house[@"managementFee"] == [NSNull null]?@"暂无":[NSString stringWithFormat:@"%@元/m²",model.hd_house[@"managementFee"]],
                        
                        model.hd_house[@"properties"] == [NSNull null]?@"暂无":[NSString stringWithFormat:@"%@",model.hd_house[@"properties"]],
                        //                        model.hd_house[@"planArea"] == nil?
                        //                        @"暂无":[NSString stringWithFormat:@"%@亩",model.hd_house[@"planArea"]],
                        
                        
                        
                        model.hd_house[@"planArea"] == [NSNull null]?@"暂无":[NSString stringWithFormat:@"%@亩",model.hd_house[@"planArea"]],
                        
                        //                        model.hd_house[@"greeningRate"] == nil || [model.hd_house[@"greeningRate"] isEqualToString:@"暂无"]?@"":[NSString stringWithFormat:@"%@",model.hd_house[@"greeningRate"]],
                        model.hd_house[@"groundParkingSpaces"] == [NSNull null]||[model.hd_house[@"groundParkingSpaces"] isEqualToString:@""]?@"暂无":[NSString stringWithFormat:@"%@",model.hd_house[@"groundParkingSpaces"]],
                        model.hd_house[@"undergroundParkingSpaces"] == [NSNull null]||[model.hd_house[@"undergroundParkingSpaces"] isEqualToString:@""]?@"暂无":[NSString stringWithFormat:@"%@",model.hd_house[@"undergroundParkingSpaces"]],
                        
                        model.hd_house[@"publicRoundRate"] == [NSNull null] || [model.hd_house[@"publicRoundRate"] isEqualToString:@""]?@"暂无":[NSString stringWithFormat:@"%@",model.hd_house[@"publicRoundRate"]],
                        model.hd_house[@"volumeRate"] == [NSNull null] || [model.hd_house[@"volumeRate"] isEqualToString:@""]?@"暂无":[NSString stringWithFormat:@"%@",model.hd_house[@"volumeRate"]],
                        
                        model.hd_houseDeveloper [@"developersName"] == [NSNull null]?@"暂无":[NSString stringWithFormat:@"%@",model.hd_houseDeveloper [@"developersName"]],
                        model.hd_house[@"operationsManagement"] == [NSNull null]?@"暂无":[NSString stringWithFormat:@"%@",model.hd_house[@"operationsManagement"]],
                        model.hd_house[@"propertyAge"] == [NSNull null]?@"暂无":[NSString stringWithFormat:@"%@年",model.hd_house[@"propertyAge"]],
                        [model.hd_house[@"buildingStartTime"] floatValue] == 0?@"暂无":[NSString stringWithFormat:@"%@",[Tools_F timeTransform:[model.hd_house[@"buildingStartTime"] floatValue] time:days]],
                        [model.hd_house[@"buildingEndTime"] floatValue] == 0?@"暂无":[NSString stringWithFormat:@"%@",[Tools_F timeTransform:[model.hd_house[@"buildingEndTime"] floatValue] time:days]],
                        [model.hd_house[@"decorationTime"] floatValue] == 0?@"暂无":[NSString stringWithFormat:@"%@",[Tools_F timeTransform:[model.hd_house[@"decorationTime"] floatValue] time:days]]
                        ];
        //btn.selected = YES;
    }
    else{
        paraTitle = @[
                      @"商业面积",
                      @"楼   层",
                      @"租   期"
                      ];
        
        paraContent = @[
                        model.hd_house[@"commercialArea"] == [NSNull null]?
                        @"暂无":[NSString stringWithFormat:@"%@ m²",model.hd_house[@"commercialArea"] ],
                        model.hd_house[@"floor"] == [NSNull null]?
                        @"暂无":[NSString stringWithFormat:@"%@",model.hd_house[@"floor"]],
                        model.hd_house[@"lease"] == [NSNull null]?
                        @"暂无":[NSString stringWithFormat:@"%@亩",model.hd_house[@"lease"]]
                        ];
        
    }
    
    [self setupUI];
    
    
}



#pragma mark - 底部3按钮方法
- (void)takePhone:(id)sender{
    
    //联系客服
//    UIWebView*callWebview =[[UIWebView alloc] init];
//    
//    NSString *telNumber;
//    if ([model.hd_house[@"telExtra"] isEqual:[NSNull null]]) {
//        
//        telNumber = [NSString stringWithFormat:@"tel:%@",model.hd_house[@"tel"]];
//    }
//    else {
//        
//        telNumber = [NSString stringWithFormat:@"tel:%@,,%@",model.hd_house[@"tel"],model.hd_house[@"telExtra"]];
//    }
//    
//    NSLog(@"%@",telNumber);
//    
//    NSURL *telURL = [NSURL URLWithString:telNumber];
//    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
//    [self.view addSubview:callWebview];
    NSString *telNumber = [[NSString alloc] initWithFormat:@"telprompt://%@",@"4009918829"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telNumber]];
    
}

- (void)im:(id)sender{
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else {
        
        if ([model.hd_consultantList count]>0) {
            
            NSDictionary *dict = model.hd_consultantList[0];
            // 用户id
            NSString *userID = [NSString stringWithFormat:@"%@",dict[@"userId"]];
            NSLog(@"对方id:%@",userID);
            
            // 发送顾问默认欢迎文本
            NSDictionary *param = @{@"consultantUserId":userID,@"type":@0};
            NSString *urlString = [SDD_MainURL stringByAppendingString:@"/user/getIMDefaultWelcomeText.do"];              // 拼接主路径和请求内容成完整url
            [self sendRequest:param url:urlString];
            
            self.hidesBottomBarWhenPushed = YES;
            ChatViewController *cvc = [[ChatViewController alloc] initWithChatter:userID isGroup:FALSE];
            cvc.userName = dict[@"realName"];
            cvc.projectName = model.hd_house[@"houseName"];
            [self.navigationController pushViewController:cvc animated:true];
        }
    }
}

#pragma mark - 顶部图片点击
- (void)topImageTap:(id)sender{
    
    //    FullScreenViewController *fsVC = [[FullScreenViewController alloc] init];
    //    fsVC.imagesFrom = 0;
    //    fsVC.paramID = model.hd_house[@"houseId"];
    //    fsVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //    UINavigationController *nav_houseLookingVC = [[UINavigationController alloc]initWithRootViewController:fsVC];
    //
    //    [self presentViewController:nav_houseLookingVC animated:YES completion:nil];
    
    // 新
    AllPhotoViewController *apVC = [[AllPhotoViewController alloc] init];
    apVC.imageFrom = Rent;
    apVC.paramID = model.hd_house[@"houseId"];
    apVC.imageDict = model.hd_images;
    
    apVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UINavigationController *nav_houseLookingVC = [[UINavigationController alloc]initWithRootViewController:apVC];
    
    [self presentViewController:nav_houseLookingVC animated:YES completion:nil];
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 300) {
        return 70;
    }
    else {
        return 130;
    }
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == 300) {
        if ([model.hd_consultantList isEqual:[NSNull null]]) {
            return 0;
        }
        return [model.hd_consultantList count]<3?[model.hd_consultantList count]:3;
    }
    else {
        
        return [model.hd_houseCommentDTO[@"total"] intValue] != 0?1:0;
    }
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
    
    if (tableView.tag == 300) {
        
        static NSString *identifier2 = @"consultant";
        //重用机制
        ConsultantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier2];      //带标识符的出列
        
        if (cell == nil) {
            //当不存在的时候用重用标识符生成
            cell = [[ConsultantTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier2];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
        }
        
        if (!model) {
            return cell;
        }
        else {
            
            NSDictionary *dict = model.hd_consultantList[indexPath.row];
            
            [cell.avatar sd_setImageWithURL:dict[@"icon"] placeholderImage:[UIImage imageNamed:@"defaultAvatar_icon_"]];
            cell.nickname.text = [NSString stringWithFormat:@"%@",dict[@"realName"]];
            cell.starRate.scorePercent = [dict[@"avgScore"] floatValue]/5;
            cell.comment.text = [NSString stringWithFormat:@"评价(%@)",dict[@"totalCommentQty"]];
            [cell.makeCall addTarget:self action:@selector(callWithConsultant:) forControlEvents:UIControlEventTouchUpInside];
            [cell.makeContact addTarget:self action:@selector(chat:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
        
    }
    else {
        //重用标识符
        static NSString *identifier = @"evaluation";
        //重用机制
        EvalutaionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
        
        if (cell == nil) {
            //当不存在的时候用重用标识符生成
            cell = [[EvalutaionTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
        }
        if (!model) {
            return cell;
        }
        else {
            
            NSDictionary *dict = model.hd_houseCommentDTO[@"commentList"][indexPath.row];
            
            [cell.avatar sd_setImageWithURL:dict[@"icon"] placeholderImage:[UIImage imageNamed:@"defaultAvatar_icon_"]];
            cell.nickname.text = [NSString stringWithFormat:@"%@",dict[@"realName"]];
            cell.starRate.scorePercent = [dict[@"avgScore"] floatValue]/5;
            cell.userType = 1;
            cell.comment.text = [NSString stringWithFormat:@"%@",dict[@"description"]];
            cell.commentTime.text = [NSString stringWithFormat:@"%@",[Tools_F timeTransform:[dict[@"addTime"] intValue] time:seconds]];
            
            return cell;
        }
    }
}

#pragma mark - 点击cell (tableView)
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 300) {
        
//        CounselorInfoViewController *counselorInfoVC = [[CounselorInfoViewController alloc] init];
//        
//        counselorInfoVC.userID = model.hd_consultantList[indexPath.row][@"userId"];
//        counselorInfoVC.houseID = model.hd_house[@"houseId"];
//        [self.navigationController pushViewController:counselorInfoVC animated:YES];
    }
    else {
    }
}

#pragma mark - 看房团
- (void)houseLooking:(UIButton *)btn{
    
    HouseLookingViewController *houseLookingVC = [[HouseLookingViewController alloc] init];
    
    houseLookingVC.houseShowingsId = model.hd_houseShowings[@"houseShowingsId"];
    houseLookingVC.hkTitle = model.hd_house[@"houseName"];
    houseLookingVC.isApply = [model.hd_houseShowings[@"isApply"] integerValue] == 1?YES:NO;
    [self.navigationController pushViewController:houseLookingVC animated:YES];
}

#pragma mark - 标题点击
- (void)titleTap:(UIGestureRecognizer *)tap{
    
    UILabel *label = (UILabel *)tap.view;
    int titleTag = (int)label.tag;
    NSLog(@"标题点击%d",titleTag);
    switch (titleTag) {
        case 99:
        {
            if (![GlobalController isLogin]) {
                
                LoginController *loginVC = [[LoginController alloc] init];
                [self.navigationController pushViewController:loginVC animated:YES];
            }
            else if ([model.hd_house[@"merchantsStatus"] intValue] != 1 && [model.hd_house[@"merchantsStatus"] intValue] != 2 ){
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂无商铺可租" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            else {
                
                OnlineChooseRoomViewController *ocrVC = [[OnlineChooseRoomViewController alloc] init];
                
                ocrVC.houseID = _houseID;
                ocrVC.theTitle = model.hd_house[@"houseName"];
                ocrVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                UINavigationController *nav_ocrVC = [[UINavigationController alloc]initWithRootViewController:ocrVC];
                [self presentViewController:nav_ocrVC animated:YES completion:nil];
            }
        }
            break;
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
            ALDViewController *aldVC = [[ALDViewController alloc] init];
            
            aldVC.imageUrl = [NSURL URLWithString:model.hd_house[@"onlineImage"]];
            aldVC.houseID = model.hd_house[@"houseId"];
            aldVC.canAppointment = [model.hd_house[@"canAppointment"] integerValue] == 1? YES:NO;
            aldVC.isOfficial = YES;
            
            [self.navigationController pushViewController:aldVC animated:YES];
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
            ConsultantViewController *consultantVC = [[ConsultantViewController alloc] init];
            
            consultantVC.houseID = model.hd_house[@"houseId"];
            [self.navigationController pushViewController:consultantVC animated:YES];
        }
            break;
        case 107:
        {
            NearAndSimilarViewController *nasVC = [[NearAndSimilarViewController alloc] init];
            nasVC.houseID = model.hd_house[@"houseId"];
            nasVC.nasTitle = @"周边项目";
            [self.navigationController pushViewController:nasVC animated:YES];
        }
            break;
        case 108:
        {
            NearAndSimilarViewController *nasVC = [[NearAndSimilarViewController alloc] init];
            nasVC.houseID = model.hd_house[@"houseId"];
            nasVC.nasTitle = @"同类项目";
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
        case 200:
        {
            MainBrankListViewController *mblVC = [[MainBrankListViewController alloc] init];
            
            mblVC.brandTitle = @"已入驻品牌";
            mblVC.brandList = model.hd_mainBrandList;
            [self.navigationController pushViewController:mblVC animated:YES];
        }
            break;
        case 201:
        {
            MainBrankListViewController *mblVC = [[MainBrankListViewController alloc] init];
            
            mblVC.brandTitle = @"最近品牌签约";
            mblVC.brandList = model.hd_newBrandList;
            [self.navigationController pushViewController:mblVC animated:YES];
        }
            break;
        case 1000:
        {
            GRMoreDetailViewController *grmdVC = [[GRMoreDetailViewController alloc] init];
            
            grmdVC.activityCategoryId = _activityCategoryId;
            grmdVC.houseID = _houseID;
            grmdVC.model = model;
            [grmdVC valueReturn:^(NSString *theHouseID) {
                _houseID = theHouseID;
                [self requestData];
            }];
            
            [self.navigationController pushViewController:grmdVC animated:YES];
        }
            break;
        case 1110:
        {
            //商铺招商
            PurchaseShopViewController * psVC = [[PurchaseShopViewController alloc] init];
            psVC.houseID = _houseID;
            psVC.canAppointmentSign = model.hd_house[@"canAppointmentSign"];
            psVC.hr_activityCategoryId = _hr_activityCategoryId;
            psVC.type = _type;
            [self.navigationController pushViewController:psVC animated:YES];
        }
            break;
            case 130:
        {
            ProjectCViewController *pcVC = [[ProjectCViewController alloc] init];
            //ProjectCoopViewController *pcVC = [[ProjectCoopViewController alloc] init];
            pcVC.model = model;
            [self.navigationController pushViewController:pcVC animated:YES];
        }
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


#pragma mark - 收藏
- (void)starClick:(UIButton *)btn{
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else {
        
        NSDictionary *dic = @{@"activityCategoryId":_activityCategoryId,@"houseId":_houseID};
        NSString *str = btn.isSelected?
        [SDD_MainURL stringByAppendingString:@"/user/house/deleteCollection.do"]:
        [SDD_MainURL stringByAppendingString:@"/user/house/collection.do"];
        [self addOrCancelFavorite:str param:dic button:btn];
    }
}

#pragma mark - 取消、添加收藏网络请求
- (void)addOrCancelFavorite:(NSString *)url param:(NSDictionary *)dic button:(UIButton *)btn{
    
    [self.httpManager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = responseObject;
        if ([dict[@"status"] intValue] == 1) {
            
            btn.selected = !btn.selected;
            [self showSuccessWithText:dict[@"message"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
}

#pragma mark - 招商顾问电话
- (void)callWithConsultant:(UIButton *)btn{
    
    // 获得indexpath
    ConsultantTableViewCell *cell = (ConsultantTableViewCell *)btn.superview;
    NSIndexPath *indexPath = [consultantContent.consultantTable indexPathForCell:cell];
    
    NSDictionary *dict = model.hd_consultantList[indexPath.row];
    //NSString *num = [NSString stringWithFormat:@"tel:%@",dict[@"phone"]];
    NSString *num;
    if (![dict[@"telExtra"] isEqualToString:@""]) {
        
        num = [NSString stringWithFormat:@"tel:%@%@",dict[@"tel"],dict[@"telExtra"]];
    }else{
        
        num = [NSString stringWithFormat:@"tel:%@",dict[@"tel"]];
    }
     NSLog(@"%@",num);
    // 联系顾问
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:num];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}

#pragma mark - 聊天
- (void)chat:(UIButton *)btn{
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else {
        
        // 获得indexpath
        ConsultantTableViewCell *cell = (ConsultantTableViewCell *)btn.superview;
        NSIndexPath *indexPath = [consultantContent.consultantTable indexPathForCell:cell];
        
        NSDictionary *dict = model.hd_consultantList[indexPath.row];
        
        // 用户id
        NSString *userID = [NSString stringWithFormat:@"%@",dict[@"userId"]];
        NSLog(@"对方id:%@",userID);
        
        // 发送顾问默认欢迎文本
        NSDictionary *param = @{@"consultantUserId":userID};
        NSString *urlString = [SDD_MainURL stringByAppendingString:@"/user/getIMDefaultWelcomeText.do"];              // 拼接主路径和请求内容成完整url
        [self sendRequest:param url:urlString];
        
        self.hidesBottomBarWhenPushed = YES;
        ChatViewController *cvc = [[ChatViewController alloc] initWithChatter:userID isGroup:FALSE];
        cvc.userName = dict[@"realName"];
        cvc.projectName = model.hd_house[@"houseName"];
        [self.navigationController pushViewController:cvc animated:true];
    }
}

#pragma mark - 更多项目详情
- (void)lookingMore{
    
    GRMoreDetailViewController *grmdVC = [[GRMoreDetailViewController alloc] init];
    
    grmdVC.activityCategoryId = _activityCategoryId;
    grmdVC.houseID = _houseID;
    grmdVC.model = model;
    [grmdVC valueReturn:^(NSString *theHouseID) {
        _houseID = theHouseID;
        [self requestData];
    }];
    
    [self.navigationController pushViewController:grmdVC animated:YES];
}

#pragma mark - 通知我
- (void)notifyMe:(UIButton *)btn{
    
    NSString *timing;
    switch ([model.hd_house[@"merchantsStatus"] intValue]) {
        case 1: timing = @"意向登记期";
            break;
        case 2: timing = @"意向金收取期";
            break;
        case 3: timing = @"转定签约期";
            break;
        default: timing = @"";
            break;
    }
    
    UIAlertView *infoModify = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:[NSString stringWithFormat:@"项目进行%@时会通过短信及手机推送消息通知您",timing]
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"确定", nil];
    infoModify.tag = 100;
    infoModify.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    //设置输入框的键盘类型
    UITextField *phoneNum_A = [infoModify textFieldAtIndex:0];
    phoneNum_A.placeholder = @"请输入11位手机号码";
    phoneNum_A.keyboardType = UIKeyboardTypeNumberPad;
    
    UILabel *num = [[UILabel alloc] init];
    num.frame = CGRectMake(0, 0, 50, 20);
    num.text = @"手机号";
    num.font = midFont;
    phoneNum_A.leftView = num;
    phoneNum_A.leftViewMode = UITextFieldViewModeAlways;
    
    [infoModify show];
}

#pragma mark - UIAlertView代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag ==100 && buttonIndex == 1) {
        
        UITextField *phoneTextfield = [alertView textFieldAtIndex:0];
        if ([Tools_F validateMobile:phoneTextfield.text]) {
            
            NSDictionary *param = @{@"phone":phoneTextfield.text,
                                    @"type":[NSNumber numberWithInteger:[model.hd_house[@"merchantsStatus"] integerValue]+1],
                                    @"houseId":_houseID};
            
            [HttpTool postWithBaseURL:SDD_MainURL Path:@"/house/noticeMe.do" params:param success:^(id JSON) {
                
                NSLog(@"%@>>>>>>>%@",JSON[@"message"],param);
                
                if ([JSON[@"status"] intValue] == 1) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"您已成功提交，请耐心等候"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
            } failure:^(NSError *error) {
                
                NSLog(@"通知我错误%@",error);
            }];
        }
        else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"请输入11位手机号码"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
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

