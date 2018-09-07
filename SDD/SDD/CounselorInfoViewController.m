//
//  CounselorInfoViewController.m
//  SDD
//
//  Created by hua on 15/4/15.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "CounselorInfoViewController.h"
#import "CounselorInfoView.h"
#import "ConsultantModel.h"

#import "CounselorReviewViewController.h"
#import "ChatViewController.h"

#import "TTTAttributedLabel.h"
#import "CWStarRateView.h"
#import "UIImageView+WebCache.h"

@interface CounselorInfoViewController ()<UIGestureRecognizerDelegate>{
    
    
    /*- 模型 -*/
    ConsultantModel *model;
    
    /*- ui -*/
    // 头像
    UIImageView *counselor_avatar;
    // 姓名
    UILabel *name;
    // 评分
    CWStarRateView *scroe;
    // 好评率
    UILabel *goodRate;
    // 关于
    UILabel *about;
    
    // 好评
    CounselorInfoView *goodReview;
    // 中评
    CounselorInfoView *mediumReview;
    // 差评
    CounselorInfoView *badReview;
    
    // 用户头像
    UIImageView *avatar;
    // 用户昵称
    UILabel *nickname;
    // 评分
    CWStarRateView *starRate;
    // 评论
    TTTAttributedLabel *comment;
    // 评论时间
    UILabel *commentTime;
}


@end

@implementation CounselorInfoViewController

