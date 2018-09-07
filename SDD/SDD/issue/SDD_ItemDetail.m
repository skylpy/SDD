//
//  SDD_ItemDetail.m
//  ShopMoreAndMore
// 项目详情界面
//  Created by mac on 15/7/4.
//  Copyright (c) 2015年 Mac. All rights reserved.
//
/*
 项目详情界面
 状态节点 开盘时间 开业时间 业态面积 项目类型 主力店 项目圈
 */
#import "SDD_ItemDetail.h"
#import "Header.h"
#import "FSDropDownMenu.h"
#import "DevCerCell.h"
#import "UpLoadDataViewController.h"
#import "UpLoadDataViewController.h"

@interface SDD_ItemDetail ()
{
    UITableView   *nodeTable;//招商节点列表
    UITableView   *shopMainTable;//主力店
    UIView       *bgView;
    NSString      *nodeStr;
    NSArray      *shopMainArr;//主力店
    NSString      *shopNameStr;
    UITableView       *mallTable;//商圈
    NSArray         *mallArr;
    NSString     *mallStr;
    UITableView  *table;//业态面积
    
    NSMutableArray *_cellArray;
    /*+ data +*/
    
    NSIndexPath *currentIndexPath;
    
   //主力店进驻
    UIView * MainStoreView;
    UIView * MainStoreMinView;
    UITableView   * MainStoreTableView;//招商节点列表
    //UITableView   *shopMainTable;//主力店
    
    NSString * MainStoreStr;
    NSString * BusinessCircleStr;
    
    //商圈
    UITableView * BusinessCircleListTableView;
    
    //项目类型
    UITableView * ProjectTypeTableView;
    
    //业态面积
    NSMutableString * FormatsOfAreaStr;
    NSString * AreaStr;
    NSString * FormatStr;
    
    UITableView * AreaTableView;
    UITableView * FormatsTableView;
    
    UIView * leftView;
    UIView * rightView;
    
    UILabel * AreaLabel;
    UILabel * FormatsLabel;
    
    UITableView * PlanningFormsTableView;
    
    //项目类型
    UITableView * ProjectType2TableView;
    
    NSString *currentMonthString;
    NSString *currentDateString;
    NSString *currentyearString;
}

//万能数组
@property (retain,nonatomic)NSMutableArray * dataArray;


@property (retain,nonatomic)NSMutableArray * AreaArray;

@property (retain,nonatomic)NSMutableArray * MainStoreArray;

@property (retain,nonatomic) UIPickerView *pickerView;

//定义五个数组
@property(retain,nonatomic)NSMutableArray * totalArray;
@property (retain,nonatomic)NSMutableArray * FirstItemArray;
@property (retain,nonatomic)NSMutableArray * SecondItemArray;
@property (retain,nonatomic)NSMutableArray * ThirdItemArray;
@property (retain,nonatomic)NSMutableArray * FourthItemArray;


@end

@implementation SDD_ItemDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [HttpRequest getWithShopCircleURL:SDD_MainURL path:@"/houseFirstCategory/projectCircleCategorys.do" success:^(id Josn) {
        mallArr = [Josn objectForKey:@"data"];
        NSLog(@"%@----%@",Josn,[Josn objectForKey:@"message"]);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    [HttpRequest getWithMainShopURL:SDD_MainURL path:@"/houseFirstCategory/mainStoreCategorys.do" success:^(id Josn) {
        shopMainArr =  [Josn objectForKey:@"data"];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    MainStoreStr = @"";
    BusinessCircleStr = @"";
    //业态面积
    FormatsOfAreaStr = [NSMutableString string];
    AreaStr = @"";
    FormatStr = @"";
    
    AreaLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 10, 100, 20)];
    FormatsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    // 导航条
    [self setupNav];
    
    [self displayContext];
    nodeStr = @"请选择节点";
    shopNameStr = @"请选择主力店进驻";
    mallStr = @"请选择项目商圈";
    

    
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
    
    
    _FirstItemArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"", nil];
    _SecondItemArray = [[NSMutableArray alloc] initWithObjects:@"请选择开盘时间",@"请选择开业时间", nil];
    _ThirdItemArray = [[NSMutableArray alloc] initWithObjects:@"",@"", nil];
    _FourthItemArray = [[NSMutableArray alloc] initWithObjects: @"请选择",@"请选择", nil];
    
    
    [self createArray];
    
    [self createTimeSct];
    //[self setUpCells];
    
}


-(void)createArray
{
    
    _totalArray = [NSMutableArray array];
    
    [_totalArray addObject:_FirstItemArray];
    [_totalArray addObject:_SecondItemArray];
    [_totalArray addObject:_ThirdItemArray];
    [_totalArray addObject:_FourthItemArray];
}


