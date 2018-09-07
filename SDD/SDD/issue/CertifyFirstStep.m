//
//  CertifyFirstStep.m
//  ShopMoreAndMore
// 发展商认证
//  Created by mac on 15/7/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
///houseCategory/natureCategorys.do  /brandCategory/industryList.do
#define VIEWHEIGHT self.view.frame.size.height
#define VIEWWIDTH self.view.frame.size.width
#import "CertifyFirstStep.h"
#import "Header.h"
@interface CertifyFirstStep ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    int        imageNumber;
    UITableView  *industryTable;
    UITableView  *proTypeTable;
    UITableView  *netureTale;
    UIView     *bgView;
    NSString    *proTypeStr;
    NSString    *netureStr;
    NSString   *induStr;
    
    UIButton * conBrandBtn1;
    
    NSInteger projectNatureCategoryId;
    NSInteger typeCategoryId;
}
@property(nonatomic, strong)NSArray     *industryArr;
@property(nonatomic, strong)NSArray     *proTypeArr;
@property(nonatomic, strong)NSArray     *netureArr;

@property (retain,nonatomic)NSMutableArray * totalArray;
@property (retain,nonatomic)NSMutableArray * FirstArray;
@property (retain,nonatomic)NSMutableArray * SecondArray;
@property (retain,nonatomic)NSMutableArray * ThirdArray;
@property (retain,nonatomic)NSMutableArray * FourthArray;

@end

