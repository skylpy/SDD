//
//  InvestmentTWOViewController.m
//  SDD
//
//  Created by mac on 15/10/15.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "InvestmentTWOViewController.h"
#import "BandMassCell.h"
#import "CategoryCell.h"

@interface InvestmentTWOViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIButton *imgButton;//图片选择
    
    //NSString * merchantsStr;//招商状态
    //NSString * typeStr;     //项目类型
    //NSString * circleStr;   //项目商圈
    
    NSString * projectName; //项目名称
    NSString * developers;  //开发商
    NSString * projectAddress; //项目地址
    NSString * ProjectIntro; //项目简介
    NSString * merchantState; //招商状态
    NSString * ProjectType;   //项目类型
    NSString * ProjectCircle;  //项目商圈
    NSString * BrandInto;     //品牌进驻
    
    NSNumber * merchantStateId;//招商状态
    NSNumber * ProjectTypeId;//招商状态
    NSNumber * ProjectCircleId;//招商状态
    
    NSString * imageStr;  //图片
    
    UIView * view_max;//大view
    UIView * view_min;//小view
}

@property (retain,nonatomic)UITableView * tableView_zs;

@property (retain,nonatomic)UITableView * tableView_state;
@property (retain,nonatomic)UITableView * tableView_type;
@property (retain,nonatomic)UITableView * tableView_circle;

@property (retain,nonatomic)NSMutableArray * stateArray;
@property (retain,nonatomic)NSMutableArray * typeArray;
@property (retain,nonatomic)NSMutableArray * circleArray;
@end

@implementation InvestmentTWOViewController

-(NSMutableArray *)stateArray
{
    if (!_stateArray) {
        _stateArray = [[NSMutableArray alloc] initWithObjects:@"意向登记期",@"意向金收取期",@"转定签约期", nil];
    }
    return _stateArray;
}

-(NSMutableArray *)typeArray
{
    if (!_typeArray) {
        _typeArray = [[NSMutableArray alloc] init];
    }
    return _typeArray;
}

-(NSMutableArray *)circleArray
{
    if (!_circleArray) {
        _circleArray = [[NSMutableArray alloc] init];
    }
    return _circleArray;
}

