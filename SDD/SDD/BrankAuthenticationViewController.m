//
//  BrankAuthenticationViewController.m
//  SDD
//
//  Created by hua on 15/7/1.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "BrankAuthenticationViewController.h"

#import "FindBrankModel.h"

#import "FSDropDownMenu.h"

@interface BrankAuthenticationViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,FSDropDownMenuDataSource,FSDropDownMenuDelegate>{
    
    /*- ui -*/
    
    UITableView *table;
    FSDropDownMenu *dropMenu;
    
    UILabel *industry;
    
    UITextView *brankNameTF;                        // 品牌名称
    UITextView *companyNameTF;                      // 企业名称
    UITextView *brankPrincipalTF;                   // 品牌负责人
    UITextView *jobTF;                              // 职务
    UITextView *phoneTF;                            // 手机号码
    UITextView *storeQTYTF;                         // 门店数量
    UITextView *companyAgeTF;                       // 企业年限
    UITextView *brankIntroduceTF;                   // 品牌介绍
    
    /*- data -*/
    
    FindBrankModel *currentModel;
    NSArray *contentTitle;
    
    NSInteger industryCategoryId;
    NSInteger industryCategoryId2;
    NSString *idCardImage;                          // 身份证url
    NSString *businessLicenseImage;                 // 名片url
    NSString *businessCardImage;                    // 营业执照url
    NSString *brandLogoImage;                       // 品牌LOGOurl
    NSInteger imgType;                              // 0:身份证url 1:名片url 2:营业执照url 3:品牌LOGOurl
}

// 填写内容
@property (nonatomic, strong) NSMutableArray *content;
// 招商对象
@property (nonatomic, strong) NSMutableArray *industryAll;

@end

@implementation BrankAuthenticationViewController

- (NSMutableArray *)content{
    if (!_content) {
        _content = [[NSMutableArray alloc]init];
    }
    return _content;
}

- (NSMutableArray *)industryAll{
    if (!_industryAll) {
        _industryAll = [[NSMutableArray alloc]init];
    }
    return _industryAll;
}

#pragma mark - 请求数据
- (void)requestData{
    
    // 招商对象
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 维度选择
    [self requestData];
    // 导航条
    [self setupNav];
    // 设置内容
    [self setupUI];
    //初始化数据
    [self initData];
}

#pragma mark -- 初始化数据
-(void)initData
{
    brankNameTF.text = _brankNameTFStr;
    companyNameTF.text = _companyNameTFStr;
    brankPrincipalTF.text = _brankPrincipalTFStr;
    jobTF.text = _jobTFStr;
    phoneTF.text = _phoneTFStr;
    storeQTYTF.text = _storeQTYTFStr;
    companyAgeTF.text = _companyAgeTFStr;
    brankIntroduceTF.text = _brankIntroduceTFStr;
    
    industryCategoryId = _industryCategoryId;
    industryCategoryId2 = _industryCategoryId2;
    idCardImage = _idCardImage;
    businessLicenseImage = _businessLicenseImage;
    businessCardImage = _businessCardImage;
    brandLogoImage = _brandLogoImage;
    imgType = _imgType;
}


#pragma mark - 设置导航条
- (void)setupNav{
    
    [self setNav:@"品牌商认证"];
    
//    UIButton *commit = [[UIButton alloc] init];
//    commit.frame = CGRectMake(0, 0, 50, 44);
//    commit.titleLabel.font = largeFont;
//    [commit setTitle:@"提交" forState:UIControlStateNormal];
//    [commit addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:commit];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    // cell标题
    contentTitle = @[@[@"*品牌名称",@"*企业名称"],
                     @[@"*品牌负责人",@"*职务",@"*手机号码"],
                     @[@"*招商对象",@"*门店数量",@"*企业年限"],
                     @[@"*品牌介绍"],
                     ];
    
    // table脚
    UIView *tableFootView = [[UIView alloc] init];
    tableFootView.frame = CGRectMake(0, 0, viewWidth, 235);
    tableFootView.backgroundColor = bgColor;
    
    for (int i=0; i<4; i++) {
        UIButton *imgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        imgButton.frame = CGRectMake(0, 0, 110, 67);
        imgButton.tag = 100+i;
        [imgButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"join_my_img_uploading%d",i]] forState:UIControlStateNormal];
        [imgButton addTarget:self action:@selector(uploadImage:) forControlEvents:UIControlEventTouchUpInside];
        
        [tableFootView addSubview:imgButton];
        
        switch (i) {
            case 0:
            {
                imgButton.center = CGPointMake(tableFootView.frame.size.width/4, (tableFootView.frame.size.height-65)/4);
            }
                break;
            case 1:
            {
                imgButton.center = CGPointMake(tableFootView.frame.size.width*3/4, (tableFootView.frame.size.height-65)/4);
            }
                break;
            case 2:
            {
                imgButton.center = CGPointMake(tableFootView.frame.size.width/4, (tableFootView.frame.size.height-65)*3/4);
            }
                break;
            default:
            {
                imgButton.center = CGPointMake(tableFootView.frame.size.width*3/4, (tableFootView.frame.size.height-65)*3/4);
            }
                break;
        }
    }
    
    // 报名按钮
    ConfirmButton *sendButton = [[ConfirmButton alloc] initWithFrame:CGRectMake(20, 180, viewWidth - 40, 45)
                                                               title:@"提交"
                                                              target:self
                                                              action:@selector(commitAction:)];
    sendButton.enabled = YES;
    [tableFootView addSubview:sendButton];
    
    // table
    table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    table.backgroundColor = bgColor;
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    table.tableFooterView = tableFootView;
    
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 栏目选择
    dropMenu = [[FSDropDownMenu alloc] initWithOrigin:CGPointMake(0, viewHeight-300-64) andHeight:300];
    dropMenu.dataSource = self;
    dropMenu.delegate = self;
    [self.view addSubview:dropMenu];
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 3) {
        return 88;
    }
    return 50;
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:{
            
            return 2;
        }
            break;
        case 1:
        case 2:{
            
            return 3;
        }
            break;
            
        default:{
            
            return 1;
        }
            break;
    }
}

