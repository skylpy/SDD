//
//  PreferentialBrandViewController.m
//  SDD
//
//  Created by hua on 15/7/21.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "PreferentialBrandViewController.h"
#import "JoinDetailViewController.h"
#import "FranchiseesDetailModel.h"
#import "HouseDetialViews.h"
#import "JoinRecommendButton.h"
#import "NSString+SDD.h"

#import "FullScreenViewController.h"
#import "DynamicListViewController.h"
#import "BranksIntroductionViewController.h"
#import "PropertyDescriptionViewController.h"
#import "InvestmentAnalysisViewController.h"
#import "RegionListViewController.h"
#import "JoinAdvantageViewController.h"
#import "JoinContactViewController.h"
#import "GetCouponViewController.h"
#import "SomeRecommandViewController.h"
#import "ChatViewController.h"

#import "ShareHelper.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

@interface PreferentialBrandViewController (){
    
    /*- data -*/
    
    FranchiseesDetailModel *model;                        // 模型
    
    /*- ui -*/
    
    UIScrollView *bg_scrollView;
    UIView *bottomView;
}

@end

@implementation PreferentialBrandViewController

#pragma mark - 请求数据
- (void)requestData{
    
    [bg_scrollView removeFromSuperview];     // 移除原有视图
    [bottomView removeFromSuperview];
    
    // 请求参数
    NSDictionary *param = @{@"brandId":_brandId};
    
    [self showLoading:1];
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brand/detail.do" params:param success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSDictionary *dict = JSON[@"data"];
        
        if (![dict isEqual:[NSNull null]]) {
            
            model = [FranchiseesDetailModel franchiseesDetailWithDict:dict];
            
            // 导航条
            [self setupNav];
            // ui
            [self setupUI];
            // 刷新数据并回滚到最上
            [bg_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        
        [self hideLoading];
    } failure:^(NSError *error) {
        
        [self hideLoading];
    }];
}

#pragma mark - 基本信息
- (NSDictionary *)getBaseInfo{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    NSArray *baseInfoTitle = @[
                               @"业态类别",
                               @"区位要求",
                               @"面积需求",
                               @"合作期限",
                               @"开店模式",
                               @"品牌定位",
                               @"企业名称",
                               @"计划拓展",
                               @"首选物业",
                               @"物业方式"
                               ];
    
    [dic setObject:baseInfoTitle forKey:@"baseInfoTitle"];
    
    NSArray *baseInfoContent =  @[
                                  model.fd_industryCategoryName == nil?@"暂无":[NSString stringWithFormat:@"%@",model.fd_industryCategoryName],
                                  model.fd_regionalLocationCategoryName == nil?@"暂无":[NSString stringWithFormat:@"%@",model.fd_regionalLocationCategoryName],
                                  model.fd_areaCategoryName == nil?@"暂无":[NSString stringWithFormat:@"%@",model.fd_areaCategoryName],
                                  model.fd_cooperationPeriodCategoryName == nil?@"暂无":[NSString stringWithFormat:@"%@",model.fd_cooperationPeriodCategoryName],
                                  model.fd_shopModelCategoryName == nil ?@"暂无":[NSString stringWithFormat:@"%@",model.fd_shopModelCategoryName],
                                  model.fd_brandPositioningCategoryName == nil? @"暂无":[NSString stringWithFormat:@"%@",model.fd_brandPositioningCategoryName],
                                  model.fd_companyName == nil ?@"暂无":[NSString stringWithFormat:@"%@",model.fd_companyName],
                                  model.fd_expandingRegion == nil?@"暂无":[NSString stringWithFormat:@"%@",model.fd_expandingRegion],
                                  model.fd_propertyTypeCategoryName == nil?@"暂无":[NSString stringWithFormat:@"%@",model.fd_propertyTypeCategoryName],
                                  model.fd_propertyUsageCategoryName == nil?@"暂无":[NSString stringWithFormat:@"%@",model.fd_propertyUsageCategoryName]
                                  ];
    
    [dic setObject:baseInfoContent forKey:@"baseInfoContent"];
    
    
    NSArray *investmentAnalysisTitle = @[
                                         @"品牌名称",
                                         @"店铺名称",
                                         @"投资总金额",
                                         @"从筹备到运营周期",
                                         @"预计可盈利时间",
                                         @"店铺经营面积",
                                         @"预计客流量",
                                         @"人均消费",
                                         @"预计一季度营收额"
                                         ];
    
    [dic setObject:investmentAnalysisTitle forKey:@"investmentAnalysisTitle"];
    
    NSArray *investmentAnalysisContent =  @[
                                            model.fd_brandName == nil?@"暂无":[NSString stringWithFormat:@"%@",model.fd_brandName],
                                            model.fd_storeName == nil?@"暂无":[NSString stringWithFormat:@"%@",model.fd_storeName],
                                            model.fd_totalInvestmentAmount == nil?@"暂无":[NSString stringWithFormat:@"%@万元",model.fd_totalInvestmentAmount],
                                            model.fd_operatingCycle == nil?@"暂无":[NSString stringWithFormat:@"%@天",model.fd_operatingCycle],
                                            model.fd_profitCycle == nil ?@"暂无":[NSString stringWithFormat:@"%@天",model.fd_profitCycle],
                                            model.fd_businessArea == nil? @"暂无":[NSString stringWithFormat:@"%@m²",model.fd_businessArea],
                                            model.fd_traffic == nil ?@"暂无":[NSString stringWithFormat:@"%@人/天",model.fd_traffic],
                                            model.fd_averageConsumption == nil?@"暂无":[NSString stringWithFormat:@"%@元/天",model.fd_averageConsumption],
                                            model.fd_quarterRevenues == nil?@"暂无":[NSString stringWithFormat:@"%@万元",model.fd_quarterRevenues]
                                            ];
    
    [dic setObject:investmentAnalysisContent forKey:@"investmentAnalysisContent"];
    
    return dic;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 加载数据
    [self requestData];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 导航条
    [self setupNav];
}

