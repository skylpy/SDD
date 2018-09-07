//
//  DevCerViewController.m
//  SDD
//
//  Created by mac on 15/9/22.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "DevCerViewController.h"
#import "DevCerCell.h"
#import "SDD_DoubleImageViewCell.h"
#import "UIButton+WebCache.h"
#import "ButtonCell.h"
#import "LPYModelTool.h"
#import "DevCerModel.h"
#import "DevCerTwoViewController.h"
#import "CertifySecondStep.h"

@interface DevCerViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>
{
    NSArray * nameArr; //名称
    NSArray * explainArr; //说明
    
    int imageNumber;
    
    UIButton * ImageBtn;//第一个按钮
    
    NSString * licenseImageStr; //营业执照
    NSString * figureImageStr; //公司形象
    
    UIButton * nextBtn;//下一步按钮
    
    
    /*******续传字段********/
    
    NSString * companyName;//公司名称
    NSString * projectName;//项目名称
    
    NSString * IndustryType;//行业类型
    NSString * projectNature;//项目性质
    NSString * projectType;//项目类型
    
    NSInteger IndustryTypeId;//行业类型
    NSInteger projectNatureId;//项目性质
    NSInteger projectTypeId;//项目类型
    
    NSString * projectAdds;//项目地址
    NSString * companyAdds;//公司地址
    
    NSString * companyIntro;//公司简介
    
    /**********************/
    
    NSMutableArray * dataArray;//整体输入数据
    
    UIView * maxView;  //大黑View
    UIView * minView;  //大白View
    
    NSArray * InduTwoArray;//行业类型二级数组
}
@property (retain,nonatomic)UITableView * fristMainTable;//第一个table

@property (retain,nonatomic)UITableView * IndustryTypeTable;//行业类型table
@property (retain,nonatomic)NSMutableArray * IndustryTypeArr;

@property (retain,nonatomic)UITableView * IndustryTwoTypeTable;//行业类型table 二级


@property (retain,nonatomic)UITableView * projectNatureTable;//行业类型table
@property (retain,nonatomic)NSMutableArray * projectNatureArr;

@property (retain,nonatomic)UITableView * projectTypeTable;//行业类型table
@property (retain,nonatomic)NSMutableArray * projectTypeArr;
@end

@implementation DevCerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    [self setUpNvc];
    [self createMainView];
    [self setInitData];
    
    [self requsetData];
}