#pragma mark - 设置Sections数 (tableView)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}

#pragma mark - 设置section 头高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}

#pragma mark - 设置section 脚高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

#pragma mark - 设置cell (tableView)
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //重用标识符
    static NSString *identifier = @"FindAuthentcation";
    //重用机制
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
    
    UITextView *textView;
    if (cell == nil) {
        //当不存在的时候用重用标识符生成
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
        cell.textLabel.font = midFont;
        
        if (textView == nil) {
            
            textView = [[UITextView alloc] init];
            textView.font = midFont;
            textView.backgroundColor = bgColor;
            textView.contentInset = UIEdgeInsetsMake(0, 8, 0, -8);
            [Tools_F setViewlayer:textView cornerRadius:4 borderWidth:0 borderColor:nil];
            [cell addSubview:textView];
            
            [textView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.mas_top).with.offset(10);
                make.bottom.equalTo(cell.mas_bottom).with.offset(-10);
                make.left.equalTo(cell.mas_left).with.offset(viewWidth*3/10);
                make.right.equalTo(cell.mas_right).with.offset(-10);
            }];
        }
        
        if (industry == nil) {
            
            industry = [[UILabel alloc] init];
            industry.font = midFont;
            industry.textColor = lgrayColor;
            industry.textAlignment = NSTextAlignmentRight;
        }
        
        switch (indexPath.section) {
            case 0:
            {
                switch (indexPath.row) {
                    case 0:
                    {
                        brankNameTF = textView;
                    }
                        break;
                    default:
                    {
                        companyNameTF = textView;
                    }
                        break;
                }
            }
                break;
            case 1:
            {
                switch (indexPath.row) {
                    case 0:
                    {
                        brankPrincipalTF = textView;
                    }
                        break;
                    case 1:
                    {
                        jobTF = textView;
                    }
                        break;
                    default:
                    {
                        phoneTF = textView;
                        phoneTF.keyboardType = UIKeyboardTypePhonePad;
                    }
                        break;
                }
            }
                break;
            case 2:
            {
                switch (indexPath.row) {
                    case 0:
                    {
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        
                        textView.hidden = YES;
                        industry.text = @"请选择招商对象";
                        
                        [cell addSubview:industry];
                        
                        [industry mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(cell.mas_top).with.offset(10);
                            make.bottom.equalTo(cell.mas_bottom).with.offset(-10);
                            make.left.equalTo(cell.mas_left).with.offset(viewWidth*3/10);
                            make.right.equalTo(cell.mas_right).with.offset(-30);
                        }];
                    }
                        break;
                    case 1:
                    {
                        storeQTYTF = textView;
                        storeQTYTF.keyboardType = UIKeyboardTypeNumberPad;
                    }
                        break;
                    default:
                    {
                        companyAgeTF = textView;
                        companyAgeTF.keyboardType = UIKeyboardTypeNumberPad;
                    }
                        break;
                }
            }
                break;
            default:
            {
                brankIntroduceTF = textView;
            }
                break;
        }
    }
    
//    cell.textLabel.text = contentTitle[indexPath.section][indexPath.row];
    
    NSString *originalStr = contentTitle[indexPath.section][indexPath.row];
    NSMutableAttributedString *paintStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
    [paintStr addAttribute:NSForegroundColorAttributeName
                     value:tagsColor
                     range:[originalStr rangeOfString:@"*"]
     ];
    cell.textLabel.attributedText = paintStr;
    
    return cell;
}

#pragma mark - 点击cell (tableView)
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        
        [self.view endEditing:YES];
        [dropMenu.rightTableView reloadData];
        [dropMenu menuTapped];
    }
}

#pragma mark - FSDropDown datasource & delegate
- (NSInteger)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == menu.leftTableView) {
        
        if (currentModel) {
            
            return [currentModel.children count];
        }
        else {
            return 0;
        }
    }
    else {
        
        return [_industryAll count];
    }
}

