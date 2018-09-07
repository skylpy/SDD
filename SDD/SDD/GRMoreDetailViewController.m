//
//  GRMoreDetailViewController.m
//  SDD
//
//  Created by hua on 15/8/19.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "GRMoreDetailViewController.h"
#import "HouseDetialViews.h"
#import "ThumbnailButton.h"


#import "AllChildViewController.h"

#import "UUChart.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "ShareHelper.h"
#import "TabButton.h"
#import "NewAppointViewController.h"
#import "PeripheralSupportViewController.h"

@interface GRMoreDetailViewController ()<UIScrollViewDelegate,UUChartDataSource,BMKGeoCodeSearchDelegate,
BMKLocationServiceDelegate>{
    
    /*- data -*/
    
    NSArray *time_X;
    NSArray *house_Y;
    NSArray *region_Y;
    
    /*- ui -*/
    
    UIScrollView *bg_scrollView;
    
    HousePriceSwing *priceSwingContent;
    HouseRecommend *nearContent;
    HouseRecommend *sameContent;
    HouseRecommend *rentContent;
    
    UIView *botView;
}

@end

@implementation GRMoreDetailViewController
@synthesize model;

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 导航条
    [self setupNav];
    // 加载数据
    [self setupUI];
}

#pragma mark - 设置导航条
- (void)setupNav{
    
    [self setNav:@"更多项目详情"];
    
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

#pragma mark - 设置内容
- (void)setupUI{
    
    // 底部滚动
    bg_scrollView = [[UIScrollView alloc] init];
    bg_scrollView.backgroundColor = bgColor;
    [self.view addSubview:bg_scrollView];
    [bg_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 底部view， 用于计算scrollview高度
    UIView* contentView = [[UIView alloc] init];
    contentView.backgroundColor = bgColor;
    [bg_scrollView addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bg_scrollView);
        make.width.equalTo(bg_scrollView);
    }];
    /*------------------------------ 项目介绍 ------------------------------*/
    
    HouseDetailTitle *projectIntroductionTitle = [[HouseDetailTitle alloc] init];
    projectIntroductionTitle.theTitle.text = @"项目介绍";
    projectIntroductionTitle.titleType = haveArrow;
    
    UITapGestureRecognizer *introductionTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
    projectIntroductionTitle.tag = 104;
    projectIntroductionTitle.userInteractionEnabled =YES;
    [projectIntroductionTitle addGestureRecognizer:introductionTap];
    
    UIView *projectIntroductionContent = [[UIView alloc] init];
    projectIntroductionContent.backgroundColor = [UIColor whiteColor];
    
    UILabel *introductionTitle = [[UILabel alloc] init];
    introductionTitle.font = midFont;
    introductionTitle.textColor = mainTitleColor;
    introductionTitle.text = @"楼盘介绍";
    
    UILabel *introductionContent = [[UILabel alloc] init];
    introductionContent.font = midFont;
    introductionContent.textColor = lgrayColor;
    introductionContent.text = [NSString stringWithFormat:@"       %@",model.hd_house[@"houseDescription"]];
    introductionContent.numberOfLines = 0;
    
    [bg_scrollView addSubview:projectIntroductionTitle];
    [projectIntroductionTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bg_scrollView.mas_top);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 40));
    }];
    
    [bg_scrollView addSubview:projectIntroductionContent];
    [projectIntroductionContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(projectIntroductionTitle.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.width.equalTo(bg_scrollView.mas_width);
    }];
    
    [projectIntroductionContent addSubview:introductionTitle];
    [introductionTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(@10);
        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 13));
    }];
    
    [projectIntroductionContent addSubview:introductionContent];
    [introductionContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(introductionTitle.mas_bottom).with.offset(5);
        make.left.equalTo(@10);
        make.width.mas_equalTo(viewWidth-20);
    }];
    
    [projectIntroductionContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(introductionContent.mas_bottom).with.offset(10);
        make.height.lessThanOrEqualTo(@115);
    }];
    /*------------------------------ 周边配套 ------------------------------*/
    
    HouseDetailTitle *findTitle  = [[HouseDetailTitle alloc] init];
    findTitle.theTitle.text = @"周边配套";
    findTitle.titleType = haveArrow;
    
    UITapGestureRecognizer *fhTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
    findTitle.tag = 102;
    findTitle.userInteractionEnabled =YES;
    [findTitle addGestureRecognizer:fhTap];
    
    [bg_scrollView addSubview:findTitle];
    [findTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(projectIntroductionContent.mas_bottom).offset(10);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 40));
    }];
    
    UIView *findContent = [[UIView alloc] init];
    findContent.backgroundColor = [UIColor whiteColor];
    
    [bg_scrollView addSubview:findContent];
    [findContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(findTitle.mas_bottom).offset(0);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 44));
    }];
    
    UIImageView *adsImageView = [[UIImageView alloc] init];
    adsImageView.image = [UIImage imageNamed:@"home_top_map_gray"];
    [findContent addSubview:adsImageView];
    [adsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(findContent.mas_centerY);
        make.left.equalTo(bg_scrollView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    UILabel *adsLabel = [[UILabel alloc] init];
    adsLabel.textColor = mainTitleColor;
    adsLabel.font = midFont;
    adsLabel.text = [NSString stringWithFormat:@"地址: %@",model.hd_house[@"address"]];
    [findContent addSubview:adsLabel];
    [adsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(findContent.mas_centerY);
        make.left.equalTo(adsImageView.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(viewWidth-50, 45));
    }];
    
    /*------------------------------ 租金走势 ------------------------------*/
    
    HouseDetailTitle *priceSwingTitle = [[HouseDetailTitle alloc] init];
    priceSwingTitle.theTitle.text = @"租金走势";
    
    priceSwingContent = [[HousePriceSwing alloc] init];
    
    [self oneYear];
    UUChart *chartView = [[UUChart alloc]initwithUUChartDataFrame:CGRectMake(10, 10, viewWidth*2-40, 0)//165
                                                       withSource:self
                                                        withStyle:UUChartLineStyle];
    [chartView showInView:priceSwingContent.movements_bg];
    priceSwingContent.movementCity.text = [NSString stringWithFormat:@"      ·%@      ·%@",
                                           model.hd_house[@"regionName"],
                                           model.hd_house[@"houseName"]];
    
    [bg_scrollView addSubview:priceSwingTitle];
    [priceSwingTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(findContent.mas_bottom).offset(0);//10
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 0));//40
    }];
    
    [bg_scrollView addSubview:priceSwingContent];
    [priceSwingContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceSwingTitle.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth,0 ));//220
    }];
    
    /*------------------------------ 周边项目 ------------------------------*/
    
    HouseDetailTitle *nearTitle = [[HouseDetailTitle alloc] init];
    nearTitle.theTitle.text = @"周边项目";
    nearTitle.titleType = haveArrow;
    nearTitle.arrowImgView.image = [UIImage imageNamed:@""];
    
