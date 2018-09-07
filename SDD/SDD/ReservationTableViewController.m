//
//  ReservationTableViewController.m
//  SDD
//
//  Created by hua on 15/7/29.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ReservationTableViewController.h"
#import "MyReservationDetailModel.h"
#import "TabButton.h"
#import "DateSelectView.h"

#import "GRDetailViewController.h"
#import "LDProgressView.h"
#import "ProjectRentViewController.h"

@interface ReservationTableViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    /*- ui -*/
    
    UITableView *table;
    
    LDProgressView *theProgress;                // 顶部进度条
    UILabel *name;                              // 姓名
    UILabel *dateLabel;                         // 指定看铺时间
    UIView *shadowView;
    DateSelectView *dateSelectView;             // 日期选择
    
    /*- data -*/
    
    NSDictionary *constTitles;
    NSDate *dateSelected;
    
    MyReservationDetailModel *model;            // 数据模型
    NSArray *content;
    
    UILabel * titLabel ;
}

@end

@implementation ReservationTableViewController

#pragma mark - 请求数据
- (void)requestData{
    
    NSDictionary *param = @{@"houseAppointmentVisitId":[NSNumber numberWithInteger:_houseAppointmentVisitId]};
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/houseAppointmentVisit/detail.do" params:param success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSDictionary *dict = JSON[@"data"];
        if (![dict isEqual:[NSNull null]]) {
            
            model = [MyReservationDetailModel objectWithKeyValues:dict];
            [self setupContent];
        }
        [table reloadData];
    } failure:^(NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
}

-(void)setupContent{
    
    content = @[model.houseName,model.realName,model.phone,model.userIndustryCategoryName,
                model.brandName,model.company,model.deptName,model.postCategoryName,
                model.industryCategoryName,model.floorName,model.appointmentAreaName,model.area
                ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    constTitles = @{@"FirstStep": @[@"楼盘",@"姓名",@"手机号",@"行业",
                                    @"品牌",@"公司",@"部门",@"职位",
                                    @"业态",@"楼层",@"区域",@"面积"],
                    @"SecondStep":@[@"姓名",@"指定看铺时间"],
                    @"LastStep":@[@"",@"预约号",@"预约时间",@"优惠独享"]
                    };
    //项目标题（例：中润欧洲城）
    titLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, viewWidth-20, 20)];
    // 数据请求
    [self requestData];
    // 导航条
    [self setupNav];
    // 设置内容
    [self setupUI];    
}

#pragma mark - 设置导航条
- (void)setupNav{
    
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"预约清单";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
//    SDDButton *button = [[SDDButton alloc]init];
//    button.frame = CGRectMake(0, 0, 100, 44);
//    [button setTitle:@"预约清单" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
//    UIButton *commit = [[UIButton alloc] init];
//    commit.frame = CGRectMake(0, 0, 65, 44);
//    commit.titleLabel.font = largeFont;
//    [commit setTitle:@"项目详情" forState:UIControlStateNormal];
//    [commit addTarget:self action:@selector(projectDetail:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:commit];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    UIView *headView = [[UIView alloc] init];
    headView.frame = CGRectMake(0, 0, viewWidth, 115);
    headView.backgroundColor = divisionColor;
    
    theProgress = [[LDProgressView alloc] initWithFrame:CGRectMake(viewWidth/6, 42, viewWidth*2/3, 5)];
    theProgress.color = deepOrangeColor;
    theProgress.showText = @NO;
    theProgress.showBackgroundInnerShadow = @NO;
    theProgress.progress = 0.25;
    theProgress.animate = @YES;
    theProgress.borderRadius = @0;
    theProgress.type = LDProgressSolid;
    [headView addSubview:theProgress];
    
    NSArray *tabTitles = @[@"1.预约项目",@"2.预约时间",@"3.提交成功"];
    NSArray *tabImages = @[@"reservation_project_icon_selected",
                           @"reservation_time_icon_unSelected",
                           @"reservation_succeed_icon_unSelected"];
    NSArray *tabImages_S = @[@"reservation_project_icon_selected",
                             @"reservation_time_icon_selected",
                             @"reservation_succeed_icon_selected"];
    TabButton *lastBtn;
    for (int i=0; i<3; i++) {
        
        TabButton *tabBtn = [TabButton buttonWithType:UIButtonTypeCustom];
        tabBtn.tag = 100+i;
        tabBtn.titleLabel.font = midFont;
        tabBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [tabBtn setTitle:tabTitles[i] forState:UIControlStateNormal];
        [tabBtn setTitleColor:lgrayColor forState:UIControlStateNormal];
        [tabBtn setTitleColor:deepOrangeColor forState:UIControlStateSelected];
        [tabBtn setImage:[UIImage imageNamed:tabImages[i]] forState:UIControlStateNormal];
        [tabBtn setImage:[UIImage imageNamed:tabImages_S[i]] forState:UIControlStateSelected];
        [tabBtn addTarget:self action:@selector(stepSelected:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:tabBtn];
        
        tabBtn.userInteractionEnabled = NO;
        
        [tabBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastBtn?lastBtn.mas_right:headView.mas_left);
            make.centerY.equalTo(headView);
            make.size.mas_equalTo(CGSizeMake(viewWidth/3, 80));
        }];
        
        lastBtn = tabBtn;
    }
    
    TabButton *tab;
    switch (_theStep) {
        case firstStep: tab = (TabButton *)[headView viewWithTag:100];
            break;
        case secondStep: tab = (TabButton *)[headView viewWithTag:101];
            break;
        case lastStep: tab = (TabButton *)[headView viewWithTag:102];
            break;
    }
    [self stepSelected:tab];
    
    // table
    table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    table.backgroundColor = bgColor;
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
#pragma mark --把表头隐藏
    //table.tableHeaderView = headView;
    
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
//    ConfirmButton * conBrandBtn = [[ConfirmButton alloc] initWithFrame:CGRectMake(20, 10, viewWidth-40, 45) title:Brand target:self action:@selector(ConBrand:)];
//    conBrandBtn.enabled = YES;
//    [cell.contentView addSubview:conBrandBtn];
}

