//
//  ProjectRentViewController.m
//  SDD
//
//  Created by hua on 15/8/13.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ProjectRentViewController.h"
#import "ProjectRentDeiltSlideView.h"
#import "MyAppointmentCell.h"
#import "MyReservationListModel.h"
#import "MyActivitiesModel.h"
#import "ReservationTableViewCell.h"
#import "LPYModelTool.h"
#import "DateSelectView.h"
#import "GroupPurchaseTableViewCell.h"
#import "NSString+SDD.h"

#import "ReservationTableViewController.h"
#import "HouseLookingViewController.h"
#import "ProjectActivitiesViewController.h"
#import "ThemeViewController.h"

#import "UIImageView+WebCache.h"

@interface ProjectRentViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    /*- ui -*/
    
    
    /*- data -*/
    
    NSArray *reservations;
    NSArray *allActivity;
    NSInteger todayD;
    
    NSInteger currentVisitId;
    DateSelectView *dateSelectView;             // 日期选择
    UIView *shadowView2;
    NSDate *dateSelected;
}

@property (strong, nonatomic) ProjectRentDeiltSlideView *ProRentSlideView;
@property (assign) NSInteger tabCount;

@end

@implementation ProjectRentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDate *datenow = [NSDate date];  // 获取现在时间
    todayD = (NSInteger)[datenow timeIntervalSince1970];
    
    [self createNvn];
    [self requestData];
    _tabCount = 2;
    [self initSlideWithCount:_tabCount];
}

-(void) initSlideWithCount: (NSInteger) count{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    screenBound.origin.y = 0;
    
    _ProRentSlideView = [[ProjectRentDeiltSlideView alloc] initWithFrame:screenBound WithCount:count];
    
    _ProRentSlideView.AppointmentTableView.delegate = self;
    _ProRentSlideView.AppointmentTableView.dataSource = self;
    _ProRentSlideView.AppointmentTableView.backgroundColor = bgColor;
    
    _ProRentSlideView.ActivityTableView.delegate = self;
    _ProRentSlideView.ActivityTableView.dataSource = self;
    _ProRentSlideView.ActivityTableView.backgroundColor = bgColor;
    
    [self.view addSubview:_ProRentSlideView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _ProRentSlideView.AppointmentTableView) {
        
        return 160;
    }
    else {
        
        return 100;
    }
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView == _ProRentSlideView.AppointmentTableView) {
        
        return [reservations count];
    }
    else {
        
        return [allActivity count];
    }
}

#pragma mark - 设置section 头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}

