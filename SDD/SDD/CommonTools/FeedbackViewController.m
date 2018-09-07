//
//  FeedbackViewController.m
//  SDD
//
//  Created by hua on 15/4/17.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "FeedbackViewController.h"
#import "LPlaceholderTextView.h"
#import "ProgressHUD.h"

@interface FeedbackViewController ()<UITextViewDelegate>{
    
    // 反馈内容
    LPlaceholderTextView *textView;
    // 联系方式
    LPlaceholderTextView *information;
}

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = bgColor;
    
    // 导航条
    [self setNav:NSLocalizedString(@"toolFeedback", @"")];
    // 设置内容
    [self setupUI];
}

- (void)commitFeedBackButton{
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else if (textView.text.length<10) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请最少输入十个字哦" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        
        NSDictionary *dict = @{@"content":textView.text,
                               @"appVersion":@"2.0.0",
                               @"contact":information.text};
        
        [HttpTool postWithBaseURL:SDD_MainURL Path:@"/userFeedback/feedback.do" params:dict success:^(id JSON) {
            
            NSLog(@"Json == %@", JSON);
            [ProgressHUD showSuccess:JSON[@"message"]];
            
            if ([JSON[@"status"] intValue] == 1) {
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } failure:^(NSError *error) {
            
            NSLog(@"error == %@", error);
        }];
    }
}

#pragma mark - 设置内容
- (void)setupUI{
    
    UIView *feedback_bg = [[UIView alloc] init];
    feedback_bg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:feedback_bg];
    [feedback_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, viewHeight*0.5));
    }];
    
    UILabel * title = [[UILabel alloc] init];
    title.font = titleFont_15;
    title.numberOfLines = 0;
    title.text = @"如果您在使用商多多用户板的过程中遇到任何问题，请留下您宝贵的建议和联系方式，我们会及时与您取得联系：";
    [feedback_bg addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(feedback_bg.mas_top).offset(10);
        make.left.equalTo(feedback_bg.mas_left).offset(10);
        make.right.equalTo(feedback_bg.mas_right).offset(-10);
        //make.size.mas_equalTo(CGSizeMake(viewWidth-20, viewHeight*0.3));
    }];
    
    textView = [[LPlaceholderTextView alloc] init];
    textView.placeholderColor = lgrayColor;
    textView.font = midFont;
    textView.textColor = mainTitleColor;
    textView.placeholderText = @"请至少输入10个字的意见反馈";//@"请留下您的宝贵意见或建议（不少于10个汉字)";
    textView.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    textView.layer.borderWidth = 0.6f;
    textView.layer.cornerRadius = 6.0f;
    [feedback_bg addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(10);
        make.left.equalTo(feedback_bg.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(viewWidth-20, viewHeight*0.3));
    }];
    
    // 分割线
//    UIView *division = [[UIView alloc] init];
//    division.backgroundColor = ldivisionColor;
//    [feedback_bg addSubview:division];
//    [division mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(textView.mas_bottom);
//        make.left.equalTo(feedback_bg.mas_left);
//        make.size.mas_equalTo(CGSizeMake(viewWidth, 1));
//    }];
//    
//    // 联系方式
//    UILabel *label2 = [[UILabel alloc] init];
//    label2.font = titleFont_15;
//    label2.textColor = mainTitleColor;
//    label2.text = @"联系方式(必填)";
//    [feedback_bg addSubview:label2];
//    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(division.mas_bottom).offset(10);
//        make.left.equalTo(feedback_bg.mas_left).offset(10);
//        make.size.mas_equalTo(CGSizeMake(viewWidth, 20));
//    }];
    
    information = [[LPlaceholderTextView alloc] init];
    information.placeholderColor = lgrayColor;
    information.font = midFont;
    information.textColor = mainTitleColor;
    information.placeholderText = @"您的手机号码";
    information.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    information.layer.borderWidth = 0.6f;
    information.layer.cornerRadius = 6.0f;
    [feedback_bg addSubview:information];
    [information mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textView.mas_bottom).offset(10);
        //make.bottom.equalTo(feedback_bg.mas_bottom).offset(-10);
        make.left.equalTo(feedback_bg.mas_left).offset(10);
        make.width.mas_equalTo(viewWidth-20);
        make.height.equalTo(@40);
    }];
    
    // 退出按钮
    ConfirmButton *takeit = [[ConfirmButton alloc] initWithFrame:CGRectMake(20, 5, viewWidth - 40, 45)
                                                                title:@"提交"
                                                               target:self
                                                               action:@selector(commitFeedBackButton)];
    takeit.enabled = YES;
    
    [self.view addSubview:takeit];
    [takeit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(feedback_bg.mas_bottom).offset(30);
        make.left.equalTo(feedback_bg.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(viewWidth-40, 45));
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


@end
