//
//  SignUpSuccessViewController.m
//  SDD
//
//  Created by mac on 15/8/19.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "SignUpSuccessViewController.h"
#import "ThemeApplyCell.h"
#import "ProjectRentViewController.h"

@interface SignUpSuccessViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    ConfirmButton * conBrandBtn;
    
    NSArray * arr;
}
@property (retain,nonatomic)UITableView * tableView;

@end

@implementation SignUpSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    
    NSString * str2 = _model.address;
//    if (_actNum == 1) {
//        str2 =_temDic[@"forumsAddress"];
//    }
//    else
//    {
//        str2 =_temDic[@"activityAddress"];
//    }
//
    NSString * str3 =[NSString stringWithFormat:@"%@",_model.time];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:MM"];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[NSString stringWithFormat:@"%@",str3] intValue]];
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
//

    NSString * str4 = _dataArray[1];
     NSString * strname = _dataArray[0];
    NSString * indStr = _dataArray[2];
    NSString * brandStr = _dataArray[3];
    
    arr = @[confromTimespStr ,str2,str4,strname,indStr,brandStr];
    
    [self createNvn];
    [self createView];
}

-(void)createView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 50)];
    footView.backgroundColor = bgColor;
    _tableView.tableFooterView = footView;
    
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 115)];
    topView.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = topView;
    
    UIImageView * logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(60, 25, 20, 20)];
    logoImage.image = [UIImage imageNamed:@"coupons_icon_successful_blue@2x"];
    [topView addSubview:logoImage];

    
    UILabel * titLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, viewWidth, 20)];
    titLabel.text = @"恭喜您报名成功！";
    titLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:titLabel];

    
    UILabel * conLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, viewWidth, 15)];
    conLabel.text = @"恭喜，您成功报名了主题论坛活动，可在";
    conLabel.textAlignment = NSTextAlignmentCenter;
    conLabel.font = titleFont_15;
    conLabel.textColor = lgrayColor;
    [topView addSubview:conLabel];
    
    UILabel * conLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, viewWidth, 15)];
    conLabel1.text = @"“我的-活动”中查看详细情况";
    conLabel1.textAlignment = NSTextAlignmentCenter;
    conLabel1.font = titleFont_15;
    conLabel1.textColor = lgrayColor;
    [topView addSubview:conLabel1];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            return 65;
        }
        return 44;
    }
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 7;
    }
    else
    {
        return 1;
    }
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString * cellId = @"cellThID";
        ThemeApplyCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[ThemeApplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray * titArr = @[@"活动时间:",@"活动地点:",@"报名人数:",@"6月30日 10:10 (周六)",@"广州市天河区林和西路161号中泰国际广场B座2007",@"1"];
        
        NSArray * mtitArr = @[@"姓名:",@"行业:",@"品牌:",@"我是帅哥",@"主力店",@"阿蒙"];
        switch (indexPath.row) {
            case 0:
            {
                cell.starLable.text = @"商多多首届投资人见面会";
                [cell.nameLable removeFromSuperview];
                [cell.textField removeFromSuperview];
                [cell.chooseLable removeFromSuperview];
                [cell.MchooseLable removeFromSuperview];
            }
                break;
            case 1:
                cell.chooseLable.text = arr[indexPath.row-1];
            case 2:
                cell.chooseLable.text = arr[indexPath.row-1];
            case 3:
            {
                cell.nameLable.text = titArr[indexPath.row-1];
                cell.chooseLable.text = arr[indexPath.row-1];
                [cell.textField removeFromSuperview];
                [cell.starLable removeFromSuperview];
                [cell.MchooseLable removeFromSuperview];
                if (indexPath.row == 2) {
                    cell.chooseLable.numberOfLines = 0;
                    UILabel * linelable =(UILabel *)[cell viewWithTag:100];
                    linelable.frame = CGRectMake(10, 64, viewWidth-20, 1);
                }
            }
                break;
            default:
            {
                cell.nameLable.text = mtitArr[indexPath.row-4];
                cell.MchooseLable.text = arr[indexPath.row-1];
                [cell.textField removeFromSuperview];
                [cell.starLable removeFromSuperview];
                [cell.chooseLable removeFromSuperview];
            }
                break;
        }
        return cell;
    }
    else
    {
        static NSString * cellId = @"cellID";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        conBrandBtn = [[ConfirmButton alloc] initWithFrame:CGRectMake(20, 7, viewWidth-40, 45) title:@"确定" target:self action:@selector(signUpClick:)];
        conBrandBtn.enabled = YES;
        [cell.contentView addSubview:conBrandBtn];
        return cell;
    }
}

#pragma mark --  立即报名按钮
-(void)signUpClick:(UIButton *)Btn
{
    NSLog(@"报名按钮*--------*");
//    ProjectRentViewController * PrVc = [[ProjectRentViewController alloc] init];
//    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;
//    [self.navigationController pushViewController:PrVc animated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)createNvn
{
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"报名成功";
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
