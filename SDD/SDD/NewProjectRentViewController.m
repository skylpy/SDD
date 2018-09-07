//
//  NewProjectRentViewController.m
//  SDD
//
//  Created by mac on 15/12/22.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "NewProjectRentViewController.h"
#import "ProjectRentView.h"
#import "GroupRentViewController.h"
#import "MyReservationListModel.h"
#import "ReservationTableViewCell.h"
#import "DateSelectView.h"
#import "NewReservationViewController.h"

@interface NewProjectRentViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIView *shadowView;
    UIView *shadowView2;
    
    NoDataTips * noProject1;
    NoDataTips * noProject2;
    NoDataTips * noProject3;
    NSInteger todayD;
    
    NSInteger currentVisitId;
    DateSelectView *dateSelectView;             // 日期选择
    
    NSDate *dateSelected;
    
    NSArray *arrCom;
    NSArray *arrFail;
    NSArray *arrPro;
    
    UIButton *moreReservation;
}

@property (strong, nonatomic) ProjectRentView * reserSlideView;
@property (assign) NSInteger tabCount;

@property (retain,nonatomic)NSArray * ProceedArray;
@property (retain,nonatomic)NSArray * CompleteArray;
@property (retain,nonatomic)NSArray * FailureArray;

@end

@implementation NewProjectRentViewController

-(void)viewWillAppear:(BOOL)animated{

    [self requestData];
}

