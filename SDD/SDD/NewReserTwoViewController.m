//
//  NewReserTwoViewController.m
//  SDD
//
//  Created by mac on 15/11/5.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "NewReserTwoViewController.h"
#import "FSDropDownMenu.h"
#import "FindBrankModel.h"
#import "DateSelectView.h"
#import "OrderReservationSucceedViewController.h"

#import "NewReservationViewController.h"
#import "SDDtextViewController.h"

typedef NS_ENUM(NSInteger, ColumnType)
{
    industryType = 0,
    jobType = 1,
    formatType = 2,
    floorType = 3,
    regionType = 4,
};
@interface NewReserTwoViewController ()<UITextFieldDelegate,FSDropDownMenuDataSource,FSDropDownMenuDelegate,UIAlertViewDelegate>
{
    UITextField *industryTextfield;               /**< 行业 */
    UITextField *brandTextfield;                  /**< 品牌 */
    UITextField *companyTextfield;                /**< 公司 */
    UITextField *departmentTextfield;             /**< 部门 */
    UITextField *jobTextfield;                    /**< 职位 */
    
    UIScrollView * _scrollView;                    /**< 滚动条 */
    
    UITextField *dateTextfield;                   /**< 预约时间 */
    UITextField *formatTextfield;                 /**< 业态 */
    UITextField *floorsTextfield;                 /**< 楼层 */
    UITextField *regionTextfield;                 /**< 区域 */
    UITextField *areaTextfield;                   /**< 面积 */
    
    FSDropDownMenu *dropMenu;
    ColumnType cType;
    
    FindBrankModel *currentModel;                 /**< 行业当前模型 */
    FindBrankModel *currentModel2;                /**< 楼层当前模型 */
    
    NSInteger industryCategoryId;                 /**< 行业父 */
    NSInteger industryCategoryId2;                /**< 行业子 */
    NSInteger postCategoryId;                     /**< 职业 */
    NSInteger industryId;                         /**< 业态 */
    NSInteger floor;                              /**< 楼层 */
    NSInteger appointmentAreaId;                  /**< 区域 */
    
    UIView *shadowView;
    DateSelectView *dateSelectView;             // 日期选择
    
    NSDate *dateSelected;                         /**< 预约时间 */
}

// 行业类别
@property (nonatomic, strong) NSMutableArray *industryAll;
// 职务类别
@property (nonatomic, strong) NSMutableArray *jobAll;
// 业态类别
@property (nonatomic, strong) NSMutableArray *formatAll;
// 楼层类别
@property (nonatomic, strong) NSMutableArray *floorsAll;
@end

@implementation NewReserTwoViewController
- (NSMutableArray *)industryAll{
    if (!_industryAll) {
        _industryAll = [[NSMutableArray alloc]init];
    }
    return _industryAll;
}

- (NSMutableArray *)jobAll{
    if (!_jobAll) {
        _jobAll = [[NSMutableArray alloc]init];
    }
    return _jobAll;
}

- (NSMutableArray *)formatAll{
    if (!_formatAll) {
        _formatAll = [[NSMutableArray alloc]init];
    }
    return _formatAll;
}

