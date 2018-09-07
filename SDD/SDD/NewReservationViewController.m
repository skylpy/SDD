//
//  NewReservationViewController.m
//  SDD
//
//  Created by mac on 15/11/6.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "NewReservationViewController.h"
#import "MyReservationDetailModel.h"
#import "TabButton.h"
#import "DateSelectView.h"

#import "GRDetailViewController.h"
#import "LDProgressView.h"
#import "ProjectRentViewController.h"

#import "ReservationTableCell.h"

@interface NewReservationViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
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
    
    UILabel * nameLable;   //楼盘名
    
    NSDictionary * userDict;
}


@end

@implementation NewReservationViewController
#pragma mark - 请求数据
- (void)requestData{
    
    NSDictionary *param = @{@"houseAppointmentVisitId":[NSNumber numberWithInteger:_houseAppointmentVisitId]};
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/houseAppointmentVisit/detail.do" params:param success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSDictionary *dict = JSON[@"data"];
        userDict = dict;
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
    
    content = @[@[
                    model.houseName,
                    model.appointmentNumber,
                    [Tools_F timeTransform:(int)model.appointmentVisitTime time:dayszw],
                    model.rentPreferentialContent
                ],
                @[
                    model.houseName,
                    model.realName,
                    model.phone,
                    model.industryCategoryName,
                    model.brandName,
                    model.company,
                    model.postCategoryName,
                    [NSString stringWithFormat:@"%ld",model.rentPrice],
                    model.floorName,
                    [NSString stringWithFormat:@"%@m²",model.area]
                ]
            ];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    constTitles = @{@"FirstStep": @[@"",@"团租优惠券编码",@"预约时间",@"独享优惠"],
                    @"SecondStep":@[@"项目",@"姓名",@"手机号",@"行业",@"品牌",@"公司",@"职位",@"意向租金",@"意向楼层",@"面积"]
                   
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
    titleLabel.text = @"预约详情";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    UIButton * buttonT = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonT.frame = CGRectMake(0, 0, 40, 40);
    [buttonT setImage:[UIImage imageNamed:@"icon-cellphone"] forState:UIControlStateNormal];
    [buttonT addTarget:self action:@selector(buttonTClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:buttonT];
    
    self.navigationItem.rightBarButtonItem = item;
    
}
#pragma mark - 点击电话
-(void)buttonTClick:(UIButton *)btn
{
    NSString *telNumber = [[NSString alloc] initWithFormat:@"telprompt://%@",@"4009918829"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telNumber]];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    //楼盘名字
    nameLable = [[UILabel alloc] init];
    nameLable.font = [UIFont systemFontOfSize:14];
    nameLable.textAlignment = NSTextAlignmentCenter;
    
    // table
    table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    table.backgroundColor = bgColor;
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
#pragma mark --把表头隐藏
    
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *footer = [[UIView alloc] init];
    footer.frame = CGRectMake(0, 0, viewWidth, 64);
    footer.userInteractionEnabled = YES;
    
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
    
    
    [footerBtn addTarget:self action:@selector(toMyReservation:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_isComin == 1) {
        
        [footerBtn setTitle:@"进入我的预约" forState:UIControlStateNormal];
    }
    else
    {
        [footerBtn setTitle:@"进入项目详情" forState:UIControlStateNormal];
    }
    
    
    table.tableFooterView = footer;

}


#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            return 40;
            break;
        case 1:
            return 30;
            break;
        default:
        {
            if (indexPath.row == 0) {
                return 60;
            }
            else
            {
                return 44;
            }
        }
            break;
    }
    return 0;
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:{
            
            return [constTitles[@"FirstStep"] count];
        }
        case 1:{
            
            return [constTitles[@"SecondStep"] count];
        }
        case 2:{
            
            switch (model.status) {
                case 0:
                    return 2;
                    break;
                case 1:
                    return 3;
                    break;
                case 2:
                    return 4;
                    break;
                default:
                    return 5;
                    break;
            }
            return 0;
            
        }
    }
    return 0;
}

#pragma mark - 设置Sections数 (tableView)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

#pragma mark - 设置section 头高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 0.01;
    }
    else
    {
        return 10;

    }
}

#pragma mark - 设置section 脚高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    return 0.01;
}

