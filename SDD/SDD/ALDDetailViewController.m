//
//  ALDDetailViewController.m
//  商多多
//
//  Created by hua on 15/4/9.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ALDDetailViewController.h"
#import "PlanDetailModel.h"
#import "ALDDetailView.h"
#import "FloorsSelect.h"

#import "ChatViewController.h"
#import "CounselorInfoViewController.h"
#import "ReservationController.h"

#import "VIPhotoView.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

@interface ALDDetailViewController ()<FloorSelectdelegate,VIPhotoViewDelegate>{
    
    /* data */
    
    NSInteger currentFloor;
    NSArray *planDetailArr;    
    
    /* ui */
    
    VIPhotoView *phoneView;                 // 图片
    
    UILabel *houseName;
    UILabel *location;                      // 位置
    UILabel *area;                          // 面积
    UILabel *industry;                      // 业态
    UILabel *brandIn;                       // 已入驻品牌
    
    UIView *bottomView;
}

@end

@implementation ALDDetailViewController

#pragma mark - 请求数据
- (void)requsetData{
    
    // 请求参数
    NSDictionary *dic = @{@"buildingId":[NSNumber numberWithInteger:_buildingId]};
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/house/floorImages.do" params:dic success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSArray *arr = JSON[@"data"];
        if (![arr isEqual:[NSNull null]]) {
            if ([arr count]>0) {
                
                // JSON array -> User array
                planDetailArr = [PlanDetailModel objectArrayWithKeyValuesArray:arr];
                
                currentFloor = 0;
                [self connect];
                
                NSMutableArray *floorArr = [NSMutableArray array];
                for (PlanDetailModel *model in planDetailArr) {
                    [floorArr addObject:model.floorName];
                }
                
                // 楼层选择
                FloorsSelect *fsView = [[FloorsSelect alloc] init];
                [fsView setWithFloorsName:floorArr];
                fsView.delegate = self;
                fsView.layer.cornerRadius = 5;
                fsView.layer.shadowColor = mainTitleColor.CGColor;
                fsView.layer.shadowOffset = CGSizeMake(1, 1);   // shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
                fsView.layer.shadowOpacity = 0.8;               // 阴影透明度，默认0
                fsView.layer.shadowRadius = 4;                  // 阴影半径，默认3
                
                [self.view addSubview:fsView];
                [fsView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(bottomView.mas_left).offset(10);
                    make.bottom.equalTo(bottomView.mas_top).offset(-10);
                }];
                
            }
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"业态平面图详情错误 -- %@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 导航条
    [self setNav:_theTitle];
    // 设置内容
    [self setupUI];
    // 请求数据
    [self requsetData];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    /*-                   底部                  -*/
    bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 60));
    }];
    
    UIView *cutoff = [[UIView alloc] init];
    cutoff.backgroundColor = ldivisionColor;
    [bottomView addSubview:cutoff];
    [cutoff mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top);
        make.left.equalTo(bottomView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 1));
    }];

    houseName = [[UILabel alloc] init];
    houseName.font = titleFont_15;
    houseName.text = _theTitle;
    houseName.textColor = mainTitleColor;
    [bottomView addSubview:houseName];
    [houseName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top);
        make.left.equalTo(bottomView.mas_left).offset(10);
        make.width.equalTo(@(viewWidth*3/4));
        make.bottom.equalTo(bottomView.mas_bottom);
    }];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.titleLabel.font = midFont;
    [backButton setTitle:@"详情" forState:UIControlStateNormal];
    [backButton setTitleColor:dblueColor forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToDetail) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top);
        make.left.equalTo(houseName.mas_right);
        make.right.equalTo(bottomView.mas_right);
        make.bottom.equalTo(bottomView.mas_bottom);
    }];
    
    UIImageView *arrow = [[UIImageView alloc] init];
    arrow.userInteractionEnabled = YES;
    arrow.image = [UIImage imageNamed:@"blue_rightArrow"];
    [backButton addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backButton);
        make.right.equalTo(backButton.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(7, 12));
    }];
    
    ///////////////////////////////////////// old //////////////////////////////////////////
    
    
