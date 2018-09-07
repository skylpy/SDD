//
//  InspectViewController.m
//  SDD
//  考察团
//  Created by mac on 16/1/6.
//  Copyright (c) 2016年 jofly. All rights reserved.
//

#import "InspectViewController.h"
#import "LPYModelTool.h"
#import "TopInspectView.h"
#import "UIImageView+WebCache.h"
#import "ItineraryView.h"
#import "GroupPurchaseTableViewCell.h"
#import "ActiveProcessView.h"
#import "AtlasOfActivity.h"
#import "ShareHelper.h"
#import "SponsorView.h"
#import "GRDetailViewController.h"
#import "GRDetailNViewController.h"
#import "ThemeApplyViewController.h"
#import "ShopPhotoViewController.h"
#import "IspectVPhotoViewController.h"
#import "SignUpViewController.h"

@interface InspectViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>{

    
    /*- ui -*/
    
    UIScrollView *bg_scrollView;
    
    NSDictionary * InspectDic;
    
    ActiveProcessView * ActiveProcess;
    float  attractInvestmentWebTitle_h;
    
    float sponsorFloat_h;
    
    float disclaimerFloat_h;
    
    SponsorView * sponsorView;
    SponsorView * disclaimerView;
    
    NSInteger selIndex;
    
    NSString * sponsorStr;
    NSString * disclaimerStr;
    
    NSInteger todayD;
}

@end

@implementation InspectViewController