#pragma mark - 设置footter
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footer = [[UIView alloc] init];
    footer.frame = CGRectMake(0, 0, viewWidth, 64);
    
    // 发布
    UIButton *footerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    footerBtn.backgroundColor = dblueColor;
    [Tools_F setViewlayer:footerBtn cornerRadius:5 borderWidth:0 borderColor:nil];
    
    [footer addSubview:footerBtn];
    [footerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.centerX.equalTo(footer);
        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 44));
    }];
    
    switch (_theStep) {
        case firstStep:{
            
            [footerBtn setTitle:@"预约时间" forState:UIControlStateNormal];
            [footerBtn addTarget:self action:@selector(confirmTime:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case secondStep:{
            
            [footerBtn setTitle:@"确定预约" forState:UIControlStateNormal];
            [footerBtn addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case lastStep:{
            
            footerBtn.hidden = YES;
            if (section == 1) {
                footerBtn.hidden = NO;
                [footerBtn setTitle:_isFromPersonal?@"进入项目详情":@"进入我的预约" forState:UIControlStateNormal];
                [footerBtn addTarget:self action:@selector(toMyReservation:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
            break;
    }
    return footer;
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (_theStep) {
        case firstStep:{
            
            return 38;
        }
        case secondStep:{
            
            return 45;
        }
        case lastStep:{
            
            return indexPath.section == 0?30:30;
        }
    }
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (_theStep) {
        case firstStep:{
            
            return [constTitles[@"FirstStep"] count];
        }
        case secondStep:{
            
            return [constTitles[@"SecondStep"] count];
        }
        case lastStep:{
            
            return section == 0?[constTitles[@"LastStep"] count]:[constTitles[@"FirstStep"] count];
            
        }
    }
}

#pragma mark - 设置Sections数 (tableView)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    switch (_theStep) {
        case firstStep:{
            
            return 1;
        }
        case secondStep:{
            
            return 1;
        }
        case lastStep:{
            
            return 2;
        }
    }
}

#pragma mark - 设置section 头高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}

#pragma mark - 设置section 脚高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (_theStep == lastStep && section ==0) {
        return 10;
    }
    else {
        return 64;
    }
}

#pragma mark - 设置cell (tableView)
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (_theStep) {
        case firstStep:{
            
            //重用标识符
            static NSString *identifier = @"FirstStep";
            //重用机制
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];      //带标识符的出列
            tableView.separatorStyle = NO;                  // 隐藏分割线

            if (cell == nil) {
                // 当不存在的时候用重用标识符生成
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
                cell.textLabel.font = [UIFont systemFontOfSize:14];
            }
            
            NSString *originalStr = [NSString stringWithFormat:@"%@:  %@",constTitles[@"FirstStep"][indexPath.row],content[indexPath.row]];
            NSMutableAttributedString *paintStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
            [paintStr addAttribute:NSForegroundColorAttributeName
                             value:lgrayColor
                             range:[originalStr rangeOfString:[NSString stringWithFormat:@"%@",
                                                               content[indexPath.row]]]
             ];
            
            cell.textLabel.attributedText = paintStr;
            
            return cell;
        }
        case secondStep:{
            
            //重用标识符
            static NSString *identifier = @"SecondStep";
            //重用机制
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];      //带标识符的出列
            tableView.separatorStyle = YES;                  // 显示分割线
            
            if (cell == nil) {
                // 当不存在的时候用重用标识符生成
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
                cell.textLabel.font = [UIFont systemFontOfSize:14];
                
                if (indexPath.row == 0 && name == nil) {
                    
                    name = [[UILabel alloc] init];
                    name.font = [UIFont systemFontOfSize:14];
                    name.textColor = lgrayColor;
                    
                    [cell addSubview:name];
                    
                    [name mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(cell.mas_top);
                        make.bottom.equalTo(cell.mas_bottom);
                        make.left.equalTo(cell.mas_left).with.offset(viewWidth/5);
                        make.right.equalTo(cell.mas_right).with.offset(-10);
                    }];
                }
                
                if (indexPath.row == 1 && dateLabel == nil) {
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                    dateLabel = [[UILabel alloc] init];
                    dateLabel.font = [UIFont systemFontOfSize:14];
                    
                    [cell addSubview:dateLabel];
                    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(cell.mas_top);
                        make.bottom.equalTo(cell.mas_bottom);
                        make.left.equalTo(cell.mas_left).with.offset(viewWidth*2/5-10);
                        make.right.equalTo(cell.mas_right).with.offset(-30);
                    }];
                }
            }
            
            name.text = model.realName;
            cell.textLabel.text = constTitles[@"SecondStep"][indexPath.row];
            
            return cell;
        }
        case lastStep:{
            
            //重用标识符
            static NSString *identifier = @"LastStep";
            //重用机制
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];      //带标识符的出列
            tableView.separatorStyle = NO;                  // 隐藏分割线

            if (cell == nil) {
                // 当不存在的时候用重用标识符生成
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
                cell.textLabel.font = midFont;
            }
            
            
            if (indexPath.section == 0) {
                
                switch (indexPath.row) {
                    case 0:
                    {
                        
                        titLabel.textAlignment = NSTextAlignmentCenter;
                        titLabel.font = [UIFont systemFontOfSize:15];
                        titLabel.text = [NSString stringWithFormat:@"%@(%@/%@/%@m²)",
                                               model.houseName,
                                               model.floorName,
                                               model.appointmentAreaName,
                                               model.area];
                        [cell.contentView addSubview:titLabel];
//                        cell.textLabel.textAlignment = NSTextAlignmentCenter;
                    }
                        break;
                    case 1:
                    {
                        // 预约号
                        cell.textLabel.text = [NSString stringWithFormat:@"%@:  %@",constTitles[@"LastStep"][indexPath.row],model.appointmentNumber];
                    }
                        break;
                    case 2:
                    {
                        // 预约时间
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        formatter.dateFormat = @"yyyy-MM-dd";
                        // 现都为网络获取
                        cell.textLabel.text = [NSString stringWithFormat:@"%@:  %@",
                                               constTitles[@"LastStep"][indexPath.row],
                                               [Tools_F timeTransform:model.appointmentVisitTime time:days]];
//                        _isFromPersonal?[Tools_F timeTransform:model.appointmentVisitTime time:days]
//                        :[formatter stringFromDate:dateSelected]
                    }
                        break;
                    default:
                    {
                        cell.textLabel.text =[NSString stringWithFormat:@"%@:认租即免租金3个月",constTitles[@"LastStep"][indexPath.row]];
                        cell.textLabel.textColor = dblueColor;
                    }
                        break;
                }
            }
            else {
                
                NSString *originalStr = [NSString stringWithFormat:@"%@:  %@",constTitles[@"FirstStep"][indexPath.row],content[indexPath.row]];
                NSMutableAttributedString *paintStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
                [paintStr addAttribute:NSForegroundColorAttributeName
                                 value:lgrayColor
                                 range:[originalStr rangeOfString:[NSString stringWithFormat:@"%@",
                                                                   content[indexPath.row]]]
                 ];
                
                cell.textLabel.attributedText = paintStr;
            }
            
            return cell;
        }
    }
}

