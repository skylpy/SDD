//
//  ActivityViewController.m
//  SDD
//
//  Created by mac on 15/8/18.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ActivityViewController.h"
#import "ActivityCell.h"
#import "ThemeViewController.h"
#import "ProjectActivitiesViewController.h"
#import "ADelegationViewController.h"
//#import "ActivityModel.h"
#import "UIImageView+AFNetworking.h"
#import "UserInfo.h"
#import "ThemeApplyViewController.h"

#import "HouseLookingViewController.h"

#import "personalTwoViewController.h"

@interface ActivityViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (retain,nonatomic) UITableView *tableView;
@property (retain,nonatomic) NSMutableArray *dataArray;
@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    

    
    [self createNvn];
    [self requestData];
    
    
}



-(void)requestData{
    
    [self showLoading:2];
    _dataArray = [NSMutableArray array];
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/forums/list.do" params:@{} success:^(id JSON) {

        _dataArray = [JSON objectForKey:@"data"];
        NSLog(@"活动页面解析数据  **********%@",_dataArray);

        [self createView];
        [_tableView reloadData];
        [self hideLoading];
    } failure:^(NSError *error) {
        [self hideLoading];
    }];
}

#pragma mark -- 创建tableViev
-(void)createView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, viewWidth-20, viewHeight-70) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tag = 999;
    [self.view addSubview:_tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0.1;
    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
//    ActivityModel * model = _dataArray[indexPath.section];
//    
    if ([[NSString stringWithFormat:@"%@",[_dataArray[indexPath.section] objectForKey:@"inviteGuests"]] integerValue]!= 1) {
    
        NSString *comment = [NSString stringWithFormat:@"邀请嘉宾：%@",[_dataArray[indexPath.section] objectForKey:@"inviteGuests"]];
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:12]};
        CGSize size = [comment boundingRectWithSize:CGSizeMake(320, 3000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        
        NSString *comment1 = [NSString stringWithFormat:@"主讲嘉宾：%@",[_dataArray[indexPath.section] objectForKey:@"mainGuests"]];
        NSDictionary *attribute1 = @{NSFontAttributeName: [UIFont systemFontOfSize:12]};
        CGSize size1 = [comment1 boundingRectWithSize:CGSizeMake(320, 2000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute1 context:nil].size;
//    

            return size1.height+size.height+280;

    }else {
       NSString *comment1 = [NSString stringWithFormat:@"主讲嘉宾：%@",[_dataArray[indexPath.section] objectForKey:@"mainGuests"]];
       NSDictionary *attribute1 = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
       CGSize size1 = [comment1 boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute1 context:nil].size;
       return size1.height+280;
    }
//    return 280;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ActivityCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[ActivityCell alloc] init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    ActivityModel * model = _dataArray[indexPath.section];
    
    if (![[_dataArray[indexPath.section] objectForKey:@"icon"] isEqual:[NSNull null]]) {
        
        [cell.headImage setImageWithURL:[NSURL URLWithString:[_dataArray[indexPath.section] objectForKey:@"icon"]]
                       placeholderImage:[UIImage imageNamed:@"loading_m"]];
    }
    
    
    NSMutableAttributedString *strTime;
    if (![[_dataArray[indexPath.section] objectForKey:@"activityTime"] isEqual:[NSNull null]]) {
        
        strTime= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"活动时间：%@",[Tools_F timeTransform:[[_dataArray[indexPath.section] objectForKey:@"activityTime"] intValue] time:minutes]]];
        [strTime addAttribute:NSForegroundColorAttributeName value:deepBLack range:NSMakeRange(0,5)];
        [strTime addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(5,17)];
    }
    
    if (![[_dataArray[indexPath.section] objectForKey:@"title"] isEqual:[NSNull null]]) {
        
        cell.titleLable.text = [_dataArray[indexPath.section] objectForKey:@"title"];
    }
    
    if (![[_dataArray[indexPath.section] objectForKey:@"activityAddress"] isEqual:[NSNull null]]) {
        
        cell.addssssLable.text = [_dataArray[indexPath.section] objectForKey:@"activityAddress"];
    }
    
    cell.timeLable.attributedText = strTime;
    
    NSMutableAttributedString *peStr;
    if (![[_dataArray[indexPath.section] objectForKey:@"peopleQty"] isEqual:[NSNull null]]) {
        
        peStr= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"参会人数：%@",[_dataArray[indexPath.section] objectForKey:@"peopleQty"]]];
        [peStr addAttribute:NSForegroundColorAttributeName value:deepBLack range:NSMakeRange(0,5)];
    }
    
    cell.peopleLabel.attributedText = peStr;
    
    NSMutableAttributedString *acStr;
    if (![[_dataArray[indexPath.section] objectForKey:@"mainGuests"] isEqual:[NSNull null]]) {
        
        acStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"主讲嘉宾：%@",[_dataArray[indexPath.section] objectForKey:@"mainGuests"]]];
        [acStr addAttribute:NSForegroundColorAttributeName value:deepBLack range:NSMakeRange(0,5)];
    }
    
    cell.activityLable.attributedText = acStr;