- (NSMutableArray *)floorsAll{
    if (!_floorsAll) {
        _floorsAll = [[NSMutableArray alloc]init];
    }
    return _floorsAll;
}
#pragma mark - 请求数据
- (void)requestData{
    
    // 行业类别
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brandCategory/industryAllList.do" params:nil success:^(id JSON) {
        
        //        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSDictionary *dict = JSON[@"data"];
        
        if (![dict isEqual:[NSNull null]]) {
            
            [_industryAll removeAllObjects];
            
            BOOL flag = NO;
            for (NSDictionary *tempDic in dict) {
                flag = YES;
                FindBrankModel *model = [FindBrankModel findBrankWithDict:tempDic];
                [self.industryAll addObject:model];
            }
            FindBrankModel *model = _industryAll[0];
            currentModel = flag?model:nil;
        }
    } failure:^(NSError *error) {
        
    }];
    
    // 职务
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/houseFirstCategory/userPostCategorys.do" params:nil success:^(id JSON) {
        
        //        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSDictionary *dict = JSON[@"data"];
        
        if (![dict isEqual:[NSNull null]]) {
            
            [_jobAll removeAllObjects];
            
            for (NSDictionary *tempDic in dict) {
                
                FindBrankModel *model = [FindBrankModel findBrankWithDict:tempDic];
                [self.jobAll addObject:model];
            }
        }
    } failure:^(NSError *error) {
        
    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;

    [self setNav:@"在线预约看铺"];
    [self setupSecond];
    [self requestData];
    // 栏目选择
    dropMenu = [[FSDropDownMenu alloc] initWithOrigin:CGPointMake(0, viewHeight-364) andHeight:300];
    dropMenu.dataSource = self;
    dropMenu.delegate = self;
    [self.view addSubview:dropMenu];
}
#pragma mark - 第二步
- (void)setupSecond{
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = bgColor;
    
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.view);
    }];
    
    // 底部view， 用于计算scrollview高度
    UIView* contentView = [[UIView alloc] init];
    contentView.backgroundColor = bgColor;
    [_scrollView addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_scrollView);
        make.width.equalTo(_scrollView);
    }];
    
    UITextField *lastTextField;
    for (int i=0; i<4; i++) {
        
        // 标题
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 0, 70, 45);
        label.userInteractionEnabled = YES;
        label.font = midFont;
        label.textColor = mainTitleColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        
        // 内容
        UITextField *textfield = [[UITextField alloc] init];
        textfield.font = midFont;
        textfield.textColor = mainTitleColor;
        textfield.backgroundColor = [UIColor whiteColor];
        textfield.leftView = label;
        textfield.delegate = self;
        textfield.leftViewMode = UITextFieldViewModeAlways;
        textfield.rightViewMode = UITextFieldViewModeAlways;
        [contentView addSubview:textfield];
        
        [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastTextField?lastTextField.mas_bottom:contentView.mas_top);
            make.left.equalTo(self.view.mas_left);
            make.size.mas_equalTo(CGSizeMake(viewWidth, 45));
        }];
        
        // 分割线
        if (lastTextField) {
            
            UIView *cutoff = [[UIView alloc] init];
            cutoff.backgroundColor = ldivisionColor;
            [contentView addSubview:cutoff];
            
            [cutoff mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastTextField.mas_bottom);
                make.left.equalTo(self.view.mas_left);
                make.size.mas_equalTo(CGSizeMake(viewWidth, 1));
            }];
        }
        
        switch (i) {
            case 0:
            {
                UIImageView *arrow = [[UIImageView alloc] init];
                arrow.frame = CGRectMake(0, (45-13)/2, 18, 13);
                arrow.backgroundColor = [UIColor whiteColor];
                arrow.image = [UIImage imageNamed:@"gray_rightArrow"];
                arrow.contentMode = UIViewContentModeScaleAspectFit;
                textfield.rightView = arrow;
                
                label.text = @"行业:";
                textfield.placeholder = @"请选择您的行业最多可选3项";
                industryTextfield = textfield;
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button addTarget:self action:@selector(industrySelected) forControlEvents:UIControlEventTouchUpInside];
                [textfield addSubview:button];
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(textfield);
                }];
            }
                break;
            case 1:
            {
                label.text = @"品牌:";
                textfield.placeholder = @"请填写您的品牌名称";
                brandTextfield = textfield;
            }
                break;
            case 2:
            {
                label.text = @"公司:";
                textfield.placeholder = @"请填写您的公司";
                companyTextfield = textfield;
            }
                break;
            
            case 3:
            {
                UIImageView *arrow = [[UIImageView alloc] init];
                arrow.frame = CGRectMake(0, (45-13)/2, 18, 13);
                arrow.backgroundColor = [UIColor whiteColor];
                arrow.image = [UIImage imageNamed:@"gray_rightArrow"];
                arrow.contentMode = UIViewContentModeScaleAspectFit;
                textfield.rightView = arrow;
                
                label.text = @"职位:";
                textfield.placeholder = @"请选择您的职位";
                jobTextfield = textfield;
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button addTarget:self action:@selector(jobSelected) forControlEvents:UIControlEventTouchUpInside];
                [textfield addSubview:button];
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(textfield);
                }];
            }
                break;
        }
        
        lastTextField = textfield;
    }
    
    
