//
//  ReservationIndexViewController.m
//  SDD
//
//  Created by hua on 15/8/20.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ReservationIndexViewController.h"
#import "TagsAndTables.h"
#import "MyReservationListModel.h"
#import "ReservationTableViewCell.h"
#import "DateSelectView.h"

#import "GroupRentViewController.h"
//#import "JoinInViewController.h"
#import "JoinInBeforeViewController.h"
#import "ReservationTableViewController.h"

#import "NewReservationViewController.h"

@interface ReservationIndexViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    /*- ui -*/
    
    UITableView *reservationTable;
    UITableView *brandTable;
    
    UIView *shadowView;
    
    UIView *shadowView2;
    DateSelectView *dateSelectView;             // 日期选择
    
    NoDataTips *noBrand;
    NoDataTips *noProject;
    
    /*- data -*/
    
    NSArray *reservations;
    NSArray *brand_reservations;
    NSInteger todayD;
    
    NSDate *dateSelected;
    NSInteger currentVisitId;
}

@end

@implementation ReservationIndexViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.viewForBaselineLayout.hidden = NO;      //  显示tabar
    // 未登录
    if (![GlobalController isLogin]) {
        
        [self showNoDataTipsWithText:@"预约需登录才能使用"
                         buttonTitle:@"登录"
                           buttonTag:100
                              target:self
                              action:@selector(login:)];
    }
    else {
        [self hideNoDataTips];
        
        // 获取数据
        [self requestData];
    }
}

#pragma mark - 获取预约
- (void)requestData{
    
    NSDictionary *param = @{@"params":@{@"type":[NSNumber numberWithInteger:0]}};
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/houseAppointmentVisit/myAppointmentVisit.do" params:param success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSArray *arr = JSON[@"data"];
        if (![arr isEqual:[NSNull null]]) {
            
            if ([arr count]<1) {
                
                noProject.hidden = NO;
            }
            else {
                
                noProject.hidden = YES;
                reservations = [MyReservationListModel objectArrayWithKeyValuesArray:arr];
            }
        }
        else {
            
            noProject.hidden = NO;
        }
        [reservationTable reloadData];
    } failure:^(NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSDate *datenow = [NSDate date];  // 获取现在时间
    todayD = (NSInteger)[datenow timeIntervalSince1970];
    
    // 导航条
    [self setupNav];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置导航条
- (void)setupNav{
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"预约";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    UIButton *moreReservation = [UIButton buttonWithType:UIButtonTypeCustom];
    moreReservation.frame = CGRectMake(0, 0, 20, 20);
    [moreReservation setBackgroundImage:[UIImage imageNamed:@"resevertion_icon_alert"] forState:UIControlStateNormal];
    [moreReservation addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:moreReservation];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    reservationTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    reservationTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    reservationTable.backgroundColor = bgColor;
    reservationTable.delegate = self;
    reservationTable.dataSource = self;
    
    [self.view addSubview:reservationTable];                            // add
    [reservationTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    noProject = [[NoDataTips alloc] init];
    [noProject setText:@"您还没预约项目,赶快去预约项目吧~"
           buttonTitle:@"马上预约"
             buttonTag:100
                target:self
                action:@selector(jumpToReservation:)];
    
    [reservationTable addSubview:noProject];
    
    if (iOS_version < 7.5) {
        noProject.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    }
    else {
        [noProject mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(reservationTable);
            make.edges.equalTo(reservationTable);
        }];
    };
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 160;
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView == reservationTable) {
        return [reservations count];
    }
    return 0;
}

#pragma mark - 设置section 头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}

#pragma mark - 设置section 脚高
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

#pragma mark - 设置cell (tableView)
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //重用标识符
    static NSString *identifier = @"CELLMARK";
    //重用机制
    ReservationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
    
    if(cell == nil){
        //当不存在的时候用重用标识符生成
        cell = [[ReservationTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
    }
    
    if (tableView == reservationTable) {
        
        MyReservationListModel *model = reservations[indexPath.section];
        
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
    }
    else {
        
//        cell.reservationTime.text = @"预约时间：  2015年08月20日（周五）";
//        cell.houseName.text = @"中润欧洲城（一层/A区/100m²）";
//        cell.appointmentNum.text = @"预约号： 114-16165465465";
//        cell.discountContent.text = @"独享优惠： 认租即免租金3个月";
    }
    
    return cell;
}

#pragma mark - 点击cell进入详细页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == reservationTable) {
        
        MyReservationListModel *model = reservations[indexPath.section];
        
//        if (todayD-model.appointmentVisitTime>0) {
        NewReservationViewController *rtVC = [[NewReservationViewController alloc] init];
        //ReservationTableViewController *rtVC = [[ReservationTableViewController alloc] init];
        //rtVC.theStep = lastStep;
        rtVC.houseAppointmentVisitId = model.houseAppointmentVisitId;
        rtVC.isFromPersonal = YES;
            
        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
        [self.navigationController pushViewController:rtVC animated:YES];
//        }
    }
}

