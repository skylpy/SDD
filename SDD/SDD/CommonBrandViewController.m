//
//  JoinDatailBrandViewController.m
//  SDD
//
//  Created by mac on 15/10/13.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "CommonBrandViewController.h"
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
#import "HouseDetailTitle.h"
#import "HouseRecommend.h"
#import "JoinRecommendButton.h"

#import "DynamicListViewController.h"
#import "PropertyDescriptionViewController.h"
#import "InvestmentAnalysisViewController.h"
#import "JoinAdvantageViewController.h"

#import "AllPhotoViewController.h"

@interface CommonBrandViewController ()<UITableViewDataSource,UITableViewDelegate>
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
}

@property (retain,nonatomic)NSMutableArray * totalArr;
@end

@implementation CommonBrandViewController

//-(NSMutableArray *)totalArr
//{
//    if (!_totalArr) {
//        _totalArr = [[NSMutableArray alloc] init];
//    }
//    return _totalArr;
//}

-(void)viewWillAppear:(BOOL)animated
{
    [self requestData];
}

#pragma mark - 请求数据
- (void)requestData{
    
    [bg_scrollView removeFromSuperview];     // 移除原有视图
    [bottomView removeFromSuperview];
    
    NSLog(@"%@",_brandId);
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
    
    /*------------------------------ 顶部图+基本参数 ------------------------------*/
    
    UIImageView *_headImage = [[UIImageView alloc] init];
    _headImage.userInteractionEnabled = YES;
    // 图片尺寸设定
    NSString *cutString = [NSString stringWithCurrentString:model.fd_defaultImage SizeWidth:viewWidth*2];
    
    [_headImage sd_setImageWithURL:[NSURL URLWithString:cutString] placeholderImage:[UIImage imageNamed:@"loading_b"]];
    
    [contentView addSubview:_headImage];
    
    
    
    UILabel *franchiseesName = [[UILabel alloc] init];
    franchiseesName.font = largeFont;
    franchiseesName.text = model.fd_storeName;
    [contentView addSubview:franchiseesName];
    
    [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_top);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 200));
    }];
    
    [franchiseesName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImage.mas_bottom).with.offset(10);
        make.left.equalTo(contentView.mas_left).with.offset(8);
        make.width.equalTo(contentView.mas_width).with.offset(-16);
    }];
    
    UIView *lastView;
    NSArray *titleArr = @[[NSString stringWithFormat:@"投资金额%@",model.fd_investmentAmountCategoryName],
                          //                          [NSString stringWithFormat:@"%@人已关注",model.fd_collectionQty],
                          //[NSString stringWithFormat:@"%@人加盟成功",model.fd_joinedQty]
                          ];
    NSArray *iconArr = @[@"join_detail-pages_icon_investment-amount",
                         //@"join_detail-pages_icon_attention",
                         //                         @"join_detail-pages_icon_join"
                         ];
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
    UIImageView * imageNum = [[UIImageView alloc] init];
    [imageNum sd_setImageWithURL:[NSURL URLWithString:model.fd_defaultImage] placeholderImage:[UIImage imageNamed:@"loading_b"]];
    imageNum.userInteractionEnabled = YES;
    imageNum.tag = 100;
    [contentView addSubview:imageNum];
    [imageNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImage.mas_bottom).with.offset(10);
        make.right.equalTo(contentView.mas_right).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(100, 65));
    }];
    
    UITapGestureRecognizer * tap_xc = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [imageNum addGestureRecognizer:tap_xc];
    
    
    UILabel * label_num = [[UILabel alloc] init];
    label_num.backgroundColor = [UIColor blackColor];
    label_num.alpha = 0.7;
    label_num.font = midFont;
    label_num.textAlignment = NSTextAlignmentCenter;
    label_num.textColor = [UIColor whiteColor];
    [imageNum addSubview:label_num];
    [label_num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(imageNum.mas_bottom).with.offset(0);
        make.right.equalTo(imageNum.mas_right).with.offset(0);
        make.left.equalTo(imageNum.mas_left).with.offset(0);
    }];
    label_num.text = [NSString stringWithFormat:@"共%ld张",_totalArr.count];
    /*------------------------------ 最新动态 ------------------------------*/
    
    //中间横背景横线
    UIView * bgView1 = [[UIView alloc] init];
    bgView1.backgroundColor = bgColor;
    [contentView addSubview:bgView1];
    [bgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageNum.mas_bottom).with.offset(10);
        make.left.equalTo(contentView.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
    }];
    
    UIImageView * image_rl2 = [[UIImageView alloc] init];
    image_rl2.image = [UIImage imageNamed:@"gray_rightArrow"];
    [contentView addSubview:image_rl2];
    [image_rl2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView1.mas_bottom).with.offset(18);
        make.right.equalTo(contentView.mas_right).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(5, 10));
    }];
    
    UILabel * dynamicLabel = [[UILabel alloc] init];
    dynamicLabel.text = @"最新动态";
    dynamicLabel.font = largeFont;
    [contentView addSubview:dynamicLabel];
    [dynamicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView1.mas_bottom).with.offset(13);
        make.left.equalTo(contentView.mas_left).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 20));
    }];
    
    
    
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = bgColor;
    [contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dynamicLabel.mas_bottom).with.offset(13);
        make.left.equalTo(contentView.mas_left).with.offset(10);
        make.right.equalTo(contentView.mas_right).with.offset(-10);
        make.height.equalTo(@1);
    }];
    
    UILabel * dynamicDalail = [[UILabel alloc] init];
    dynamicDalail.font = midFont;
    dynamicDalail.textColor = lgrayColor;
    dynamicDalail.numberOfLines = 3;
    [contentView addSubview:dynamicDalail];
    [dynamicDalail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).with.offset(13);
        make.left.equalTo(contentView.mas_left).with.offset(10);
        //make.size.mas_equalTo(CGSizeMake(viewWidth-20, 10));
        make.right.equalTo(contentView.mas_right).with.offset(-10);
    }];
    
    NSLog(@"%@",dictData[@"dynamicList"]);
    if ([dictData[@"dynamicList"] count]>0) {
        NSDictionary * dict_dy = dictData[@"dynamicList"][0];
        dynamicDalail.text = dict_dy[@"description"];
    }
    
    /*------------------------------ 品牌介绍 ------------------------------*/
    
    //中间横背景横线
    UIView * bgView2 = [[UIView alloc] init];
    bgView2.backgroundColor = bgColor;
    [contentView addSubview:bgView2];
    [bgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dynamicDalail.mas_bottom).with.offset(10);
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
    
    UILabel * introduceDalail = [[UILabel alloc] init];
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
    
    
    
    /*------------------------------ 网点分布 ------------------------------*/
    
