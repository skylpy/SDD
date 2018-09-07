//
//  SDD_MoreInfomation.m
//  ShopMoreAndMore
//
//  Created by mac on 15/7/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//
/*
 更多项目信息界面
 */
#import "SDD_MoreInfomation.h"
#import "Header.h"


@interface SDD_MoreInfomation ()
{
    UIView * TransView;
    UIView * SmallView;
    
    NSString *currentMonthString;
    NSString *currentDateString;
    NSString *currentyearString;
    SDDButton *SDDbutton;
}

@property (nonatomic,retain)NSMutableArray * FirstArray;
@property (nonatomic,retain)NSMutableArray * SecondArray;
@property (nonatomic,retain)NSMutableArray * ThirdArray;
@property (nonatomic,retain)NSMutableArray * FourthArray;

@property (nonatomic,retain)UITableView * NatureTableView;
@property (nonatomic,retain)NSMutableArray * NatureArray;

@property (retain,nonatomic) UIPickerView *pickerView;

@property (retain,nonatomic) NSMutableArray * TotalArray;

@end

@implementation SDD_MoreInfomation

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"更多项目信息";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
//    SDDbutton = [[SDDButton alloc]init];
//    SDDbutton.frame = CGRectMake(0, 0, viewWidth*2/3, 44);
//    [SDDbutton setTitle:@"更多项目信息" forState:UIControlStateNormal];
//    [SDDbutton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:SDDbutton];
    
    
    
    _TotalArray = [NSMutableArray array];
    
    _FirstArray = [[NSMutableArray alloc] initWithObjects:@"请选择项目性质",@"请选择开工时间",@"", nil];
    _SecondArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"", nil];
    _ThirdArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"", nil];
    _FourthArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"", nil];
    
    
    
    
    
    _NatureArray = [[NSMutableArray alloc] initWithObjects:@"不限",@"全国品牌",@"区域品牌",@"地方品牌", nil];
    
    [self OptimizeInformation];
    
    [self displayContext];
    [self createTimeSct];
}
//导航条返回键
- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)OptimizeInformation
{
    NSDate *date = [NSDate date];
    
    // Get Current Year
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    
    currentyearString = [NSString stringWithFormat:@"%@",
                         [formatter stringFromDate:date]];
    
    NSLog(@"%@",currentyearString);
    
    // Get Current  Month
    
    [formatter setDateFormat:@"MM"];
    
    currentMonthString = [NSString stringWithFormat:@"%ld",[[formatter stringFromDate:date]integerValue]];
    NSLog(@"%@",currentMonthString);
    
    // Get Current  Date
    
    [formatter setDateFormat:@"dd"];
    currentDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    
    _proYearsStr = currentyearString;
    _proMonthStr = currentMonthString;
    _proDayStr = currentDateString;
    
    _proDayList = [[NSMutableArray alloc]init];
    
    for (int i = 1; i <= 31; i ++) {
        [_proDayList addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    _proMonthList = [[NSMutableArray alloc]init];
    for (int i = 1; i <= 12; i ++) {
        [_proMonthList addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    _proYearsList = [[NSMutableArray alloc] init];
    for (int i = 1970; i <= 2050; i ++) {
        [_proYearsList addObject:[NSString stringWithFormat:@"%d",i]];
    }
}

#pragma mark -- 时间选择器
-(void)createTimeSct
{
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 30, 560/2, 186/2)];
    // 显示选中框
    _pickerView.showsSelectionIndicator=YES;
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    
    [_pickerView selectRow:[currentyearString intValue]-1970 inComponent:0 animated:YES];
    [_pickerView selectRow:[currentMonthString intValue]-1 inComponent:1 animated:YES];
    [_pickerView selectRow:[currentDateString intValue]-1 inComponent:2 animated:YES];
}

- (void)displayContext
{
    UIButton *commit = [[UIButton alloc] init];
    commit.frame = CGRectMake(0, 0, 40, 44);
    commit.titleLabel.font = largeFont;
    [commit setTitle:@"预览" forState:UIControlStateNormal];
    [commit addTarget:self action:@selector(lookClick) forControlEvents:UIControlEventTouchUpInside];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:commit];

    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [SDDColor colorWithHexString:@"#e5e5e5"];
    [self.view addSubview:_tableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == _NatureTableView)
    {
        return 1;
    }
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _NatureTableView) {
        return 0;
    }
    if (section == 0) {
        return 0;
    }
    if (section == 4) {
        return 20;
    }
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _NatureTableView) {
        return _NatureArray.count;
    }
    if (section == 4) {
        return 1;
    }
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _NatureTableView) {
        return 44;
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 2) {
            return 90;
        }
    }
    if (indexPath.section == 4) {
        return 72;
    }
    return 45;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _NatureTableView) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellNa"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellNa"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = _NatureArray[indexPath.row];
        return cell;
    }
    SDD_DetailCell *cell = [[SDD_DetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (!cell) {
        cell = [[SDD_DetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray * textArr = [NSArray arrayWithObjects:@"项目性质",@"开工时间",@"",@"", nil];//,@"请选择项目性质",@"请选择开工时间"
    cell.nameLable.text = textArr[indexPath.row];
    cell.chooseLable.text = _FirstArray[indexPath.row];
    UILabel *label = (UILabel*)[cell viewWithTag:40];
    [label removeFromSuperview];
    cell.chooseLable.textAlignment = NSTextAlignmentRight;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            SDD_MoreInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell02"];
            if (!cell) {
                cell = [[SDD_MoreInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell02"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            
            cell.nameLabel.text = @"产权年限：";
            UIColor *color = [SDDColor colorWithHexString:@"#999999"];
            cell.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入产权年限" attributes:@{NSForegroundColorAttributeName: color}];
            cell.textField.frame = CGRectMake(70, 16, 200, 13);
            cell.textField.tag = 100;
#pragma mark -- 设置通知中心监控textField.text的值得变化
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(textFieldChanged:)
                                                         name:UITextFieldTextDidChangeNotification
                                                       object:cell.textField];
            
            return cell;
        }
    }
    if (indexPath.section == 1) {
        SDD_MoreInfoLvCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell11"];
        if (!cell) {
            cell = [[SDD_MoreInfoLvCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell11"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *textArr = [NSArray arrayWithObjects:@"公摊率:",@"绿化率:",@"容积率:",@"请选择公摊率",@"请选择绿化率",@"请选择容积率", nil];
        cell.nameLabel.text = textArr[indexPath.row];
        UIColor *color = [SDDColor colorWithHexString:@"#999999"];
        cell.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textArr[indexPath.row+3] attributes:@{NSForegroundColorAttributeName: color}];
        cell.textField.tag = indexPath.row+50;
        
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        
#pragma mark -- 设置通知中心监控textField.text的值得变化
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldChanged:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:cell.textField];
        
        return cell;
    }
    if (indexPath.section == 2) {
        SDD_MoreInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (!cell) {
            cell = [[SDD_MoreInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSArray *textArr = [NSArray arrayWithObjects:@"物业数量:",@"地上停车位:",@"地下停车位:",@"请输入物业数量",@"请输入地上停车位",@"请输入地下停车位", nil];
        cell.nameLabel.text = textArr[indexPath.row];
        UIColor *color = [SDDColor colorWithHexString:@"#999999"];
        cell.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textArr[indexPath.row+3] attributes:@{NSForegroundColorAttributeName: color}];
//        if (indexPath.row == 0) {
//            cell.textField.frame = CGRectMake(70, 16, 200, 13);
//        }
        cell.textField.tag = indexPath.row+200;
        
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        
#pragma mark -- 设置通知中心监控textField.text的值得变化
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldChanged:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:cell.textField];
        return cell;
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            SDD_MoreInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
            if (!cell) {
                cell = [[SDD_MoreInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.nameLabel.text = @"周边竞品资料:";
            cell.textField.frame = CGRectMake(110, 16, 200, 13);
            cell.nameLabel.frame = CGRectMake(10, 16, 100, 13);
            UIColor *color = [SDDColor colorWithHexString:@"#999999"];
            cell.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入周边竞品资料" attributes:@{NSForegroundColorAttributeName: color}];
            cell.textField.tag = 250;
            
            
            
#pragma mark -- 设置通知中心监控textField.text的值得变化
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(textFieldChanged:)
                                                         name:UITextFieldTextDidChangeNotification
                                                       object:cell.textField];
            return cell;
        }
        if (indexPath.row == 1) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.nameLable.text = @"周边商户对本项目评价:";
            cell.nameLable.frame = CGRectMake(10, 16, 140, 13);
            [cell.chooseLable removeFromSuperview];
        }
        
        if (indexPath.row == 2) {
            SDD_TextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell32"];
            if (!cell) {
                cell = [[SDD_TextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell32"];
            }
            [cell.label removeFromSuperview];
            cell.textView.frame = CGRectMake(5, 7, 300, 76);
            cell.textView.delegate = self;
            cell.textView.placeholderText = @"请输入周边商户对本项目的评价";
            cell.textView.placeholderColor = [SDDColor colorWithHexString:@"#999999"];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(textViewChanged:)
                                                         name:UITextViewTextDidChangeNotification
                                                       object:cell.textView];
            
            return cell;
        }
    }
    if (indexPath.section == 4) {
        SDD_NextButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell6"];
        if (!cell) {
            cell = [[SDD_NextButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell6"];
        }
        ConfirmButton * conBrandBtn = [[ConfirmButton alloc] initWithFrame:CGRectMake(20, 0, viewWidth-40, 45) title:@"确定" target:self action:@selector(sureClick)];
        conBrandBtn.enabled = YES;
        [cell.contentView addSubview:conBrandBtn];
        
        UIButton *button = (UIButton*)[cell viewWithTag:10];
        UIImageView *image = (UIImageView*)[cell viewWithTag:11];
        UILabel *line = (UILabel*)[cell viewWithTag:12];
        UILabel *lable = (UILabel*)[cell viewWithTag:15];
        UILabel *positionLable = (UILabel*)[cell viewWithTag:16];
        UIButton *positionButton = (UIButton*)[cell viewWithTag:150];
        [positionButton removeFromSuperview];
        [positionLable removeFromSuperview];
        [image removeFromSuperview];
        [line removeFromSuperview];
        [lable removeFromSuperview];
        button.layer.borderColor = [[SDDColor colorWithHexString:@"#e73820"] CGColor];
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = 5;
        [button removeFromSuperview];
        button.titleLabel.font = [UIFont systemFontOfSize:19];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:[SDDColor colorWithHexString:@"#e73820"] forState:UIControlStateNormal];
        [button setBackgroundImage:nil forState:UIControlStateNormal];
        [button addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _NatureTableView) {
        UITableViewCell *cell =  (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [_FirstArray replaceObjectAtIndex:0 withObject:cell.textLabel.text];
        NSLog(@"_FirstArray = %@",_FirstArray);
        
        //[_tableView reloadData];
        [TransView removeFromSuperview];
        [SmallView removeFromSuperview];
        
    }
    if (tableView == _tableView) {
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                [self createView];
            }
            if (indexPath.row == 1) {
                [self createTimeView];
                
            }
        }
    }
    
}

#pragma mark -- UItextFild监控值得变化
-(void)textFieldChanged:(NSNotification *)notification
{
    UITextField *textfield=[notification object];
    if (textfield.tag == 100) {
        NSLog(@"textfield=%@",textfield.text);
        [_FirstArray replaceObjectAtIndex:2 withObject:textfield.text];
        NSLog(@"%@",_FirstArray);
    }
    if (textfield.tag == 50) {
        NSLog(@"textfield=%@",textfield.text);
        [_SecondArray replaceObjectAtIndex:0 withObject:textfield.text];
        NSLog(@"%@",_SecondArray);
    }
    if (textfield.tag == 51) {
        NSLog(@"textfield=%@",textfield.text);
        [_SecondArray replaceObjectAtIndex:1 withObject:textfield.text];
        NSLog(@"%@",_SecondArray);
    }
    if (textfield.tag == 52) {
        NSLog(@"textfield=%@",textfield.text);
        [_SecondArray replaceObjectAtIndex:2 withObject:textfield.text];
        NSLog(@"%@",_SecondArray);
    }
    if (textfield.tag == 200) {
        NSLog(@"textfield=%@",textfield.text);
        [_ThirdArray replaceObjectAtIndex:0 withObject:textfield.text];
        NSLog(@"%@",_ThirdArray);
    }
    if (textfield.tag == 201) {
        NSLog(@"textfield=%@",textfield.text);
        [_ThirdArray replaceObjectAtIndex:1 withObject:textfield.text];
        NSLog(@"%@",_ThirdArray);
    }
    if (textfield.tag == 202) {
        NSLog(@"textfield=%@",textfield.text);
        [_ThirdArray replaceObjectAtIndex:2 withObject:textfield.text];
        NSLog(@"%@",_ThirdArray);
    }
    if (textfield.tag == 250) {
        NSLog(@"textfield=%@",textfield.text);
        [_FourthArray replaceObjectAtIndex:0 withObject:textfield.text];
        NSLog(@"%@",_FourthArray);
    }
    
    
}
-(void)textViewChanged:(NSNotification *)notification
{
    UITextView * textView = [notification object];
    [_FourthArray replaceObjectAtIndex:2 withObject:textView.text];
    NSLog(@"_FourthArray = %@",_FourthArray);
}


#pragma mark -- 实例化时间选择
-(void)createTimeView
{
    TransView = [[UIView alloc] initWithFrame:self.view.bounds];
    TransView.backgroundColor = [UIColor blackColor];
    TransView.alpha = 0.7;
    [self.view addSubview:TransView];
    
    SmallView = [[UIView alloc] initWithFrame:CGRectMake(20, 270/2, 560/2, 460/2)];
    SmallView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SmallView];
    
    [SmallView addSubview:_pickerView];
    
    UILabel * StartingTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(210/2, 15, 140/2, 30/2)];
    StartingTimeLabel.text = @"开工时间";
    [SmallView addSubview:StartingTimeLabel];
    
    
    UIButton * ConfirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ConfirmBtn.frame = CGRectMake(180/2, 370/2, 200/2, 70/2);
    ConfirmBtn.backgroundColor = [UIColor redColor];
    [ConfirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [ConfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ConfirmBtn addTarget:self action:@selector(ConfirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [SmallView addSubview:ConfirmBtn];
}

#pragma mark -- 点击确认
-(void)ConfirmBtnClick
{
    
    
    NSString * DateOfStr = [NSString stringWithFormat:@"%@-%@-%@",_proYearsStr,_proMonthStr,_proDayStr];
    NSLog(@"%@",DateOfStr);
        UILabel * OTLable = (UILabel *)[self.view viewWithTag:100];
        OTLable.text = DateOfStr;
    
    //SDD_DetailCell *cell = (SDD_DetailCell *)[_tableView cellForRowAtIndexPath:currentIndexPath];
    
    [_FirstArray replaceObjectAtIndex:1 withObject:DateOfStr];
    NSLog(@"_FirstArray =%@",_FirstArray);
    
    [_tableView reloadData];
    
    [TransView removeFromSuperview];
    [SmallView removeFromSuperview];
}
// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [_proYearsList count];
    }
    if (component == 1) {
        return [_proMonthList count];
    }
    return [_proDayList count];
}
//每列的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 45;
}
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    //    if (component == 0) {
    //        return 80;
    //    }
    //
    //    if (component == 1) {
    //        return 80;
    //    }
    return 80;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        _proYearsStr = [_proYearsList objectAtIndex:row];
        
    } else if(component == 1){
        _proMonthStr = [_proMonthList objectAtIndex:row];
    }
    else{
        _proDayStr = [_proDayList objectAtIndex:row];
    }
    
    
    NSLog(@"_proYearsStr=%@",_proYearsStr);
    NSLog(@"_proMonthStr=%@",_proMonthStr);
    NSLog(@"_proDayStr=%@",_proDayStr);
    
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [_proYearsList objectAtIndex:row];
    } else if(component == 1){
        return [_proMonthList objectAtIndex:row];
        
    }else
    {
        return [_proDayList objectAtIndex:row];
    }
}


#pragma mark -- 实例化两个视图
-(void)createView
{
    TransView = [[UIView alloc] initWithFrame:self.view.bounds];
    TransView.backgroundColor = [UIColor blackColor];
    TransView.alpha = 0.7;
    [self.view addSubview:TransView];
    
    SmallView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-44*4, self.view.bounds.size.width, 44*4)];
    SmallView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:SmallView];
    
    _NatureTableView = [[UITableView alloc] initWithFrame:SmallView.bounds style:UITableViewStylePlain];
    _NatureTableView.delegate = self;
    _NatureTableView.dataSource = self;
    [SmallView addSubview:_NatureTableView];
}