#pragma mark - 请求数据
- (void)requestData{
    
    // 请求参数
    NSDictionary *dic = @{@"userId":_userID,@"houseId":_houseID};
    
    NSString *urlString = [SDD_MainURL stringByAppendingString:@"/house/consultantDetail.do"];              // 拼接主路径和请求内容成完整url
    
    [self.httpManager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = responseObject;
        NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
        if (![dict[@"data"] isEqual:[NSNull null]]) {
            
            NSDictionary *tempDict = dict[@"data"];
            
            model = [[ConsultantModel alloc] init];
            model.c_avgScore = tempDict[@"avgScore"];
            model.c_commentList = tempDict[@"commentList"];
            model.c_consultantUserId = tempDict[@"consultantUserId"];
            model.c_goodCommentQty = tempDict[@"goodCommentQty"];
            model.c_goodCommentRate = tempDict[@"goodCommentRate"];
            model.c_middleCommentQty = tempDict[@"middleCommentQty"];
            model.c_middleCommentRate = tempDict[@"middleCommentRate"];
            model.c_poorCommentQty = tempDict[@"poorCommentQty"];
            model.c_poorCoommentRate = tempDict[@"poorCoommentRate"];
            model.c_realName = tempDict[@"realName"];
            model.c_signature = tempDict[@"signature"];
            model.c_totalCommentQty = tempDict[@"totalCommentQty"];
            model.c_icon = tempDict[@"icon"];
            
            [self connect];

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    // 请求数据
    [self requestData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.view.backgroundColor = bgColor;
    
    // 导航条
    [self setupNav];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置导航条
- (void)setupNav{
    
    SDDButton *button = [[SDDButton alloc]init];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"招商顾问信息";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

#pragma mark - 设置内容
- (void)setupUI{
    
    // 头像
    counselor_avatar = [[UIImageView alloc] init];
    counselor_avatar.frame = CGRectMake((viewWidth-60)/2, 15, 60, 60);
    [Tools_F setViewlayer:counselor_avatar cornerRadius:30 borderWidth:0 borderColor:[UIColor clearColor]];
    [self.view addSubview:counselor_avatar];
    
    // 姓名
    name = [[UILabel alloc] init];
    name.frame = CGRectMake(0, CGRectGetMaxY(counselor_avatar.frame)+10, viewWidth, 13);
    name.textColor = deepBLack;
    name.textAlignment = NSTextAlignmentCenter;
    name.font = midFont;
    [self.view addSubview:name];
    
    // 评分
    scroe = [[CWStarRateView alloc]initWithFrame:CGRectMake((viewWidth-100)/2, CGRectGetMaxY(name.frame)+10, 100, 15) numberOfStars:5];
    scroe.userInteractionEnabled = NO;    // 这里只作展示
    scroe.hasAnimation = YES;
    [self.view addSubview:scroe];
    
    // 分割线
    NSArray *divisionH = @[@0,@80,@140,@240,@290];
    for (int i=0; i<5; i++) {
        
        UIView *division = [[UIView alloc] init];
        division.frame = CGRectMake(0, CGRectGetMaxY(scroe.frame)+10+[divisionH[i] floatValue], viewWidth, 1);
        division.backgroundColor = divisionColor;
        [self.view addSubview:division];
    }
    
    UIView *division = [[UIView alloc] init];
    division.frame = CGRectMake(viewWidth/4, CGRectGetMaxY(scroe.frame)+20, 1, 60);
    division.backgroundColor = divisionColor;
    [self.view addSubview:division];
    
    UILabel *goodRateLabel = [[UILabel alloc] init];
    goodRateLabel.frame = CGRectMake(10, CGRectGetMaxY(scroe.frame)+20, viewWidth/5, 13);
    goodRateLabel.textColor = lgrayColor;
    goodRateLabel.text = @"好评率";
    goodRateLabel.font = midFont;
    [self.view addSubview:goodRateLabel];
    
    goodRate = [[UILabel alloc] init];
    goodRate.frame = CGRectMake(10, CGRectGetMaxY(goodRateLabel.frame)+10, viewWidth/4, 20);
    goodRate.font = biggestFont;
    [self.view addSubview:goodRate];
    
    // 评价条
    goodReview = [[CounselorInfoView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(division.frame), CGRectGetMaxY(scroe.frame)+20, viewWidth*3/4, 15)];
    goodReview.gradeTitle.text = @"好评:";
    goodReview.gradeProgress.flat = @NO;
    [self.view addSubview:goodReview];
    
    mediumReview = [[CounselorInfoView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(division.frame), CGRectGetMaxY(goodReview.frame)+8, viewWidth*3/4, 15)];
    mediumReview.gradeTitle.text = @"中评:";
    mediumReview.gradeProgress.flat = @NO;
    [self.view addSubview:mediumReview];
    
    badReview = [[CounselorInfoView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(division.frame), CGRectGetMaxY(mediumReview.frame)+8, viewWidth*3/4, 15)];
    badReview.gradeTitle.text = @"差评:";
    badReview.gradeProgress.flat = @NO;
    [self.view addSubview:badReview];
    
    UILabel *aboutLabel = [[UILabel alloc] init];
    aboutLabel.frame = CGRectMake(8, CGRectGetMaxY(scroe.frame)+10+80+10, 100, 13);
    aboutLabel.font = midFont;
    aboutLabel.textColor = lgrayColor;
    aboutLabel.text = @"关于";
    [self.view addSubview:aboutLabel];
    
    about = [[UILabel alloc] init];
    about.frame = CGRectMake(8, CGRectGetMaxY(aboutLabel.frame)+10, viewWidth-16, 13);
    about.font = midFont;
    about.textColor = lgrayColor;
    [self.view addSubview:about];
    
    // 头像
    avatar = [[UIImageView alloc] init];
    avatar.frame = CGRectMake(8, CGRectGetMaxY(scroe.frame)+10+140+8, 40, 40);
    avatar.layer.masksToBounds = YES;
    avatar.layer.cornerRadius = 20;
    [self.view addSubview:avatar];
    
    // 昵称
    nickname = [[UILabel alloc] init];
    nickname.frame = CGRectMake(CGRectGetMaxX(avatar.frame)+8, CGRectGetMaxY(scroe.frame)+10+140+8, viewWidth-64, 15);
    nickname.font = midFont;
    nickname.textColor = deepBLack;
    [self.view addSubview:nickname];
    
    // 评分
    starRate = [[CWStarRateView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(avatar.frame)+8, CGRectGetMaxY(nickname.frame)+5, 100, 15) numberOfStars:5];
    starRate.userInteractionEnabled = NO;    // 这里只作展示
    starRate.scorePercent = 0;
    starRate.hasAnimation = YES;
    [self.view addSubview:starRate];
    
    // 评论内容
    comment = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(avatar.frame)+8, viewWidth-16, 20)];
    comment.font = midFont;
    comment.textColor = deepBLack;
    comment.numberOfLines = 0;
    comment.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;  // 最顶
    [self.view addSubview:comment];
    
    // 时间
    commentTime = [[UILabel alloc] init];
    commentTime.frame = CGRectMake(8, CGRectGetMaxY(comment.frame)+8, viewWidth-16, 11);
    commentTime.font = midFont;
    commentTime.textColor = lgrayColor;
    [self.view addSubview:commentTime];
    
    // 马上点评
    UIButton *evaluationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    evaluationButton.frame = CGRectMake(16, CGRectGetMaxY(scroe.frame)+10+240+8, viewWidth-32, 35);
    [Tools_F setViewlayer:evaluationButton cornerRadius:5 borderWidth:1 borderColor:deepOrangeColor];
    evaluationButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [evaluationButton setTitle:@"马上点评" forState:UIControlStateNormal];
    [evaluationButton setTitleColor:deepOrangeColor forState:UIControlStateNormal];
    [evaluationButton addTarget:self action:@selector(reviewCounselor:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:evaluationButton];
    
    // 底部按钮
    UIView *botView = [[UIView alloc] init];
    botView.frame = CGRectMake(0, viewHeight-104, viewWidth, 40);
    botView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:botView];
    
    NSArray *someOperation = @[@"电话",@"聊天"];
    NSArray *operationImg = @[@"index_btn_call_white",@"index_btn_chat_white"];
    for (int i=0; i<2; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, ((viewWidth-10)/2)-10, 28);
        btn.tag = 100+i;
        btn.center = CGPointMake(viewWidth/4+(i*viewWidth/2), 40/2);
        btn.backgroundColor = i==0?lorangeColor:deepOrangeColor;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [Tools_F setViewlayer:btn cornerRadius:3 borderWidth:0 borderColor:[UIColor clearColor]];
        [btn setTitle:someOperation[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:operationImg[i]] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -3, 0, 3)];
        [btn addTarget:self action:@selector(callAndTalk:) forControlEvents:UIControlEventTouchUpInside];
        [botView addSubview:btn];
    }
}

#pragma mark - 对接数据
- (void)connect{
    
    // 头像
    [counselor_avatar sd_setImageWithURL:[NSURL URLWithString:model.c_icon]];
    // 姓名
    name.text = [NSString stringWithFormat:@"%@",model.c_realName];
    // 评分
    scroe.scorePercent = [model.c_avgScore floatValue]/5;
    // 好评率
    goodRate.text = [NSString stringWithFormat:@"%@%%",model.c_goodCommentRate];
    // 好评率（右）
    goodReview.gradePercent.text = [NSString stringWithFormat:@"%@%%",model.c_goodCommentRate];
    goodReview.gradeProgress.progress = [model.c_goodCommentRate floatValue]/100;
    goodReview.gradeCounts.text = [NSString stringWithFormat:@"%@条",model.c_goodCommentQty];
    // 中评率（右）
    mediumReview.gradePercent.text = [NSString stringWithFormat:@"%@%%",model.c_middleCommentRate];
    mediumReview.gradeProgress.progress = [model.c_middleCommentRate floatValue]/100;
    mediumReview.gradeCounts.text = [NSString stringWithFormat:@"%@条",model.c_middleCommentQty];
    // 差评率（右）
    badReview.gradePercent.text = [NSString stringWithFormat:@"%@%%",model.c_poorCoommentRate];
    badReview.gradeProgress.progress = [model.c_poorCoommentRate floatValue]/100;
    badReview.gradeCounts.text = [NSString stringWithFormat:@"%@条",model.c_middleCommentQty];
    // 个签
    about.text = [NSString stringWithFormat:@"%@",model.c_signature];
    
    // 评论人
    if (![model.c_commentList isEqual:[NSNull null]]) {
        
        // 头像
        [avatar sd_setImageWithURL:[NSURL URLWithString:model.c_commentList[0][@"icon"]]];
        // 昵称
        nickname.text = [NSString stringWithFormat:@"%@",model.c_commentList[0][@"realName"]];
        // 评分
        starRate.scorePercent = [model.c_commentList[0][@"commentScore"] floatValue]/5;
        // 评论内容
        comment.text = [NSString stringWithFormat:@"%@",model.c_commentList[0][@"commentContent"]];
        // 时间
        commentTime.text = [NSString stringWithFormat:@"%@",[Tools_F timeTransform:[model.c_commentList[0][@"commentTime"] intValue] time:seconds]];
    }
}

#pragma mark - 评论
- (void)reviewCounselor:(UIButton *)btn{
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else {
        
        CounselorReviewViewController *crVC = [[CounselorReviewViewController alloc] init];
        
        crVC.consultantUserId = model.c_consultantUserId;
        [self.navigationController pushViewController:crVC animated:YES];
    }
}

#pragma mark - 点评
- (void)callAndTalk:(UIButton *)btn{
    
    switch (btn.tag) {
        case 100:
        {
            NSString *num = [NSString stringWithFormat:@"tel:%@",_phone];
            // 联系顾问
            UIWebView*callWebview =[[UIWebView alloc] init];
            NSURL *telURL =[NSURL URLWithString:num];
            [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
            [self.view addSubview:callWebview];
        }
            break;
        case 101:
        {
            if (![GlobalController isLogin]) {
                
                LoginController *loginVC = [[LoginController alloc] init];
                
                [self.navigationController pushViewController:loginVC animated:YES];
            }
            else {
                
                // 发送顾问默认欢迎文本
                NSDictionary *param = @{@"consultantUserId":model.c_consultantUserId};
                NSString *urlString = [SDD_MainURL stringByAppendingString:@"/user/getIMDefaultWelcomeText.do"];              // 拼接主路径和请求内容成完整url
                [self sendRequest:param url:urlString];
                
                self.hidesBottomBarWhenPushed = YES;
                ChatViewController *cvc = [[ChatViewController alloc] initWithChatter:[NSString stringWithFormat:@"%@",model.c_consultantUserId] isGroup:FALSE];
                cvc.userName = model.c_realName;
                [self.navigationController pushViewController:cvc animated:true];
            }
        }
            break;
            
        default:
            break;
    }
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