#pragma mark - 点击cell (tableView)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_theStep == secondStep && indexPath.row == 1) {
        
        shadowView = [[UIView alloc] init];
        shadowView.backgroundColor = [UIColor blackColor];
        shadowView.alpha = 0;
        [self.view addSubview:shadowView];
        
        [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
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
            shadowView.alpha = 0.5;
            [dateSelectView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(viewWidth-40, 235));
            }];
        }];
    }
}

#pragma mark - 回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [UIView animateWithDuration:0.3 animations:^{
        shadowView.alpha = 0;
        [shadowView removeFromSuperview];
        [dateSelectView removeFromSuperview];
    }];
}

#pragma mark - 日期变动
- (void)dateChange:(UIDatePicker *)sender{
    
    dateSelected = sender.date;
    NSLog(@"时间——%@",dateSelected);
}

#pragma mark - 确认日期
- (void)selectedDate:(UIButton *)btn{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    dateLabel.text = [formatter stringFromDate:dateSelected];    // table显示
    
    [UIView animateWithDuration:0.3 animations:^{
        shadowView.alpha = 0;
        [shadowView removeFromSuperview];
        [dateSelectView removeFromSuperview];
    }];
}

#pragma mark - 步骤
- (void)stepSelected:(TabButton *)btn{
    
    for (int i=100; i<103; i++) {
        TabButton *allBtn = (TabButton *)[btn.superview viewWithTag:i];
        if (allBtn.tag <= btn.tag) {
            
            allBtn.selected = YES;
        }
        else {
            
            allBtn.selected = NO;
        }
    }
    _theStep = btn.tag-100;
    theProgress.progress = 0.25+((NSInteger)btn.tag-100)*0.5;
    [table reloadData];
}