#pragma mark - 获取预约
- (void)requestData{
    
    NSDictionary *param = @{@"params":@{@"type":[NSNumber numberWithInteger:1]}};
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/houseAppointmentVisit/myAppointmentVisit.do" params:param success:^(id JSON) {
        
        [noProject1 removeFromSuperview];
        NSLog(@"%@>>>进行中>>>>%@",JSON[@"message"],JSON);
        arrPro = JSON[@"data"];
        if (![arrPro isEqual:[NSNull null]]) {
            
            _ProceedArray = [MyReservationListModel objectArrayWithKeyValuesArray:arrPro];
        }
        if(arrPro.count == 0)
        {
            noProject1 = [[NoDataTips alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-64)];
            [noProject1 setText:@"“暂无进行中的预约，赶快去预约心仪的项目吧~”"//@"您还没预约项目,赶快去预约项目吧~"
                    buttonTitle:@"马上预约"
                      buttonTag:100
                         target:self
                         action:@selector(jumpToReservation:)];
            
            [_reserSlideView.ProceedTableView addSubview:noProject1];
        }
        [_reserSlideView.ProceedTableView reloadData];
        
    } failure:^(NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
    
    
    NSDictionary *param1 = @{@"params":@{@"type":[NSNumber numberWithInteger:2]}};
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/houseAppointmentVisit/myAppointmentVisit.do" params:param1 success:^(id JSON) {
        
        [noProject2 removeFromSuperview];
        NSLog(@"%@>>>已完成>>>>%@",JSON[@"message"],JSON);
        arrCom = JSON[@"data"];
        if (![arrCom isEqual:[NSNull null]]) {
            
            _CompleteArray = [MyReservationListModel objectArrayWithKeyValuesArray:arrCom];
        }
        if(arrCom.count == 0)
        {
            noProject2 = [[NoDataTips alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-64)];
            [noProject2 setText:@"您还没预约项目,赶快去预约项目吧~"
                    buttonTitle:@"马上预约"
                      buttonTag:101
                         target:self
                         action:@selector(jumpToReservation:)];
            
            [_reserSlideView.CompleteTableView addSubview:noProject2];
        }
        if ((arrFail.count!= 0||arrPro.count!= 0 )&& arrCom.count == 0) {
            
            [noProject2 removeFromSuperview];
            
            
            noProject2  = [[NoDataTips alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-64)];
            [noProject2 setText:@"暂无已完成的预约，赶快去完成吧~"];//@"您当前还没有已完成的项目，赶快去完成吧~"];
            [_reserSlideView.CompleteTableView addSubview:noProject2];
            
        }
        [_reserSlideView.CompleteTableView reloadData];
        
    } failure:^(NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
    
    
    NSDictionary *param2 = @{@"params":@{@"type":[NSNumber numberWithInteger:3]}};
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/houseAppointmentVisit/myAppointmentVisit.do" params:param2 success:^(id JSON) {
        
        [noProject3 removeFromSuperview];
        NSLog(@"%@>>>已失效>>>>%@",JSON[@"message"],JSON);
        arrFail = JSON[@"data"];
        if (![arrFail isEqual:[NSNull null]]) {
            
            _FailureArray = [MyReservationListModel objectArrayWithKeyValuesArray:arrFail];
        }
        if(arrFail.count == 0)
        {
            noProject3 = [[NoDataTips alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-64)];
            [noProject3 setText:@"您还没预约项目,赶快去预约项目吧~"
                    buttonTitle:@"马上预约"
                      buttonTag:102
                         target:self
                         action:@selector(jumpToReservation:)];
            
            [_reserSlideView.FailureTableView addSubview:noProject3];
        }
        if ((arrCom.count != 0||arrPro.count != 0)&&arrFail.count == 0) {
            
            [noProject3 removeFromSuperview];
            
            noProject3  = [[NoDataTips alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-64)];
            [noProject3 setText:@"暂无已失效的预约"];//@"您当前还没有已失效的项目，赶快去完成吧~"];
            [_reserSlideView.FailureTableView addSubview:noProject3];
            
        }
        
        [_reserSlideView.FailureTableView reloadData];
        
    } failure:^(NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
}
#pragma mark - 去预约
- (void)jumpToReservation:(UIButton *)btn{
    
    GroupRentViewController *groupRentVC = [[GroupRentViewController alloc] init];
    groupRentVC.activityCategoryId = 2;
    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
    [self.navigationController pushViewController:groupRentVC animated:YES];
    
    [self closeWindow];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    
    
    
    [self setupNav];
    //[self requestData];
    NSDate *datenow = [NSDate date];  // 获取现在时间
    todayD = (NSInteger)[datenow timeIntervalSince1970];
    _tabCount = 3;
    [self initSlideWithCount:_tabCount];
}
-(void) initSlideWithCount: (NSInteger) count{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    screenBound.origin.y = 0;
    
    _reserSlideView = [[ProjectRentView alloc] initWithFrame:screenBound WithCount:count];
    
    _reserSlideView.ProceedTableView.delegate = self;
    _reserSlideView.ProceedTableView.dataSource = self;
    _reserSlideView.ProceedTableView.backgroundColor = bgColor;
    
    _reserSlideView.CompleteTableView.delegate = self;
    _reserSlideView.CompleteTableView.dataSource = self;
    _reserSlideView.CompleteTableView.backgroundColor = bgColor;
    
    _reserSlideView.FailureTableView.delegate = self;
    _reserSlideView.FailureTableView.dataSource = self;
    _reserSlideView.FailureTableView.backgroundColor = bgColor;
    
    [self.view addSubview:_reserSlideView];
    
    
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
    else
    {
        return 10;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 230;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_reserSlideView.ProceedTableView == tableView) {
        
        return _ProceedArray.count;
    }
    else if (_reserSlideView.CompleteTableView == tableView) {
        
        return _CompleteArray.count;
    }
    else {
        
        return _FailureArray.count;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //重用标识符
    static NSString *identifier = @"CELLMARK";
    //重用机制
    ReservationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
    
    if(cell == nil){
        //当不存在的时候用重用标识符生成
        cell = [[ReservationTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
    }
    if (tableView == _reserSlideView.ProceedTableView) {
        
        MyReservationListModel *model = _ProceedArray[indexPath.section];
        
        //        NSString *aString = [Tools_F timeTransform:(int)model.appointmentVisitTime time:days];
        //        NSData * aData = [aString dataUsingEncoding: NSUTF8StringEncoding];
        
        //Tools_F * tool_f;
        cell.reservationTime.text = [NSString stringWithFormat:@"预约时间: %@ %@",[Tools_F timeTransform:(int)model.appointmentVisitTime time:dayszw],[self featureWeekdayWithDate:[Tools_F timeTransform:(int)model.appointmentVisitTime time:dayszw]]];
        cell.houseName.text = [NSString stringWithFormat:@"%@",
                               model.houseName];
        cell.appointmentNum.text = [NSString stringWithFormat:@"团租优惠劵编码: %@",model.appointmentNumber];
        cell.discountContent.text = [NSString stringWithFormat:@"独享优惠: %@",model.rentPreferentialContent];
        
        cell.isOutdated = todayD-model.appointmentVisitTime>0?NO:YES;
        cell.rescheduleButton.tag = 100+indexPath.section;
        [cell.rescheduleButton addTarget:self action:@selector(reschedule:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        if (model.status == 0) {
            
            cell.progressImage.image = [UIImage imageNamed:@"tip-book-on1"];
        }
        else if (model.status == 1){
            
            cell.progressImage.image = [UIImage imageNamed:@"tip-book-on2"];
        }
        else if (model.status == 2){
            
            cell.progressImage.image = [UIImage imageNamed:@"tip-book-on3"];
        }
        
    }
    
    else if (tableView == _reserSlideView.FailureTableView) {
        
        MyReservationListModel *model = _FailureArray[indexPath.section];
        
        cell.reservationTime.text = [NSString stringWithFormat:@"预约时间: %@ %@",[Tools_F timeTransform:(int)model.appointmentVisitTime time:dayszw],[self featureWeekdayWithDate:[Tools_F timeTransform:(int)model.appointmentVisitTime time:dayszw]]];
        cell.houseName.text = [NSString stringWithFormat:@"%@",
                               model.houseName];
        cell.appointmentNum.text = [NSString stringWithFormat:@"团租优惠劵编码: %@",model.appointmentNumber];
        cell.discountContent.text = [NSString stringWithFormat:@"独享优惠: %@",model.rentPreferentialContent];
        
        cell.progressImage.image = [UIImage imageNamed:@"tip-book-on4"];
        
        cell.isOutdated = todayD-model.appointmentVisitTime>0?NO:YES;
        cell.rescheduleButton.tag = 100+indexPath.section;
        [cell.rescheduleButton addTarget:self action:@selector(reschedule:) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        
        MyReservationListModel *model = _CompleteArray[indexPath.section];
        
        cell.reservationTime.text = [NSString stringWithFormat:@"预约时间: %@ %@",[Tools_F timeTransform:(int)model.appointmentVisitTime time:dayszw],[self featureWeekdayWithDate:[Tools_F timeTransform:(int)model.appointmentVisitTime time:dayszw]]];
        cell.houseName.text = [NSString stringWithFormat:@"%@",
                               model.houseName];
        //        ,
        //        model.floorName,
        //        model.appointmentAreaName,
        //        model.area
        cell.appointmentNum.text = [NSString stringWithFormat:@"团租优惠劵编码: %@",model.appointmentNumber];
        cell.discountContent.text = [NSString stringWithFormat:@"独享优惠: %@",model.rentPreferentialContent];
        
        cell.progressImage.image = [UIImage imageNamed:@"tip-book-on4"];
        
        cell.isOutdated = YES;
        
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _reserSlideView.ProceedTableView) {
        
        MyReservationListModel *model = _ProceedArray[indexPath.section];
        
        NewReservationViewController *rtVC = [[NewReservationViewController alloc] init];
        rtVC.houseAppointmentVisitId = model.houseAppointmentVisitId;
        rtVC.isFromPersonal = YES;
        rtVC.isComin = 0;
        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
        [self.navigationController pushViewController:rtVC animated:YES];
        
    }
    else if (tableView == _reserSlideView.CompleteTableView) {
        
        MyReservationListModel *model = _CompleteArray[indexPath.section];
        NewReservationViewController *rtVC = [[NewReservationViewController alloc] init];
        rtVC.houseAppointmentVisitId = model.houseAppointmentVisitId;
        rtVC.isFromPersonal = YES;
        rtVC.isComin = 0;
        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
        [self.navigationController pushViewController:rtVC animated:YES];
    }
}

#pragma mark - 设置导航条
- (void)setupNav{
    
    [self setNav:@"项目团租"];
    
//    UILabel *titleLabel = [[UILabel alloc] init];
//    titleLabel.text = @"预约看铺";
//    titleLabel.textColor = [UIColor whiteColor];
//    titleLabel.font = biggestFont;
//    [titleLabel sizeToFit];
//    self.navigationItem.titleView = titleLabel;
    
    moreReservation = [UIButton buttonWithType:UIButtonTypeCustom];
    moreReservation.frame = CGRectMake(0, 0, 20, 20);
    [moreReservation setBackgroundImage:[UIImage imageNamed:@"icon-add"] forState:UIControlStateNormal];
    [moreReservation addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:moreReservation];
}

/**
 *  获取未来某个日期是星期几
 *  注意：featureDate 传递过来的格式 必须 和 formatter.dateFormat 一致，否则endDate可能为nil
 *
 */
- (NSString *)featureWeekdayWithDate:(NSString *)featureDate{
    // 创建 格式 对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置 日期 格式 可以根据自己的需求 随时调整， 否则计算的结果可能为 nil
    formatter.dateFormat = @"yyyy-MM-dd";
    // 将字符串日期 转换为 NSDate 类型
    NSDate *endDate = [formatter dateFromString:featureDate];
    // 判断当前日期 和 未来某个时刻日期 相差的天数
    long days = [self daysFromDate:[NSDate date] toDate:endDate];
    // 将总天数 换算为 以 周 计算（假如 相差10天，其实就是等于 相差 1周零3天，只需要取3天，更加方便计算）
    long day = days >= 7 ? days % 7 : days;
    long week = [self getNowWeekday] + day;
    switch (week) {
        case 1:
            return @"周日";
            break;
        case 2:
            return @"周一";
            break;
        case 3:
            return @"周二";
            break;
        case 4:
            return @"周三";
            break;
        case 5:
            return @"周四";
            break;
        case 6:
            return @"周五";
            break;
        case 7:
            return @"周六";
            break;
            
        default:
            break;
    }
    return nil;
}
/**
 *  计算2个日期相差天数
 *  startDate   起始日期
 *  endDate     截至日期
 */
-(NSInteger)daysFromDate:(NSDate *)startDate toDate:(NSDate *)endDate {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    // 话说在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //得到相差秒数
    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    int days = ((int)time)/(3600*24);
    int hours = ((int)time)%(3600*24)/3600;
    int minute = ((int)time)%(3600*24)/3600/60;
    if (days <= 0 && hours <= 0&&minute<= 0) {
        NSLog(@"0天0小时0分钟");
        return 0;
    }
    else {
        NSLog(@"%@",[[NSString alloc] initWithFormat:@"%i天%i小时%i分钟",days,hours,minute]);
        // 之所以要 + 1，是因为 此处的days 计算的结果 不包含当天 和 最后一天\
        （如星期一 和 星期四，计算机 算的结果就是2天（星期二和星期三），日常算，星期一——星期四相差3天，所以需要+1）\
        对于时分 没有进行计算 可以忽略不计
        return days + 1;
    }
}

// 获取当前是星期几
- (NSInteger)getNowWeekday {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDate *now = [NSDate date];
    // 话说在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    comps = [calendar components:unitFlags fromDate:now];
    return [comps weekday];
}

#pragma mark - more
- (void)more:(UIButton *)btn{
    
    [self windowMore];
}
-(void)windowMore{
    
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
    
    UIButton * closebtn = [[UIButton alloc] init];
    [closebtn setImage:[UIImage imageNamed:@"icon-close"] forState:UIControlStateNormal];//.image = [UIImage imageNamed:@"icon-close"];
    [closebtn addTarget:self action:@selector(closeWindow) forControlEvents:UIControlEventTouchUpInside];
    [shadowView addSubview:closebtn];
    [closebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.window.mas_right).with.offset(-16);
        make.top.equalTo(self.view.window.mas_top).with.offset(33);
        make.size.mas_equalTo(CGSizeMake(20, 20));
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
    
    //    // 去约
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
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        shadowView.alpha = 1;
    }];
}

-(void)firstWindow{
    
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
    
    [self.view addSubview:shadowView];
    
    [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.center.equalTo(self.view.window);
        //make.edges.equalTo(self.view.window);
        make.top.equalTo(self.view.window.mas_top);
        make.bottom.equalTo(self.view.window.mas_bottom);
        make.left.equalTo(self.view.window.mas_left);
        make.right.equalTo(self.view.window.mas_right);
    }];
    
    UIButton * closebtn = [[UIButton alloc] init];
    [closebtn setImage:[UIImage imageNamed:@"icon-close"] forState:UIControlStateNormal];//.image = [UIImage imageNamed:@"icon-close"];
    [closebtn addTarget:self action:@selector(closeWindow) forControlEvents:UIControlEventTouchUpInside];
    [shadowView addSubview:closebtn];
    [closebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.window.mas_right).with.offset(-16);
        make.top.equalTo(self.view.window.mas_top).with.offset(33);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    //
    //    // 背景图片
    UIImageView *popWindow_Bg = [[UIImageView alloc] init];
    popWindow_Bg.userInteractionEnabled = YES;
    popWindow_Bg.image = [UIImage imageNamed:@"reservation_recomandToReservation"];
    [shadowView addSubview:popWindow_Bg];
    
    [popWindow_Bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view.window);
        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 4*(viewWidth-20)/3));
    }];
    //
    //    //    // 去约
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
    //
    //
    //
    [UIView animateWithDuration:0.3 animations:^{
        shadowView.alpha = 1;
    }];
}

- (void)closeWindow{
    
    [UIView animateWithDuration:0.3 animations:^{
        shadowView.alpha = 0;
        [shadowView removeFromSuperview];
        shadowView2.alpha = 0;
        [shadowView2 removeFromSuperview];
        //[dateSelectView removeFromSuperview];
    }];
}


#pragma mark - 重新预约
- (void)reschedule:(UIButton *)btn{
    
    NSInteger index = (NSInteger)btn.tag-100;
    MyReservationListModel *model = _FailureArray[index];
    currentVisitId = model.houseAppointmentVisitId;
    
    shadowView2 = [[UIView alloc] init];
    shadowView2.backgroundColor = setColor(0, 0, 0, 0.7);
    shadowView2.alpha = 0;
    
    UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(closeWindow)];
    [shadowView2 addGestureRecognizer:bgTap];
    
    [self.view.window addSubview:shadowView2];
    
    [shadowView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.center.equalTo(self.view.window);
        //        make.edges.equalTo(self.view.window);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    dateSelectView = [[DateSelectView alloc] init];
    dateSelectView.theTitle.text = @"预约时间";
    
    NSTimeInterval a_day = 1*60*60;
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
