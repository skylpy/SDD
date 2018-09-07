//
//  NormalJoinMoreViewController.m
//  SDD
//  更多品牌详情（普通加盟）
//  Created by hua on 15/12/29.
//  Copyright (c) 2015年 jofly. All rights reserved.
//


#import "NewJoinDatailBrandViewController.h"
#import "FranchiseesDetailModel.h"
#import "ShareHelper.h"
#import "NSString+SDD.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "HouseEvaluation.h"
#import "ConsultantTableViewCell.h"
#import "EvalutaionTableViewCell.h"
#import "CWStarRateView.h"
#import "UIImageView+LBBlurredImage.h"
#import "JoinContactWay.h"
#import "FullScreenViewController.h"
#import "RecommendViewController.h"
#import "SomeRecommandViewController.h"
#import "JoinBottomBtn.h"
#import "ChatViewController.h"
#import "BranksIntroductionViewController.h"
#import "JoinDetailMoreViewController.h"
#import "RegionListViewController.h"
#import "InvestmentViewController.h"

#import "GetCouponViewController.h"
#import "IWantToJoinViewController.h"  //我要加盟
#import "NormalJoinMoreViewController.h" //更多品牌详情
#import "GroupRentViewController.h"
#import "HouseDetailTitle.h"
#import "HouseRecommend.h"
#import "JoinRecommendButton.h"

#import "DynamicListViewController.h"
#import "PropertyDescriptionViewController.h"
#import "InvestmentAnalysisViewController.h"
#import "JoinAdvantageViewController.h"
#import "AllPhotoViewController.h"

#import "NormalJoinMoreViewController.h"

#define NumberOfLines 3

@interface NormalJoinMoreViewController ()
{
    /*- data -*/
    
    FranchiseesDetailModel *model;                        // 模型
    
    /*- ui -*/
    
    // 星星
    CWStarRateView *rateView;
    
    UIScrollView *bg_scrollView;
    UIView *bottomView;
    
    NSDictionary * dictData;
    HouseEvaluation *evaluationContent;
    
    NSArray * comArray;
    
    UITableView *table;
    
    UIButton * receiveBtn;//顶部按钮
    
    UIView * view_b;
    
    UILabel *propertyDescriptionContent;  //物业要求内容
    UILabel *preferentialDalail;  //加盟条件内容
    UILabel *joinAdvantageContent;  //加盟优势内容
    
    UILabel * annualplanDalail; //加盟流程内容
}
@property (retain,nonatomic)NSMutableArray * totalArr;
@end

