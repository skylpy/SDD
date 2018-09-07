//
//  MoreViewController.m
//  SDD
//
//  Created by mac on 15/10/22.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "MoreViewController.h"
#import "JoinUsViewController.h"
#import "QuestionnaireViewController.h"
#import "JoinViewController.h"
#import "QuestViewController.h"
#import "FeedbackViewController.h"
#import "JoinInSBViewController.h"
#import "CommonToolController.h"

@interface MoreViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray * _dataArray;
    NSArray * _imageArray;
}
@property (retain,nonatomic)UITableView * table;
@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    [self createNvn];
    [self createView];
    [self initData];
}
-(void)initData
{
    _dataArray = @[@"加入我们",@"调查问卷",@"加盟商多多",@"用户反馈"];
    _imageArray = @[@"jiaruwomen",@"tiaochawenjuan",@"jiamengshangduoduo",@"set_tickling"];//,@"jiancha"
    
}
-(void)createView
{
    _table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _table.delegate = self;
    _table.dataSource = self;
    _table.backgroundColor = bgColor;
    _table.scrollEnabled = NO;
    [self.view addSubview:_table];
    
   self.table.tableFooterView = [UIView new];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }
    else{
        return 10;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _dataArray.count;
    }
    else
    {
        return 1;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:_imageArray[indexPath.row]];
        cell.textLabel.text = _dataArray[indexPath.row];
    }
    else{
        
        cell.imageView.image = [UIImage imageNamed:@"shezhi"];
        cell.textLabel.text = @"设置";
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0:
            {
                JoinUsViewController *joinUsVC = [[JoinUsViewController alloc] init];
                [self.navigationController pushViewController:joinUsVC animated:YES];
            }
                break;
            case 1:
            {
                QuestionnaireViewController *QuestVC = [[QuestionnaireViewController alloc] init];
                //QuestViewController *QuestVC = [[QuestViewController alloc] init];
                [self.navigationController pushViewController:QuestVC animated:YES];
            }
                break;
            case 2:
            {
                JoinInSBViewController *joinUsVC = [[JoinInSBViewController alloc] init];
                //JoinViewController *joinUsVC = [[JoinViewController alloc] init];
                [self.navigationController pushViewController:joinUsVC animated:YES];
            }
                break;
            default:
            {
                //            NSLog(@"去评价");
                //            // 评分
                //            NSString *str = [NSString stringWithFormat:
                //                             @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",
                //                             @"1032683390"];
                //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                FeedbackViewController *feedbackVC = [[FeedbackViewController alloc] init];
                [self.navigationController pushViewController:feedbackVC animated:YES];
            }
                break;
        }

    }
    else{
        
        CommonToolController *ctVC = [[CommonToolController alloc] init];
        
        //self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
        [self.navigationController pushViewController:ctVC animated:YES];
    
    }
}
#pragma mark - 设置导航条
-(void)createNvn{
    
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"更多";
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