//
//    location = [[UILabel alloc] init];
//    location.font = largeFont;
//    location.textColor = mainTitleColor;
//    [bottomView addSubview:location];
//    [location mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(cutoff.mas_bottom).offset(10);
//        make.left.equalTo(bottomView.mas_left).offset(10);
//        make.height.equalTo(@20);
//    }];
//
//    area = [[UILabel alloc] init];
//    area.font = largeFont;
//    area.textColor = tagsColor;
//    [bottomView addSubview:area];
//    [area mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(cutoff.mas_bottom).offset(10);
//        make.left.equalTo(location.mas_right).offset(10);
//        make.height.equalTo(@20);
//    }];
//    
//    industry = [[UILabel alloc] init];
//    industry.font = midFont;
//    industry.textColor = mainTitleColor;
//    [bottomView addSubview:industry];
//    [industry mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(location.mas_bottom).offset(5);
//        make.left.equalTo(bottomView.mas_left).offset(10);
//        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 20));
//    }];
//    
//    brandIn = [[UILabel alloc] init];
//    brandIn.font = midFont;
//    brandIn.textColor = mainTitleColor;
//    [bottomView addSubview:brandIn];
//    [brandIn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(industry.mas_bottom).offset(5);
//        make.left.equalTo(bottomView.mas_left).offset(10);
//        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 20));
//    }];
//    
//    // 预约
//    ConfirmButton *reservationBtn = [[ConfirmButton alloc] initWithFrame:CGRectMake(20, viewHeight-119, viewWidth - 40, 45)
//                                                             title:@"马上预约"
//                                                            target:self
//                                                            action:@selector(reservation)];
//    [reservationBtn setBackgroundImage:[Tools_F imageWithColor:lblueColor
//                                                size:CGSizeMake(viewWidth-40, 45)]
//                              forState:UIControlStateDisabled];
//    [reservationBtn setTitleColor:[UIColor whiteColor]
//                         forState:UIControlStateDisabled];
//    
//    [Tools_F setViewlayer:reservationBtn cornerRadius:5 borderWidth:0 borderColor:nil];
//    reservationBtn.enabled = _canAppointment;
//    
//    [bottomView addSubview:reservationBtn];
//    [reservationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(bottomView.mas_bottom).offset(-10);
//        make.left.equalTo(bottomView.mas_left).offset(20);
//        make.size.mas_equalTo(CGSizeMake(viewWidth-40, 45));
//    }];
}

#pragma mark - 连接数据
- (void)connect{
    
    PlanDetailModel *model = planDetailArr[currentFloor];
    
    /*-                   图片                  -*/
    
    UIImageView *aldImage = [[UIImageView alloc] init];
    // 对接数据
    [aldImage sd_setImageWithURL:model.floorImage
                placeholderImage:[UIImage imageNamed:@"loading_b"]];
    
    [phoneView removeFromSuperview];
    phoneView = [[VIPhotoView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-130)
                                      andImageView:aldImage];
    phoneView.autoresizingMask = (1 << 6) -1;
    phoneView.movingDelegate = self;
    
    [self.view addSubview:phoneView];
    [self.view sendSubviewToBack:phoneView];        // 放到底层
    
    
    ///////////////////////////////////////// old //////////////////////////////////////////

    
//    location.text = [NSString stringWithFormat:@"%@%@",_theTitle,model.floorName];
//    area.text = [NSString stringWithFormat:@"面积:  %.0fm²",model.floorArea];
//    
//    NSString *originalString = [NSString stringWithFormat:@"业态:  %@",model.formatName];
//    NSMutableAttributedString *paintString = [[NSMutableAttributedString alloc] initWithString:originalString];
//    [paintString addAttribute:NSForegroundColorAttributeName
//                        value:lgrayColor
//                        range:[originalString
//                               rangeOfString:model.formatName]];
//    industry.attributedText = paintString;
//    
//    NSString *brandName = model.brandName == nil?@"":model.brandName;
//    
//    originalString = [NSString stringWithFormat:@"已入驻品牌:  %@",brandName
//                      ];
//    paintString = [[NSMutableAttributedString alloc] initWithString:originalString];
//    [paintString addAttribute:NSForegroundColorAttributeName
//                        value:lgrayColor
//                        range:[originalString
//                               rangeOfString:brandName]];
//    brandIn.attributedText = paintString;
}