@implementation NormalJoinMoreViewController
-(void)viewWillAppear:(BOOL)animated
{
    [self requestData];
}
#pragma mark - 请求数据
- (void)requestData{
    
    [bg_scrollView removeFromSuperview];     // 移除原有视图
    [bottomView removeFromSuperview];
    
    // 请求参数
    NSDictionary *param = @{@"brandId":_brandId};
    
    [self showLoading:1];
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brand/detail.do" params:param success:^(id JSON) {
        
        NSLog(@"%@",JSON);
        NSDictionary *dict = JSON[@"data"];
        
        if (![dict isEqual:[NSNull null]]) {
            
            model = [FranchiseesDetailModel franchiseesDetailWithDict:dict];
            dictData = dict;
            
            comArray = dictData[@"comment"][@"commentList"];
            
            NSArray * imageList_xc = @[@"panorama360Urls",@"videoDefaultImages",@"realMapUrls",@"exhibitionUrls",@"brandVIUrls",@"terminalUrls",@"productUrls",@"videoUrls"];
            _totalArr = [[NSMutableArray alloc] init];
            for (int i = 0; i < imageList_xc.count; i ++) {
                
                NSArray * array = dict[@"imageList"][imageList_xc[i]];
                
                for (int j = 0; j < array.count; j ++) {
                    
                    [_totalArr addObject:array[j]];
                    
                }
            }
            
            [evaluationContent.evaluationTable reloadData];
            
            //            // 导航条
            [self setupNav];
            //            // ui
            [self setupUI];
            //            // 刷新数据并回滚到最上
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
    
    /*
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
    
    [dic setObject:investmentAnalysisContent forKey:@"investmentAnalysisContent"];*/
    
    NSArray *investmentAnalysisTitle = @[
                                         @"参考店铺",
                                         @"经营面积",
                                         @"所在楼层",
                                         @"客流量",
                                         @"投资金额",
                                         @"成交量",
                                         @"客单价",
                                         @"营业收入",
                                         @"营业成本",
                                         @"分摊折旧",
                                         @"毛利",
                                         @"年利润",
                                         @"回报周期",
                                         @"回报率",
                                         ];
    
    [dic setObject:investmentAnalysisTitle forKey:@"investmentAnalysisTitle"];
    
    NSArray *investmentAnalysisContent =  @[
                                            [model.referenceStore isKindOfClass:[NSNull class]]?@"暂无":[NSString stringWithFormat:@"%@",model.referenceStore],
                                            [model.businessArea  isKindOfClass:[NSNull class]]?@"暂无":[NSString stringWithFormat:@"%@m²",model.businessArea],
                                            [model.floor  isKindOfClass:[NSNull class]]?@"暂无":[NSString stringWithFormat:@"%@层",model.floor],
                                            [model.traffic isKindOfClass:[NSNull class]]?@"暂无":[NSString stringWithFormat:@"%@人/天",model.traffic],
                                            [model.totalInvestmentAmount isKindOfClass:[NSNull class]] ?@"暂无":[NSString stringWithFormat:@"%@万元",model.totalInvestmentAmount],
                                            [model.volume isKindOfClass:[NSNull class]]? @"暂无":[NSString stringWithFormat:@"%@单/月",model.volume],
                                            [model.averageConsumption isKindOfClass:[NSNull class]] ?@"暂无":[NSString stringWithFormat:@"%@元/人",model.averageConsumption],
                                            [model.revenue isKindOfClass:[NSNull class]]?@"暂无":[NSString stringWithFormat:@"%@元/月",model.revenue],
                                            [model.operatingCosts isKindOfClass:[NSNull class]]?@"暂无":[NSString stringWithFormat:@"%@元/月",model.operatingCosts],
                                            [model.depreciationShare isKindOfClass:[NSNull class]]?@"暂无":[NSString stringWithFormat:@"%@元/月",model.depreciationShare],
                                            [model.grossProfit isKindOfClass:[NSNull class]]?@"暂无":[NSString stringWithFormat:@"%@%s",model.grossProfit,"%"],
                                            [model.annualProfit isKindOfClass:[NSNull class]]?@"暂无":[NSString stringWithFormat:@"%@万/年",model.annualProfit],
                                            [model.paybackPeriod isKindOfClass:[NSNull class]]?@"暂无":[NSString stringWithFormat:@"%@个月",model.paybackPeriod],
                                            [model.responseRate isKindOfClass:[NSNull class]]?@"暂无":[NSString stringWithFormat:@"%@%s",model.responseRate,"%"],
                                            ];
    
    [dic setObject:investmentAnalysisContent forKey:@"investmentAnalysisContent"];
    
    return dic;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = bgColor;
    //[self requestData];
    [self setupNav];
}
#pragma mark - 设置内容
- (void)setupUI{
    
    NSDictionary * dicount = model.fd_discountCoupons;
    // 底部滚动
    bg_scrollView = [[UIScrollView alloc] init];
    bg_scrollView.backgroundColor = [UIColor whiteColor];
    //bg_scrollView.backgroundColor = bgColor;
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
//    
//    /*------------------------------ 顶部图+基本参数 ------------------------------*/
//    
//    
//    UIImageView *_headImage = [[UIImageView alloc] init];
//    _headImage.userInteractionEnabled = YES;
//    // 图片尺寸设定
    NSString *cutString = [NSString stringWithCurrentString:model.fd_defaultImage SizeWidth:viewWidth*2];
//
//    [_headImage sd_setImageWithURL:[NSURL URLWithString:cutString] placeholderImage:[UIImage imageNamed:@"loading_b"]];
//    
//    [contentView addSubview:_headImage];
//    
//    _headImage.userInteractionEnabled = YES;
//    _headImage.tag = 100;
//    //
//    
//    
//    //
//    
//    UILabel *_headImage_lable = [[UILabel alloc] init];
//    _headImage_lable.backgroundColor = [UIColor blackColor];
//    _headImage_lable.alpha = 0.7;
//    [_headImage addSubview:_headImage_lable];
//    
//    [_headImage_lable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(_headImage.mas_bottom).with.offset(0);
//        make.left.equalTo(contentView.mas_left).with.offset(0);
//        make.width.equalTo(contentView.mas_width).with.offset(0);
//        make.height.equalTo(@40);
//    }];
//    
//    UILabel *franchiseesName = [[UILabel alloc] init];
//    franchiseesName.font = largeFont;
//    franchiseesName.text = model.fd_storeName;
//    franchiseesName.textColor = [UIColor whiteColor];
//    [_headImage addSubview:franchiseesName];
//    
//    UILabel *maxPreferentialStr = [[UILabel alloc] init];
//    maxPreferentialStr.font = midFont;
//    maxPreferentialStr.textColor = [UIColor whiteColor];
//    
//    [_headImage addSubview:maxPreferentialStr];
//    
//    [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(contentView.mas_top);
//        make.left.equalTo(contentView.mas_left);
//        make.size.mas_equalTo(CGSizeMake(viewWidth, 200));
//    }];
//    
//    [franchiseesName mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(_headImage.mas_bottom).with.offset(-15);
//        make.left.equalTo(contentView.mas_left).with.offset(8);
//        make.width.equalTo(contentView.mas_width).with.offset(-16);
//    }];
//    [maxPreferentialStr mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(_headImage.mas_bottom).with.offset(0);
//        make.left.equalTo(contentView.mas_left).with.offset(8);
//        make.width.equalTo(contentView.mas_width).with.offset(-16);
//    }];
//    
//    
//    if (![model.fd_discountCoupons isEqual:[NSNull null]]) {
//        
//        maxPreferentialStr.text = model.fd_discountCoupons[@"maxPreferentialStr"];
//    }
//    
//    
//    UIView  * view_zxlq = [[UIView alloc] init];
//    [contentView addSubview:view_zxlq];
//    [view_zxlq mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_headImage.mas_bottom).with.offset(10);
//        make.right.equalTo(contentView.mas_right).with.offset(0);
//        make.size.mas_equalTo(CGSizeMake(viewWidth, 65));
//    }];
//    
//    receiveBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    [receiveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    
//    [receiveBtn setBackgroundImage:[Tools_F imageWithColor:tagsColor
//                                                      size:CGSizeMake(130, 35)]
//                          forState:UIControlStateNormal];
//    
//    [receiveBtn setBackgroundImage:[Tools_F imageWithColor:[SDDColor colorWithHexString:@"006699"]
//                                                      size:CGSizeMake(130, 35)]
//                          forState:UIControlStateHighlighted];
//    [receiveBtn addTarget:self action:@selector(receiveBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [Tools_F setViewlayer:receiveBtn cornerRadius:5 borderWidth:0 borderColor:nil];
//    [view_zxlq addSubview:receiveBtn];
//    [receiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(view_zxlq.mas_top).with.offset(0);
//        make.right.equalTo(view_zxlq.mas_right).with.offset(-10);
//        //make.centerX.equalTo(_headImage);
//        make.width.equalTo(@(130));
//        make.height.equalTo(@35);
//    }];
//    
//    if (![model.fd_discountCoupons isEqual:[NSNull null]]) {
//        
//        if ([model.fd_discountCoupons[@"isApply"] integerValue] == 1){
//            
//            [receiveBtn setTitle:@"我要加盟" forState:UIControlStateNormal];
//        }
//        else {
//            
//            [receiveBtn setTitle:@"立即领取" forState:UIControlStateNormal];
//        }
//    }else{
//        
//        [receiveBtn setTitle:@"暂不可加盟" forState:UIControlStateNormal];
//    }
//    
//    
//    UILabel * discoLabel = [[UILabel alloc] init];
//    discoLabel.textColor = tagsColor;
//    [view_zxlq addSubview:discoLabel];
//    [discoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(view_zxlq.mas_top).with.offset(0);
//        make.left.equalTo(view_zxlq.mas_left).with.offset(10);
//    }];
//    
//    UILabel * lineLabel = [[UILabel alloc] init];
//    lineLabel.backgroundColor = bgColor;
//    [view_zxlq addSubview:lineLabel];
//    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(receiveBtn.mas_bottom).with.offset(5);
//        make.width.equalTo(@(viewWidth));
//        make.height.equalTo(@1);
//    }];
//    
//    //投资额度
//    UILabel * Label_tzed = [[UILabel alloc] init];
//    Label_tzed.textColor = lgrayColor;
//    Label_tzed.font = midFont;
//    Label_tzed.text = [NSString stringWithFormat:@"投资额度%@",model.fd_investmentAmountCategoryName];
//    [view_zxlq addSubview:Label_tzed];
//    [Label_tzed mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(lineLabel.mas_top).with.offset(5);
//        make.left.equalTo(view_zxlq.mas_left).with.offset(10);
//        
//    }];
//    
//    //关注
//    UILabel * Label_gz = [[UILabel alloc] init];
//    Label_gz.textColor = lgrayColor;
//    Label_gz.font = midFont;
//    Label_gz.text = [NSString stringWithFormat:@"%@人已关注",model.fd_collectionQty];
//    Label_gz.textAlignment = NSTextAlignmentCenter;
//    [view_zxlq addSubview:Label_gz];
//    
//    
//    //领取
//    UILabel * Label_lq = [[UILabel alloc] init];
//    Label_lq.textColor = lgrayColor;
//    Label_lq.font = midFont;
//    Label_lq.text = [NSString stringWithFormat:@"%@人已领取",model.fd_joinedQty];
//    [view_zxlq addSubview:Label_lq];
//    
//    [Label_gz mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(lineLabel.mas_top).with.offset(5);
//        make.left.equalTo(Label_tzed.mas_right).with.offset(20);
//        //make.right.equalTo(Label_lq.mas_left).with.offset(10);
//    }];
//    
//    [Label_lq mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(lineLabel.mas_top).with.offset(5);
//        make.right.equalTo(view_zxlq.mas_right).with.offset(-10);
//        //make.left.equalTo(Label_gz.mas_right).with.offset(10);
//    }];
//    
//    UITapGestureRecognizer * tap_xc = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
//    [_headImage addGestureRecognizer:tap_xc];
//    
//    
//    UILabel * label_num = [[UILabel alloc] init];
//    //    label_num.backgroundColor = [UIColor blackColor];
//    //    label_num.alpha = 0.7;
//    label_num.font = midFont;
//    label_num.textAlignment = NSTextAlignmentCenter;
//    label_num.textColor = [UIColor whiteColor];
//    [_headImage addSubview:label_num];
//    [label_num mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(_headImage.mas_bottom).with.offset(-15);
//        make.right.equalTo(_headImage.mas_right).with.offset(0);
//        //make.left.equalTo(_headImage.mas_left).with.offset(0);
//        make.width.equalTo(@80);
//    }];
//    label_num.text = [NSString stringWithFormat:@"1/%ld",_totalArr.count];
//    
//    
//    /*------------------------------ 基本信息 ------------------------------*/
//    //中间横背景横线
//    UIView * bgViewtop = [[UIView alloc] init];
//    bgViewtop.backgroundColor = bgColor;
//    [contentView addSubview:bgViewtop];
//    [bgViewtop mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(Label_lq.mas_bottom).with.offset(10);
//        make.left.equalTo(contentView.mas_left).with.offset(0);
//        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
//    }];
//    
//    
//    HouseDetailTitle *houseParaTitle  = [[HouseDetailTitle alloc] init];
//    houseParaTitle.theTitle.text = @"基本信息";
//    houseParaTitle.tag = 101;
//    houseParaTitle.userInteractionEnabled =YES;
//    [contentView addSubview:houseParaTitle];
//    
//    UITapGestureRecognizer *hpTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
//    [houseParaTitle addGestureRecognizer:hpTap];
//    
//    [houseParaTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        //        [lastView isKindOfClass:[UIImageView class]]?
//        //        make.top.equalTo(allImage.mas_bottom).with.offset(17):
//        make.top.equalTo(bgViewtop.mas_bottom).with.offset(0);
//        make.left.equalTo(contentView.mas_left);
//        make.size.mas_equalTo(CGSizeMake(viewWidth, 46));
//    }];
//    
//    UIView * lastView ;
//    for (int i=0; i<10; i++) {
//        
//        UILabel *label = [[UILabel alloc] init];
//        label.font = midFont;
//        label.textColor = lgrayColor;
//        label.text = [NSString stringWithFormat:@"%@: %@",dict[@"baseInfoTitle"][i],dict[@"baseInfoContent"][i]];
//        
//        [contentView addSubview:label];
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.top.equalTo(lastView? lastView.mas_bottom:houseParaTitle.mas_bottom).with.offset(8);
//            make.left.equalTo(contentView.mas_left).with.offset(8);
//            make.right.equalTo(contentView.mas_right).with.offset(-8);
//            make.height.mas_equalTo(@13);
//        }];
//        lastView = label;
//    }
//    
//    /*------------------------------ 独享优惠 ------------------------------*/
//    
//    //中间横背景横线
//    UIView * bgView = [[UIView alloc] init];
//    bgView.backgroundColor = bgColor;
//    [contentView addSubview:bgView];
//    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(lastView.mas_bottom).with.offset(10);
//        make.left.equalTo(contentView.mas_left).with.offset(0);
//        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
//    }];
//    
//    
//    UIImageView * PreferentialImage = [[UIImageView alloc] init];
//    PreferentialImage.backgroundColor = dblueColor;
//    PreferentialImage.layer.cornerRadius = 5;
//    PreferentialImage.clipsToBounds = YES;
//    [contentView addSubview:PreferentialImage];
//    [PreferentialImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bgView.mas_bottom).with.offset(10);
//        make.left.equalTo(contentView.mas_left).with.offset(10);
//        make.size.mas_equalTo(CGSizeMake(50, 50));
//    }];
//    
//    
//    UILabel * label_dx = [[UILabel alloc] init];
//    label_dx.text = @"独享";
//    label_dx.textColor =[UIColor whiteColor];
//    label_dx.font = midFont;
//    [PreferentialImage addSubview:label_dx];
//    [label_dx mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(PreferentialImage.mas_top).with.offset(7);
//        make.centerX.equalTo(PreferentialImage);
//    }];
//    
//    UILabel * label_yh = [[UILabel alloc] init];
//    label_yh.text = @"优惠";
//    label_yh.textColor =[UIColor whiteColor];
//    label_yh.font = midFont;
//    [PreferentialImage addSubview:label_yh];
//    [label_yh mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(label_dx.mas_bottom).with.offset(5);
//        make.centerX.equalTo(PreferentialImage);
//    }];
//    
//    UIImageView * image_rl1 = [[UIImageView alloc] init];
//    image_rl1.image = [UIImage imageNamed:@"gray_rightArrow"];
//    [contentView addSubview:image_rl1];
//    [image_rl1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bgView.mas_bottom).with.offset(30);
//        make.right.equalTo(contentView.mas_right).with.offset(-20);
//        make.size.mas_equalTo(CGSizeMake(5, 10));
//    }];
//    
//    UILabel * discountLabel = [[UILabel alloc] init];
//    discountLabel.font = titleFont_15;
//    discountLabel.textColor = dblueColor;
//    [contentView addSubview:discountLabel];
//    
//    [discountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bgView.mas_bottom).with.offset(13);
//        make.left.equalTo(PreferentialImage.mas_right).with.offset(10);
//    }];
//    
//    
//    
//    UILabel * dateOfLabel = [[UILabel alloc] init];
//    dateOfLabel.font = midFont;
//    dateOfLabel.textColor = lgrayColor;
//    [contentView addSubview:dateOfLabel];
//    [dateOfLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(discountLabel.mas_bottom).with.offset(10);
//        make.left.equalTo(PreferentialImage.mas_right).with.offset(10);
//    }];
//    
//    
//    
//    /*------------------------------ 最新动态 ------------------------------*/
//    
//    //中间横背景横线
//    UIView * bgView1 = [[UIView alloc] init];
//    bgView1.backgroundColor = bgColor;
//    [contentView addSubview:bgView1];
//    [bgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(PreferentialImage.mas_bottom).with.offset(10);
//        make.left.equalTo(contentView.mas_left).with.offset(0);
//        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
//    }];
//    
//    UIImageView * image_rl2 = [[UIImageView alloc] init];
//    image_rl2.image = [UIImage imageNamed:@"gray_rightArrow"];
//    [contentView addSubview:image_rl2];
//    [image_rl2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bgView1.mas_bottom).with.offset(18);
//        make.right.equalTo(contentView.mas_right).with.offset(-20);
//        make.size.mas_equalTo(CGSizeMake(5, 10));
//    }];
//    
//    UILabel * dynamicLabel = [[UILabel alloc] init];
//    dynamicLabel.text = @"最新动态";
//    dynamicLabel.font = largeFont;
//    dynamicLabel.tag = 101;
//    dynamicLabel.userInteractionEnabled = YES;
//    [contentView addSubview:dynamicLabel];
//    [dynamicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bgView1.mas_bottom).with.offset(13);
//        make.left.equalTo(contentView.mas_left).with.offset(10);
//        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 20));
//    }];
//    
//    UITapGestureRecognizer *dynamicTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taplabelClick:)];
//    [dynamicLabel addGestureRecognizer:dynamicTap];
//    
//    UIView * lineView = [[UIView alloc] init];
//    lineView.backgroundColor = bgColor;
//    [contentView addSubview:lineView];
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(dynamicLabel.mas_bottom).with.offset(13);
//        make.left.equalTo(contentView.mas_left).with.offset(10);
//        make.right.equalTo(contentView.mas_right).with.offset(-10);
//        make.height.equalTo(@1);
//    }];
//    
//    UILabel * dynamicDalail = [[UILabel alloc] init];
//    dynamicDalail.font = midFont;
//    dynamicDalail.textColor = lgrayColor;
//    dynamicDalail.numberOfLines = 3;
//    [contentView addSubview:dynamicDalail];
//    [dynamicDalail mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(lineView.mas_bottom).with.offset(13);
//        make.left.equalTo(contentView.mas_left).with.offset(10);
//        //make.size.mas_equalTo(CGSizeMake(viewWidth-20, 10));
//        make.right.equalTo(contentView.mas_right).with.offset(-10);
//    }];
//    
//    //NSLog(@"%@",dictData[@"dynamicList"]);
//    if ([dictData[@"dynamicList"] count]>0) {
//        NSDictionary * dict_dy = dictData[@"dynamicList"][0];
//        dynamicDalail.text = dict_dy[@"description"];
//    }
//    
//    /*------------------------------ 品牌介绍 ------------------------------*/
//    
//    //中间横背景横线
//    UIView * bgView2 = [[UIView alloc] init];
//    bgView2.backgroundColor = bgColor;
//    [contentView addSubview:bgView2];
//    [bgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(dynamicDalail.mas_bottom).with.offset(10);
//        make.left.equalTo(contentView.mas_left).with.offset(0);
//        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
//    }];
//    
//    UIImageView * image_rl3 = [[UIImageView alloc] init];
//    image_rl3.image = [UIImage imageNamed:@"gray_rightArrow"];
//    [contentView addSubview:image_rl3];
//    [image_rl3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bgView2.mas_bottom).with.offset(18);
//        make.right.equalTo(contentView.mas_right).with.offset(-20);
//        make.size.mas_equalTo(CGSizeMake(5, 10));
//    }];
//    
//    UILabel * introduceLabel = [[UILabel alloc] init];
//    introduceLabel.text = @"品牌介绍";
//    introduceLabel.font = largeFont;
//    introduceLabel.tag = 102;
//    introduceLabel.userInteractionEnabled = YES;
//    [contentView addSubview:introduceLabel];
//    [introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bgView2.mas_bottom).with.offset(13);
//        make.left.equalTo(contentView.mas_left).with.offset(10);
//        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 20));
//    }];
//    
//    UITapGestureRecognizer *introTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taplabelClick:)];
//    [introduceLabel addGestureRecognizer:introTap];
//    
//    UIView * lineView1 = [[UIView alloc] init];
//    lineView1.backgroundColor = bgColor;
//    [contentView addSubview:lineView1];
//    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(introduceLabel.mas_bottom).with.offset(13);
//        make.left.equalTo(contentView.mas_left).with.offset(10);
//        make.right.equalTo(contentView.mas_right).with.offset(-10);
//        make.height.equalTo(@1);
//    }];
//    
//    UILabel * introduceDalail = [[UILabel alloc] init];
//    introduceDalail.text = model.fd_brandDescription;
//    introduceDalail.font = midFont;
//    introduceDalail.textColor = lgrayColor;
//    introduceDalail.numberOfLines = 2;
//    [contentView addSubview:introduceDalail];
//    [introduceDalail mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(lineView1.mas_bottom).with.offset(13);
//        make.left.equalTo(contentView.mas_left).with.offset(10);
//        make.right.equalTo(contentView.mas_right).with.offset(-10);
//    }];
//    
//    
//    /*------------------------------ 优惠须知 ------------------------------*/
//    //中间横背景横线
//    UIView * bgView3 = [[UIView alloc] init];
//    bgView3.backgroundColor = bgColor;
//    [contentView addSubview:bgView3];
//    [bgView3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(introduceDalail.mas_bottom).with.offset(10);
//        make.left.equalTo(contentView.mas_left).with.offset(0);
//        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
//    }];
//    
//    UIImageView * image_rl4 = [[UIImageView alloc] init];
//    image_rl4.image = [UIImage imageNamed:@"gray_rightArrow"];
//    [contentView addSubview:image_rl4];
//    [image_rl4 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bgView3.mas_bottom).with.offset(18);
//        make.right.equalTo(contentView.mas_right).with.offset(-20);
//        make.size.mas_equalTo(CGSizeMake(5, 10));
//    }];
//    
//    UILabel * preferentialLabel = [[UILabel alloc] init];
//    preferentialLabel.text = @"优惠须知";
//    preferentialLabel.font = largeFont;
//    preferentialLabel.tag = 103;
//    preferentialLabel.userInteractionEnabled = YES;
//    [contentView addSubview:preferentialLabel];
//    [preferentialLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bgView3.mas_bottom).with.offset(18);
//        make.left.equalTo(contentView.mas_left).with.offset(10);
//        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 20));
//    }];
//    
//    UITapGestureRecognizer *prefTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taplabelClick:)];
//    [preferentialLabel addGestureRecognizer:prefTap];
//    
//    
//    UIView * lineView2 = [[UIView alloc] init];
//    lineView2.backgroundColor = bgColor;
//    [contentView addSubview:lineView2];
//    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(preferentialLabel.mas_bottom).with.offset(13);
//        make.left.equalTo(contentView.mas_left).with.offset(10);
//        make.right.equalTo(contentView.mas_right).with.offset(-10);
//        make.height.equalTo(@1);
//    }];
//    
//    UILabel * preferentialDalail = [[UILabel alloc] init];
//    
//    preferentialDalail.font = midFont;
//    preferentialDalail.textColor = lgrayColor;
//    preferentialDalail.numberOfLines = 2;
//    [contentView addSubview:preferentialDalail];
//    [preferentialDalail mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(lineView2.mas_bottom).with.offset(13);
//        make.left.equalTo(contentView.mas_left).with.offset(10);
//        make.right.equalTo(contentView.mas_right).with.offset(-10);
//    }];
//
//    
//    
//    /*------------------------------ 年度拓展计划 ------------------------------*/
//    //中间横背景横线
//    UIView * bgView15 = [[UIView alloc] init];
//    bgView15.backgroundColor = bgColor;
//    [contentView addSubview:bgView15];
//    [bgView15 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(preferentialDalail.mas_bottom).with.offset(10);
//        make.left.equalTo(contentView.mas_left).with.offset(0);
//        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
//    }];
//    
//    UIImageView * image_rl12 = [[UIImageView alloc] init];
//    image_rl12.image = [UIImage imageNamed:@"gray_rightArrow"];
//    [contentView addSubview:image_rl12];
//    [image_rl12 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bgView15.mas_bottom).with.offset(18);
//        make.right.equalTo(contentView.mas_right).with.offset(-20);
//        make.size.mas_equalTo(CGSizeMake(5, 10));
//    }];
//    
//    UILabel * annualplanLabel = [[UILabel alloc] init];
//    annualplanLabel.text = @"年度拓展计划";
//    annualplanLabel.font = largeFont;
//    annualplanLabel.tag = 130;
//    annualplanLabel.userInteractionEnabled = YES;
//    [contentView addSubview:annualplanLabel];
//    [annualplanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bgView15.mas_bottom).with.offset(18);
//        make.left.equalTo(contentView.mas_left).with.offset(10);
//        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 20));
//    }];
//    
//    UITapGestureRecognizer *planTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taplabelClick:)];
//    [annualplanLabel addGestureRecognizer:planTap];
//    
//    
//    UIView * lineView12 = [[UIView alloc] init];
//    lineView12.backgroundColor = bgColor;
//    [contentView addSubview:lineView12];
//    [lineView12 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(annualplanLabel.mas_bottom).with.offset(13);
//        make.left.equalTo(contentView.mas_left).with.offset(10);
//        make.right.equalTo(contentView.mas_right).with.offset(-10);
//        make.height.equalTo(@1);
//    }];
//    
//    UILabel * annualplanDalail = [[UILabel alloc] init];
//    
//    annualplanDalail.font = midFont;
//    if (![model.planYearExtension isEqual:[NSNull null]]) {
//        
//        annualplanDalail.text = model.planYearExtension;
//    }
//    //annualplanDalail.text = model.planYearExtension;
//    annualplanDalail.textColor = lgrayColor;
//    annualplanDalail.numberOfLines = 2;
//    [contentView addSubview:annualplanDalail];
//    [annualplanDalail mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(lineView12.mas_bottom).with.offset(13);
//        make.left.equalTo(contentView.mas_left).with.offset(10);
//        make.right.equalTo(contentView.mas_right).with.offset(-10);
//    }];
//
//    
//    
//    /*------------------------------ 品牌点评 ------------------------------*/
//    
//    //中间横背景横线
//    UIView * bgView5 = [[UIView alloc] init];
//    bgView5.backgroundColor = bgColor;
//    [contentView addSubview:bgView5];
//    [bgView5 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(annualplanDalail.mas_bottom).with.offset(10);
//        make.left.equalTo(contentView.mas_left).with.offset(0);
//        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
//    }];
//    
//    UIImageView * image_rl6 = [[UIImageView alloc] init];
//    image_rl6.image = [UIImage imageNamed:@"gray_rightArrow"];
//    [contentView addSubview:image_rl6];
//    [image_rl6 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bgView5.mas_bottom).with.offset(18);
//        make.right.equalTo(contentView.mas_right).with.offset(-20);
//        make.size.mas_equalTo(CGSizeMake(5, 10));
//    }];
//    
//    UILabel * BrandreviewLabel = [[UILabel alloc] init];
//    BrandreviewLabel.text = @"品牌点评";
//    BrandreviewLabel.font = largeFont;
//    BrandreviewLabel.tag = 111;
//    BrandreviewLabel.userInteractionEnabled = YES;
//    [contentView addSubview:BrandreviewLabel];
//    [BrandreviewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bgView5.mas_bottom).with.offset(13);
//        make.left.equalTo(contentView.mas_left).with.offset(10);
//        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 20));
//    }];
//    
//    UITapGestureRecognizer * tap_br = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taplabelClick:)];
//    [BrandreviewLabel addGestureRecognizer:tap_br];
//    
//    UIView * lineView4 = [[UIView alloc] init];
//    lineView4.backgroundColor = bgColor;
//    [contentView addSubview:lineView4];
//    [lineView4 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(BrandreviewLabel.mas_bottom).with.offset(13);
//        make.left.equalTo(contentView.mas_left).with.offset(10);
//        make.right.equalTo(contentView.mas_right).with.offset(-10);
//        make.height.equalTo(@1);
//    }];
//    
//    
//    evaluationContent = [[HouseEvaluation alloc] init];
//    evaluationContent.evaluationTable.tag = 200;
//    evaluationContent.evaluationTable.scrollEnabled = NO;
//    evaluationContent.evaluationTable.delegate = self;
//    evaluationContent.evaluationTable.dataSource = self;
//    
//    [evaluationContent.evaluationButton addTarget:self action:@selector(evaluationClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    NSLog(@"%@",dictData[@"comment"][@"commentList"]);
//    
//    float devaluationContent_h = 140.f;
//    if (![dictData[@"comment"][@"commentList"] isEqual:[NSNull null]]) {
//        if ([dictData[@"comment"][@"commentList"] count] != 0) {
//            // 未对数据
//            NSDictionary * dic = dictData[@"comment"][@"commentList"][0];
//            
//            evaluationContent.totalStar.scorePercent = [dic[@"avgScore"] floatValue]/5;//[dic[@"avgScore"] floatValue]/5
//            evaluationContent.totalScore.text = [NSString stringWithFormat:@"%.1f分",[dic[@"avgScore"] floatValue]];
//            evaluationContent.scoreDetail.text = [NSString stringWithFormat:@"价格%.1f分 地段%.1f分 配套%.1f分 交通%.1f分 政策%.1f分 竞争%.1f分",
//                                                  [dic[@"priceScore"] floatValue],
//                                                  [dic[@"areaScore"] floatValue],
//                                                  [dic[@"supportingScore"] floatValue],
//                                                  [dic[@"trafficScore"] floatValue],
//                                                  [dic[@"policyScore"] floatValue],
//                                                  [dic[@"competeScore"] floatValue]];
//            
//            //devaluationContent_h = 270.f;
//            devaluationContent_h = 230.f;
//        }
//        
//    }
//    
//    
//    [contentView addSubview:evaluationContent];
//    [evaluationContent mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(lineView4.mas_bottom);
//        make.left.equalTo(bg_scrollView.mas_left);
//        make.size.mas_equalTo(CGSizeMake(viewWidth, devaluationContent_h));
//    }];
//    
//    /*------------------------------ 品牌顾问 ------------------------------*/
//    
//    //中间横背景横线
//    UIView * bgView6 = [[UIView alloc] init];
//    bgView6.backgroundColor = bgColor;
//    [contentView addSubview:bgView6];
//    [bgView6 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(evaluationContent.mas_bottom).with.offset(10);
//        make.left.equalTo(contentView.mas_left).with.offset(0);
//        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
//    }];
//    
//    UIImageView * image_rl7 = [[UIImageView alloc] init];
//    image_rl7.image = [UIImage imageNamed:@"gray_rightArrow"];
//    [contentView addSubview:image_rl7];
//    [image_rl7 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bgView6.mas_bottom).with.offset(18);
//        make.right.equalTo(contentView.mas_right).with.offset(-20);
//        make.size.mas_equalTo(CGSizeMake(5, 10));
//    }];
//    
//    UILabel * BrandconsultantLabel = [[UILabel alloc] init];
//    BrandconsultantLabel.text = @"品牌顾问";
//    BrandconsultantLabel.font = largeFont;
//    [contentView addSubview:BrandconsultantLabel];
//    [BrandconsultantLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bgView6.mas_bottom).with.offset(13);
//        make.left.equalTo(contentView.mas_left).with.offset(10);
//        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 20));
//    }];
//    
//    
//    UIView * lineView5 = [[UIView alloc] init];
//    lineView5.backgroundColor = bgColor;
//    [contentView addSubview:lineView5];
//    [lineView5 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(BrandconsultantLabel.mas_bottom).with.offset(13);
//        make.left.equalTo(contentView.mas_left).with.offset(10);
//        make.right.equalTo(contentView.mas_right).with.offset(-10);
//        make.height.equalTo(@1);
//    }];
//    
//    
//    JoinContactWay *contactWayContent = [[JoinContactWay alloc] init];
//    
//    contactWayContent.peopleName.text = model.fd_brandContacts == nil?
//    @"暂无":[NSString stringWithFormat:@"%@",model.fd_brandContacts];
//    contactWayContent.peoplePosition.text = model.fd_jobTitle == nil?
//    @"暂无":[NSString stringWithFormat:@"%@",model.fd_jobTitle];
//    contactWayContent.peopleRegion.text = model.fd_precinct == nil?
//    @"暂无":[NSString stringWithFormat:@"%@",model.fd_precinct];
//    contactWayContent.peopleTel.text = model.fd_tel == nil?
//    @"暂无":[NSString stringWithFormat:@"%@",@"***-********"];
//    NSMutableString *phongStr = [[NSMutableString alloc] initWithString:model.fd_phone == nil?
//                                 @"暂无":[NSString stringWithFormat:@"%@",model.fd_phone]];
//    phongStr.length == 11?
//    [phongStr replaceCharactersInRange:NSMakeRange(3, 7) withString:@"*******"]:phongStr;
//    contactWayContent.peopleMobileNum.text = phongStr;
//    contactWayContent.peopleEmail.text = model.fd_email == nil?
//    @"暂无":@"**@**.com";
//    contactWayContent.peopleAddress.text = model.fd_address == nil?
//    @"暂无":@"********";
//    [contentView addSubview:contactWayContent];
//    
//    
//    [contactWayContent mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(lineView5.mas_bottom).with.offset(10);
//        make.left.equalTo(contentView.mas_left).with.offset(30);
//        make.size.mas_equalTo(CGSizeMake(viewWidth, 150));
//    }];
//    
//    
//    
//    
//    if (![dicount isEqual:[NSNull null]]) {
//        discountLabel.text = [NSString stringWithFormat:@"%@折加盟优惠",dicount[@"discount"]];
//        dateOfLabel.text = [NSString stringWithFormat:@"截止日期: %@",[Tools_F timeTransform:[dicount[@"endTime"] floatValue] time:days]];
//        
//        preferentialDalail.text = dicount[@"preferentialDescription"];
//        
//        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@折", dicount[@"discount"]]];
//        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:NSMakeRange(0, 3)];
//        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(3, 1)];
//        discoLabel.attributedText = str;
//    }
    
    /*------------------------------ 基本信息 ------------------------------*/
    
    //中间横背景横线
    //    UIView * bgView8 = [[UIView alloc] init];
    //    bgView8.backgroundColor = bgColor;
    //    [contentView addSubview:bgView8];
    //    [bgView8 mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(contactWayContent.mas_bottom).with.offset(10);
    //        make.left.equalTo(contentView.mas_left).with.offset(0);
    //        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
    //    }];
    //
    //
    //    HouseDetailTitle *houseParaTitle = [[HouseDetailTitle alloc] init];
    //    houseParaTitle.theTitle.text = @"基本信息";
    //    houseParaTitle.tag = 101;
    //    houseParaTitle.userInteractionEnabled =YES;
    //    [contentView addSubview:houseParaTitle];
    //
    //    UITapGestureRecognizer *hpTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
    //    [houseParaTitle addGestureRecognizer:hpTap];
    //
    //    [houseParaTitle mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(bgView8.mas_bottom).with.offset(10);
    //        make.left.equalTo(contentView.mas_left);
    //        make.size.mas_equalTo(CGSizeMake(viewWidth, 40));
    //    }];
    //
    //    //lastView = nil;
    UIView *lastView8;
    //    for (int i=0; i<10; i++) {
    //
    //        UILabel *label = [[UILabel alloc] init];
    //        label.font = midFont;
    //        label.textColor = lgrayColor;
    //        label.text = [NSString stringWithFormat:@"%@: %@",dict[@"baseInfoTitle"][i],dict[@"baseInfoContent"][i]];
    //
    //        [contentView addSubview:label];
    //        [label mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //            make.top.equalTo(lastView8? lastView8.mas_bottom:houseParaTitle.mas_bottom).with.offset(8);
    //            make.left.equalTo(contentView.mas_left).with.offset(8);
    //            make.right.equalTo(contentView.mas_right).with.offset(-8);
    //            make.height.mas_equalTo(@13);
    //        }];
    //        lastView8 = label;
    //    }
    
    
    
    /*------------------------------ 物业要求 ------------------------------*/
    
    //中间横背景横线
//    UIView * bgView9 = [[UIView alloc] init];
//    bgView9.backgroundColor = bgColor;
//    [contentView addSubview:bgView9];
//    [bgView9 mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.top.equalTo(contactWayContent.mas_bottom).with.offset(10);
//        make.top.equalTo(contentView.mas_top);
//        make.left.equalTo(contentView.mas_left).with.offset(0);
//        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
//    }];
    
    HouseDetailTitle *propertyDescriptionTitle  = [[HouseDetailTitle alloc] init];
    propertyDescriptionTitle.theTitle.text = @"物业要求";
    propertyDescriptionTitle.tag = 105;
    propertyDescriptionTitle.userInteractionEnabled =YES;
    propertyDescriptionTitle.titleType = haveArrow;
    [contentView addSubview:propertyDescriptionTitle];
    
    UITapGestureRecognizer *pdTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
    [propertyDescriptionTitle addGestureRecognizer:pdTap];
    
    propertyDescriptionContent = [[UILabel alloc] init];
    propertyDescriptionContent.font = midFont;
    propertyDescriptionContent.textColor = lgrayColor;
    [contentView addSubview:propertyDescriptionContent];
    
    float propertyDescriptionTitle_h = 0;
//    float propertyDescriptionContent_h = 0;
    
    if (model.fd_brandDescription!= nil) {
        propertyDescriptionTitle_h = 40.f;
//        propertyDescriptionContent_h = 85.f;
        propertyDescriptionContent.numberOfLines = NumberOfLines;
        propertyDescriptionContent.text = [model.fd_propertyDescription isKindOfClass:[NSNull class]]?@"暂无":[NSString stringWithFormat:@"%@",model.fd_propertyDescription];
    }
    
    [propertyDescriptionTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_top);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, propertyDescriptionTitle_h));
    }];
    
    [propertyDescriptionContent mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(propertyDescriptionTitle.mas_bottom).with.offset(10);
        make.left.equalTo(contentView.mas_left).with.offset(8);
        make.right.equalTo(contentView.mas_right).with.offset(-8);
        make.height.mas_greaterThanOrEqualTo(20);
//        make.height.mas_lessThanOrEqualTo(propertyDescriptionContent_h);
    }];
    
    UIButton *drawButton = [[UIButton alloc] init];
    //    _drawButton.backgroundColor = [UIColor redColor];
    [drawButton setImage:[UIImage imageNamed:@"icon-chevron-down"] forState:UIControlStateNormal];
    [drawButton setImage:[UIImage imageNamed:@"icon-chevron-up"] forState:UIControlStateSelected];
    [drawButton setTitle:@"查看更多信息" forState:UIControlStateNormal];
    [drawButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, viewWidth - 15-120-180)];
    [drawButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, viewWidth - 15 - 90)];
    drawButton.tag = 900;
    [drawButton addTarget:self action:@selector(drawClick:) forControlEvents:UIControlEventTouchUpInside];
    [drawButton setTitle:@"收起" forState:UIControlStateSelected];
    drawButton.titleLabel.font = midFont;
    
    [drawButton setTitleColor:dblueColor forState:UIControlStateNormal];
    [contentView addSubview:drawButton];
    [drawButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(propertyDescriptionContent.mas_bottom).with.offset(10);
        make.height.equalTo(@24);
        make.width.equalTo(contentView.mas_width);
    }];
    
    
    /*------------------------------ 加盟条件 ------------------------------*/
    //中间横背景横线
    UIView * bgView3 = [[UIView alloc] init];
    bgView3.backgroundColor = bgColor;
    [contentView addSubview:bgView3];
    [bgView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(drawButton.mas_bottom).with.offset(10);
        make.left.equalTo(contentView.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
    }];
    