- (NSString *)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView titleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == menu.leftTableView) {
        
        NSDictionary *tempDic = currentModel.children[indexPath.row];
        return tempDic[@"categoryName"];
    }
    else{
        
        FindBrankModel *model = _industryAll[indexPath.row];
        return model.categoryName;
    }
}

- (void)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == menu.leftTableView) {
        
        NSDictionary *tempDic = currentModel.children[indexPath.row];
        industry.text = tempDic[@"categoryName"];
        industryCategoryId2 = [tempDic[@"industryCategoryId"] integerValue];
        industry.text = tempDic[@"categoryName"];
        NSLog(@"%@",tempDic[@"categoryName"]);
    }
    else{
        
        FindBrankModel *model = _industryAll[indexPath.row];
        currentModel = model;
        industryCategoryId = [model.industryCategoryId integerValue];
        [menu.leftTableView reloadData];
    }
}

#pragma mark - 上传
- (void)uploadImage:(UIButton *)btn{
    
    imgType = (NSInteger)btn.tag-100;
    UIActionSheet *shotOrAlbums = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册中选择", nil];
    [shotOrAlbums showInView:self.view];
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
    
    [self showLoading:0];
    [HttpTool uploadWithBaseURL:SDD_MainURL Path:@"/upload/images.do" params:nil dataName:@"images" AlbumImage:imageNew success:^(id responseObject) {
        
        [self hideLoading];
        NSDictionary *dict = responseObject;
        NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
        if (![dict[@"data"] isEqual:[NSNull null]]) {
            
             // 0:身份证url 1:名片url 2:营业执照url 3:品牌LOGOurl
            switch (imgType) {
                case 0:
                {
                    idCardImage = dict[@"data"][0];
                    UIButton *btn = (UIButton *)[table.tableFooterView viewWithTag:100];
                    [btn setBackgroundImage:imageNew forState:UIControlStateNormal];
                }
                    break;
                case 1:
                {
                    businessLicenseImage = dict[@"data"][0];
                    UIButton *btn = (UIButton *)[table.tableFooterView viewWithTag:101];
                    [btn setBackgroundImage:imageNew forState:UIControlStateNormal];
                }
                    break;
                case 2:
                {
                    businessCardImage = dict[@"data"][0];
                    UIButton *btn = (UIButton *)[table.tableFooterView viewWithTag:102];
                    [btn setBackgroundImage:imageNew forState:UIControlStateNormal];
                }
                    break;
                case 3:
                {
                    brandLogoImage = dict[@"data"][0];
                    UIButton *btn = (UIButton *)[table.tableFooterView viewWithTag:103];
                    [btn setBackgroundImage:imageNew forState:UIControlStateNormal];
                }
                    break;
                default:
                    break;
            }
        }
        
    } fail:^{
        
        [self showErrorWithText:@"上传失败"];
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 提交
- (void)commitAction:(UIButton *)btn{
   
    if (brankNameTF.text.length<1 || companyNameTF.text.length<1 || brankPrincipalTF.text.length<1 ||
        jobTF.text.length<1 || phoneTF.text.length<1 || storeQTYTF.text.length<1 ||companyAgeTF.text.length<1 ||
        brankIntroduceTF.text.length<1 || idCardImage || businessLicenseImage || businessCardImage ||
        brandLogoImage || !industryCategoryId || !industryCategoryId2) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入完整信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (![Tools_F validateMobile:phoneTF.text]){

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入有效的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        
        // 请求参数
        NSDictionary *param = @{
                                @"businessLife":companyAgeTF.text,
                                @"industryCategoryId1":[NSNumber numberWithInteger:industryCategoryId],
                                @"industryCategoryId2":[NSNumber numberWithInteger:industryCategoryId2],
                                @"companyName":companyNameTF.text,
                                @"phone":phoneTF.text,
                                @"brandName":brankNameTF.text,
                                @"storeAmount":storeQTYTF.text,
                                @"brandContacts":brankPrincipalTF.text,
                                @"brandDescription":brankIntroduceTF.text,
                                @"jobTitle":jobTF.text,
                                
//                                四个图片的上传在这里取消掉了
//                                @"idCardImage":idCardImage,
//                                @"businessLicenseImage":businessLicenseImage,
//                                @"businessCardImage":businessCardImage,
//                                @"brandLogoImage":brandLogoImage,
                                };
        
//        NSLog(@"~~~~~%@",param);
        
        [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brandApprove/addApprove.do" params:param success:^(id JSON) {
            
            NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
            
            if ([JSON[@"status"] intValue] == 1) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"亲爱的用户，提交成功，您可以在“我的-我的认证”中查看"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } failure:^(NSError *error) {
            NSLog(@">>>>>>>%@",error);
        }];
    }
}

#pragma mark - leftaction
- (void)leftAction:(UIButton *)btn{
    
    NSLog(@"返回");
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
