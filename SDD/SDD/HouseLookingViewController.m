//
//  HouseLookingViewController.m
//  SDD
//
//  Created by hua on 15/4/11.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "HouseLookingViewController.h"
#import "LabelTextfieldView.h"
#import "GroupPurchaseView.h"
#import "HouseLookingModel.h"

#import "HLApplyViewController.h"
#import "ActivityProcessViewController.h"
#import "MapViewController.h"

#import "UIImageView+WebCache.h"

@interface HouseLookingViewController (){
    
    /* -模型- */
    HouseLookingModel *model;
    
    /* -ui- */
    // 上部分背景
    UIView *topView_bg;
    // 线路介绍
    LabelTextfieldView *introduction;
    // 最高优惠
    LabelTextfieldView *maxPreferential;
    // 均价
    LabelTextfieldView *averagePrice;
    // 所属区域
    LabelTextfieldView *subclass;
    // 看房热线
    LabelTextfieldView *telephoneNum;
    // 截止时间
    UILabel *deadline;
    // 已报名
    UILabel *signUp;
    // cell
    GroupPurchaseView *groupPurchase;
}

@end

@implementation HouseLookingViewController

#pragma mark - 请求数据
- (void)requestData{
    
    // 请求参数
    NSDictionary *dic = @{@"houseShowingsId":_houseShowingsId};
    
    NSString *urlString = [SDD_MainURL stringByAppendingString:@"/house/showings.do"];              // 拼接主路径和请求内容成完整url
    
    [self.httpManager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = responseObject;
        NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
        if (![dict[@"data"] isEqual:[NSNull null]]) {
            
            model = [[HouseLookingModel alloc] init];
            model.hk_activityCategoryId = dict[@"data"][@"activityCategoryId"];
            model.hk_applyPeopleQty = dict[@"data"][@"applyPeopleQty"];
            model.hk_house = dict[@"data"][@"house"];
            model.hk_houseId = dict[@"data"][@"houseId"];
            model.hk_perferentialContent = dict[@"data"][@"perferentialContent"];
            model.hk_price = dict[@"data"][@"price"];
            model.hk_showingsActivityProcess = dict[@"data"][@"showingsActivityProcess"];
            model.hk_showingsEndtime = dict[@"data"][@"showingsEndtime"];
            model.hk_showingsErea = dict[@"data"][@"showingsErea"];
            model.hk_showingsLineIntroduction = dict[@"data"][@"showingsLineIntroduction"];
            model.hk_showingsMaxPreferential = dict[@"data"][@"showingsMaxPreferential"];
            model.hk_showingsTitle = dict[@"data"][@"showingsTitle"];
            model.hk_tel = dict[@"data"][@"tel"];
            model.hk_totalPeopleQty = dict[@"data"][@"totalPeopleQty"];
            model.hk_houseShowingsId = dict[@"data"][@"houseShowingsId"];
            
            [self conntect];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = bgColor;
    
    // 请求数据
    [self requestData];
    // 导航条
    [self setNav:[NSString stringWithFormat:@"%@考察团",_hkTitle]];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    /*        -----第一段-----       */
    
    topView_bg = [[UIView alloc] init];
    topView_bg.frame = CGRectMake(0, 0, viewWidth, 190);
    topView_bg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView_bg];
    
    introduction = [[LabelTextfieldView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(introduction.frame)+8, viewWidth, 13)];
    introduction.titleLabel.font = midFont;
    introduction.titleLabel.textColor = mainTitleColor;
    introduction.titleLabel.text = @"线路介绍:";
    introduction.textField.enabled = NO;
    introduction.textField.font = midFont;
    introduction.textField.textColor = lorangeColor;
    [topView_bg addSubview:introduction];
    
    maxPreferential = [[LabelTextfieldView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(introduction.frame)+8, viewWidth, 13)];
    maxPreferential.titleLabel.font = midFont;
    maxPreferential.titleLabel.textColor = mainTitleColor;
    maxPreferential.titleLabel.text = @"最高优惠:";
    maxPreferential.textField.enabled = NO;
    maxPreferential.textField.font = midFont;
    maxPreferential.textField.textColor = tagsColor;
    [topView_bg addSubview:maxPreferential];
    
    averagePrice = [[LabelTextfieldView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(maxPreferential.frame)+8, viewWidth, 13)];
    averagePrice.titleLabel.font = midFont;
    averagePrice.titleLabel.textColor = mainTitleColor;
    averagePrice.titleLabel.text = @"均       价:";
    averagePrice.textField.enabled = NO;
    averagePrice.textField.font = midFont;
    averagePrice.textField.textColor = lgrayColor;
    [topView_bg addSubview:averagePrice];
    
    subclass = [[LabelTextfieldView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(averagePrice.frame)+8, viewWidth, 13)];
    subclass.titleLabel.font = midFont;
    subclass.titleLabel.textColor = mainTitleColor;
    subclass.titleLabel.text = @"所属区域:";
    subclass.textField.enabled = NO;
    subclass.textField.font = midFont;
    subclass.textField.textColor = lgrayColor;
    [topView_bg addSubview:subclass];
    
    telephoneNum = [[LabelTextfieldView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(subclass.frame)+8, viewWidth, 13)];
    telephoneNum.titleLabel.font = midFont;
    telephoneNum.titleLabel.textColor = mainTitleColor;
    telephoneNum.titleLabel.text = @"看铺热线:";
    telephoneNum.textField.enabled = NO;
    telephoneNum.textField.font = midFont;
    telephoneNum.textField.textColor = lgrayColor;
    [topView_bg addSubview:telephoneNum];
    
    // 立即报名
    ConfirmButton *applyButton = [[ConfirmButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(telephoneNum.frame)+15, viewWidth - 40, 45)
                                                                title:_isApply?@"已报名":@"立即报名"
                                                               target:self
                                                               action:@selector(applyClick:)];
    applyButton.enabled = _isApply?NO:YES;
    [topView_bg addSubview:applyButton];
    
    // 截止时间
    UIImageView *timeIcon = [[UIImageView alloc] init];
    timeIcon.frame = CGRectMake(10, CGRectGetMaxY(applyButton.frame)+15, 10, 10);
    timeIcon.image = [UIImage imageNamed:@"icon_time@2x"];
    [topView_bg addSubview:timeIcon];
    
    deadline = [[UILabel alloc] init];
    deadline.frame = CGRectMake(CGRectGetMaxX(timeIcon.frame)+5, CGRectGetMaxY(applyButton.frame)+15, viewWidth/2, 11);
    deadline.font = littleFont;
    deadline.textColor = lgrayColor;
    [topView_bg addSubview:deadline];
    
    // 已报名
    UIImageView *peopleIcon = [[UIImageView alloc] init];
    peopleIcon.frame = CGRectMake(CGRectGetMaxX(deadline.frame)+10, CGRectGetMaxY(applyButton.frame)+15, 7, 10);
    peopleIcon.image = [UIImage imageNamed:@"icon_renshu@2x"];
    [topView_bg addSubview:peopleIcon];
    
    signUp = [[UILabel alloc] init];
    signUp.frame = CGRectMake(CGRectGetMaxX(peopleIcon.frame)+5, CGRectGetMaxY(applyButton.frame)+15, viewWidth/2-30, 11);
    signUp.font = littleFont;
    signUp.textColor = lgrayColor;
    [topView_bg addSubview:signUp];
    
    topView_bg.frame = CGRectMake(0, 0, viewWidth, CGRectGetMaxY(signUp.frame)+10);
    
    /*        -----第二段-----       */
    
    UIView *midView_bg = [[UIView alloc] init];
    midView_bg.frame = CGRectMake(0, CGRectGetMaxY(topView_bg.frame)+10, viewWidth, 145);
    midView_bg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:midView_bg];
    
    // 线路楼盘
    UILabel *lineHouse = [[UILabel alloc] init];
    lineHouse.frame = CGRectMake(10, 0, viewWidth-20, 45);
    lineHouse.font = largeFont;
    lineHouse.textColor = mainTitleColor;
    lineHouse.text = @"线路楼盘";
    [midView_bg addSubview:lineHouse];
    
    UIView *cutoff = [[UIView alloc] init];
    cutoff.frame = CGRectMake(0, CGRectGetMaxY(lineHouse.frame), viewWidth, 1);
    cutoff.backgroundColor = ldivisionColor;
    [midView_bg addSubview:cutoff];
    
    UIButton *mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mapButton.frame = CGRectMake(viewWidth-95, 7.5, 85, 30);
    mapButton.titleLabel.font = midFont;
    mapButton.backgroundColor = [UIColor whiteColor];
    [mapButton setTitle:@"地图路线" forState:UIControlStateNormal];
    [mapButton setTitleColor:dblueColor forState:UIControlStateNormal];
    [Tools_F setViewlayer:mapButton cornerRadius:5 borderWidth:1 borderColor:dblueColor];
    [mapButton addTarget:self action:@selector(mapLine:) forControlEvents:UIControlEventTouchUpInside];
    [midView_bg addSubview:mapButton];
    
    groupPurchase = [[GroupPurchaseView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(cutoff.frame), viewWidth, 100)];
    groupPurchase.backgroundColor = [UIColor whiteColor];
    [midView_bg addSubview:groupPurchase];
    
    /*        -----第三段-----       */
    
    UIView *bottom_bg = [[UIView alloc] init];
    bottom_bg.frame = CGRectMake(0, CGRectGetMaxY(midView_bg.frame)+10, viewWidth, 90);
    bottom_bg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottom_bg];
    
    // 活动流程
    UILabel *activeProcesses  = [[UILabel alloc] init];
    activeProcesses.frame = CGRectMake(10, 0, viewWidth-10, 45);
    activeProcesses.font = largeFont;
    activeProcesses.textColor = mainTitleColor;
    activeProcesses.text = @"活动流程";
    
    UITapGestureRecognizer *activeProcessesTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
    activeProcesses.tag = 100;
    activeProcesses.userInteractionEnabled = YES;
    [activeProcesses addGestureRecognizer:activeProcessesTap];
    [bottom_bg addSubview:activeProcesses];
    
    // 分割线
    UIView *division = [[UIView alloc] init];
    division.frame = CGRectMake(0, CGRectGetMaxY(activeProcesses.frame), viewWidth, 1);
    division.backgroundColor = ldivisionColor;
    [bottom_bg addSubview:division];
    
    // 免责声明
    UILabel *statement = [[UILabel alloc] init];
    statement.frame = CGRectMake(10, CGRectGetMaxY(division.frame), viewWidth, 45);
    statement.font = largeFont;
    statement.textColor = mainTitleColor;
    statement.text = @"免责声明";
    
    UITapGestureRecognizer *statementTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleTap:)];
    statement.tag = 101;
    statement.userInteractionEnabled = YES;
    [statement addGestureRecognizer:statementTap];
    [bottom_bg addSubview:statement];
}

