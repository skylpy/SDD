//
//  DirectNormalViewController.m
//  SDD
//  普通直营
//  Created by mac on 15/12/29.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "DirectNormalViewController.h"
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
#import "GroupRentViewController.h"
#import "IWantToJoinViewController.h"  //我要加盟
#import "DirectNormalMoreViewController.h"
#import "HouseDetailTitle.h"
#import "HouseRecommend.h"
#import "JoinRecommendButton.h"

#import "DynamicListViewController.h"
#import "PropertyDescriptionViewController.h"
#import "InvestmentAnalysisViewController.h"
#import "JoinAdvantageViewController.h"
#import "AllPhotoViewController.h"
#import "HouseConsultant.h"
@interface DirectNormalViewController ()<UITableViewDataSource,UITableViewDelegate>
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
    //    品牌介绍
    UILabel * introduceDalail;
    
    //    市场前景
    UILabel * markIntroduceDalail;
    //   品牌客服
    HouseConsultant *consultantContent;
}
@property (retain,nonatomic)NSMutableArray * totalArr;
@end

@implementation DirectNormalViewController
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
                               @"适合人群",
                               @"成立时间",
                               ];
    
    [dic setObject:baseInfoTitle forKey:@"baseInfoTitle"];
    
    NSArray *baseInfoContent =  @[
                                  [model.fd_industryCategoryName isKindOfClass:[NSNull class]]?@"暂无":[NSString stringWithFormat:@"%@",model.fd_industryCategoryName],
                                  [model.fd_regionalLocationCategoryName isKindOfClass:[NSNull class]]?@"暂无":[NSString stringWithFormat:@"%@",model.fd_regionalLocationCategoryName],
                                  [model.fd_areaCategoryName isKindOfClass:[NSNull class]]?@"暂无":[NSString stringWithFormat:@"%@",model.fd_areaCategoryName],
                                  [model.fd_cooperationPeriodCategoryName isKindOfClass:[NSNull class]]?@"暂无":[NSString stringWithFormat:@"%@",model.fd_cooperationPeriodCategoryName],
                                  [model.fd_shopModelCategoryName isKindOfClass:[NSNull class]]?@"暂无":[NSString stringWithFormat:@"%@",model.fd_shopModelCategoryName],
                                  [model.fd_brandPositioningCategoryName isKindOfClass:[NSNull class]]? @"暂无":[NSString stringWithFormat:@"%@",model.fd_brandPositioningCategoryName],
                                  [model.fd_companyName isKindOfClass:[NSNull class]]?@"暂无":[NSString stringWithFormat:@"%@",model.fd_companyName],
                                  [model.fd_expandingRegion isKindOfClass:[NSNull class]]?@"暂无":[NSString stringWithFormat:@"%@",model.fd_expandingRegion],
                                  [model.preferredProperty isKindOfClass:[NSNull class]]?@"暂无":[NSString stringWithFormat:@"%@",model.preferredProperty],
                                  //                                  model.fd_propertyUsageCategoryName == nil?@"暂无":[NSString stringWithFormat:@"%@",model.fd_propertyUsageCategoryName]
                                  [model.suitableGroup isKindOfClass:[NSNull class]]?@"暂无":[NSString stringWithFormat:@"%@",model.suitableGroup],
                                  [model.foundedTime intValue] <=0?@"暂无":[NSString stringWithFormat:@"%@",[Tools_F timeTransform:[model.foundedTime intValue] time:days]]
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
    //    bg_scrollView.backgroundColor = bgColor;
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
    // 图片尺寸设定
    NSString *cutString = [NSString stringWithCurrentString:model.fd_defaultImage SizeWidth:viewWidth*2];
    
    [_headImage sd_setImageWithURL:[NSURL URLWithString:cutString] placeholderImage:[UIImage imageNamed:@"loading_b"]];
    
    [contentView addSubview:_headImage];
    
    _headImage.userInteractionEnabled = YES;
    _headImage.tag = 100;
    //
    
    
    //
    
    UILabel *_headImage_lable = [[UILabel alloc] init];
    _headImage_lable.backgroundColor = [UIColor blackColor];
    _headImage_lable.alpha = 0.7;
    [_headImage addSubview:_headImage_lable];
    
    [_headImage_lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_headImage.mas_bottom).with.offset(0);
        make.left.equalTo(contentView.mas_left).with.offset(0);
        make.width.equalTo(contentView.mas_width).with.offset(0);
        make.height.equalTo(@40);
    }];
    
    UILabel *franchiseesName = [[UILabel alloc] init];
    franchiseesName.font = largeFont;
    franchiseesName.text = model.fd_storeName;
    franchiseesName.textColor = [UIColor whiteColor];
    [_headImage addSubview:franchiseesName];
    
    UILabel *maxPreferentialStr = [[UILabel alloc] init];
    maxPreferentialStr.font = midFont;
    maxPreferentialStr.textColor = [UIColor whiteColor];
    
    [_headImage addSubview:maxPreferentialStr];
    
    [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_top);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 200));
    }];
    
    [franchiseesName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_headImage.mas_bottom).with.offset(-15);
        make.left.equalTo(contentView.mas_left).with.offset(8);
        make.width.equalTo(contentView.mas_width).with.offset(-16);
    }];
    [maxPreferentialStr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_headImage.mas_bottom).with.offset(0);
        make.left.equalTo(contentView.mas_left).with.offset(8);
        make.width.equalTo(contentView.mas_width).with.offset(-16);
    }];
    
    
    if (![model.fd_discountCoupons isEqual:[NSNull null]]) {
        
        maxPreferentialStr.text = model.fd_discountCoupons[@"maxPreferentialStr"];
    }
    
    
    UIView *headViewLabel;
    UIView *headViewLabel1;
    
    NSArray *headTitle = @[@"投资额度",@"已收藏",@"已申请"];
    NSArray *headNums = @[model.fd_investmentAmountCategoryName,model.fd_collectionQty,model.fd_joinedQty];
    for (int i=0; i<3; i++) {
        
        UILabel *labelHead = [[UILabel alloc] initWithFrame:CGRectMake(i*(viewWidth/3), 218, viewWidth/3, 20)];
        labelHead.font = titleFont_15;
        //        labelHead.textColor = lgrayColor;
        labelHead.textAlignment = NSTextAlignmentCenter;
        labelHead.text = [NSString stringWithFormat:@"%@",headNums[i]];
        
        [contentView addSubview:labelHead];
        
        UILabel *labelHead1 = [[UILabel alloc] initWithFrame:CGRectMake(i*(viewWidth/3), CGRectGetMaxY(labelHead.frame), viewWidth/3, 20)];
        labelHead1.font = midFont;
        labelHead1.textColor = lgrayColor;
        labelHead1.textAlignment = NSTextAlignmentCenter;
        labelHead1.text = headTitle[i];
        
        [contentView addSubview:labelHead1];
        
        UIView *headCutOff2 = [[UIView alloc] initWithFrame:CGRectMake(i*(viewWidth/3), 218, 0.5, 40)];
        headCutOff2.backgroundColor = divisionColor;
        [contentView addSubview:headCutOff2];
        
        //        [labelHead mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        //            make.top.equalTo(headCutOff.mas_bottom).with.offset(8);
        //            make.left.equalTo(contentView.mas_left).with.offset(8);
        //            make.right.equalTo(contentView.mas_right).with.offset(-8);
        //            make.height.mas_equalTo(@13);
        //        }];
        headViewLabel = labelHead;
        headViewLabel1 = labelHead1;
    }
    
    
    UILabel * label_num = [[UILabel alloc] init];
    //    label_num.backgroundColor = [UIColor blackColor];
    //    label_num.alpha = 0.7;
    label_num.font = midFont;
    label_num.textAlignment = NSTextAlignmentCenter;
    label_num.textColor = [UIColor whiteColor];
    [_headImage addSubview:label_num];
    [label_num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_headImage.mas_bottom).with.offset(-15);
        make.right.equalTo(_headImage.mas_right).with.offset(0);
        //make.left.equalTo(_headImage.mas_left).with.offset(0);
        make.width.equalTo(@80);
    }];
    label_num.text = [NSString stringWithFormat:@"1/%ld",_totalArr.count];
    
    
    /*------------------------------ 基本信息 ------------------------------*/
    //中间横背景横线
    UIView * bgViewtop = [[UIView alloc] init];
    bgViewtop.backgroundColor = bgColor;
    [contentView addSubview:bgViewtop];
    [bgViewtop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headViewLabel1.mas_bottom).with.offset(10);
        make.left.equalTo(contentView.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
    }];
    
    
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
    UIView * upLastView ;
    for (int i=0; i<2; i++) {
        
        UILabel *label = [[UILabel alloc] init];
        label.font = midFont;
        label.textColor = lgrayColor;
        label.text = [NSString stringWithFormat:@"%@: %@",dict[@"baseInfoTitle"][i],dict[@"baseInfoContent"][i]];
        
        [contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(upLastView? upLastView.mas_bottom:bgViewtop.mas_bottom).with.offset(8);
            make.left.equalTo(contentView.mas_left).with.offset(8);
            make.right.equalTo(contentView.mas_right).with.offset(-8);
            make.height.mas_equalTo(@13);
        }];
        upLastView = label;
    }
    
    //    下划线
    UIView *cutOff = [[UIView alloc] init];
    cutOff.backgroundColor = divisionColor;
    [contentView addSubview:cutOff];
    [cutOff mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(upLastView.mas_bottom).with.offset(8);
        make.left.equalTo(@10);
        make.right.mas_equalTo(contentView.mas_right).offset(-10);
        make.height.equalTo(@1);
    }];
    
    
    UIView * lastView ;
    for (int i=2; i<11; i++) {
        
        UILabel *label = [[UILabel alloc] init];
        label.font = midFont;
        label.textColor = lgrayColor;
        label.text = [NSString stringWithFormat:@"%@: %@",dict[@"baseInfoTitle"][i],dict[@"baseInfoContent"][i]];
        
        [contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(lastView? lastView.mas_bottom:cutOff.mas_bottom).with.offset(8);
            make.left.equalTo(contentView.mas_left).with.offset(8);
            make.right.equalTo(contentView.mas_right).with.offset(-8);
            make.height.mas_equalTo(@13);
        }];
        lastView = label;
    }
    
    
