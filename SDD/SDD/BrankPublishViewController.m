//
//  BrankPublishViewController.m
//  SDD
//
//  Created by hua on 15/7/3.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "BrankPublishViewController.h"

#import "FindBrankModel.h"

#import "FSDropDownMenu.h"
#import "UIButton+WebCache.h"

typedef NS_ENUM(NSInteger, ColumnType)
{
    exRegionType = 0,
    industryType = 1,
    investmentAmountsType = 2
};

@interface BrankPublishViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,FSDropDownMenuDataSource,FSDropDownMenuDelegate>{
    
    /*- ui -*/
    
    UITableView *table;
    FSDropDownMenu *dropMenu;
    
    UILabel *exRegion;
    UILabel *industry;
    UILabel *investmentAmounts;
    
    UITextView *brankNameTF;                        // 品牌名称
    UITextView *brankPrincipalTF;                   // 品牌负责人
    UITextView *phoneTF;                            // 手机号码
    UITextView *storeQTYTF;                         // 门店数量
    UIButton *upLoadImg;                            // 上传图片
    
    /*- data -*/
    
    FindBrankModel *currentModel;
    FindBrankModel *currentModel2;
    
    NSArray *contentTitle;
    
    NSString *brandImage;                       // 品牌图片url
    NSInteger expandingRegion;
    NSInteger industryCategoryId;
    NSInteger industryCategoryId2;
    NSInteger investmentAmountCategoryId;
    
    ColumnType columntype;
}

// 区位位置
@property (nonatomic, strong) NSMutableArray *regionalLocation;  //←命名有歧义，有空改
// 招商对象
@property (nonatomic, strong) NSMutableArray *industryAll;
// 省份、城市列表
@property (nonatomic, strong) NSMutableArray *province;
@property (nonatomic, strong) NSMutableArray *city;

@end

@implementation BrankPublishViewController

- (NSMutableArray *)regionalLocation{
    if (!_regionalLocation) {
        _regionalLocation = [[NSMutableArray alloc]init];
    }
    return _regionalLocation;
}

- (NSMutableArray *)industryAll{
    if (!_industryAll) {
        _industryAll = [[NSMutableArray alloc]init];
    }
    return _industryAll;
}

- (NSMutableArray *)province{
    if (!_province) {
        _province = [[NSMutableArray alloc]init];
    }
    return _province;
}

- (NSMutableArray *)city{
    if (!_city) {
        _city = [[NSMutableArray alloc]init];
    }
    return _city;
}

#pragma mark - 请求数据
- (void)requestData{
    
    NSDictionary *param = @{};    // 请求参数
    
    // 投资额度
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brandCategory/investmentAmountCategoryList.do" params:param success:^(id JSON) {
        
        //        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSArray *dict = JSON[@"data"];
        
        if (![dict isEqual:[NSNull null]]) {
            
            [_regionalLocation removeAllObjects];
            
            // 第一个不限
            NSDictionary *firstDic = @{@"categoryName": @"不限",
                                       @"investmentAmountCategoryId": @0};
            FindBrankModel *model = [FindBrankModel findBrankWithDict:firstDic];
            [self.regionalLocation addObject:model];
            
            for (NSDictionary *tempDic in dict) {
                
                FindBrankModel *model = [FindBrankModel findBrankWithDict:tempDic];
                [self.regionalLocation addObject:model];
            }
        }
    } failure:^(NSError *error) {
        
    }];
    
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
    
    param = @{@"parentId":@1};
    
    // 省市
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/houseRegion/list.do" params:param success:^(id JSON) {
        
