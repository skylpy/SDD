//
//  ShopForDetailsViewController.m
//  SDD
//
//  Created by mac on 15/12/28.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ShopForDetailsViewController.h"
#import "TabButton.h"
#import "NewAppointViewController.h"
#import "UIImageView+EMWebCache.h"
#import "SelectBtn.h"
#import "ShopBtn.h"
#import "PhotoView.h"
#import "UIImageView+EMWebCache.h"
#import "PhotoTitleView.h"
#import "ShopPhotoViewController.h"

@interface ShopForDetailsViewController ()
{
    
    UIScrollView *bg_scrollView;
    
    NSArray * paraTitle;
    NSArray * paraContent;
    
    UIView * botView;
    
    NSDictionary * dictStore;
    
    
    NSArray * paraTitleDown;
    NSArray * paraContentDown;
}
@end

@implementation ShopForDetailsViewController
//请求网络数据
-(void)requestData{
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/houseStore/detail.do" params:@{@"storeId":_storeId} success:^(id JSON) {
        
        NSLog(@"%@",JSON);
        if (![JSON[@"data"] isEqual:[NSNull null]]) {
            
            dictStore = JSON[@"data"];
        }
        
        [self setupData];
        
        [self setupUI];
        
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    //[self setupUI];
    [self requestData];
}

-(void)topImageTap{

    ShopPhotoViewController * shPVc = [[ShopPhotoViewController alloc] init];
    shPVc.imageArr = dictStore[@"imageUrls"];
    [self.navigationController pushViewController:shPVc animated:YES];
}



-(void)setupUI{

    [self setNav:dictStore[@"storeName"]];
    
    // 底部滚动
    bg_scrollView = [[UIScrollView alloc] init];
    bg_scrollView.backgroundColor = bgColor;
    [self.view addSubview:bg_scrollView];
    [bg_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    // 底部view， 用于计算scrollview高度
    UIView* contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    [bg_scrollView addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bg_scrollView);
        make.width.equalTo(bg_scrollView);
    }];
    
    
    /*------------------------------ 顶部图+基本参数 ------------------------------*/
    
    UIImageView *_headImage = [[UIImageView alloc] init];
    [_headImage sd_setImageWithURL:[NSURL URLWithString:dictStore[@"defaultImage"]] placeholderImage:[UIImage imageNamed:@"loading_b"]];
