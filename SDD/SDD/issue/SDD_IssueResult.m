//
//  SDD_IssueResult.m
//  ShopMoreAndMore
//
//  Created by mac on 15/7/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SDD_IssueResult.h"
#import "PersonalViewController.h"
#import "Header.h"
@interface SDD_IssueResult ()
{
    SDDButton *SDDbutton;
}
@end

@implementation SDD_IssueResult

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [SDDColor colorWithHexString:@"#e5e5e5"];
    [self displayContext];
}
- (void)displayContext
{
    SDDbutton = [[SDDButton alloc]init];
    SDDbutton.frame = CGRectMake(0, 0, viewWidth*2/3, 44);
    [SDDbutton setTitle:@"发布结果" forState:UIControlStateNormal];
    [SDDbutton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:SDDbutton];
    
   
    
    UILabel *contextLa = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 85)];
    contextLa.text = @"          您的项目已进入商多多平台，商多多将您的\n                项目信息进行审核，3个工作日内\n                    会有专业客服人员与您联系,\n                                  请耐心等候!";
    contextLa.numberOfLines = 0;
    contextLa.backgroundColor = [UIColor whiteColor];
    contextLa.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    [self.view addSubview:contextLa];
   
    UILabel *successLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 39)];
    successLabel.numberOfLines = 0;
    successLabel.textAlignment = NSTextAlignmentCenter;
    successLabel.text = @"发布申请成功 !";
    successLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];;
    successLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:successLabel];
    UIImageView *checkImage = [[UIImageView alloc] initWithFrame:CGRectMake(70, 10, 20, 20)];
    checkImage.layer.cornerRadius = 5;
    checkImage.image = [UIImage imageNamed:@"release-application-is-successful_frame"];
    [self.view addSubview:checkImage];
    UIButton *myPerson = [[UIButton alloc] initWithFrame:CGRectMake(10, 135, viewWidth-20, 40)];
    myPerson.backgroundColor = dblueColor;//[SDDColor colorWithHexString:@"#e73820"]
    [myPerson addTarget:self action:@selector(myPerson) forControlEvents:UIControlEventTouchUpInside];
    [myPerson setTitle:@"随时随地查看项目进展" forState:UIControlStateNormal];
    [myPerson setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    myPerson.titleLabel.font = [UIFont systemFontOfSize:20];
    myPerson.layer.cornerRadius = 5;
    [self.view addSubview:myPerson];
}
- (void)myPerson
{
    PersonalViewController *myNewIssue = [[PersonalViewController alloc] init];
    [self.navigationController pushViewController:myNewIssue animated:YES];
}
- (void)leftButtonClick
{
    UIViewController *vc = [[self.navigationController viewControllers] objectAtIndex:3];
    [self.navigationController popToViewController:vc animated:YES];
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