//        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSDictionary *dict = JSON[@"data"];
        
        if (![dict isEqual:[NSNull null]]) {
            
            [_province removeAllObjects];
            BOOL flag = NO;
            for (NSDictionary *tempDic in dict) {
                flag = YES;
                FindBrankModel *model = [FindBrankModel findBrankWithDict:tempDic];
                [self.province addObject:model];
            }
            FindBrankModel *model = _province[0];
            currentModel2 = flag?model:nil;
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    brandImage = @"";
    
    // 维度选择
    [self requestData];
    // 导航条
    [self setupNav];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置导航条
- (void)setupNav{

    [self setNav:@"品牌发布"];
    
//    UIButton *commit = [[UIButton alloc] init];
//    commit.frame = CGRectMake(0, 0, 50, 44);
//    commit.titleLabel.font = largeFont;
//    [commit setTitle:@"提交" forState:UIControlStateNormal];
//    [commit addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:commit];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    contentTitle = @[@[@"*品牌名称",@"*招商对象"],
                     @[@"*投资额度",@"*门店数量",@"*拓展区域"],
                     @[@"*品牌联系人",@"*联系电话"],
                     @[@"上传图片 (有照片的品牌更容易通过哦)"]
                     ];
    
    // table
    table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    table.backgroundColor = bgColor;
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    // 栏目选择
    dropMenu = [[FSDropDownMenu alloc] initWithOrigin:CGPointMake(0, viewHeight-300-64) andHeight:300];
    //    _menu.transformView = transformView;
    dropMenu.dataSource = self;
    dropMenu.delegate = self;
    [self.view addSubview:dropMenu];
    
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // footer
    UIView *footer_bg = [[UIView alloc] init];
    footer_bg.frame = CGRectMake(0, 0, viewWidth, 65);
    footer_bg.backgroundColor = bgColor;
    
    // 报名按钮
    ConfirmButton *sendButton = [[ConfirmButton alloc] initWithFrame:CGRectMake(20, 10, viewWidth - 40, 45)
                                                                       title:@"提交"
                                                                      target:self
                                                                      action:@selector(commitAction:)];
    sendButton.enabled = YES;
    [footer_bg addSubview:sendButton];
    
    table.tableFooterView = footer_bg;
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 3) {
        
        return 115;
    }
    else {
        
        return 50;
    }
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:{
            
            return 2;
        }
            break;
        case 1:{
            
            return 3;
        }
            break;
        case 2:{
            
            return 2;
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
    static NSString *identifier = @"BrankPublish";
    //重用机制
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
    
    UILabel *label;
    UITextView *textView;
    
    if (cell == nil) {
        // 当不存在的时候用重用标识符生成
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
        
        if (label == nil) {
            
            label = [[UILabel alloc] init];
            label.hidden = YES;
            label.font = midFont;
            label.textColor = lgrayColor;
            label.textAlignment = NSTextAlignmentRight;
            
            [cell addSubview:label];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.mas_top).with.offset(10);
                make.bottom.equalTo(cell.mas_bottom).with.offset(-10);
                make.left.equalTo(cell.mas_left).with.offset(viewWidth*3/10);
                make.right.equalTo(cell.mas_right).with.offset(-30);
            }];
        }
        
        if (upLoadImg == nil){
            
            upLoadImg = [UIButton buttonWithType:UIButtonTypeCustom];
            [upLoadImg setBackgroundImage:[UIImage imageNamed:@"join_brand_icon_upload-pictures"] forState:UIControlStateNormal];
            [upLoadImg addTarget:self action:@selector(uploadImage:) forControlEvents:UIControlEventTouchUpInside];
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
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        textView.hidden = YES;
                        label.hidden = NO;
                        industry = label;
                        industry.text = @"请选择招商对象";
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
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        textView.hidden = YES;
                        label.hidden = NO;
                        investmentAmounts = label;
                        investmentAmounts.text = @"请选择投资额度";
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
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        textView.hidden = YES;
                        label.hidden = NO;
                        exRegion = label;
                        exRegion.text = @"请选择拓展区域";
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
                        brankPrincipalTF = textView;
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
            default:
            {
                textView.hidden = YES;
                cell.textLabel.hidden = YES;
                
                [cell addSubview:upLoadImg];
                
                UILabel *lastLabel = [[UILabel alloc] init];                
                
                lastLabel.text = contentTitle[indexPath.section][indexPath.row];
                lastLabel.font = midFont;
                [cell addSubview:lastLabel];
                
                [lastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(cell.mas_top).with.offset(18);
                    make.left.equalTo(cell.mas_left).with.offset(15);
                    make.right.equalTo(cell.mas_right).with.offset(-15);
                }];
                
                [upLoadImg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(cell.mas_bottom).with.offset(-10);
                    make.left.equalTo(cell.mas_left).with.offset(15);
                    make.size.mas_equalTo(CGSizeMake(60, 60));
                }];
            }
                break;
        }
    }
    
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    
                }
                    break;
                default:
                {
                    [self.view endEditing:YES];
                    columntype = industryType;
                    [dropMenu.rightTableView reloadData];
                    [dropMenu menuTapped];
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
                    [self.view endEditing:YES];
                    columntype = investmentAmountsType;
                    [dropMenu.rightTableView reloadData];
                    [dropMenu menuTapped];
                }
                    break;
                case 1:
                {
                    
                }
                    break;
                default:
                {
                    [self.view endEditing:YES];
                    columntype = exRegionType;
                    [dropMenu.rightTableView reloadData];
                    [dropMenu menuTapped];
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
                    
                }
                    break;
                default:
                {
                    
                }
                    break;
            }
        }
            break;
        default:
        {
            
        }
            break;
    }
}

#pragma mark - FSDropDown datasource & delegate
- (NSInteger)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == menu.leftTableView) {
        
        switch (columntype) {
            case exRegionType:{
                if (_city) {
                    
                    return [_city count];
                }
                else {
                    return 0;
                }
            }
                break;
            case industryType:{
                if (currentModel) {
                    
                    return [currentModel.children count];
                }
                else {
                    return 0;
                }
            }
                break;
            case investmentAmountsType:{
                
                return [_regionalLocation count];
            }
                break;
        }
    }
    else {
        
        switch (columntype) {
            case exRegionType:{
                
                return [_province count];
            }
                break;
            case industryType:{
                
                return [_industryAll count];
            }
                break;
            case investmentAmountsType:{
                
                return 1;
            }
                break;
        }
    }
}