#pragma mark -- 数据下载
-(void)requsetData
{
    _IndustryTypeArr = [[NSMutableArray alloc] init];
    _projectNatureArr = [[NSMutableArray alloc] init];
    _projectTypeArr = [[NSMutableArray alloc] init];
    // 行业类别/houseCategory/industryCategorys.do
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brandCategory/industryAllList.do" params:nil success:^(id JSON) {
        
        NSLog(@"%@",JSON);
        if (![JSON[@"data"] isEqual:[NSNull null]])
        {
            NSArray * array = JSON[@"data"];
            for (NSDictionary * dic in array)
            {
                DevCerModel * model = [[DevCerModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_IndustryTypeArr addObject:model];
            }
        }
        [_IndustryTypeTable reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
    
     // 项目类型
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/houseCategory/typeCategorys.do" params:nil success:^(id JSON) {
        
        if (![JSON[@"data"] isEqual:[NSNull null]])
        {
            NSArray * array = JSON[@"data"];
            for (NSDictionary * dic in array)
            {
                DevCerModel * model = [[DevCerModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_projectTypeArr addObject:model];
            }
        }
        [_projectTypeTable reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
    
    //  项目性质
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/houseCategory/natureCategorys.do" params:nil success:^(id JSON) {
        
        if (![JSON[@"data"] isEqual:[NSNull null]])
        {
            NSArray * array = JSON[@"data"];
            for (NSDictionary * dic in array)
            {
                DevCerModel * model = [[DevCerModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_projectNatureArr addObject:model];
            }
        }
        [_projectNatureTable reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark -- 初始化数据
-(void)setInitData
{
    nameArr = @[@"公司名称：",@"项目名称：",@"招商对象：",@"项目性质：",@"项目类型：",@"项目地址：",@"公司地址：",@"企业简介："];
    
    explainArr = @[@"请输入公司名称",@"请输入项目名称",@"请选择行业类别",@"请选择项目性质",@"请输入项目类型",@"请输入项目地址",@"请输入公司地址",@"请输入企业简介"];
    
    licenseImageStr = @"";
    figureImageStr = @"";
    
    companyName = @"";
    projectName = @"";
    IndustryType = @"请选择行业类别";
    projectNature = @"请选择项目性质";
    projectType = @"请选择项目类型";
    projectAdds = @"";
    companyAdds =@"";
    companyIntro = @"";
    
    IndustryTypeId = 0;
    projectNatureId = 0;
    projectTypeId = 0;
    
    dataArray = [[NSMutableArray alloc] initWithObjects:companyName,projectName,IndustryType,projectNature,projectType,projectAdds,companyAdds,companyIntro, nil];
    
    nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextBtn.tag = 1100;
    [nextBtn setBackgroundImage:[Tools_F imageWithColor:dblueColor
                                                       size:CGSizeMake(viewWidth-40, 45)]
                           forState:UIControlStateNormal];
    
    [nextBtn setBackgroundImage:[Tools_F imageWithColor:[SDDColor colorWithHexString:@"006699"]
                                                       size:CGSizeMake(viewWidth-40, 45)]
                           forState:UIControlStateHighlighted];
    [Tools_F setViewlayer:nextBtn cornerRadius:5 borderWidth:1 borderColor:dblueColor];
    
}

#pragma mark -- 点击时弹出的view
-(void)createScelView
{
    maxView = [[UIView alloc] initWithFrame:self.view.bounds];
    maxView.backgroundColor = [UIColor blackColor];
    maxView.alpha = 0.7;
    [self.view addSubview:maxView];
    
    minView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight/2, viewWidth, viewHeight/2)];
    minView.backgroundColor = bgColor;
    [self.view addSubview:minView];
}

#pragma mark -- 行业类型View
-(void)IndustryTypeView
{
    [self createScelView];
    
    _IndustryTypeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth/3-1, viewHeight/2-60) style:UITableViewStylePlain];
    _IndustryTypeTable.delegate = self;
    _IndustryTypeTable.dataSource = self;
    _IndustryTypeTable.backgroundColor = bgColor;
    [minView addSubview:_IndustryTypeTable];
    
    _IndustryTwoTypeTable = [[UITableView alloc] initWithFrame:CGRectMake(viewWidth/3, 0, viewWidth/3*2, viewHeight/2-60) style:UITableViewStylePlain];
    _IndustryTwoTypeTable.delegate = self;
    _IndustryTwoTypeTable.dataSource = self;
    _IndustryTwoTypeTable.backgroundColor = bgColor;
    [minView addSubview:_IndustryTwoTypeTable];
}

#pragma mark -- 项目性质View
-(void)projectNatureView
{
    [self createScelView];
    
    _projectNatureTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight/2-60) style:UITableViewStylePlain];
    _projectNatureTable.delegate = self;
    _projectNatureTable.dataSource = self;
    _projectNatureTable.backgroundColor = bgColor;
    [minView addSubview:_projectNatureTable];
}

#pragma mark -- 项目类型View
-(void)projectTypeView
{
    [self createScelView];
    
    _projectTypeTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight/2-60) style:UITableViewStylePlain];
    _projectTypeTable.delegate = self;
    _projectTypeTable.dataSource = self;
    _projectTypeTable.backgroundColor = bgColor;
    [minView addSubview:_projectTypeTable];
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
                if (indexPath.row == 2) {
                    return 80;
                }
                else
                {
                    return 44;
                }
            }
                break;
            case 3:
            {
                return 135;
            }
                break;
            case 4:
            {
                return 80;
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
    if (_fristMainTable == tableView)
    {
        return 5;
    }
    else
    {
        return 1;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_fristMainTable == tableView )
    {
        switch (section) {
            case 0:
            {
                return 2;
            }
                break;
            case 1:
            {
                return 3;
            }
                break;
            case 2:
            {
                return 3;
            }
                break;
            case 3:
            {
                return 1;
            }
                break;
            default:
            {
                return 1;
            }
                break;
        }
    }
    else if (tableView == _IndustryTypeTable)
    {
        return _IndustryTypeArr.count;
    }
    else if (tableView == _projectTypeTable)
    {
        return _projectTypeArr.count;
    }
    else if (tableView == _projectNatureTable)
    {
        return _projectNatureArr.count;
    }
    else
    {
        return InduTwoArray.count;;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_fristMainTable == tableView) {
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
                cell.textField.placeholder = explainArr[indexPath.row];
                cell.textField.text = dataArray[indexPath.row];
                
                cell.textField.tag = indexPath.row+100;
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(textFieldChanged:)
                                                             name:UITextFieldTextDidChangeNotification
                                                           object:cell.textField];
                
            }
                break;
            case 1:
            {
                cell.textField.hidden = YES;
                cell.nameLable.text = nameArr[indexPath.row+2];
                cell.chooseLable.text =dataArray[indexPath.row+2];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
                break;
            case 2:
            {
                [cell.chooseLable removeFromSuperview];
                cell.textField.hidden = NO;
                
                cell.nameLable.text = nameArr[indexPath.row+5];
                cell.textField.placeholder = explainArr[indexPath.row+5];
                cell.textField.text = dataArray[indexPath.row+5];
                
                cell.textField.tag = indexPath.row+200;
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(textFieldChanged:)
                                                             name:UITextFieldTextDidChangeNotification
                                                           object:cell.textField];
                
                if (indexPath.row == 2) {
                    cell.textField.hidden = YES;
                    //cell.textField.placeholder = explainArr[indexPath.row+5];
                    
                    cell.textView.text = dataArray[indexPath.row+5];
                    [cell.textView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(cell.mas_top).with.offset(8);
                        make.left.equalTo(cell.nameLable.mas_right).with.offset(5);
                        make.bottom.equalTo(cell.mas_bottom).with.offset(-8);
                        make.right.equalTo(cell.mas_right).with.offset(-20);
                    }];
                    
                    
                    [[NSNotificationCenter defaultCenter] addObserver:self
                                                             selector:@selector(textViewChanged:)
                                                                 name:UITextViewTextDidChangeNotification
                                                               object:cell.textView];
                }
            }
                break;
            case 3:
            {
                
                SDD_DoubleImageViewCell *cellBtn = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
                if (!cellBtn) {
                    cellBtn = [[SDD_DoubleImageViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
                }
                cellBtn.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *lableF = (UILabel*)[cellBtn viewWithTag:333];
                UILabel *lableS = (UILabel*)[cellBtn viewWithTag:334];
                lableF.text = @"上传营业执照";
                lableS.text = @"上传公司形象墙";
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
                cell.backgroundColor = bgColor;
                
                cell.textField.hidden = YES;
                cell.starLable.hidden = YES;
                cell.nameLable.hidden = YES;
                cell.chooseLable.hidden = YES;
                
                [cell addSubview:nextBtn];
                
                [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
                [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(cell.mas_top).with.offset(10);
                    make.left.equalTo(cell.mas_left).with.offset(20);
                    make.right.equalTo(cell.mas_right).with.offset(-20);
                    make.height.equalTo(@45);
                }];
                
                
            }
                break;
        }
        
       
        
        return cell;
    }
    else if (tableView == _IndustryTypeTable)
    {
        static NSString * cellID = @"IndustryTypeCellID";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        DevCerModel * model = _IndustryTypeArr[indexPath.row];
        cell.textLabel.text = model.categoryName;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }
    else if (tableView == _projectNatureTable)
    {
        static NSString * cellID = @"projectNatureCellID";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        DevCerModel * model = _projectNatureArr[indexPath.row];
        cell.textLabel.text = model.categoryName;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }
    else if (tableView == _projectTypeTable)
    {
        static NSString * cellID = @"projectTypeCellID";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        DevCerModel * model = _projectTypeArr[indexPath.row];
        cell.textLabel.text = model.categoryName;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }
    else
    {
        static NSString * cellID = @"cellID";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        NSDictionary * dict = InduTwoArray[indexPath.row];
        cell.textLabel.text = dict[@"categoryName"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }
}