#pragma mark - 预约时间
- (void)confirmTime:(UIButton *)btn{
    
    TabButton *tab = (TabButton *)[table.tableHeaderView viewWithTag:101];
    [self stepSelected:tab];
}

#pragma mark - 确认提交
- (void)commit:(UIButton *)btn{
    
    if (!dateSelected) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请选择时间"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        
        NSDictionary *param = @{@"houseAppointmentVisitId":[NSNumber numberWithInteger:_houseAppointmentVisitId],
                                @"appointmentVisitTime":[NSNumber numberWithInteger:(NSInteger)[dateSelected timeIntervalSince1970]]
                                };

        [HttpTool postWithBaseURL:SDD_MainURL Path:@"/houseAppointmentVisit/changeAppointmentVisitTime.do" params:param success:^(id JSON) {
            
            NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
            NSInteger theStatus = [JSON[@"status"] integerValue];
            
            if (theStatus == 1) {
                
                TabButton *tab = (TabButton *)[table.tableHeaderView viewWithTag:102];
                [self stepSelected:tab];
            }
        } failure:^(NSError *error) {
//            
            NSLog(@"错误 -- %@", error);
        }];
    }
}

#pragma mark - 进入我的预约
- (void)toMyReservation:(UIButton *)btn{
    
    if (_isFromPersonal) {
        
        GRDetailViewController *grDetail = [[GRDetailViewController alloc] init];
        grDetail.activityCategoryId = @"2";
        grDetail.houseID = [NSString stringWithFormat:@"%ld",model.houseId];
        [self.navigationController pushViewController:grDetail animated:YES];
    }
    else {
        ProjectRentViewController * MyAppVc = [[ProjectRentViewController alloc] init];
        
        [self.navigationController pushViewController:MyAppVc animated:YES];
//        [self.navigationController popToRootViewControllerAnimated:YES];
//        self.tabBarController.selectedIndex = 2;
    }
}

#pragma mark - 项目详情
- (void)projectDetail:(UIButton *)btn{
    
    GRDetailViewController *grDetail = [[GRDetailViewController alloc] init];
    grDetail.activityCategoryId = @"2";
    grDetail.houseID = [NSString stringWithFormat:@"%d",model.houseId];
    [self.navigationController pushViewController:grDetail animated:YES];
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
