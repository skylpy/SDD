//
//  ReviewViewController.m
//  SDD
//
//  Created by hua on 15/4/13.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ReviewViewController.h"
#import "ReviewView.h"

#import "LPlaceholderTextView.h"

@interface ReviewViewController ()<UIGestureRecognizerDelegate,CWStarRateViewDelegate>{
    
    // 价格
    ReviewView *thePrice;
    // 区位
    ReviewView *theLocation;
    // 配套
    ReviewView *theSet;
    // 交通
    ReviewView *theTraffic;
    // 政策
    ReviewView *thePolicy;
    // 竞争力
    ReviewView *theCompetitiveness;
    // 综合评价
    UILabel *averageScore;
    
    LPlaceholderTextView *reviewText;
}

// 网络请求
@property (nonatomic, strong) AFHTTPRequestOperationManager *httpManager;

@end

@implementation ReviewViewController

- (AFHTTPRequestOperationManager *)httpManager
{
    if(!_httpManager)
    {
        _httpManager = [AFHTTPRequestOperationManager manager];
        //        httpManager.requestSerializer.timeoutInterval = 15;         //设置超时时间
        _httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];        // ContentTypes 为json
    }
    return _httpManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    titleLabel.text = @"在线评房";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

#pragma mark - 设置内容
- (void)setupUI{
    
    // 价格
    thePrice = [[ReviewView alloc]initWithFrame:CGRectMake(0, 15, viewWidth-20, 15)];
    thePrice.starTitle.text = @"价格";
    thePrice.starRate.scorePercent = 0;
    thePrice.starRate.delegate = self;
    [self.view addSubview:thePrice];
    
    // 区位
    theLocation = [[ReviewView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(thePrice.frame)+10, viewWidth-20, 15)];
    theLocation.starTitle.text = @"区位";
    theLocation.starRate.scorePercent = 0;
    theLocation.starRate.delegate = self;
    [self.view addSubview:theLocation];
    
    // 配套
    theSet = [[ReviewView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(theLocation.frame)+10, viewWidth-20, 15)];
    theSet.starTitle.text = @"配套";
    theSet.starRate.scorePercent = 0;
    theSet.starRate.delegate = self;
    [self.view addSubview:theSet];
    
    // 交通
    theTraffic = [[ReviewView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(theSet.frame)+10, viewWidth-20, 15)];
    theTraffic.starTitle.text = @"交通";
    theTraffic.starRate.scorePercent = 0;
    theTraffic.starRate.delegate = self;
    [self.view addSubview:theTraffic];
    
    // 政策
    thePolicy = [[ReviewView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(theTraffic.frame)+10, viewWidth-20, 15)];
    thePolicy.starTitle.text = @"政策";
    thePolicy.starRate.scorePercent = 0;
    thePolicy.starRate.delegate = self;
    [self.view addSubview:thePolicy];
    
    // 竞争力
    theCompetitiveness = [[ReviewView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(thePolicy.frame)+10, viewWidth-20, 15)];
    theCompetitiveness.starTitle.text = @"竞争力";
    theCompetitiveness.starRate.scorePercent = 0;
    theCompetitiveness.starRate.delegate = self;
    [self.view addSubview:theCompetitiveness];
    
    //综合评价
    averageScore = [[UILabel alloc] init];
    averageScore.frame = CGRectMake(10, CGRectGetMaxY(theCompetitiveness.frame)+15, viewWidth/2, 16);
    averageScore.font = largeFont;
    averageScore.text = @"综合评价: 0.0分";
    averageScore.textColor = deepBLack;
    [self.view addSubview:averageScore];
    
    // 评价内容
    reviewText = [[LPlaceholderTextView alloc]init];
    reviewText.frame = CGRectMake(10, CGRectGetMaxY(averageScore.frame)+8, viewWidth - 20, 100);
    reviewText.font = midFont;
    reviewText.placeholderText = @"请输入点评内容";
    reviewText.placeholderColor = setColor(100, 100, 100, 1);
    [Tools_F setViewlayer:reviewText cornerRadius:0.0 borderWidth:1 borderColor:divisionColor];
    [self.view addSubview:reviewText];
    
    // 马上点评
    ConfirmButton *applyBtn = [[ConfirmButton alloc] initWithFrame:CGRectMake(20, viewHeight-119, viewWidth - 40, 45)
                                                                title:@"马上点评"
                                                               target:self
                                                            action:@selector(applyClick:)];
    applyBtn.enabled = YES;
    [self.view addSubview:applyBtn];
    
}

- (void)starRateView:(CWStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent{
    
    ReviewView *review = (ReviewView *)starRateView.superview;
    review.score.text = [NSString stringWithFormat:@"%.1f分",newScorePercent*5];
    
    NSArray *scoreArr = @[[NSString stringWithFormat:@"%.1f",thePrice.starRate.scorePercent*5],
                          [NSString stringWithFormat:@"%.1f",theLocation.starRate.scorePercent*5],
                          [NSString stringWithFormat:@"%.1f",theSet.starRate.scorePercent*5],
                          [NSString stringWithFormat:@"%.1f",theTraffic.starRate.scorePercent*5],
                          [NSString stringWithFormat:@"%.1f",thePolicy.starRate.scorePercent*5],
                          [NSString stringWithFormat:@"%.1f",theCompetitiveness.starRate.scorePercent*5]
                          ];
    
    NSNumber *avg = [scoreArr valueForKeyPath:@"@avg.floatValue"];
    averageScore.text = [NSString stringWithFormat:@"综合评价:%.1f分",[avg floatValue]];
}

#pragma mark - 马上点评
- (void)applyClick:(UIButton *)btn{
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else if (reviewText.text.length<1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"评论内容不能为空哦~" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        
        NSDictionary *dic = @{@"supportingScore":[NSString stringWithFormat:@"%.1f",theSet.starRate.scorePercent*5],
                              @"policyScore":[NSString stringWithFormat:@"%.1f",thePolicy.starRate.scorePercent*5],
                              @"areaScore":[NSString stringWithFormat:@"%.1f",theLocation.starRate.scorePercent*5],
                              @"description":reviewText.text,
                              @"priceScore":[NSString stringWithFormat:@"%.1f",thePrice.starRate.scorePercent*5],
                              @"trafficScore":[NSString stringWithFormat:@"%.1f",theTraffic.starRate.scorePercent*5],
                              @"competeScore":[NSString stringWithFormat:@"%.1f",theCompetitiveness.starRate.scorePercent*5],
                              @"houseId":_houseID};
        
        [self requestApply:dic];
    }
}


- (void)requestApply:(NSDictionary *)param{
    
    NSString *str = [SDD_MainURL stringByAppendingString:@"/user/houseComment/addComment.do"];              // 拼接主路径和请求内容成完整url
    
    [self.httpManager POST:str parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = responseObject;
        NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
//        if ([dict[@"status"] intValue] == 1){
        
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"评论成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [self.navigationController popViewControllerAnimated:YES];
//        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
}

#pragma mark - leftaction
- (void)leftAction:(UIButton *)btn{
    
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
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
