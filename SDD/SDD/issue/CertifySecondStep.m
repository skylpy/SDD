//
//  CertifySecondStep.m
//  ShopMoreAndMore
//
//  Created by mac on 15/7/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
///admin/brandCategory/industryFindAll.do 行业类别 

#import "CertifySecondStep.h"
#import "Header.h"
#import "HttpTool.h"
@interface CertifySecondStep ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate>

{
    int  imageNumber;
    
    NSInteger  postCategoryId;//职务ID
    NSString *idCardImage;//身份
    NSString *realName;//姓名
    NSString *deptName;//部门
    NSString *tel;//办公电话
    NSString *businessCardImage;//上传名片
    
    NSString *positionStr;//职务
    UIView *bgView;
    UIView *bgView1;
    NSString  *telPhone;
    
    int controlNum;
    UIButton * conBrandBtn1;
}
@property (retain,nonatomic)NSMutableArray * FirstArray;
@property (retain,nonatomic)NSMutableArray * SecondArray;
@property (retain,nonatomic)NSMutableArray * ThirdArray;

@end

@implementation CertifySecondStep
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
//    if ([self.navigationController viewControllers].count>7) {
//        CertifyFirstStep *certFirst = (CertifyFirstStep*)[[self.navigationController viewControllers] objectAtIndex:7];
//        NSLog(@"asdaqweqwazxczxcqwe%@",certFirst.companyName);
//    }
//    if ([self.navigationController viewControllers].count<5) {
//        CertifyFirstStep *certFirst = [[self.navigationController viewControllers] objectAtIndex:2];
//        NSLog(@"asdaqweqwazxczxcqwe%@",certFirst.companyName);
//    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    controlNum = 0;
    
    _FirstArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"请选择职务",nil];
    _SecondArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"", nil];
    _ThirdArray = [[NSMutableArray alloc] initWithObjects:@"",@"", nil];
    
    
    [self displayContext];
}
- (void)leftButtonClick:(UIButton*)sender
{

    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)displayContext
{
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"发展商认证2/2";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    
    positionStr = @"请选择职务";

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [SDDColor colorWithHexString:@"#e5e5e5"];
    [self.view addSubview:_tableView];
    
    conBrandBtn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [conBrandBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [conBrandBtn1 setBackgroundImage:[Tools_F imageWithColor:dblueColor
                                                        size:CGSizeMake(viewWidth-40, 45)]
                            forState:UIControlStateNormal];
    
    [conBrandBtn1 setBackgroundImage:[Tools_F imageWithColor:[SDDColor colorWithHexString:@"006699"]
                                                        size:CGSizeMake(viewWidth-40, 45)]
                            forState:UIControlStateHighlighted];
    [conBrandBtn1 addTarget:self action:@selector(commitButton1Click) forControlEvents:UIControlEventTouchUpInside];
    [Tools_F setViewlayer:conBrandBtn1 cornerRadius:5 borderWidth:1 borderColor:dblueColor];
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _positionTable) {
        return 1;
    }
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _positionTable){
        return self.positionArr.count;
    }
    if (section == 2||section == 3){
        return 1;
    }
    if (section ==  0) {
        return _FirstArray.count;
    }
    if (section == 1) {
        return _SecondArray.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _positionTable) {
        return 0;
    }
    if (section == 0||section == 3) {
        return 0;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _positionTable) {
        return 44;
    }
    if (indexPath.section == 2) {
        return 135;
    }
    if (indexPath.section == 3) {
        return 180;
    }
    return 45;
}
#pragma mark---表格内容
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _positionTable) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellP"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellP"];
        }
        cell.textLabel.text = [self.positionArr[indexPath.row] objectForKey:@"categoryName"];
        NSLog(@"%@",cell.textLabel.text);
        CELLSELECTSTYLE
        return cell;
    }
    SDD_CooperationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[SDD_CooperationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    
    if (indexPath.section == 0) {
        NSArray *nameArr = [NSArray arrayWithObjects:@"姓名:",@"部门:",@"请输入您的姓名",@"请输入所在部门",@"",@"", nil];
        cell.nameLable.text = nameArr[indexPath.row];
        UIColor *color = [SDDColor colorWithHexString:@"#999999"];
        cell.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:nameArr[indexPath.row+2] attributes:@{NSForegroundColorAttributeName: color}];
        cell.textField.frame = CGRectMake(55, 13, 250, 20);
        cell.textField.delegate = self;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldChanged:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:cell.textField];
        
        if (indexPath.row==0) {
            cell.textField.tag = 1000;
            cell.textField.text = realName;
            
            cell.textField.text = _FirstArray[indexPath.row];
            
            NSLog(@"姓名%@",realName);
        }
        if (indexPath.row == 1) {
            cell.textField.tag = 1001;
            cell.textField.text = deptName;
            
            cell.textField.text = _FirstArray[indexPath.row];
            
            NSLog(@"部门%@",deptName);
        }
        if (indexPath.row == 2) {
            SDD_DetailValueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
            if (!cell) {
                cell = [[SDD_DetailValueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
            }
            cell.nameLable.text = @"职务:";
            cell.chooseLable.text = positionStr;
            
            cell.chooseLable.text = _FirstArray[indexPath.row];
            
            cell.chooseLable.frame = CGRectMake(190, 16, 100, 13);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.textField removeFromSuperview];
            CELLSELECTSTYLE
            return cell;
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            SDD_MoreInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell02"];
            if (!cell) {
                cell = [[SDD_MoreInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell02"];
            }
            cell.nameLabel.text = @"办公电话:";
            UIColor *color = [SDDColor colorWithHexString:@"#999999"];
            cell.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入办公电话" attributes:@{NSForegroundColorAttributeName: color}];
            cell.textField.frame = CGRectMake(70, 16, 200, 13);
            cell.textField.text = tel;
            
            cell.textField.text = _SecondArray[indexPath.row];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(textFieldChanged:)
                                                         name:UITextFieldTextDidChangeNotification
                                                       object:cell.textField];
            
            cell.textField.tag = 1002;
            cell.textField.delegate = self;
            CELLSELECTSTYLE
            return cell;
        }else{
            SDD_CooperationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
            if (!cell) {
                cell = [[SDD_CooperationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell4"];
            }
            cell.nameLable.text = @"手机号:";
            cell.textField.placeholder = @"请输入手机号";
            cell.textField.delegate = self;
            cell.textField.tag = 1003;
            cell.textField.frame = CGRectMake(65, 13, 200, 20);
            
            cell.textField.text = _SecondArray[indexPath.row];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(textFieldChanged:)
                                                         name:UITextFieldTextDidChangeNotification
                                                       object:cell.textField];
            
            UIColor *color = [SDDColor colorWithHexString:@"#999999"];
            cell.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号" attributes:@{NSForegroundColorAttributeName: color}];
            if (indexPath.row == 2) {
                cell.nameLable.text = @"验证码:";
                cell.textField.frame = CGRectMake(65, 13, 200, 20);
                cell.textField.placeholder = @"请输入验证码";
                cell.textField.tag = 1004;
                
                cell.textField.text = _SecondArray[indexPath.row];
                
                UIColor *color = [SDDColor colorWithHexString:@"#999999"];
                cell.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName: color}];
                
                UIButton *checkButton = [[UIButton alloc] initWithFrame:CGRectMake(220, 13,80, 20)];
                [checkButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                checkButton.titleLabel.font = [UIFont systemFontOfSize:12];
                [checkButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [checkButton addTarget:self action:@selector(checkClick) forControlEvents:UIControlEventTouchUpInside];
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
                    make.top.equalTo(cell.mas_top).with.offset(15);
                    make.right.equalTo(checkButton.mas_left).with.offset(-10);
                    make.width.equalTo(@1);
                    make.height.equalTo(@15);
                }];
              
            }
            CELLSELECTSTYLE
            return cell;
        }
        
    }
    if (indexPath.section == 2){
        SDD_DoubleImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        if (!cell) {
            cell = [[SDD_DoubleImageViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
        }
        UILabel *lableF = (UILabel*)[cell viewWithTag:333];
        UILabel *lableS = (UILabel*)[cell viewWithTag:334];
        lableF.text = @"上传身份证照";
        lableS.text = @"上传名片";
        lableF.textAlignment = NSTextAlignmentCenter;
        lableS.textAlignment = NSTextAlignmentCenter;
        for (int i=0; i<2; i++) {
            UIButton *button = (UIButton*)[cell viewWithTag:222+i];
            [button addTarget:self action:@selector(upDataClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        CELLSELECTSTYLE
        return cell;
    }
    if (indexPath.section == 3) {        
        SDD_CertifyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell33"];
        if (!cell) {
            cell = [[SDD_CertifyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell33"];
        }
        cell.backgroundColor = [UIColor clearColor];
//        UIButton *button = (UIButton*)[cell viewWithTag:1111];
//        [button addTarget:self action:@selector(commitButtonClick) forControlEvents:UIControlEventTouchUpInside];
        //cell.backgroundColor = bgColor;
        [conBrandBtn1 setTitle:@"提交" forState:UIControlStateNormal];
        
        [cell.contentView addSubview:conBrandBtn1];
        [conBrandBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.mas_top).with.offset(60);
            make.left.equalTo(cell.mas_left).with.offset(20);
            make.right.equalTo(cell.mas_right).with.offset(-20);
            make.height.equalTo(@45);
        }];
        CELLSELECTSTYLE
        return cell;
    }
    CELLSELECTSTYLE
    return cell;
}
#pragma mark -- 点击表格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _positionTable) {
        
        //_positionTable.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.positionArr.count*44);
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        positionStr = cell.textLabel.text;
        postCategoryId = [[self.positionArr[indexPath.row] objectForKey:@"postCategoryId"] integerValue];
        [self.dataArr  addObject:positionStr];
        [self.dataArr addObject:[NSNumber numberWithInteger:postCategoryId]];
        
        [_FirstArray replaceObjectAtIndex:2 withObject:positionStr];
        [_tableView reloadData];
        [bgView removeFromSuperview];
        [bgView1 removeFromSuperview];

    }
    if (tableView == _tableView)
    {
        if (indexPath.section == 0) {
            if (indexPath.row == 2) {
                bgView = [[UIView alloc] initWithFrame:self.view.bounds];
                bgView.backgroundColor = [UIColor blackColor];
                bgView.alpha = 0.5;
                [self.view addSubview:bgView];
                
                bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight-7*44, viewWidth, 7*44)];
                bgView1.backgroundColor = [UIColor whiteColor];
                [self.view addSubview:bgView1];
                

                _positionArr = [[NSMutableArray alloc] init];
                [HttpRequest getWithPositionURL:SDD_MainURL path:@"/houseFirstCategory/userPostCategorys.do" success:^(id Josn) {
                    
                    _positionArr = [Josn objectForKey:@"data"];
                    NSLog(@"%@",_positionArr);
                    
                    _positionTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 7*44) style:UITableViewStylePlain];
                    _positionTable.delegate = self;
                    _positionTable.dataSource = self;
                    [bgView1 addSubview:_positionTable];
                    
                } failure:^(NSError *error) {
                    NSLog(@"%@",error);
                }];
            }
        }
    }
    
}