#pragma mark - 设置导航条
- (void)setupNav{
    
    [self setNav:model.fd_brandName];
    
    // 导航条右
    UIButton *star = [UIButton buttonWithType:UIButtonTypeCustom];
    star.frame = CGRectMake(0, 0, 20, 20);
    [star setBackgroundImage:[UIImage imageNamed:@"收藏-图标"] forState:UIControlStateNormal];
    [star setBackgroundImage:[UIImage imageNamed:@"收藏星星"] forState:UIControlStateSelected];
    [star addTarget:self action:@selector(starClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 判断是否收藏
    if ([model.fd_isCollectioned integerValue]==1) {
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

#pragma mark - 设置内容
- (void)setupUI{
    
    // 底部滚动
    bg_scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:bg_scrollView];
    [bg_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 底部view， 用于计算scrollview高度
    UIView* contentView = UIView.new;
    [bg_scrollView addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bg_scrollView);
        make.width.equalTo(bg_scrollView);
    }];
    
    // 一些固定字段内容
    NSDictionary *dict = [self getBaseInfo];
    
    /*------------------------------ 顶部图+基本参数 ------------------------------*/
    
    UIImageView *_headImage = [[UIImageView alloc] init];
    _headImage.userInteractionEnabled = YES;
    _headImage.contentMode = UIViewContentModeScaleAspectFill;
    // 图片尺寸设定
    NSString *cutString = [NSString stringWithCurrentString:model.fd_defaultImage SizeWidth:viewWidth*2];
    [_headImage sd_setImageWithURL:[NSURL URLWithString:cutString] placeholderImage:[UIImage imageNamed:@"loading_b"]];
    UIImage *bgimg =  [UIImage imageWithData:UIImageJPEGRepresentation(_headImage.image, 1)];
    [_headImage setImage:[Tools_F blurryImage:bgimg withBlurLevel:0.2]];
    [contentView addSubview:_headImage];
    
    UIView *black = [[UIView alloc] init];
    black.backgroundColor = [UIColor blackColor];
    black.alpha = 0.3;
    
    [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_top);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 240));
    }];
    
    [_headImage addSubview:black];
    [black mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_headImage);
    }];
    
    if (![model.fd_discountCoupons isEqual:[NSNull null]]) {
        
        UILabel *theDiscount = [[UILabel alloc] init];
        theDiscount.font = [UIFont systemFontOfSize:50];
        theDiscount.textAlignment = NSTextAlignmentCenter;
        theDiscount.textColor = [UIColor whiteColor];
        NSString *originalStr = [NSString stringWithFormat:@"%.1f折",
                                 [model.fd_discountCoupons[@"discount"] floatValue]];
        NSMutableAttributedString *paintStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
        [paintStr addAttribute:NSFontAttributeName value:midFont range:[originalStr rangeOfString:@"折"]];
        theDiscount.attributedText = paintStr;
        
        UILabel *theTicket = [[UILabel alloc] init];
        theTicket.font = midFont;
        theTicket.textAlignment = NSTextAlignmentCenter;
        theTicket.text = @"折扣券";
        theTicket.textColor = [UIColor whiteColor];
        
        UILabel *theDiscountDetail = [[UILabel alloc] init];
        theDiscountDetail.font = midFont;
        theDiscountDetail.textAlignment = NSTextAlignmentCenter;
        theDiscountDetail.text = [NSString stringWithFormat:@"%@ | %@人已领",
                                  model.fd_discountCoupons[@"maxPreferentialStr"],
                                  model.fd_discountCoupons[@"userGetQty"]];
        theDiscountDetail.textColor = lgrayColor;
        
        UIButton *takeItNow = [UIButton buttonWithType:UIButtonTypeCustom];
        takeItNow.backgroundColor = [SDDColor colorWithHexString:@"#008fec"];
        
        if ([model.fd_discountCoupons[@"isApply"] integerValue] == 1){
            
            [takeItNow setTitle:@"已领取" forState:UIControlStateNormal];
        }
        else {
            
            [takeItNow setTitle:@"立即领取" forState:UIControlStateNormal];
        }
        
        [takeItNow addTarget:self action:@selector(takeItNow:) forControlEvents:UIControlEventTouchUpInside];
        [Tools_F setViewlayer:takeItNow cornerRadius:20 borderWidth:0 borderColor:nil];
        
        [_headImage addSubview:theDiscount];
        [theDiscount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headImage.mas_top).offset(40);
            make.centerX.equalTo(_headImage);
            make.size.mas_equalTo(CGSizeMake(viewWidth, 50));
        }];
        
        [_headImage addSubview:theTicket];
        [theTicket mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(theDiscount.mas_bottom).offset(12);
            make.centerX.equalTo(_headImage);
            make.size.mas_equalTo(CGSizeMake(viewWidth, 13));
        }];
        
        [_headImage addSubview:theDiscountDetail];
        [theDiscountDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(theTicket.mas_bottom).offset(12);
            make.centerX.equalTo(_headImage);
            make.size.mas_equalTo(CGSizeMake(viewWidth, 13));
        }];
        
        [_headImage addSubview:takeItNow];
        [takeItNow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(theDiscountDetail.mas_bottom).offset(18);
            make.centerX.equalTo(_headImage);
            make.size.mas_equalTo(CGSizeMake(viewWidth-10, 40));
        }];
    }
    
    /*------------------------------ 基本参数 ------------------------------*/
    
    
    UILabel *franchiseesName = [[UILabel alloc] init];
    franchiseesName.font = largeFont;
    franchiseesName.text = model.fd_storeName;
    [contentView addSubview:franchiseesName];
    
    [franchiseesName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImage.mas_bottom).with.offset(10);
        make.left.equalTo(contentView.mas_left).with.offset(8);
        make.width.equalTo(contentView.mas_width).with.offset(-16);
    }];
    
    UIView *lastView;
    
    NSArray *titleArr = @[[NSString stringWithFormat:@"投资金额%@",model.fd_investmentAmountCategoryName],
                          [NSString stringWithFormat:@"%@人已关注",model.fd_collectionQty]];
    NSArray *iconArr = @[@"join_detail-pages_icon_investment-amount",
                         @"join_detail-pages_icon_attention"];
    for (int i=0; i<[titleArr count]; i++) {
        
        UIImageView *logo = [[UIImageView alloc] init];
        logo.image = [UIImage imageNamed:iconArr[i]];
        [contentView addSubview:logo];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = midFont;
        label.textColor = lgrayColor;
        label.text = titleArr[i];
        [contentView addSubview:label];
        
        [logo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastView? lastView.mas_bottom:franchiseesName.mas_bottom).with.offset(5);
            make.left.equalTo(contentView.mas_left).with.offset(8);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(logo.mas_top);
            make.left.equalTo(logo.mas_right).with.offset(7);
            make.right.equalTo(contentView.mas_right).with.offset(-8);
            make.height.equalTo(logo.mas_height);
        }];
        
        lastView = logo;
    }
    
    UIButton *allImage = [UIButton buttonWithType:UIButtonTypeCustom];
    // 图片尺寸设定
    [allImage sd_setImageWithURL:[NSURL URLWithString:cutString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading_b"]];
    allImage.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [allImage addTarget:self action:@selector(topImageTap:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imgIcon = [[UIImageView alloc] init];
    imgIcon.image = [UIImage imageNamed:@"图片-图标"];
    
    UILabel *_imageCounts = [[UILabel alloc] init];
    _imageCounts.textColor = [UIColor whiteColor];
    _imageCounts.font = midFont;
    _imageCounts.text = [NSString stringWithFormat:@"共%d张",[model.fd_imageList[@"brandVIUrls"] count]+
                         [model.fd_imageList[@"exhibitionUrls"] count]+
                         [model.fd_imageList[@"panorama360Urls"] count]+
                         [model.fd_imageList[@"productUrls"] count]+
                         [model.fd_imageList[@"realMapUrls"] count]+
                         [model.fd_imageList[@"terminalUrls"] count]+
                         [model.fd_imageList[@"videoDefaultImages"] count]+
                         [model.fd_imageList[@"videoUrls"] count]];
    _imageCounts.textAlignment = NSTextAlignmentRight;
    
    [contentView addSubview:allImage];
    [allImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImage.mas_bottom).offset(17);
        make.right.equalTo(contentView.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(100, 80));
    }];
    
    [allImage addSubview:imgIcon];
    [imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(allImage).with.offset(-20);
        make.bottom.equalTo(allImage).with.offset(-5);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [allImage addSubview:_imageCounts];
    [_imageCounts mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(imgIcon.mas_left).with.offset(-5);
        make.bottom.equalTo(allImage).with.offset(-5);
        make.size.mas_equalTo(CGSizeMake(50, 15));
    }];
    
    /*------------------------------ 优惠说明 ------------------------------*/
    
    HouseDetailTitle *preferenceDescriptionTitle  = [[HouseDetailTitle alloc] init];
    preferenceDescriptionTitle.theTitle.text = @"优惠说明";
    preferenceDescriptionTitle.tag = 99;
    preferenceDescriptionTitle.userInteractionEnabled =YES;
    preferenceDescriptionTitle.titleType = haveArrowWithText;
    [contentView addSubview:preferenceDescriptionTitle];
    
    UITapGestureRecognizer *pdeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
    [preferenceDescriptionTitle addGestureRecognizer:pdeTap];
    
    UILabel *preferenceDescriptionContent = [[UILabel alloc] init];
    preferenceDescriptionContent.font = midFont;
    preferenceDescriptionContent.textColor = lgrayColor;
    [contentView addSubview:preferenceDescriptionContent];
    
    float preferenceDescriptionTitle_h = 0;
    float preferenceDescriptionContent_h = 0;
    
    if (model.fd_brandDescription!= nil) {
        preferenceDescriptionTitle_h = 46.f;
        preferenceDescriptionContent_h = 75.f;
        preferenceDescriptionContent.numberOfLines = 3;
        preferenceDescriptionContent.text = [NSString stringWithFormat:@"%@",model.fd_discountCoupons[@"preferentialDescription"]];
    }
    
    [preferenceDescriptionTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(allImage.mas_bottom).with.offset(17);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, preferenceDescriptionTitle_h));
    }];
    
    [preferenceDescriptionContent mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(preferenceDescriptionTitle.mas_bottom).with.offset(10);
        make.left.equalTo(contentView.mas_left).with.offset(8);
        make.right.equalTo(contentView.mas_right).with.offset(-8);
        make.height.mas_lessThanOrEqualTo(preferenceDescriptionContent_h);
    }];
    
    lastView = preferenceDescriptionContent;
    
    /*------------------------------ 最新动态 ------------------------------*/
    
    if (![model.fd_dynamicList isEqual:[NSNull null]] && [model.fd_dynamicList count]>0) {
        
        HouseDetailTitle *newestDynamicTitle  = [[HouseDetailTitle alloc] init];
        newestDynamicTitle.theTitle.text = @"最新动态";
        newestDynamicTitle.tag = 100;
        newestDynamicTitle.userInteractionEnabled =YES;
        newestDynamicTitle.titleType = haveArrowWithText;
        [contentView addSubview:newestDynamicTitle];
        
        UITapGestureRecognizer *ndTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
        [newestDynamicTitle addGestureRecognizer:ndTap];
        
        [newestDynamicTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(preferenceDescriptionContent.mas_bottom).with.offset(10);
            make.left.equalTo(contentView.mas_left);
            make.size.mas_equalTo(CGSizeMake(viewWidth, 46));
        }];
        
        lastView = nil;
        for (int i=0; i<[model.fd_dynamicList count]; i++) {
            
            if (i>1) {      // 最多显示两条
                break;
            }
            else {
                
                JoinDynamic *newestDynamicContent = [[JoinDynamic alloc] init];
                newestDynamicContent.dynamicTitle.text = model.fd_dynamicList[i][@"title"];
                newestDynamicContent.dynamicContent.text = model.fd_dynamicList[i][@"description"];
                
                [contentView addSubview:newestDynamicContent];
                
                [newestDynamicContent mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lastView? lastView.mas_bottom:newestDynamicTitle.mas_bottom);
                    make.left.equalTo(contentView.mas_left);
                    make.width.equalTo(contentView.mas_width);
                    make.height.lessThanOrEqualTo(@75);
                }];
                
                lastView = newestDynamicContent;
                if (i==0) {
                    UIView *cutoff = [[UIView alloc] init];
                    cutoff.backgroundColor = bgColor;
                    [contentView addSubview:cutoff];
                    
                    [cutoff mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(lastView.mas_bottom);
                        make.left.equalTo(contentView.mas_left);
                        make.width.equalTo(contentView.mas_width);
                        make.height.equalTo(@1);
                    }];
                    lastView = cutoff;
                }
            }
        }
    }
    
    /*------------------------------ 基本信息 ------------------------------*/
    
    HouseDetailTitle *houseParaTitle  = [[HouseDetailTitle alloc] init];
    houseParaTitle.theTitle.text = @"基本信息";
    houseParaTitle.tag = 101;
    houseParaTitle.userInteractionEnabled =YES;
    [contentView addSubview:houseParaTitle];
    
    UITapGestureRecognizer *hpTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
    [houseParaTitle addGestureRecognizer:hpTap];
    
    [houseParaTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        //        [lastView isKindOfClass:[UIImageView class]]?
        //        make.top.equalTo(allImage.mas_bottom).with.offset(17):
        make.top.equalTo(lastView.mas_bottom).with.offset(10);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 46));
    }];
    
    lastView = nil;
    for (int i=0; i<10; i++) {
        
        UILabel *label = [[UILabel alloc] init];
        label.font = midFont;
        label.textColor = lgrayColor;
        label.text = [NSString stringWithFormat:@"%@: %@",dict[@"baseInfoTitle"][i],dict[@"baseInfoContent"][i]];
        
        [contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(lastView? lastView.mas_bottom:houseParaTitle.mas_bottom).with.offset(8);
            make.left.equalTo(contentView.mas_left).with.offset(8);
            make.right.equalTo(contentView.mas_right).with.offset(-8);
            make.height.mas_equalTo(@13);
        }];
        lastView = label;
    }
    
    /*------------------------------ 品牌简介 ------------------------------*/
    
    HouseDetailTitle *brandIntroductionTitle  = [[HouseDetailTitle alloc] init];
    brandIntroductionTitle.theTitle.text = @"品牌简介";
    brandIntroductionTitle.tag = 102;
    brandIntroductionTitle.userInteractionEnabled =YES;
    brandIntroductionTitle.titleType = haveArrowWithText;
    [contentView addSubview:brandIntroductionTitle];
    
    UITapGestureRecognizer *biTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
    [brandIntroductionTitle addGestureRecognizer:biTap];
    
    UILabel *brandIntroductionContent = [[UILabel alloc] init];
    brandIntroductionContent.font = midFont;
    brandIntroductionContent.textColor = lgrayColor;
    [contentView addSubview:brandIntroductionContent];
    
    float brandIntroductionTitle_h = 0;
    float brandIntroductionContent_h = 0;
    
    if (model.fd_brandDescription!= nil) {
        brandIntroductionTitle_h = 46.f;
        brandIntroductionContent_h = 85.f;
        brandIntroductionContent.numberOfLines = 4;
        brandIntroductionContent.text = [NSString stringWithFormat:@"%@",model.fd_brandDescription];
    }
    
    [brandIntroductionTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastView.mas_bottom).with.offset(8);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, brandIntroductionTitle_h));
    }];
    
    [brandIntroductionContent mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(brandIntroductionTitle.mas_bottom).with.offset(10);
        make.left.equalTo(contentView.mas_left).with.offset(8);
        make.right.equalTo(contentView.mas_right).with.offset(-8);
        make.height.mas_lessThanOrEqualTo(brandIntroductionContent_h);
    }];
    
    /*------------------------------ 终端展示 ------------------------------*/
    
    HouseDetailTitle *terminalShowTitle  = [[HouseDetailTitle alloc] init];
    terminalShowTitle.theTitle.text = @"终端展示";
    terminalShowTitle.tag = 103;
    terminalShowTitle.userInteractionEnabled =YES;
    terminalShowTitle.titleType = haveArrowWithText;
    [contentView addSubview:terminalShowTitle];
    
    UITapGestureRecognizer *tsTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
    [terminalShowTitle addGestureRecognizer:tsTap];
    
    UIButton *terminalShowContent = [UIButton buttonWithType:UIButtonTypeCustom];
    terminalShowContent.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [contentView addSubview:terminalShowContent];
    
    float terminalShowTitle_h = 0;
    float terminalShowContent_h = 0;
    
    if (![model.fd_imageList[@"terminalUrls"] isEqual:[NSNull null]]) {
        if ([model.fd_imageList[@"terminalUrls"] count]>0) {
            
            terminalShowTitle_h = 46;
            terminalShowContent_h = 175;
            
            // 图片尺寸设定
            cutString = [NSString stringWithCurrentString:model.fd_imageList[@"terminalUrls"][0] SizeWidth:viewWidth*2];
            //    [_headImage addTarget:self action:@selector(topImageTap:) forControlEvents:UIControlEventTouchUpInside];
            [terminalShowContent sd_setImageWithURL:[NSURL URLWithString:cutString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading_b"]];
        }
    }
    
    [terminalShowTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(brandIntroductionContent.mas_bottom).with.offset(8);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, terminalShowTitle_h));
    }];
    
    [terminalShowContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(terminalShowTitle.mas_bottom);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, terminalShowContent_h));
    }];
    
    /*------------------------------ 产品展示 ------------------------------*/
    
    HouseDetailTitle *productShowTitle  = [[HouseDetailTitle alloc] init];
    productShowTitle.theTitle.text = @"产品展示";
    productShowTitle.tag = 104;
    productShowTitle.userInteractionEnabled =YES;
    productShowTitle.titleType = haveArrowWithText;
    [contentView addSubview:productShowTitle];
    
    UITapGestureRecognizer *psTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
    [productShowTitle addGestureRecognizer:psTap];
    
    UIButton *productShowContent = [UIButton buttonWithType:UIButtonTypeCustom];
    productShowContent.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [contentView addSubview:productShowContent];
    
    float productShowTitle_h = 0;
    float productShowContent_h = 0;
    
    if (![model.fd_imageList[@"productUrls"] isEqual:[NSNull null]]) {
        if ([model.fd_imageList[@"productUrls"] count]>0) {
            
            productShowTitle_h = 46;
            productShowContent_h = 175;
            
            // 图片尺寸设定
            cutString = [NSString stringWithCurrentString:model.fd_imageList[@"productUrls"][0] SizeWidth:viewWidth*2];
            [productShowContent sd_setImageWithURL:[NSURL URLWithString:cutString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading_b"]];
            //    [_headImage addTarget:self action:@selector(topImageTap:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    [productShowTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(terminalShowContent.mas_bottom);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, productShowTitle_h));
    }];
    
    [productShowContent  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(productShowTitle.mas_bottom);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, productShowContent_h));
    }];
    
    /*------------------------------ 物业要求 ------------------------------*/
    
    HouseDetailTitle *propertyDescriptionTitle  = [[HouseDetailTitle alloc] init];
    propertyDescriptionTitle.theTitle.text = @"物业要求";
    propertyDescriptionTitle.tag = 105;
    propertyDescriptionTitle.userInteractionEnabled =YES;
    propertyDescriptionTitle.titleType = haveArrowWithText;
    [contentView addSubview:propertyDescriptionTitle];
    
    UITapGestureRecognizer *pdTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
    [propertyDescriptionTitle addGestureRecognizer:pdTap];
    
    UILabel *propertyDescriptionContent = [[UILabel alloc] init];
    propertyDescriptionContent.font = midFont;
    propertyDescriptionContent.textColor = lgrayColor;
    [contentView addSubview:propertyDescriptionContent];
    
    float propertyDescriptionTitle_h = 0;
    float propertyDescriptionContent_h = 0;
    
    if (model.fd_brandDescription!= nil) {
        propertyDescriptionTitle_h = 46.f;
        propertyDescriptionContent_h = 85.f;
        propertyDescriptionContent.numberOfLines = 4;
        propertyDescriptionContent.text = [NSString stringWithFormat:@"%@",model.fd_propertyDescription];
    }
    
    [propertyDescriptionTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(productShowContent.mas_bottom);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, propertyDescriptionTitle_h));
    }];
    
    [propertyDescriptionContent mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(propertyDescriptionTitle.mas_bottom).with.offset(10);
        make.left.equalTo(contentView.mas_left).with.offset(8);
        make.right.equalTo(contentView.mas_right).with.offset(-8);
        make.height.mas_lessThanOrEqualTo(propertyDescriptionContent_h);
    }];
    
    /*------------------------------ 门店分布 ------------------------------*/
    
    HouseDetailTitle *regionListTitle  = [[HouseDetailTitle alloc] init];
    regionListTitle.theTitle.text = [NSString stringWithFormat:@"门店分布(%@)",model.fd_storeQty];
    regionListTitle.tag = 106;
    regionListTitle.userInteractionEnabled =YES;
    regionListTitle.titleType = haveArrowWithText;
    [contentView addSubview:regionListTitle];
    
    UITapGestureRecognizer *rlTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
    [regionListTitle addGestureRecognizer:rlTap];
    
    UIView *regionListContent = [[UIView alloc] init];
    regionListContent.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:regionListContent];
    
    float regionListTitle_h = 0;
    float regionListContent_h = 0;
    
    if (![model.fd_regionList isEqual:[NSNull null]]) {
        for (int i=0; i<[model.fd_regionList count]; i++) {
            
            regionListTitle_h = 46.f;
            regionListContent_h = 45.f;
            if (i>3) {
                regionListContent_h = 80.f;
            }
            else if (i>7) {
                break;
            }
            
            UILabel *label = [[UILabel alloc] init];
            label.frame = CGRectMake(10 + ((viewWidth-50)/4+10)*(i%4), 10+35*(i/4), (viewWidth-50)/4, 25);
            label.font = midFont;
            label.textColor = lgrayColor;
            label.text = [NSString stringWithFormat:@"%@",model.fd_regionList[i][@"regionName"]];
            label.textAlignment = NSTextAlignmentCenter;
            [Tools_F setViewlayer:label cornerRadius:0 borderWidth:1 borderColor:bgColor];
            [regionListContent addSubview:label];
        }
    }
    
    [regionListTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(propertyDescriptionContent.mas_bottom).with.offset(8);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, regionListTitle_h));
    }];
    
    [regionListContent mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(regionListTitle.mas_bottom);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, regionListContent_h));
    }];
    
    /*------------------------------ 投资分析 ------------------------------*/
    
    HouseDetailTitle *investmentAnalysisTitle  = [[HouseDetailTitle alloc] init];
    investmentAnalysisTitle.theTitle.text = @"投资分析";
    investmentAnalysisTitle.tag = 107;
    investmentAnalysisTitle.userInteractionEnabled =YES;
    investmentAnalysisTitle.titleType = haveArrowWithText;
    [contentView addSubview:investmentAnalysisTitle];
    
    UITapGestureRecognizer *iaTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
    [investmentAnalysisTitle addGestureRecognizer:iaTap];
    
    [investmentAnalysisTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(regionListContent.mas_bottom);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 46));
    }];
    
    lastView = nil;
    
    for (int i=0; i<9; i++) {
        
        UILabel *label = [[UILabel alloc] init];
        label.font = midFont;
        label.textColor = lgrayColor;
        label.text = [NSString stringWithFormat:@"%@: %@",dict[@"investmentAnalysisTitle"][i],dict[@"investmentAnalysisContent"][i]];
        
        [contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(lastView? lastView.mas_bottom:investmentAnalysisTitle.mas_bottom).with.offset(8);
            make.left.equalTo(contentView.mas_left).with.offset(8);
            make.right.equalTo(contentView.mas_right).with.offset(-8);
            make.height.mas_equalTo(@13);
        }];
        lastView = label;
    }
    
    /*------------------------------ 加盟优势 ------------------------------*/
    
    HouseDetailTitle *joinAdvantageTitle  = [[HouseDetailTitle alloc] init];
    joinAdvantageTitle.theTitle.text = @"加盟优势";
    joinAdvantageTitle.tag = 108;
    joinAdvantageTitle.userInteractionEnabled =YES;
    joinAdvantageTitle.titleType = haveArrowWithText;
    [contentView addSubview:joinAdvantageTitle];
    
    UITapGestureRecognizer *jaTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
    [joinAdvantageTitle addGestureRecognizer:jaTap];
    
    UILabel *joinAdvantageContent = [[UILabel alloc] init];
    joinAdvantageContent.font = midFont;
    joinAdvantageContent.textColor = lgrayColor;
    [contentView addSubview:joinAdvantageContent];
    
    float joinAdvantageTitle_h = 0;
    float joinAdvantageContent_h = 0;
    
    if (model.fd_brandDescription!= nil) {
        joinAdvantageTitle_h = 46.f;
        joinAdvantageContent_h = 23.f;
        joinAdvantageContent.numberOfLines = 0;
        joinAdvantageContent.text = [NSString stringWithFormat:@"%@",model.fd_joinAdvantage];
    }
    
    [joinAdvantageTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastView.mas_bottom).with.offset(8);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, joinAdvantageTitle_h));
    }];
    
    [joinAdvantageContent mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(joinAdvantageTitle.mas_bottom).with.offset(10);
        make.left.equalTo(contentView.mas_left).with.offset(8);
        make.right.equalTo(contentView.mas_right).with.offset(-8);
        make.height.mas_greaterThanOrEqualTo(joinAdvantageContent_h);
    }];
    
    /*------------------------------ 相关推荐 ------------------------------*/
    
    HouseDetailTitle *anyRecommendTitle  = [[HouseDetailTitle alloc] init];
    anyRecommendTitle.theTitle.text = @"相关推荐";
    anyRecommendTitle.tag = 109;
    anyRecommendTitle.userInteractionEnabled =YES;
    [contentView addSubview:anyRecommendTitle];
    
    UITapGestureRecognizer *arTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
    [anyRecommendTitle addGestureRecognizer:arTap];
    
    HouseRecommend *anyRecommendContent = [[HouseRecommend alloc] init];
    [contentView addSubview:anyRecommendContent];
    
    float anyRecommendTitle_h = 0;
    float anyRecommendContent_h = 0;
    
    if (![model.fd_recommendList isEqual:[NSNull null]]) {
        
        for (int i=0; i<[model.fd_recommendList count]; i++) {
            
            NSDictionary *tempDic = model.fd_recommendList[i];
            
            JoinRecommendButton *jrButton = [[JoinRecommendButton alloc] initWithFrame: CGRectMake(i*(141), 0, 141, 165)];
            jrButton.tag = 1000+i;
            // 图片尺寸设定
            cutString = [NSString stringWithCurrentString:tempDic[@"defaultImage"] SizeWidth:viewWidth*2];
            [jrButton.imgView sd_setImageWithURL:[NSURL URLWithString:cutString] placeholderImage:[UIImage imageNamed:@"loading_l"]];
            jrButton.brankName.text = [NSString stringWithFormat:@"品牌: %@",tempDic[@"brandName"]];
            jrButton.investmentAmountCategoryName.text = [NSString stringWithFormat:@"投资总额度: %@",tempDic[@"investmentAmountCategoryName"]];
            jrButton.industryCategoryName.text = [NSString stringWithFormat:@"行业类别: %@",tempDic[@"industryCategoryName"]];
            jrButton.storeAmount.text = [NSString stringWithFormat:@"门店数量: %@",tempDic[@"storeAmount"]];
            [jrButton addTarget:self action:@selector(anyRecommend:) forControlEvents:UIControlEventTouchUpInside];
            
            [anyRecommendContent.houseRecommendScrollView addSubview:jrButton];
            
            anyRecommendContent.houseRecommendScrollView.frame = CGRectMake(0, 0, viewWidth, 165);
            anyRecommendContent.houseRecommendScrollView.contentSize = CGSizeMake(141+i*(141), 165);
            
            anyRecommendTitle_h = 46;
            anyRecommendContent_h = 165;
        }
    }
    
    [anyRecommendTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(joinAdvantageContent.mas_bottom).with.offset(10);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, anyRecommendTitle_h));
    }];
    
    [anyRecommendContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(anyRecommendTitle.mas_bottom);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, anyRecommendContent_h));
    }];
    
    /*------------------------------ 联系方式 ------------------------------*/
    
    HouseDetailTitle *contactWayTitle  = [[HouseDetailTitle alloc] init];
    contactWayTitle.theTitle.text = @"联系方式";
    contactWayTitle.tag = 110;
    contactWayTitle.userInteractionEnabled =YES;
    contactWayTitle.titleType = haveArrowWithText;
    [contentView addSubview:contactWayTitle];
    
    UITapGestureRecognizer *cwTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
    [contactWayTitle addGestureRecognizer:cwTap];
    
    JoinContactWay *contactWayContent = [[JoinContactWay alloc] init];
    
    contactWayContent.peopleName.text = model.fd_brandContacts == nil?
    @"暂无":[NSString stringWithFormat:@"%@",model.fd_brandContacts];
    contactWayContent.peoplePosition.text = model.fd_jobTitle == nil?
    @"暂无":[NSString stringWithFormat:@"%@",model.fd_jobTitle];
    contactWayContent.peopleRegion.text = model.fd_precinct == nil?
    @"暂无":[NSString stringWithFormat:@"%@",model.fd_precinct];
    contactWayContent.peopleTel.text = model.fd_tel == nil?
    @"暂无":[NSString stringWithFormat:@"%@",@"***-********"];
    NSMutableString *phongStr = [[NSMutableString alloc] initWithString:model.fd_phone == nil?
                                 @"暂无":[NSString stringWithFormat:@"%@",model.fd_phone]];
    phongStr.length == 11?
    [phongStr replaceCharactersInRange:NSMakeRange(3, 7) withString:@"*******"]:phongStr;
    contactWayContent.peopleMobileNum.text = phongStr;
    contactWayContent.peopleEmail.text = model.fd_email == nil?
    @"暂无":@"**@**.com";
    contactWayContent.peopleAddress.text = model.fd_address == nil?
    @"暂无":@"********";
    //    [NSString stringWithFormat:@"%@",model.fd_address]
    //    [model.fd_tel stringByReplacingCharactersInRange:NSMakeRange(6, 10) withString:@"*"]
    [contentView addSubview:contactWayContent];
    
    [contactWayTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(anyRecommendContent.mas_bottom).with.offset(8);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 46));
    }];
    
    [contactWayContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contactWayTitle.mas_bottom);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 150));
    }];
    
    /*------------------------------ 加盟点评 ------------------------------*/
    
    HouseDetailTitle *commendTitle  = [[HouseDetailTitle alloc] init];
    commendTitle.theTitle.text = @"加盟点评";
    commendTitle.tag = 111;
    commendTitle.userInteractionEnabled =YES;
    commendTitle.titleType = haveArrowWithText;
    [contentView addSubview:commendTitle];
    
    UITapGestureRecognizer *cTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
    [commendTitle addGestureRecognizer:cTap];
    
    JoinCommend *commendContent = [[JoinCommend alloc] init];
    commendContent.theStar.hidden = YES;
    [contentView addSubview:commendContent];
    
    float commentTitle_h = 46.f;
    float commentContent_h = 0;
    
    if (![model.fd_commentList isEqual:[NSNull null]]) {
        
        if ([model.fd_commentList count]>0) {
            
            NSDictionary *tempD = model.fd_commentList[0];
            
            [commendContent.theAvatar sd_setImageWithURL:[NSURL URLWithString:tempD[@"icon"]]];
            commendContent.theName.text = tempD[@"realName"];
            commendContent.theStar.hidden = NO;
            commendContent.theStar.scorePercent = [tempD[@"starScore"] floatValue]/5.0;
            
            switch ([tempD[@"starScore"] integerValue]) {
                case 1:
                {
                    commendContent.theAppraise.text = @"差评";
                }
                    break;
                case 2:
                {
                    commendContent.theAppraise.text = @"一般";
                }
                    break;
                case 3:
                {
                    commendContent.theAppraise.text = @"满意";
                }
                    break;
                case 4:
                {
                    commendContent.theAppraise.text = @"非常满意";
                }
                    break;
                case 5:
                {
                    commendContent.theAppraise.text = @"无可挑剔";
                }
                    break;
                default:{
                    commendContent.theAppraise.text = @"";
                }
                    break;
            }
            commendContent.theCommend.text = tempD[@"description"];
            commendContent.theTime.text = [NSString stringWithFormat:@"%@",[Tools_F timeTransform:[tempD[@"addTime"] intValue] time:seconds]];
            
            [commendContent.theLike setTitle:[NSString stringWithFormat:@"%@",tempD[@"likeTotal"]] forState:UIControlStateNormal];
            commendContent.theLike.selected = [tempD[@"isLike"] intValue] == 1? YES:NO;
            commendContent.theLike.tag = [tempD[@"commentId"] intValue]+100;
            [commendContent.theLike addTarget:self action:@selector(clickLike:) forControlEvents:UIControlEventTouchUpInside];
            
            commentTitle_h = 46.f;
            commentContent_h = 118.f;
        }
    }
    
    [commendTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contactWayContent.mas_bottom);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, commentTitle_h));
    }];
    
    [commendContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commendTitle.mas_bottom);
        make.left.equalTo(contentView.mas_left);
        make.right.equalTo(contentView.mas_right);
        make.height.equalTo(@(commentContent_h));
    }];
    
    // 自动scrollview高度
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(commendContent.mas_bottom).with.offset(40);
    }];
    
    /*------------------------------ 我要加盟 ------------------------------*/
    
    bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIView *division = [[UIView alloc] init];
    division.backgroundColor = bgColor;
    [bottomView addSubview:division];
    
    UIButton *contact = [UIButton buttonWithType:UIButtonTypeCustom];
    [contact setImage:[UIImage imageNamed:@"join_detail-pages_icon_wechat"] forState:UIControlStateNormal];
    [contact addTarget:self action:@selector(contact:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:contact];
    
    UIButton *takeItNow2 = [UIButton buttonWithType:UIButtonTypeCustom];
    takeItNow2.backgroundColor = [SDDColor colorWithHexString:@"#008fec"];
    [takeItNow2 setTitle:@"立即领取" forState:UIControlStateNormal];
    [takeItNow2 addTarget:self action:@selector(takeItNow:) forControlEvents:UIControlEventTouchUpInside];
    [Tools_F setViewlayer:takeItNow2 cornerRadius:15 borderWidth:0 borderColor:nil];
    [bottomView addSubview:takeItNow2];
    
    UIButton *call = [UIButton buttonWithType:UIButtonTypeCustom];
    [call setImage:[UIImage imageNamed:@"join_detail-pages_icon_phone"] forState:UIControlStateNormal];
    [call addTarget:self action:@selector(takePhone:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:call];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 40));
    }];
    
    [division mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top);
        make.left.equalTo(bottomView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 1));
    }];
    
    [contact mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(division.mas_bottom).with.offset(6);
        make.left.equalTo(bottomView.mas_left).with.offset(30);
        make.bottom.equalTo(bottomView.mas_bottom).with.offset(-6);
        make.width.equalTo(contact.mas_height);
    }];
    
    [takeItNow2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(bottomView.center);
        make.size.mas_equalTo(CGSizeMake(110, 30));
    }];
    
    [call mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(division.mas_bottom).with.offset(6);
        make.right.equalTo(bottomView.mas_right).with.offset(-30);
        make.bottom.equalTo(bottomView.mas_bottom).with.offset(-6);
        make.width.equalTo(contact.mas_height);
    }];
}