#pragma mark -- 部分
    // 标题
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, 85, 45);
    label.font = midFont;
    label.textColor = mainTitleColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor whiteColor];
    
    // 内容
    UITextField *textfield = [[UITextField alloc] init];
    textfield.font = midFont;
    textfield.textColor = mainTitleColor;
    textfield.backgroundColor = [UIColor whiteColor];
    textfield.leftView = label;
    textfield.delegate = self;
    textfield.leftViewMode = UITextFieldViewModeAlways;
    textfield.rightViewMode = UITextFieldViewModeAlways;
    [contentView addSubview:textfield];
    
    [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastTextField.mas_bottom).with.offset(10);
        make.left.equalTo(contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 45));
    }];
    
    UIImageView *arrow = [[UIImageView alloc] init];
    arrow.frame = CGRectMake(0, (45-13)/2, 18, 13);
    arrow.backgroundColor = [UIColor whiteColor];
    arrow.image = [UIImage imageNamed:@"gray_rightArrow"];
    arrow.contentMode = UIViewContentModeScaleAspectFit;
    textfield.rightView = arrow;
    
    NSString *originalStr = @"*预约时间:";
    NSMutableAttributedString *paintStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
    [paintStr addAttribute:NSForegroundColorAttributeName
                     value:tagsColor
                     range:[originalStr rangeOfString:@"*"]
     ];
    label.attributedText = paintStr;
    textfield.placeholder = @"请选择预约看铺时间";
    dateTextfield = textfield;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(dateSelected) forControlEvents:UIControlEventTouchUpInside];
    [textfield addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(textfield);
    }];

    
    UITextField *lastTextField1;
    for (int i=0; i<3; i++) {

        // 标题
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 0, 70, 45);
        label.font = midFont;
        label.textColor = mainTitleColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        
        // 内容
        UITextField *textfield = [[UITextField alloc] init];
        textfield.font = midFont;
        textfield.textColor = mainTitleColor;
        textfield.backgroundColor = [UIColor whiteColor];
        textfield.leftView = label;
        textfield.delegate = self;
        textfield.leftViewMode = UITextFieldViewModeAlways;
        textfield.rightViewMode = UITextFieldViewModeAlways;
        [contentView addSubview:textfield];
        
        [textfield mas_makeConstraints:^(MASConstraintMaker *make) {

            if (i == 0) {
                make.top.equalTo(lastTextField1?lastTextField1.mas_bottom:button.mas_bottom).with.offset(10);
            }
            else
            {
                make.top.equalTo(lastTextField1?lastTextField1.mas_bottom:button.mas_bottom).with.offset(0);
            }
            make.top.equalTo(lastTextField1?lastTextField1.mas_bottom:button.mas_bottom).with.offset(10);
            make.left.equalTo(contentView.mas_left);
            make.size.mas_equalTo(CGSizeMake(viewWidth, 45));
        }];
        
        // 分割线
        if (lastTextField1) {
            
            UIView *cutoff = [[UIView alloc] init];
            cutoff.backgroundColor = ldivisionColor;
            [_scrollView addSubview:cutoff];
            
            [cutoff mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastTextField1.mas_bottom);
                make.left.equalTo(self.view.mas_left);
                make.size.mas_equalTo(CGSizeMake(viewWidth, 1));
            }];
        }
        
        switch (i) {
            case 0:
            {
                UILabel *units = [[UILabel alloc] init];
                units.frame = CGRectMake(0, (45-13)/2, 60, 13);
                units.backgroundColor = [UIColor whiteColor];
                units.textColor = dblueColor;
                units.text = @"元/m²/月";
                units.font = midFont;
                textfield.rightView = units;
                
                NSString *originalStr = @"*意向租金:";
                NSMutableAttributedString *paintStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
                [paintStr addAttribute:NSForegroundColorAttributeName
                                 value:tagsColor
                                 range:[originalStr rangeOfString:@"*"]
                 ];
                label.attributedText = paintStr;
                textfield.placeholder = @"请填写你的意向租金";
                formatTextfield = textfield;

            }
                break;
            case 1:
            {
                UILabel *units = [[UILabel alloc] init];
                units.frame = CGRectMake(0, (45-13)/2, 25, 13);
                units.backgroundColor = [UIColor whiteColor];
                units.textColor = dblueColor;
                units.text = @"层";
                units.font = midFont;
                textfield.rightView = units;
                
                NSString *originalStr = @"*意向楼层:";
                NSMutableAttributedString *paintStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
                [paintStr addAttribute:NSForegroundColorAttributeName
                                 value:tagsColor
                                 range:[originalStr rangeOfString:@"*"]
                 ];
                label.attributedText = paintStr;
                textfield.placeholder = @"请填写数字，例如：“1”";
                floorsTextfield = textfield;

            }
                break;
            case 2:
            {
                UILabel *units = [[UILabel alloc] init];
                units.frame = CGRectMake(0, (45-13)/2, 25, 13);
                units.backgroundColor = [UIColor whiteColor];
                units.textColor = dblueColor;
                units.text = @"m²";
                units.font = midFont;
                textfield.rightView = units;
                
                NSString *originalStr = @"*面积需求:";
                NSMutableAttributedString *paintStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
                [paintStr addAttribute:NSForegroundColorAttributeName
                                 value:tagsColor
                                 range:[originalStr rangeOfString:@"*"]
                 ];
                label.attributedText = paintStr;
                textfield.placeholder = @"请填写您对商铺的面积需求";
                areaTextfield = textfield;
            }
                break;
        }
        
        lastTextField1 = textfield;
    }
    
    // 下一步
    ConfirmButton *nextButton = [[ConfirmButton alloc] initWithFrame:CGRectZero
                                                               title:@"立即预约"
                                                              target:self
                                                              action:@selector(btnClick:)];
    nextButton.enabled = YES;
    [contentView addSubview:nextButton];
    
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastTextField1.mas_bottom).offset(40);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(viewWidth-40, 45));
    }];
    
    
    UILabel * labelts = [[UILabel alloc] init];
    labelts.text = @"点击上面的“立即预约”即表示您同意";
    labelts.font = midFont;
    labelts.textAlignment = NSTextAlignmentCenter;
    labelts.textColor = lgrayColor;
    [contentView addSubview:labelts];
    [labelts mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nextButton.mas_bottom).offset(40);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(viewWidth-40, 15));
    }];
    
    UIButton * buttonyue = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonyue setTitle:@"《商多多看铺服务协议》" forState:UIControlStateNormal];
    [buttonyue setTitleColor:dblueColor forState:UIControlStateNormal];
    buttonyue.titleLabel.font = midFont;
    [buttonyue addTarget:self action:@selector(buttonyueClick:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:buttonyue];
    [buttonyue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(labelts.mas_bottom).offset(20);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(viewWidth-40, 05));
    }];
    
    // 自动scrollview高度
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(buttonyue.mas_bottom).with.offset(35);
    }];
}