//    UITapGestureRecognizer *nearTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
//    nearTitle.tag = 107;
//    nearTitle.userInteractionEnabled = YES;
//    [nearTitle addGestureRecognizer:nearTap];
    
    nearContent = [[HouseRecommend alloc] init];
    
    float nearTitle_h = 0;
    float nearContent_h = 0;
    
    if (![model.hd_surroundingsList isEqual:[NSNull null]]) {
        
        for (int i=0; i<[model.hd_surroundingsList count]; i++) {
            
            NSDictionary *dict = model.hd_surroundingsList[i];
            
            ThumbnailButton *thumbanil = [[ThumbnailButton alloc] initWithFrame:CGRectMake(i*(130), 0, 130, 165)];
            
            thumbanil.tag = 400+i;
            
            thumbanil.imgView.contentMode = UIViewContentModeScaleAspectFill;
            [thumbanil.imgView sd_setImageWithURL:dict[@"defaultImage"] placeholderImage:[UIImage imageNamed:@"square_loading"]] ;
            
            thumbanil.topLabel.text = [NSString stringWithFormat:@"%@",dict[@"houseName"]];
            thumbanil.midLabel.text = [NSString stringWithFormat:@"业态:%@",dict[@"planFormat"]];
            thumbanil.bottomLabel.text = [NSString stringWithFormat:@"建筑面积:%@万m²",dict[@"buildingArea"]];
            [thumbanil addTarget:self action:@selector(nearAndSimilarClick:) forControlEvents:UIControlEventTouchUpInside];
            [nearContent.houseRecommendScrollView addSubview:thumbanil];
            
            nearContent.houseRecommendScrollView.frame = CGRectMake(0, 0, viewWidth, 165);
            nearContent.houseRecommendScrollView.contentSize = CGSizeMake(130+i*(130), 165);
            
            nearTitle_h = 40;
            nearContent_h = 165;
        }
    }
    
    [bg_scrollView addSubview:nearTitle];
    [nearTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceSwingContent.mas_bottom).offset(nearTitle_h==0?0:10);
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
    sameTitle.arrowImgView.image = [UIImage imageNamed:@""];
    
