//
//  SDD_UpLoadData.m
//  ShopMoreAndMore
//
//  Created by mac on 15/7/4.
//  Copyright (c) 2015年 Mac. All rights reserved.
//
/*
 上传资料界面
 上传图片 职务选择 手机验证 更多新项目信息
 */
#import "SDD_UpLoadData.h"
#import "XHBaseViewController.h"
#import "Header.h"
#import "UserInfo.h"

@interface SDD_UpLoadData ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    NSString * OverallEffectImage;//整体效果图
    NSString * MarketingCenterImage;//营销中心图
    
    NSInteger houseFirstId;
    
    NSTimer * timer;
    int allTime;
    
    
    NSInteger CooperationCell;
    
    UIButton *checkButton;
    
    UIButton * ImageBtn;//第一个按钮
}
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)UITableView *positionTable;
@property (nonatomic ,strong)NSArray     *positionArr;//职位选择

@property (retain,nonatomic)NSMutableArray * totalArray;
@property (retain,nonatomic)NSMutableArray * FirstGroupArray;
@property (retain,nonatomic)NSMutableArray * SecondGroupArray;
@property (retain,nonatomic)NSMutableArray * ThirdGroupArray;

@property (retain,nonatomic)NSMutableArray * TotalArray;//更多界面回传

@end

@implementation SDD_UpLoadData

