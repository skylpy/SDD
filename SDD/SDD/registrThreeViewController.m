//
//  registrThreeViewController.m
//  SDD
//
//  Created by hua on 15/10/28.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "registrThreeViewController.h"
#import "registrFourViewController.h"

@interface registrThreeViewController ()
{
    UITextField *nameTextfield;                   /**< 姓名 */
}

@end

@implementation registrThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:(234/255.0) green:((234)/255.0) blue:((234)/255.0) alpha:(1.0)];
    
    [self createNvn];
    
    [self createUI];
    // Do any additional setup after loading the view.
}

-(void)createUI
{
    UILabel *titLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, viewWidth - 20, 25)];
    titLabel.font = midFont;
    titLabel.text = @"填写真实姓名更利于获得帮助";
    titLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titLabel];
    
    nameTextfield = [[UITextField alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(titLabel.frame)+25, viewWidth - 20, 45)];
    nameTextfield.placeholder = @"姓名 请填写20字以内";
    nameTextfield.backgroundColor = [UIColor whiteColor];
    nameTextfield.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:nameTextfield];
    
    //下一步按钮
    ConfirmButton *nextButton = [[ConfirmButton alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(nameTextfield.frame)+25, viewWidth - 20, 45)
                                                               title:@"下一步"
                                                              target:self
                                                              action:@selector(secondStep)];
    nextButton.enabled = YES;
    [self.view addSubview:nextButton];
}

-(void)secondStep
{
    if (nameTextfield.text.length<1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请填写姓名"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else{
        registrFourViewController *viewController = [[registrFourViewController alloc] init];
        viewController.phoneStr = _phoneStr;
        viewController.codeStr = _codeStr;
        viewController.nameStr = nameTextfield.text;
        viewController.num = _num;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

-(void)createNvn
{
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"填写姓名";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    //    UIButton * rightBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    //    rightBtn.frame = CGRectMake(0, 0, 15, 15);
    //    [rightBtn setBackgroundImage:[UIImage imageNamed:@"分享-图标"] forState:UIControlStateNormal];
    //
    //    UIBarButtonItem * rigItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    //    self.navigationItem.rightBarButtonItem = rigItem;
    
}

- (void)leftButtonClick
{
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