#pragma mark - 移动中隐藏
- (void)moving:(BOOL)isMoving{
    
    bottomView.hidden = isMoving;
}

#pragma mark - 楼层选择代理
- (void)didSelectFloor:(NSInteger)theIndex{
   
    NSLog(@"选择了%d层",theIndex);
    currentFloor = theIndex;
    [self connect];
}

- (void)backToDetail{

    // 连续返回2级
    UIViewController *vc = [self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count] -3)];
    [self.navigationController popToViewController:vc animated:YES];
}

#pragma mark - 马上预约
- (void)reservation{
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else if (!_canAppointment) {
        
        //
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"您已报名该预约，请勿重复报名"
                                                       delegate:self
                                              cancelButtonTitle:@"好"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        
        PlanDetailModel *model = planDetailArr[currentFloor];

        ReservationController *rVC = [[ReservationController alloc] init];
        
        rVC.houseName = _theTitle;
        rVC.houseID = [NSString stringWithFormat:@"%d",model.houseId];
        rVC.activityCategoryId = 2;
        rVC.isOfficial = _isOfficial;
        [self.navigationController pushViewController:rVC animated:YES];
    }
}

//#pragma mark - callButton
//- (void)consultantInfo:(UITapGestureRecognizer *)tap{
//    
//    UIImageView *image = (UIImageView *)tap.view;
//    NSInteger theIndex = image.tag-400;
//    
//    CounselorInfoViewController *counselorInfoVC = [[CounselorInfoViewController alloc] init];
//    
//    counselorInfoVC.userID = model.ald_consultants[theIndex][@"userId"];
//    counselorInfoVC.houseID = model.ald_consultants[theIndex][@"houseId"];
//    [self.navigationController pushViewController:counselorInfoVC animated:YES];
//}
//
//#pragma mark - callButton
//- (void)callClick:(UIButton *)sender{
//    
//    NSString *num = model.ald_consultants[(int)sender.tag-200][@"phone"];
//    
//    //联系客服
//    UIWebView*callWebview =[[UIWebView alloc] init];
//    NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",num]];
//    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
//    [self.view addSubview:callWebview];
//}
//
//#pragma mark - contactButton
//- (void)contactClick:(UIButton *)sender{
//    
//    // 用户id
//    NSString *userID = [NSString stringWithFormat:@"%@",model.ald_consultants[(int)sender.tag-300][@"userId"]];
//    NSLog(@"对方id:%@",userID);
//    
//    // 发送顾问默认欢迎文本
//    NSDictionary *param = @{@"consultantUserId":userID};
//    NSString *urlString = [SDD_MainURL stringByAppendingString:@"/user/getIMDefaultWelcomeText.do"];              // 拼接主路径和请求内容成完整url
//    [self sendCustomerServicesWelcome:param url:urlString];
//    
//    self.hidesBottomBarWhenPushed = YES;
//    ChatViewController *cvc = [[ChatViewController alloc] initWithChatter:userID isGroup:FALSE];
//    [self.navigationController pushViewController:cvc animated:true];
//}
//
//#pragma mark - 发送客服欢迎
//- (void)sendCustomerServicesWelcome:param url:urlString{
//    
//    [self.httpManager POST:urlString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSDictionary *dict = responseObject;
//        NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        NSLog(@"错误 -- %@", error);
//    }];
//}

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