- (void)setUpCells{
    _cellArray=[[NSMutableArray alloc] init];
   
    for (int i=0; i<2; i++) {
        if (i<2) {
            SDD_DetailCell *stationCell=[[NSBundle mainBundle] loadNibNamed:@"cell2" owner:self options:nil][0];
            [_cellArray addObject:stationCell];
       
        }
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

- (void)setPageAera
{
    
    
    // 内容
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-104) style:UITableViewStyleGrouped];
    table.backgroundColor = bgColor;
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
}


#pragma mark - 设置导航条
- (void)setupNav{
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"项目发布";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    UIButton *commit = [[UIButton alloc] init];
    commit.frame = CGRectMake(0, 0, 40, 44);
    commit.titleLabel.font = largeFont;
    [commit setTitle:@"预览" forState:UIControlStateNormal];
    [commit addTarget:self action:@selector(lookClick) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:commit];
}

#pragma mark ---- 创建列表
- (void)displayContext
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    nodeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 4*44)];
    nodeTable.delegate = self;
    nodeTable.dataSource = self;
    [self.view addSubview:nodeTable];
    shopMainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, shopMainArr.count*44)];
    shopMainTable.delegate = self;
    shopMainTable.dataSource = self;
    [self.view addSubview:shopMainTable];
    mallTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, mallArr.count*44)];
    mallTable.delegate = self;
    mallTable.dataSource = self;
    [self.view addSubview:mallTable];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == ProjectType2TableView) {
        return 1;
    }
    if(tableView == PlanningFormsTableView)
    {
        return 1;
    }
    if (tableView == AreaTableView) {
        return 1;
    }
    if (tableView == FormatsTableView) {
        return 1;
    }
    if (tableView == ProjectTypeTableView) {
        return 1;
        
    }
    if (tableView == BusinessCircleListTableView) {
        return 1;
    }
    if (tableView == MainStoreTableView) {
        return 1;
    }
    
    if (tableView == mallTable) {
        return 1;
    }
    if (tableView == shopMainTable) {
        return 1;
    }
    if (tableView == nodeTable) {
        return 1;
    }
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == ProjectType2TableView) {
        return 0;
    }
    if (tableView == PlanningFormsTableView) {
        return 0;
    }
    if (tableView == AreaTableView) {
        return 0;
    }
    if (tableView == FormatsTableView) {
        return 0;
    }
    if (tableView == ProjectTypeTableView ) {
        return 0;
    }
    if (tableView == BusinessCircleListTableView) {
        return 44;
    }
    if (tableView == MainStoreTableView) {
        return 0;
    }
    if (tableView == mallTable) {
        return 0;
    }
    if (tableView == shopMainTable) {
        return 0;
    }
    if (tableView == nodeTable) {
        return 0;
    }
    if (section == 5) {
        return 20;
    }
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == BusinessCircleListTableView) {
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainStoreMinView.frame.size.width, 44)];
        UILabel * hLable = [[UILabel alloc] initWithFrame:CGRectMake(210/2, 20/2, 140/2, 40/2)];
        hLable.text = @"商圈级别";
        [headerView addSubview:hLable];
        UIImageView * lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 43, 560/2, 1)];
        lineImageView.image = [UIImage imageNamed:@"line"];
        [headerView addSubview:lineImageView];
        
        return headerView;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == ProjectType2TableView) {
        return 44;
    }
    if (tableView == PlanningFormsTableView) {
        return 44;
    }
    if (tableView == AreaTableView) {
        return 44;
    }
    if (tableView == FormatsTableView) {
        return 44;
    }
    if (tableView == ProjectTypeTableView) {
        return 44;
    }
    if (tableView == BusinessCircleListTableView ) {
        return 44;
    }
    if (tableView == MainStoreTableView) {
        return 44;
    }
    if (tableView == mallTable) {
        return 44;
    }
    if (tableView == shopMainTable) {
        return 44;
    }
    if (tableView == nodeTable) {
        return 44;
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 3) {
            return 90;
        }
    }

    if (indexPath.section == 5) {
        return 73;
    }
    return 45;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == ProjectType2TableView) {
        return _AreaArray.count;
    }
    if (tableView == PlanningFormsTableView) {
        return _dataArray.count;
    }
    if (tableView == AreaTableView) {
        return _AreaArray.count;
    }
    if (tableView == FormatsTableView) {
        return _dataArray.count;
    }
    if (tableView == ProjectTypeTableView) {
        return _dataArray.count;
    }
    if (tableView == BusinessCircleListTableView) {
        return _MainStoreArray.count;
    }
    if (tableView == MainStoreTableView) {
        return _MainStoreArray.count;
    }
    if (tableView == mallTable) {
        return mallArr.count;
    }
    if (tableView == shopMainTable) {
        return shopMainArr.count;
    }
    if (tableView == nodeTable) {
        return 4;
    }
    if (section == 1||section == 2||section == 3||section == 4) {
        NSArray * array = [_totalArray objectAtIndex:section-1];
        NSLog(@"%ld",array.count);
        return array.count;
    }
    
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
#pragma mark -- 项目类型
    if(tableView == ProjectType2TableView)
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellPro"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellPro"];
        }
        cell.textLabel.text = [_AreaArray[indexPath.row] objectForKey:@"categoryName"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }
#pragma mark -- 规划业态
    else if(tableView == PlanningFormsTableView)
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellPl"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellPl"];
        }
        cell.textLabel.text = _dataArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }
#pragma mark -- 业态面积左边的tableView
    else if(tableView == AreaTableView)
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellAr"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellAr"];
        }
        cell.textLabel.text = [_AreaArray[indexPath.row] objectForKey:@"categoryName"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }
#pragma MARK -- 业态面积右边的tableView
    else if(tableView == FormatsTableView)
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellFm"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellFm"];
        }
        cell.textLabel.text = [_dataArray[indexPath.row] objectForKey:@"categoryName"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }
#pragma mark -- 项目类型
    else if(tableView == ProjectTypeTableView)
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellPr"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellPr"];
        }
        cell.textLabel.text = [_dataArray[indexPath.row] objectForKey:@"categoryName"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }
    
#pragma mark -- 商圈
    else if(tableView == BusinessCircleListTableView)
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellBu"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellBu"];
        }
        cell.textLabel.text = [_MainStoreArray[indexPath.row] objectForKey:@"categoryName"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }
#pragma mark -- 主力店进驻
    else if (tableView == MainStoreTableView) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellMain"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellMain"];
        }
        cell.textLabel.text = [_MainStoreArray[indexPath.row] objectForKey:@"categoryName"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }
    
    else if (tableView == mallTable) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellM"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellM"];
        }
        cell.textLabel.text = [mallArr[indexPath.row] objectForKey:@"categoryName"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }
    else if (tableView == shopMainTable) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellS"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellS"];
        }
        cell.textLabel.text = [shopMainArr[indexPath.row] objectForKey:@"categoryName"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }
    else if (tableView == nodeTable) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellN"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellN"];
        }
        NSArray *contextArr = [NSArray arrayWithObjects:@"意向登记项目",@"诚意登记项目",@"认租转定项目",@"已开业项目", nil];
        cell.textLabel.text = contextArr[indexPath.row];
        CELLSELECTSTYLE
        return cell;
    }
    else
    {
        SDD_BasicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[SDD_BasicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        for (int i=0; i<3; i++) {
            UIButton *button = (UIButton *)[cell viewWithTag:40+i];
            if (button.tag == 41|button.tag == 40) {
                [button setTitleColor:dblueColor forState:UIControlStateNormal];
            }
            
        }
        if (indexPath.section == 1) {
            DevCerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
            if (!cell) {
                cell = [[DevCerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
            }
            
            [cell.textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.mas_top).with.offset(8);
                make.left.equalTo(cell.nameLable.mas_right).with.offset(5);
                make.bottom.equalTo(cell.mas_bottom).with.offset(-8);
                make.width.equalTo(@160);
            }];
            
            //显示输入的数据
            NSArray * titArray = [_totalArray objectAtIndex:indexPath.section-1];
            
            cell.textField.text = titArray[indexPath.row];
            
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            cell.textField.font = [UIFont systemFontOfSize:13];
            
            cell.textField.tag = indexPath.row+20;
            
#pragma mark -- 设置通知中心监控textField.text的值得变化
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(textFieldChanged:)
                                                         name:UITextFieldTextDidChangeNotification
                                                       object:cell.textField];
            
            
            NSArray *arr = [NSArray arrayWithObjects:@"参考均价:",@"参考租金:",@"元/m²",@"元/m²",@"",@"",@"",@"", nil];
            cell.nameLable.text = arr[indexPath.row];
            cell.chooseLable.text = arr[indexPath.row+2];
            
            
            
            if (indexPath.row == 2) {
                [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
                SDD_DetailValueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell12"];
                if (!cell) {
                    cell = [[SDD_DetailValueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell12"];
                }
                
                
                cell.nameLable.text = @"招商状态节点:";
#pragma mark -- 修改chooseLable
                cell.chooseLable.text = titArray[indexPath.row];
                
                cell.chooseLable.text = nodeStr;
                cell.chooseLable.frame = CGRectMake(210, 16, 80, 13);
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell.textField removeFromSuperview];
                CELLSELECTSTYLE
                return cell;
            }
            CELLSELECTSTYLE
            return cell;
        }
        if (indexPath.section == 2) {
            
            SDD_DetailCell *cell=nil;
            //重用标识符
            NSString *identifier = [NSString stringWithFormat:@"TimeLineCell%d%d",(int)indexPath.section,(int)indexPath.row];
            if (cell == nil) {
                //当不存在的时候用重用标识符生成
                cell = [[SDD_DetailCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
            }
            
            NSArray * titArray = _totalArray[indexPath.section-1];
            
            
            UILabel *label = (UILabel*)[cell viewWithTag:40];
            [label removeFromSuperview];
            NSArray *arr = [NSArray arrayWithObjects:@"开盘时间:",@"开业时间:", nil];
            cell.nameLable.text = arr[indexPath.row];
            cell.chooseLable.text = titArray[indexPath.row];
            cell.chooseLable.tag = indexPath.row+200;
            cell.chooseLable.textAlignment = NSTextAlignmentRight;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            CELLSELECTSTYLE
            return cell;
        }
        if (indexPath.section == 3) {
            SDD_DetailValueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
            if (!cell) {
                cell = [[SDD_DetailValueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
            }
            NSArray *arr = [NSArray arrayWithObjects:@"规划面积:",@"建筑面积:",@"万m²",@"万m²",@"",@"", nil];
            cell.nameLable.text = arr[indexPath.row];
            cell.chooseLable.text = arr[indexPath.row+2];
            cell.chooseLable.textAlignment = NSTextAlignmentRight;
            
            NSArray * titArray = [_totalArray objectAtIndex:indexPath.section-1];
            
#pragma mark -- 设置通知中心监控textField.text的值得变化
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(textFieldChanged:)
                                                         name:UITextFieldTextDidChangeNotification
                                                       object:cell.textField];
            
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            cell.textField.font = [UIFont systemFontOfSize:12];
            
            if (indexPath.row == 0) {
                cell.textField.text = titArray[indexPath.row];
                cell.textField.tag = 50+indexPath.row;
                
            }
            if (indexPath.row == 1) {
                cell.textField.text = titArray[indexPath.row];
                cell.textField.tag = 50+indexPath.row;
                
                
            }
            
            CELLSELECTSTYLE
            return cell;
        }
        if (indexPath.section == 4) {
            SDD_DetailValueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell5"];
            if (!cell) {
                cell = [[SDD_DetailValueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell5"];
            }
            NSArray *arr = [NSArray arrayWithObjects:@"规划业态:",@"项目类型:", nil];
            
            NSArray * titArray = [_totalArray objectAtIndex:indexPath.section-1];
            
            cell.nameLable.text = arr[indexPath.row];
            
#pragma mark -- 修改chooseLable.text
            
            cell.chooseLable.textAlignment = NSTextAlignmentRight;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.textField removeFromSuperview];
            if (indexPath.row == 0) {
                //cell.chooseLable.text = shopNameStr;
                cell.chooseLable.text = titArray[indexPath.row];
            }
            if (indexPath.row == 1) {
                //cell.chooseLable.text = mallStr;
                cell.chooseLable.text = titArray[indexPath.row];
            }
            
            CELLSELECTSTYLE
            return cell;
        }
        if (indexPath.section == 5) {
            SDD_NextButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell6"];
            if (!cell) {
                cell = [[SDD_NextButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell6"];
            }
            ConfirmButton * conBrandBtn = [[ConfirmButton alloc] initWithFrame:CGRectMake(20, 0, viewWidth-40, 45) title:@"下一步" target:self action:@selector(nextButtonClick)];
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
            [button removeFromSuperview];
            
            CELLSELECTSTYLE
            return cell;
        }
        return cell;
    }

}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{

#pragma mark -- 业态面积点击事件
    if(tableView == FormatsTableView)
    {
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = [UIColor blackColor];

    }
    if (tableView == AreaTableView) {
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = [UIColor blackColor];

    }
}

#pragma mark --- 表格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
#pragma mark -- 项目类型
    if(tableView == ProjectType2TableView)
    {
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        [_FourthItemArray replaceObjectAtIndex:1 withObject:cell.textLabel.text];
        NSLog(@"_FourthItemArray = %@",_FourthItemArray);
        [_tableView reloadData];
        [MainStoreView removeFromSuperview];
        [MainStoreMinView removeFromSuperview];
    }
#pragma mark -- 规划业态
    if(tableView == PlanningFormsTableView)
    {
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        [_FourthItemArray replaceObjectAtIndex:0 withObject:cell.textLabel.text];
        NSLog(@"_FourthItemArray = %@",_FourthItemArray);
        [_tableView reloadData];
        [MainStoreView removeFromSuperview];
        [MainStoreMinView removeFromSuperview];
    }
#pragma mark -- 业态面积点击事件
    if(tableView == FormatsTableView)
    {
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = [UIColor redColor];
        
        AreaStr =cell.textLabel.text;
        AreaLabel.text = cell.textLabel.text;
        AreaLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.tag = 181;
        [MainStoreMinView addSubview:AreaLabel];
    }
    if (tableView == AreaTableView) {
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.textLabel.textColor = [UIColor redColor];
        
        FormatStr =cell.textLabel.text;
        FormatsLabel.text = cell.textLabel.text;
        FormatsLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.tag = 180;
        [MainStoreMinView addSubview:FormatsLabel];
    }
#pragma mark -- 项目类型弹出视图点击事件
    if(tableView == ProjectTypeTableView)
    {
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        [_ThirdItemArray replaceObjectAtIndex:3 withObject:cell.textLabel.text];
        NSLog(@"_ThirdItemArray = %@",_ThirdItemArray);
        [_tableView reloadData];
        [MainStoreView removeFromSuperview];
        [MainStoreMinView removeFromSuperview];
    }
    
#pragma mark -- 商圈点击事件
    if(tableView == BusinessCircleListTableView)
    {
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        [_FourthItemArray replaceObjectAtIndex:2 withObject:cell.textLabel.text];
        NSLog(@"_FourthItemArray = %@",_FourthItemArray);
        [_tableView reloadData];
        [MainStoreView removeFromSuperview];
        [MainStoreMinView removeFromSuperview];

    }
#pragma mark -- 主力店点击事件
    if (tableView == MainStoreTableView) {
//        MainStoreStr = @"";
//        BusinessCircleStr = @"";
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        MainStoreStr = cell.textLabel.text;
        [_FourthItemArray replaceObjectAtIndex:1 withObject:MainStoreStr];
        NSLog(@"_FourthItemArray = %@",_FourthItemArray);
        [_tableView reloadData];
        [MainStoreView removeFromSuperview];
        [MainStoreMinView removeFromSuperview];
        
    }
    if (tableView == mallTable) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        mallStr = cell.textLabel.text;
        mallTable.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 4*44);
        [bgView removeFromSuperview];
        [_tableView reloadData];
    }
    if (tableView == nodeTable) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        nodeStr = cell.textLabel.text;
        nodeTable.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 4*44);
        [bgView removeFromSuperview];
        [_tableView reloadData];
        [_FirstItemArray replaceObjectAtIndex:2 withObject:nodeStr];
        NSLog(@"%@",_FirstItemArray);
    }
    if (tableView == shopMainTable) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        shopNameStr = cell.textLabel.text;
        shopMainTable.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 4*44);
        [bgView removeFromSuperview];
        [_tableView reloadData];
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 2) {
            [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationCurve:7];
            [UIView setAnimationDuration:0.1];
            bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44*4)];
            bgView.backgroundColor = [UIColor blackColor];
            bgView.alpha = 0.5;
            [self.view addSubview:bgView];
            nodeTable.frame = CGRectMake(0, self.view.frame.size.height-4*44, self.view.frame.size.width, 4*44);
            [UIView commitAnimations];
            
            SDD_DetailValueCell *cell = (SDD_DetailValueCell *)[_tableView cellForRowAtIndexPath:indexPath];
            [cell.textField resignFirstResponder];
        }
    }
    if (indexPath.section == 2) {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
#pragma mark -- 选择开盘时间数据
        if (indexPath.row == 0) {
            
            currentIndexPath = indexPath;
            
            [self createTimeSelectorWithIndexPath];
            
        }
        else
        {
            currentIndexPath = indexPath;
            
            [self createTimeSelectorWithIndexPath];
        }
       
    }
    if (indexPath.section == 3){
        if (indexPath.row == 2) {
            
            [self createAreaOfFormatsView ];
            [self createAreaOfOormatsDownLoad];
            [self createFrmatsDownLoad];
            
        }
        if (indexPath.row == 3){
            NSLog(@"asdasdas");
            
            [self ProjectTypeView];
            
            [self createTypeShopsDownLoad];
        }
    }
    if (indexPath.section == 4) {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        if (indexPath.row == 0) {
            NSLog(@"规划业态");
           
            [self createPlanningForms];
            
        }
        if (indexPath.row == 1) {
            NSLog(@"项目类型");
            [self createProjectTypeView];
            
            [self createFrmatsDownLoad];
            
        }
    }
}