//    UIImageView * image_rl4 = [[UIImageView alloc] init];
//    image_rl4.image = [UIImage imageNamed:@"gray_rightArrow"];
//    [contentView addSubview:image_rl4];
//    [image_rl4 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bgView3.mas_bottom).with.offset(18);
//        make.right.equalTo(contentView.mas_right).with.offset(-20);
//        make.size.mas_equalTo(CGSizeMake(5, 10));
//    }];
    
    UILabel * preferentialLabel = [[UILabel alloc] init];
    preferentialLabel.text = @"加盟条件";
    preferentialLabel.font = largeFont;
    preferentialLabel.tag = 103;
    preferentialLabel.userInteractionEnabled = YES;
    [contentView addSubview:preferentialLabel];
    [preferentialLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView3.mas_bottom).with.offset(18);
        make.left.equalTo(contentView.mas_left).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 20));
    }];
    
//    UITapGestureRecognizer *prefTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taplabelClick:)];
//    [preferentialLabel addGestureRecognizer:prefTap];
    
    
    UIView * lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = bgColor;
    [contentView addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(preferentialLabel.mas_bottom).with.offset(13);
        make.left.equalTo(contentView.mas_left).with.offset(10);
        make.right.equalTo(contentView.mas_right).with.offset(-10);
        make.height.equalTo(@1);
    }];
    
    preferentialDalail = [[UILabel alloc] init];
    
    preferentialDalail.font = midFont;
    preferentialDalail.textColor = lgrayColor;
    preferentialDalail.numberOfLines = NumberOfLines;
    preferentialDalail.text =  [model.joinConditions isKindOfClass:[NSNull class]]?@"暂无":[NSString stringWithFormat:@"%@",model.joinConditions];
    [contentView addSubview:preferentialDalail];
    [preferentialDalail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView2.mas_bottom).with.offset(13);
        make.left.equalTo(contentView.mas_left).with.offset(10);
        make.right.equalTo(contentView.mas_right).with.offset(-10);
    }];
    
    UIButton *preButton = [[UIButton alloc] init];
    //    _drawButton.backgroundColor = [UIColor redColor];
    [preButton setImage:[UIImage imageNamed:@"icon-chevron-down"] forState:UIControlStateNormal];
    [preButton setImage:[UIImage imageNamed:@"icon-chevron-up"] forState:UIControlStateSelected];
    [preButton setTitle:@"查看更多信息" forState:UIControlStateNormal];
    [preButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, viewWidth - 15-120-180)];
    [preButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, viewWidth - 15 - 90)];
    preButton.tag = 901;
    [preButton addTarget:self action:@selector(drawClick:) forControlEvents:UIControlEventTouchUpInside];
    [preButton setTitle:@"收起" forState:UIControlStateSelected];
    preButton.titleLabel.font = midFont;
    
    [preButton setTitleColor:dblueColor forState:UIControlStateNormal];
    [contentView addSubview:preButton];
    [preButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(preferentialDalail.mas_bottom).with.offset(10);
        make.height.equalTo(@24);
        make.width.equalTo(contentView.mas_width);
    }];


    /*------------------------------ 投资分析 ------------------------------*/
    
    //中间横背景横线
    UIView * bgView10 = [[UIView alloc] init];
    bgView10.backgroundColor = bgColor;
    [contentView addSubview:bgView10];
    [bgView10 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(preButton.mas_bottom).with.offset(10);
        make.left.equalTo(contentView.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
    }];
    
    HouseDetailTitle *investmentAnalysisTitle  = [[HouseDetailTitle alloc] init];
    investmentAnalysisTitle.theTitle.text = @"投资分析";
    investmentAnalysisTitle.tag = 107;
    investmentAnalysisTitle.userInteractionEnabled =YES;
    investmentAnalysisTitle.titleType = haveArrow;
    [contentView addSubview:investmentAnalysisTitle];
    
