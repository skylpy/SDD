//
//  HouseParameterViewController.m
//  商多多
//
//  Created by hua on 15/4/9.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "HouseParameterViewController.h"
#import "Tools_F.h"

@interface HouseParameterViewController ()

@end

@implementation HouseParameterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = bgColor;
    // 导航条
    [self setNav:_theTitle];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    // 底部滚动
    UIScrollView *bg_scrollView = [[UIScrollView alloc] init];
    bg_scrollView.backgroundColor = bgColor;
    [self.view addSubview:bg_scrollView];
    [bg_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 底部view， 用于计算scrollview高度
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = bgColor;
    [bg_scrollView addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bg_scrollView);
        make.width.equalTo(bg_scrollView);
    }];
    
    // 标题
//    UILabel *titleLabel = [[UILabel alloc] init];
//    titleLabel.font = titleFont_15;
//    titleLabel.textColor = mainTitleColor;
//    titleLabel.text = @"查看项目参数";
//    
//    [contentView addSubview:titleLabel];
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(contentView.mas_top).offset(10);
//        make.left.equalTo(contentView.mas_left).offset(10);
//        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 20));
//    }];
    
    // 楼盘参数
//    NSArray *paraTitle = @[//@"开盘时间",
//                           @"规划业态",
//                           @"建筑类型",
//                           @"规划面积",
//                           @"建筑面积",
//                           @"公摊率",
//                           @"容积率",
//                           @"绿化率",
//                           @"地上车位数",
//                           @"地下车位数",
//                           @"物业数量",
//                           @"开发商",
//                           @"运营管理公司",
//                           @"产权年限",
//                           @"开工时间",
//                           @"竣工时间",
//                           ];
//
//    NSArray *paraContent = @[
////                             [_theContent[@"openedTime"] floatValue] == 0?@"未开盘":[NSString stringWithFormat:@"%@",[Tools_F timeTransform:[_theContent[@"openedTime"] floatValue] time:days]],
//                             _theContent[@"planFormat"] == nil?@"暂无":[NSString stringWithFormat:@"%@",_theContent[@"planFormat"]],
//                             _theContent[@"buildingType"] == nil?@"暂无":[NSString stringWithFormat:@"%@",_theContent[@"buildingType"]],
//                             _theContent[@"planArea"] == nil?@"暂无":[NSString stringWithFormat:@"%@亩",_theContent[@"planArea"]],
//                             _theContent[@"buildingArea"] == nil?@"暂无":[NSString stringWithFormat:@"%@m²",_theContent[@"buildingArea"]],
//                             _theContent[@"publicRoundRate"] == nil || [_theContent[@"publicRoundRate"] isEqualToString:@""]?@"暂无":[NSString stringWithFormat:@"%@",_theContent[@"publicRoundRate"]],
//                             _theContent[@"volumeRate"] == nil || [_theContent[@"volumeRate"] isEqualToString:@""]?@"暂无":[NSString stringWithFormat:@"%@",_theContent[@"volumeRate"]],
//                             _theContent[@"greeningRate"] == nil || [_theContent[@"greeningRate"] isEqualToString:@"暂无"]?@"":[NSString stringWithFormat:@"%@",_theContent[@"greeningRate"]],
//                             _theContent[@"groundParkingSpaces"] == nil?@"暂无":[NSString stringWithFormat:@"%@",_theContent[@"groundParkingSpaces"]],
//                             _theContent[@"undergroundParkingSpaces"] == nil?@"暂无":[NSString stringWithFormat:@"%@",_theContent[@"undergroundParkingSpaces"]],
//                             _theContent[@"properties"] == nil?@"暂无":[NSString stringWithFormat:@"%@",_theContent[@"properties"]],
//                             _theDevelopersName,
//                             _theContent[@"operationsManagement"] == nil?@"暂无":[NSString stringWithFormat:@"%@",_theContent[@"operationsManagement"]],
//                             _theContent[@"propertyAge"] == nil?@"暂无":[NSString stringWithFormat:@"%@",_theContent[@"propertyAge"]],
//                             [_theContent[@"buildingStartTime"] floatValue] == 0?@"未开工":[NSString stringWithFormat:@"%@",[Tools_F timeTransform:[_theContent[@"buildingStartTime"] floatValue] time:days]],
//                             [_theContent[@"buildingEndTime"] floatValue] == 0?@"未竣工":[NSString stringWithFormat:@"%@",[Tools_F timeTransform:[_theContent[@"buildingEndTime"] floatValue] time:days]]
//                             ];
    NSArray * paraTitle = @[
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
    
    NSArray * paraContent = @[
                    _theContent[@"commercialArea"] == [NSNull null]?
                    @"暂无":[NSString stringWithFormat:@"%@ m²",_theContent[@"commercialArea"] ],
                    _theContent[@"floor"] == [NSNull null]?
                    @"暂无":[NSString stringWithFormat:@"%@",_theContent[@"floor"]],
                    _theContent[@"lease"] == [NSNull null]?
                    @"暂无":[NSString stringWithFormat:@"%@",_theContent[@"lease"]],
                    _theContent[@"buildingType"] == [NSNull null]?
                    @"暂无":[NSString stringWithFormat:@"%@",_theContent[@"buildingType"]],
                    _theContent[@"planFormat"] == [NSNull null]?
                    @"暂无":[NSString stringWithFormat:@"%@",_theContent[@"planFormat"]],
                    
                    _theContent[@"managementFee"] == [NSNull null]?@"暂无":[NSString stringWithFormat:@"%@",_theContent[@"managementFee"]],
                    
                    _theContent[@"properties"] == [NSNull null]?@"暂无":[NSString stringWithFormat:@"%@",_theContent[@"properties"]],
                    //                        model.hd_house[@"planArea"] == nil?
                    //                        @"暂无":[NSString stringWithFormat:@"%@亩",model.hd_house[@"planArea"]],
                    
                    
                    
                    _theContent[@"planArea"] == [NSNull null]?@"暂无":[NSString stringWithFormat:@"%@亩",_theContent[@"planArea"]],
                   
                    //                        model.hd_house[@"greeningRate"] == nil || [model.hd_house[@"greeningRate"] isEqualToString:@"暂无"]?@"":[NSString stringWithFormat:@"%@",model.hd_house[@"greeningRate"]],
                    _theContent[@"groundParkingSpaces"] == [NSNull null]?@"暂无":[NSString stringWithFormat:@"%@",_theContent[@"groundParkingSpaces"]],
                    _theContent[@"undergroundParkingSpaces"] == [NSNull null]?@"暂无":[NSString stringWithFormat:@"%@",_theContent[@"undergroundParkingSpaces"]],
                    
                    _theContent[@"publicRoundRate"] == [NSNull null] || [_theContent[@"publicRoundRate"] isEqualToString:@""]?@"暂无":[NSString stringWithFormat:@"%@",_theContent[@"publicRoundRate"]],
                    _theContent[@"volumeRate"] == [NSNull null] || [_theContent[@"volumeRate"] isEqualToString:@""]?@"暂无":[NSString stringWithFormat:@"%@",_theContent[@"volumeRate"]],
                    
                    _theDevelopersName,
                    _theContent[@"operationsManagement"] == [NSNull null]?@"暂无":[NSString stringWithFormat:@"%@",_theContent[@"operationsManagement"]],
                    _theContent[@"propertyAge"] == [NSNull null]?@"暂无":[NSString stringWithFormat:@"%@",_theContent[@"propertyAge"]],
                    [_theContent[@"buildingStartTime"] floatValue] == 0?@"暂无":[NSString stringWithFormat:@"%@",[Tools_F timeTransform:[_theContent[@"buildingStartTime"] floatValue] time:days]],
                    [_theContent[@"buildingEndTime"] floatValue] == 0?@"暂无":[NSString stringWithFormat:@"%@",[Tools_F timeTransform:[_theContent[@"buildingEndTime"] floatValue] time:days]],
                    [_theContent[@"decorationTime"] floatValue] == 0?@"暂无":[NSString stringWithFormat:@"%@",[Tools_F timeTransform:[_theContent[@"decorationTime"] floatValue] time:days]]
                    ];
    
    UILabel *lastLabel;
    for (int i=0; i<paraTitle.count; i++) {
        
        UILabel *label = [[UILabel alloc] init];
        //label.text = [NSString stringWithFormat:@"%@: %@",paraTitle[i],paraContent[i]];
        label.font = midFont;
        label.textColor = lgrayColor;
        label.numberOfLines = 0;
        [contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastLabel?lastLabel.mas_bottom: self.view.mas_top).offset(5);
            make.left.equalTo(contentView.mas_left).offset(10);
            make.width.mas_equalTo(viewWidth-20);
        }];
        NSString * surroundingString1 = [NSString stringWithFormat:@"%@: %@",
                                         paraTitle[i],paraContent[i]];
        NSMutableAttributedString * surroundString2 = [[NSMutableAttributedString alloc] initWithString:surroundingString1];
        //NSMutableAttributedString * surroundString2 = [[NSMutableAttributedString alloc] initWithString:surroundingString1];
        [surroundString2 addAttribute:NSForegroundColorAttributeName
                                value:mainTitleColor
                                range:[paraTitle[i]
                                       rangeOfString:paraTitle[i]]];
        label.attributedText = surroundString2;
        lastLabel = label;
    }
    
    // 自动scrollview高度
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastLabel.mas_bottom).with.offset(65);
    }];
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