//    /*------------------------------ 最新动态 ------------------------------*/
//    
//    //中间横背景横线
//    UIView * bgView1 = [[UIView alloc] init];
//    bgView1.backgroundColor = bgColor;
//    [contentView addSubview:bgView1];
//    [bgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(lastView.mas_bottom).with.offset(10);
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
    /*------------------------------ 品牌介绍 ------------------------------*/
    
    //中间横背景横线
    UIView * bgView2 = [[UIView alloc] init];
    bgView2.backgroundColor = bgColor;
    [contentView addSubview:bgView2];
    [bgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastView.mas_bottom).with.offset(10);
        make.left.equalTo(contentView.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
    }];
    
    UIImageView * image_rl3 = [[UIImageView alloc] init];
    image_rl3.image = [UIImage imageNamed:@"gray_rightArrow"];
    [contentView addSubview:image_rl3];
    [image_rl3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView2.mas_bottom).with.offset(18);
        make.right.equalTo(contentView.mas_right).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(5, 10));
    }];
    
    UILabel * introduceLabel = [[UILabel alloc] init];
    introduceLabel.text = @"品牌介绍";
    introduceLabel.font = largeFont;
    introduceLabel.tag = 102;
    introduceLabel.userInteractionEnabled = YES;
    [contentView addSubview:introduceLabel];
    [introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView2.mas_bottom).with.offset(13);
        make.left.equalTo(contentView.mas_left).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 20));
    }];
    
    
    
    UITapGestureRecognizer *introTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taplabelClick:)];
    [introduceLabel addGestureRecognizer:introTap];
    
    UIView * lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = bgColor;
    [contentView addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(introduceLabel.mas_bottom).with.offset(13);
        make.left.equalTo(contentView.mas_left).with.offset(10);
        make.right.equalTo(contentView.mas_right).with.offset(-10);
        make.height.equalTo(@1);
    }];
    
    introduceDalail = [[UILabel alloc] init];
    introduceDalail.text = model.fd_brandDescription;
    introduceDalail.font = midFont;
    introduceDalail.textColor = lgrayColor;
    introduceDalail.numberOfLines = 2;
    [contentView addSubview:introduceDalail];
    [introduceDalail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView1.mas_bottom).with.offset(13);
        make.left.equalTo(contentView.mas_left).with.offset(10);
        make.right.equalTo(contentView.mas_right).with.offset(-10);
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
        
        make.top.equalTo(introduceDalail.mas_bottom).with.offset(10);
        make.height.equalTo(@24);
        make.width.equalTo(contentView.mas_width);
    }];
    
    
    
    /*------------------------------ 市场前景 ------------------------------*/
    
    //中间横背景横线
    UIView * markBgView = [[UIView alloc] init];
    markBgView.backgroundColor = bgColor;
    [contentView addSubview:markBgView];
    [markBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(drawButton.mas_bottom).with.offset(10);
        make.left.equalTo(contentView.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
    }];
    ;
    
    UILabel * markIntroduceLabel = [[UILabel alloc] init];
    markIntroduceLabel.text = @"市场前景";
    markIntroduceLabel.font = largeFont;
    markIntroduceLabel.tag = 120;
    markIntroduceLabel.userInteractionEnabled = YES;
    [contentView addSubview:markIntroduceLabel];
    [markIntroduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(markBgView.mas_bottom).with.offset(13);
        make.left.equalTo(contentView.mas_left).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 20));
    }];
    
    
    
    //    UITapGestureRecognizer *introTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taplabelClick:)];
    //    [introduceLabel addGestureRecognizer:introTap];
    
    UIView * lineView19 = [[UIView alloc] init];
    lineView19.backgroundColor = bgColor;
    [contentView addSubview:lineView19];
    [lineView19 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(markIntroduceLabel.mas_bottom).with.offset(13);
        make.left.equalTo(contentView.mas_left).with.offset(10);
        make.right.equalTo(contentView.mas_right).with.offset(-10);
        make.height.equalTo(@1);
    }];
    
    markIntroduceDalail = [[UILabel alloc] init];
    markIntroduceDalail.text =[model.marketOutlook isEqual:[NSNull null]]?@"": model.marketOutlook;
    markIntroduceDalail.font = midFont;
    markIntroduceDalail.textColor = lgrayColor;
    markIntroduceDalail.numberOfLines = 2;
    [contentView addSubview:markIntroduceDalail];
    [markIntroduceDalail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView19.mas_bottom).with.offset(13);
        make.left.equalTo(contentView.mas_left).with.offset(10);
        make.right.equalTo(contentView.mas_right).with.offset(-10);
    }];
    
    UIButton *markDrawButton = [[UIButton alloc] init];
    //    _drawButton.backgroundColor = [UIColor redColor];
    [markDrawButton setImage:[UIImage imageNamed:@"icon-chevron-down"] forState:UIControlStateNormal];
    [markDrawButton setImage:[UIImage imageNamed:@"icon-chevron-up"] forState:UIControlStateSelected];
    [markDrawButton setTitle:@"查看更多信息" forState:UIControlStateNormal];
    [markDrawButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, viewWidth - 15-120-180)];
    [markDrawButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, viewWidth - 15 - 90)];
    markDrawButton.tag = 901;
    [markDrawButton addTarget:self action:@selector(drawClick:) forControlEvents:UIControlEventTouchUpInside];
    [markDrawButton setTitle:@"收起" forState:UIControlStateSelected];
    markDrawButton.titleLabel.font = midFont;
    
    [markDrawButton setTitleColor:dblueColor forState:UIControlStateNormal];
    [contentView addSubview:markDrawButton];
    [markDrawButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(markIntroduceDalail.mas_bottom).with.offset(10);
        make.height.equalTo(@24);
        make.width.equalTo(contentView.mas_width);
    }];
    
    
    /*------------------------------ 可加盟区域 ------------------------------*/
    //中间横背景横线
    UIView * bgView15 = [[UIView alloc] init];
    bgView15.backgroundColor = bgColor;
    [contentView addSubview:bgView15];
    [bgView15 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(markDrawButton.mas_bottom).with.offset(10);
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
    annualplanLabel.text = @"可加盟区域";
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
    
    UILabel * annualplanDalail = [[UILabel alloc] init];
    
    annualplanDalail.font = midFont;
    if (![model.fd_expandingRegion isEqual:[NSNull null]]) {
        
        annualplanDalail.text = model.fd_expandingRegion;
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
    
    
    
    /*------------------------------ 品牌点评 ------------------------------*/
    
    //中间横背景横线
    UIView * bgView5 = [[UIView alloc] init];
    bgView5.backgroundColor = bgColor;
    [contentView addSubview:bgView5];
    [bgView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(annualplanDalail.mas_bottom).with.offset(10);
        make.left.equalTo(contentView.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
    }];
    
    UIImageView * image_rl6 = [[UIImageView alloc] init];
    image_rl6.image = [UIImage imageNamed:@"gray_rightArrow"];
    [contentView addSubview:image_rl6];
    [image_rl6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView5.mas_bottom).with.offset(18);
        make.right.equalTo(contentView.mas_right).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(5, 10));
    }];
    
    UILabel * BrandreviewLabel = [[UILabel alloc] init];
    BrandreviewLabel.text = @"品牌点评";
    BrandreviewLabel.font = largeFont;
    BrandreviewLabel.tag = 111;
    BrandreviewLabel.userInteractionEnabled = YES;
    [contentView addSubview:BrandreviewLabel];
    [BrandreviewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView5.mas_bottom).with.offset(13);
        make.left.equalTo(contentView.mas_left).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 20));
    }];
    
    UITapGestureRecognizer * tap_br = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taplabelClick:)];
    [BrandreviewLabel addGestureRecognizer:tap_br];
    
    UIView * lineView4 = [[UIView alloc] init];
    lineView4.backgroundColor = bgColor;
    [contentView addSubview:lineView4];
    [lineView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(BrandreviewLabel.mas_bottom).with.offset(13);
        make.left.equalTo(contentView.mas_left).with.offset(10);
        make.right.equalTo(contentView.mas_right).with.offset(-10);
        make.height.equalTo(@1);
    }];
    
    
    evaluationContent = [[HouseEvaluation alloc] init];
    evaluationContent.evaluationTable.tag = 200;
    evaluationContent.evaluationTable.scrollEnabled = NO;
    evaluationContent.evaluationTable.delegate = self;
    evaluationContent.evaluationTable.dataSource = self;
    
    [evaluationContent.evaluationButton addTarget:self action:@selector(evaluationClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSLog(@"%@",dictData[@"comment"][@"commentList"]);
    
    float devaluationContent_h = 140.f;
    if (![dictData[@"comment"][@"commentList"] isEqual:[NSNull null]]) {
        if ([dictData[@"comment"][@"commentList"] count] != 0) {
            // 未对数据
            NSDictionary * dic = dictData[@"comment"][@"commentList"][0];
            
            evaluationContent.totalStar.scorePercent = [dic[@"avgScore"] floatValue]/5;//[dic[@"avgScore"] floatValue]/5
            evaluationContent.totalScore.text = [NSString stringWithFormat:@"%.1f分",[dic[@"avgScore"] floatValue]];
            evaluationContent.scoreDetail.text = [NSString stringWithFormat:@"价格%.1f分 地段%.1f分 配套%.1f分 交通%.1f分 政策%.1f分 竞争%.1f分",
                                                  [dic[@"priceScore"] floatValue],
                                                  [dic[@"areaScore"] floatValue],
                                                  [dic[@"supportingScore"] floatValue],
                                                  [dic[@"trafficScore"] floatValue],
                                                  [dic[@"policyScore"] floatValue],
                                                  [dic[@"competeScore"] floatValue]];
            
            //devaluationContent_h = 270.f;
            devaluationContent_h = 230.f;
        }
        
    }
    
    
    [contentView addSubview:evaluationContent];
    [evaluationContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView4.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, devaluationContent_h));
    }];
    
    /*------------------------------ 品牌联系人 ------------------------------*/
    
    //中间横背景横线
    UIView * bgView6 = [[UIView alloc] init];
    bgView6.backgroundColor = bgColor;
    [contentView addSubview:bgView6];
    [bgView6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(evaluationContent.mas_bottom).with.offset(10);
        make.left.equalTo(contentView.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
    }];
    
    UIImageView * image_rl7 = [[UIImageView alloc] init];
    image_rl7.image = [UIImage imageNamed:@"gray_rightArrow"];
    [contentView addSubview:image_rl7];
    [image_rl7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView6.mas_bottom).with.offset(18);
        make.right.equalTo(contentView.mas_right).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(5, 10));
    }];
    
    UILabel * BrandconsultantLabel = [[UILabel alloc] init];
    BrandconsultantLabel.text = @"品牌联系人";
    BrandconsultantLabel.font = largeFont;
    [contentView addSubview:BrandconsultantLabel];
    [BrandconsultantLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView6.mas_bottom).with.offset(13);
        make.left.equalTo(contentView.mas_left).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 20));
    }];
    
    
    UIView * lineView5 = [[UIView alloc] init];
    lineView5.backgroundColor = bgColor;
    [contentView addSubview:lineView5];
    [lineView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(BrandconsultantLabel.mas_bottom).with.offset(13);
        make.left.equalTo(contentView.mas_left).with.offset(10);
        make.right.equalTo(contentView.mas_right).with.offset(-10);
        make.height.equalTo(@1);
    }];
    
    
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
    [contentView addSubview:contactWayContent];
    
    
    [contactWayContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView5.mas_bottom).with.offset(10);
        make.left.equalTo(contentView.mas_left).with.offset(30);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 150));
    }];
    
    
    
    
    /*------------------------------ 品牌客服 ------------------------------*/
    
    //中间横背景横线
    UIView * bgView8 = [[UIView alloc] init];
    bgView8.backgroundColor = bgColor;
    [contentView addSubview:bgView8];
    [bgView8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contactWayContent.mas_bottom).with.offset(10);
        make.left.equalTo(contentView.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
    }];
    //
    //
    HouseDetailTitle *houseParaTitle = [[HouseDetailTitle alloc] init];
    houseParaTitle.theTitle.text = @"品牌客服";
    houseParaTitle.tag = 101;
    houseParaTitle.userInteractionEnabled =YES;
    [contentView addSubview:houseParaTitle];
    //
    consultantContent = [[HouseConsultant alloc] init];
    consultantContent.consultantTable.tag = 300;
    consultantContent.consultantTable.delegate = self;
    consultantContent.consultantTable.dataSource = self;
    consultantContent.consultantTable.scrollEnabled = NO;        // 禁滑
    consultantContent.consultantTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    float consultantTitle_h = 0;
    float consultantContent_h = 0;
    if (![model.consultantList isEqual:[NSNull null]]) {
        
        houseParaTitle.theTitle.text = [NSString stringWithFormat:@"品牌客服"];//,[model.hd_consultantList count]
        consultantTitle_h = 40;
        consultantContent_h = [model.consultantList count]<2?[model.consultantList count]*70:2*70;
    }
    //
    //
    [houseParaTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView8.mas_bottom).offset(10);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, consultantTitle_h));
    }];
    //
    [contentView addSubview:consultantContent];
    [consultantContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(houseParaTitle.mas_bottom);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, consultantContent_h));
    }];
    //
    
    
    
    
    /*------------------------------ 查看更多 ------------------------------*/
    
    //中间横背景横线
    UIView * bgView81 = [[UIView alloc] init];
    bgView81.backgroundColor = bgColor;
    [contentView addSubview:bgView81];
    [bgView81 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(consultantContent.mas_bottom).with.offset(10);
        make.left.equalTo(contentView.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
    }];
    
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
        make.top.equalTo(bgView81.mas_bottom).offset(0);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 40));
    }];
    
    
    //    //中间横背景横线
    UIView * bgView25 = [[UIView alloc] init];
    bgView25.backgroundColor = bgColor;
    [contentView addSubview:bgView25];
    [bgView25 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(checkMore.mas_bottom).with.offset(0);
        make.left.equalTo(contentView.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
    }];
    
    // 自动scrollview高度
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(bgView25.mas_bottom).with.offset(45);
    }];
    
    
    /*------------------------------ 底部按钮 ------------------------------*/
    view_b = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight-108, viewWidth, 45)];
    view_b.backgroundColor = bgColor;
    [self.view addSubview:view_b];
    
    
    NSArray * butt_bArr =@[@"全国热线",@"品牌热线",@"",@""];
    NSArray * btn_image = @[@"icon-hotline1",@"house_counselor_1",@"house_counselor_3",@"house_counselor_4"];
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
            
            [button_b setTitle:@"找场地" forState:UIControlStateNormal];
            button_b.width = viewWidth/2;
        }
        if (i==3) {
            button_b.hidden = YES;
        }
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
        case 1000:
        {
            DirectNormalMoreViewController *preVC = [[DirectNormalMoreViewController alloc] init];
            preVC.brandId = self.brandId;
            preVC.brandType = self.brandType;
            [self.navigationController pushViewController:preVC animated:YES];
            
        }break;
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
            case 202:
            {
                GroupRentViewController * groupRentVC = [[GroupRentViewController alloc] init];
                
                groupRentVC.activityCategoryId = 2;
                //                groupRentVC.regionId = regionId;
                [self.navigationController pushViewController:groupRentVC animated:true];
            }
                break;
                
                
            case 203:
            {
                InvestmentViewController * investVC = [[InvestmentViewController alloc] init];
                investVC.brandId = _brandId;
                [self.navigationController pushViewController:investVC animated:true];
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
                        
                        GetCouponViewController *gcVC = [[GetCouponViewController alloc] init];
                        gcVC.brankName = model.fd_brandName;
                        gcVC.discountCoupons = model.fd_discountCoupons;
                        [self.navigationController pushViewController:gcVC animated:YES];
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
- (void)drawClick:(UIButton *)btn{
    
    switch (btn.tag) {
        case 900:
        {
            
            if (!btn.selected) {
                [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, viewWidth - 15-60-80)];
                [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, viewWidth - 15 - 50)];
                introduceDalail.numberOfLines = 0;
            }else{
                
                introduceDalail.numberOfLines = 2;
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
                markIntroduceDalail.numberOfLines = 0;
            }else{
                
                markIntroduceDalail.numberOfLines = 2;
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
            [self.navigationController pushViewController:goVc animated:YES];
            
//            IWantToJoinViewController *goVc = [[IWantToJoinViewController alloc]init];
//            goVc.brandId = self.brandId;
//            [self.navigationController pushViewController:goVc animated:YES];
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
    
    
    if (tableView.tag == 300) {
        return 70;
    }
    if (tableView.tag == 200) {
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
    return 130;
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == 300) {
        if ([model.consultantList isEqual:[NSNull null]]) {
            return 0;
        }
        return [model.consultantList count]<2?[model.consultantList count]:2;
    }
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
            
            NSDictionary *dict = model.consultantList[indexPath.row];
            
            [cell.avatar sd_setImageWithURL:dict[@"icon"] placeholderImage:[UIImage imageNamed:@"defaultAvatar_icon_"]];
            cell.nickname.text = [NSString stringWithFormat:@"%@",dict[@"realName"]];
            //            cell.starRate.scorePercent = [dict[@"avgScore"] floatValue]/5;
            cell.comment.text = @"商多多品牌经理";
            [cell.makeCall addTarget:self action:@selector(callWithConsultant:) forControlEvents:UIControlEventTouchUpInside];
            [cell.makeContact addTarget:self action:@selector(chat:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
        
    }
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


#pragma mark - 招商顾问电话
- (void)callWithConsultant:(UIButton *)btn{
    
    // 获得indexpath
    ConsultantTableViewCell *cell = (ConsultantTableViewCell *)btn.superview;
    NSIndexPath *indexPath = [consultantContent.consultantTable indexPathForCell:cell];
    
    NSDictionary *dict = model.consultantList[indexPath.row];
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
        
        NSDictionary *dict = model.consultantList[indexPath.row];
        
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
        cvc.projectName = model.fd_brandName;
        [self.navigationController pushViewController:cvc animated:true];
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