#pragma mark - 数据对接
- (void)conntect{
    
    // 线路介绍
    introduction.textField.text = [NSString stringWithFormat:@"%@",model.hk_showingsLineIntroduction];
    // 最高优惠
    maxPreferential.textField.text = [NSString stringWithFormat:@"%@",model.hk_showingsMaxPreferential];
    // 均价
    averagePrice.textField.text = [NSString stringWithFormat:@"%@元/m²",model.hk_price];
    // 所属区域
    subclass.textField.text = [NSString stringWithFormat:@"%@",model.hk_showingsErea];
    // 看房热线
    telephoneNum.textField.text = [NSString stringWithFormat:@"%@",model.hk_tel];
    // 截止时间
    deadline.text = [NSString stringWithFormat:@"报名截止时间:%@",[Tools_F timeTransform:[model.hk_showingsEndtime intValue] time:days]];
    // 已报名
    signUp.text = [NSString stringWithFormat:@"已报名:%@",model.hk_applyPeopleQty];
    
    // 图片
    [groupPurchase.placeImage sd_setImageWithURL:[NSURL URLWithString:model.hk_house[@"defaultImage"]] placeholderImage:[UIImage imageNamed:@"loading_l"]];
    // 地名
    groupPurchase.placeTitle.text = [NSString stringWithFormat:@"%@",model.hk_house[@"houseName"]];
    // 地址
    groupPurchase.placeAdd.text = [NSString stringWithFormat:@"%@",model.hk_house[@"planFormat"]];
    // 招商状态
    NSString *merchantsStatus;
    switch ([model.hk_house[@"merchantsStatus"] intValue]) {
        case 1: merchantsStatus = @"招商状态: 意向登记";
            break;
        case 2: merchantsStatus = @"招商状态: 意向租赁";
            break;
        case 3: merchantsStatus = @"招商状态: 品牌转定";
            break;
        default: merchantsStatus = @"招商状态: 未定";
            break;
    }
    
    groupPurchase.placeDiscount.text = merchantsStatus;
    // 价格
    groupPurchase.placePrice.text = model.hk_house[@"perferentialContent"];
}