//    UITapGestureRecognizer *iaTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
//    [investmentAnalysisTitle addGestureRecognizer:iaTap];
    
    [investmentAnalysisTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView10.mas_bottom);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 40));
    }];
    
    lastView8 = nil;
    
    for (int i=0; i<[dict[@"investmentAnalysisTitle"]count]; i++) {
        
        UILabel *label = [[UILabel alloc] init];
        label.font = midFont;
        label.textColor = lgrayColor;
        label.text = [NSString stringWithFormat:@"%@: %@",dict[@"investmentAnalysisTitle"][i],dict[@"investmentAnalysisContent"][i]];
        
        [contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(lastView8? lastView8.mas_bottom:investmentAnalysisTitle.mas_bottom).with.offset(8);
            make.left.equalTo(contentView.mas_left).with.offset(8);
            make.right.equalTo(contentView.mas_right).with.offset(-8);
            make.height.mas_equalTo(@13);
        }];
        lastView8 = label;
    }
    
    /*------------------------------ 加盟优势 ------------------------------*/
    
    //中间横背景横线
    UIView * bgView11 = [[UIView alloc] init];
    bgView11.backgroundColor = bgColor;
    [contentView addSubview:bgView11];
    [bgView11 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastView8.mas_bottom).with.offset(10);
        make.left.equalTo(contentView.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
    }];
    
    HouseDetailTitle *joinAdvantageTitle  = [[HouseDetailTitle alloc] init];
    joinAdvantageTitle.theTitle.text = @"加盟优势";
    joinAdvantageTitle.tag = 108;
    joinAdvantageTitle.userInteractionEnabled =YES;
    joinAdvantageTitle.titleType = haveArrow;
    [contentView addSubview:joinAdvantageTitle];
    