-(void)buttonyueClick:(UIButton *)btn
{
    SDDtextViewController * SDDT = [[SDDtextViewController alloc] init];
    
    [self.navigationController pushViewController:SDDT animated:YES];
}

#pragma mark -- 立即预约按钮
-(void)btnClick:(UIButton *)btn
{
    [self btnRequset];
}

-(void)btnRequset
{
    [self showLoading:2];
    NSInteger appointmentVisitTime = [Tools_F cTimestampFromDate:dateSelected];
    NSDictionary * param = @{@"houseId":@([_houseID integerValue]),
                             @"rentPrice":@([formatTextfield.text integerValue]),
                             @"activityCategoryId":@(_activityCategoryId),
                             @"appointmentVisitTime":@(appointmentVisitTime),
                             @"area":@([areaTextfield.text integerValue]),
                             @"code":_codeStr,
                             @"company":companyTextfield.text,
                             @"brandName":brandTextfield.text,
                             @"floor":@([floorsTextfield.text integerValue]),
                             @"phone":_phoneStr,
                             @"postCategoryId":@(postCategoryId),
                             @"realName":_nameStr,
                             @"userIndustryCategoryIdList":@[@(industryCategoryId),@(industryCategoryId2)]
                             };
    
    NSLog(@"%@",param);
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/houseAppointmentVisit/add.do" params:param success:^(id JSON) {
        
        NSLog(@"%@",JSON);
        if ([JSON[@"status"] intValue] == 1) {
            
            NSLog(@"详情页");
            [self hideLoading];
            
            NewReservationViewController * reseVc = [[NewReservationViewController alloc] init];
            reseVc.houseAppointmentVisitId = [JSON[@"data"][@"houseAppointmentVisitId"] integerValue];
            reseVc.isComin = 1;
            [self.navigationController pushViewController:reseVc animated:YES];
            //            self.tabBarController.selectedIndex = 1;
            //            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
        }
        else {
            // 失败则跳回第一步
            [self showErrorWithText:JSON[@"message"]];
            
        }
        [self hideLoading];
        
    } failure:^(NSError *error) {
        
        [self hideLoading];
        [self showLoadfailedWithaction:@selector(btnAction)];
        
    }];
}
#pragma mark -- 加载失败之后重新加载
-(void)btnAction
{
    [self btnRequset];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    OrderReservationSucceedViewController *orsVC = [[OrderReservationSucceedViewController alloc] init];
    orsVC.houseName = _houseName;
    orsVC.houseId = _houseID;
    //orsVC.isOfficial = _isOfficial;
    [self.navigationController pushViewController:orsVC animated:YES];

    
}
- (void)dateSelected{
    
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
#pragma mark - 日期变动
- (void)dateChange:(UIDatePicker *)sender{
    
    dateSelected = sender.date;
    NSLog(@"时间——%@",dateSelected);
}

#pragma mark - 确认日期
- (void)selectedDate:(UIButton *)btn{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    dateTextfield.text = [formatter stringFromDate:dateSelected];    // table显示
    
    [UIView animateWithDuration:0.3 animations:^{
        shadowView.alpha = 0;
        [shadowView removeFromSuperview];
        [dateSelectView removeFromSuperview];
    }];
}
#pragma mark - 各类维度选择
- (void)industrySelected{
    
    cType = industryType;
    [self.view endEditing:YES];
    [dropMenu.rightTableView reloadData];
    [dropMenu menuTapped];
}
- (void)jobSelected{
    
    cType = jobType;
    [self.view endEditing:YES];
    [dropMenu.rightTableView reloadData];
    [dropMenu menuTapped];
}

#pragma mark - FSDropDown datasource & delegate
- (NSInteger)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == menu.leftTableView) {
        switch (cType) {
            case industryType:{
                if (currentModel) {
                    return [currentModel.children count]+1;
                }
                else {
                    return 0;
                }
            }
                break;
            case jobType:{
                
                return [_jobAll count];
            }
                break;
            case formatType:{
                
                return [_formatAll count];
            }
                break;
            case floorType:{
                
                return [_floorsAll count];
            }
                break;
            case regionType:{
                
                return [currentModel2.areaList count];
            }
                break;
        }
    }
    else {
        switch (cType) {
            case industryType:{
                
                
                return [_industryAll count];
            }
                break;
            case jobType:{
                
                return 1;
            }
                break;
            case formatType:{
                
                return 1;
            }
                break;
            case floorType:{
                
                return 1;
            }
                break;
            case regionType:{
                
                return 1;
            }
                break;
        }
    }
}