#pragma mark -- 项目类型视图
-(void)createProjectTypeView
{
    _dataArray = [NSMutableArray array] ;
    
    MainStoreView = [[UIView alloc] initWithFrame:self.view.bounds];
    MainStoreView.backgroundColor = [UIColor blackColor];
    MainStoreView.alpha = 0.7;
    [self.view addSubview:MainStoreView];
    
    MainStoreMinView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight-(630/2+100), self.view.bounds.size.width, 630/2+100)];
    MainStoreMinView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:MainStoreMinView];
    
    ProjectType2TableView = [[UITableView alloc] initWithFrame:MainStoreMinView.bounds style:UITableViewStylePlain];
    ProjectType2TableView.delegate = self;
    ProjectType2TableView.dataSource = self;
    [MainStoreMinView addSubview:ProjectType2TableView];
    
}


#pragma mark -- 规划业态视图
-(void)createPlanningForms
{
    _dataArray = [[NSMutableArray alloc] initWithObjects:@"不限",@"专业市场",@"综合体",@"旅游地产", nil];
    
    MainStoreView = [[UIView alloc] initWithFrame:self.view.bounds];
    MainStoreView.backgroundColor = [UIColor blackColor];
    MainStoreView.alpha = 0.7;
    [self.view addSubview:MainStoreView];
    
    MainStoreMinView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight-(630/2-50), self.view.bounds.size.width,630/2-50 )];
    MainStoreMinView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:MainStoreMinView];
    
    PlanningFormsTableView = [[UITableView alloc] initWithFrame:MainStoreMinView.bounds style:UITableViewStylePlain];
    PlanningFormsTableView.delegate = self;
    PlanningFormsTableView.dataSource = self;
    [MainStoreMinView addSubview:PlanningFormsTableView];
}


