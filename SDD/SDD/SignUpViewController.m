//
//  SignUpViewController.m
//  SDD
//
//  Created by mac on 16/1/7.
//  Copyright (c) 2016年 jofly. All rights reserved.
//

#import "SignUpViewController.h"
#import "SDD_TextViewCell.h"
#import "SDD_DetailValueCell.h"
#import "PublicCell.h"
#import "SignUpSuccessViewController.h"
#import "RentShopsModel.h"

@interface SignUpViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIButton *checkButton;
    
    ConfirmButton * conBrandBtn;
    
    NSTimer * timer;
    int allTime;
    NSArray * arr;
    
    UIView * BigView;
    UIView * IndustryView;
    
    int IndustryNum;
    int IndNum;
    
    NSNumber * signupQty;
}
@property (retain,nonatomic)UITableView * tableView;

@property (retain,nonatomic)NSMutableArray * dataArray;

@property (retain,nonatomic)UITableView * IndustryTableView;
@property (retain,nonatomic)NSMutableArray * IndustryArray;

@property (retain,nonatomic)UITableView * IndTableView;
@property (retain,nonatomic)NSMutableArray * IndyArray;

@end

@implementation SignUpViewController

-(void)requestData1{
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/activityForums/detail.do" params:@{@"activityForumsId":_model.activityId} success:^(id JSON) {
        
        NSLog(@"-----%@",JSON);
        if (![JSON[@"data"] isEqual:[NSNull null]]) {
            
            //signupQty = JSON[@"data"][@"activityForums"][@"signupQty"];
            
        }
        [self createView];
        
    } failure:^(NSError *error) {
        
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.‘
    self.view.backgroundColor = bgColor;
    allTime = 60;
    //设置定时器
    [self getTime];
    
    
    IndustryNum = 0;
    IndNum = 0;
    
    //    arr = @[[NSString stringWithFormat:@"%@",_model.title],[NSString stringWithFormat:@"%@",_model.time],[NSString stringWithFormat:@"%@",_model.address]];
    
    arr = @[_str1,_confromTimespStr,_str2];
    NSLog(@"arr%@",arr);
    
    _dataArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"请选择您的行业",@"",@"",@"", nil];
    
    NSLog(@"%@",arr);
    
    [self createNvn];
    
    [self requestIndestData];
    [self requestData1];
}