//    //中间横背景横线
//    UIView * bgView4 = [[UIView alloc] init];
//    bgView4.backgroundColor = bgColor;
//    [contentView addSubview:bgView4];
//    [bgView4 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(introduceDalail.mas_bottom).with.offset(10);
//        make.left.equalTo(contentView.mas_left).with.offset(0);
//        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
//    }];
//    
//    UIImageView * image_rl5 = [[UIImageView alloc] init];
//    image_rl5.image = [UIImage imageNamed:@"gray_rightArrow"];
//    [contentView addSubview:image_rl5];
//    [image_rl5 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bgView4.mas_bottom).with.offset(18);
//        make.right.equalTo(contentView.mas_right).with.offset(-20);
//        make.size.mas_equalTo(CGSizeMake(5, 10));
//    }];
//    
//    UILabel * branchesLabel = [[UILabel alloc] init];
//    branchesLabel.text = @"网点分布";
//    branchesLabel.font = largeFont;
//    branchesLabel.tag = 106;
//    branchesLabel.userInteractionEnabled = YES;
//    [contentView addSubview:branchesLabel];
//    [branchesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bgView4.mas_bottom).with.offset(13);
//        make.left.equalTo(contentView.mas_left).with.offset(10);
//        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 20));
//    }];
//    
//    UITapGestureRecognizer * tap_brche = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taplabelClick:)];
//    [branchesLabel addGestureRecognizer:tap_brche];
//    
//    UIView * lineView3 = [[UIView alloc] init];
//    lineView3.backgroundColor = bgColor;
//    [contentView addSubview:lineView3];
//    [lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(branchesLabel.mas_bottom).with.offset(13);
//        make.left.equalTo(contentView.mas_left).with.offset(10);
//        make.right.equalTo(contentView.mas_right).with.offset(-10);
//        make.height.equalTo(@1);
//    }];
//    
//    UIView * view_branche = [[UIView alloc] init];
//    [contentView addSubview:view_branche];
//    [view_branche mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(lineView3.mas_bottom).with.offset(10);
//        make.left.equalTo(contentView.mas_left).with.offset(10);
//        make.right.equalTo(contentView.mas_right).with.offset(-10);
//        make.height.equalTo(@40);
//    }];
//    
//    if ([dictData[@"regionList"] count] > 4) {
//        
//        for (int i = 0; i < 4; i ++) {
//            
//            NSDictionary * dict_btnV = dictData[@"regionList"][i];
//            
//            NSLog(@"%@",dict_btnV);
//            
//            UIButton * btn_V = [UIButton buttonWithType:UIButtonTypeSystem];
//            btn_V.frame = CGRectMake(10+i*((viewWidth-20)/4), 5, 60, 25);
//            btn_V.backgroundColor = bgColor;
//            [view_branche addSubview:btn_V];
//            [btn_V setTitle:dict_btnV[@"regionName"] forState:UIControlStateNormal];
//            [btn_V setTitleColor:lgrayColor forState:UIControlStateNormal];
//            btn_V.layer.cornerRadius = 5;
//            btn_V.clipsToBounds = YES;
//            btn_V.titleLabel.font = midFont;
//        }
//    }
//    else
//    {
//        for (int i = 0; i < [dictData[@"regionList"] count]; i ++) {
//            
//            NSDictionary * dict_btnV = dictData[@"regionList"][i];
//            
//            NSLog(@"%@",dict_btnV);
//            
//            UIButton * btn_V = [UIButton buttonWithType:UIButtonTypeSystem];
//            btn_V.frame = CGRectMake(10+i*((viewWidth-20)/([dictData[@"regionList"] count])), 5, 60, 25);
//            btn_V.backgroundColor = bgColor;
//            [view_branche addSubview:btn_V];
//            [btn_V setTitle:dict_btnV[@"regionName"] forState:UIControlStateNormal];
//            [btn_V setTitleColor:lgrayColor forState:UIControlStateNormal];
//            btn_V.layer.cornerRadius = 5;
//            btn_V.clipsToBounds = YES;
//            btn_V.titleLabel.font = midFont;
//        }
//    }
    
    
    /*------------------------------ 品牌点评 ------------------------------*/
    
    //中间横背景横线
    UIView * bgView5 = [[UIView alloc] init];
    bgView5.backgroundColor = bgColor;
    [contentView addSubview:bgView5];
    [bgView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(introduceDalail.mas_bottom).with.offset(10);
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
    
    /*------------------------------ 品牌顾问 ------------------------------*/
    
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
    BrandconsultantLabel.text = @"品牌顾问";
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
    //    [NSString stringWithFormat:@"%@",model.fd_address]
    //    [model.fd_tel stringByReplacingCharactersInRange:NSMakeRange(6, 10) withString:@"*"]
    [contentView addSubview:contactWayContent];
    
    
    [contactWayContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView5.mas_bottom).with.offset(10);
        make.left.equalTo(contentView.mas_left).with.offset(30);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 150));
    }];
    
    