//    UITapGestureRecognizer *jaTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
//    [joinAdvantageTitle addGestureRecognizer:jaTap];
    
    joinAdvantageContent = [[UILabel alloc] init];
    joinAdvantageContent.font = midFont;
    joinAdvantageContent.textColor = lgrayColor;
    [contentView addSubview:joinAdvantageContent];
    
    float joinAdvantageTitle_h = 0;
    float joinAdvantageContent_h = 0;
    
    if (model.fd_brandDescription!= nil) {
        joinAdvantageTitle_h = 40.f;
        joinAdvantageContent_h = 23.f;
        joinAdvantageContent.numberOfLines = 0;
        joinAdvantageContent.text = [NSString stringWithFormat:@"%@",model.fd_joinAdvantage];
    }
    
    [joinAdvantageTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView11.mas_bottom).with.offset(8);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, joinAdvantageTitle_h));
    }];
    
    [joinAdvantageContent mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(joinAdvantageTitle.mas_bottom).with.offset(10);
        make.left.equalTo(contentView.mas_left).with.offset(8);
        make.right.equalTo(contentView.mas_right).with.offset(-8);
        make.height.mas_greaterThanOrEqualTo(joinAdvantageContent_h);
    }];
    
    UIButton *joinAdvButton = [[UIButton alloc] init];
    //    _drawButton.backgroundColor = [UIColor redColor];
    [joinAdvButton setImage:[UIImage imageNamed:@"icon-chevron-down"] forState:UIControlStateNormal];
    [joinAdvButton setImage:[UIImage imageNamed:@"icon-chevron-up"] forState:UIControlStateSelected];
    [joinAdvButton setTitle:@"查看更多信息" forState:UIControlStateNormal];
    [joinAdvButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, viewWidth - 15-120-180)];
    [joinAdvButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, viewWidth - 15 - 90)];
    joinAdvButton.tag = 902;
    [joinAdvButton addTarget:self action:@selector(drawClick:) forControlEvents:UIControlEventTouchUpInside];
    [joinAdvButton setTitle:@"收起" forState:UIControlStateSelected];
    joinAdvButton.titleLabel.font = midFont;
    
    [joinAdvButton setTitleColor:dblueColor forState:UIControlStateNormal];
    [contentView addSubview:joinAdvButton];
    [joinAdvButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(joinAdvantageContent.mas_bottom).with.offset(10);
        make.height.equalTo(@24);
        make.width.equalTo(contentView.mas_width);
    }];
    
    
    /*------------------------------ 加盟流程 ------------------------------*/
    //中间横背景横线
    UIView * bgView15 = [[UIView alloc] init];
    bgView15.backgroundColor = bgColor;
    [contentView addSubview:bgView15];
    [bgView15 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(joinAdvButton.mas_bottom).with.offset(10);
        make.left.equalTo(contentView.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
    }];
    
    UIImageView * image_rl12 = [[UIImageView alloc] init];
    image_rl12.image = [UIImage imageNamed:@"gray_rightArrow"];
    [contentView addSubview:image_rl12];
    [image_rl12 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView15.mas_bottom).with.offset(18);
        make.right.equalTo(contentView.mas_right).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(5, 10));
    }];
    
    UILabel * annualplanLabel = [[UILabel alloc] init];
    annualplanLabel.text = @"加盟流程";
    annualplanLabel.font = largeFont;
    annualplanLabel.tag = 130;
    annualplanLabel.userInteractionEnabled = YES;
    [contentView addSubview:annualplanLabel];
    [annualplanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView15.mas_bottom).with.offset(18);
        make.left.equalTo(contentView.mas_left).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 20));
    }];
    