#pragma mark - 设置section 脚高
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _ProRentSlideView.AppointmentTableView) {
        
        MyReservationListModel *model = reservations[indexPath.section];
        ReservationTableViewController *rtVC = [[ReservationTableViewController alloc] init];
        
        rtVC.theStep = lastStep;
        rtVC.houseAppointmentVisitId = model.houseAppointmentVisitId;
        rtVC.isFromPersonal = YES;
        [self.navigationController pushViewController:rtVC animated:YES];
    }
    else {
        
        MyActivitiesModel *model = allActivity[indexPath.section];
        
        if (model.type == 1) {
            
            HouseLookingViewController *hlVC = [[HouseLookingViewController alloc] init];
            hlVC.hkTitle = model.title;
            hlVC.houseShowingsId = [NSString stringWithFormat:@"%d",model.houseShowingsId];
            hlVC.isApply = NO;
            [self.navigationController pushViewController:hlVC animated:YES];
        }
//        else if (model.type == 2) {
//            
//            ProjectActivitiesViewController * PjAtiVc = [[ProjectActivitiesViewController alloc] init];
//            
//            PjAtiVc.model = model;
//            self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;
//            [self.navigationController pushViewController:PjAtiVc animated:YES];
//        }
//        else if (model.type == 3) {
//            
//            ThemeViewController * themVc = [[ThemeViewController alloc] init];
//            
//            themVc.model = model;
//            self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;
//            [self.navigationController pushViewController:themVc animated:YES];
//        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _ProRentSlideView.AppointmentTableView) {
        //重用标识符
        static NSString *identifier = @"CELLMARK";
        //重用机制
        ReservationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
        
        if(cell == nil){
            //当不存在的时候用重用标识符生成
            cell = [[ReservationTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
        }
        MyReservationListModel *model = reservations[indexPath.section];

        for (int i = 0; i < 4; i ++) {
            
            UILabel * label = (UILabel *)[cell viewWithTag:100+i];
            label.hidden = YES;
        }
        
        cell.reservationTime.text = [NSString stringWithFormat:@"预约时间: %@",[Tools_F timeTransform:(int)model.appointmentVisitTime time:days]];
        cell.houseName.text = [NSString stringWithFormat:@"%@(%@/%@/%dm²)",
                               model.houseName,
                               model.floorName,
                               model.appointmentAreaName,
                               model.area];
        cell.appointmentNum.text = [NSString stringWithFormat:@"预约号: %@",model.appointmentNumber];
        cell.discountContent.text = [NSString stringWithFormat:@"独享优惠: %@",model.rentPreferentialContent];
        
        cell.isOutdated = todayD-model.appointmentVisitTime>0?NO:YES;
        cell.rescheduleButton.tag = 100+indexPath.section;
        [cell.rescheduleButton addTarget:self action:@selector(reschedule:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    else {
        //重用标识符
        static NSString *identifier = @"HOUSELOOKINGMARK";
        //重用机制
        GroupPurchaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
        
        if(cell == nil){
            // 当不存在的时候用重用标识符生成
            cell = [[GroupPurchaseTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            cell.cellType = personal_activities;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
        }
        
        MyActivitiesModel *model = allActivity[indexPath.section];
        
        // 图片
        [cell.placeImage sd_setImageWithURL:model.defaultImage placeholderImage:[UIImage imageNamed:@"cell_loading"]];
        // 标题
        cell.placeTitle.text = [NSString stringWithFormat:@"%@",model.title];
        // 活动时间
        cell.placeAdd.text = [NSString stringWithFormat:@"活动时间:%@",[Tools_F timeTransform:(int)model.time time:days]];
        // 活动地点
        cell.placeDiscount.text = [NSString stringWithFormat:@"活动地点%@",model.address];
        
        if (model.addTime > model.showingsEndtime) {
            cell.statusLabel.enabled = NO;
        }
        else {
            cell.statusLabel.enabled = YES;
        }
        
        return cell;
    }
}

#pragma mark - 重新预约
- (void)reschedule:(UIButton *)btn{
    
    NSInteger index = (NSInteger)btn.tag-100;
    MyReservationListModel *model = reservations[index];
    currentVisitId = model.houseAppointmentVisitId;
    
    shadowView2 = [[UIView alloc] init];
    shadowView2.backgroundColor = [UIColor blackColor];
    shadowView2.alpha = 0;
    [self.view addSubview:shadowView2];
    
    [shadowView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.edges.equalTo(self.view);
    }];
    
    dateSelectView = [[DateSelectView alloc] init];
    dateSelectView.theTitle.text = @"预约时间";
    
    NSTimeInterval a_day = 24*60*60;
    NSTimeInterval a_month = 24*60*60*60;
    NSDate *date = [NSDate date];
    NSDate *tomorrow = [date dateByAddingTimeInterval:a_day];          // 设置明天
    NSDate *monthsAgo = [date dateByAddingTimeInterval:a_month];          // 设置明天
    
    dateSelectView.theDatePicker.minimumDate = tomorrow;
    dateSelectView.theDatePicker.maximumDate = monthsAgo;       // 设置上下限日期
    
    dateSelected = tomorrow;           // 默认选明天
    [dateSelectView.theDatePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    [dateSelectView.confirmButton addTarget:self action:@selector(selectedDate:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:dateSelectView];
    [dateSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeZero);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        shadowView2.alpha = 0.5;
        [dateSelectView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(viewWidth-40, 235));
        }];
    }];
}

#pragma mark - 日期变动
- (void)dateChange:(UIDatePicker *)sender{
    
    dateSelected = sender.date;
    NSLog(@"时间——%@",dateSelected);
}

#pragma mark - 确认日期
- (void)selectedDate:(UIButton *)btn{
    
    [UIView animateWithDuration:0.3 animations:^{
        shadowView2.alpha = 0;
        [shadowView2 removeFromSuperview];
        [dateSelectView removeFromSuperview];
    }];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSDictionary *param = @{@"houseAppointmentVisitId":[NSNumber numberWithInteger:currentVisitId],
                            @"appointmentVisitTime":[NSNumber numberWithInteger:(NSInteger)[dateSelected timeIntervalSince1970]]
                            };
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/houseAppointmentVisit/changeAppointmentVisitTime.do" params:param success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSInteger theStatus = [JSON[@"status"] integerValue];
        
        if (theStatus == 1) {
            
            [self requestData];
        }
    } failure:^(NSError *error) {
        //
        NSLog(@"错误 -- %@", error);
    }];
}

-(void)requestData{
    
    NSDictionary *param = @{@"params":@{@"type":[NSNumber numberWithInteger:0]}};
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/houseAppointmentVisit/myAppointmentVisit.do" params:param success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSArray *arr = JSON[@"data"];
        if (![arr isEqual:[NSNull null]]) {
            
            reservations = [MyReservationListModel objectArrayWithKeyValuesArray:arr];
        }
        [_ProRentSlideView.AppointmentTableView reloadData];
    } failure:^(NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/userReserve/bigList.do" params:@{} success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSArray *arr = JSON[@"data"];
        if (![arr isEqual:[NSNull null]]) {
            
            allActivity = [MyActivitiesModel objectArrayWithKeyValuesArray:arr];
        }
        [_ProRentSlideView.ActivityTableView reloadData];
    } failure:^(NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
    
}

-(void)createNvn{
    
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"项目团租";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
}

- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
