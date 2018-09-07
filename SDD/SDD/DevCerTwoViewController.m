//
//  DevCerTwoViewController.m
//  SDD
//
//  Created by mac on 15/9/22.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "DevCerTwoViewController.h"
#import "DevCerCell.h"
#import "SDD_DoubleImageViewCell.h"
#import "ButtonCell.h"
#import "DevCerModel.h"

@interface DevCerTwoViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>
{
    NSArray * nameArr; //名称
    NSArray * explainArr; //说明
    
    UIButton *checkButton;//验证按钮
    
    int imageNumber;
    
    UIButton * ImageBtn;//第一个按钮
    
    NSTimer * timer;
    int allTime;
    
    NSString * IdCardImageStr; //身份证
    NSString * BusCardImageStr; //名片
    
    NSString * nameStr;//姓名
    NSString * DepartmentStr;//部门
    NSString * positionStr;//职务
    NSInteger  positionId;//职务
    
    NSString * OfficePhoneStr;//办公电话
    NSString * PhoneNumberStr;//手机号码
    NSString * codeStr;//验证码
    
    NSMutableArray * dataArray;//整体输入数据
    
    UIView * maxView;  //大黑View
    UIView * minView;  //大白View
}
@property (retain,nonatomic)UITableView * fristMainTable;//第一个table

@property (retain,nonatomic)UITableView * positionTable;//职务的table
@property (retain,nonatomic)NSMutableArray * positionArray;//职务的数组


@end

@implementation DevCerTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    
    [self setUpNvc];
    [self createMainView];
    [self setInitData];
    [self PositionData];
    
    [self getTime];
     allTime = 60;
   
    
}

-(void)PositionData
{
    _positionArray = [[NSMutableArray alloc] init];
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/houseFirstCategory/userPostCategorys.do" params:nil success:^(id JSON) {
        
        NSLog(@"%@",JSON);
        if (![JSON[@"data"] isEqual:[NSNull null]])
        {
            NSArray * array = JSON[@"data"];
            for (NSDictionary * dic in array)
            {
                DevCerModel * model = [[DevCerModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_positionArray addObject:model];
            }
        }
        [_positionTable reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

#pragma mark -- 初始化数据
-(void)setInitData
{
    nameArr = @[@"姓   名：",@"部   门：",@"职   务：",@"办公电话：",@"手机号码：",@"验 证 码："];
    
    explainArr = @[@"请输入您的姓名",@"请输入所在的部门",@"请选择职务",@"请输入办公电话",@"请输入手机号",@"请输入验证码"];
    
    nameStr = @"";
    DepartmentStr = @"";
    positionStr =@"请选择职务";
    positionId = 0;
    
    OfficePhoneStr = @"";
    PhoneNumberStr = @"";
    codeStr = @"";
    
    IdCardImageStr = @"";
    BusCardImageStr = @"";
    
    dataArray = [[NSMutableArray alloc] initWithObjects:nameStr,DepartmentStr,positionStr,OfficePhoneStr,PhoneNumberStr,codeStr, nil];
}

#pragma mark -- 点击时弹出的view
-(void)createScelView
{
    maxView = [[UIView alloc] initWithFrame:self.view.bounds];
    maxView.backgroundColor = [UIColor blackColor];
    maxView.alpha = 0.7;
    [self.view addSubview:maxView];
    
    minView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight/2, viewWidth, viewHeight/2)];
    minView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:minView];
}

#pragma mark -- 职务View
-(void)IndustryTypeView
{
    [self createScelView];
    
    _positionTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight/2) style:UITableViewStylePlain];
    _positionTable.delegate = self;
    _positionTable.dataSource = self;
    _positionTable.backgroundColor = bgColor;
    [minView addSubview:_positionTable];
}