#pragma 维度数据帅选
-(void)requestData
{
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/houseFirstCategory/projectCircleCategorys.do" params:nil success:^(id JSON) {
        
        NSLog(@"%@",JSON);
        for (NSDictionary * dic in JSON[@"data"]) {
            
            CategoryCell * model = [[CategoryCell alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.circleArray addObject:model];
        }
        [_tableView_circle reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/houseCategory/typeCategorys.do" params:nil success:^(id JSON) {
        
        NSLog(@"%@",JSON);
        for (NSDictionary * dic in JSON[@"data"]) {
            
            CategoryCell * model = [[CategoryCell alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.typeArray addObject:model];
        }
        [_tableView_type reloadData];
        
    } failure:^(NSError *error) {
        
    }];
//
//    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/houseFirstCategory/projectCircleCategorys.do" params:nil success:^(id JSON) {
//        
//    } failure:^(NSError *error) {
//        
//    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    [self setNav:@"我要招商"];
    [self setUpUI];
    
    [self requestData];
    [self initData];
    
    merchantStateId = @0;//招商状态
    ProjectTypeId = @0;//招商状态
    ProjectCircleId = @0;//招商状态
}

#pragma mark -- 初始化数据
-(void)initData
{
    merchantState = @"请选择招商状态";
    ProjectType = @"请选择项目类型";
    ProjectCircle = @"请选择项目商圈";
    
    projectName = @"";
    developers = @"";
    projectAddress = @"";
    ProjectIntro = @"";
    BrandInto = @"";
    
    imageStr = @"";
}


#pragma mark -- 设置UI
-(void)setUpUI
{
    _tableView_zs = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, self.view.bounds.size.height-60) style:UITableViewStyleGrouped];
    _tableView_zs.delegate = self;
    _tableView_zs.dataSource = self;
    _tableView_zs.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView_zs];
    
    
    imgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [imgButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"upload-the-whole-rendering_icon"]] forState:UIControlStateNormal];
    [imgButton addTarget:self action:@selector(uploadImage:) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark -- 上传图片
-(void)uploadImage:(UIButton *)btn
{
    UIActionSheet *shotOrAlbums = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册中选择", nil];
    [shotOrAlbums showInView:self.view];
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
            [imgButton setBackgroundImage:imageNew forState:UIControlStateNormal];
            
            [self showSuccessWithText:dict[@"message"]];
            imageStr = dict[@"data"][0];
            NSLog(@"imageStr%@",imageStr);
        }
        
    } fail:^{
        
        [self showErrorWithText:@"上传失败"];
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (tableView == _tableView_zs) {
        if (section == 0) {
            return 0.01;
        }
        else
        {
            return 10;
        }
    }
    else
    {
        return 0.01;
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView_zs) {
        switch (indexPath.section) {
            case 1:
            {
                return 100;
            }
                break;
            case 2:
            {
                switch (indexPath.row) {
                    case 3:
                    {
                        return 100;
                    }
                        break;
                        
                    default:
                        return 44;
                        break;
                }
            }
                break;
            case 3:
            {
                if (indexPath.row == 1) {
                    return 100;
                }
            }
                break;
            case 4:
                return 100;
                break;
                
            default:
                return 44;
                break;
        }
        return 44;
    }
    else
    {
        return 44;
    }
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _tableView_zs) {
        return 5;
    }
    else
    {
        return 1;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView_zs) {
        switch (section) {
            case 0:
                return 3;
                break;
            case 1:
                return 1;
                break;
            case 2:
                return 4;
                break;
            case 3:
                return 2;
                break;
            default:
                return 1;
                break;
        }
    }
    else if(tableView == _tableView_circle)
    {
        return _circleArray.count;
    }
    else if(tableView == _tableView_type)
    {
        return _typeArray.count;
    }
    else
    {
        return self.stateArray.count;
    }
    
    
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView_zs) {
        static NSString * cellID = @"cellId";
        BandMassCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[BandMassCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView * line = (UIImageView *)[cell viewWithTag:1005];
        cell.textView.hidden = YES;
#pragma mark -- 设置通知中心监控textField.text的值得变化
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldChanged:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:cell.textField];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textViewChanged:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:cell.textView];
        switch (indexPath.section) {
            case 0:
            {
                cell.receiveBtn.hidden = YES;
                cell.starLable.hidden = NO;
                cell.nameLable.hidden = NO;
                cell.textField.hidden = NO;
                cell.chooseLable.hidden = NO;
                cell.backgroundColor = [UIColor whiteColor];
                line.hidden = NO;
                switch (indexPath.row) {
                    case 0:
                    {
                        cell.nameLable.text = @"项目名称：";
                        cell.textField.placeholder = @"请输入您的项目名称";
                        cell.textField.text = projectName;
                        cell.textField.tag = 100;
                    }
                        break;
                    case 1:
                    {
                        cell.nameLable.text = @"开发商：";
                        cell.textField.placeholder = @"请输入开发商";
                        cell.textField.text = developers;
                        cell.textField.tag = 101;
                    }
                        break;
                    case 2:
                    {
                        cell.nameLable.text = @"项目地址：";
                        cell.textField.placeholder = @"请输入项目地址";
                        cell.textField.text = projectAddress;
                        cell.textField.tag = 102;
                    }
                    default:
                    {
                        
                    }
                        break;
                }
            }
                break;
            case 1:
            {
                cell.receiveBtn.hidden = YES;
                
                line.hidden = YES;
                cell.nameLable.text = @"项目简介：";
                cell.textView.hidden = NO;
                cell.textView.text = ProjectIntro;
                cell.textView.tag = 1000;
            }
                
                break;
            case 2:
            {
                cell.receiveBtn.hidden = YES;
                cell.textField.hidden = YES;
                switch (indexPath.row) {
                    case 0:
                    {
                        cell.nameLable.text = @"招商状态：";
                        cell.chooseLable.text = merchantState;
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    }
                        break;
                    case 1:
                    {
                        cell.nameLable.text = @"项目类型：";
                        cell.chooseLable.text = ProjectType;
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    }
                        break;
                    case 2:
                    {
                        cell.nameLable.text = @"项目商圈：";
                        cell.chooseLable.text = ProjectCircle;
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    }
                        break;
                    default:
                    {
                        cell.nameLable.text = @"主力品牌进驻信息：";
                        UIImageView * line = (UIImageView *)[cell viewWithTag:1005];
                        line.hidden = YES;
                        cell.textView.hidden = NO;
                        cell.textView.text = BrandInto;
                        cell.textView.tag = 1001;
                    }
                        break;
                }
                
            }
                break;
            case 3:
            {
                cell.receiveBtn.hidden = YES;
                switch (indexPath.row) {
                    case 0:
                    {
                        cell.nameLable.text = @"例如：项目实景图、业态平面图等";
                        cell.nameLable.textColor = lgrayColor;
                        cell.starLable.hidden = YES;
                    }
                        break;
                        
                    default:
                    {
                        cell.receiveBtn.hidden = YES;
                        cell.starLable.hidden = YES;
                        cell.nameLable.hidden = YES;
                        cell.textField.hidden = YES;
                        cell.chooseLable.hidden = YES;
                        UIImageView * line = (UIImageView *)[cell viewWithTag:1005];
                        line.hidden = YES;
                        
                        imgButton.hidden = NO;
                        [cell addSubview:imgButton];
                        [imgButton mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(cell.mas_top).with.offset(10);
                            make.left.equalTo(cell.mas_left).with.offset(15);
                            make.width.equalTo(@80);
                            make.height.equalTo(@80);
                        }];
                        
                        
                    }
                        break;
                }
                
            }
                break;
            case 4:
            {
                cell.receiveBtn.hidden = NO;
                cell.starLable.hidden = YES;
                cell.nameLable.hidden = YES;
                cell.textField.hidden = YES;
                cell.chooseLable.hidden = YES;
                
                cell.backgroundColor = bgColor;
                [cell.receiveBtn setTitle:@"提交" forState:UIControlStateNormal];
                [cell.receiveBtn addTarget:self action:@selector(receiveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            default:
            {
                
            }
                break;
        }
        return cell;
    }
    else if (tableView == _tableView_type)
    {
        static NSString * cellID = @"cellId_t";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        CategoryCell * model = _typeArray[indexPath.row];
        cell.textLabel.text = model.categoryName;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }
    else if (tableView == _tableView_state)
    {
        static NSString * cellID = @"cellId_S";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        cell.textLabel.text = self.stateArray[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }
    else
    {
        static NSString * cellID = @"cellId_c";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        CategoryCell * model = _circleArray[indexPath.row];
        cell.textLabel.text = model.categoryName;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (tableView == _tableView_zs) {
        if (indexPath.section == 2) {
            
            switch (indexPath.row) {
                case 0:
                {
                    [self initStateTable];
                }
                    break;
                case 1:
                {
                    [self initTypeTable];
                }
                    break;
                    
                default:
                {
                    [self initCircleTable];
                }
                    break;
            }
            
        }
    }
    else if(tableView == _tableView_circle)
    {
        [view_max removeFromSuperview];
        [view_min removeFromSuperview];
        CategoryCell * model = _circleArray[indexPath.row];
        ProjectCircle =model.categoryName;
        ProjectCircleId = model.projectCircleCategoryId;
        [_tableView_zs reloadData];
    }
    else if(tableView == _tableView_type)
    {
        [view_max removeFromSuperview];
        [view_min removeFromSuperview];
        CategoryCell * model = _typeArray[indexPath.row];
        ProjectType =model.categoryName;
        ProjectTypeId = model.typeCategoryId;
        [_tableView_zs reloadData];
    }
    else if(tableView == _tableView_state)
    {
        [view_max removeFromSuperview];
        [view_min removeFromSuperview];
        merchantStateId =  [NSNumber numberWithInteger:indexPath.row + 1] ;
        merchantState =self.stateArray[indexPath.row];
        [_tableView_zs reloadData];
    }
    
}
#pragma mark -- 状态
-(void)initStateTable
{
    view_max = [[UIView alloc] initWithFrame:self.view.bounds];
    view_max.backgroundColor = [UIColor blackColor];
    view_max.alpha = 0.7;
    [self.view addSubview:view_max];
    
    UIGestureRecognizer * tap_g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap_gClick:)];
    [view_max addGestureRecognizer:tap_g];
    
    view_min = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight/2, viewWidth, viewHeight/2)];
    view_min.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view_min];
    
    _tableView_state = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight/2) style:UITableViewStylePlain];
    _tableView_state.delegate = self;
    _tableView_state.dataSource = self;
    [view_min addSubview:_tableView_state];
    
}
#pragma mark -- 类型
-(void)initTypeTable
{
    view_max = [[UIView alloc] initWithFrame:self.view.bounds];
    view_max.backgroundColor = [UIColor blackColor];
    view_max.alpha = 0.7;
    [self.view addSubview:view_max];
    
    UIGestureRecognizer * tap_g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap_gClick:)];
    [view_max addGestureRecognizer:tap_g];
    
    view_min = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight/2, viewWidth, viewHeight/2)];
    view_min.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view_min];
    
    _tableView_type = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight/2) style:UITableViewStylePlain];
    _tableView_type.delegate = self;
    _tableView_type.dataSource = self;
    [view_min addSubview:_tableView_type];
    
}
#pragma mark -- 商圈
-(void)initCircleTable
{
    view_max = [[UIView alloc] initWithFrame:self.view.bounds];
    view_max.backgroundColor = [UIColor blackColor];
    view_max.alpha = 0.7;
    [self.view addSubview:view_max];
    
    UIGestureRecognizer * tap_g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap_gClick:)];
    [view_max addGestureRecognizer:tap_g];
    
    view_min = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight/2, viewWidth, viewHeight/2)];
    view_min.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view_min];
    
    _tableView_circle = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight/2) style:UITableViewStylePlain];
    _tableView_circle.delegate = self;
    _tableView_circle.dataSource = self;
    [view_min addSubview:_tableView_circle];
    
}
-(void)tap_gClick:(UITapGestureRecognizer *)tap
{
    [view_max removeFromSuperview];
    [view_min removeFromSuperview];
}
#pragma mark -- UItextFild监控值得变化
-(void)textFieldChanged:(NSNotification *)notification
{
    UITextField *textfield=[notification object];
    
    switch (textfield.tag) {
        case 100:
        {
            projectName = textfield.text;
        }
            break;
        case 101:
        {
            developers = textfield.text;
        }
            break;
        case 102:
        {
            projectAddress = textfield.text;
        }
            break;
        default:
        {
            //codeStr = textfield.text;
        }
            break;
    }
    NSLog(@"%@~~~%@~~~%@",projectName,developers,projectAddress);
}