//    UITapGestureRecognizer *similarTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
//    sameTitle.tag = 108;
//    sameTitle.userInteractionEnabled =YES;
//    [sameTitle addGestureRecognizer:similarTap];
    
    sameContent = [[HouseRecommend alloc] init];
    
    float sameTitle_h = 0;
    float sameContent_h = 0;
    
    if (![model.hd_similarsList isEqual:[NSNull null]]) {
        
        for (int i=0; i<[model.hd_similarsList count]; i++) {
            
            NSDictionary *dict = model.hd_similarsList[i];
            
            ThumbnailButton *thumbanil = [[ThumbnailButton alloc] initWithFrame:CGRectMake(i*(130), 0, 130, 165)];
            
            thumbanil.tag = 500+i;
            
            thumbanil.imgView.contentMode = UIViewContentModeScaleAspectFill;
            [thumbanil.imgView sd_setImageWithURL:dict[@"defaultImage"] placeholderImage:[UIImage imageNamed:@"square_loading"]] ;
            
            thumbanil.topLabel.text = [NSString stringWithFormat:@"%@",dict[@"houseName"]];
            thumbanil.midLabel.text = [NSString stringWithFormat:@"业态:%@",dict[@"planFormat"]];
            thumbanil.bottomLabel.text = [NSString stringWithFormat:@"建筑面积:%@万m²",dict[@"buildingArea"]];
            [thumbanil addTarget:self action:@selector(nearAndSimilarClick:) forControlEvents:UIControlEventTouchUpInside];
            [sameContent.houseRecommendScrollView addSubview:thumbanil];
            
            sameContent.houseRecommendScrollView.frame = CGRectMake(0, 0, viewWidth, 165);
            sameContent.houseRecommendScrollView.contentSize = CGSizeMake(130+i*(130), 165);
            
            sameTitle_h = 40;
            sameContent_h = 165;
        }
    }
    
    [bg_scrollView addSubview:sameTitle];
    [sameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nearContent.mas_bottom).offset(sameTitle_h==0?0:10);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, sameTitle_h));
    }];
    
    [bg_scrollView addSubview:sameContent];
    [sameContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sameTitle.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, sameContent_h));
    }];
    
    /*------------------------------ 相关团租推荐 ------------------------------*/
    
    HouseDetailTitle *rentTitle = [[HouseDetailTitle alloc] init];
    rentTitle.theTitle.text = @"相关项目团租推荐";
    rentTitle.titleType = haveArrow;
    rentTitle.arrowImgView.image = [UIImage imageNamed:@""];
    