//    UITapGestureRecognizer *planTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taplabelClick:)];
//    [annualplanLabel addGestureRecognizer:planTap];
    
    
    UIView * lineView12 = [[UIView alloc] init];
    lineView12.backgroundColor = bgColor;
    [contentView addSubview:lineView12];
    [lineView12 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(annualplanLabel.mas_bottom).with.offset(13);
        make.left.equalTo(contentView.mas_left).with.offset(10);
        make.right.equalTo(contentView.mas_right).with.offset(-10);
        make.height.equalTo(@1);
    }];
    
    annualplanDalail = [[UILabel alloc] init];
    
    annualplanDalail.font = midFont;
    if (![model.joinProcess isEqual:[NSNull null]]) {
        
        annualplanDalail.text = model.joinProcess;
    }
    //annualplanDalail.text = model.planYearExtension;
    annualplanDalail.textColor = lgrayColor;
    annualplanDalail.numberOfLines = 2;
    [contentView addSubview:annualplanDalail];
    [annualplanDalail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView12.mas_bottom).with.offset(13);
        make.left.equalTo(contentView.mas_left).with.offset(10);
        make.right.equalTo(contentView.mas_right).with.offset(-10);
    }];
    
    UIButton *annualButton = [[UIButton alloc] init];
    //    _drawButton.backgroundColor = [UIColor redColor];
    [annualButton setImage:[UIImage imageNamed:@"icon-chevron-down"] forState:UIControlStateNormal];
    [annualButton setImage:[UIImage imageNamed:@"icon-chevron-up"] forState:UIControlStateSelected];
    [annualButton setTitle:@"查看更多信息" forState:UIControlStateNormal];
    [annualButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, viewWidth - 15-120-180)];
    [annualButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, viewWidth - 15 - 90)];
    annualButton.tag = 903;
    [annualButton addTarget:self action:@selector(drawClick:) forControlEvents:UIControlEventTouchUpInside];
    [annualButton setTitle:@"收起" forState:UIControlStateSelected];
    annualButton.titleLabel.font = midFont;
    
    [annualButton setTitleColor:dblueColor forState:UIControlStateNormal];
    [contentView addSubview:annualButton];
    [annualButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(annualplanDalail.mas_bottom).with.offset(10);
        make.height.equalTo(@24);
        make.width.equalTo(contentView.mas_width);
    }];

    
    /*------------------------------ 实体图展示 ------------------------------*/
    
    //中间横背景横线
    UIView * bgView12 = [[UIView alloc] init];
    bgView12.backgroundColor = bgColor;
    [contentView addSubview:bgView12];
    [bgView12 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(annualButton.mas_bottom).with.offset(10);
        make.left.equalTo(contentView.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
    }];
    
    HouseDetailTitle *terminalShowTitle  = [[HouseDetailTitle alloc] init];
    terminalShowTitle.theTitle.text = @"实体图展示";
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
            
            terminalShowTitle_h = 40;
            terminalShowContent_h = 175;
            
            // 图片尺寸设定
            cutString = [NSString stringWithCurrentString:model.fd_imageList[@"terminalUrls"][0] SizeWidth:viewWidth*2];
            //    [_headImage addTarget:self action:@selector(topImageTap:) forControlEvents:UIControlEventTouchUpInside];
            [terminalShowContent sd_setImageWithURL:[NSURL URLWithString:cutString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading_b"]];
        }
    }
    
    [terminalShowTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView12.mas_bottom).with.offset(8);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, terminalShowTitle_h));
    }];
    
    [terminalShowContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(terminalShowTitle.mas_bottom);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, terminalShowContent_h));
    }];
    
    /*------------------------------ 产品展示 ------------------------------*/
    
    //中间横背景横线
    UIView * bgView13 = [[UIView alloc] init];
    bgView13.backgroundColor = bgColor;
    [contentView addSubview:bgView13];
    [bgView13 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(terminalShowContent.mas_bottom).with.offset(0);
        make.left.equalTo(contentView.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
    }];
    
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
            
            productShowTitle_h = 40;
            productShowContent_h = 175;
            
            // 图片尺寸设定
            cutString = [NSString stringWithCurrentString:model.fd_imageList[@"productUrls"][0] SizeWidth:viewWidth*2];
            [productShowContent sd_setImageWithURL:[NSURL URLWithString:cutString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading_b"]];
            //    [_headImage addTarget:self action:@selector(topImageTap:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    [productShowTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView13.mas_bottom);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, productShowTitle_h));
    }];
    
    [productShowContent  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(productShowTitle.mas_bottom);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, productShowContent_h));
    }];
    
    
    /*------------------------------ 相关品牌推荐 ------------------------------*/
    //中间横背景横线
    UIView * bgView7 = [[UIView alloc] init];
    bgView7.backgroundColor = bgColor;
    [contentView addSubview:bgView7];
    [bgView7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(productShowContent.mas_bottom).with.offset(0);
        make.left.equalTo(contentView.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
    }];
    
    UIImageView * image_rl8 = [[UIImageView alloc] init];
    image_rl8.image = [UIImage imageNamed:@""];
    [contentView addSubview:image_rl8];
    [image_rl8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView7.mas_bottom).with.offset(18);
        make.right.equalTo(contentView.mas_right).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(5, 10));
    }];
    
    
    
    UILabel * BrandrecommendationLabel = [[UILabel alloc] init];
    BrandrecommendationLabel.text = @"相关品牌推荐";
    BrandrecommendationLabel.font = largeFont;
    [contentView addSubview:BrandrecommendationLabel];
    [BrandrecommendationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView7.mas_bottom).with.offset(13);
        make.left.equalTo(contentView.mas_left).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 20));
    }];
    
    
    UIView * lineView6 = [[UIView alloc] init];
    lineView6.backgroundColor = bgColor;
    [contentView addSubview:lineView6];
    [lineView6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(BrandrecommendationLabel.mas_bottom).with.offset(13);
        make.left.equalTo(contentView.mas_left).with.offset(10);
        make.right.equalTo(contentView.mas_right).with.offset(-10);
        make.height.equalTo(@1);
    }];
    
    float commendation_h = 0;
    UIView * commendationView = [[UIView alloc] init];
    [contentView addSubview:commendationView];
    
    if (![dictData[@"recommendList"] isEqual:[NSNull null]]) {
        
        if ([dictData[@"recommendList"] count] != 0) {
            
            commendation_h = 150;
            UIScrollView * scrollView_min = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, commendation_h)];
            [commendationView addSubview:scrollView_min];
            
            for (int i = 0; i < [dictData[@"recommendList"] count]; i ++) {
                
                UIView * minView = [[UIView alloc] initWithFrame:CGRectMake(i*95+10, 0, 85, commendation_h)];
                //minView.backgroundColor = [UIColor redColor];
                [scrollView_min addSubview:minView];
                
                UIImageView * topImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 85, 45)];
                [topImage sd_setImageWithURL:[NSURL URLWithString:dictData[@"recommendList"][i][@"defaultImage"]] placeholderImage:[UIImage imageNamed:@"loading_b"]];
                [minView addSubview:topImage];
                
                UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 85, 20)];
                //title.textColor = lgrayColor;
                title.font = titleFont_15;
                title.text = dictData[@"recommendList"][i][@"brandName"];
                [minView addSubview:title];
                
                UILabel * planFormat = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 85, 15)];
                planFormat.textColor = lgrayColor;
                planFormat.font = littleFont;
                planFormat.text = [NSString stringWithFormat:@"投资额度：%@",dictData[@"recommendList"][i][@"investmentAmountCategoryName"]];
                [minView addSubview:planFormat];
                
                UILabel * Status = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 85, 15)];
                Status.textColor = lgrayColor;
                Status.font = littleFont;
                Status.text = [NSString stringWithFormat:@"行业类别：%@",dictData[@"recommendList"][i][@"industryCategoryName"]];
                [minView addSubview:Status];
                
                UILabel * Area = [[UILabel alloc] initWithFrame:CGRectMake(0, 110, 85, 15)];
                Area.textColor = lgrayColor;
                Area.font = littleFont;
                Area.text = [NSString stringWithFormat:@"门店数量：%@",dictData[@"recommendList"][i][@"joinedQty"]];
                [minView addSubview:Area];
            }
            scrollView_min.contentSize = CGSizeMake(95*[dictData[@"recommendList"] count], commendation_h);
            
            
        }
        
    }
    
    
    [commendationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView6.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, commendation_h));
    }];
    
    
    // 自动scrollview高度
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(commendationView.mas_bottom).with.offset(45);
    }];
    
    
    /*------------------------------ 底部按钮 ------------------------------*/
    view_b = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight-108, viewWidth, 45)];
    view_b.backgroundColor = bgColor;
    [self.view addSubview:view_b];
    
    
    NSArray * butt_bArr =@[@"全国热线",@"品牌热线",@"",@"找场地"];
    NSArray * btn_image = @[@"icon-hotline1",@"house_counselor_1",@"house_counselor_3",@"icon-brand-find"];
    for (int i = 0; i < 4; i ++) {
        JoinBottomBtn * button_b = [JoinBottomBtn buttonWithType:UIButtonTypeCustom];
        button_b.frame = CGRectMake(i*(viewWidth/4), 0, viewWidth/4-1, 45);
        button_b.backgroundColor = tagsColor;
        [button_b setTitle:butt_bArr[i] forState:UIControlStateNormal];
        button_b.titleLabel.font = midFont;
        [button_b setImage:[UIImage imageNamed:btn_image[i]] forState:UIControlStateNormal];
        button_b.titleLabel.textAlignment = NSTextAlignmentCenter;
        button_b.tag = 200+i;
        [view_b addSubview:button_b];
        [button_b addTarget:self action:@selector(button_bClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i < 2) {
            button_b.backgroundColor = [UIColor whiteColor];
            [button_b setTitleColor:lgrayColor forState:UIControlStateNormal];
        }
        else
        {
            button_b.backgroundColor = tagsColor;
        }
        if (i == 2) {
            
            if (![model.fd_discountCoupons isEqual:[NSNull null]]) {
                
                if ([model.fd_discountCoupons[@"isApply"] integerValue] == 1){
                    
                    [button_b setTitle:@"我要加盟" forState:UIControlStateNormal];
                }
                else {
                    
                    [button_b setTitle:@"立即领取" forState:UIControlStateNormal];
                }
            }else{
                
                [button_b setTitle:@"暂不可加盟" forState:UIControlStateNormal];
            }
        }
    }
}
- (void)drawClick:(UIButton *)btn{
    
    switch (btn.tag) {
        case 900:
        {
            
            if (!btn.selected) {
                [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, viewWidth - 15-60-80)];
                [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, viewWidth - 15 - 50)];
                propertyDescriptionContent.numberOfLines = 0;
            }else{
                
                propertyDescriptionContent.numberOfLines = NumberOfLines;
                [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, viewWidth - 15-120-180)];
                [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, viewWidth - 15 - 90)];
            }
            btn.selected = !btn.selected;
        }
            break;
        case 901:
        {
            
            if (!btn.selected) {
                [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, viewWidth - 15-60-80)];
                [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, viewWidth - 15 - 50)];
                preferentialDalail.numberOfLines = 0;
            }else{
                
                preferentialDalail.numberOfLines = NumberOfLines;
                [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, viewWidth - 15-120-180)];
                [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, viewWidth - 15 - 90)];
            }
            btn.selected = !btn.selected;
        }
            break;
        case 902:
        {
            
            if (!btn.selected) {
                [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, viewWidth - 15-60-80)];
                [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, viewWidth - 15 - 50)];
                joinAdvantageContent.numberOfLines = 0;
            }else{
                
                joinAdvantageContent.numberOfLines = NumberOfLines;
                [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, viewWidth - 15-120-180)];
                [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, viewWidth - 15 - 90)];
            }
            btn.selected = !btn.selected;
        }
            break;
        case 903:
        {
            
            if (!btn.selected) {
                [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, viewWidth - 15-60-80)];
                [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, viewWidth - 15 - 50)];
                annualplanDalail.numberOfLines = 0;
            }else{
                
                annualplanDalail.numberOfLines = NumberOfLines;
                [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, viewWidth - 15-120-180)];
                [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, viewWidth - 15 - 90)];
            }
            btn.selected = !btn.selected;
        }
            break;
        default:
            break;
    }
    
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
            //            DynamicListViewController *dylVC = [[DynamicListViewController alloc] init];
            //            dylVC.brandId = model.fd_brandId;
            //            [self.navigationController pushViewController:dylVC animated:YES];
        }
            break;
        case 101:
        {
            
        }
            break;
        case 102:
        {
            // 品牌介绍
            BranksIntroductionViewController *biVC = [[BranksIntroductionViewController alloc] init];
            biVC.introductionContent = [NSString stringWithFormat:@"%@",model.fd_brandDescription];
            [self.navigationController pushViewController:biVC animated:YES];
        }
            break;
        case 103:
        {
            // 实体图展示
            FullScreenViewController *fsVC = [[FullScreenViewController alloc] init];
            fsVC.imagesFrom = 1;
            fsVC.paramID = model.fd_brandId;
            fsVC.jumpColumn = @"实体图展示";
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
            //            if (![GlobalController isLogin]) {
            //
            //                LoginController *loginVC = [[LoginController alloc] init];
            //                [self.navigationController pushViewController:loginVC animated:YES];
            //            }
            //            else {
            //
            //                // 联系方式
            //                JoinContactViewController *jcVC = [[JoinContactViewController alloc] init];
            //                jcVC.brandId = model.fd_brandId;
            //                [self.navigationController pushViewController:jcVC animated:YES];
            //            }
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
        case 130:
        {
            BranksIntroductionViewController *biVC = [[BranksIntroductionViewController alloc] init];
            biVC.introductionContent = [NSString stringWithFormat:@"%@",model.planYearExtension];
            [self.navigationController pushViewController:biVC animated:YES];
            
            
        }
            break;
        default:
            break;
    }
}