#pragma mark -- UITextView监控值得变化
-(void)textViewChanged:(NSNotification *)notification
{
    UITextView *textView=[notification object];
    if (textView.tag == 1000) {
        
        ProjectIntro = textView.text;
    }
    else if (textView.tag == 1001)
    {
        BrandInto = textView.text;
    }
    NSLog(@"%@~~~%@",ProjectIntro,BrandInto);
}

#pragma mark -- 提交按钮
-(void)receiveBtnClick:(UIButton *)btn
{
    
    NSDictionary * param = @{@"projectImage":imageStr,
                            @"projectCircleCategoryId":ProjectCircleId,
                            @"phone":_phoneStr,
                            @"department":developers,
                            @"code":_codeStr,
                            @"brandId":_brandId,
                            @"postId":@(_postCategoryId),
                            @"merchantsStatus":merchantStateId,
                            @"projectAddress":projectAddress,
                            @"mainBrands":BrandInto,
                            @"projectDescription":ProjectIntro,
                            @"typeCategoryId":ProjectTypeId,
                            @"realName":_contactStr,
                            @"developersName":_departmentStr,
                            @"projectName":projectName};
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brandMerchant/add/merchant.do" params:param success:^(id JSON) {
        
        NSLog(@"%@",JSON);
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:JSON[@"message"] delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
        if ([JSON[@"status"] integerValue] == 1) {
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        
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