- (void)leftButtonClick:(UIButton*)sender
{
    UIViewController *vc = [[self.navigationController viewControllers] objectAtIndex:3];
    [self.navigationController popToViewController:vc animated:YES];
}
- (void)lookClick
{
    [_TotalArray addObject:_FirstArray];
    [_TotalArray addObject:_SecondArray];
    [_TotalArray addObject:_ThirdArray];
    [_TotalArray addObject:_FourthArray];
    
    
    //PREVIEW
    SDD_Preview *preview = [[SDD_Preview alloc] init];
    preview.BasicArray = _BasicArray;
    preview.DetailsArray = _DetailsArray;
    preview.MorePagesArray = _TotalArray;
    preview.UploadDataArray = _UploadDataArray;
    [self.navigationController pushViewController:preview animated:YES];
}
//textView键盘下去
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)sureClick
{
//    SDD_UpLoadData * sdd_upVc = [[SDD_UpLoadData alloc] init];
//    sdd_upVc.delegate.friArray = _FirstArray;
    
//    self.delegate.friArray = _FirstArray;
//    self.delegate.secArray = _SecondArray;
//    self.delegate.thrArray = _ThirdArray;
//    self.delegate.fourArray = _FourthArray;
    
//    NSLog(@"_f1%@",self.delegate.friArray);
//    NSLog(@"_f1222%@",_FirstArray);
    
    
    NSMutableArray * dataArray = [NSMutableArray array];
    [dataArray addObject:_FirstArray];
    [dataArray addObject:_SecondArray];
    [dataArray addObject:_ThirdArray];
    [dataArray addObject:_FourthArray];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:dataArray forKey:@"1"];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    //[self.navigationController popViewControllerAnimated:YES];
    
    
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