#pragma mark -- UItextFild监控值得变化
-(void)textFieldChanged:(NSNotification *)notification
{
    UITextField *textfield=[notification object];

   
    if (textfield.tag == 1000) {
         NSLog(@"%@",textfield.text);
        [_FirstArray replaceObjectAtIndex:0 withObject:textfield.text];
        NSLog(@"_FirstArray=%@",_FirstArray);
    }
    if (textfield.tag == 1001) {
        NSLog(@"%@",textfield.text);
        [_FirstArray replaceObjectAtIndex:1 withObject:textfield.text];
        NSLog(@"_FirstArray=%@",_FirstArray);
    }
    
    if (textfield.tag == 1002) {
        
        NSLog(@"%@",textfield.text);
        
        [_SecondArray replaceObjectAtIndex:0 withObject:textfield.text];
        NSLog(@"%@",_SecondArray);
        
    }
    if (textfield.tag == 1003) {
        
        NSLog(@"%@",textfield.text);
        [_SecondArray replaceObjectAtIndex:1 withObject:textfield.text];
        NSLog(@"%@",_SecondArray);
        
    }
    
    if (textfield.tag == 1004) {
        
        NSLog(@"%@",textfield.text);
        [_SecondArray replaceObjectAtIndex:2 withObject:textfield.text];
        NSLog(@"%@",_SecondArray);
        
    }
    
}