#pragma mark - 顶部图片点击
- (void)topImageTap:(id)sender{
    
    FullScreenViewController *fsVC = [[FullScreenViewController alloc] init];
    fsVC.imagesFrom = 1;
    fsVC.paramID = model.fd_brandId;
    fsVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UINavigationController *nav_houseLookingVC = [[UINavigationController alloc]initWithRootViewController:fsVC];
    
    [self presentViewController:nav_houseLookingVC animated:YES completion:nil];
}

#pragma mark - 标题点击
- (void)titleTap:(UIGestureRecognizer *)tap{
    
    UILabel *label = (UILabel *)tap.view;
    NSInteger titleTag = (NSInteger)label.tag;
    NSLog(@"标题点击%ld",(long)titleTag);
    switch (titleTag) {
        case 100:
        {
            // 最新动态
            DynamicListViewController *dylVC = [[DynamicListViewController alloc] init];
            dylVC.brandId = model.fd_brandId;
            [self.navigationController pushViewController:dylVC animated:YES];
        }
            break;
        case 101:
        {
            
        }
            break;
        case 102:
        {
            // 品牌简介
            BranksIntroductionViewController *biVC = [[BranksIntroductionViewController alloc] init];
            biVC.introductionContent = [NSString stringWithFormat:@"%@",model.fd_brandDescription];
            [self.navigationController pushViewController:biVC animated:YES];
        }
            break;
        case 103:
        {
            // 终端展示
            FullScreenViewController *fsVC = [[FullScreenViewController alloc] init];
            fsVC.imagesFrom = 1;
            fsVC.paramID = model.fd_brandId;
            fsVC.jumpColumn = @"终端展示";
            fsVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            UINavigationController *nav_houseLookingVC = [[UINavigationController alloc]initWithRootViewController:fsVC];
            
            [self presentViewController:nav_houseLookingVC animated:YES completion:nil];
        }
            break;
        case 104:
        {
            // 产品展示
            FullScreenViewController *fsVC = [[FullScreenViewController alloc] init];
            fsVC.imagesFrom = 1;
            fsVC.paramID = model.fd_brandId;
            fsVC.jumpColumn = @"产品展示";
            fsVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            UINavigationController *nav_houseLookingVC = [[UINavigationController alloc]initWithRootViewController:fsVC];
            
            [self presentViewController:nav_houseLookingVC animated:YES completion:nil];
        }
            break;
        case 105:
        {
            // 物业要求
            PropertyDescriptionViewController *pdVC = [[PropertyDescriptionViewController alloc] init];
            pdVC.propertyDescriptionContent = [NSString stringWithFormat:@"%@",model.fd_propertyDescription];
            [self.navigationController pushViewController:pdVC animated:YES];
        }
            break;
        case 106:
        {
            // 门店分布
            RegionListViewController *rlVC = [[RegionListViewController alloc] init];
            rlVC.brandId = model.fd_brandId;
            [self.navigationController pushViewController:rlVC animated:YES];
        }
            break;
        case 107:
        {
            NSDictionary *dict = [self getBaseInfo];
            
            // 投资分析
            InvestmentAnalysisViewController *iaVC = [[InvestmentAnalysisViewController alloc] init];
            iaVC.investmentAnalysisTitle = dict[@"investmentAnalysisTitle"];
            iaVC.investmentAnalysisContent = dict[@"investmentAnalysisContent"];
            [self.navigationController pushViewController:iaVC animated:YES];
        }
            break;
        case 108:
        {
            // 加盟优势
            JoinAdvantageViewController *jaVC = [[JoinAdvantageViewController alloc] init];
            jaVC.joinAdvantageContent = [NSString stringWithFormat:@"%@",model.fd_joinAdvantage];
            [self.navigationController pushViewController:jaVC animated:YES];
        }
            break;
        case 109:
        {
            
        }
            break;
        case 110:
        {
            if (![GlobalController isLogin]) {
                
                LoginController *loginVC = [[LoginController alloc] init];
                [self.navigationController pushViewController:loginVC animated:YES];
            }
            else {
                
                // 联系方式
                JoinContactViewController *jcVC = [[JoinContactViewController alloc] init];
                jcVC.brandId = model.fd_brandId;
                [self.navigationController pushViewController:jcVC animated:YES];
            }
        }
            break;
        case 111:
        {
            // 加盟点评
            SomeRecommandViewController *srVC = [[SomeRecommandViewController alloc] init];
            srVC.brandId = model.fd_brandId;
            [self.navigationController pushViewController:srVC animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 相关推荐
- (void)anyRecommend:(UIButton *)btn{
    
    NSInteger i = (NSInteger)btn.tag-1000;
    NSDictionary *tempDic = model.fd_recommendList[i];
    
    _brandId = tempDic[@"brandId"];
    [self requestData];
}

#pragma mark - 点赞/取消点赞
- (void)clickLike:(UIButton *)btn{
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else {
        
        NSNumber *commentID = [NSNumber numberWithInt:(int)btn.tag-100];
        
        NSDictionary *dic = @{@"commentId":commentID};
        NSString *str = btn.isSelected?
        @"/brand/deleteLike/comment.do":
        @"/brand/like/comment.do";
        [self addOrCancelLike:str param:dic button:btn];
    }
}

- (void)addOrCancelLike:(NSString *)url param:(NSDictionary *)dic button:(UIButton *)btn{
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:url params:dic success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        
        if ([JSON[@"status"] intValue] == 1) {
            
            [self showSuccessWithText:JSON[@"message"]];
            
            int i = [btn.titleLabel.text intValue];
            NSLog(@"%d",i);
            if ([url isEqualToString:@"/brand/deleteLike/comment.do"]) {
                [btn setTitle:[NSString stringWithFormat:@"%d",--i] forState:UIControlStateNormal];
            }
            else {
                [btn setTitle:[NSString stringWithFormat:@"%d",++i] forState:UIControlStateSelected];
            }
            NSLog(@"%d",i);
            btn.selected = !btn.selected;
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 收藏/取消收藏
- (void)starClick:(UIButton *)btn{
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else {
        
        NSDictionary *dic = @{@"brandId":_brandId};
        NSString *str = btn.isSelected?
        [SDD_MainURL stringByAppendingString:@"/brandCollection/deleteCollection.do"]:
        [SDD_MainURL stringByAppendingString:@"/brandCollection/addCollection.do"];
        [self addOrCancelFavorite:str param:dic button:btn];
    }
}

- (void)addOrCancelFavorite:(NSString *)url param:(NSDictionary *)dic button:(UIButton *)btn{
    
    [self.httpManager POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = responseObject;
        if ([dict[@"status"] intValue] == 1) {
            
            [self showSuccessWithText:dict[@"message"]];
            btn.selected = !btn.selected;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
}

#pragma mark - 底部3按钮 im、加盟、电话
- (void)contact:(UIButton *)btn{
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else {
        
        // 用户id
        NSString *userID = [NSString stringWithFormat:@"%@",model.fd_chatUser[@"userId"]];
        NSLog(@"对方id:%@",userID);
        
        // 发送顾问默认欢迎文本
        NSDictionary *param = @{@"consultantUserId":userID,@"type":@1,@"brandId":_brandId};
        NSString *urlString = [SDD_MainURL stringByAppendingString:@"/user/getIMDefaultWelcomeText.do"];              // 拼接主路径和请求内容成完整url
        [self sendRequest:param url:urlString];
        
        self.hidesBottomBarWhenPushed = YES;
        ChatViewController *cvc = [[ChatViewController alloc] initWithChatter:userID isGroup:FALSE];
        cvc.userName = model.fd_chatUser[@"chatName"];
        [self.navigationController pushViewController:cvc animated:true];
    }
}

- (void)takeItNow:(UIButton *)btn{
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else if ([model.fd_discountCoupons[@"isApply"] integerValue] == 1){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您已获取过该折扣券，请到我的折扣券查看" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        
        // 立即领取
        GetCouponViewController *gcVC = [[GetCouponViewController alloc] init];
        
        gcVC.brankName = model.fd_brandName;
        gcVC.discountCoupons = model.fd_discountCoupons;
        [self.navigationController pushViewController:gcVC animated:YES];
    }
}

- (void)takePhone:(UIButton *)btn{
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else {
        
        //联系客服
        UIWebView*callWebview =[[UIWebView alloc] init];
        
        // 过滤非数字
        NSCharacterSet *setToRemove = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]
                                       invertedSet];
        NSString *telNumber;
        if ([model.fd_tel400Extra isEqual:[NSNull null]]) {
            
            telNumber = [NSString stringWithFormat:@"tel:%@",
                         [[model.fd_tel400 componentsSeparatedByCharactersInSet:setToRemove]
                          componentsJoinedByString:@""]];
        }
        else {
            
            telNumber = [NSString stringWithFormat:@"tel:%@,,%@",
                         [[model.fd_tel400 componentsSeparatedByCharactersInSet:setToRemove]
                          componentsJoinedByString:@""],
                         model.fd_tel400Extra];
        }
        
        NSURL *telURL = [NSURL URLWithString:telNumber];
        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
        [self.view addSubview:callWebview];
    }
}

#pragma mark - 分享
- (void)GRshareBtn{
    
    [ShareHelper shareIn:self content:@"Hello" url:@"http://www.shangdodo.com"];
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

@end



