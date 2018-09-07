//
//  ActivityProcessViewController.m
//  SDD
//
//  Created by hua on 15/4/24.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ActivityProcessViewController.h"
#import "Tools_F.h"

#import "TTTAttributedLabel.h"

@interface ActivityProcessViewController ()<UIGestureRecognizerDelegate>

@end

@implementation ActivityProcessViewController

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
    button.frame = CGRectMake(0, 0, viewWidth*2/3, 44);
    [button setTitle:_theTitle forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];    
}

#pragma mark - 设置内容
- (void)setupUI{
    
    if ([_theTitle isEqualToString:@"免责声明"]) {
        
        UILabel *_introductionTitle = [[UILabel alloc] init];
        _introductionTitle.frame = CGRectMake(10, 10, viewWidth-20, 20);
        _introductionTitle.font = largeFont;
        _introductionTitle.textColor = mainTitleColor;
        _introductionTitle.text = @"商多多免责声明";
        
        [self.view addSubview:_introductionTitle];
        
        UILabel *_introductionContent = [[UILabel alloc] init];
        _introductionContent.frame = CGRectMake(10, CGRectGetMaxY(_introductionTitle.frame)+5, viewWidth-20, 20);
        _introductionContent.numberOfLines = 0;
        _introductionContent.font = midFont;
        _introductionContent.textColor = lgrayColor;
        _introductionContent.text = @"免责声明\n        1.商多多已尽力确保所有资料是准确、完整及最新的。就该资料的针对性、精确性以及特定用途的适合性而言，本网站不可能也无义务做出最对应和最有成效的方案。所以对本网站所引用的资料，本网站概不承诺对其针对性、精确性以及特定用途的适合性负责，同时因依赖该资料所至的任何损失，本网站亦不承担任何法律责任。\n        2. 商多多不保证所有信息、文本、图形、链接及其它项目的绝对准确性和完整性，故仅供访问者参照使用。其中政策法规中文本不得作为正式法规文本使用。\n        3. 如果单位或个人认为本网站某部分内容有侵权嫌疑，敬请立即通知我们，我们将第一时间予以更该或删除。本网站并不承担查清事情的责任和证实事情公正性和合法性的责任，同时在事情查清前保留对该部分内容继续刊载的权利。\n        4. 若商多多已经明示其网络服务提供方式发生变更并提醒普通会员应当注意事项，普通会员未按要求操作所产生的一切后果由普通会员自行承担。\n        5. 普通会员明确同意其使用商多多络服务所存在的风险将完全由其自己承担；因其使用商多多服务而产生的一切后果也由其自己承担，商多多对普通会员不承担任何责任。\n        6. 普通会员同意保障和维护商多多及其他普通会员的利益，由于普通会员登录网站内容违法、不真实、不正当、侵犯第三方合法权益，或普通会员违反本协议项下的任何条款而给商多多或任何其他第三人造成损失，普通会员同意承担由此造成的损害赔偿责任。\n        7. 以上信息均为转载自相关品牌商网站，商多多无法保证上述信息的真实性与准确性。如有任何疑问请咨询相关品牌商。";
        [_introductionContent sizeToFit];
        [self.view addSubview:_introductionContent];
    }
    else {
        
        TTTAttributedLabel *content = [[TTTAttributedLabel alloc] init];
        content.frame = CGRectMake(10, 10, viewWidth-20, viewHeight-64);
        content.font = midFont;
        content.textColor = lgrayColor;
        content.text = _theContent;
        content.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
        [self.view addSubview:content];
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
