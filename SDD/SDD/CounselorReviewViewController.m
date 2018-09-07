//
//  CounselorReviewViewController.m
//  SDD
//
//  Created by hua on 15/5/20.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "CounselorReviewViewController.h"
#import "ReviewView.h"

#import "LPlaceholderTextView.h"

@interface CounselorReviewViewController ()<CWStarRateViewDelegate>{
    
    
    // 竞争力
    ReviewView *theScore;
    // 综合评价
    UILabel *averageScore;
    // 评论内容
    LPlaceholderTextView *reviewText;
}

@end

@implementation CounselorReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = bgColor;
    // 设置导航条
    [self setNav:@"评价招商顾问"];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    // 评分
    theScore = [[ReviewView alloc]initWithFrame:CGRectMake(0, 20, viewWidth, 15)];
    theScore.starTitle.text = @"";
    theScore.starRate.scorePercent = 0;
    theScore.starRate.delegate = self;
    [self.view addSubview:theScore];
    
    // 评价
    averageScore = [[UILabel alloc] init];
    averageScore.frame = CGRectMake(10, CGRectGetMaxY(theScore.frame)+30, viewWidth/2, 16);
    averageScore.font = [UIFont systemFontOfSize:16];
    averageScore.text = @"评价: 0.0分";
    averageScore.textColor = deepBLack;
    [self.view addSubview:averageScore];
    
    // 评价内容
    reviewText = [[LPlaceholderTextView alloc]init];
    reviewText.frame = CGRectMake(10, CGRectGetMaxY(averageScore.frame)+8, viewWidth - 20, 100);
    reviewText.font = [UIFont systemFontOfSize:13];
    reviewText.placeholderText = @"请输入点评内容";
    reviewText.placeholderColor = setColor(100, 100, 100, 1);
    [Tools_F setViewlayer:reviewText cornerRadius:0.0 borderWidth:1 borderColor:divisionColor];
    [self.view addSubview:reviewText];
    
    // 提交
//    UIButton *apply = [UIButton buttonWithType:UIButtonTypeCustom];
//    apply.frame = CGRectMake(30, CGRectGetMaxY(reviewText.frame)+20, viewWidth-60, 30);
//    apply.backgroundColor = deepOrangeColor;
//    apply.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
//    [apply setTitle:@"提交" forState:UIControlStateNormal];
//    [apply setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [Tools_F setViewlayer:apply cornerRadius:5 borderWidth:0 borderColor:[UIColor clearColor]];
//    [apply addTarget:self action:@selector(applyClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:apply];
    
    // 提交
    ConfirmButton *applyBtn = [[ConfirmButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(reviewText.frame)+20, viewWidth - 40, 45)
                                                             title:@"马上点评"
                                                            target:self
                                                            action:@selector(applyClick:)];
    applyBtn.enabled = YES;
    [self.view addSubview:applyBtn];
}

- (void)starRateView:(CWStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent{
    
    ReviewView *review = (ReviewView *)starRateView.superview;
    review.score.text = [NSString stringWithFormat:@"%.1f分",newScorePercent*5];
    
    averageScore.text = [NSString stringWithFormat:@"评价:%.1f分",newScorePercent*5];
}


#pragma mark - 马上点评
- (void)applyClick:(UIButton *)btn{
    
    
    NSDictionary *param = @{@"commentContent":reviewText.text,
                            @"commentScore":[NSString stringWithFormat:@"%.1f",theScore.starRate.scorePercent*5],
                            @"consultantUserId":_consultantUserId};
    NSString *urlString = [SDD_MainURL stringByAppendingString:@"/user/house/addConsultantComment.do"];              // 拼接主路径和请求内容成完整url
    
    [self sendRequest:param url:urlString];
    [self showLoading:0];
}

- (void)onSuccess:(AFHTTPRequestOperation *)operation context:(id)responseObject{
    
    [self hideLoading];
    NSDictionary *dict = responseObject;
    NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
    
    [self showSuccessWithText:dict[@"message"]];
    
    if ([dict[@"status"] intValue] == 1) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)onFailure:(AFHTTPRequestOperation *)operation error:(NSError *)error{
    
    [self hideLoading];
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