//_headImage.image = [UIImage imageNamed:@"loading_l"];
    _headImage.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *hTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topImageTap)];
    [_headImage addGestureRecognizer:hTap];
    
    [bg_scrollView addSubview:_headImage];
    [_headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 200));
    }];
    
    UIView * topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    [bg_scrollView addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_headImage.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 50));
    }];
    
    UILabel * moneyLabel = [[UILabel alloc] init];
    moneyLabel.textColor = tagsColor;
    moneyLabel.text = [NSString stringWithFormat:@"%@元/㎡/月",dictStore[@"storeRentPrice"]];//@"80元/㎡/月";
    [topView addSubview:moneyLabel];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(topView.mas_top).with.offset(20);
        make.left.equalTo(bg_scrollView.mas_left).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(viewWidth/2, 10));
    }];
    
    UILabel * focusLabel = [[UILabel alloc] init];
    //focusLabel.text = @"已有 205 人关注";
    focusLabel.font = titleFont_15;
    focusLabel.textColor = lgrayColor;
    [topView addSubview:focusLabel];
    [focusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(topView.mas_top).with.offset(20);
        make.right.equalTo(bg_scrollView.mas_right).with.offset(-10);
        //make.size.mas_equalTo(CGSizeMake(viewWidth/2, 10));
    }];
    
  
    
    NSString * surroundingString1 = [NSString stringWithFormat:@"已有 %@ 人关注",
                                     dictStore[@"totalAttentions"]];
    NSMutableAttributedString * surroundString2 = [[NSMutableAttributedString alloc] initWithString:surroundingString1];
    [surroundString2 addAttribute:NSForegroundColorAttributeName
                            value:dblueColor
                            range:[surroundingString1
                                   rangeOfString:[NSString stringWithFormat:@"%@",dictStore[@"totalAttentions"]]]];
    focusLabel.attributedText = surroundString2;
    
    // 下分割线
    UIView *cutOff = [[UIView alloc] init];
    cutOff.backgroundColor = divisionColor;
    [bg_scrollView addSubview:cutOff];
    [cutOff mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.equalTo(@10);
        make.right.equalTo(bg_scrollView.mas_right).with.offset(-10);
        make.height.equalTo(@1);
    }];
    
    UIView * bg_view = [[UIView alloc] init];
    bg_view.backgroundColor = [UIColor whiteColor];
    [bg_scrollView addSubview:bg_view];
    
    
    UIView * lastView;
    for (int i = 0; i < paraTitle.count; i ++) {
        
        UILabel * titlabel = [[UILabel alloc] init];
        titlabel.text = [NSString stringWithFormat:@"%@:%@",paraTitle[i],paraContent[i]];
        titlabel.font = midFont;
        titlabel.textColor = lgrayColor;
        [bg_view addSubview:titlabel];
        
        NSString * surroundingString1 = [NSString stringWithFormat:@"%@: %@",
                                         paraTitle[i],paraContent[i]];
        NSMutableAttributedString * surroundString2 = [[NSMutableAttributedString alloc] initWithString:surroundingString1];
        [surroundString2 addAttribute:NSForegroundColorAttributeName
                                value:mainTitleColor
                                range:[paraTitle[i]
                                       rangeOfString:paraTitle[i]]];
        titlabel.attributedText = surroundString2;
        
        [titlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.right.equalTo(bg_view.mas_right).with.offset(-10);
            //make.height.mas_equalTo(@13);
            if (lastView){
                make.top.mas_equalTo(lastView.mas_bottom).with.offset(8);
            }
            else {
                make.top.mas_equalTo(@15);
            }
        }];
        
        lastView = titlabel;
    }
    [bg_view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(cutOff.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.right.equalTo(bg_scrollView.mas_right);
        make.bottom.equalTo(lastView.mas_bottom).with.offset(10);
    }];
    
    // 下分割线
    UIView *cutOff1 = [[UIView alloc] init];
    cutOff1.backgroundColor = divisionColor;
    [bg_scrollView addSubview:cutOff1];
    [cutOff1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bg_view.mas_bottom);
        make.left.equalTo(@10);
        make.right.equalTo(bg_scrollView.mas_right).with.offset(-10);
        make.height.equalTo(@1);
    }];
    
    
    UIView * bg_view1 = [[UIView alloc] init];
    bg_view1.backgroundColor = [UIColor whiteColor];
    [bg_scrollView addSubview:bg_view1];
    
    lastView = nil;
    for (int i = 0 ; i < 2; i ++) {
        
        UILabel * titlabel = [[UILabel alloc] init];
        titlabel.text = [NSString stringWithFormat:@"%@:%@",paraTitleDown[i],paraContentDown[i]];
        titlabel.font = midFont;
        titlabel.textColor = lgrayColor;
        [bg_view1 addSubview:titlabel];
        
        NSString * surroundingString1 = [NSString stringWithFormat:@"%@: %@",
                                         paraTitleDown[i],paraContentDown[i]];
        NSMutableAttributedString * surroundString2 = [[NSMutableAttributedString alloc] initWithString:surroundingString1];
        [surroundString2 addAttribute:NSForegroundColorAttributeName
                                value:mainTitleColor
                                range:[paraTitleDown[i]
                                       rangeOfString:paraTitleDown[i]]];
        titlabel.attributedText = surroundString2;
        
        [titlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@10);
            make.right.equalTo(bg_view1.mas_right).with.offset(-10);
            //make.height.mas_equalTo(@13);
            if (lastView){
                make.top.mas_equalTo(lastView.mas_bottom).with.offset(8);
            }
            else {
                make.top.mas_equalTo(@15);
            }
        }];
        
        lastView = titlabel;
    }
    
    [bg_view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(cutOff1.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.right.equalTo(bg_scrollView.mas_right);
        make.bottom.equalTo(lastView.mas_bottom).with.offset(10);
    }];
    
    // 下分割线
    UIView *cutOff2 = [[UIView alloc] init];
    cutOff2.backgroundColor = divisionColor;
    [bg_scrollView addSubview:cutOff2];
    [cutOff2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bg_view1.mas_bottom);
        make.left.equalTo(@10);
        make.right.equalTo(bg_scrollView.mas_right).with.offset(-10);
        make.height.equalTo(@1);
    }];
    
    /* *******************照片全景按钮******************* */
    
    UIView * btnView = [[UIView alloc] init];
    btnView.backgroundColor = [UIColor whiteColor];
    [bg_scrollView addSubview:btnView];
    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(cutOff2.mas_bottom);
        make.left.equalTo(bg_scrollView.mas_left);
        make.right.equalTo(bg_scrollView.mas_right);
        make.height.equalTo(@50);
    }];
    
    NSArray * titBtnArr = @[@"照片",@"全景"];
    NSArray * imageArr = @[@"icon-follow-pic",@"icon-follow-360"];
    
    for (int i = 0; i < 2; i ++) {
        
        ShopBtn * selBtn = [ShopBtn buttonWithType:UIButtonTypeCustom];
        selBtn.frame = CGRectMake(25+viewWidth/2*i, 10, viewWidth/2-50, 30);
        [selBtn setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        selBtn.titleLabel.font = titleFont_15;
        [selBtn setTitleColor:lgrayColor forState:UIControlStateNormal];
        [btnView addSubview:selBtn];
        
        if (i == 0) {
            UILabel * lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth/2, 5, 1, 40)];
            lineLabel.backgroundColor = divisionColor;
            [btnView addSubview:lineLabel];
            [selBtn setTitle:[NSString stringWithFormat:@"%@(%ld)",titBtnArr[i],[dictStore[@"imageUrls"] count]] forState:UIControlStateNormal];
            [selBtn addTarget:self action:@selector(topImageTap) forControlEvents:UIControlEventTouchUpInside];
        }else{
        
            [selBtn setTitle:[NSString stringWithFormat:@"%@(%@)",titBtnArr[i],@"暂无"] forState:UIControlStateNormal];
        }
    }
    
    
    // 下分割线
    UIView *cutOff3 = [[UIView alloc] init];
    cutOff3.backgroundColor = bgColor;
    [bg_scrollView addSubview:cutOff3];
    [cutOff3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnView.mas_bottom).offset(0);;
        make.left.equalTo(@0);
        make.right.equalTo(bg_scrollView.mas_right).with.offset(0);
        make.height.equalTo(@10);
    }];
    
    UIButton *notifyMe_bg = [UIButton buttonWithType:UIButtonTypeCustom];
    notifyMe_bg.backgroundColor = [UIColor whiteColor];
    //[notifyMe_bg addTarget:self action:@selector(notifyMe:) forControlEvents:UIControlEventTouchUpInside];
    [bg_scrollView addSubview:notifyMe_bg];
    [notifyMe_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cutOff3.mas_bottom).offset(0);
        make.left.equalTo(bg_scrollView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 44));
    }];
    
    UIImageView *notifyImageView = [[UIImageView alloc] init];
    notifyImageView.image = [UIImage imageNamed:@"house_nav_notify"];
    [notifyMe_bg addSubview:notifyImageView];
    [notifyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(notifyMe_bg.mas_centerY);
        make.left.equalTo(bg_scrollView.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    UILabel *notifyLabel = [[UILabel alloc] init];
    notifyLabel.textColor = mainTitleColor;
    notifyLabel.font = midFont;
    notifyLabel.text = @"关注商铺实时收取消息通知";
    
    [notifyMe_bg addSubview:notifyLabel];
    [notifyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(notifyMe_bg.mas_centerY);
        make.left.equalTo(notifyImageView.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(viewWidth-50, 44));
    }];
    
    UIButton *notifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [notifyBtn setTitle:@"关注" forState:UIControlStateSelected];
    notifyBtn.titleLabel.font = midFont;
    [notifyBtn setTitleColor:dblueColor forState:UIControlStateSelected];
    [notifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [notifyBtn setTitle:@"已关注" forState:UIControlStateNormal];
    UIImage * notimage = [Tools_F imageWithColor:lgrayColor size:CGSizeMake(60, 25)];
    [notifyBtn setBackgroundImage:notimage forState:UIControlStateNormal];
    UIImage * notimage1 = [Tools_F imageWithColor:[UIColor whiteColor] size:CGSizeMake(60, 25)];
    [notifyBtn setBackgroundImage:notimage1 forState:UIControlStateSelected];
    
    [notifyBtn addTarget:self action:@selector(notifyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [notifyMe_bg addSubview:notifyBtn];
    if ([dictStore[@"isAttention"] integerValue] == 1) {
        [Tools_F setViewlayer:notifyBtn cornerRadius:5 borderWidth:1 borderColor:divisionColor];
        notifyBtn.selected = NO;
        notifyBtn.enabled = NO;
    }else{
    
        [Tools_F setViewlayer:notifyBtn cornerRadius:5 borderWidth:1 borderColor:dblueColor];
        
        notifyBtn.selected = YES;
        notifyBtn.enabled = YES;
    }
    [notifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(notifyMe_bg.mas_centerY);
        make.right.equalTo(bg_scrollView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(60, 25));
    }];
    
    
    /***********************照片***************************/
    
    PhotoView * photoV = [[PhotoView alloc] init];
    photoV.backgroundColor = bgColor;
    if ([dictStore[@"imageUrls"] count]>= 3) {
        
        [photoV.leftImage sd_setImageWithURL:[NSURL URLWithString:dictStore[@"imageUrls"][0]] placeholderImage:[UIImage imageNamed:@"square_loading"]];
        [photoV.rightTImage sd_setImageWithURL:[NSURL URLWithString:dictStore[@"imageUrls"][1]] placeholderImage:[UIImage imageNamed:@"square_loading"]];
        [photoV.rightBImage sd_setImageWithURL:[NSURL URLWithString:dictStore[@"imageUrls"][2]] placeholderImage:[UIImage imageNamed:@"square_loading"]];
        
    }
    
    [bg_scrollView addSubview:photoV];
    
    UITapGestureRecognizer *phTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(topImageTap)];
    [photoV addGestureRecognizer:phTap];
    
    [photoV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(notifyMe_bg.mas_bottom).with.offset(0);
        make.left.equalTo(bg_scrollView.mas_left);
        make.right.equalTo(bg_scrollView.mas_right);
        make.height.equalTo(@180);
        
    }];
    
    
    PhotoTitleView * photoTitle = [[PhotoTitleView alloc] init];
    photoTitle.storeDescriptionLabel.text = dictStore[@"storeDescription"];
    //NSString * str = dictStore[@"storeDescription"];
    [bg_scrollView addSubview:photoTitle];
    photoTitle.backgroundColor = bgColor;
    
    CGSize  storeDesSize = [Tools_F countingSize:dictStore[@"storeDescription"] fontSize:15 width:viewWidth-20];
    [photoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(photoV.mas_bottom).with.offset(0);
        make.left.equalTo(bg_scrollView.mas_left);
        make.right.equalTo(bg_scrollView.mas_right);
        make.height.equalTo(@(storeDesSize.height+100));
    }];
    
    
    
    // 自动scrollview高度
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(photoTitle.mas_bottom).with.offset(0);
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
    
    if ([_hr_activityCategoryId integerValue] != 2 && _type == 0){
    
        UIButton *callButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [callButton setTitle:@"立即联系" forState:UIControlStateNormal];
        [callButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [callButton addTarget:self action:@selector(takePhone:) forControlEvents:UIControlEventTouchUpInside];
        [callButton setBackgroundColor:tagsColor];
        [botView addSubview:callButton];
        
        [callButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(botView);
        }];
        
    }else{
    
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
        
        reservationButton.enabled = [_canAppointmentSign integerValue] == 1?YES:NO;
        
        [botView addSubview:reservationButton];
        
        [reservationButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.left.equalTo(chatButton.mas_right);
            make.right.equalTo(botView.mas_right);
            make.bottom.equalTo(botView.mas_bottom);
        }];
    }
    
    
    
    
    
}

 //在线咨询