-(void)button_bClick:(UIButton *)btn
{
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else
    {
        switch (btn.tag) {
            case 200:
            {
                NSString *telNumber = [[NSString alloc] initWithFormat:@"telprompt://%@",@"4009918829"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telNumber]];
            }
                break;
            case 201:
            {
                
                NSString *telNumber;
                if (![model.fd_tel400Extra isEqualToString:@""]) {
                    
                    telNumber = [[NSString alloc] initWithFormat:@"telprompt://%@%@",model.fd_tel400,model.fd_tel400Extra];
                }else{
                    
                    telNumber = [[NSString alloc] initWithFormat:@"telprompt://%@",model.fd_tel400];
                }
                NSString *strUrl = [telNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strUrl]];
                // 用户id
                //                NSString *userID = [NSString stringWithFormat:@"%@",model.fd_chatUser[@"userId"]];
                //                NSLog(@"对方id:%@",userID);
                //
                //                // 发送顾问默认欢迎文本
                //                NSDictionary *param = @{@"consultantUserId":userID,@"type":@1,@"brandId":_brandId};
                //                NSString *urlString = [SDD_MainURL stringByAppendingString:@"/user/getIMDefaultWelcomeText.do"];              // 拼接主路径和请求内容成完整url
                //                [self sendRequest:param url:urlString];
                //
                //                self.hidesBottomBarWhenPushed = YES;
                //                ChatViewController *cvc = [[ChatViewController alloc] initWithChatter:userID isGroup:FALSE];
                //
                //                cvc.userName = model.fd_chatUser[@"chatName"];
                //                cvc.projectName = model.fd_brandName;
                //                [self.navigationController pushViewController:cvc animated:true];
                
            }
                break;
            case 203:
            {
                GroupRentViewController * groupRentVC = [[GroupRentViewController alloc] init];
                
                groupRentVC.activityCategoryId = 2;
                //                groupRentVC.regionId = regionId;
                [self.navigationController pushViewController:groupRentVC animated:true];
            }
                break;
            default:
            {
                if (![model.fd_discountCoupons isEqual:[NSNull null]]){
                    
                    if ([btn.titleLabel.text isEqualToString:@"立即领取"]) {
                        
                        [self requestReceive];
                    }
                    else
                    {
                        // 立即加盟
                        
                        //                        GetCouponViewController *gcVC = [[GetCouponViewController alloc] init];
                        //                        gcVC.brankName = model.fd_brandName;
                        //                        gcVC.discountCoupons = model.fd_discountCoupons;
                        //                        [self.navigationController pushViewController:gcVC animated:YES];
                        
#warning mark 我要加盟
                        //                        IWantToJoinViewController *goVc = [[IWantToJoinViewController alloc]init];
                        //                        [self.navigationController pushViewController:goVc animated:YES];
                    }
                    
                }else{
                    
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"抱歉，暂不可加盟" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                    [alert show];
                }
                
                
            }
                break;
        }
    }
    
}