@implementation CertifyFirstStep

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
#pragma mark -- 修改传值7.16
    _FirstArray = [[NSMutableArray alloc] initWithObjects:@"",@"", nil];
    _SecondArray = [[NSMutableArray alloc] initWithObjects:@"请输入行业类别",@"请输入项目性质",@"请输入项目类型", nil];
    _ThirdArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"", nil];
    _FourthArray = [[NSMutableArray alloc] initWithObjects:@"",@"", nil];
    
    
    self.certiyFirstArr                               = [[NSMutableArray alloc] initWithCapacity:0];
    [HttpRequest getWithIndustyURL:SDD_MainURL path:@"/houseCategory/industryCategorys.do" success:^(id Josn) {
        //        行业类别
        _industryArr                                      = [Josn objectForKey:@"data"];
        NSLog(@"+++++++++%@",[[[Josn objectForKey:@"data"] [3] objectForKey:@"industryCategoryId"] class]);
        NSLog(@"行业%ld",[[[Josn objectForKey:@"data"] [3] objectForKey:@"industryCategoryId"] integerValue]);
    } failure:^(NSError *error) {
        
    }];
    [HttpRequest getWithProTypeURL:SDD_MainURL path:@"/houseCategory/typeCategorys.do" success:^(id Josn) {
        //        项目类型
        _netureArr= [Josn objectForKey:@"data"];
//        _proTypeArr= [Josn objectForKey:@"data"];
        NSLog(@"项目类型%@",Josn);
        //typeCategoryId =
        NSLog(@"类型%@",[[Josn objectForKey:@"data"] [3] objectForKey:@"typeCategoryId"]);
    } failure:^(NSError *error) {
        
    }];
    [HttpRequest getWithNetureURL:SDD_MainURL path:@"/houseCategory/natureCategorys.do" success:^(id Josn) {
        //        项目性质
//        _netureArr= [Josn objectForKey:@"data"];
        _proTypeArr= [Josn objectForKey:@"data"];
        NSLog(@"项目性质%@",Josn);
        NSLog(@"性质%@",[[Josn objectForKey:@"data"] [3] objectForKey:@"projectNatureCategoryId"]);
    } failure:^(NSError *error) {
        
    }];
    induStr                                           = @"请选择行业类型";
    proTypeStr                                        = @"请选择项目类型";
    netureStr                                         = @"请选择项目性质";
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
    titleLabel.text = @"发展商认证1/2";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    
    _tableView                                        = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];//self.view.bounds
    _tableView.delegate                               = self;
    _tableView.dataSource                             = self;
    _tableView.backgroundColor                        = [SDDColor colorWithHexString:@"#e5e5e5"];
    [self.view addSubview:_tableView];
    industryTable                                     = [[UITableView alloc] initWithFrame:CGRectMake(0, VIEWHEIGHT, VIEWWIDTH, _industryArr.count*44) style:UITableViewStylePlain];
    industryTable.delegate                            = self;
    industryTable.dataSource                          = self;
    [self.view addSubview:industryTable];
    proTypeTable                                      = [[UITableView alloc] initWithFrame:CGRectMake(0, VIEWHEIGHT, VIEWWIDTH, _proTypeArr.count*44) style:UITableViewStylePlain];
    proTypeTable.delegate                             = self;
    proTypeTable.dataSource                           = self;
    [self.view addSubview:proTypeTable];
    netureTale                                        = [[UITableView alloc] initWithFrame:CGRectMake(0, VIEWHEIGHT, VIEWWIDTH, _netureArr.count*44) style:UITableViewStylePlain];
    netureTale.delegate                               = self;
    netureTale.dataSource                             = self;
    [self.view addSubview:netureTale];
    
    
    conBrandBtn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [conBrandBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [conBrandBtn1 setBackgroundImage:[Tools_F imageWithColor:dblueColor
                                                        size:CGSizeMake(viewWidth-40, 45)]
                            forState:UIControlStateNormal];
    
    [conBrandBtn1 setBackgroundImage:[Tools_F imageWithColor:[SDDColor colorWithHexString:@"006699"]
                                                        size:CGSizeMake(viewWidth-40, 45)]
                            forState:UIControlStateHighlighted];
    [conBrandBtn1 addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [Tools_F setViewlayer:conBrandBtn1 cornerRadius:5 borderWidth:1 borderColor:dblueColor];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == industryTable||tableView == netureTale||tableView == proTypeTable) {
        return 1;
    }if (tableView == netureTale) {
        return 1;
    }if (tableView == proTypeTable) {
        return 1;
    }
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == netureTale) {
        return _netureArr.count;
    }
    if (tableView == industryTable) {
        return _industryArr.count;
    }
    if (tableView == proTypeTable) {
        return _proTypeArr.count;
    }
    if (section == 0) {
        return _FirstArray.count;
    }
    if (section == 1) {
        return _SecondArray.count;
    }
    if (section == 2) {
        return _ThirdArray.count;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == industryTable||tableView == netureTale||tableView == proTypeTable) {
        return 0;
    }if (tableView == netureTale) {
        return 0;
    }if (tableView == proTypeTable) {
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == industryTable||tableView == netureTale||tableView == proTypeTable) {
        return 44;
    }if (tableView == netureTale) {
        return 44;
    }if (tableView == proTypeTable) {
        return 44;
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 2) {
            return 89;
        }
    }
    if (indexPath.section == 3) {
        return 135;
    }
    if (indexPath.section == 4) {
        return 80;
    }
    return 45;
}
#pragma mark----表格类容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == industryTable) {//行业类别
        UITableViewCell *cell                             = [tableView dequeueReusableCellWithIdentifier:@"cellI"];
        if (!cell) {
            cell                                              = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cellI"];
        }
        cell.textLabel.text                               = [_industryArr[indexPath.row] objectForKey:@"categoryName"];
        return cell;
    }
    if (tableView == proTypeTable) {//项目性质
        UITableViewCell *cell                             = [tableView dequeueReusableCellWithIdentifier:@"cellP"];
        if (!cell) {
            cell                                              = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cellP"];
        }
        cell.textLabel.text                               = [_proTypeArr[indexPath.row] objectForKey:@"categoryName"];
        
        
        return cell;
    }
    if (tableView == netureTale) {//项目类型
        UITableViewCell *cell                             = [tableView dequeueReusableCellWithIdentifier:@"cellN"];
        if (!cell) {
            cell                                              = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cellN"];
        }
        cell.textLabel.text                               = [_netureArr[indexPath.row] objectForKey:@"categoryName"];
        return cell;
    }
    
    SDD_CooperationCell *cell                         = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (tableView == _tableView) {
        //第0组
        
        if (!cell) {
            cell                                              = [[SDD_CooperationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        
        cell.nameLable.text                               = (indexPath.row == 0)?@"公司名称:":@"项目名称:";
        UIColor *color                                    = [SDDColor colorWithHexString:@"#999999"];
        cell.textField.attributedPlaceholder              = [[NSAttributedString alloc] initWithString:(indexPath.row == 0)?@"请输入公司名称":@"请输入项目名称" attributes:@{NSForegroundColorAttributeName: color}];
        if (indexPath.section == 0) {
            cell.textField.text = _FirstArray[indexPath.row];
        }
        
        
        cell.textField.tag                                = indexPath.row+10;
        if (indexPath.row == 0) {
            cell.textField.tag                                = 1000;
        }else{
            cell.textField.tag                                = 1001;
        }
        cell.textField.delegate                           = self;
        
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldChanged:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:cell.textField];
        
        
        //第一组
        if (indexPath.section == 1) {
            SDD_DetailValueCell *cell                         = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
            if (!cell) {
                cell                                              = [[SDD_DetailValueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
            }
            NSArray *nameArr                                  = [NSArray arrayWithObjects:@"行业类别:",@"项目性质:",@"项目类型:", nil];
            cell.nameLable.text                               = nameArr[indexPath.row];
            cell.chooseLable.text                             = _SecondArray[indexPath.row];
            
            cell.chooseLable.frame                            = CGRectMake(190, 16, 100, 13);
            cell.accessoryType                                = UITableViewCellAccessoryDisclosureIndicator;
            [cell.textField removeFromSuperview];
            CELLSELECTSTYLE
            return cell;
            
        }
        
        //第2组
        if (indexPath.section == 2){
            SDD_CooperationCell *cell                         = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            if (!cell) {
                cell                                              = [[SDD_CooperationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
            }
            NSArray *nameArr                                  = [NSArray arrayWithObjects:@"项目地址:",@"公司地址:",@"请输入项目地址",@"请输入公司地址",@"",@"", nil];
            UIColor *color                                    = [SDDColor colorWithHexString:@"#999999"];
            cell.textField.attributedPlaceholder              = [[NSAttributedString alloc] initWithString:nameArr[indexPath.row+2] attributes:@{NSForegroundColorAttributeName: color}];
            cell.nameLable.text                               = nameArr[indexPath.row];
            cell.textField.delegate                           = self;
            cell.textField.tag                                = indexPath.row+100;
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(textFieldChanged:)
                                                         name:UITextFieldTextDidChangeNotification
                                                       object:cell.textField];
            
            if (indexPath.row == 0) {
                cell.textField.text                               = _hoseAdress;
                cell.textField.tag                                = 1002;
            }
            if (indexPath.row == 1) {
                cell.textField.text                               = _companyAdress;
                cell.textField.tag                                = 1003;
            }
            if (indexPath.row == 2) {
                SDD_TextViewCell *cell                            = [tableView dequeueReusableCellWithIdentifier:@"cell22"];
                if (!cell) {
                    cell                                              = [[SDD_TextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell22"];
                }
                cell.label.text                                   = @"企业简介:";
                cell.textView.placeholderColor                    = [SDDColor colorWithHexString:@"#999999"];
                cell.textView.placeholderText                     = @"请选择企业简介";
                cell.textView.frame                               = CGRectMake(70, 6, 250, 74);
                cell.textView.delegate                            = self;
                cell.textView.text                                = _companyDescription;
                cell.textView.tag                                 = 1004;
                
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(textViewChanged:)
                                                             name:UITextViewTextDidChangeNotification
                                                           object:cell.textView];
                CELLSELECTSTYLE
                
                return cell;
            }
            CELLSELECTSTYLE
            return cell;
        }
        
        
        //第3组
        if (indexPath.section == 3){
            SDD_DoubleImageViewCell *cell                     = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
            if (!cell) {
                cell                                              = [[SDD_DoubleImageViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
            }
            UILabel *lableF                                   = (UILabel*)[cell viewWithTag:333];
            UILabel *lableS                                   = (UILabel*)[cell viewWithTag:334];
            lableF.text                                       = @"上传营业执照";
            lableS.text                                       = @"上传公司形象";
            for (int i                                        = 0; i<2; i++) {
                UIButton *button                                  = (UIButton*)[cell viewWithTag:222+i];
                [button addTarget:self action:@selector(upDataClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            CELLSELECTSTYLE
            return cell;
        }
        
        //第4组
        if (indexPath.section == 4) {
            UITableViewCell *cell                          = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
            if (!cell) {
                cell                                              = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell4"];
            }
//            UIImageView *image                                = (UIImageView*)[cell viewWithTag:11];
//            UILabel *line                                     = (UILabel*)[cell viewWithTag:12];
//            UILabel *lable                                    = (UILabel*)[cell viewWithTag:15];
//            UILabel *positionLable                            = (UILabel*)[cell viewWithTag:16];
//            UIButton *positionButton                          = (UIButton*)[cell viewWithTag:150];
//            [positionButton removeFromSuperview];
//            [positionLable removeFromSuperview];
//            [image removeFromSuperview];
//            [line removeFromSuperview];
//            [lable removeFromSuperview];
//            UIButton *nextButton                              = (UIButton*)[cell viewWithTag:10];
//            [nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
//            cell.backgroundColor                              = [UIColor clearColor];
            cell.backgroundColor = bgColor;
            [conBrandBtn1 setTitle:@"下一步" forState:UIControlStateNormal];
            
            [cell.contentView addSubview:conBrandBtn1];
            [conBrandBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.mas_top).with.offset(10);
                make.left.equalTo(cell.mas_left).with.offset(20);
                make.right.equalTo(cell.mas_right).with.offset(-20);
                make.height.equalTo(@45);
            }];
            
            CELLSELECTSTYLE
            return cell;
            
        }
        
    }
        
    CELLSELECTSTYLE
    return cell;
    
    
}
#pragma mark --- 表格点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == industryTable) {
        
        UITableViewCell *cell                             = [tableView cellForRowAtIndexPath:indexPath];
        induStr                                           = cell.textLabel.text;
        self.industryCategoryId                           = [[_industryArr[indexPath.row] objectForKey:@"industryCategoryId"] integerValue];
        
        
        NSLog(@"----asdasd-----asdasd---%d",self.industryCategoryId);
        [self.certiyFirstArr addObject:induStr];
        industryTable.frame                               = CGRectMake(0, VIEWHEIGHT,VIEWWIDTH, 44*_industryArr.count);
        
        [_SecondArray replaceObjectAtIndex:0 withObject:induStr];
        NSLog(@"%@",_SecondArray);
        
        
        [bgView removeFromSuperview];
        NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:0 inSection:1];
        NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
        [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    
    if (tableView == proTypeTable) {
        UITableViewCell *cell                             = [tableView cellForRowAtIndexPath:indexPath];
        proTypeStr                                        = cell.textLabel.text;
        self.typeCategoryId                               = [[self.netureArr[indexPath.row] objectForKey:@"typeCategoryId"] integerValue];
        NSLog(@"----asdasd%@-----asdasd---%ld",self.netureArr,self.typeCategoryId);
        [self.certiyFirstArr addObject:proTypeStr];
        //        [self.certiyFirstArr addObject:[NSNumber numberWithInteger:_typeCategoryId]];
        proTypeTable.frame                                = CGRectMake(0, VIEWHEIGHT,VIEWWIDTH, 44*_industryArr.count);
        
        
        NSDictionary * dict = _netureArr[indexPath.row];
        typeCategoryId = [dict[@"typeCategoryId"] integerValue];
       
        
        [_SecondArray replaceObjectAtIndex:1 withObject:proTypeStr];
        NSLog(@"%@",_SecondArray);
        
        [bgView removeFromSuperview];
        NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:1 inSection:1];
        NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
        [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    if (tableView == netureTale) {
        UITableViewCell *cell                             = [tableView cellForRowAtIndexPath:indexPath];
        netureStr                                         = cell.textLabel.text;
        self.projectNatureCategoryId                      = [[self.proTypeArr[indexPath.row] objectForKey:@"projectNatureCategoryId"] integerValue];//
        NSLog(@"----asdasd%@-----asdasd---%ld",self.proTypeArr,self.projectNatureCategoryId);
        [self.certiyFirstArr addObject:netureStr];
        
        [_SecondArray replaceObjectAtIndex:2 withObject:netureStr];
        NSLog(@"%@",_SecondArray);
        
        //NSDictionary * dict = self.proTypeArr[indexPath.row];
        projectNatureCategoryId = [[self.proTypeArr[indexPath.row] objectForKey:@"projectNatureCategoryId"] integerValue];
        
        //[_tableView reloadData];
        
        //        [self.certiyFirstArr addObject:[NSNumber numberWithInteger:_projectNatureCategoryId]];
        [bgView removeFromSuperview];
        netureTale.frame                                  = CGRectMake(0, VIEWHEIGHT, VIEWWIDTH, 44);
        NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:2 inSection:1];
        NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
        [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.1];
            industryTable.frame                               = CGRectMake(0, 200,VIEWWIDTH, VIEWHEIGHT-200);
            bgView                                            = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
            bgView.backgroundColor                            = [UIColor blackColor];
            bgView.alpha                                      = 0.5;
            [self.view addSubview:bgView];
            [UIView setAnimationCurve:7];
            [UIView commitAnimations];
            [industryTable reloadData];
            
        }
        if (indexPath.row == 1) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.1];
            proTypeTable.frame                                = CGRectMake(0, VIEWHEIGHT-44*_proTypeArr.count,VIEWWIDTH, 44*_proTypeArr.count);
            bgView                                            = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, VIEWHEIGHT-44*_proTypeArr.count)];
            bgView.backgroundColor                            = [UIColor blackColor];
            bgView.alpha                                      = 0.5;
            [self.view addSubview:bgView];
            
            
            [UIView setAnimationCurve:7];
            [UIView commitAnimations];
            [proTypeTable reloadData];
        }
        
        
        if (indexPath.row == 2) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.1];
            netureTale.frame                                  = CGRectMake(0,  VIEWHEIGHT-44*_netureArr.count,VIEWWIDTH, 44*_netureArr.count);
            bgView                                            = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, VIEWHEIGHT-44*_netureArr.count)];
            bgView.backgroundColor                            = [UIColor blackColor];
            bgView.alpha                                      = 0.5;
            [self.view addSubview:bgView];
            
            
            
            [UIView setAnimationCurve:7];
            [UIView commitAnimations];
            [netureTale reloadData];
        }
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    }
}
#pragma mark -- UItextFild监控值得变化
-(void)textFieldChanged:(NSNotification *)notification
{
    UITextField *textfield=[notification object];
    //NSLog(@"%@",textfield.text);
    if(textfield.tag == 1000)
    {
        NSLog(@"textfield.text=%@",textfield.text);
        [_FirstArray replaceObjectAtIndex:0 withObject:textfield.text];
        NSLog(@"%@",_FirstArray);
    }
    if (textfield.tag == 1001) {
        
        NSLog(@"textfield.text = %@",textfield.text);
        [_FirstArray replaceObjectAtIndex:1 withObject:textfield.text];
        NSLog(@"%@",_FirstArray);
    }
    if (textfield.tag == 1002) {
        
        NSLog(@"%@",textfield.text);
        [_ThirdArray replaceObjectAtIndex:0 withObject:textfield.text];
        NSLog(@"%@",_ThirdArray);
        
    }
    if (textfield.tag == 1003) {
        
        NSLog(@"%@",textfield.text);
        [_ThirdArray replaceObjectAtIndex:1 withObject:textfield.text];
        NSLog(@"%@",_ThirdArray);
        
    }
}