- (NSString *)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView titleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == menu.leftTableView) {
        switch (cType) {
            case industryType:{
                
                if (indexPath.row == 0) {
                    return @"不限";
                }
                else {
                    
                    NSDictionary *tempDic = currentModel.children[indexPath.row-1];
                    return tempDic[@"categoryName"];
                }
            }
                break;
            case jobType:{
                
                FindBrankModel *model = _jobAll[indexPath.row];
                return model.categoryName;
            }
                break;
            case formatType:{
                
                FindBrankModel *model = _formatAll[indexPath.row];
                return model.categoryName;
            }
                break;
            case floorType:{
                
                FindBrankModel *model = _floorsAll[indexPath.row];
                return model.floorName;
            }
                break;
            case regionType:{
                
                NSDictionary *tempDic = currentModel2.areaList[indexPath.row];
                return tempDic[@"appointmentAreaName"];
            }
                break;
        }
        if (indexPath.row == 0) {
            return @"不限";
        }
        else {
            
            NSDictionary *tempDic = currentModel.children[indexPath.row-1];
            return tempDic[@"categoryName"];
        }
    }
    else {
        switch (cType) {
            case industryType:{
                
                FindBrankModel *model = _industryAll[indexPath.row];
                return model.categoryName;
            }
                break;
            case jobType:{
                
                return @"职务";
            }
                break;
            case formatType:{
                
                return @"业态";
            }
                break;
            case floorType:{
                
                return @"楼层";
            }
                break;
            case regionType:{
                
                return @"区域";
            }
                break;
        }
    }
}