#pragma  mark -- label点击
-(void)taplabelClick:(UITapGestureRecognizer *)tapl
{
    UILabel *label = (UILabel *)tapl.view;
    NSInteger titleTag = (NSInteger)label.tag;
    NSLog(@"标题点击%ld",(long)titleTag);
    switch (titleTag) {
        case 101:
        {
            // 品牌介绍
            BranksIntroductionViewController *biVC = [[BranksIntroductionViewController alloc] init];
            biVC.introductionContent = [NSString stringWithFormat:@"%@",model.fd_brandDescription];
            [self.navigationController pushViewController:biVC animated:YES];
        }
            break;
        case 102:
        {
            // 品牌介绍
            BranksIntroductionViewController *biVC = [[BranksIntroductionViewController alloc] init];
            biVC.introductionContent = [NSString stringWithFormat:@"%@",model.fd_brandDescription];
            [self.navigationController pushViewController:biVC animated:YES];
        }
            break;
        case 103:
        {
            // 品牌介绍
            BranksIntroductionViewController *biVC = [[BranksIntroductionViewController alloc] init];
            biVC.introductionContent = [NSString stringWithFormat:@"%@",model.fd_discountCoupons[@"preferentialDescription"]];
            [self.navigationController pushViewController:biVC animated:YES];
        }
            break;
        case 104:
        {
            JoinDetailMoreViewController * joinMore = [[JoinDetailMoreViewController alloc] init];
            joinMore.brandId = _brandId;
            [self.navigationController pushViewController:joinMore animated:YES];
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

#pragma mark -- 相册
-(void)tapClick:(UITapGestureRecognizer *)tap
{
    NSLog(@"相册");
    
    //    FullScreenViewController *fsVC = [[FullScreenViewController alloc] init];
    //    fsVC.imagesFrom = 1;
    //    fsVC.paramID = model.fd_brandId;
    //    fsVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //    UINavigationController *nav_houseLookingVC = [[UINavigationController alloc]initWithRootViewController:fsVC];
    //
    //    [self presentViewController:nav_houseLookingVC animated:YES completion:nil];
    // 新
    AllPhotoViewController *apVC = [[AllPhotoViewController alloc] init];
    apVC.imageFrom = 1;
    apVC.paramID =model.fd_brandId ;//model.fd_brandId[@"houseId"];
    apVC.imageDict =model.fd_imageList; //model.hd_images;
    
    apVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UINavigationController *nav_houseLookingVC = [[UINavigationController alloc]initWithRootViewController:apVC];
    
    [self presentViewController:nav_houseLookingVC animated:YES completion:nil];
}

#pragma mark -- 立即领取按钮
-(void)receiveBtn:(UIButton *)btn
{
    
    NSLog(@"领取优惠券");
    if (![model.fd_discountCoupons isEqual:[NSNull null]]){
        
        if ([btn.titleLabel.text isEqualToString:@"立即领取"]) {
            
            [self requestReceive];
        }
        else
        {
            /*
             GetCouponViewController *gcVC = [[GetCouponViewController alloc] init];
             gcVC.brankName = model.fd_brandName;
             gcVC.discountCoupons = model.fd_discountCoupons;*/
#warning mark 我要加盟
            
            NSDictionary *dic = model.fd_discountCoupons;
            IWantToJoinViewController *goVc = [[IWantToJoinViewController alloc]init];
            goVc.brandId = self.brandId;
            goVc.brandStr = model.fd_brandName;
            goVc.discount = [NSString stringWithFormat:@"%@折加盟优惠",dic[@"discount"]];
            NSLog(@"%@",model.fd_discountCoupons);
            [self.navigationController pushViewController:goVc animated:YES];
            //            NormalJoinMoreViewController *vc = [[NormalJoinMoreViewController alloc]init];
            //            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else{
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"抱歉，暂不可加盟" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    
    
}

-(void)requestReceive
{
    NSDictionary * discount = dictData[@"discountCoupons"];
    
    NSDictionary * dict_lq = @{@"brandCustomerCategoryId":dictData[@"industryCategoryId"],
                               @"brandIndustryCategoryId1":dictData[@"industryCategoryId1"],
                               @"brandIndustryCategoryId2":dictData[@"industryCategoryId2"],
                               @"brandInvestmentAmountCategoryId":dictData[@"investmentAmountCategoryId"],
                               @"code":@"",
                               @"company":@"",
                               @"discountId":discount[@"discountId"],
                               @"gender":@1,
                               @"operateBrand":@"",
                               @"phone":@"",
                               @"postCategoryId":dictData[@"characterCategoryId"],
                               @"realName":@"",
                               @"storeAddress":@"",
                               @"userHistory":@"",
                               @"addressImage":@""};
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brandUserDiscountCoupons/add.do" params:dict_lq success:^(id JSON) {
        
        NSLog(@"%@",JSON);
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:JSON[@"message"] delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        if ([JSON[@"status"] integerValue]== 1) {
            [receiveBtn setTitle:@"我要加盟" forState:UIControlStateNormal];
            JoinBottomBtn * button_b = (JoinBottomBtn *)[view_b viewWithTag:202];
            [button_b setTitle:@"我要加盟" forState:UIControlStateNormal];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (![comArray isEqual:[NSNull null]]) {
        NSString *contentText = comArray[indexPath.row][@"description"];
        CGSize contentSize = [Tools_F countingSize:contentText fontSize:13*1.1 width:viewWidth-40];
        return contentSize.height+75;
    }
    else
    {
        return 0.01;
    }
    
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
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
    EvalutaionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
    
    if (cell == nil) {
        //当不存在的时候用重用标识符生成
        cell = [[EvalutaionTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
        cell.userType = 1;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
    }
    
    if (![comArray isEqual:[NSNull null]]) {
        // 头像
        [cell.avatar sd_setImageWithURL:[NSURL URLWithString:[comArray[indexPath.row][@"icon"] isEqual:[NSNull null]]?
                                         @"":comArray[indexPath.row][@"icon"]]];
        cell.nickname.text = [comArray[indexPath.row][@"realName"] isEqual:[NSNull null]]?
        @"":comArray[indexPath.row][@"realName"];
        cell.starRate.scorePercent = [comArray[indexPath.row][@"avgScore"] floatValue]/5;
        
        NSString *contentText = comArray[indexPath.row][@"description"];
        CGSize contentSize = [Tools_F countingSize:contentText fontSize:13 width:viewWidth-40];
        cell.comment.frame = CGRectMake(8, CGRectGetMaxY(cell.avatar.frame)+8, viewWidth-16, contentSize.height);
        cell.comment.text = contentText;
        
        cell.commentTime.frame = CGRectMake(8, CGRectGetMaxY(cell.comment.frame)+5, viewWidth-16, 11);
        cell.commentTime.text = [Tools_F timeTransform:[comArray[indexPath.row][@"addTime"] intValue] time:seconds];
        
        
    }
    return cell;
}



#pragma mark - 马上点评
- (void)evaluationClick:(UIButton *)btn{
    
    NSLog(@"马上点评");
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else {
        RecommendViewController *rVC = [[RecommendViewController alloc] init];
        rVC.brandId = _brandId;
        [self.navigationController pushViewController:rVC animated:YES];
    }
}

#pragma mark - 设置导航条
- (void)setupNav{
    
    [self setNav:@"更多品牌详情"];
    
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
#pragma mark - 分享
- (void)GRshareBtn{
    
    [ShareHelper shareIn:self content:[NSString stringWithFormat:@"投资额度%@\n优惠:%@",model.fd_investmentAmountCategoryName,model.fd_discountCoupons[@"maxPreferentialStr"]] url:[NSString stringWithFormat:@"http://www.91sydc.com/user_mobile/web/bannerShare.do?brandId=%@",_brandId] image:model.fd_defaultImage title:model.fd_brandName];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