#pragma mark - 重新预约
- (void)reschedule:(UIButton *)btn{
    
    NSInteger index = (NSInteger)btn.tag-100;
    MyReservationListModel *model = reservations[index];
    currentVisitId = model.houseAppointmentVisitId;
    
    shadowView2 = [[UIView alloc] init];
    shadowView2.backgroundColor = setColor(0, 0, 0, 0.7);
    shadowView2.alpha = 0;
    
    UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(closeWindow)];
    [shadowView2 addGestureRecognizer:bgTap];
    
    [self.view.window addSubview:shadowView2];
    
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
    
    [shadowView2 addSubview:dateSelectView];
    [dateSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeZero);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        shadowView2.alpha = 1;
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

#pragma mark - 登录
- (void)login:(UIButton *)btn{
    
    LoginController *loginVC = [[LoginController alloc] init];
    
    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
    [self.navigationController pushViewController:loginVC animated:YES];
}

#pragma mark - more
- (void)more:(UIButton *)btn{
    
    if (shadowView) {
        [shadowView removeFromSuperview];
    }
    
    shadowView = [[UIView alloc] init];
    shadowView.backgroundColor = setColor(0, 0, 0, 0.7);
//    shadowView.userInteractionEnabled = YES;
    shadowView.alpha = 0;
    
    UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(closeWindow)];
    [shadowView addGestureRecognizer:bgTap];
    
    [self.view.window addSubview:shadowView];
    
    [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view.window);
        make.edges.equalTo(self.view.window);
    }];
    
    // 背景图片
    UIImageView *popWindow_Bg = [[UIImageView alloc] init];
    popWindow_Bg.userInteractionEnabled = YES;
    popWindow_Bg.image = [UIImage imageNamed:@"reservation_recomandToReservation"];
    [shadowView addSubview:popWindow_Bg];
    
    [popWindow_Bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view.window);
        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 4*(viewWidth-20)/3));
    }];
    
    // 去约
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 100;
    button.titleLabel.font = biggestFont;
    [button setTitle:@"我要约，马上约！" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [Tools_F setViewlayer:button cornerRadius:5 borderWidth:1 borderColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(jumpToReservation:) forControlEvents:UIControlEventTouchUpInside];
    
    [popWindow_Bg addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(popWindow_Bg.mas_bottom).offset(-45);
        make.centerX.equalTo(self.view.window);
        make.size.mas_equalTo(CGSizeMake(viewWidth*2/3, 45));
    }];
    
    // 叉叉
//    UIButton *closePop = [UIButton buttonWithType:UIButtonTypeCustom];
//    closePop.frame = CGRectMake(0, 0, 20, 20);
//    [closePop setBackgroundImage:[UIImage imageNamed:@"resevertion_icon_close"] forState:UIControlStateNormal];
//    [closePop addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [shadowView addSubview:closePop];
//    [closePop mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(popWindow_Bg.mas_top).offset(-20);
//        make.right.equalTo(popWindow_Bg.mas_right).offset(-10);
//        make.size.mas_equalTo(CGSizeMake(20, 20));
//    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        shadowView.alpha = 1;
    }];
}

#pragma mark - 去预约
- (void)jumpToReservation:(UIButton *)btn{

    switch (btn.tag) {
        case 100:
        {
            GroupRentViewController *groupRentVC = [[GroupRentViewController alloc] init];
            groupRentVC.activityCategoryId = 2;
            self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
            [self.navigationController pushViewController:groupRentVC animated:YES];
        }
            break;
        case 101:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没了没了" delegate:self cancelButtonTitle:@"好吧" otherButtonTitles:nil, nil];
            [alert show];
//            JoinInViewController *joinVC = [[JoinInViewController alloc] init];
//            
//            self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
//            [self.navigationController pushViewController:joinVC animated:YES];
        }
            break;
    }
    
    [self closeWindow];
}

- (void)closeWindow{
    
    [UIView animateWithDuration:0.3 animations:^{
        shadowView.alpha = 0;
        [shadowView removeFromSuperview];
        shadowView2.alpha = 0;
        [shadowView2 removeFromSuperview];
        [dateSelectView removeFromSuperview];
    }];
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