//    cell.activityLable.numberOfLines = 4;
    
//    if ([[NSString stringWithFormat:@"%@",model.type] integerValue]!= 1) {
    NSMutableAttributedString *inStr;
    if (![[_dataArray[indexPath.section] objectForKey:@"inviteGuests"] isEqual:[NSNull null]]) {
        
        inStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"邀请嘉宾：%@",[_dataArray[indexPath.section] objectForKey:@"inviteGuests"]]];
        [inStr addAttribute:NSForegroundColorAttributeName value:deepBLack range:NSMakeRange(0,5)];
    }
    
    cell.invitationLable.attributedText = inStr;
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    ActivityModel * model = _dataArray[indexPath.section];
    
//    ActivityModel * model = _dataArray[0];
//    if ([[NSString stringWithFormat:@"%@",model.type] integerValue]== 1) {
//        
//        HouseLookingViewController *hlVC = [[HouseLookingViewController alloc] init];
//        hlVC.hkTitle = model.title;
//        hlVC.houseShowingsId = [NSString stringWithFormat:@"%@",model.id];
//        hlVC.isApply = NO;
//        [self.navigationController pushViewController:hlVC animated:YES];
//    }
//    else if ([[NSString stringWithFormat:@"%@",model.type] integerValue]== 2) {
    
        ProjectActivitiesViewController * PjAtiVc = [[ProjectActivitiesViewController alloc] init];
    
        PjAtiVc.dataDic = _dataArray[indexPath.section];
        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;
        [self.navigationController pushViewController:PjAtiVc animated:YES];
//    }
//    else if ([[NSString stringWithFormat:@"%@",model.type] integerValue]== 3) {
//        
//        ThemeViewController * themVc = [[ThemeViewController alloc] init];
//        
//        themVc.model = model;
//        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;
//        [self.navigationController pushViewController:themVc animated:YES];
//    }
}

#pragma mark -- 报名活动
- (void)ConBrandClick:(UIButton *)btn{
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        
        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else {
        
        ActivityCell *cell = (ActivityCell *)btn.superview;
        NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
        
        ActivityModel * model = _dataArray[indexPath.section];
        
        if ([[NSString stringWithFormat:@"%@",model.type] integerValue]== 1) {
            
            HouseLookingViewController *hlVC = [[HouseLookingViewController alloc] init];
            hlVC.hkTitle = model.title;
            hlVC.houseShowingsId = [NSString stringWithFormat:@"%@",model.id];
            hlVC.isApply = NO;
            [self.navigationController pushViewController:hlVC animated:YES];
        }

        else if ([[NSString stringWithFormat:@"%@",model.type] integerValue]== 2) {
            NSString * str3 =[NSString stringWithFormat:@"%@",model.time];
            
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            
            [formatter setDateFormat:@"yyyy-MM-dd HH:MM"];
            
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[NSString stringWithFormat:@"%@",str3] intValue]];
            
            NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
            
            ThemeApplyViewController * thVc = [[ThemeApplyViewController alloc] init];
          
            thVc.confromTimespStr = confromTimespStr;
            thVc.str2 = model.address;
            thVc.str1 = model.title;

            [self.navigationController pushViewController:thVc animated:YES];
        }
        else if([[NSString stringWithFormat:@"%@",model.type] integerValue]== 3)
        {

            NSString * str3 =[NSString stringWithFormat:@"%@",model.time];
            
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            
            [formatter setDateFormat:@"yyyy-MM-dd HH:MM"];
            
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[NSString stringWithFormat:@"%@",str3] intValue]];
            
            NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
            
            ThemeApplyViewController * thVc = [[ThemeApplyViewController alloc] init];
            
            thVc.confromTimespStr = confromTimespStr;
            thVc.str2 = model.address;
            thVc.str1 = model.title;
            [self.navigationController pushViewController:thVc animated:YES];
        }
    }
}
    
-(void)createNvn{
    
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"活动";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
}

- (void)leftButtonClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 必选的没选提示按钮
- (void)showAlert:(NSString *) _message{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}

- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert = NULL;
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