#pragma mark - 线路楼盘
- (void)mapLine:(UIButton *)btn{
    
    MapViewController *mapVC = [[MapViewController alloc] init];
    
    mapVC.fromIndex = 0;
    mapVC.theLatitude = [model.hk_house[@"latitude"] floatValue];
    mapVC.theLongitude = [model.hk_house[@"longitude"] floatValue];
    [self.navigationController pushViewController:mapVC animated:YES];
}

#pragma mark - 标题点击
- (void)titleTap:(UIGestureRecognizer *)tap{
    
    UILabel *label = (UILabel *)tap.view;
    int titleTag = (int)label.tag;
    NSLog(@"标题点击%d",titleTag);
    
    ActivityProcessViewController *hpVC = [[ActivityProcessViewController alloc] init];
    
    switch (titleTag) {
        case 100:
        {
            hpVC.theTitle = @"活动流程";
            hpVC.theContent = model.hk_showingsActivityProcess;
        }
            break;
        case 101:
        {
            hpVC.theTitle = @"免责声明";
        }
            break;
    }
    [self.navigationController pushViewController:hpVC animated:YES];

}

#pragma mark - 立刻报名
- (void)applyClick:(UIButton *)btn{
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else {
        
        HLApplyViewController *alApply = [[HLApplyViewController alloc] init];
        
        alApply.model = model;
        [self.navigationController pushViewController:alApply animated:YES];
    }
}

#pragma mark - leftaction
- (void)leftAction:(UIButton *)btn{
    
    NSLog(@"返回");
    [self dismissViewControllerAnimated:YES completion:nil];

//    [self.navigationController popViewControllerAnimated:YES];
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