#pragma mark -- 主table
-(void)createMainView
{
    _fristMainTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _fristMainTable.delegate = self;
    _fristMainTable.dataSource = self;
    _fristMainTable.backgroundColor = bgColor;
    _fristMainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_fristMainTable];
    
    checkButton = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth-100, 16,80, 13)];
    [checkButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    checkButton.titleLabel.font = [UIFont systemFontOfSize:12];
    checkButton.tag = 1500;
    [checkButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [checkButton addTarget:self action:@selector(checkClick) forControlEvents:UIControlEventTouchUpInside];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_fristMainTable == tableView)
    {
        switch (section) {
            case 0:
                return 0.01;
                break;
                
            default:
                return 10;
                break;
        }
        
    }
    else
    {
        return 0.01;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_fristMainTable == tableView)
    {
        switch (indexPath.section) {
            case 2:
            {
                return 135;
            }
                break;
            case 3:
            {
                return 150;
            }
                break;
    
            default:
            {
                return 44;
            }
                break;
        }
    }
    else
    {
        return 44;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _fristMainTable)
    {
        return 4;
    }
    else
    {
        return 1;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _fristMainTable)
    {
        switch (section) {
            case 0:
                return 3;
                break;
            case 1:
                return 3;
                break;
            case 2:
                return 1;
                break;
            default:
                return 1;
                break;
        }
    }
    else
    {
        return _positionArray.count;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _fristMainTable)
    {
        
        static NSString * cellID = @"cellID";
        DevCerCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[DevCerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.textField.hidden = NO;
        cell.starLable.hidden = NO;
        cell.nameLable.hidden = NO;
        cell.chooseLable.hidden = NO;
        
        [cell.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.mas_top).with.offset(8);
            make.left.equalTo(cell.nameLable.mas_right).with.offset(5);
            make.bottom.equalTo(cell.mas_bottom).with.offset(-8);
            make.width.equalTo(@200);
        }];
        switch (indexPath.section) {
            case 0:
            {
                cell.nameLable.text = nameArr[indexPath.row];
                if (indexPath.row < 2) {
                    cell.textField.placeholder = explainArr[indexPath.row];
                    
                    cell.textField.text = dataArray[indexPath.row];
                    
                    cell.textField.tag = indexPath.row+100;
                    [[NSNotificationCenter defaultCenter] addObserver:self
                                                             selector:@selector(textFieldChanged:)
                                                                 name:UITextFieldTextDidChangeNotification
                                                               object:cell.textField];
                }
                else
                {
                    cell.textField.hidden = YES;
                    cell.chooseLable.text = positionStr;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                
            }
                break;
            case 1:
            {
                cell.textField.tag = indexPath.row+200;
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(textFieldChanged:)
                                                             name:UITextFieldTextDidChangeNotification
                                                           object:cell.textField];
                
                cell.nameLable.text = nameArr[indexPath.row+3];
                if (indexPath.row < 2) {
                    cell.textField.placeholder = explainArr[indexPath.row+3];
                    cell.textField.text = dataArray[indexPath.row+3];
                }
                else
                {
                    cell.chooseLable.hidden = YES;
                    cell.textField.backgroundColor = [UIColor whiteColor];
                    cell.textField.placeholder = @"输入验证码";
                    
                    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth-120, 10, 1, 25)];
                    line.backgroundColor = [SDDColor colorWithHexString:@"#e5e5e5"];
                    [cell addSubview:line];
                    
                    [cell addSubview:checkButton];
                }
            }
                break;
            case 2:
            {
                SDD_DoubleImageViewCell *cellBtn = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
                if (!cellBtn) {
                    cellBtn = [[SDD_DoubleImageViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
                }
                cellBtn.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *lableF = (UILabel*)[cellBtn viewWithTag:333];
                UILabel *lableS = (UILabel*)[cellBtn viewWithTag:334];
                
                lableF.text = @"上传身份证照";
                lableS.text = @"上传名片";
                for (int i = 0; i<2; i++) {
                    UIButton *button = (UIButton*)[cellBtn viewWithTag:222+i];
                    [button addTarget:self action:@selector(upDataClick:) forControlEvents:UIControlEventTouchUpInside];
                    button.tag = 1000+i;
                }
                //CELLSELECTSTYLE
                return cellBtn;
            }
                break;
            
            default:
            {
                ButtonCell *cellBtn = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
                if (!cellBtn) {
                    cellBtn = [[ButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
                }
                cellBtn.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cellBtn.label.text = @"隐私声明:\n商多多非常重视对您的个人隐私保护,严格保护您的个人信息的安全.我们使用各种安全技术和程序来保护您的个人信息不被未经授权的访问,使用或泄露。";
                
                UIButton * button = (UIButton *)[cellBtn viewWithTag:1100];
                [button setTitle:@"提交" forState:UIControlStateNormal];
                
                [button addTarget:self action:@selector(commitButton1Click) forControlEvents:UIControlEventTouchUpInside];
                
                cellBtn.backgroundColor = bgColor;
                
                return cellBtn;
            }
                break;
        }
        
        return cell;
    }
    else
    {
        static NSString * cellID = @"cellID";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        DevCerModel * model = _positionArray[indexPath.row];
        cell.textLabel.text = model.categoryName;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _fristMainTable)
    {
        switch (indexPath.section) {
            case 0:
            {
                if (indexPath.row == 2)
                {
                    [self IndustryTypeView];
                }
            }
                break;
                
            default:
                break;
        }
    }
    else
    {
        DevCerModel * model = _positionArray[indexPath.row];
        positionStr = model.categoryName;
        positionId = [model.postCategoryId integerValue];
        
        dataArray = [[NSMutableArray alloc] initWithObjects:nameStr,DepartmentStr,positionStr,OfficePhoneStr,PhoneNumberStr,codeStr, nil];
        
        [_fristMainTable reloadData];
        [maxView removeFromSuperview];
        [minView removeFromSuperview];
        
    }
}

#pragma mark -- UItextFild监控值得变化
-(void)textFieldChanged:(NSNotification *)notification
{
    UITextField *textfield=[notification object];
    switch (textfield.tag) {
        case 100:
            nameStr = textfield.text;
            break;
        case 101:
            DepartmentStr = textfield.text;
            break;
        case 200:
            OfficePhoneStr = textfield.text;
            break;
        case 201:
            PhoneNumberStr = textfield.text;
            break;
        case 202:
            codeStr = textfield.text;
            NSLog(@"%@",codeStr);
            break;
        default:
            break;
    }
    
    dataArray = [[NSMutableArray alloc] initWithObjects:nameStr,DepartmentStr,positionStr,OfficePhoneStr,PhoneNumberStr,codeStr, nil];
    
}

#pragma mark --- 提交
- (void)commitButton1Click
{
    NSLog(@"提交");
    
    NSDictionary *dic = @{@"businessCardImage":BusCardImageStr,
                          @"businessLicense":_licenseImageStr,
                          @"companyAddress":_companyAdds,
                          @"companyDescription":_companyIntro,
                          @"companyImage":_figureImageStr,
                          @"companyName":_companyName,
                          @"deptName":DepartmentStr,
                          @"houseAddress":_projectAdds,
                          @"houseName":_projectName,
                          @"idCardImage":IdCardImageStr,
                          @"industryCategoryId":@(_industryTypeId),
                          @"phone":PhoneNumberStr,
                          @"postCategoryId":@(positionId),
                          @"projectNatureCategoryId":@(_projectNatureId),
                          @"realName":nameStr,
                          @"tel":OfficePhoneStr,
                          @"typeCategoryId":@(_projectTypeId),
                          @"code":codeStr};
    
    NSLog(@"/n%@",dic);
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/houseApprove/user/save.do" params:dic success:^(id JSON) {
        
        
        NSLog(@"%@",JSON);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:JSON[@"message"]
                                                       delegate:self
                                              cancelButtonTitle:@"好"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
        if ([JSON[@"status"] integerValue]==1) {
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark----获取验证
- (void)checkClick
{
    NSLog(@"获取验证");
    [timer setFireDate:[NSDate distantPast]];
    [self requestPhoneData];
}
#pragma mark -- 获取验证码数据下载
-(void)requestPhoneData
{
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/sms/user/sendHouseApproveCode.do" params:@{@"phone":PhoneNumberStr} success:^(id JSON) {
        
        NSLog(@"%@",JSON);
        if ([[NSString stringWithFormat:@"%@",JSON[@"status"]] intValue]==1) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"短信已发送，请在10分钟内输入"
                                                           delegate:self
                                                  cancelButtonTitle:@"好"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:JSON[@"message"]
                                                           delegate:self
                                                  cancelButtonTitle:@"好"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
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
    
    [checkButton setTitle:[NSString stringWithFormat:@"还剩(%d)",allTime] forState:UIControlStateNormal];
    [checkButton setTintColor:[UIColor grayColor]];
    
    
    if (allTime == 0) {
        [checkButton setTitle:@"重新获取(59)" forState:UIControlStateNormal];
        allTime = 60;
        [timer setFireDate:[NSDate distantFuture]];
    }
    
}


#pragma mark---点击上传
- (void)upDataClick:(UIButton*)sender
{
    
    SDD_DoubleImageViewCell *cell = (SDD_DoubleImageViewCell *)sender.superview;
    ImageBtn = (UIButton *)[cell viewWithTag:sender.tag];
    
    
    UIActionSheet *shotOrAlbums = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册中选择", nil];
    [shotOrAlbums showInView:self.view];
    switch (sender.tag) {
        case 1000:
            imageNumber = 0;
            break;
        case 1001:
            imageNumber = 1;
            break;
        default:
            break;
    }
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
    
    [self showLoading:0];
    [HttpTool uploadWithBaseURL:SDD_MainURL Path:@"/upload/images.do" params:nil dataName:@"images" AlbumImage:imageNew success:^(id responseObject) {
        
        [self hideLoading];
        NSDictionary *dict = responseObject;
        NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
        if (![dict[@"data"] isEqual:[NSNull null]]) {
            
            // 0:身份证url 1:名片url 2:营业执照url 3:品牌LOGOurl
            [ImageBtn setBackgroundImage:imageNew forState:UIControlStateNormal];
            
            [self showSuccessWithText:dict[@"message"]];
            switch (imageNumber) {
                case 0:
                    IdCardImageStr = dict[@"data"][0];
                    break;
                case 1:
                    BusCardImageStr = dict[@"data"][0];
                    break;
                default:
                    
                    
                    break;
            }
            NSLog(@"IdCardImageStr-->%@  , BusCardImageStr--->%@",IdCardImageStr,BusCardImageStr);
        }
        
    } fail:^{
        
        [self showErrorWithText:@"上传失败"];
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)setUpNvc
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
}

- (void)leftButtonClick:(UIButton*)sender
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