//    UITapGestureRecognizer *recommendListTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
//    rentTitle.tag = 110;
//    rentTitle.userInteractionEnabled =YES;
//    [rentTitle addGestureRecognizer:recommendListTap];
    
    rentContent = [[HouseRecommend alloc] init];
    
    float rentTitle_h = 0;
    float rentContent_h = 0;
    
    if (![model.hd_rentList isEqual:[NSNull null]]) {
        
        for (int i=0; i<[model.hd_recommendRentList count]; i++) {
            
            NSDictionary *dict = model.hd_recommendRentList[i];
            
            ThumbnailButton *thumbanil = [[ThumbnailButton alloc] initWithFrame:CGRectMake(i*(130), 0, 130, 165)];
            
            thumbanil.tag = 700+i;
            
            thumbanil.imgView.contentMode = UIViewContentModeScaleAspectFill;
            [thumbanil.imgView sd_setImageWithURL:dict[@"defaultImage"] placeholderImage:[UIImage imageNamed:@"square_loading"]] ;
            
            thumbanil.topLabel.text = [NSString stringWithFormat:@"%@",dict[@"houseName"]];
            thumbanil.midLabel.text = [NSString stringWithFormat:@"业态:%@",dict[@"planFormat"]];
            thumbanil.bottomLabel.text = [NSString stringWithFormat:@"建筑面积:%@万m²",dict[@"buildingArea"]];
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
        make.top.equalTo(sameContent.mas_bottom).offset(rentTitle_h==0?0:10);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, rentTitle_h));
    }];
    
    [bg_scrollView addSubview:rentContent];
    [rentContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rentTitle.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, rentContent_h));
    }];
    
    // 自动scrollview高度
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(rentContent.mas_bottom).offset(10);
    }];
    
    /*------------------------------ 底部按钮 ------------------------------*/
    
    botView = [[UIView alloc] init];
    botView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:botView];
    
    [botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 45));
    }];
    
    UIView *cutoffL = [[UIView alloc] init];
    cutoffL.backgroundColor = ldivisionColor;
    [botView addSubview:cutoffL];
    [cutoffL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(botView.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 1));
    }];
    
    // 打电话
    TabButton *callButton = [[TabButton alloc] init];
    callButton.titleLabel.font = littleFont;
    callButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    callButton.isLittle = YES;
    [callButton setTitle:@"全国热线" forState:UIControlStateNormal];
    [callButton setTitleColor:lgrayColor forState:UIControlStateNormal];
    [callButton setImage:[UIImage imageNamed:@"house_counselor_call2"] forState:UIControlStateNormal];
    [callButton addTarget:self action:@selector(takePhone:) forControlEvents:UIControlEventTouchUpInside];
    
    [botView addSubview:callButton];
    [callButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(botView.mas_left);
        make.size.mas_equalTo(CGSizeMake(75, 45));
    }];
    
    UIView *cutoff3 = [[UIView alloc] init];
    cutoff3.backgroundColor = ldivisionColor;
    
    [botView addSubview:cutoff3];
    [cutoff3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(botView.mas_centerY);
        make.left.equalTo(callButton.mas_right);
        make.size.mas_equalTo(CGSizeMake(1, 30));
    }];
    
    //在线咨询
    TabButton *chatButton = [[TabButton alloc] init];
    chatButton.titleLabel.font = littleFont;
    chatButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    chatButton.isLittle = YES;
    [chatButton setTitle:@"项目咨询" forState:UIControlStateNormal];
    [chatButton setTitleColor:lgrayColor forState:UIControlStateNormal];
    [chatButton setImage:[UIImage imageNamed:@"house_counselor_online2"] forState:UIControlStateNormal];
    [chatButton addTarget:self action:@selector(im:) forControlEvents:UIControlEventTouchUpInside];
    
    [botView addSubview:chatButton];
    [chatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(cutoff3.mas_right);
        make.size.mas_equalTo(CGSizeMake(75, 45));
    }];
    
    // 预约看铺
    UIButton *reservationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reservationButton.titleLabel.font = titleFont_15;
    [reservationButton setTitle:@"预约看铺" forState:UIControlStateNormal];
    [reservationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reservationButton setBackgroundImage:[Tools_F imageWithColor:tagsColor
                                                             size:CGSizeMake(1, 1)]
                                 forState:UIControlStateNormal];
    [reservationButton setBackgroundImage:[Tools_F imageWithColor:lblueColor
                                                             size:CGSizeMake(1, 1)]
                                 forState:UIControlStateDisabled];
    [reservationButton addTarget:self action:@selector(bookLookHouse:) forControlEvents:UIControlEventTouchUpInside];
    reservationButton.enabled = [model.hd_house[@"canAppointment"] integerValue] == 1?YES:NO;
    
    [botView addSubview:reservationButton];
    
    // 状态判断
    [reservationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(chatButton.mas_right);
        make.right.equalTo(botView.mas_right);
        make.bottom.equalTo(botView.mas_bottom);
    }];

}
#pragma mark - 底部3按钮方法
- (void)takePhone:(id)sender{
    
    NSString *telNumber = [[NSString alloc] initWithFormat:@"telprompt://%@",@"4009918829"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telNumber]];
}