//请求数据
-(void)requestData{

    [self showLoading:2];
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/activityShowings/detail.do" params:@{@"activityShowingsId":_model.activityId} success:^(id JSON) {
        
        NSLog(@"%@=====%@",JSON[@"message"],JSON);
        if (![JSON[@"data"] isEqual:[NSNull null]]) {
            
            InspectDic = JSON[@"data"];
        }
        NSLog(@"%@",InspectDic);
        [self hideLoading];
        [self setupUI];
        
    } failure:^(NSError *error) {
        
        [self hideLoading];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    
    NSDate *datenow = [NSDate date];  // 获取现在时间
    todayD = (NSInteger)[datenow timeIntervalSince1970];
    
    attractInvestmentWebTitle_h = 0;
    sponsorFloat_h = 150;
    disclaimerFloat_h = 150;
    selIndex = 0;
    sponsorStr = @"展开";
    disclaimerStr = @"展开";
    [self setupNav];
    [self requestData];
}
- (void)GRshareBtn{
    
    [ShareHelper shareIn:self content:[NSString stringWithFormat:@"%@/n%@",[Tools_F timeTransform:[_model.time intValue] time:minutes],_model.addressShort] url:[NSString stringWithFormat:@"http://www.91sydc.com/user_mobile/web/appActivity.do?activityForumsId=%@",_model.activityId] image:_model.icon title:_model.title];
    
}
-(void)setupNav{
    
    [self setNav:_titles];
    
    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
    share.frame = CGRectMake(0, 0, 19, 20);
    [share setBackgroundImage:[UIImage imageNamed:@"分享-图标"] forState:UIControlStateNormal];
    [share addTarget:self action:@selector(GRshareBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barShare = [[UIBarButtonItem alloc]initWithCustomView:share];
    self.navigationItem.rightBarButtonItems = @[barShare];
}
#pragma mark -- 考察团UI
-(void)setupUI{

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
    
    if (selIndex == 1) {
        
        [bg_scrollView setContentOffset:CGPointMake(0, 1000) animated:YES];
    }else if (selIndex == 2){
    
        [bg_scrollView setContentOffset:CGPointMake(0, 1000) animated:YES];
        
    }else if(selIndex == 3){
    
        [bg_scrollView setContentOffset:CGPointMake(0, 1000) animated:YES];
    }else if(selIndex == 4){
    
        [bg_scrollView setContentOffset:CGPointMake(0, 1000) animated:YES];
    }
    
    /*------------------------------ 顶部图+基本参数 ------------------------------*/
    TopInspectView * topInspect = [[TopInspectView alloc] init];
    topInspect.backgroundColor = [UIColor whiteColor];
    [topInspect.topImage sd_setImageWithURL:[NSURL URLWithString:InspectDic[@"activityShowings"][@"icon"]] placeholderImage:[UIImage imageNamed:@"cell_loading"]];
    topInspect.userInteractionEnabled = YES;
    topInspect.topImage.userInteractionEnabled = YES;
    topInspect.topImage.tag = 1000;
    UITapGestureRecognizer * taptop = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageVClick:)];
    [topInspect.topImage addGestureRecognizer:taptop];
    
    NSMutableAttributedString * SponsorStr = [Tools_F transitionString:@"主办单位" andStr:InspectDic[@"activityShowings"][@"organizers"]];
    topInspect.SponsorLable.attributedText = SponsorStr;
    
    NSMutableAttributedString * AssistingStr = [Tools_F transitionString:@"协办单位" andStr:InspectDic[@"activityShowings"][@"coorganizers"]];
    topInspect.AssistingLable.attributedText = AssistingStr;
    
    NSString * ActivityStr = [Tools_F timeTransform:[InspectDic[@"activityShowings"][@"time"] intValue] time:seconds];
    Tools_F * tool_f = [[Tools_F alloc] init];
    NSString * week = [tool_f featureWeekdayWithDate:ActivityStr];
    NSString * timeWeek = [NSString stringWithFormat:@"%@(%@)",ActivityStr,week];
    
    NSMutableAttributedString * ActivityTimeStr = [Tools_F transitionString:@"活动时间" andStr:timeWeek];
    topInspect.ActivityTimeLable.attributedText = ActivityTimeStr;
    
    NSMutableAttributedString * CollectionSiteStr = [Tools_F transitionString:@"集合地点" andStr:InspectDic[@"activityShowings"][@"address"]];
    topInspect.CollectionSiteLable.attributedText = CollectionSiteStr;
    
    topInspect.DeadlineLable.text = [NSString stringWithFormat:@"报名截止时间：%@",[Tools_F timeTransform:[InspectDic[@"activityShowings"][@"signupTime"] intValue] time:hours]];
    
    
    NSMutableAttributedString * SignUpStr = [Tools_F transitionString:@"已报名" andStr:[NSString stringWithFormat:@"%@人",InspectDic[@"activityShowings"][@"signupQty"]]];
    topInspect.SignUpLable.attributedText = SignUpStr;
    
    topInspect.icondImage.image = [UIImage imageNamed:@"act-tip-rigsting"];
    topInspect.iconsImage.image = [UIImage imageNamed:@"act-tip-rigsting"];
    [contentView addSubview:topInspect];
    [topInspect mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(contentView.mas_top);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 280));
        
    }];
    
    /*------------------------------ 考察路线 ------------------------------*/
    ItineraryView * itineView = [[ItineraryView alloc] init];
    itineView.backgroundColor = [UIColor whiteColor];
    itineView.table.delegate = self;
    itineView.table.dataSource = self;
    
    [contentView addSubview:itineView];
    [itineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(topInspect.mas_bottom).with.offset(10);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 100*[InspectDic[@"houses"] count]+45));
        
    }];
    
    /*------------------------------ 活动流程 ------------------------------*/
    ActiveProcess = [[ActiveProcessView alloc] init];
    [ActiveProcess.webView loadHTMLString:InspectDic[@"activityShowings"][@"activityProcess"] baseURL:nil];
    //ActiveProcess.webView.delegate = self;
    
    ActiveProcess.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:ActiveProcess];
    [ActiveProcess mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(itineView.mas_bottom).with.offset(10);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 370));
        
    }];
    
    /*------------------------------ 活动图集 ------------------------------*/
    AtlasOfActivity * atlasView = [[AtlasOfActivity alloc] init];
    atlasView.backgroundColor = [UIColor whiteColor];

    float atlasView_h = 0;
    float atlasView_t = 0;
    int i = 0;
    if (![InspectDic[@"images"] isEqual:[NSNull null]]) {
        
        for (NSDictionary * dic in InspectDic[@"images"]) {
            
            UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(i*130, 0, 121, 90)];
            [imageV sd_setImageWithURL:[NSURL URLWithString:dic[@"imageUrl"]] placeholderImage:
             [UIImage imageNamed:@"cell_loading"]];
            imageV.tag = 1000+i;
            [atlasView.scrollView addSubview:imageV];
            imageV.userInteractionEnabled = YES;
            UITapGestureRecognizer * tapImaV = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageVClick:)];
            [imageV addGestureRecognizer:tapImaV];

            i ++;
        }
        atlasView_h = [InspectDic[@"images"] count] == 0? 0:135 ;
        atlasView_t = [InspectDic[@"images"] count] == 0? 0:10 ;
        atlasView.titleLabel.text = [InspectDic[@"images"] count] == 0? @"":@"活动图集";
    }
    atlasView.scrollView.contentSize = CGSizeMake([InspectDic[@"images"] count]*130, 90);
    [contentView addSubview:atlasView];
    [atlasView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(ActiveProcess.mas_bottom).with.offset(atlasView_t);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, atlasView_h));
        
    }];
    
    /*------------------------------ 主办单位介绍 ------------------------------*/
    sponsorView = [[SponsorView alloc] init];
    float sponsorView_t = 0;
    if (![InspectDic[@"activityShowings"][@"organizersDescription"] isEqualToString:@""]) {
        [sponsorView.webView loadHTMLString:InspectDic[@"activityShowings"][@"organizersDescription"] baseURL:nil];
        sponsorView_t = 10;
        sponsorView.titleLabel.text = @"主办单位介绍";
    }else{
        sponsorFloat_h = 0;
        sponsorView_t = 0;
    }
    
    sponsorView.backgroundColor = [UIColor whiteColor];
    [sponsorView.selBtn setTitle:sponsorStr forState:UIControlStateNormal];
    [sponsorView.selBtn addTarget:self action:@selector(selBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    sponsorView.selBtn.tag = 1000;
    sponsorView.selBtn.selected = sponsorFloat_h == 150? NO:YES;
    [contentView addSubview:sponsorView];
    [sponsorView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(atlasView.mas_bottom).with.offset(sponsorView_t);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, sponsorFloat_h));
        
    }];
    
    /*------------------------------ 免责声明 ------------------------------*/
    disclaimerView = [[SponsorView alloc] init];
    
    float disclaimerView_t = 0;
    if (![InspectDic[@"activityShowings"][@"disclaimer"] isEqualToString:@""]) {
        [disclaimerView.webView loadHTMLString:InspectDic[@"activityShowings"][@"disclaimer"] baseURL:nil];
        disclaimerView_t = 10;
        disclaimerView.titleLabel.text = @"免责声明";
    }else{
        disclaimerFloat_h = 0;
        disclaimerView_t = 0;
        disclaimerStr = @"";
        disclaimerView.selBtn.enabled = NO;
    }
    
    
    disclaimerView.backgroundColor = [UIColor whiteColor];
    [disclaimerView.selBtn setTitle:disclaimerStr forState:UIControlStateNormal];
    [disclaimerView.selBtn addTarget:self action:@selector(selBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    disclaimerView.selBtn.tag = 1001;
    disclaimerView.selBtn.selected = disclaimerFloat_h == 150? NO:YES;
    [contentView addSubview:disclaimerView];
    [disclaimerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(sponsorView.mas_bottom).with.offset(disclaimerView_t);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, disclaimerFloat_h));
        
    }];
    
    
    // 自动scrollview高度
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(disclaimerView.mas_bottom).with.offset(55);
    }];
    
    /*------------------------------ 底部按钮 ------------------------------*/

    UIView *  botView = [[UIView alloc] init];
    botView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:botView];
    
    [botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 55));
    }];
    
    UIButton *callButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    NSString * strleft = todayD - [_model.signupTime integerValue] < 0 ? ([_model.isSignup integerValue] == 0 ?@"立即报名":@"已报名"):@"已结束";
    callButton.enabled = todayD - [_model.signupTime integerValue] < 0 ? ([_model.isSignup integerValue] == 0 ?YES:NO):NO;
    
    UIColor *callColor = todayD - [_model.signupTime integerValue] < 0 ?([_model.isSignup integerValue] == 0 ?tagsColor:lgrayColor):lgrayColor;
    
    [callButton setTitle:strleft forState:UIControlStateNormal];
    [callButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [callButton setBackgroundColor:callColor];
    [callButton addTarget:self action:@selector(takePhone:) forControlEvents:UIControlEventTouchUpInside];
    //[callButton setBackgroundColor:tagsColor];
    [Tools_F setViewlayer:callButton cornerRadius:5 borderWidth:1 borderColor:callColor];
    [botView addSubview:callButton];
    
    [callButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(botView.mas_top).with.offset(5);
        make.bottom.equalTo(botView.mas_bottom).with.offset(-5);
        make.left.equalTo(botView.mas_left).with.offset(20);
        make.right.equalTo(botView.mas_right).with.offset(-20);
    }];
    
    
}
#pragma  mark -- 展开
-(void)selBtnClick:(UIButton *)btn{
    
    NSLog(@"111");
    if (btn == sponsorView.selBtn) {
        selIndex = sponsorView.selBtn.selected == NO?1:2;
        sponsorFloat_h = sponsorView.selBtn.selected == NO?400:150;
        sponsorStr = sponsorView.selBtn.selected == NO?@"收起":@"展开";
    }else{
        selIndex = disclaimerView.selBtn.selected == NO?3:4;
        disclaimerFloat_h = disclaimerView.selBtn.selected == NO?600:150;
        disclaimerStr = disclaimerView.selBtn.selected == NO?@"收起":@"展开";
    }
    
    [bg_scrollView removeFromSuperview];
    [self setupUI];
}
#pragma mark -- 报名
-(void)takePhone:(UIButton *)btn{

    NSString *confromTimespStr = [Tools_F timeTransform:[InspectDic[@"activityShowings"][@"signupTime"] intValue] time:minutes];
    SignUpViewController * thVc = [[SignUpViewController alloc] init];
    thVc.actNum = 2;
    
    
    thVc.model = _model;
    thVc.confromTimespStr = confromTimespStr;
    
    thVc.str2 = _model.addressShort;
    
    thVc.str1 = _model.title;
    
    thVc.temDic = InspectDic;
    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;
    [self.navigationController pushViewController:thVc animated:YES];

}