- (void)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == menu.leftTableView) {
        switch (cType) {
            case industryType:{
                if (indexPath.row == 0) {
                    
                    industryTextfield.text = [NSString stringWithFormat:@"%@-不限",currentModel.categoryName];
                    industryCategoryId2 = 0;
                }
                else {
                    
                    NSDictionary *tempDic = currentModel.children[indexPath.row-1];
                    industryTextfield.text = tempDic[@"categoryName"];
                    industryCategoryId2 = [tempDic[@"industryCategoryId"] integerValue];
                }
            }
                break;
            case jobType:{
                
                FindBrankModel *model = _jobAll[indexPath.row];
                jobTextfield.text = model.categoryName;
                postCategoryId = [model.postCategoryId integerValue];
            }
                break;
            case formatType:{
                
                FindBrankModel *model = _formatAll[indexPath.row];
                formatTextfield.text = model.categoryName;
                industryId = [model.industryCategoryId integerValue];
                
                // 重置楼层、区域
                floorsTextfield.text = @"";
                floor = 0;
                appointmentAreaId = 0;
                regionTextfield.text = @"";
            }
                break;
            case floorType:{
                
                FindBrankModel *model = _floorsAll[indexPath.row];
                floorsTextfield.text = model.floorName;
                floor = [model.floor integerValue];
                currentModel2 = model;
                
                // 重置区域
                appointmentAreaId = 0;
                regionTextfield.text = @"";
            }
                break;
            case regionType:{
                
                NSDictionary *tempDic = currentModel2.areaList[indexPath.row];
                appointmentAreaId = [tempDic[@"appointmentAreaId"] integerValue];
                regionTextfield.text = tempDic[@"appointmentAreaName"];
            }
                break;
        }
    }
    else {
        switch (cType) {
            case industryType:{
                
                FindBrankModel *model = _industryAll[indexPath.row];
                industryCategoryId = [model.industryCategoryId integerValue];
                currentModel = model;
            }
                break;
            case jobType:{
                
            }
                break;
            case formatType:{
                
            }
                break;
            case floorType:{
                
            }
                break;
            case regionType:{
                
            }
                break;
        }
        [menu.leftTableView reloadData];
    }
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