//    //------------------------------ 相关品牌推荐 ------------------------------
//    
//    //中间横背景横线
//    UIView * bgView7 = [[UIView alloc] init];
//    bgView7.backgroundColor = bgColor;
//    [contentView addSubview:bgView7];
//    [bgView7 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(contactWayContent.mas_bottom).with.offset(10);
//        make.left.equalTo(contentView.mas_left).with.offset(0);
//        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
//    }];
//    
//    UIImageView * image_rl8 = [[UIImageView alloc] init];
//    image_rl8.image = [UIImage imageNamed:@"gray_rightArrow"];
//    [contentView addSubview:image_rl8];
//    [image_rl8 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bgView7.mas_bottom).with.offset(18);
//        make.right.equalTo(contentView.mas_right).with.offset(-20);
//        make.size.mas_equalTo(CGSizeMake(5, 10));
//    }];
//    
//    
//    
//    UILabel * BrandrecommendationLabel = [[UILabel alloc] init];
//    BrandrecommendationLabel.text = @"相关品牌推荐";
//    BrandrecommendationLabel.font = largeFont;
//    [contentView addSubview:BrandrecommendationLabel];
//    [BrandrecommendationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bgView7.mas_bottom).with.offset(13);
//        make.left.equalTo(contentView.mas_left).with.offset(10);
//        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 20));
//    }];
//    
//    
//    UIView * lineView6 = [[UIView alloc] init];
//    lineView6.backgroundColor = bgColor;
//    [contentView addSubview:lineView6];
//    [lineView6 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(BrandrecommendationLabel.mas_bottom).with.offset(13);
//        make.left.equalTo(contentView.mas_left).with.offset(10);
//        make.right.equalTo(contentView.mas_right).with.offset(-10);
//        make.height.equalTo(@1);
//    }];
//    
//    float commendation_h = 0;
//    UIView * commendationView = [[UIView alloc] init];
//    [contentView addSubview:commendationView];
//    
//    if ([dictData[@"recommendList"] count] != 0) {
//        
//        for (int i = 0; i < [dictData[@"recommendList"] count]; i ++) {
//            
//        }
//        
//        commendation_h = 150;
//    }
//    
//    [commendationView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(lineView6.mas_bottom);
//        make.left.equalTo(bg_scrollView.mas_left);
//        make.size.mas_equalTo(CGSizeMake(viewWidth, commendation_h));
//    }];
    
    
//    /*------------------------------ 相关项目团租推荐 ------------------------------*/
//    
//    //中间横背景横线
//    UIView * bgView8 = [[UIView alloc] init];
//    bgView8.backgroundColor = bgColor;
//    [contentView addSubview:bgView8];
//    [bgView8 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(commendationView.mas_bottom).with.offset(10);
//        make.left.equalTo(contentView.mas_left).with.offset(0);
//        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
//    }];
//    
//    UIImageView * image_rl9 = [[UIImageView alloc] init];
//    image_rl9.image = [UIImage imageNamed:@"gray_rightArrow"];
//    [contentView addSubview:image_rl9];
//    [image_rl9 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bgView8.mas_bottom).with.offset(18);
//        make.right.equalTo(contentView.mas_right).with.offset(-20);
//        make.size.mas_equalTo(CGSizeMake(5, 10));
//    }];
//    
//    UILabel * BrandrectLabel = [[UILabel alloc] init];
//    BrandrectLabel.text = @"相关项目团租推荐";
//    BrandrectLabel.font = largeFont;
//    [contentView addSubview:BrandrectLabel];
//    [BrandrectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bgView8.mas_bottom).with.offset(13);
//        make.left.equalTo(contentView.mas_left).with.offset(10);
//        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 20));
//    }];
//    
//    
//    UIView * lineView7 = [[UIView alloc] init];
//    lineView7.backgroundColor = bgColor;
//    [contentView addSubview:lineView7];
//    [lineView7 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(BrandrectLabel.mas_bottom).with.offset(13);
//        make.left.equalTo(contentView.mas_left).with.offset(10);
//        make.right.equalTo(contentView.mas_right).with.offset(-10);
//        make.height.equalTo(@1);
//    }];
//    
//    
//    float Rectcommendation_h = 0;
//    UIView * RectcommendationView = [[UIView alloc] init];
//    [contentView addSubview:RectcommendationView];
//    
//    if ([dictData[@"recommendRentList"] count] != 0) {
//        
//        Rectcommendation_h = 150;
//        UIScrollView * scrollView_min = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, Rectcommendation_h)];
//        [RectcommendationView addSubview:scrollView_min];
//        
//        for (int i = 0; i < [dictData[@"recommendRentList"] count]; i ++) {
//            
//            UIView * minView = [[UIView alloc] initWithFrame:CGRectMake(i*95+10, 0, 85, Rectcommendation_h)];
//            //minView.backgroundColor = [UIColor redColor];
//            [scrollView_min addSubview:minView];
//            
//            UIImageView * topImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 85, 45)];
//            [topImage sd_setImageWithURL:[NSURL URLWithString:dictData[@"recommendRentList"][i][@"defaultImage"]] placeholderImage:[UIImage imageNamed:@"loading_b"]];
//            [minView addSubview:topImage];
//            
//            UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 85, 20)];
//            //title.textColor = lgrayColor;
//            title.font = titleFont_15;
//            title.text = dictData[@"recommendRentList"][i][@"houseName"];
//            [minView addSubview:title];
//            
//            UILabel * planFormat = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 85, 15)];
//            planFormat.textColor = lgrayColor;
//            planFormat.font = littleFont;
//            planFormat.text = [NSString stringWithFormat:@"业态：%@",dictData[@"recommendRentList"][i][@"planFormat"]];
//            [minView addSubview:planFormat];
//            
//            UILabel * Status = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 85, 15)];
//            Status.textColor = lgrayColor;
//            Status.font = littleFont;
//            Status.text = [NSString stringWithFormat:@"状态：%@",dictData[@"recommendRentList"][i][@"planFormat"]];
//            [minView addSubview:Status];
//            
//            UILabel * Area = [[UILabel alloc] initWithFrame:CGRectMake(0, 110, 85, 15)];
//            Area.textColor = lgrayColor;
//            Area.font = littleFont;
//            Area.text = [NSString stringWithFormat:@"面积：%@m²",dictData[@"recommendRentList"][i][@"buildingArea"]];
//            [minView addSubview:Area];
//        }
//        scrollView_min.contentSize = CGSizeMake(95*[dictData[@"recommendRentList"] count], Rectcommendation_h);
//        
//        
//    }
//    
//    [RectcommendationView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(lineView7.mas_bottom).with.offset(10);
//        make.left.equalTo(bg_scrollView.mas_left);
//        make.size.mas_equalTo(CGSizeMake(viewWidth, Rectcommendation_h));
//    }];
//    
//    /*------------------------------ 品牌详情 ------------------------------*/
//    //中间横背景横线
//    UIView * bgView9 = [[UIView alloc] init];
//    bgView9.backgroundColor = bgColor;
//    [contentView addSubview:bgView9];
//    [bgView9 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(RectcommendationView.mas_bottom).with.offset(10);
//        make.left.equalTo(contentView.mas_left).with.offset(0);
//        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
//    }];
//    
//    UIImageView * image_rl10 = [[UIImageView alloc] init];
//    image_rl10.image = [UIImage imageNamed:@"gray_rightArrow"];
//    [contentView addSubview:image_rl10];
//    [image_rl10 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bgView9.mas_bottom).with.offset(18);
//        make.right.equalTo(contentView.mas_right).with.offset(-20);
//        make.size.mas_equalTo(CGSizeMake(5, 10));
//    }];
//    
//    UILabel * BranddalielLabel = [[UILabel alloc] init];
//    BranddalielLabel.text = @"品牌详情";
//    BranddalielLabel.font = largeFont;
//    BranddalielLabel.tag = 104;
//    BranddalielLabel.userInteractionEnabled = YES;
//    [contentView addSubview:BranddalielLabel];
//    [BranddalielLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bgView9.mas_bottom).with.offset(13);
//        make.left.equalTo(contentView.mas_left).with.offset(10);
//        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 20));
//    }];
//    
//    UITapGestureRecognizer * tap_brdm = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taplabelClick:)];
//    [BranddalielLabel addGestureRecognizer:tap_brdm];
//    
//    
//    UIView * bgView10 = [[UIView alloc] init];
//    bgView10.backgroundColor = bgColor;
//    [contentView addSubview:bgView10];
//    [bgView10 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(BranddalielLabel.mas_bottom).with.offset(13);
//        make.left.equalTo(contentView.mas_left).with.offset(0);
//        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
//    }];
    

    /*------------------------------ 基本信息 ------------------------------*/
    
    //中间横背景横线
    UIView * bgView8 = [[UIView alloc] init];
    bgView8.backgroundColor = bgColor;
    [contentView addSubview:bgView8];
    [bgView8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contactWayContent.mas_bottom).with.offset(10);
        make.left.equalTo(contentView.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
    }];
    
    HouseDetailTitle *houseParaTitle = [[HouseDetailTitle alloc] init];
    houseParaTitle.theTitle.text = @"基本信息";
    houseParaTitle.tag = 101;
    houseParaTitle.userInteractionEnabled =YES;
    [contentView addSubview:houseParaTitle];
    
    UITapGestureRecognizer *hpTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
    [houseParaTitle addGestureRecognizer:hpTap];
    
    [houseParaTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView8.mas_bottom).with.offset(10);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 40));
    }];
    
    //lastView = nil;
    UIView *lastView8;
    for (int i=0; i<10; i++) {
        
        UILabel *label = [[UILabel alloc] init];
        label.font = midFont;
        label.textColor = lgrayColor;
        label.text = [NSString stringWithFormat:@"%@: %@",dict[@"baseInfoTitle"][i],dict[@"baseInfoContent"][i]];
        
        [contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(lastView8? lastView8.mas_bottom:houseParaTitle.mas_bottom).with.offset(8);
            make.left.equalTo(contentView.mas_left).with.offset(8);
            make.right.equalTo(contentView.mas_right).with.offset(-8);
            make.height.mas_equalTo(@13);
        }];
        lastView8 = label;
    }
    
    
    
    /*------------------------------ 物业要求 ------------------------------*/
    
    //中间横背景横线
    UIView * bgView9 = [[UIView alloc] init];
    bgView9.backgroundColor = bgColor;
    [contentView addSubview:bgView9];
    [bgView9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastView8.mas_bottom).with.offset(10);
        make.left.equalTo(contentView.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
    }];

    
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
        propertyDescriptionTitle_h = 40.f;
        propertyDescriptionContent_h = 85.f;
        propertyDescriptionContent.numberOfLines = 4;
        propertyDescriptionContent.text = [NSString stringWithFormat:@"%@",model.fd_propertyDescription];
    }
    
    [propertyDescriptionTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView9.mas_bottom);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, propertyDescriptionTitle_h));
    }];
    
    [propertyDescriptionContent mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(propertyDescriptionTitle.mas_bottom).with.offset(10);
        make.left.equalTo(contentView.mas_left).with.offset(8);
        make.right.equalTo(contentView.mas_right).with.offset(-8);
        make.height.mas_lessThanOrEqualTo(propertyDescriptionContent_h);
    }];
    
    
    /*------------------------------ 投资分析 ------------------------------*/
    
    //中间横背景横线