#pragma mark --在线咨询
-(void)im:(UIButton *)btn{

    if (![GlobalController isLogin]) {
        
        
    }else{
    
        
    }
}

//打电话
#pragma mark --打电话
-(void)takePhone:(UIButton *)btn{

    NSString *telNumber = [[NSString alloc] initWithFormat:@"telprompt://%@",@"4009918829"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telNumber]];
}

//预约看铺
#pragma mark --预约看铺
-(void)bookLookHouse:(UIButton *)btn{

    NewAppointViewController *rVC = [[NewAppointViewController alloc] init];
    
    //rVC.houseName = model.hd_house[@"houseName"];
    rVC.houseID = _houseID;
    rVC.activityCategoryId = 2;
    rVC.isOfficial = NO;
    [self.navigationController pushViewController:rVC animated:YES];
}
//关注
#pragma mark --关注
-(void)notifyBtnClick:(UIButton *)btn{

    NSString * selectStr = @"/houseStore/addAttention.do";
    //NSString * noselectStr = @"/houseStore/deleteAttention.do";
    //NSString * strURL =  btn.selected == YES ? selectStr : noselectStr;
    //NSLog(@"%@",strURL);
    [HttpTool postWithBaseURL:SDD_MainURL Path:selectStr params:@{@"storeId":_storeId} success:^(id JSON) {
        
        if ([JSON[@"status"] integerValue] == 1) {
            
            if (btn.selected) {
                
                btn.selected = NO;
                btn.enabled = NO;
            }
//            else{
//            
//                btn.selected = YES;
//            }
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}

//数据初始化
#pragma mark --数据初始化
- (void)setupData{
    
    paraTitle = @[
                  @"铺位编号",
                  @"可租面积",
                  @"截止日期",
                  @"所在楼栋",
                  @"所在楼层"
                  
                  ];
    
    paraContent = @[
                    dictStore[@"storeSn"],
                    [NSString stringWithFormat:@"%@㎡",dictStore[@"storeArea"]],//@"200㎡",
                    [Tools_F timeTransform:[dictStore[@"addTime"] intValue]time:dayszw],
                    dictStore[@"storeBuilding"],
                    [NSString stringWithFormat:@"%@F",dictStore[@"storeFloor"]],
                    ];
    
    paraTitleDown = @[
                      @"铺位业态",
                      @"物业条件"
                      ];
    
    paraContentDown =@[
                       dictStore[@"categoryName"],
                       dictStore[@"storePropertyCondition"]
                      
                      ];
    
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