#pragma mark -- UITextView监控值得变化
-(void)textViewChanged:(NSNotification *)notification
{
    UITextView *textView=[notification object];
    // NSLog(@"_com%@",_companyDescription);
    if (textView.tag == 1004) {
        NSLog(@"%@",textView.text);
        _companyDescription = textView.text;
        [_ThirdArray replaceObjectAtIndex:2 withObject:textView.text];
        NSLog(@"%@",_ThirdArray);
        
    }
}

#pragma mark---点击上传
- (void)upDataClick:(UIButton*)sender
{
    UIActionSheet *shotOrAlbums                       = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册中选择", nil];
    [shotOrAlbums showInView:self.view];
    switch (sender.tag) {
        case 222:
            imageNumber                                       = 0;
            break;
        case 223:
            imageNumber                                       = 1;
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
    
    UIImagePickerController *imagePicker              = [[UIImagePickerController alloc] init];
    imagePicker.delegate                              = self;
    imagePicker.sourceType                            = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing                         = YES;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

#pragma mark - 调用摄像机
- (void)pickImageFromCamera{
    
    UIImagePickerController *imagePicker              = [[UIImagePickerController alloc] init];
    imagePicker.delegate                              = self;
    imagePicker.sourceType                            = UIImagePickerControllerSourceTypeCamera;
    imagePicker.allowsEditing                         = YES;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - 当用户取消选取时调用；
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 当用户选取完成后调用；
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //初始化imageNew为从相机中获得的--
    UIImage *imageNew                                 = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        
        UIImageWriteToSavedPhotosAlbum(imageNew, nil, nil, nil);
    }
    
    //设置image的尺寸
    CGSize imagesize                                  = imageNew.size;
    imagesize.height                                  = 80;
    imagesize.width                                   = 80;
    //对图片大小进行压缩--
    //    userAvatar.image = [self imageWithImage:imageNew scaledToSize:imagesize];
    UIImageView *user1                                = (UIImageView *)[self.view viewWithTag:111];
    UIImageView *user2                                = (UIImageView *)[self.view viewWithTag:112];
    XHBaseViewController *baseVC                      = [[XHBaseViewController alloc] init];
    if (imageNumber == 0) {
        user1.image                                       = imageNew;
        [HttpTool uploadWithBaseURL:SDD_MainURL Path:@"/upload/images.do" params:nil dataName:@"images" AlbumImage:imageNew success:^(id responseObject) {
            
            [baseVC hideLoading];
            NSDictionary *dict                                = responseObject;
            NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
            if (![dict[@"data"] isEqual:[NSNull null]]) {
                
                NSLog(@"营业执照%@",dict[@"data"][0]);
                
                [_FourthArray replaceObjectAtIndex:0 withObject:dict[@"data"][0]];
                [self showAlert:dict[@"message"]];
                NSLog(@"%@",_FourthArray);
                
                self.businessLicense                              = dict[@"data"][0];
                //                brandImage = dict[@"data"][0];
                //                [upLoadImg setBackgroundImage:imageNew forState:UIControlStateNormal];
            }
            
        } fail:^{
            [self showAlert:@"上传失败,请重新上传！"];
            [baseVC showErrorWithText:@"上传失败"];
        }];
        
        
        imageNumber                                       = 2;
    }
    if (imageNumber == 1) {
        user2.image                                       = imageNew;
        [HttpTool uploadWithBaseURL:SDD_MainURL Path:@"/upload/images.do" params:nil dataName:@"images" AlbumImage:imageNew success:^(id responseObject) {
            
            [baseVC hideLoading];
            NSDictionary *dict                                = responseObject;
            NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
            if (![dict[@"data"] isEqual:[NSNull null]]) {
                NSLog(@"公司形象%@",dict[@"data"][0]);
                
                [_FourthArray replaceObjectAtIndex:1 withObject:dict[@"data"][0]];
                [self showAlert:dict[@"message"]];
                NSLog(@"%@",_FourthArray);
                
                self.companyImage                                 = dict[@"data"][0];
                //                brandImage = dict[@"data"][0];
                //                [upLoadImg setBackgroundImage:imageNew forState:UIControlStateNormal];
            }
            
        } fail:^{
            [self showAlert:@"上传失败,请重新上传！"];
            [baseVC showErrorWithText:@"上传失败"];
        }];
        
        
        imageNumber                                       = 4;
    }
    
    NSData *imageData                                 = UIImageJPEGRepresentation(imageNew,0.01);
    
    NSArray *paths                                    = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory                      = [paths objectAtIndex:0];
    // Now we get the full path to the file
    NSString *fullPathToFile                          = [documentsDirectory stringByAppendingPathComponent:@"newAvatar.png"];
    // and then we write it out
    [imageData writeToFile:fullPathToFile atomically:YES];
    NSLog(@"%@",[NSURL fileURLWithPath:fullPathToFile]);
    [self uploadTask:fullPathToFile];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//对图片尺寸进行压缩--
- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize{
    
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage                                 = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

#pragma mark - 上传图片
- (void)uploadTask:(NSString *)imageUrl{
    NSLog(@"上传图片");
    XHBaseViewController *baseVC                      = [[XHBaseViewController alloc] init];
    [baseVC showLoading:0];
    
    NSString *str                                     = [SDD_MainURL stringByAppendingString:@"/upload/images.do"];// 拼接主路径和请求内容成完整url
    
    NSMutableURLRequest *request                      = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:str parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:imageUrl] name:@"images" fileName:@"newPic.png" mimeType:@"image/png" error:nil];
    } error:nil];
    AFURLSessionManager * manager                     = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSProgress *progress                              = nil;
    
    NSURLSessionUploadTask *uploadTask                = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            
            NSLog(@"Error: %@", error);
        } else {
            
            //            NSDictionary *dict = responseObject;
            //            NSLog(@"+++++++++++++++%@",dict);
            [baseVC hideLoading];
        }
    }];
    
    [uploadTask resume];
}

