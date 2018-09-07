//
//  HKDetailViewController.m
//  SDD
//
//  Created by hua on 15/5/22.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "HKDetailViewController.h"

#import "GPDetailViewController.h"
#import "GRDetailViewController.h"
#import "HRDetailViewController.h"
#import "ConsultantViewController.h"

#import "UIImageView+WebCache.h"
@interface HKDetailViewController ()

@end

@implementation HKDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = bgColor;
    // nav
    [self setNav:@"看房团"];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    UIView *view_bg = [[UIView alloc] init];
    view_bg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view_bg];
    
    // 标题
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(8, 15, viewWidth-32, 18);
    title.font = largeFont;
    title.textColor = deepBLack;
    title.textAlignment = NSTextAlignmentCenter;
    title.text = _model.r_houseName;
    [view_bg addSubview:title];
    
    // 副标题
    UILabel *subTitle = [[UILabel alloc] init];
    subTitle.frame = CGRectMake(8, CGRectGetMaxY(title.frame)+5, viewWidth-32, 18);
    subTitle.font = midFont;
    subTitle.textColor = lgrayColor;
    subTitle.textAlignment = NSTextAlignmentCenter;
    subTitle.text = _model.r_houseName;
    [view_bg addSubview:subTitle];
    
    // 分割线
    UIView *cutOff = [[UIView alloc] init];
    cutOff.frame = CGRectMake(0, CGRectGetMaxY(subTitle.frame)+15, viewWidth-16, 1);
    cutOff.backgroundColor = bgColor;
    [view_bg addSubview:cutOff];
    
    // 线路介绍
    UILabel *lineIntroduction = [[UILabel alloc] init];
    lineIntroduction.frame = CGRectMake(8, CGRectGetMaxY(cutOff.frame)+5, viewWidth-32, 18);
    lineIntroduction.font = midFont;
    lineIntroduction.text = [NSString stringWithFormat:@"线路介绍:%@",_model.r_showingsLineIntroduction];
    [view_bg addSubview:lineIntroduction];
    
    // 最高优惠
    UILabel *maxPreferential = [[UILabel alloc] init];
    maxPreferential.frame = CGRectMake(8, CGRectGetMaxY(lineIntroduction.frame)+5, viewWidth-32, 18);
    maxPreferential.font = midFont;
    lineIntroduction.text = [NSString stringWithFormat:@"最高优惠:%@",_model.r_showingsMaxPreferential];
    [view_bg addSubview:maxPreferential];
    
    // url
    NSString *imgUrlString = [NSString stringWithFormat:@"http://api.map.baidu.com/staticimage?center=%@,%@,&width=300&height=200&zoom=15",_model.r_longitude,_model.r_latitude];
    // image
    UIImageView *mapImage = [[UIImageView alloc] init];
    mapImage.frame = CGRectMake(8, CGRectGetMaxY(maxPreferential.frame)+8, viewWidth-32, 200);
    [mapImage sd_setImageWithURL:[NSURL URLWithString:imgUrlString] placeholderImage:[UIImage imageNamed:@"loading_b"]];
    mapImage.backgroundColor = RandomColor;
    
    [view_bg addSubview:mapImage];
    
    // 楼盘
    UILabel *houseName = [[UILabel alloc] init];
    houseName.frame = CGRectMake(8, CGRectGetMaxY(mapImage.frame)+8, viewWidth/2-8, 18);
    houseName.font = midFont;
    houseName.text = _model.r_houseName;
    [view_bg addSubview:houseName];
    
    // 价格
    UILabel *price = [[UILabel alloc] init];
    price.frame = CGRectMake(viewWidth*2/3-8, CGRectGetMaxY(mapImage.frame)+8, viewWidth/3-16, 18);
    price.font = midFont;
    price.textColor = lorangeColor;
    price.textAlignment = NSTextAlignmentRight;
    price.text = [NSString stringWithFormat:@"%@元/m²",_model.r_price];
    [view_bg addSubview:price];
    
    // 线路查询
    UIButton *lineConsult = [UIButton buttonWithType:UIButtonTypeCustom];
    lineConsult.frame = CGRectMake(30, CGRectGetMaxY(houseName.frame)+8, viewWidth/4, 30);
    lineConsult.backgroundColor = deepOrangeColor;
    lineConsult.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    [lineConsult setTitle:@"线路查询" forState:UIControlStateNormal];
    [lineConsult setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [Tools_F setViewlayer:lineConsult cornerRadius:5 borderWidth:0 borderColor:[UIColor clearColor]];
    [lineConsult addTarget:self action:@selector(lineConsult) forControlEvents:UIControlEventTouchUpInside];
    [view_bg addSubview:lineConsult];
    
    // 已报名
    UIButton *apply = [UIButton buttonWithType:UIButtonTypeCustom];
    apply.frame = CGRectMake(viewWidth*3/4-46, CGRectGetMaxY(houseName.frame)+8, viewWidth/4, 30);
    apply.backgroundColor = lorangeColor;
    apply.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    [apply setTitle:@"已报名" forState:UIControlStateNormal];
    [apply setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [Tools_F setViewlayer:apply cornerRadius:5 borderWidth:0 borderColor:[UIColor clearColor]];
    [apply addTarget:self action:@selector(applyClick) forControlEvents:UIControlEventTouchUpInside];
    [view_bg addSubview:apply];
    
    
    view_bg.frame = CGRectMake(8, 8, viewWidth-16, CGRectGetMaxY(apply.frame)+8);
    
}

#pragma mark - 线路咨询
- (void)lineConsult{
    
    ConsultantViewController *consultantVC = [[ConsultantViewController alloc] init];
    
    consultantVC.houseID = _model.r_houseId;
    [self.navigationController pushViewController:consultantVC animated:YES];
}

#pragma mark - 报名
- (void)applyClick{
    
    switch ([_model.r_activityCategoryId integerValue]) {
        case 1:
        {
            GPDetailViewController *gpDetail = [[GPDetailViewController alloc] init];
            gpDetail.activityCategoryId = @"1";
            gpDetail.houseID = _model.r_houseId;
            [self.navigationController pushViewController:gpDetail animated:YES];
        }
            break;
        case 2:
        {
            
            GRDetailViewController *grDetail = [[GRDetailViewController alloc] init];
            grDetail.activityCategoryId = @"2";
            grDetail.houseID = _model.r_houseId;
            [self.navigationController pushViewController:grDetail animated:YES];
        }
            break;
        case 3:
        {
            HRDetailViewController *hrDetail = [[HRDetailViewController alloc] init];
            
            hrDetail.activityCategoryId = @"3";
            hrDetail.hrTitle = _model.r_houseName;
            hrDetail.houseID = _model.r_houseId;
            [self.navigationController pushViewController:hrDetail animated:YES];
        }
            break;
        default:
            break;
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