-(void)viewWillAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi" object:nil];
}
- (void)tongzhi:(NSNotification *)dict{
    _TotalArray = [dict.userInfo objectForKey:@"1"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置定时器
    [self getTime];
    
    allTime = 60;
    
    houseFirstId = 0;
    
    OverallEffectImage = @"";
    MarketingCenterImage = @"";
    
    _TotalArray = [NSMutableArray array];
    
    [HttpRequest getWithPositionURL:SDD_MainURL path:@"/houseFirstCategory/userPostCategorys.do" success:^(id Josn) {
        self.positionArr = [Josn objectForKey:@"data"];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    _FirstGroupArray = [[NSMutableArray alloc] initWithObjects:@"",@"", nil];
    _SecondGroupArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"请选择职务", nil];
    _ThirdGroupArray = [[NSMutableArray alloc] initWithObjects:@"",@"", nil];
    
    // 导航条
    [self setupNav];
    
    [self displayContext];
    
    [self initData];
}

#pragma mark -- 初始化数据
-(void)initData
{
    checkButton = [[UIButton alloc] init];//WithFrame:CGRectMake(220, 16,80, 13)
    [checkButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    checkButton.titleLabel.font = [UIFont systemFontOfSize:12];
    checkButton.tag = 1500;
    [checkButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [checkButton addTarget:self action:@selector(checkClick) forControlEvents:UIControlEventTouchUpInside];
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:commit];
}

- (void)displayContext
{
    positionStr = @"请选择职位";
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [SDDColor colorWithHexString:@"#e5e5e5"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    _positionTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.positionArr.count*44) style:UITableViewStylePlain];
    _positionTable.delegate = self;
    _positionTable.dataSource = self;
    [self.view addSubview:_positionTable];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _positionTable) {
        return 0;
    }
    if (section == 5) {
        return 25;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _positionTable) {
        return 44;
    }
    if (indexPath.section == 1) {
        return 136;
    }
    if (indexPath.section == 5) {
        return 56;
    }
    return 45;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _positionTable) {
        return 1;
    }
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _positionTable) {
        return self.positionArr.count;
    }
    if (section == 2) {
        return _SecondGroupArray.count;
    }
    if (section == 3) {
        return _ThirdGroupArray.count;
    }
    return 1;
}
#pragma mark---表内容
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _positionTable) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellP"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellP"];
        }
        cell.textLabel.text = [self.positionArr[indexPath.row] objectForKey:@"categoryName"];
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
            if (button.tag == 42) {
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            [button addTarget:self action:@selector(upLoadDataClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (indexPath.section == 1) {
            
#pragma mark -- 两个选择图片按钮
            
            SDD_DoubleImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
            if (!cell) {
                cell = [[SDD_DoubleImageViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
            }
            
            for (int i=0; i<2; i++) {
                UIButton *button = (UIButton*)[cell viewWithTag:222+i];
                [button addTarget:self action:@selector(upDataClick:) forControlEvents:UIControlEventTouchUpInside];
                button.backgroundColor = dblueColor;
            }
            CELLSELECTSTYLE
            return cell;
        }
        if (indexPath.section == 2) {
            SDD_CooperationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            if (!cell) {
                cell = [[SDD_CooperationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
            }
            NSArray *nameArr = [NSArray arrayWithObjects:@"联系人:",@"部门:",@"职务", nil];
            NSArray *placeArr = @[@"请输入联系人姓名",@"请输入所在部门",@""];
            
            cell.nameLable.text = nameArr[indexPath.row];
            cell.textField.placeholder = placeArr[indexPath.row];
            
            //cell.textField.frame = CGRectMake(63, 16, 180, 13);
            cell.textField.tag = 10+indexPath.row;
            
            [cell.textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.mas_top).with.offset(8);
                make.left.equalTo(cell.nameLable.mas_right).with.offset(5);
                make.bottom.equalTo(cell.mas_bottom).with.offset(-8);
                make.width.equalTo(@200);
            }];
            
            cell.textField.text = _SecondGroupArray[indexPath.row];
#pragma mark -- 设置通知中心监控textField.text的值得变化
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(textFieldChanged:)
                                                         name:UITextFieldTextDidChangeNotification
                                                       object:cell.textField];
            
            
            
            UIColor *color = [SDDColor colorWithHexString:@"#999999"];
            cell.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入联系人姓名" attributes:@{NSForegroundColorAttributeName: color}];
            
            if (indexPath.row == 1) {
                cell.textField.text = _SecondGroupArray[indexPath.row];
                cell.textField.frame = CGRectMake(50, 16, 180, 13);
                cell.textField.tag = 10+indexPath.row;
                cell.textField.placeholder =placeArr[indexPath.row];
                UIColor *color = [SDDColor colorWithHexString:@"#999999"];
                cell.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入所在部门" attributes:@{NSForegroundColorAttributeName: color}];
            }
            if (indexPath.row == 2) {
                SDD_DetailValueCell *cell  =[tableView dequeueReusableCellWithIdentifier:@"cell23"];
                if (!cell) {
                    cell = [[SDD_DetailValueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell23"];
                }
                cell.nameLable.text = @"职务:";
                //cell.chooseLable.text = positionStr;
                
                cell.chooseLable.text = _SecondGroupArray[indexPath.row];
                
                cell.chooseLable.frame = CGRectMake(230, 16, 60, 13);
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell.textField removeFromSuperview];
                CELLSELECTSTYLE
                return cell;
            }
            CELLSELECTSTYLE
            return cell;
        }
        if (indexPath.section == 4) {
            SDD_DetailValueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
            if (!cell) {
                cell = [[SDD_DetailValueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell4"];
            }
            cell.nameLable.text = @"更多新项目信息:";
            cell.chooseLable.text = @"选填";
            cell.nameLable.frame = CGRectMake(12, 16, 120, 13);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.chooseLable.frame = CGRectMake(230, 16, 60, 13);
            [cell.textField removeFromSuperview];
            [cell.starLable removeFromSuperview];
            CELLSELECTSTYLE
            return cell;
        }
        if (indexPath.section == 3) {
            SDD_CooperationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
            if (!cell) {
                cell = [[SDD_CooperationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell4"];
            }
            cell.nameLable.text = @"手机号:";
            cell.textField.placeholder = @"请输入手机号";
            
            cell.textField.tag = 1110+indexPath.row;
            cell.textField.text = _ThirdGroupArray[indexPath.row];
            
            [cell.textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.mas_top).with.offset(8);
                make.left.equalTo(cell.nameLable.mas_right).with.offset(5);
                make.bottom.equalTo(cell.mas_bottom).with.offset(-8);
                make.width.equalTo(@200);
            }];
            
#pragma mark -- 设置通知中心监控textField.text的值得变化
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(textFieldChanged:)
                                                         name:UITextFieldTextDidChangeNotification
                                                       object:cell.textField];
            
            
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            
            UIColor *color = [SDDColor colorWithHexString:@"#999999"];
            cell.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName: color}];
            if (indexPath.row == 1) {
                cell.nameLable.text = @"验证码";
                cell.textField.placeholder = @"请输入验证码";
                
                cell.textField.tag = 1110+indexPath.row;
                cell.textField.text = _ThirdGroupArray[indexPath.row];
                
                UIColor *color = [SDDColor colorWithHexString:@"#999999"];
                cell.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName: color}];
                
                
                
                [cell addSubview:checkButton];
                
                [checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(cell.mas_top).with.offset(13);
                    make.right.equalTo(cell.mas_right).with.offset(-20);
                    make.width.equalTo(@80);
                    make.height.equalTo(@20);
                }];

                UILabel *line = [[UILabel alloc] init];//WithFrame:CGRectMake(200, 10, 1, 25)
                line.backgroundColor = [SDDColor colorWithHexString:@"#e5e5e5"];
                [cell addSubview:line];
                
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(cell.mas_top).with.offset(10);
                    make.right.equalTo(checkButton.mas_left).with.offset(-10);
                    make.width.equalTo(@1);
                    make.bottom.equalTo(cell.mas_bottom).with.offset(-10);
                }];
                //cell.textField.tag = 1112;
            }
            CELLSELECTSTYLE
            return cell;
        }
        if (indexPath.section == 5) {
            SDD_SaveIssueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell5"];
            if (!cell) {
                cell = [[SDD_SaveIssueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell5"];
            }
            for (int i=0; i<2; i++) {
                UIButton *button = (UIButton*)[cell viewWithTag:333+i];
                [button addTarget:self action:@selector(savaAndIssueClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            cell.backgroundColor = [UIColor clearColor];
            CELLSELECTSTYLE
            return cell;
        }
        
        return cell;
    }
}
#pragma mark----表格点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _positionTable) {
        [bgView removeFromSuperview];
        _positionTable.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.positionArr.count*44);
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        positionStr = cell.textLabel.text;
        [_SecondGroupArray replaceObjectAtIndex:2 withObject:positionStr];
        NSLog(@"_SecondGroupArray=%@",_SecondGroupArray);
        
        [_tableView reloadData];
    }
    else
    {
        if (indexPath.section == 2) {
            if (indexPath.row == 2) {
                [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
                bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44*4)];
                bgView.backgroundColor = [UIColor blackColor];
                bgView.alpha = 0.5;
                [self.view addSubview:bgView];
                _positionTable.frame = CGRectMake(0, self.view.frame.size.height-self.positionArr.count*44, self.view.frame.size.width, self.positionArr.count*44);
                [_positionTable reloadData];
            }
        }
        if (indexPath.section == 4) {
            SDD_MoreInfomation *moreInfoVC = [[SDD_MoreInfomation alloc] init];
            moreInfoVC.BasicArray = _BasicArray;//第一个界面
            moreInfoVC.DetailsArray  = _DetailsArray;//第二个界面
            moreInfoVC.UploadDataArray = _FirstGroupArray;//上传界面上数组
            [self.navigationController pushViewController:moreInfoVC animated:YES];
        }

    }
}
- (void)leftButtonClick:(UIButton*)sender
{
//    UIViewController *vc = [[self.navigationController viewControllers] objectAtIndex:2];
//    [self.navigationController popToViewController:vc animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)lookClick
{
    //PREVIEW
    SDD_Preview *preview = [[SDD_Preview alloc] init];
    preview.BasicArray = _BasicArray;
    preview.DetailsArray = _DetailsArray;
    preview.MorePagesArray = _TotalArray;
    
    preview.UploadDataArray = _FirstGroupArray;
    NSLog(@"%@",preview.UploadDataArray);
    [self.navigationController pushViewController:preview animated:YES];
}

#pragma mark -- UItextFild监控值得变化
-(void)textFieldChanged:(NSNotification *)notification
{
    UITextField *textfield=[notification object];
    //NSLog(@"%@",textfield.text);
    if(textfield.tag == 10)
    {
        [_SecondGroupArray replaceObjectAtIndex:0 withObject:textfield.text];
        NSLog(@"_SecondGroupArray = %@",_SecondGroupArray);
    }
    if (textfield.tag == 11) {
        [_SecondGroupArray replaceObjectAtIndex:1 withObject:textfield.text];
        NSLog(@"_SecondGroupArray = %@",_SecondGroupArray);
    }
    if (textfield.tag == 1110) {
        
        [_ThirdGroupArray replaceObjectAtIndex:0 withObject:textfield.text];
        NSLog(@"%@",_ThirdGroupArray);
        

        
    }
    if (textfield.tag == 1111) {
        
        [_ThirdGroupArray replaceObjectAtIndex:1 withObject:textfield.text];
        NSLog(@"%@",_ThirdGroupArray);
        
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




#pragma mark---点击上传
- (void)upDataClick:(UIButton*)sender
{
    SDD_DoubleImageViewCell *cell = (SDD_DoubleImageViewCell *)sender.superview;
    ImageBtn = (UIButton *)[cell viewWithTag:sender.tag];
    
    UIActionSheet *shotOrAlbums = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册中选择", nil];
    [shotOrAlbums showInView:self.view];
    switch (sender.tag) {
        case 222:
            imageNumber = 0;
            break;
        case 223:
            imageNumber =1;
            break;
        default:
            break;
    }
}
#pragma mark----保存
- (void)savaAndIssueClick:(UIButton *)sender
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"大人!填写“更多新项目信息”更利于通过审核哦!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"继续填写",@"我要发布", nil];
    switch (sender.tag) {
        case 333:
        {

            
            
#pragma mark -- 第一个界面传过来的数组
            NSString * ProjectNameStr = _BasicArray[0];//项目名称
            NSString * developersName = _BasicArray[1];//开发商
            NSString * ProjectAddress = _BasicArray[2];//项目地址
            NSString * ProjectIntroduction = _BasicArray[3];//项目简介
            NSString * Cooperation = _BasicArray[4];//合作方式
            
#pragma mark -- 第二个界面传过来的数组
            //第一组
            NSArray * FirArray = _DetailsArray[0];
            NSString * ReferAverage = FirArray[0];//参考均价
            NSString * ReferRent = FirArray[1];//参考租金
            NSString * MerchantsStateNode = FirArray[2];//招商状态节点
            
            //第二组
            NSArray * SecArray = _DetailsArray[1];
            NSString * OpenedTime = SecArray[0];//开盘时间
            NSString * OpeningTime = SecArray[1];//开业时间
            
            int OpenedTime1 = [[self TimestampConversion:OpeningTime] intValue];
            int OpeningTime1 = [[self TimestampConversion:OpenedTime] intValue];
            
            NSLog(@"%d -- %d",OpenedTime1,OpeningTime1);
            
            //第三组
            NSArray * ThiArray = _DetailsArray[2];
            NSString * PlanningArea = ThiArray[0];//规划面积
            NSString * BuildArea = ThiArray[1];//建设面积
            
            //第四组
            NSArray * fouArray = _DetailsArray[3];
            NSString * PlanningForms = fouArray[0];//规划业态
            NSString * ProjectType = fouArray[1];//项目类型
            
#pragma mark -- 第三个界面//= =
            NSString * OverallEffectImage =_FirstGroupArray[0];//整体效果图
            NSString * MarketingCenterImage=_FirstGroupArray[1] ;//营销中心图
            
            NSString * Contact = _SecondGroupArray[0];//联系人
            NSString * Department = _SecondGroupArray[1];//部门
            NSString * Position = _SecondGroupArray[2];//职务
            
            NSString * phoneStr = _ThirdGroupArray[0];//手机号码
            NSString * codeStr = _ThirdGroupArray[1];//验证码
            
#pragma amrk -- 更多界面的
            int buildingStartTime1 = 0;
            NSString * businessComment = @"";
            NSString * surroundingCompetingProducts = @"";
            NSString * publicRoundRate = @"";
            NSString * greeningRate = @"";
            NSString * volumeRate = @"";
            NSString * propertyAge = @"";
            NSString * groundParkingSpaces = @"";
            NSString * undergroundParkingSpaces = @"";
            
            if (_TotalArray.count>0) {
                NSArray * buiArray = _TotalArray[0];
                NSString * buildingStartTime = buiArray[1];
                buildingStartTime1 = [[self TimestampConversion:buildingStartTime] intValue];//开工时间
                
                NSArray * ComArray = _TotalArray[3];
                businessComment = ComArray[2];
                surroundingCompetingProducts = ComArray[0];
                
                NSArray * rateArray = _TotalArray[1];
                publicRoundRate = [NSString stringWithFormat:@"%@",rateArray[0]];
                greeningRate = [NSString stringWithFormat:@"%@",rateArray[1]];
                volumeRate = [NSString stringWithFormat:@"%@",rateArray[2]];
                
                NSArray * numArray = _TotalArray[2];
                propertyAge = [NSString stringWithFormat:@"%@",numArray[0]];
                groundParkingSpaces = [NSString stringWithFormat:@"%@",numArray[1]];
                undergroundParkingSpaces = [NSString stringWithFormat:@"%@",numArray[2]];
            }
            
            NSDictionary * dict;
            if ([OverallEffectImage isEqualToString:@""]|[MarketingCenterImage isEqualToString:@""]|[Contact isEqualToString:@""]|[Department isEqualToString:@""]|[Position isEqualToString:@""]|[phoneStr isEqualToString:@""]|[codeStr isEqualToString:@""])
            {
                [self showAlert:@"请把信息填写完整"];
            }
            else
            {
                dict =@{
                        @"activityCategoryIds":@[@1],
                        @"address":ProjectAddress,
                        @"buildingArea":@([BuildArea intValue]),
                        @"buildingStartTime":@(buildingStartTime1),
                        @"businessComment":businessComment,
                        @"code":codeStr,
                        @"contacts":Contact,
                        @"defaultImage":OverallEffectImage,
                        @"department":Department,
                        @"developersId":@1,
                        @"developersName":developersName,
                        @"formatAreas":@[@{@"areaCategoryId":@3,@"industryCategoryId":@2},@{@"areaCategoryId":@2,@"industryCategoryId":@1}],
                        
                        @"greeningRate":greeningRate,
                        @"groundParkingSpaces":groundParkingSpaces,
                        @"houseDescription":ProjectIntroduction,
                        @"houseFirstId":@0,
                        @"houseName":ProjectNameStr,
                        @"industryCategoryId":@"",
                        @"industryCategoryIds":@[@4,@5],
                        @"investmentPolicy":@"招商政策",
                        @"mainStoreCategoryId":@1,
                        @"merchantsState":MerchantsStateNode,
                        @"merchantsStatus":@1,
                        @"openedTime":@(OpenedTime1),
                        @"openingTime":@(OpeningTime1),
                        @"phone":phoneStr,
                        @"planArea":@([PlanningArea intValue]),
                        @"planFormat":PlanningForms,
                        @"postCategoryId":@2,
                        @"price":@([ReferAverage intValue]),
                        @"projectCircleCategoryId":@1,
                        @"projectNatureCategoryId":@1,
                        @"properties":@100,
                        @"propertyAge":propertyAge,
                        @"publicRoundRate":publicRoundRate,
                        @"realMapImage":MarketingCenterImage,
                        @"rentPrice":@([ReferRent intValue]),
                        @"surroundingCompetingProducts":surroundingCompetingProducts,
                        @"teamDescription":@"运营团队描述",
                        @"typeCategoryId":@1,
                        @"undergroundParkingSpaces":undergroundParkingSpaces,
                        @"volumeRate":volumeRate
                        };
                
            }
            
            [HttpRequest postWithNewIssueSavaURL:SDD_MainURL path:@"/houseFirst/saveOnly.do" parameter:dict success:^(id Josn) {
                NSLog(@"%@",Josn);
                if ([[Josn objectForKey:@"status"] integerValue] == 1) {
                    houseFirstId = [Josn[@"data"][@"houseFirstId"] integerValue];
                    NSLog(@"%ld",houseFirstId);
                }
                [self showAlert:[Josn objectForKey:@"message"]];
                
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
            }];
        }
            break;
        case 334:
            [alter show];
            break;
        default:
            break;
    }
}
//获取验证 登录状态
#pragma mark----获取验证
- (void)checkClick
{
    NSLog(@"获取验证");
    
    NSString * phoneStr = _ThirdGroupArray[0];
    if ([Tools_F validateMobile:phoneStr]) {
        
        [HttpRequest postWithMobileURL:SDD_MainURL path:@"/sms/user/saveHouseCode.do" parameter:@{@"phone":phoneStr} success:^(id Josn) {
            NSLog(@"----%@",Josn);
            
            [self showAlert:[Josn objectForKey:@"message"]];
            
            //[self getTime];
            if ([[Josn objectForKey:@"status"] intValue] == 1) {
                [checkButton setTitle:@"" forState:UIControlStateNormal];
                [timer setFireDate:[NSDate distantPast]];
                
            }
            
            
        } failure:^(NSError *error) {
            
        }];
        
        
    }
    else {
        [self showAlert:@"请输入正确的手机号码！"];

    }
}
-(void)getTime
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getTimeclick) userInfo:nil repeats:YES];
    [timer setFireDate:[NSDate distantFuture]];
}
-(void)getTimeclick
{
    //NSLog(@"%@",timer);
    allTime --;
    
    if (allTime ==59||allTime == 58) {
        [checkButton setTitle:@"" forState:UIControlStateNormal];
    }
    
    //NSLog(@"%@",timer);
    [checkButton setTitle:[NSString stringWithFormat:@"还剩(%d)",allTime] forState:UIControlStateNormal];
    [checkButton setTintColor:[UIColor grayColor]];
    
    
    if (allTime == 0) {
        [checkButton setTitle:@"重新获取" forState:UIControlStateNormal];
        allTime = 60;
        [timer setFireDate:[NSDate distantFuture]];
    }
    
}
- (void)upLoadDataClick:(UIButton*)button
{
    
    NSLog(@"上传资料界面%ld",button.tag);
}
#pragma mark----发布
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            
#pragma mark -- 第一个界面传过来的数组
            NSString * ProjectNameStr = _BasicArray[0];//项目名称
            NSString * developersName = _BasicArray[1];//开发商
            NSString * ProjectAddress = _BasicArray[2];//项目地址
            NSString * ProjectIntroduction = _BasicArray[3];//项目简介
            NSString * Cooperation = _BasicArray[4];//合作方式
            