#pragma mark - 设置cell (tableView)
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    tableView.separatorStyle = NO;                  // 隐藏分割线
    
    switch (indexPath.section) {
        case 0:
        {
            //重用标识符
            static NSString *identifier = @"FirstStep";
            //重用机制
            ReservationTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];      //带标识符的出列
            
            if (cell == nil) {
                // 当不存在的时候用重用标识符生成
                cell = [[ReservationTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
                
            }
            if (indexPath.row == 0 ) {
                
                
                [cell addSubview:nameLable];
                
                nameLable.text = content[0][indexPath.row] == [NSNull null]?@"网络不给力":content[0][indexPath.row];
                [nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(cell.mas_top);
                    make.bottom.equalTo(cell.mas_bottom);
                    make.left.equalTo(cell.mas_left).with.offset(0);
                    make.right.equalTo(cell.mas_right).with.offset(0);
                }];
            }
            else if (indexPath.row == 3) {
                
                NSString *originalStr = [NSString stringWithFormat:@"%@:  %@",constTitles[@"FirstStep"][indexPath.row],content[0][indexPath.row] == [NSNull null]?@"网络不给力":content[0][indexPath.row]];
                NSMutableAttributedString *paintStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
                [paintStr addAttribute:NSForegroundColorAttributeName
                                 value:tagsColor
                                 range:[originalStr rangeOfString:[NSString stringWithFormat:@"%@",
                                                                   content[0][indexPath.row]]]
                 ];
                
                cell.nameLabel.attributedText = paintStr;
            }
            else if (indexPath.row == 2){
            
                Tools_F * tool_f = [[Tools_F alloc] init];
                NSString *originalStr = [NSString stringWithFormat:@"%@:  %@(%@)",constTitles[@"FirstStep"][indexPath.row],content[0][indexPath.row],[tool_f featureWeekdayWithDate:content[0][indexPath.row]]];
                NSMutableAttributedString *paintStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
                [paintStr addAttribute:NSForegroundColorAttributeName
                                 value:lgrayColor
                                 range:[originalStr rangeOfString:[NSString stringWithFormat:@"%@(%@)",
                                                                   content[0][indexPath.row],[tool_f featureWeekdayWithDate:content[0][indexPath.row]]]]
                 ];
                
                cell.nameLabel.attributedText = paintStr;
            }
            else
            {
                NSString *originalStr = [NSString stringWithFormat:@"%@:  %@",constTitles[@"FirstStep"][indexPath.row],content[0][indexPath.row]];
                NSMutableAttributedString *paintStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
                [paintStr addAttribute:NSForegroundColorAttributeName
                                 value:lgrayColor
                                 range:[originalStr rangeOfString:[NSString stringWithFormat:@"%@",
                                                                   content[0][indexPath.row]]]
                 ];
                
                cell.nameLabel.attributedText = paintStr;
            }
            
            return cell;
        }
            break;
        case 1:
        {
            //重用标识符
            static NSString *identifier = @"SecondStep";
            //重用机制
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];      //带标识符的出列
            
            
            if (cell == nil) {
                // 当不存在的时候用重用标识符生成
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
                cell.textLabel.font = [UIFont systemFontOfSize:14];
            }
            
            NSString *originalStr = [NSString stringWithFormat:@"%@:  %@",constTitles[@"SecondStep"][indexPath.row],content[1][indexPath.row]];
            NSMutableAttributedString *paintStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
            [paintStr addAttribute:NSForegroundColorAttributeName
                             value:lgrayColor
                             range:[originalStr rangeOfString:[NSString stringWithFormat:@"%@",
                                                               content[1][indexPath.row]]]
             ];
            
            cell.textLabel.attributedText = paintStr;
            
            return cell;
        }
            break;
        default:
        {
            //重用标识符
            static NSString *identifier = @"ThirdStep";
            //重用机制
            ReservationTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];      //带标识符的出列
            
            
            if (cell == nil) {
                // 当不存在的时候用重用标识符生成
                cell = [[ReservationTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
                cell.textLabel.font = [UIFont systemFontOfSize:14];
                cell.detailTextLabel.font = midFont;
                cell.detailTextLabel.textColor = lgrayColor;
            }
            if (indexPath.row == 0) {
                cell.progressImage.hidden = NO;
                NSArray * arr = @[@"预约",@"到访",@"意向金",@"签约"];
                for (int i = 0; i < 4; i ++) {
                    
                    UILabel *topLabel = [[UILabel alloc] init];
                    topLabel.font = midFont;
                    topLabel.text = arr[i];
                    topLabel.textAlignment = NSTextAlignmentCenter;
                    [cell addSubview:topLabel];
                    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.equalTo(cell.mas_bottom).with.offset(-5);
                        make.left.equalTo(cell.mas_left).with.offset(i*(viewWidth/4)+10);
                        make.width.equalTo(@((viewWidth-90)/4));
                        make.height.equalTo(@28);
                    }];
                    if (i == 0) {
                        
                        topLabel.textAlignment = NSTextAlignmentLeft;
                    }
                    if (i == 3||i==2) {
                        
                        topLabel.textAlignment = NSTextAlignmentRight;
                    }
                }

                if (model.status == 0) {
                    
                    cell.progressImage.image = [UIImage imageNamed:@"tip-book-on1"];
                }
                else if (model.status == 1){
                    
                    cell.progressImage.image = [UIImage imageNamed:@"tip-book-on2"];
                }
                else if (model.status == 2){
                    
                    cell.progressImage.image = [UIImage imageNamed:@"tip-book-on3"];
                }
                else
                {
                    cell.progressImage.image = [UIImage imageNamed:@"tip-book-on4"];
                }
            }else{
                cell.progressImage.hidden = YES;
            }
            switch (model.status) {
                case 0:
                {
                    if (indexPath.row == 1) {
                        
                        cell.textLabel.text = @"预约成功";
                        cell.detailTextLabel.text = [Tools_F timeTransform:(int)model.appointmentVisitTime time:minutes];
                    }
                }
                    break;
                case 1:
                {
                    if (indexPath.row == 1) {
                        
                        cell.textLabel.text = @"预约成功";
                        cell.detailTextLabel.text = [Tools_F timeTransform:(int)model.appointmentVisitTime time:minutes];
                        
                        
                        
                    }
                    else if (indexPath.row == 2){
                        
                        cell.textLabel.text = @"到访成功";
                        cell.detailTextLabel.text = [Tools_F timeTransform:(int)model.visitedTime time:minutes];
                        
                    }
                }
                    break;
                case 2:
                {
                    if (indexPath.row == 1) {
                        
                        cell.textLabel.text = @"预约成功";
                        cell.detailTextLabel.text = [Tools_F timeTransform:(int)model.appointmentVisitTime time:minutes];
                        
                        
                    }
                    else if (indexPath.row == 2){
                        
                        cell.textLabel.text = @"到访成功";
                        cell.detailTextLabel.text = [Tools_F timeTransform:(int)model.visitedTime time:minutes];
                        
                    }
                    else if (indexPath.row == 3){
                        
                        cell.textLabel.text = @"已交意向金";
                        cell.detailTextLabel.text = [Tools_F timeTransform:(int)model.paySuccessTime time:minutes];
                    }
                }
                    break;
                default:
                {
                    if (indexPath.row == 1) {
                        
                        cell.textLabel.text = @"预约成功";
                        cell.detailTextLabel.text = [Tools_F timeTransform:(int)model.appointmentVisitTime time:minutes];
                        
                        
            
                    }
                    else if (indexPath.row == 2){
                        
                        cell.textLabel.text = @"到访成功";
                        cell.detailTextLabel.text = [Tools_F timeTransform:(int)model.visitedTime time:minutes];

                    }
                    else if (indexPath.row == 3){
                        
                        cell.textLabel.text = @"已交意向金";
                        cell.detailTextLabel.text = [Tools_F timeTransform:(int)model.paySuccessTime time:minutes];
                        
                    }
                    else if (indexPath.row == 4){
                        
                        cell.textLabel.text = @"签约成功";
                        cell.detailTextLabel.text = [Tools_F timeTransform:(int)model.signSuccessTime time:minutes];
                        
                    }
                }
                    break;
            }
            return cell;
        }
            break;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];      //带标识符的出列
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    return cell;
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
    
    if ([btn.titleLabel.text isEqualToString:@"进入我的预约"]) {
        
        self.tabBarController.selectedIndex = 1;
        [self.navigationController popToRootViewControllerAnimated:YES];

    }
    else{
    
        GRDetailViewController *grDetail = [[GRDetailViewController alloc] init];
        grDetail.activityCategoryId = @"2";
        grDetail.houseID = [NSString stringWithFormat:@"%ld",model.houseId];
        [self.navigationController pushViewController:grDetail animated:YES];
    }
    
}

#pragma mark - 项目详情
- (void)projectDetail:(UIButton *)btn{
    
    GRDetailViewController *grDetail = [[GRDetailViewController alloc] init];
    grDetail.activityCategoryId = @"2";
    grDetail.houseID = [NSString stringWithFormat:@"%ld",model.houseId];
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