- (void)im:(id)sender{
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else {
        
        if (![model.hd_consultantList isEqual:[NSNull null]]) {
            
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
}

#pragma mark -- 预约看房
- (void)bookLookHouse:(UIButton *)btn{
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else {
        
        NewAppointViewController *rVC = [[NewAppointViewController alloc] init];
        //ReservationController *rVC = [[ReservationController alloc] init];
        
        rVC.houseName = model.hd_house[@"houseName"];
        rVC.houseID = _houseID;
        rVC.activityCategoryId = 2;
        rVC.isOfficial = YES;
        [self.navigationController pushViewController:rVC animated:YES];
    }
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
    }
    if (![model.hd_priceMap[@"one"][@"region"] isEqual:[NSNull null]]) {
        
        NSMutableArray *muArr = [[NSMutableArray alloc] init];
        
        for (id something in model.hd_priceMap[@"one"][@"region"]) {
            
            if (![something isEqual:[NSNull null]]) {
                
                [muArr addObject:something];
            }
        }
        
        region_Y = muArr;
    }
}

#pragma mark - 走势图@required
// 横坐标标题数组
- (NSArray *)UUChart_xLableArray:(UUChart *)chart{
    
    return time_X;
}

// 数值多重数组
- (NSArray *)UUChart_yValueArray:(UUChart *)chart{
    
    return @[house_Y,region_Y];
}

// 颜色数组
- (NSArray *)UUChart_ColorArray:(UUChart *)chart{
    
    return @[UUGreen,UURed];
}

// 判断显示横线条
- (BOOL)UUChart:(UUChart *)chart ShowHorizonLineAtIndex:(NSInteger)index{
    
    return YES;
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

        }
            break;
        case 102:
        {
//            PeripheralSupportViewController *mapVC = [[PeripheralSupportViewController alloc] init];
//            mapVC.theLatitude = [model.hd_house[@"latitude"] floatValue];
//            mapVC.theLongitude = [model.hd_house[@"longitude"] floatValue];
//            [self.navigationController pushViewController:mapVC animated:YES];
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
        default:
            break;
    }
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

#pragma mark - 周边/同类项目
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
    else if (btn.superview == rentContent.houseRecommendScrollView) {
        
        NSDictionary *dict = model.hd_rentList[(int)btn.tag-700];
        _houseID = [NSString stringWithFormat:@"%@",dict[@"houseId"]];
        
        NSLog(@"相关团租houseid%@",dict);
    }
    
    // block回传
    if (self.returnBlock != nil) {
        
        [self.navigationController popViewControllerAnimated:YES];
        self.returnBlock(_houseID);
    }
}

- (void)valueReturn:(ReturnHouseID)block{
    
    self.returnBlock = block;
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

- (void)GRshareBtn{
    
    [ShareHelper shareIn:self content:@"Hello" url:@"http://www.shangdodo.com"];
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