#pragma mark -- 提交数据下载
-(void)requestData
{
    
    
    NSString * telPhone = _dataArray[4];
    NSString * code = _dataArray[5];
    
    NSString * realName = _dataArray[0];
    NSString * brandName = _dataArray[3];
    
    int peopleQty  = [[NSString stringWithFormat:@"%@",_dataArray[1]] intValue];
    
    //    NSDictionary * dict = @{@"phone":telPhone,
    //                            @"preferentialCategoryId1":@(IndustryNum),
    //                            @"peopleQty":@(peopleQty),
    //                            @"realName":realName,
    //                            @"code":code,
    //                            @"preferentialCategoryId2":@(IndNum),
    //                            @"forumsId":@([[NSString stringWithFormat:@"%@",_model.activityId] intValue]),
    //                            @"brandName":brandName};
    NSDictionary * dict = @{@"phone":telPhone,
                            @"activityForumsId":_model.activityId,
                            @"industryCategoryId":@(IndustryNum),
                            @"brand":brandName,
                            @"peopleQty":@(peopleQty),
                            @"realName":realName,
                            @"code":code};
    
    //@"/forums/addSignup.do"
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/activityShowings/addSignup.do" params:dict success:^(id JSON) {
        
        NSLog(@"%@",JSON);
        //        NSString stringWithFormat:@"%@",JSON[@"status"]intValue
        if ([[NSString stringWithFormat:@"%@",JSON[@"status"]] intValue]==1) {
            [self showAlert:JSON[@"message"]];
            SignUpSuccessViewController * sinUpVc = [[SignUpSuccessViewController alloc] init];
            sinUpVc.dataArray = _dataArray;
            sinUpVc.temDic = _temDic;
            sinUpVc.model = _model;
            self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;
            [self.navigationController pushViewController:sinUpVc animated:YES];
        }
        else
        {
            [self showAlert:JSON[@"message"]];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -- 行业数据下载
-(void)requestIndestData
{
    _IndustryArray = [NSMutableArray array];
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brandCategory/industryAllList.do" params:nil success:^(id JSON) {
        
        NSLog(@"行业数据下载   ***************    %@",JSON);
        NSArray * array = JSON[@"data"];
        for (NSDictionary * dict in array) {
            RentShopsModel * model = [[RentShopsModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [_IndustryArray addObject:model];
        }
        [_IndustryTableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -- 获取验证码数据下载
-(void)requestPhoneData
{
    NSString * telPhone = _dataArray[4];
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/sms/user/sendShowingsSignupCode.do" params:@{@"phone":telPhone} success:^(id JSON) {
        
        NSLog(@"%@",JSON);
        if ([[NSString stringWithFormat:@"%@",JSON[@"status"]] intValue]==1) {
            [self showAlert:@"短信已发送，请在十分钟内输入！"];
        }
        else
        {
            [self showAlert:JSON[@"message"]];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)createView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 50)];
    footView.backgroundColor = bgColor;
    _tableView.tableFooterView = footView;
    
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    topView.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = topView;
    
    UILabel * titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, viewWidth, 20)];
    titleLable.font = [UIFont systemFontOfSize:17];
    titleLable.text = _model.title;
    titleLable.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:titleLable];
    
    NSString * originalString = [NSString stringWithFormat:@"已有%@人报名，报名截止至%@",_temDic[@"activityShowings"][@"signupQty"],[Tools_F timeTransform:[_temDic[@"activityShowings"][@"signupTime"] intValue]  time:dayszw]];
    NSMutableAttributedString * paintString = [[NSMutableAttributedString alloc] initWithString:originalString];
    [paintString addAttribute:NSForegroundColorAttributeName
                        value:tagsColor
                        range:[originalString
                               rangeOfString:[NSString stringWithFormat:@"%@",_temDic[@"activityShowings"][@"signupQty"]]]];
    
    
    UILabel * conLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, viewWidth, 20)];
    conLable.font = titleFont_15;
    conLable.textColor = lgrayColor;
    conLable.attributedText = paintString;
    conLable.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:conLable];
    
    checkButton = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth-100, 16,80, 13)];
    [checkButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    checkButton.titleLabel.font = [UIFont systemFontOfSize:12];
    checkButton.tag = 1500;
    [checkButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [checkButton addTarget:self action:@selector(checkClick) forControlEvents:UIControlEventTouchUpInside];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _IndustryTableView) {
        return 0.01;
    }
    if (tableView == _IndTableView) {
        return 0.01;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        switch (indexPath.section) {
            case 0:
                if (indexPath.row == 2) {
                    return 60;
                }
                else
                {
                    return 44;
                }
                break;
            case 3:
                return 60;
                break;
            default:
                return 44;
                break;
        }
    }
    
    return 40;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _IndustryTableView) {
        return 1;
    }
    if (tableView == _IndTableView) {
        return 1;
    }
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _IndustryTableView) {
        return _IndustryArray.count;
    }
    if (tableView == _IndTableView) {
        return _IndyArray.count;
    }
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 4;
            break;
        case 3:
            return 1;
            break;
        default:
            return 2;
            break;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _IndTableView) {
        static NSString * cellID = @"cellId";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        NSDictionary * dict = _IndyArray[indexPath.row];
        cell.textLabel.text = dict[@"categoryName"];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        return cell;
    }
    if (tableView == _IndustryTableView) {
        
        static NSString * cellID = @"cellId";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        RentShopsModel * model = _IndustryArray[indexPath.row];
        cell.textLabel.text = model.categoryName;
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        return cell;
        
    }
    if (tableView == _tableView) {
        
        switch (indexPath.section) {
            case 0:
            {
                static NSString * cellID = @"cellID1";
                PublicCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
                if (!cell) {
                    cell = [[PublicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                }
                NSArray * titArr = @[@"项目名称:",@"活动时间:",@"活动地点:", ];
                cell.nameLable.text = titArr[indexPath.row];
                if (indexPath.row == 2) {
                    UILabel * linelable =(UILabel *)[cell viewWithTag:100];
                    [linelable removeFromSuperview];
                    cell.chooseLable.numberOfLines = 0;
                }
                cell.chooseLable.textAlignment = NSTextAlignmentLeft;
                
                cell.chooseLable.text = arr[indexPath.row];
                [cell.starLable removeFromSuperview];
                return cell;
            }
                break;
                
                
            case 1:
            {
                static NSString * cellID = @"cellID";
                PublicCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
                if (!cell) {
                    cell = [[PublicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                }
                NSArray * titArr = @[@"姓名:",@"报名人数:",@"行业:",@"品牌:",@"请输入您的真实姓名",@"请输入报名人数",@"",@"请填写您的品牌名称"];
                if (indexPath.row == 2) {
                    [cell.textField removeFromSuperview];
                    //                    cell.chooseLable.text = titArr[indexPath.row+4];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    [cell.starLable removeFromSuperview];
                    cell.chooseLable.textAlignment = NSTextAlignmentRight;
                    cell.chooseLable.text = _dataArray[indexPath.row];
                    
                }
                cell.textField.text = _dataArray[indexPath.row];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.nameLable.text =titArr[indexPath.row];
                cell.nameLable.textAlignment = NSTextAlignmentCenter;
                cell.textField.placeholder = titArr[indexPath.row+4];
                
                cell.textField.tag = 100+indexPath.row;
#pragma mark -- 设置通知中心监控textField.text的值得变化
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(textFieldChanged:)
                                                             name:UITextFieldTextDidChangeNotification
                                                           object:cell.textField];
                if (indexPath.row != 2) {
                    [cell.chooseLable removeFromSuperview];
                    
                }
                
                if (indexPath.row == 3) {
                    UILabel * linelable =(UILabel *)[cell viewWithTag:100];
                    [linelable removeFromSuperview];
                    [cell.starLable removeFromSuperview];
                }
                return cell;
            }
                break;
            case 2:
            {
                static NSString * cellID = @"cellPID";
                PublicCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
                if (!cell) {
                    cell = [[PublicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                }
                NSArray * titArr = @[@"手机号:",@"验证码:",@"请输入你的手机号",@"请输入验证码"];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.nameLable.text =titArr[indexPath.row];
                cell.nameLable.textAlignment = NSTextAlignmentCenter;
                cell.textField.placeholder = titArr[indexPath.row+2];
                [cell.textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(cell.mas_top).with.offset(15);
                    make.left.equalTo(cell.nameLable.mas_right).with.offset(8);
                    make.width.equalTo(@130);
                }];
                cell.textField.tag = 130+indexPath.row;
#pragma mark -- 设置通知中心监控textField.text的值得变化
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(textFieldChanged:)
                                                             name:UITextFieldTextDidChangeNotification
                                                           object:cell.textField];
                
                
                if (indexPath.row == 1) {
                    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth-120, 10, 1, 25)];
                    line.backgroundColor = [SDDColor colorWithHexString:@"#e5e5e5"];
                    [cell addSubview:line];
                    
                    
                    
                    [cell addSubview:checkButton];
                }
                
                
                return cell;
            }
                break;
            default:
            {
                static NSString * cellID = @"cellBId";
                UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                conBrandBtn = [[ConfirmButton alloc] initWithFrame:CGRectMake(20, 7, viewWidth-40, 45) title:@"立即报名" target:self action:@selector(signUpClick:)];
                [cell.contentView addSubview:conBrandBtn];
                return cell;
                
            }
                
                break;
        }
        
    }
    
    
    static NSString * cellID = @"cellId";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

#pragma mark -- cell 的点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        if (indexPath.section == 1) {
            if (indexPath.row == 2) {
                [self createIndustry];
            }
        }
    }
    if (tableView == _IndustryTableView) {
        
        RentShopsModel * model = _IndustryArray[indexPath.row];
        _IndyArray = model.children;
        IndustryNum  = [[NSString stringWithFormat:@"%@",model.industryCategoryId] intValue];
        
        [_IndTableView reloadData];
    }
    if (tableView == _IndTableView) {
        [BigView removeFromSuperview];
        [IndustryView removeFromSuperview];
        NSDictionary * dict = _IndyArray[indexPath.row];
        [_dataArray replaceObjectAtIndex:2 withObject:dict[@"categoryName"]];
        
        IndNum  = [[NSString stringWithFormat:@"%@",dict[@"industryCategoryId"]] intValue];
        [_tableView reloadData];
    }
}