#pragma mark -- 第二个界面传过来的数组
            //第一组
            NSArray * FirArray = _DetailsArray[0];
            NSString * ReferAverage = FirArray[0];//参考均价
            NSString * ReferRent = FirArray[1];//参考租金
            NSString * MerchantsStateNode = FirArray[2];//招商状态节点
            
            //第二组
            NSArray * SecArray = _DetailsArray[1];
            NSString * OpenedTime = SecArray[0];//开盘时间
            NSString * OpeningTime = SecArray[1];//开业时间
            
            int OpenedTime1 = [[self TimestampConversion:OpeningTime] intValue];
            int OpeningTime1 = [[self TimestampConversion:OpenedTime] intValue];
            
            NSLog(@"%d -- %d",OpenedTime1,OpeningTime1);
            
            //第三组
            NSArray * ThiArray = _DetailsArray[2];
            NSString * PlanningArea = ThiArray[0];//规划面积
            NSString * BuildArea = ThiArray[1];//建设面积
            
            //第四组
            NSArray * fouArray = _DetailsArray[3];
            NSString * PlanningForms = fouArray[0];//规划业态
            NSString * ProjectType = fouArray[1];//项目类型
            
#pragma mark -- 第三个界面
            NSString * OverallEffectImage = _FirstGroupArray[0];//整体效果图
            NSString * MarketingCenterImage = _FirstGroupArray[1];//营销中心图
            
            NSString * Contact = _SecondGroupArray[0];//联系人
            NSString * Department = _SecondGroupArray[1];//部门
            NSString * Position = _SecondGroupArray[2];//职务
            
            NSString * phoneStr = _ThirdGroupArray[0];//手机号码
            NSString * codeStr = _ThirdGroupArray[1];//验证码
            