#pragma mark -- 业态数据下载
-(void)createFrmatsDownLoad
{
    
    NSString * path = @"/houseCategory/industryCategorys.do";
    
    _AreaArray = [NSMutableArray array];
    [HttpRequest postWithNewIssueURL:SDD_MainURL path:path parameter:nil success:^(id Josn) {
        
        NSDictionary * dict = Josn;
        _AreaArray = dict[@"data"];
        
        NSLog(@"%@",_AreaArray);
        
        [ProjectType2TableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark -- 业态面积数据下载
-(void)createAreaOfOormatsDownLoad
{
    _dataArray = [NSMutableArray array];
    [HttpRequest getWithFomatAeraURL:SDD_MainURL path:@"/houseFirstCategory/areaCategorys.do" success:^(id Josn) {
        NSLog(@"%@",Josn);
        
        NSDictionary * dict = Josn;
        _dataArray = dict[@"data"];
        
        NSLog(@"%@",_dataArray);
        
        [FormatsTableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -- 业态面积视图
-(void)CreateView
{
    MainStoreView = [[UIView alloc] initWithFrame:self.view.bounds];
    MainStoreView.backgroundColor = [UIColor blackColor];
    MainStoreView.alpha = 0.7;
    [self.view addSubview:MainStoreView];
    
    MainStoreMinView = [[UIView alloc] initWithFrame:CGRectMake(0, 272/2, self.view.bounds.size.width, 630/2+50)];
    MainStoreMinView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:MainStoreMinView];
    
   
    
    leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width/2, 630/2-60)];
    leftView.backgroundColor = [UIColor redColor];
    [MainStoreMinView addSubview:leftView];
    
    rightView = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2, 50, self.view.bounds.size.width/2, 630/2-60)];
    rightView.backgroundColor = [UIColor yellowColor];
    [MainStoreMinView addSubview:rightView];
}

-(void)createAreaOfFormatsView
{
    [self CreateView];
    
//    UITableView * AreaTableView;
//    UITableView * FormatsTableView;
    
    FormatsTableView = [[UITableView alloc] initWithFrame:rightView.bounds style:UITableViewStylePlain];
    FormatsTableView.delegate = self;
    FormatsTableView.dataSource = self;
    [rightView addSubview:FormatsTableView];
    
    AreaTableView = [[UITableView alloc] initWithFrame:leftView.bounds style:UITableViewStylePlain];
    AreaTableView.delegate = self;
    AreaTableView.dataSource = self;
    [leftView addSubview:AreaTableView];
    
    NSArray * arrayTit = @[@"重选",@"确定"];
    NSArray * bjArr = @[@"today's headline_frame",@"industry point of view_frame"];
    
    for (int i = 0; i < arrayTit.count; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(20+i*164, 630/2, 112, 34);
        //button.backgroundColor = [UIColor blueColor];
        [button setTitle:arrayTit[i] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:bjArr[i]] forState:UIControlStateNormal];
        button.tag = 100+i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [MainStoreMinView addSubview:button];
        if (button.tag == 100) {
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
    }
    
}
#pragma mark -- 业态面积点击事件
-(void)buttonClick:(UIButton *)btn
{
    if (btn.tag == 101) {
        FormatsOfAreaStr = [NSMutableString stringWithFormat:@"%@/%@",FormatStr,AreaStr];
        
        [_ThirdItemArray replaceObjectAtIndex:2 withObject:FormatsOfAreaStr];
        
        [_tableView reloadData];
        [MainStoreView removeFromSuperview];
        [MainStoreMinView removeFromSuperview];
    }
    if (btn.tag == 100) {
        
    }
}

#pragma mark -- 项目类型数据下载
-(void)createTypeShopsDownLoad
{
    //NSString * url = @"http://192.168.1.234:8180/user_mobile";
    NSString * path = @"/houseCategory/typeCategorys.do";

    _dataArray = [NSMutableArray array] ;
    [HttpRequest postWithNewIssueURL:SDD_MainURL path:path parameter:nil success:^(id Josn) {
        
        NSDictionary * dict = Josn;
        _dataArray = dict[@"data"];
        
        NSLog(@"%@",_dataArray);
        
        [ProjectTypeTableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark -- 项目类型视图
-(void)ProjectTypeView
{
    
    MainStoreView = [[UIView alloc] initWithFrame:self.view.bounds];
    MainStoreView.backgroundColor = [UIColor blackColor];
    MainStoreView.alpha = 0.7;
    [self.view addSubview:MainStoreView];
    
    MainStoreMinView = [[UIView alloc] initWithFrame:CGRectMake(0, 272/2+50, self.view.bounds.size.width, 630/2)];
    MainStoreMinView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:MainStoreMinView];
    
    ProjectTypeTableView = [[UITableView alloc] initWithFrame:MainStoreMinView.bounds style:UITableViewStylePlain];
    ProjectTypeTableView.delegate = self;
    ProjectTypeTableView.dataSource = self;
    [MainStoreMinView addSubview:ProjectTypeTableView];
    
}


#pragma mark -- 商圈列表
-(void)createBusinessCircleList
{
    MainStoreView = [[UIView alloc] initWithFrame:self.view.bounds];
    MainStoreView.backgroundColor = [UIColor blackColor];
    MainStoreView.alpha = 0.7;
    [self.view addSubview:MainStoreView];
    
    MainStoreMinView = [[UIView alloc] initWithFrame:CGRectMake(20, 272/2, 560/2, 450/2)];
    MainStoreMinView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:MainStoreMinView];
    
    BusinessCircleListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainStoreMinView.frame.size.width, MainStoreMinView.frame.size.height) style:UITableViewStylePlain];
    BusinessCircleListTableView.delegate = self;
    BusinessCircleListTableView.dataSource = self;
    [MainStoreMinView addSubview:BusinessCircleListTableView];
    
    
}
#pragma mark -- 商圈列表数据下载
-(void)createBusinessCircleListDownLoad
{
    
    NSString * path = @"/houseFirstCategory/projectCircleCategorys.do";
    
    _MainStoreArray = [NSMutableArray array];
    
    [HttpRequest getWithMainShopURL:SDD_MainURL path:path success:^(id Josn) {
        NSLog(@"%@",Josn);
        _MainStoreArray =  [Josn objectForKey:@"data"];
        NSLog(@"%@",_MainStoreArray);
        
        [BusinessCircleListTableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark -- 主力店数据下载
-(void)createMainStoreDownLoad
{

    NSString * path = @"/houseFirstCategory/mainStoreCategorys.do";
    
    _MainStoreArray = [NSMutableArray array];
    
    [HttpRequest getWithMainShopURL:SDD_MainURL path:path success:^(id Josn) {
        NSLog(@"%@",Josn);
        _MainStoreArray =  [Josn objectForKey:@"data"];
        NSLog(@"%@",_MainStoreArray);
        
        [MainStoreTableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}
///houseFirstCategory/mainStoreCategorys.do

#pragma mark -- mainstore主力店进驻
-(void)createMainStore
{
    MainStoreView = [[UIView alloc] initWithFrame:self.view.bounds];
    MainStoreView.backgroundColor = [UIColor blackColor];
    MainStoreView.alpha = 0.7;
    [self.view addSubview:MainStoreView];
    
    MainStoreMinView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, self.view.bounds.size.height-200)];
    MainStoreMinView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:MainStoreMinView];
    
    MainStoreTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MainStoreMinView.frame.size.width, MainStoreMinView.frame.size.height) style:UITableViewStylePlain];
    MainStoreTableView.delegate = self;
    MainStoreTableView.dataSource = self;
    [MainStoreMinView addSubview:MainStoreTableView];
    
}


#pragma mark -- 创建业态面积视图
-(void)CreateOfArea
{
    
}

#pragma mark -- UITextView监控值得变化
-(void)textViewChanged:(NSNotification *)notification
{
    UITextView *textView=[notification object];
    if (textView.tag == 33) {
        NSLog(@"textView.text = %@",textView.text);
        [_FirstItemArray replaceObjectAtIndex:3 withObject:textView.text];
        NSLog(@"_FirstItemArray=%@",_FirstItemArray);
    }
    if (textView.tag == 40) {
        NSLog(@"textView.text = %@",textView.text);
        [_FourthItemArray replaceObjectAtIndex:0 withObject:textView.text];
         NSLog(@"_FourthItemArray=%@",_FourthItemArray);
    }
    
}


#pragma mark -- UItextFild监控值得变化
-(void)textFieldChanged:(NSNotification *)notification
{
    UITextField *textfield=[notification object];
    //NSLog(@"%@",textfield.text);
    if(textfield.tag == 20)
    {
        
        NSLog(@"textfield=%@",textfield.text);
        [_FirstItemArray replaceObjectAtIndex:0 withObject:textfield.text];
        NSLog(@"%@",_FirstItemArray);
    }
    if (textfield.tag == 21) {
        NSLog(@"textfield=%@",textfield.text);
        [_FirstItemArray replaceObjectAtIndex:1 withObject:textfield.text];
        NSLog(@"%@",_FirstItemArray);
        
    }
    //第三组
    if (textfield.tag == 50) {
        //ProjectAddress = textfield.text;
         NSLog(@"ProjectAddress = %@",textfield.text);
        [_ThirdItemArray replaceObjectAtIndex:0 withObject:textfield.text];
        NSLog(@"_ThirdItemArray = %@",_ThirdItemArray);
    }
    if (textfield.tag == 51) {
        NSLog(@"ProjectAddress = %@",textfield.text);
        [_ThirdItemArray replaceObjectAtIndex:1 withObject:textfield.text];
        NSLog(@"_ThirdItemArray = %@",_ThirdItemArray);
    }
    
    
}


#pragma mark -- 点击开盘时间弹出时间选择器
-(void)createTimeSelectorWithIndexPath{
    
    _TranSparentView = [[UIView alloc] initWithFrame:self.view.bounds];
    _TranSparentView.backgroundColor = [UIColor blackColor];
    _TranSparentView.alpha = 0.7;
    [self.view addSubview:_TranSparentView];
    
    _SmallView = [[UIView alloc] initWithFrame:CGRectMake(viewWidth/2-560/4, 270/2, 560/2, 460/2)];
    _SmallView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_SmallView];
    
    [_SmallView addSubview:_pickerView];
    
    
    UILabel * StartingTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(210/2, 15, 140/2, 30/2)];
    StartingTimeLabel.text = @"开工时间";
    [_SmallView addSubview:StartingTimeLabel];
    
    
    UIButton * ConfirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ConfirmBtn.frame = CGRectMake(180/2, 370/2, 200/2, 70/2);
    ConfirmBtn.backgroundColor = dblueColor;
    [ConfirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [ConfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ConfirmBtn addTarget:self action:@selector(ConfirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_SmallView addSubview:ConfirmBtn];
    
}

#pragma mark -- 点击确认
-(void)ConfirmBtnClick
{
    
    
    NSString * DateOfStr = [NSString stringWithFormat:@"%@-%@-%@",_proYearsStr,_proMonthStr,_proDayStr];
    NSLog(@"%@",DateOfStr);
//    UILabel * OTLable = (UILabel *)[self.view viewWithTag:100];
//    OTLable.text = DateOfStr;
    
    SDD_DetailCell *cell = (SDD_DetailCell *)[_tableView cellForRowAtIndexPath:currentIndexPath];
    
    
    if (cell.chooseLable.tag == 200) {
        
        
        cell.chooseLable.text = DateOfStr;
        [_SecondItemArray replaceObjectAtIndex:0 withObject:DateOfStr];
        NSLog(@"_SecondItemArray =%@",_SecondItemArray);
        
    }
    else
    {
        cell.chooseLable.text = DateOfStr;
        [_SecondItemArray replaceObjectAtIndex:1 withObject:DateOfStr];
        NSLog(@"_SecondItemArray =%@",_SecondItemArray);
        [_tableView reloadData];
    }
    
    [_TranSparentView removeFromSuperview];
    [_SmallView removeFromSuperview];
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



- (void)leftButtonClick:(UIButton*)sender
{
//    UIViewController *vc = [[self.navigationController viewControllers] objectAtIndex:1];
//    [self.navigationController popToViewController:vc animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)lookClick
{
    //PREVIEW;
    SDD_Preview *preview = [[SDD_Preview alloc] init];
    preview.BasicArray = _BasicArray;
    NSLog(@"_totalArray= %@",_totalArray);
    preview.DetailsArray = _totalArray;
    
    [self.navigationController pushViewController:preview animated:YES];
}
#pragma mark -- 下一步按钮
- (void)nextButtonClick
{
    //1
    NSString * averageStr = _FirstItemArray[0];
    NSString * rentStr = _FirstItemArray[1];
    NSString * nodeStr1 = _FirstItemArray[2];
    
    //3
    NSString * planning1Str = _ThirdItemArray[0];
    NSString * buildStr = _ThirdItemArray[1];
    
    //4
    NSString * formatsStr = _FourthItemArray[0];
    NSString * typeStr = _FourthItemArray[1];
    
    
    NSLog(@"_BasicArray=%@",_BasicArray);
    NSLog(@"_totalArray=%@",_totalArray);
    
    
    
    
    if ([averageStr isEqualToString:@""]||[rentStr isEqualToString:@""]||[planning1Str isEqualToString:@""]||[buildStr isEqualToString:@""]||[formatsStr isEqualToString:@"请选择"]||[typeStr isEqualToString:@"请选择"]||[nodeStr1 isEqualToString:@"请选择节点"]) {
        
        [self showAlert:@"请把信息填完整"];
    }
    else
    {
        //UpLoadDataViewController * upVC = [[UpLoadDataViewController alloc] init];
        SDD_UpLoadData *upVC  =[[SDD_UpLoadData alloc] init];
        upVC.BasicArray = _BasicArray;
        upVC.DetailsArray = _totalArray;
        
        [self.navigationController pushViewController:upVC animated:YES];
    }
   
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
    promptAlert =NULL;
}


//textView键盘下去
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)detailButtonClick:(UIButton*)button
{
    NSLog(@"详情界面%ld",button.tag);
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
