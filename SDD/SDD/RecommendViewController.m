//
//  RecommendViewController.m
//  SDD
//
//  Created by hua on 15/6/26.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "RecommendViewController.h"
#import "CWStarRateView.h"

@interface RecommendViewController ()<CWStarRateViewDelegate>{
    
    float scores;
    UITextField *recommand;
}

@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 导航条
    [self setupNav];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置导航条
- (void)setupNav{
    
    SDDButton *button = [[SDDButton alloc]init];
    button.frame = CGRectMake(0, 0, 100, 44);
    [button setTitle:@"我来点评" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    CWStarRateView *_starRate = [[CWStarRateView alloc]initWithFrame:CGRectMake(0, 0, viewWidth-32, 30) numberOfStars:5];
    _starRate.hasAnimation = YES;
    _starRate.scorePercent = 0;
    _starRate.delegate = self;
    [self.view addSubview:_starRate];
    
    [_starRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(12);
        make.left.equalTo(self.view.mas_left).with.offset(16);
        make.right.equalTo(self.view.mas_right).with.offset(-16);
        make.height.equalTo(@30);
    }];
    
    NSArray *appraiseTitle = @[@"差评",@"一般",@"满意",@"非常满意",@"无可挑剔"];
    UIView *lastView;
    
    for (int i=0; i<5; i++) {
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = lgrayColor;
        label.font = littleFont;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = appraiseTitle[i];
        [self.view addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_starRate.mas_bottom).with.offset(12);
            lastView? make.left.equalTo(lastView.mas_right):make.left.equalTo(self.view.mas_left).with.offset(13);
            make.width.mas_equalTo((viewWidth-26)/5);
            make.height.equalTo(@10);
        }];
        
        lastView = label;
    }
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIView *division = [[UIView alloc] init];
    division.backgroundColor = divisionColor;
    [bottomView addSubview:division];
    
    recommand = [[UITextField alloc] init];;
    recommand.font = largeFont;
    recommand.backgroundColor = [UIColor whiteColor];
    recommand.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    recommand.placeholder = @"我来点评...";
    [Tools_F setViewlayer:recommand cornerRadius:4 borderWidth:1 borderColor:lgrayColor];
//    [recommand becomeFirstResponder];
    [bottomView addSubview:recommand];
    
    UIButton *publish = [UIButton buttonWithType:UIButtonTypeCustom];
    publish.titleLabel.font = largeFont;
    publish.backgroundColor = [UIColor whiteColor];
    [publish setTitle:@"发表" forState:UIControlStateNormal];
    [publish setTitleColor:[SDDColor colorWithHexString:@"#008fec"] forState:UIControlStateNormal];
    [Tools_F setViewlayer:publish cornerRadius:4 borderWidth:1 borderColor:[SDDColor colorWithHexString:@"#008fec"]];
    [publish addTarget:self action:@selector(publish:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:publish];
    
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 40));
    }];
    
    [division mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top);
        make.left.equalTo(bottomView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 1));
    }];
    
    [recommand mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(division.mas_bottom).with.offset(5);
        make.bottom.equalTo(bottomView.mas_bottom).with.offset(-5);
        make.left.equalTo(bottomView.mas_left).with.offset(8);
        make.right.equalTo(publish.mas_left).with.offset(-10);
    }];
    
    [publish mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(division.mas_bottom).with.offset(5);
        make.bottom.equalTo(bottomView.mas_bottom).with.offset(-5);
        make.right.equalTo(bottomView.mas_right).with.offset(-8);
        make.width.equalTo(@70);
    }];
}

- (void)starRateView:(CWStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent{
    
    scores = newScorePercent;
}

#pragma mark - 发布
- (void)publish:(UIButton *)btn{
    
    // 请求参数
    NSDictionary *param = @{@"starScore":[NSNumber numberWithFloat:scores*5],
                            @"description":recommand.text,
                            @"brandId":_brandId
                            };
   NSDictionary *param1 = @{@"serviceScore":[NSNumber numberWithFloat:scores*5],
                           @"productScore":[NSNumber numberWithFloat:scores*5],
                           @"priceScore":[NSNumber numberWithFloat:scores*5],
                           @"description":recommand.text,
                           @"competeScore":[NSNumber numberWithFloat:scores*5],
                           @"positionScore":[NSNumber numberWithFloat:scores*5],
                           @"brandId":_brandId};
    NSLog(@"%@~~~~~",param);
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brand/add/comment.do" params:param1 success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        
        if ([JSON[@"status"] intValue] == 1) {
            
            [self showSuccessWithText:@"评论成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            
            [self showErrorWithText:JSON[@"message"]];
        }
        
    } failure:^(NSError *error) {
        
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