#pragma amrk -- 更多界面的
#pragma amrk -- 更多界面的
            int buildingStartTime1 = 0;
            NSString * businessComment = @"";
            NSString * surroundingCompetingProducts = @"";
            NSString * publicRoundRate = @"";
            NSString * greeningRate = @"";
            NSString * volumeRate = @"";
            NSString * propertyAge = @"";
            NSString * groundParkingSpaces = @"";
            NSString * undergroundParkingSpaces = @"";
            
            if (_TotalArray.count>0) {
                NSArray * buiArray = _TotalArray[0];
                NSString * buildingStartTime = buiArray[1];
                buildingStartTime1 = [[self TimestampConversion:buildingStartTime] intValue];//开工时间
                
                NSArray * ComArray = _TotalArray[3];
                businessComment = ComArray[2];
                surroundingCompetingProducts = ComArray[0];
                
                NSArray * rateArray = _TotalArray[1];
                publicRoundRate = [NSString stringWithFormat:@"%@",rateArray[0]];
                greeningRate = [NSString stringWithFormat:@"%@",rateArray[1]];
                volumeRate = [NSString stringWithFormat:@"%@",rateArray[2]];
                
                NSArray * numArray = _TotalArray[2];
                propertyAge = [NSString stringWithFormat:@"%@",numArray[0]];
                groundParkingSpaces = [NSString stringWithFormat:@"%@",numArray[1]];
                undergroundParkingSpaces = [NSString stringWithFormat:@"%@",numArray[2]];
            }
            
            NSDictionary * dict;
            if (houseFirstId == 0) {
                if ([OverallEffectImage isEqualToString:@""]|[MarketingCenterImage isEqualToString:@""]|[Contact isEqualToString:@""]|[Department isEqualToString:@""]|[Position isEqualToString:@""]|[phoneStr isEqualToString:@""]|[codeStr isEqualToString:@""])
                {
                    [self showAlert:@"请把信息填写完整"];
                }
                else
                {
                    dict = @{@"activityCategoryIds":@[@1],
                             @"address":ProjectAddress,
                             @"buildingArea":@([BuildArea intValue]),
                             @"buildingStartTime":@(buildingStartTime1),//开建时间
                             @"businessComment":businessComment,
                             @"code":codeStr,
                             @"contacts":Contact,
                             @"defaultImage":OverallEffectImage,
                             @"department":Department,
                             @"developersId":@0,
                             @"developersName":
                                 developersName,
                             @"formatAreas":@[@{@"areaCategoryId":@3,
                                                @"industryCategoryId":@2},
                                              @{@"areaCategoryId":@2,
                                                @"industryCategoryId":@1}],
                             @"greeningRate":greeningRate,
                             @"groundParkingSpaces":groundParkingSpaces,
                             @"houseDescription":ProjectIntroduction,
                             @"houseFirstId":@0,
                             @"houseName":ProjectNameStr,
                             @"industryCategoryId":@"",
                             @"industryCategoryIds":@[@4,@5],
                             @"investmentPolicy":@"招商政策",
                             @"mainStoreCategoryId":@1,
                             @"merchantsState":MerchantsStateNode,
                             @"merchantsStatus":@1,
                             @"openedTime":@(OpenedTime1),
                             @"openingTime":@(OpeningTime1),
                             @"phone":phoneStr,
                             @"planArea":@([PlanningArea intValue]),
                             @"planFormat":PlanningForms,
                             @"postCategoryId":@2,
                             @"price":@([ReferAverage intValue]),
                             @"projectCircleCategoryId":@1,
                             @"projectNatureCategoryId":@1,
                             @"properties":@100,
                             @"propertyAge":propertyAge,
                             @"publicRoundRate":publicRoundRate,
                             @"realMapImage":MarketingCenterImage,
                             @"rentPrice":@([ReferRent intValue]),
                             @"surroundingCompetingProducts":surroundingCompetingProducts,
                             @"teamDescription":@"运营团队描述",
                             @"typeCategoryId":@1,
                             @"undergroundParkingSpaces":undergroundParkingSpaces,
                             @"volumeRate":volumeRate
                             };
                    
                }
                
            }
            else
            {
                dict = @{@"activityCategoryIds":@[@1],
                         @"address":ProjectAddress,
                         @"buildingArea":@([BuildArea intValue]),
                         @"buildingStartTime":@(buildingStartTime1),//开建时间
                         @"businessComment":businessComment,
                         @"code":codeStr,
                         @"contacts":Contact,
                         @"defaultImage":OverallEffectImage,
                         @"department":Department,
                         @"developersId":@0,
                         @"developersName":
                             developersName,
                         @"formatAreas":@[@{@"areaCategoryId":@3,
                                            @"industryCategoryId":@2},
                                          @{@"areaCategoryId":@2,
                                            @"industryCategoryId":@1}],
                         @"greeningRate":greeningRate,
                         @"groundParkingSpaces":groundParkingSpaces,
                         @"houseDescription":ProjectIntroduction,
                         @"houseFirstId":@(houseFirstId),
                         @"houseName":ProjectNameStr,
                         @"industryCategoryId":@"",
                         @"industryCategoryIds":@[@4,@5],
                         @"investmentPolicy":@"招商政策",
                         @"mainStoreCategoryId":@1,
                         @"merchantsState":MerchantsStateNode,
                         @"merchantsStatus":@1,
                         @"openedTime":@(OpenedTime1),
                         @"openingTime":@(OpeningTime1),
                         @"phone":phoneStr,
                         @"planArea":@([PlanningArea intValue]),
                         @"planFormat":PlanningForms,
                         @"postCategoryId":@2,
                         @"price":@([ReferAverage intValue]),
                         @"projectCircleCategoryId":@1,
                         @"projectNatureCategoryId":@1,
                         @"properties":@100,
                         @"propertyAge":propertyAge,
                         @"publicRoundRate":publicRoundRate,
                         @"realMapImage":MarketingCenterImage,
                         @"rentPrice":@([ReferRent intValue]),
                         @"surroundingCompetingProducts":surroundingCompetingProducts,
                         @"teamDescription":@"运营团队描述",
                         @"typeCategoryId":@1,
                         @"undergroundParkingSpaces":undergroundParkingSpaces,
                         @"volumeRate":volumeRate
                         };
            }
            
            //houseName这个必须不一样
            
            [HttpRequest postWithNewIssueURL:SDD_MainURL path:@"/houseFirst/save.do" parameter:dict success:^(id Josn) {
                NSLog(@"%@--%@",Josn,[Josn objectForKey:@"message"]);
                
                NSLog(@"%@",[Josn objectForKey:@"status"]);
                
//                在登录情况下 并且status = 1 发布成功进行跳转
                if ([[Josn objectForKey:@"status"] integerValue] == 1) {
                    SDD_IssueResult *result = [[SDD_IssueResult alloc] init];
                    [self.navigationController pushViewController:result animated:YES];
                }
                else
                {
                    [self showAlert:[Josn objectForKey:@"message"]];
                }
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
            }];
           
        }
            
            break;
            
        default:
            break;
    }
    if (buttonIndex == 0) {
        SDD_MoreInfomation *moreInfo = [[SDD_MoreInfomation alloc] init];
        [self.navigationController pushViewController:moreInfo animated:YES];
    }
    
}
-(NSString *)TimestampConversion:(NSString *)Times
{
    NSString* timeStr = Times;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    NSDate* date = [formatter dateFromString:timeStr];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    
    NSLog(@"timeSp:%@",timeSp);
    return timeSp;
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"拍照");
            [self pickImageFromCamera];
        }
            break;
        case 1:
        {
            NSLog(@"相册选择");
            [self pickImageFromAlbum];
        }
            break;
        default:
            break;
    }
}
#pragma mark - 从用户相册获取活动图片
- (void)pickImageFromAlbum{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

#pragma mark - 调用摄像机
- (void)pickImageFromCamera{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - 当用户取消选取时调用；
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 当用户选取完成后调用；
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //初始化imageNew为从相机中获得的--
    UIImage *imageNew = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        
        UIImageWriteToSavedPhotosAlbum(imageNew, nil, nil, nil);
    }

    UIImageView *user1 = (UIImageView *)[self.view viewWithTag:111];
    UIImageView *user2 = (UIImageView *)[self.view viewWithTag:112];
    
    
    XHBaseViewController *baseVC = [[XHBaseViewController alloc] init];
    if (imageNumber == 0) {
        user1.image = imageNew;
        [HttpTool uploadWithBaseURL:SDD_MainURL Path:@"/upload/images.do" params:nil dataName:@"images" AlbumImage:imageNew success:^(id responseObject) {
            
            [baseVC hideLoading];
            NSDictionary *dict = responseObject;
            NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
            if (![dict[@"data"] isEqual:[NSNull null]]) {
                OverallEffectImage = dict[@"data"][0];
                
                [ImageBtn setBackgroundImage:imageNew forState:UIControlStateNormal];
                
                [self showSuccessWithText:dict[@"message"]];
                [_FirstGroupArray replaceObjectAtIndex:0 withObject:dict[@"data"][0]];
                NSLog(@"_FirstGroupArray%@",_FirstGroupArray);
                

            }
            
        } fail:^{
            
            [baseVC showErrorWithText:@"上传失败"];
        }];
        imageNumber = 2;
    }
    if (imageNumber == 1) {
        user2.image = imageNew;
        [HttpTool uploadWithBaseURL:SDD_MainURL Path:@"/upload/images.do" params:nil dataName:@"images" AlbumImage:imageNew success:^(id responseObject) {
            
            [baseVC hideLoading];
            NSDictionary *dict = responseObject;
            if (![dict[@"data"] isEqual:[NSNull null]]) {
                MarketingCenterImage = dict[@"data"][0];
                
                [ImageBtn setBackgroundImage:imageNew forState:UIControlStateNormal];
                
                [self showSuccessWithText:dict[@"message"]];
                
                [_FirstGroupArray replaceObjectAtIndex:1 withObject:dict[@"data"][0]];
                NSLog(@"_FirstGroupArray%@",_FirstGroupArray);
                
                
            }
            
        } fail:^{
            
            [baseVC showErrorWithText:@"上传失败"];
        }];
        
        imageNumber = 4;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