#pragma mark -- 点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (tableView == _fristMainTable)
    {
    
        if (indexPath.section == 1)
        {
            switch (indexPath.row) {
                case 0:
                    [self IndustryTypeView];
                    break;
                case 1:
                    [self projectNatureView];
                    break;
                case 2:
                    [self projectTypeView];
                    break;
                default:
                    break;
            }
            
        }
    }
    
    else if (tableView == _projectTypeTable)
    {
        DevCerModel * model = _projectTypeArr[indexPath.row];
        projectType = model.categoryName;
        projectTypeId = [model.typeCategoryId integerValue];
        
        [maxView removeFromSuperview];
        [minView removeFromSuperview];
        
    }
    else if (tableView == _IndustryTypeTable)
    {
        DevCerModel * model = _IndustryTypeArr[indexPath.row];
        InduTwoArray = model.children;
        
        [_IndustryTwoTypeTable reloadData];
        
    }
    else if (tableView == _IndustryTwoTypeTable)
    {
        NSDictionary * dict = InduTwoArray[indexPath.row];
        
        IndustryType = dict[@"categoryName"];
        IndustryTypeId = [dict[@"industryCategoryId"] integerValue];
        
        [maxView removeFromSuperview];
        [minView removeFromSuperview];
    }
    else if (tableView == _projectNatureTable)
    {
        DevCerModel * model = _projectNatureArr[indexPath.row];
        projectNature = model.categoryName;
        projectNatureId = [model.projectNatureCategoryId integerValue];
        
        [maxView removeFromSuperview];
        [minView removeFromSuperview];
        
    }
    
    
    dataArray = [[NSMutableArray alloc] initWithObjects:companyName,projectName,IndustryType,projectNature,projectType,projectAdds,companyAdds,companyIntro, nil];
    
    [_fristMainTable reloadData];
}