#pragma mark---下一界面
- (void)nextButtonClick
{
    //    [self.certiyFirstArr addObject:companyName];
    //    [self.certiyFirstArr addObject:hoseName];
    ////    [self.certiyFirstArr addObject:[NSNumber numberWithInteger:industryCategoryId]];
    ////    [self.certiyFirstArr addObject:[NSNumber numberWithInteger:typeCategoryId]];
    ////    [self.certiyFirstArr addObject:[NSNumber numberWithInteger:projectNatureCategoryId]];
    //    [self.certiyFirstArr addObject:hoseAdress];
    //    [self.certiyFirstArr addObject:companyAdress];
    //    [self.certiyFirstArr addObject:companyDescription];
    NSLog(@"%@本页面%@",self.companyName,self.hoseName);
    
    //    if (companyName==@""||hoseName==@""||hoseAdress==@""||companyAdress==@""||induStr==@""||proTypeStr==@""||netureStr==@"") {
    //        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请将信息填写完整" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //        [alter show];
    //    }
    
#pragma mark -- 7.16修改带星号的如果不填post不过下一个界面
    NSString * comName = _FirstArray[0];
    NSString * comPro = _FirstArray[1];
    
    NSString * comType = _SecondArray[0];
    NSString * comnAture = _SecondArray[1];
    NSString * comProType = _SecondArray[2];
    
    NSString * comProAddress = _ThirdArray[0];
    NSString * comAddress = _ThirdArray[1];
    NSString * comIntroduction = _ThirdArray[2];
    
    NSString * comPic1 = _FourthArray[0];
    NSString * comPic2 = _FourthArray[1];
    
//    修改之前   上传营业执照  上传公司形象墙
//    if ([comName isEqualToString:@""]|[comPro isEqualToString:@""]|[comType isEqualToString: @"请输入行业类别"]|[comnAture isEqualToString:@"请输入项目性质"]|[comProType isEqualToString:@"请输入项目类型"]|[comProAddress isEqualToString:@""]|[comAddress isEqualToString:@""]|[comIntroduction isEqualToString:@""]|[comPic1 isEqualToString:@""]|[comPic2 isEqualToString:@""])
    
//    修改之后   营业执照  公司形象墙  非必须
    if ([comName isEqualToString:@""]|[comPro isEqualToString:@""]|[comType isEqualToString: @"请输入行业类别"]|[comnAture isEqualToString:@"请输入项目性质"]|[comProType isEqualToString:@"请输入项目类型"]|[comProAddress isEqualToString:@""]|[comAddress isEqualToString:@""]|[comIntroduction isEqualToString:@""]) {
        
        [self showAlert:@"请把信息填写完整"];
        
    }
    else
    {
        CertifySecondStep *certSecond = [[CertifySecondStep alloc] init];
        
        certSecond.companyDescription = _companyDescription;
        certSecond.dataArray1 = _FirstArray;
        certSecond.dataArray2 = _SecondArray;
        certSecond.dataArray3 = _ThirdArray;
        certSecond.projectNatureCategoryId = projectNatureCategoryId;
        certSecond.typeCategoryId = typeCategoryId;
        [self.navigationController pushViewController:certSecond animated:YES];
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


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UITextField *companyNameText                      = (UITextField*)[self.tableView viewWithTag:1000];
    UITextField *hoseNameText                         = (UITextField*)[self.tableView viewWithTag:1001];
    UITextField *hoseAdressText                       = (UITextField*)[self.tableView viewWithTag:1002];
    UITextField *companyAdressText                    = (UITextField*)[self.tableView viewWithTag:1003];
    _companyName                                      = companyNameText.text;
    _hoseName                                         = hoseNameText.text;
    _hoseAdress                                       = hoseAdressText.text;
    _companyAdress                                    = companyAdressText.text;
    [self.certiyFirstArr addObject:_companyName];
    [self.certiyFirstArr addObject:_hoseName];
    [self.certiyFirstArr addObject:_hoseAdress];
    [self.certiyFirstArr addObject:_companyAdress];
    NSLog(@"111---%@%@%@%@",_companyName,_hoseName,_hoseAdress,_companyAdress);
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    _companyDescription                               = textView.text;
    
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