- (NSString *)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView titleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == menu.leftTableView) {
        
        switch (columntype) {
            case exRegionType:{
                
                FindBrankModel *model = _city[indexPath.row];
                return model.regionName;
            }
                break;
            case industryType:{
                
                NSDictionary *tempDic = currentModel.children[indexPath.row];
                return tempDic[@"categoryName"];
            }
                break;
            case investmentAmountsType:{
                
                FindBrankModel *model = _regionalLocation[indexPath.row];
                return model.categoryName;
            }
                break;
        }
    }
    else{
        
        switch (columntype) {
            case exRegionType:{
                
                FindBrankModel *model = _province[indexPath.row];
                return model.regionName;
            }
                break;
            case industryType:{
                
                FindBrankModel *model = _industryAll[indexPath.row];
                return model.categoryName;
            }
                break;
            case investmentAmountsType:{
                
                return @"投资额度";
            }
                break;
        }
    }
}

- (void)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == menu.leftTableView) {
        
        switch (columntype) {
            case exRegionType:{
                
                FindBrankModel *model = _city[indexPath.row];
                exRegion.text = model.regionName;
                expandingRegion = [model.regionId integerValue];
            }
                break;
            case industryType:{
                
                NSDictionary *tempDic = currentModel.children[indexPath.row];
                industry.text = tempDic[@"categoryName"];
                industryCategoryId2 = [tempDic[@"industryCategoryId"] integerValue];
            }
                break;
            case investmentAmountsType:{
                
                FindBrankModel *model = _regionalLocation[indexPath.row];
                investmentAmounts.text = model.categoryName;
                investmentAmountCategoryId = [model.investmentAmountCategoryId integerValue];
            }
                break;
        }
    }
    else{
        
        switch (columntype) {
            case exRegionType:{
                
                FindBrankModel *model = _province[indexPath.row];
                [self requestCityWithID:[model.regionId integerValue]];
            }
                break;
            case industryType:{
                
                FindBrankModel *model = _industryAll[indexPath.row];
                industryCategoryId = [model.industryCategoryId integerValue];
                currentModel = model;
            }
                break;
            case investmentAmountsType:{
                
            }
                break;
        }
        [menu.leftTableView reloadData];
    }
}

- (void)requestCityWithID:(NSInteger)parentId{
    
    NSDictionary *param = @{@"parentId":[NSNumber numberWithInteger:parentId]};
    
    // 省市
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/houseRegion/list.do" params:param success:^(id JSON) {
        
//        NSLog(@"%@>>>>>>>%@ ",JSON[@"message"],JSON);
        NSDictionary *dict = JSON[@"data"];
        
        if (![dict isEqual:[NSNull null]]) {
            
            [_city removeAllObjects];
            BOOL flag = NO;
            for (NSDictionary *tempDic in dict) {
                flag = YES;
                FindBrankModel *model = [FindBrankModel findBrankWithDict:tempDic];
                [self.city addObject:model];
            }
            [dropMenu.leftTableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 上传图片
- (void)uploadImage:(UIButton *)btn{
    
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
            
            brandImage = dict[@"data"][0];
            [upLoadImg setBackgroundImage:imageNew forState:UIControlStateNormal];
        }
        
    } fail:^{
        
        [self showErrorWithText:@"上传失败"];
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 提交
- (void)commitAction:(UIButton *)btn{
    
    if (brankNameTF.text.length<1 || brankPrincipalTF.text.length<1 || phoneTF.text.length<1 ||
        storeQTYTF.text.length<1 ||!industryCategoryId || !industryCategoryId2 ||
        !investmentAmountCategoryId || !expandingRegion) {
        
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
                                @"brandContacts":brankPrincipalTF.text,
                                @"brandName":brankNameTF.text,
                                @"defaultImage": brandImage,
                                @"industryCategoryId1":[NSNumber numberWithInteger:industryCategoryId],
                                @"industryCategoryId2":[NSNumber numberWithInteger:industryCategoryId2],
                                @"investmentAmountCategoryId":[NSNumber numberWithInteger:investmentAmountCategoryId],
                                @"phone":phoneTF.text,
                                @"regionIds":@[[NSNumber numberWithInteger:expandingRegion]],
                                @"storeAmount": storeQTYTF.text,
                                };
//        NSLog(@"````````%@",param);
        [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brandFirst/save.do" params:param success:^(id JSON) {
            
            NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
            
            if ([JSON[@"status"] intValue] == 1) {
    
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:JSON[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            else {
                
                [self showErrorWithText:JSON[@"message"]];
            }
            
        } failure:^(NSError *error) {
            
            [self showErrorWithText:[NSString stringWithFormat:@"%@",error]];
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    [self.navigationController popViewControllerAnimated:YES];
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