- (void)checkClick
{
    UITextField *tex = (UITextField*)[_tableView viewWithTag:1003];
    telPhone = tex.text;
    [HttpRequest postWithMobileURL:SDD_MainURL path:@"/sms/user/sendHouseApproveCode.do" parameter:@{@"phone":telPhone} success:^(id Josn) {
        NSLog(@"----%@",Josn);
        
        controlNum = 0;
        [self showAlert:@"发送成功，10分钟内有效"];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark --- 提交
- (void)commitButton1Click
{
    NSString * ProName = _FirstArray[0];
    NSString * Department = _FirstArray[1];
    NSString * Position = _FirstArray[2];
    
    NSString * OfficePhone = _SecondArray[0];
    NSString * MobilePhone = _SecondArray[1];
    NSString * Verification = _SecondArray[2];
    
    NSString * picStr1 = _ThirdArray[0];
    NSString * picStr2 = _ThirdArray[1];
    
    
    
    NSLog(@"1 %@ 2 %@ 3 %@ 4 %@ 5 %@ 6 %@ 7 %@ 8 %@",ProName,Department,Position,OfficePhone,MobilePhone,Verification,picStr1,picStr2);
    
    
    if ([ProName isEqualToString:@""]|[Department isEqualToString:@""]|[Position isEqualToString:@"请选择职务"]|[OfficePhone isEqualToString:@""]|[MobilePhone isEqualToString:@""]|[Verification isEqualToString:@""]|[picStr1 isEqualToString:@""]|[picStr2 isEqualToString:@""]) {
        
        [self showAlert:@"请把信息填写完整"];
        
    }
    else
    {
        CertifyFirstStep *certFirst = [[self.navigationController viewControllers] objectAtIndex:2];
        UITextField *realNameText = (UITextField*)[self.tableView viewWithTag:1000];
        realName = realNameText.text;
        UITextField *deatNameText = (UITextField*)[self.tableView viewWithTag:1001];
        deptName = deatNameText.text;
        UITextField *telText = (UITextField*)[self.tableView viewWithTag:1002];
        tel = telText.text;
        NSInteger tels =  [tel integerValue];
        UITextField *tex = (UITextField*)[_tableView viewWithTag:1003];
        telPhone = tex.text;
        UITextField *sureText = (UITextField*)[self.tableView viewWithTag:1004];
        
        NSLog(@"%@%@%ld%ld",certFirst.companyName,certFirst.companyImage,tels,certFirst.industryCategoryId);
        
        //NSString *
        
        
        
        NSDictionary *dict1 = @{@"businessCardImage":businessCardImage,
                              @"businessLicense":certFirst.businessLicense,
                              @"companyAddress":certFirst.companyDescription,
                              @"companyDescription":_companyDescription,
                              @"companyImage":certFirst.companyImage,
                              @"companyName":certFirst.companyName,
                              @"deptName":deptName,
                              @"houseAddress":certFirst.hoseAdress,
                              @"houseName":certFirst.hoseName,
                              @"idCardImage":idCardImage,
                              @"industryCategoryId":[NSNumber numberWithInteger:certFirst.industryCategoryId],
                              @"phone":telPhone,
                              @"postCategoryId":[NSNumber numberWithInteger:postCategoryId],
                              @"projectNatureCategoryId":@(_projectNatureCategoryId),
                              @"realName":realName,
                              @"tel":[NSNumber numberWithInteger:tels],
                              @"typeCategoryId":@(_typeCategoryId),
                              @"code":sureText.text};
        
        NSLog(@"/n%@",dict1);
        
        [HttpRequest postWithCommitSavaURL:SDD_MainURL path:@"/houseApprove/user/save.do" parameter:dict1 success:^(id Josn) {
            NSLog(@"%@",Josn);
            
            if ([[Josn objectForKey:@"status"] integerValue] == 1) {
                controlNum = 1;
                [self showAlert:@"认证成功"];
            }
            else
            {
                controlNum = 0;
                [self showAlert:[Josn objectForKey:@"message"]];
            }
            
            
            
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
        
    }

}

#pragma mark --- 提交
- (void)commitButtonClick
{
//    /houseApprove/user/save.do
    if ([self.navigationController viewControllers].count>7) {
        CertifyFirstStep *certFirst = (CertifyFirstStep*)[[self.navigationController viewControllers] objectAtIndex:7];
        UITextField *realNameText = (UITextField*)[self.tableView viewWithTag:1000];
        realName = realNameText.text;
        UITextField *deatNameText = (UITextField*)[self.tableView viewWithTag:1001];
        deptName = deatNameText.text;
        UITextField *telText = (UITextField*)[self.tableView viewWithTag:1002];
        tel = telText.text;
        NSInteger tels =  [tel integerValue];
        UITextField *tex = (UITextField*)[_tableView viewWithTag:1003];
        telPhone = tex.text;
        UITextField *sureText = (UITextField*)[self.tableView viewWithTag:1004];
        NSLog(@"%@%@%d%ld",certFirst.companyName,certFirst.companyImage,tels,certFirst.industryCategoryId);
        if (![telPhone isEqualToString:@""]&&![sureText.text isEqualToString:@""]&&[businessCardImage isEqualToString:@""]&&[certFirst.businessLicense isEqualToString:@""]&&[certFirst.companyDescription isEqualToString:@""]&&[certFirst.companyImage isEqualToString:@""]&&[certFirst.companyName isEqualToString:@""]&&[deptName isEqualToString:@""]&&[certFirst.hoseAdress isEqualToString:@""]&&[certFirst.hoseName isEqualToString:@""]&&[idCardImage isEqualToString:@""]&&certFirst.industryCategoryId==NULL&&[telPhone isEqualToString:@""]&&[realName isEqualToString:@""]&&certFirst.projectNatureCategoryId==NULL&&certFirst.typeCategoryId==NULL) {
            
            NSDictionary *dic = @{@"businessCardImage":businessCardImage,
                                  @"businessLicense":certFirst.businessLicense,
                                  @"companyAddress":certFirst.companyDescription,
                                  @"companyImage":certFirst.companyImage,
                                  @"companyName":certFirst.companyName,
                                  @"deptName":deptName,
                                  @"houseAddress":certFirst.hoseAdress,
                                  @"houseName":certFirst.hoseName,
                                  @"idCardImage":idCardImage,
                                  @"industryCategoryId":[NSNumber numberWithInt:certFirst.industryCategoryId],
                                  @"phone":telPhone,
                                  @"postCategoryId":[NSNumber numberWithInteger:postCategoryId],
                                  @"projectNatureCategoryId":[NSNumber numberWithInteger:certFirst.projectNatureCategoryId],
                                  @"realName":realName,
                                  @"tel":[NSNumber numberWithInteger:tels],
                                  @"typeCategoryId":[NSNumber numberWithInteger:certFirst.typeCategoryId],
                                  @"code":sureText.text};
            [HttpRequest postWithCommitSavaURL:SDD_MainURL path:@"/houseApprove/user/save.do" parameter:dic success:^(id Josn) {
                NSLog(@"%@",Josn);
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
            }];
            
        }

        NSLog(@"第二界面%@",certFirst.companyName);
    }
    if ([self.navigationController viewControllers].count<5) {
        
        
        NSString * ProName = _FirstArray[0];
        NSString * Department = _FirstArray[1];
        NSString * Position = _FirstArray[2];
        
        NSString * OfficePhone = _SecondArray[0];
        NSString * MobilePhone = _SecondArray[1];
        NSString * Verification = _SecondArray[2];
        
        NSString * picStr1 = _ThirdArray[0];
        NSString * picStr2 = _ThirdArray[1];
        
        NSLog(@"1 %@ 2 %@ 3 %@ 4 %@ 5 %@ 6 %@ 7 %@ 8 %@",ProName,Department,Position,OfficePhone,MobilePhone,Verification,picStr1,picStr2);
        
//        修改之前 上传身份证 上传名片
//         if ([ProName isEqualToString:@""]|[Department isEqualToString:@""]|[Position isEqualToString:@"请选择职务"]|[OfficePhone isEqualToString:@""]|[MobilePhone isEqualToString:@""]|[Verification isEqualToString:@""]|[picStr1 isEqualToString:@""]|[picStr2 isEqualToString:@""]) 
        
//        修改之后上传身份证 上传名片 非必选
        if ([ProName isEqualToString:@""]|[Department isEqualToString:@""]|[Position isEqualToString:@"请选择职务"]|[OfficePhone isEqualToString:@""]|[MobilePhone isEqualToString:@""]|[Verification isEqualToString:@""]) {
            
            [self showAlert:@"请把信息填写完整"];
            
        }
        else
        {
            CertifyFirstStep *certFirst = [[self.navigationController viewControllers] objectAtIndex:2];
            UITextField *realNameText = (UITextField*)[self.tableView viewWithTag:1000];
            realName = realNameText.text;
            UITextField *deatNameText = (UITextField*)[self.tableView viewWithTag:1001];
            deptName = deatNameText.text;
            UITextField *telText = (UITextField*)[self.tableView viewWithTag:1002];
            tel = telText.text;
            NSInteger tels =  [tel integerValue];
            UITextField *tex = (UITextField*)[_tableView viewWithTag:1003];
            telPhone = tex.text;
            UITextField *sureText = (UITextField*)[self.tableView viewWithTag:1004];
            
            NSLog(@"%@%@%ld%ld",certFirst.companyName,certFirst.companyImage,tels,certFirst.industryCategoryId);
            
            NSString * companyName =_dataArray1[0];
            //NSString * companyName =_dataArray1[0];
            
            NSDictionary *dic = @{@"businessCardImage":businessCardImage,
                                  @"businessLicense":certFirst.businessLicense,
                                  @"companyAddress":certFirst.companyDescription,
                                  @"companyDescription":_companyDescription,
                                  @"companyImage":certFirst.companyImage,
                                  @"companyName":companyName,
                                  @"deptName":deptName,
                                  @"houseAddress":certFirst.hoseAdress,
                                  @"houseName":certFirst.hoseName,
                                  @"idCardImage":idCardImage,
                                  @"industryCategoryId":[NSNumber numberWithInteger:certFirst.industryCategoryId],
                                  @"phone":telPhone,
                                  @"postCategoryId":[NSNumber numberWithInteger:postCategoryId],
                                  @"projectNatureCategoryId":[NSNumber numberWithInteger:certFirst.projectNatureCategoryId],
                                  @"realName":realName,
                                  @"tel":[NSNumber numberWithInteger:tels],
                                  @"typeCategoryId":[NSNumber numberWithInteger:certFirst.typeCategoryId],
                                  @"code":sureText.text};
            
            NSLog(@"/n%@",dic);
            
            [HttpRequest postWithCommitSavaURL:SDD_MainURL path:@"/houseApprove/user/save.do" parameter:dic success:^(id Josn) {
                NSLog(@"%@",Josn);
                
                if ([[Josn objectForKey:@"status"] integerValue] == 1) {
                    controlNum = 1;
                    [self showAlert:@"认证成功"];
                }
                else
                {
                    controlNum = 0;
                    [self showAlert:[Josn objectForKey:@"message"]];
                }

                
                
                
            } failure:^(NSError *error) {
                NSLog(@"%@",error);
            }];

        }
        
        
        
//        if (![telPhone isEqualToString:@""]&&![sureText.text isEqualToString:@""]&&[businessCardImage isEqualToString:@""]&&[certFirst.businessLicense isEqualToString:@""]&&[certFirst.companyDescription isEqualToString:@""]&&[certFirst.companyImage isEqualToString:@""]&&[certFirst.companyName isEqualToString:@""]&&[deptName isEqualToString:@""]&&[certFirst.hoseAdress isEqualToString:@""]&&[certFirst.hoseName isEqualToString:@""]&&[idCardImage isEqualToString:@""]&&[NSNumber numberWithInteger:certFirst.industryCategoryId]==NULL&&[telPhone isEqualToString:@""]&&[realName isEqualToString:@""]&&[NSNumber numberWithInteger:postCategoryId]==NULL&&[NSNumber numberWithInteger:certFirst.projectNatureCategoryId]==NULL&&[NSNumber numberWithInteger:tels]==NULL&&[NSNumber numberWithInteger:certFirst.typeCategoryId]==NULL) {
//            
//            
//            
//        }
//
//        NSLog(@"第一界面1%@2%@3%@4%@5%@6%@7%ld8%ld9%ld第二界面",certFirst.companyName,certFirst.companyDescription,certFirst.hoseAdress,certFirst.hoseName,certFirst.companyImage,certFirst.businessLicense,certFirst.industryCategoryId,[NSNumber numberWithInteger:certFirst.projectNatureCategoryId],[NSNumber numberWithInteger:certFirst.typeCategoryId]);
    }
       NSLog(@"提交");
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
    
    if (controlNum == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}


#pragma mark---点击上传
- (void)upDataClick:(UIButton*)sender
{
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
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    //before animation and hiding view
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
                idCardImage = dict[@"data"][0];
                NSLog(@"身份证图片%@",dict[@"data"][0]);
                
                [_ThirdArray replaceObjectAtIndex:0 withObject:dict[@"data"][0]];
                NSLog(@"_ThirdArray%@",_ThirdArray);
                
//                brandImage = dict[@"data"][0];
//                [upLoadImg setBackgroundImage:imageNew forState:UIControlStateNormal];
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
            NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
            if (![dict[@"data"] isEqual:[NSNull null]]) {
                businessCardImage = dict[@"data"][0];
                NSLog(@"上传名片%@",dict[@"data"][0]);
                
                [_ThirdArray replaceObjectAtIndex:1 withObject:dict[@"data"][0]];
                NSLog(@"_ThirdArray%@",_ThirdArray);
                
                
                //                brandImage = dict[@"data"][0];
                //                [upLoadImg setBackgroundImage:imageNew forState:UIControlStateNormal];
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