#pragma mark -- UItextFild监控值得变化
-(void)textFieldChanged:(NSNotification *)notification
{
    UITextField *textfield=[notification object];
    switch (textfield.tag) {
        case 100:
            companyName = textfield.text;
            break;
        case 101:
            projectName = textfield.text;
            break;
        case 200:
            projectAdds = textfield.text;
            break;
        default:
            companyAdds = textfield.text;
            break;
    }
    dataArray = [[NSMutableArray alloc] initWithObjects:companyName,projectName,IndustryType,projectNature,projectType,projectAdds,companyAdds,companyIntro, nil];
    
//    [_fristMainTable reloadData];
}
#pragma mark -- UITextView监控值得变化
-(void)textViewChanged:(NSNotification *)notification
{
    UITextView *textView=[notification object];
    
    companyIntro = textView.text;
    
    dataArray = [[NSMutableArray alloc] initWithObjects:companyName,projectName,IndustryType,projectNature,projectType,projectAdds,companyAdds,companyIntro, nil];
    
    NSLog(@"dataArray = %@",dataArray);
}
#pragma mark -- 下一步按钮
-(void)nextBtnClick:(UIButton *)btn
{
    if ([companyName isEqualToString:@""]|[projectName isEqualToString:@""]|[IndustryType isEqualToString:@""]|[projectNature isEqualToString:@""]|[projectType isEqualToString:@""]|[projectAdds isEqualToString:@""]|[companyAdds isEqualToString:@""]|[companyIntro isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请输完整信息"
                                                       delegate:self
                                              cancelButtonTitle:@"好"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else
    {
        DevCerTwoViewController * DevCerVc = [[DevCerTwoViewController alloc] init];
        DevCerVc.companyName = companyName;
        DevCerVc.projectName = projectName;
        DevCerVc.projectAdds = projectAdds;
        DevCerVc.companyAdds = companyAdds;
        DevCerVc.companyIntro = companyIntro;
        
        DevCerVc.licenseImageStr = licenseImageStr;
        DevCerVc.figureImageStr = figureImageStr;
        
        DevCerVc.industryTypeId = IndustryTypeId;
        DevCerVc.projectTypeId = projectTypeId;
        DevCerVc.projectNatureId = projectNatureId;
        
        [self.navigationController pushViewController:DevCerVc animated:YES];
    }
    
    //CertifySecondStep * DevCerVc = [[CertifySecondStep alloc] init];
//    DevCerTwoViewController * DevCerVc = [[DevCerTwoViewController alloc] init];
//    
//    [self.navigationController pushViewController:DevCerVc animated:YES];
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
                    licenseImageStr = dict[@"data"][0];
                    break;
                case 1:
                    figureImageStr = dict[@"data"][0];
                    break;
                default:
                    
                    
                    break;
            }
            NSLog(@"licenseImageStr-->%@  , figureImageStr--->%@",licenseImageStr,figureImageStr);
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
    titleLabel.text = @"发展商认证1/2";
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
