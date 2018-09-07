//
//  MyCertificationViewController.m
//  SDD
//
//  Created by mac on 15/8/13.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "MyCertificationViewController.h"
#import "MyCerSlideView.h"
#import "ConfirmButton.h"
#import "Header.h"
#import "UserInfo.h"
#import "CertifyFirstStep.h"
#import "SDD_BasicInformation.h"
#import "BrankPublishViewController.h"
#import "BrankAuthenticationViewController.h"

#import "DevCerViewController.h"

@interface MyCertificationViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    SDDButton *SDDbutton;
    UIImageView *logoimageView;
    NSString * Developer;
    NSString * Brand;
    UILabel *label ;
    UILabel *label1;
    UIButton * conBrandBtn1;
    UIButton * conBrandBtn2;
}
@property (strong, nonatomic) MyCerSlideView *myCerSlideView;
@property (assign) NSInteger tabCount;

@end

@implementation MyCertificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    label = [[UILabel alloc] init];
    label1 = [[UILabel alloc] init];
    [self initWithBtn];
    
    [self createNvn];
    Developer = @"";
    Brand = @"";
    _tabCount = 2;
    [self initSlideWithCount:_tabCount];
}
-(void)initWithBtn
{
    conBrandBtn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [conBrandBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [conBrandBtn1 setBackgroundImage:[Tools_F imageWithColor:dblueColor
                                                        size:CGSizeMake(viewWidth-40, 45)]
                            forState:UIControlStateNormal];
    
    [conBrandBtn1 setBackgroundImage:[Tools_F imageWithColor:[SDDColor colorWithHexString:@"006699"]
                                                        size:CGSizeMake(viewWidth-40, 45)]
                            forState:UIControlStateHighlighted];
    [conBrandBtn1 addTarget:self action:@selector(ConBrand:) forControlEvents:UIControlEventTouchUpInside];
    [Tools_F setViewlayer:conBrandBtn1 cornerRadius:5 borderWidth:0 borderColor:nil];
    

    
    
    conBrandBtn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [conBrandBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [conBrandBtn2 setBackgroundImage:[Tools_F imageWithColor:dblueColor
                                                        size:CGSizeMake(viewWidth-40, 45)]
                            forState:UIControlStateNormal];
    
    [conBrandBtn2 setBackgroundImage:[Tools_F imageWithColor:[SDDColor colorWithHexString:@"006699"]
                                                        size:CGSizeMake(viewWidth-40, 45)]
                            forState:UIControlStateHighlighted];//DeveloperClick  ConRelease
    [conBrandBtn2 addTarget:self action:@selector(ConRelease:) forControlEvents:UIControlEventTouchUpInside];
    [Tools_F setViewlayer:conBrandBtn2 cornerRadius:5 borderWidth:0 borderColor:nil];
    
}
-(void) initSlideWithCount: (NSInteger) count{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    screenBound.origin.y = 0;
    
    _myCerSlideView = [[MyCerSlideView alloc] initWithFrame:screenBound WithCount:count];
    
    _myCerSlideView.DeveloperTableView.delegate = self;
    _myCerSlideView.DeveloperTableView.dataSource = self;
    _myCerSlideView.DeveloperTableView.backgroundColor = bgColor;
    
    _myCerSlideView.BrandsTableView.delegate = self;
    _myCerSlideView.BrandsTableView.dataSource = self;
    _myCerSlideView.BrandsTableView.backgroundColor = bgColor;

    
    [self.view addSubview:_myCerSlideView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 200;
    }
    return 60;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"cellMyCer";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        logoimageView = [[UIImageView alloc] init];
        
    }
    
    logoimageView.image = [UIImage imageNamed:@"icon_nodataface"];

    if (tableView == _myCerSlideView.DeveloperTableView) {
        if (indexPath.row == 0) {
            
            [cell.contentView addSubview:logoimageView];
            [logoimageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView.mas_top).offset(30);
                make.centerX.equalTo(cell.contentView.mas_centerX);
                make.size.mas_equalTo(CGSizeMake(135, 135));
            }];
            
            label.font = titleFont_15;
            label.textColor = lgrayColor;
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(logoimageView.mas_bottom).offset(15);
                make.centerX.equalTo(cell.contentView.mas_centerX);
                make.height.greaterThanOrEqualTo(@14);
                make.width.mas_equalTo(viewWidth-20);
            }];
            if ([[NSString stringWithFormat:@"%@",[UserInfo sharedInstance].userInfoDic[@"isHouseUser"]] integerValue]==0) {
                label.text = @"您当前还没通过开发商认证。";
            }
            if ([[NSString stringWithFormat:@"%@",[UserInfo sharedInstance].userInfoDic[@"isHouseUser"]] integerValue]==1) {
                label.text = @"您已通过认证，可以发布信息咯。";
            }
            if ([[NSString stringWithFormat:@"%@",[UserInfo sharedInstance].userInfoDic[@"isHouseUser"]] integerValue]==2) {
                label.text = @"您的认证在审核中，请耐心等待哦！";
            }
            if ([[NSString stringWithFormat:@"%@",[UserInfo sharedInstance].userInfoDic[@"isHouseUser"]] integerValue]==-1) {
                label.text = @"您的认证没通过，请重新认证或联系我们。";
            }
            
        }
        if (indexPath.row == 1) {
            
            if ([[NSString stringWithFormat:@"%@",[UserInfo sharedInstance].userInfoDic[@"isHouseUser"]] integerValue]==0) {
                Developer = @"马上认证";
            }
            if ([[NSString stringWithFormat:@"%@",[UserInfo sharedInstance].userInfoDic[@"isHouseUser"]] integerValue]==1) {
                Developer = @"马上发布";
            }
            if ([[NSString stringWithFormat:@"%@",[UserInfo sharedInstance].userInfoDic[@"isHouseUser"]] integerValue]==2) {
                Developer = @"审核中";
                conBrandBtn2.enabled = NO;
                [conBrandBtn2 setBackgroundImage:[Tools_F imageWithColor:lgrayColor
                                                                    size:CGSizeMake(viewWidth-40, 45)]
                                        forState:UIControlStateNormal];
            }
            if ([[NSString stringWithFormat:@"%@",[UserInfo sharedInstance].userInfoDic[@"isHouseUser"]] integerValue]==-1) {
                Developer = @"重新认证";
            }

            [conBrandBtn2 setTitle:Developer forState:UIControlStateNormal];
            
            [cell.contentView addSubview:conBrandBtn2];
            [conBrandBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.mas_top).with.offset(10);
                make.left.equalTo(cell.mas_left).with.offset(20);
                make.right.equalTo(cell.mas_right).with.offset(-20);
                make.height.equalTo(@45);
            }];
            
        }
        
    }
    
    if (tableView == _myCerSlideView.BrandsTableView) {
        if (indexPath.row == 0) {
            
            [cell.contentView addSubview:logoimageView];
            [logoimageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView.mas_top).offset(30);
                make.centerX.equalTo(cell.contentView.mas_centerX);
                make.size.mas_equalTo(CGSizeMake(135, 135));
            }];
            
            label1.font = titleFont_15;
            label1.textColor = lgrayColor;
            label1.textAlignment = NSTextAlignmentCenter;
            //label.text = @"你已通过认证，可以发布信息咯";
            label1.numberOfLines = 0;
            [cell.contentView addSubview:label1];
            [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(logoimageView.mas_bottom).offset(15);
                make.centerX.equalTo(cell.contentView.mas_centerX);
                make.height.greaterThanOrEqualTo(@14);
                make.width.mas_equalTo(viewWidth-20);
            }];
            
            if ([[NSString stringWithFormat:@"%@",[UserInfo sharedInstance].userInfoDic[@"isBrandUser"]] integerValue]==0) {
                label1.text = @"您当前还没认证品牌。";
            }
            if ([[NSString stringWithFormat:@"%@",[UserInfo sharedInstance].userInfoDic[@"isBrandUser"]] integerValue]==1) {
                label1.text = @"您已通过认证，可以发布信息咯。";
            }
            if ([[NSString stringWithFormat:@"%@",[UserInfo sharedInstance].userInfoDic[@"isBrandUser"]] integerValue]==2) {
                label1.text = @"您的认证在审核中，请耐心等待哦！";
            }
            if ([[NSString stringWithFormat:@"%@",[UserInfo sharedInstance].userInfoDic[@"isBrandUser"]] integerValue]==-1) {
                label1.text = @"您的认证没通过，请重新认证或联系我们。";
            }
            
        }
        if (indexPath.row == 1) {
            if ([[NSString stringWithFormat:@"%@",[UserInfo sharedInstance].userInfoDic[@"isBrandUser"]] integerValue]==0) {
                Brand = @"马上认证";
            }
            if ([[NSString stringWithFormat:@"%@",[UserInfo sharedInstance].userInfoDic[@"isBrandUser"]] integerValue]==1) {
                Brand = @"马上发布";
            }
            if ([[NSString stringWithFormat:@"%@",[UserInfo sharedInstance].userInfoDic[@"isBrandUser"]] integerValue]==2) {
                Brand = @"审核中";
                conBrandBtn1.enabled = NO;
                [conBrandBtn1 setBackgroundImage:[Tools_F imageWithColor:lgrayColor
                                                                    size:CGSizeMake(viewWidth-40, 45)]
                                        forState:UIControlStateNormal];
            }
            if ([[NSString stringWithFormat:@"%@",[UserInfo sharedInstance].userInfoDic[@"isBrandUser"]] integerValue]==-1) {
                Brand = @"重新认证";
            }
            
            
            [conBrandBtn1 setTitle:Brand forState:UIControlStateNormal];
            
            [cell.contentView addSubview:conBrandBtn1];
            [conBrandBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.mas_top).with.offset(10);
                make.left.equalTo(cell.mas_left).with.offset(20);
                make.right.equalTo(cell.mas_right).with.offset(-20);
                make.height.equalTo(@45);
            }];
            

        }
        
    }
    
    
    cell.backgroundColor = bgColor;
    CELLSELECTSTYLE
    return cell;
}
#pragma mark -- 发展商按钮
-(void)ConRelease:(UIButton *)Btn
{
    
    if ([[NSString stringWithFormat:@"%@",[UserInfo sharedInstance].userInfoDic[@"isHouseUser"]] integerValue]==0)
    {
        //CertifyFirstStep * cerVc = [[CertifyFirstStep alloc] init];
        DevCerViewController * cerVc = [[DevCerViewController alloc] init];
        [self.navigationController pushViewController:cerVc animated:YES];
    }
    if ([[NSString stringWithFormat:@"%@",[UserInfo sharedInstance].userInfoDic[@"isHouseUser"]] integerValue]==1)
    {
        SDD_BasicInformation * BaseVc = [[SDD_BasicInformation alloc] init];
        BaseVc.page = 1;
        [self.navigationController pushViewController:BaseVc animated:YES];
    }
    if ([[NSString stringWithFormat:@"%@",[UserInfo sharedInstance].userInfoDic[@"isHouseUser"]] integerValue]==2)
    {
        //CertifyFirstStep * cerVc = [[CertifyFirstStep alloc] init];
        DevCerViewController * cerVc = [[DevCerViewController alloc] init];
        [self.navigationController pushViewController:cerVc animated:YES];
    }
    if ([[NSString stringWithFormat:@"%@",[UserInfo sharedInstance].userInfoDic[@"isHouseUser"]] integerValue]==-1)
    {
        DevCerViewController * cerVc = [[DevCerViewController alloc] init];
        [self.navigationController pushViewController:cerVc animated:YES];
    }
}