-(void)createIndustry
{
    BigView = [[UIView alloc] initWithFrame:self.view.bounds];
    BigView.alpha = 0.7;
    BigView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:BigView];
    
    IndustryView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight/2, viewWidth, viewHeight/2)];
    IndustryView.backgroundColor = bgColor;
    [self.view addSubview:IndustryView];
    
    _IndustryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth/2-1, viewHeight/2-50) style:UITableViewStylePlain];
    _IndustryTableView.delegate = self;
    _IndustryTableView.dataSource = self;
    [IndustryView addSubview:_IndustryTableView];
    
    _IndTableView = [[UITableView alloc] initWithFrame:CGRectMake(viewWidth/2, 0, viewWidth/2, viewHeight/2-50) style:UITableViewStylePlain];
    
    _IndTableView.delegate = self;
    _IndTableView.dataSource = self;
    [IndustryView addSubview:_IndTableView];
}

#pragma mark -- UItextFild监控值得变化
-(void)textFieldChanged:(NSNotification *)notification
{
    UITextField *textfield=[notification object];
    switch (textfield.tag) {
        case 131:
            if (![textfield.text isEqualToString:@""]) {
                conBrandBtn.enabled = YES;
            }
            if ([textfield.text isEqualToString:@""]) {
                conBrandBtn.enabled = NO;
            }
            [_dataArray replaceObjectAtIndex:5 withObject:textfield.text];
            break;
        case 130:
            [_dataArray replaceObjectAtIndex:4 withObject:textfield.text];
            break;
        case 100:
            [_dataArray replaceObjectAtIndex:0 withObject:textfield.text];
            break;
        case 101:
            [_dataArray replaceObjectAtIndex:1 withObject:textfield.text];
            break;
        case 103:
            [_dataArray replaceObjectAtIndex:3 withObject:textfield.text];
            break;
        default:
            break;
    }
    NSLog(@"%@",_dataArray);
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


#pragma mark --  立即报名按钮
-(void)signUpClick:(UIButton *)Btn
{
    
    
    
    NSLog(@"报名按钮");
    //系统内收键盘监控收键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    //    SignUpSuccessViewController * sinUpVc = [[SignUpSuccessViewController alloc] init];
    //    sinUpVc.dataArray = _dataArray;
    //    sinUpVc.temDic = _temDic;
    //    sinUpVc.actNum = _actNum;
    //
    //
    //    sinUpVc.model = _model;
    //    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;
    //    [self.navigationController pushViewController:sinUpVc animated:YES];
    [self requestData];
    
}


#pragma mark----获取验证
- (void)checkClick
{
    NSLog(@"获取验证");
    [timer setFireDate:[NSDate distantPast]];
    [self requestPhoneData];
    
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
-(void)createNvn
{
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"报名";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
}
- (void)leftButtonClick
{
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