//    UIView * bgView10 = [[UIView alloc] init];
//    bgView10.backgroundColor = bgColor;
//    [contentView addSubview:bgView10];
//    [bgView10 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(propertyDescriptionContent.mas_bottom).with.offset(10);
//        make.left.equalTo(contentView.mas_left).with.offset(0);
//        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
//    }];
//    
//    HouseDetailTitle *investmentAnalysisTitle  = [[HouseDetailTitle alloc] init];
//    investmentAnalysisTitle.theTitle.text = @"投资分析";
//    investmentAnalysisTitle.tag = 107;
//    investmentAnalysisTitle.userInteractionEnabled =YES;
//    investmentAnalysisTitle.titleType = haveArrowWithText;
//    [contentView addSubview:investmentAnalysisTitle];
//    
//    UITapGestureRecognizer *iaTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
//    [investmentAnalysisTitle addGestureRecognizer:iaTap];
//    
//    [investmentAnalysisTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(bgView10.mas_bottom);
//        make.left.equalTo(contentView.mas_left);
//        make.size.mas_equalTo(CGSizeMake(viewWidth, 40));
//    }];
//    
//    lastView8 = nil;
//    
//    for (int i=0; i<9; i++) {
//        
//        UILabel *label = [[UILabel alloc] init];
//        label.font = midFont;
//        label.textColor = lgrayColor;
//        label.text = [NSString stringWithFormat:@"%@: %@",dict[@"investmentAnalysisTitle"][i],dict[@"investmentAnalysisContent"][i]];
//        
//        [contentView addSubview:label];
//        [label mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.top.equalTo(lastView8? lastView8.mas_bottom:investmentAnalysisTitle.mas_bottom).with.offset(8);
//            make.left.equalTo(contentView.mas_left).with.offset(8);
//            make.right.equalTo(contentView.mas_right).with.offset(-8);
//            make.height.mas_equalTo(@13);
//        }];
//        lastView8 = label;
//    }
    
    /*------------------------------ 加盟优势 ------------------------------*/
    
    //中间横背景横线
    UIView * bgView11 = [[UIView alloc] init];
    bgView11.backgroundColor = bgColor;
    [contentView addSubview:bgView11];
    [bgView11 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(propertyDescriptionContent.mas_bottom).with.offset(10);
        make.left.equalTo(contentView.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
    }];
    
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
    
    /*------------------------------ 终端展示 ------------------------------*/
    
    //中间横背景横线
    UIView * bgView12 = [[UIView alloc] init];
    bgView12.backgroundColor = bgColor;
    [contentView addSubview:bgView12];
    [bgView12 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(joinAdvantageContent.mas_bottom).with.offset(0);
        make.left.equalTo(contentView.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 10));
    }];
    
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
    
    
    //------------------------------ 相关品牌推荐 ------------------------------
    
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
    image_rl8.image = [UIImage imageNamed:@"gray_rightArrow"];
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
    view_b.userInteractionEnabled = YES;
    [self.view addSubview:view_b];
    
    UIButton * button_b = [UIButton buttonWithType:UIButtonTypeCustom];
    button_b.frame = CGRectMake(0, 0, viewWidth/3, 45);
    button_b.backgroundColor = dblueColor;
    [button_b setTitle:@"品牌热线" forState:UIControlStateNormal];
    //button_b.titleLabel.font = midFont;
    [button_b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button_b.titleLabel.textAlignment = NSTextAlignmentCenter;
    button_b.tag = 300;
    [view_b addSubview:button_b];
    
    [button_b addTarget:self action:@selector(button_brandClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * button_pp = [UIButton buttonWithType:UIButtonTypeCustom];
    button_pp.frame = CGRectMake(viewWidth/3,0, viewWidth/3*2, 45);
    button_pp.backgroundColor = tagsColor;
    [button_pp setTitle:@"立即联系" forState:UIControlStateNormal];
    //button_b.titleLabel.font = midFont;
    [button_pp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button_pp.titleLabel.textAlignment = NSTextAlignmentCenter;
    button_pp.tag = 200;
    [view_b addSubview:button_pp];
    
    [button_pp addTarget:self action:@selector(button_bClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)button_brandClick:(UIButton *)btn{

    NSString *num;
    if (![model.fd_tel400Extra isEqualToString:@""]) {
        
        num = [NSString stringWithFormat:@"telprompt:%@%@",model.fd_tel400,model.fd_tel400Extra];
    }else{
        
        num = [NSString stringWithFormat:@"telprompt:%@",model.fd_tel400];
    }
    NSString *strUrl = [num stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"%@",strUrl);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strUrl]];
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
                cvc.projectName = model.fd_brandName;
                [self.navigationController pushViewController:cvc animated:true];
                
            }
                break;
            case 203:
            {
                InvestmentViewController * investVC = [[InvestmentViewController alloc] init];
                investVC.brandId = _brandId;
                [self.navigationController pushViewController:investVC animated:true];
            }
                break;
            case 300:
            {
            
//                NSString *telNumber = [[NSString alloc] initWithFormat:@"telprompt://%@%@",model.fd_tel400,model.fd_tel400Extra];
//
//                
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telNumber]];
            }
                break;
            default:
            {
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
    apVC.imageFrom = Brand;
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
    if ([btn.titleLabel.text isEqualToString:@"立即领取"]) {
        
        [self requestReceive];
    }
    else
    {
        GetCouponViewController *gcVC = [[GetCouponViewController alloc] init];
        
        gcVC.brankName = model.fd_brandName;
        gcVC.discountCoupons = model.fd_discountCoupons;
        [self.navigationController pushViewController:gcVC animated:YES];
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
            [receiveBtn setTitle:@"立即加盟" forState:UIControlStateNormal];
            JoinBottomBtn * button_b = (JoinBottomBtn *)[view_b viewWithTag:202];
            [button_b setTitle:@"立即加盟" forState:UIControlStateNormal];
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
    

    [ShareHelper shareIn:self content:[NSString stringWithFormat:@"投资额度%@",model.fd_investmentAmountCategoryName] url:[NSString stringWithFormat:@"http://www.91sydc.com/user_mobile/web/bannerShare.do?brandId=%@",_brandId] image:model.fd_defaultImage title:model.fd_brandName];
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