#pragma mark -- 发展商按钮
-(void)DeveloperClick:(UIButton *)btn
{
    //CertifyFirstStep * CerVc = [[CertifyFirstStep alloc] init];
    DevCerViewController * CerVc = [[DevCerViewController alloc] init];
    [self.navigationController pushViewController:CerVc animated:YES];
}

#pragma mark --  品牌商按钮
-(void)ConBrand:(UIButton *)Btn
{
    if ([[NSString stringWithFormat:@"%@",[UserInfo sharedInstance].userInfoDic[@"isBrandUser"]] integerValue]==0)
    {
        BrankAuthenticationViewController *baVC = [[BrankAuthenticationViewController alloc] init];
        [self.navigationController pushViewController:baVC animated:YES];
    }
    if ([[NSString stringWithFormat:@"%@",[UserInfo sharedInstance].userInfoDic[@"isBrandUser"]] integerValue]==1)
    {
        BrankPublishViewController *bpVC = [[BrankPublishViewController alloc] init];
        [self.navigationController pushViewController:bpVC animated:YES];
    }
    if ([[NSString stringWithFormat:@"%@",[UserInfo sharedInstance].userInfoDic[@"isBrandUser"]] integerValue]==2)
    {
        BrankAuthenticationViewController *baVC = [[BrankAuthenticationViewController alloc] init];
        [self.navigationController pushViewController:baVC animated:YES];
    }
    if ([[NSString stringWithFormat:@"%@",[UserInfo sharedInstance].userInfoDic[@"isBrandUser"]] integerValue]==-1)
    {
        BrankAuthenticationViewController *baVC = [[BrankAuthenticationViewController alloc] init];
        [self.navigationController pushViewController:baVC animated:YES];
    }

}
-(void)createNvn
{
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"我的认证";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
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