#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

#pragma mark - 设置行数 (tableView)
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [InspectDic[@"houses"] count];
}

#pragma mark - 设置section 头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

#pragma mark - 设置section 脚高
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    //重用标识符
    static NSString *identifier = @"RentAndBuy";
    //重用机制
    GroupPurchaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
    
    if(cell == nil){
        //当不存在的时候用重用标识符生成
        cell = [[GroupPurchaseTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
    }
    
    
    cell.cellType = index_gr;
    
    NSDictionary * dictModel = InspectDic[@"houses"][indexPath.row];
    
    // 图片
//    NSString *tmpStr = [NSString stringWithCurrentString:dictModel[@"defaultImage"] SizeWidth:80*2];        // 请求适应图片
    [cell.placeImage sd_setImageWithURL:[NSURL URLWithString:dictModel[@"defaultImage"]] placeholderImage:[UIImage imageNamed:@"cell_loading"]];
    // 地名
    cell.placeTitle.text = [NSString stringWithFormat:@"%@",dictModel[@"houseName"]];
    
    // 招商对象
    cell.placeAdd.text = [NSString stringWithFormat:@"业态:%@",dictModel[@"planFormat"]];
    cell.teamImg.image = [UIImage imageNamed:@"index_btn_rent_tag"];
    // 招商状态
    // 状态
    NSString *merchantsStatus;
    switch ([dictModel[@"merchantsStatus"] intValue]) {
        case 1:
        {
            merchantsStatus = @"状态: 意向登记期";
        }
            break;
        case 2:
        {
            merchantsStatus = @"状态: 意向金收取期";
        }
            break;
        case 3:
        {
            merchantsStatus = @"状态: 转定签约期";
        }
            break;
        case 4:
        {
            merchantsStatus = @"状态: 已开业";
        }
            break;
        default:
        {
            merchantsStatus = @"状态: 未定";
        }
            break;
    }
    
    cell.placeDiscount.text = merchantsStatus;
    // 抵价
    cell.placePrice.text = dictModel[@"rentPreferentialContent"] == [NSNull null] ? @"暂无":dictModel[@"rentPreferentialContent"];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary * dictModel = InspectDic[@"houses"][indexPath.row];
    if ([dictModel[@"activityCategoryId"] integerValue] != 2) {
        
        GRDetailNViewController *grDetail = [[GRDetailNViewController alloc] init];
        grDetail.activityCategoryId = @"2";
        grDetail.houseID = dictModel[@"houseId"];
        grDetail.type = 0;
        [self.navigationController pushViewController:grDetail animated:YES];
    }
    else {
        
        GRDetailViewController *grDetail = [[GRDetailViewController alloc] init];
        grDetail.activityCategoryId = @"2";
        grDetail.houseID = dictModel[@"houseId"];
        grDetail.type = 2;
        [self.navigationController pushViewController:grDetail animated:YES];
    }
}



//点击相册
#pragma mark --点击相册
-(void)imageVClick:(UITapGestureRecognizer *)tap{

    NSLog(@"sdfdsfds");
    NSMutableArray * arrImage = [[NSMutableArray alloc] init];
    if (![InspectDic[@"images"] isEqual:[NSNull null]]) {
        
        for (NSDictionary * dic in InspectDic[@"images"]) {
        
            [arrImage addObject:dic[@"imageUrl"]];
        }
    }
    
    IspectVPhotoViewController * shVc = [[IspectVPhotoViewController alloc] init];
    shVc.imageArr = arrImage;
    shVc.index = tap.view.tag - 1000;
    [self.navigationController pushViewController:shVc animated:YES];
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
