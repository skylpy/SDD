//
//  GetCouponViewController.m
//  SDD
//
//  Created by hua on 15/7/22.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "GetCouponViewController.h"
#import "GetCouponTableViewCell.h"
#import "FindBrankModel.h"

#import "SuccessReceiveViewController.h"

#import "FSDropDownMenu.h"
#import "LPlaceholderTextView.h"

typedef NS_ENUM(NSInteger, ColumnType)
{
    industryType = 0,
    investmentAmountsType = 1,
    jobType = 2
};

@interface GetCouponViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,
FSDropDownMenuDataSource,FSDropDownMenuDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>{
    
    /*- ui -*/
    
    UITableView *table;
    FSDropDownMenu *dropMenu;
    
    UIButton *getCode;                                         /**< 获取验证码 */
    
    UILabel *industry_Label;                                   /**< 行业类别 */
    UILabel *investmentAmounts_Label;                          /**< 投资额度 */
    UILabel *jobType_Label;                                    /**< 职务类别 */
    
    LPlaceholderTextView *name_TextView;                       /**< 姓名 */
    LPlaceholderTextView *phone_TextView;                      /**< 手机号 */
    LPlaceholderTextView *code_TextView;                       /**< 验证码 */
    LPlaceholderTextView *company_TextView;                    /**< 公司 */
    LPlaceholderTextView *franchiseBrands_TextView;            /**< 经营品牌 */
    LPlaceholderTextView *address_TextView;                    /**< 有无场地 */
    LPlaceholderTextView *pastBackground_TextView;             /**< 过去背景 */
    
    /*- data -*/
    
    NSTimer *timer;           //倒计时
    NSInteger second;               //秒数

    NSArray *contentTitle;                           /**< 表格标题 */
    
    NSInteger gender;                                /**< 性别 */
    NSInteger brandCustomerCategoryId;               /**< 类别 */
    NSInteger postCategoryId;                        /**< 职务 */
    NSInteger industryCategoryId;                    /**< 行业品类1 */
    NSInteger industryCategoryId2;                   /**< 行业品类2 */
    NSInteger investmentAmountCategoryId;            /**< 投资能力 */
    
    FindBrankModel *currentModel;
    
    ColumnType columntype;
    
    UIButton *imgButton;//图片选择
    
    NSString * addressImage;
}

// 行业类别
@property (nonatomic, strong) NSMutableArray *industryAll;
// 投资额度
@property (nonatomic, strong) NSMutableArray *investmentAmount;
// 省份、城市列表
@property (nonatomic, strong) NSMutableArray *jobTypeAll;

@end

@implementation GetCouponViewController

- (NSMutableArray *)industryAll{
    if (!_industryAll) {
        _industryAll = [[NSMutableArray alloc]init];
    }
    return _industryAll;
}

- (NSMutableArray *)investmentAmount{
    if (!_investmentAmount) {
        _investmentAmount = [[NSMutableArray alloc]init];
    }
    return _investmentAmount;
}

- (NSMutableArray *)jobTypeAll{
    if (!_jobTypeAll) {
        _jobTypeAll = [[NSMutableArray alloc]init];
    }
    return _jobTypeAll;
}

#pragma mark - 请求数据
- (void)requestData{
    
    NSDictionary *param = @{};    // 请求参数
    
    // 投资额度
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brandCategory/investmentAmountCategoryList.do" params:param success:^(id JSON) {
        
        //        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSArray *dict = JSON[@"data"];
        
        if (![dict isEqual:[NSNull null]]) {
            
            [_investmentAmount removeAllObjects];
            
            // 第一个不限
            NSDictionary *firstDic = @{@"categoryName": @"不限",
                                       @"investmentAmountCategoryId": @0};
            FindBrankModel *model = [FindBrankModel findBrankWithDict:firstDic];
            [self.investmentAmount addObject:model];
            
            for (NSDictionary *tempDic in dict) {
                
                FindBrankModel *model = [FindBrankModel findBrankWithDict:tempDic];
                [self.investmentAmount addObject:model];
            }
        }
    } failure:^(NSError *error) {
        
    }];
    
    // 行业类别
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
    
    // 职务
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/houseFirstCategory/userPostCategorys.do" params:nil success:^(id JSON) {
        
//        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSDictionary *dict = JSON[@"data"];
        
        if (![dict isEqual:[NSNull null]]) {
            
            [_jobTypeAll removeAllObjects];
            
            for (NSDictionary *tempDic in dict) {
                
                FindBrankModel *model = [FindBrankModel findBrankWithDict:tempDic];
                [self.jobTypeAll addObject:model];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

/**< 快速单选选项 */
- (void)quicklyRadioButton:(UIButton *)btn Tag:(NSInteger)theTag Title:(NSString *)string{
    
    btn.tag = theTag;
    btn.titleLabel.font = midFont;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"join_btn_coupons_unSelected"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"join_btn_coupons_selected"] forState:UIControlStateSelected];
    [btn setTitle:string forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    // 初始化
    gender = 1;
    brandCustomerCategoryId = 1;
    second = 60;
    
    // 维度选择
    [self requestData];
    // 导航条
    [self setupNav];

    // 设置内容
    [self setupUI];
    addressImage = @"";
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
            addressImage = dict[@"data"][0];
//            NSLog(@"imageStr%@",imageStr);
        }
        
    } fail:^{
        
        [self showErrorWithText:@"上传失败"];
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 设置导航条
- (void)setupNav{
    
    SDDButton *button = [[SDDButton alloc]init];
    button.frame = CGRectMake(0, 0, 100, 44);
    [button setTitle:@"我要加盟" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

#pragma mark - 设置内容0.
- (void)setupUI{
    
    
    imgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [imgButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"upload-the-whole-rendering_icon"]] forState:UIControlStateNormal];
    [imgButton addTarget:self action:@selector(uploadImage:) forControlEvents:UIControlEventTouchUpInside];
    
    contentTitle = @[@[_discountCoupons[@"maxPreferentialStr"]],
                     @[@"*姓名",@"*性别",@"*手机号",@"验证码"],
                    @[@"*公司",@"*职务"],
                     @[@"*类别",@"*经营品牌",@"*行业品类",@"*投资能力",@"*有无场地",@"场地图片",@"*过去背景"]
                     ];
    
    // table
    table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    table.backgroundColor = bgColor;
    table.delegate = self;
    table.dataSource = self;
    
    [self.view addSubview:table];
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // head
    UIView *headView = [[UIView alloc] init];
    headView.frame = CGRectMake(0, 0, viewWidth, 100);
    headView.backgroundColor = [UIColor whiteColor];
    
    UILabel *couponTitle = [[UILabel alloc] init];
    couponTitle.textAlignment = NSTextAlignmentCenter;
    couponTitle.font = largeFont;
    NSString *originalStr = [NSString stringWithFormat:@"%@%.1f折加盟",_brankName,
                             [_discountCoupons[@"discount"] floatValue]];
    NSMutableAttributedString *paintStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
    [paintStr addAttribute:NSForegroundColorAttributeName
                     value:lorangeColor
                     range:[originalStr rangeOfString:[NSString stringWithFormat:@"%.1f折",
                                                       [_discountCoupons[@"discount"] floatValue]]]
     ];
    couponTitle.attributedText = paintStr;
    
    UILabel *validityDate = [[UILabel alloc] init];
    validityDate.textAlignment = NSTextAlignmentCenter;
    validityDate.font = midFont;
    validityDate.textColor = lgrayColor;
    validityDate.text = [NSString stringWithFormat:@"有效期至: %@",[Tools_F timeTransform:[_discountCoupons[@"endTime"] intValue] time:days]];
    
    [headView addSubview:couponTitle];
    [couponTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headView);
        make.centerY.equalTo(headView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 16));
    }];
    
    [headView addSubview:validityDate];
    [validityDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(couponTitle.mas_bottom).offset(10);
        make.centerX.equalTo(headView);
        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 13));
    }];
    
    table.tableHeaderView = headView;
    
    // footer
    UIView *footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, viewWidth, 105);
    footerView.backgroundColor = bgColor;
    
    UIButton *readOrNo = [UIButton buttonWithType:UIButtonTypeCustom];
    [Tools_F commonWithButton:readOrNo
                         font:nil
                        title:nil
                selectedTitle:nil
                   titleColor:nil
           selectedtitleColor:nil
                backgroundImg:[UIImage imageNamed:@"join_btn_ coupons_unSelected"]
        selectedBackgroundImg:[UIImage imageNamed:@"join_btn_ coupons_selected"]
                       target:self
                       action:@selector(read:)];
    readOrNo.selected = YES;
    
    UILabel *agreement = [[UILabel alloc] init];
    agreement.font = midFont;
    originalStr = @"我已阅读并同意商多多品牌加盟协议";
    paintStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
    [paintStr addAttributes:@{NSForegroundColorAttributeName: [SDDColor colorWithHexString:@"#008fec"]
                              }
                      range:[originalStr rangeOfString:@"商多多品牌加盟协议"]];
    [paintStr addAttributes:@{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]
                              }
                      range:[originalStr rangeOfString:@"商多多品牌加盟协议"]];
    agreement.attributedText = paintStr;
    
    UIButton *takeItNow = [UIButton buttonWithType:UIButtonTypeCustom];
    takeItNow.backgroundColor = [SDDColor colorWithHexString:@"#008fec"];
    [takeItNow setTitle:@"提交" forState:UIControlStateNormal];
    [takeItNow addTarget:self action:@selector(takeItNow:) forControlEvents:UIControlEventTouchUpInside];
    [Tools_F setViewlayer:takeItNow cornerRadius:20 borderWidth:0 borderColor:nil];
    
    [footerView addSubview:readOrNo];
    [readOrNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerView.mas_top).offset(5);
        make.left.equalTo(footerView.mas_left).offset(4);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [footerView addSubview:agreement];
    [agreement mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(readOrNo);
        make.left.equalTo(readOrNo.mas_right);
        make.size.mas_equalTo(CGSizeMake(viewWidth-48, 13));
    }];
    
    [footerView addSubview:takeItNow];
    [takeItNow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(agreement.mas_bottom).offset(29);
        make.centerX.equalTo(footerView);
        make.size.mas_equalTo(CGSizeMake(viewWidth-20, 40));
    }];
    
    table.tableFooterView = footerView;
    
    // 栏目选择
    dropMenu = [[FSDropDownMenu alloc] initWithOrigin:CGPointMake(0, viewHeight-300-64) andHeight:300];
    //    _menu.transformView = transformView;
    dropMenu.dataSource = self;
    dropMenu.delegate = self;
    [self.view addSubview:dropMenu];
//
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 3) {
        
        if (indexPath.row == 4|| indexPath.row == 5||indexPath.row == 6) {
            
            return 125;
        }
        else {
            
            return 50;
        }
    }
    else {
        
        return 50;
    }
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:{
            
            return 1;
        }
            break;
        case 1:{
            
            return 4;
        }
            break;
        case 2:{
            
            return 2;
        }
            break;
        default:{
            
            return 7;
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
    
    return 10;
}

#pragma mark - 设置section 脚高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}

#pragma mark - 设置cell (tableView)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //重用标识符
    NSString *identifier = [NSString stringWithFormat:@"GetCoupon%d%d",(int)indexPath.section,(int)indexPath.row];
//    static NSString *identifier = @"GetCoupon";
    //重用机制
    GetCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
    
    if (cell == nil) {
        // 当不存在的时候用重用标识符生成
        cell = [[GetCouponTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
        cell.textLabel.font = midFont;
        
        switch (indexPath.section) {
            case 0:{
                cell.cellType = nothing;
            }
                break;
            case 1:{
                switch (indexPath.row) {
                    case 0:{
                        
                        cell.cellType = withTextView;
                        name_TextView = cell.theTextView;
                    }
                        break;
                    case 1:{
                        
                        cell.cellType = nothing;
                        
                        UIButton *male = [UIButton buttonWithType:UIButtonTypeCustom];
                        [self quicklyRadioButton:male Tag:100 Title:@" 男"];
                        [male addTarget:self action:@selector(genderAction:) forControlEvents:UIControlEventTouchUpInside];
                        male.selected = YES;
                        
                        UIButton *female = [UIButton buttonWithType:UIButtonTypeCustom];
                        [self quicklyRadioButton:female Tag:101 Title:@" 女"];
                        [female addTarget:self action:@selector(genderAction:) forControlEvents:UIControlEventTouchUpInside];
                        
                        [cell addSubview:male];
                        [male mas_makeConstraints:^(MASConstraintMaker *make) {
                            
                            make.top.equalTo(cell.mas_top).with.offset(13.75);
                            make.bottom.equalTo(cell.mas_bottom).with.offset(-13.75);
                            make.left.equalTo(cell.mas_left).with.offset(viewWidth*3/10);
                            make.width.equalTo(@50);
                        }];
                        
                        [cell addSubview:female];
                        [female mas_makeConstraints:^(MASConstraintMaker *make) {
                            
                            make.top.equalTo(cell.mas_top).with.offset(13.75);
                            make.bottom.equalTo(cell.mas_bottom).with.offset(-13.75);
                            make.left.equalTo(male.mas_right).with.offset(30);
                            make.width.equalTo(@50);
                        }];
                    }
                        break;
                    case 2:{
                        
                        cell.cellType = withTextView;
                        phone_TextView = cell.theTextView;
                        phone_TextView.keyboardType = UIKeyboardTypeNumberPad;
                    }
                        break;
                    default:{
                        
                        cell.cellType = withShortTextView;
                        code_TextView = cell.theTextView;
                        code_TextView.keyboardType = UIKeyboardTypeNumberPad;
                        
                        getCode = [UIButton buttonWithType:UIButtonTypeCustom];
                        getCode.titleLabel.font = midFont;
                        [getCode setTitleColor:[SDDColor colorWithHexString:@"#008fec"] forState:UIControlStateNormal];
                        [getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                        [Tools_F setViewlayer:getCode cornerRadius:4 borderWidth:1 borderColor:[SDDColor colorWithHexString:@"#008fec"]];
                        [getCode addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
                        
                        [cell addSubview:getCode];
                        [getCode mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(cell.mas_top).with.offset(10);
                            make.bottom.equalTo(cell.mas_bottom).with.offset(-10);
                            make.right.equalTo(cell.mas_right).offset(-10);
                            make.width.equalTo(@105);
                        }];
                    }
                        break;
                }
            }
                break;
            case 2:{
                switch (indexPath.row) {
                    case 0:{
                        
                        cell.cellType = withTextView;
                        company_TextView = cell.theTextView;
                    }
                        break;
                    default:{
                        
                        cell.cellType = withLabel;
                        jobType_Label = cell.theSelected;
                        jobType_Label.text = @"请选择您的职务";
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    }
                        break;
                }
            }
                break;
            default:{
                switch (indexPath.row) {
                    case 0:{
                        
                        cell.cellType = nothing;
                        
                        UIButton *franchiser = [UIButton buttonWithType:UIButtonTypeCustom];
                        [self quicklyRadioButton:franchiser Tag:100 Title:@" 经销商"];
                        [franchiser addTarget:self action:@selector(typeAction:) forControlEvents:UIControlEventTouchUpInside];
                        franchiser.selected = YES;
                        
                        UIButton *investor = [UIButton buttonWithType:UIButtonTypeCustom];
                        [self quicklyRadioButton:investor Tag:101 Title:@" 投资客"];
                        [investor addTarget:self action:@selector(typeAction:) forControlEvents:UIControlEventTouchUpInside];
                        
                        UIButton *otherType = [UIButton buttonWithType:UIButtonTypeCustom];
                        [self quicklyRadioButton:otherType Tag:102 Title:@" 其他"];
                        [otherType addTarget:self action:@selector(typeAction:) forControlEvents:UIControlEventTouchUpInside];
                        
                        [cell addSubview:franchiser];
                        [franchiser mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(cell.mas_top).with.offset(13.75);
                            make.bottom.equalTo(cell.mas_bottom).with.offset(-13.75);
                            make.left.equalTo(cell.mas_left).with.offset(viewWidth*3/10);
                            make.width.equalTo(@80);
                        }];
                        
                        [cell addSubview:investor];
                        [investor mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(cell.mas_top).with.offset(13.75);
                            make.bottom.equalTo(cell.mas_bottom).with.offset(-13.75);
                            make.left.equalTo(franchiser.mas_right).offset(10);
                            make.width.equalTo(@80);
                        }];
                        
                        [cell addSubview:otherType];
                        [otherType mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(cell.mas_top).with.offset(13.75);
                            make.bottom.equalTo(cell.mas_bottom).with.offset(-13.75);
                            make.left.equalTo(investor.mas_right).offset(10);
                            make.width.equalTo(@80);
                        }];

                    }
                        break;
                    case 1:{
                        
                        cell.cellType = withTextView;
                        franchiseBrands_TextView = cell.theTextView;
                    }
                        break;
                    case 2:{
                        
                        cell.cellType = withLabel;
                        industry_Label = cell.theSelected;
                        industry_Label.text = @"请选择您的行业品类";
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    }
                        break;
                    case 3:{
                        
                        cell.cellType = withLabel;
                        investmentAmounts_Label = cell.theSelected;
                        investmentAmounts_Label.text = @"请选择您的投资能力";
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    }
                        break;
                    case 4:{
                        
                        cell.cellType = withLongTextView;
                        address_TextView = cell.theTextView;
                        address_TextView.placeholderText = @"请输入您的场地地址，没有场地直接填无";
                    }
                        break;
                    case 5:
                    {
                        cell.theTextView.hidden = YES;
                        [cell addSubview:imgButton];
                        [imgButton mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(cell.mas_top).with.offset(40);
                            make.left.equalTo(cell.mas_left).with.offset(15);
                            make.width.equalTo(@70);
                            make.height.equalTo(@70);
                        }];
                    }
                        break;
                    default:{
                        
                        cell.cellType = withLongTextView;
                        pastBackground_TextView = cell.theTextView;
                        pastBackground_TextView.placeholderText = @"请输入您的过去背景";
                    }
                        break;
                }
            }
                break;
        }
    }

    NSString *originalStr = contentTitle[indexPath.section][indexPath.row];
    NSMutableAttributedString *paintStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
    [paintStr addAttributes:@{NSForegroundColorAttributeName: deepOrangeColor} range:[originalStr rangeOfString:@"*"]];

    cell.theTitle.attributedText = paintStr;
    
    return cell;
}

#pragma mark - 点击cell (tableView)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2 && indexPath.row == 1) {
        
        [self.view endEditing:YES];
        columntype = jobType;
        [dropMenu.rightTableView reloadData];
        [dropMenu menuTapped];
    }
    else if (indexPath.section == 3 && indexPath.row == 2){
        
        [self.view endEditing:YES];
        columntype = industryType;
        [dropMenu.rightTableView reloadData];
        [dropMenu menuTapped];
    }
    else if (indexPath.section == 3 && indexPath.row == 3){
        
        [self.view endEditing:YES];
        columntype = investmentAmountsType;
        [dropMenu.rightTableView reloadData];
        [dropMenu menuTapped];
    }
}

#pragma mark - FSDropDown datasource & delegate
- (NSInteger)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == menu.leftTableView) {
        
        switch (columntype) {
            case jobType:{
                
                return [_jobTypeAll count];
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
                
                return [_investmentAmount count];
            }
                break;
        }
    }
    else {
        
        switch (columntype) {
            case jobType:{
                
                return 1;
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
            case jobType:{
                
                FindBrankModel *model = _jobTypeAll[indexPath.row];
                return model.categoryName;
            }
                break;
            case industryType:{
                
                NSDictionary *tempDic = currentModel.children[indexPath.row];
                return tempDic[@"categoryName"];
            }
                break;
            case investmentAmountsType:{
                
                FindBrankModel *model = _investmentAmount[indexPath.row];
                return model.categoryName;
            }
                break;
        }
    }
    else{
        
        switch (columntype) {
            case jobType:{
                
                return @"职务";
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
            case jobType:{
                
                FindBrankModel *model = _jobTypeAll[indexPath.row];
                jobType_Label.text = model.categoryName;
                postCategoryId = [model.postCategoryId integerValue];
            }
                break;
            case industryType:{
                
                NSDictionary *tempDic = currentModel.children[indexPath.row];
                industry_Label.text = tempDic[@"categoryName"];
                industryCategoryId2 = [tempDic[@"industryCategoryId"] integerValue];
            }
                break;
            case investmentAmountsType:{
                
                FindBrankModel *model = _investmentAmount[indexPath.row];
                investmentAmounts_Label.text = model.categoryName;
                investmentAmountCategoryId = [model.investmentAmountCategoryId integerValue];
            }
                break;
        }
    }
    else{
        
        switch (columntype) {
            case jobType:{
                
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

#pragma mark - 性别
- (void)genderAction:(UIButton *)btn{
    
    BOOL isMan = (NSInteger)btn.tag == 100?YES:NO;
    
    UIButton *other = (UIButton *)[btn.superview viewWithTag:isMan?101:100];
    other.selected = NO;
    btn.selected = YES;
    gender = isMan?1:0;
}

#pragma mark - 类别
- (void)typeAction:(UIButton *)btn{
    
    switch ((NSInteger)btn.tag) {
        case 100:
        {
            UIButton *other = (UIButton *)[btn.superview viewWithTag:101];
            UIButton *another = (UIButton *)[btn.superview viewWithTag:102];
            other.selected = NO;
            another.selected = NO;
            btn.selected = YES;
            brandCustomerCategoryId = 1;
        }
            break;
        case 101:
        {
            UIButton *other = (UIButton *)[btn.superview viewWithTag:100];
            UIButton *another = (UIButton *)[btn.superview viewWithTag:102];
            other.selected = NO;
            another.selected = NO;
            btn.selected = YES;
            brandCustomerCategoryId = 2;
        }
            break;
        default:
        {
            UIButton *other = (UIButton *)[btn.superview viewWithTag:101];
            UIButton *another = (UIButton *)[btn.superview viewWithTag:100];
            other.selected = NO;
            another.selected = NO;
            btn.selected = YES;
            brandCustomerCategoryId = 3;
        }
            break;
    }
}

#pragma mark - 协议条款
- (void)read:(UIButton *)btn{
    
    btn.selected = !btn.selected;
}

#pragma mark - 获取验证码
- (void)getCode:(UIButton *)btn{
    
    if ([Tools_F validateMobile:phone_TextView.text]) {
        
        // 请求参数
        NSDictionary *param = @{@"phone":phone_TextView.text};
        //
        [HttpTool postWithBaseURL:SDD_MainURL Path:@"/sms/user/sendBrandJoinCode.do" params:param success:^(id JSON) {
            
            NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
            
            if ([JSON[@"status"] intValue] == 1) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:JSON[@"message"]
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                         target:self
                                                       selector:@selector(timingOfSixtySecond)
                                                       userInfo:nil
                                                        repeats:YES];
            }
            
        } failure:^(NSError *error) {
            
            NSLog(@"%@",error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:[NSString stringWithFormat:@"%@",error]
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }];
    }
    else {
        
        UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入有效的手机号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}


#pragma mark -- 倒计时
- (void)timingOfSixtySecond{
    
    getCode.enabled = NO;
    NSString *secondStr = [NSString stringWithFormat:@"%d秒",(second--) - 1];
    [getCode setTitleColor:lgrayColor forState:UIControlStateNormal];
    [getCode setTitle:secondStr forState:UIControlStateNormal];
    if (second == 0) {
        [timer invalidate];
        timer = nil;
        second = 60;
        
        [getCode setTitleColor:[SDDColor colorWithHexString:@"#008fec"] forState:UIControlStateNormal];
        [getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        getCode.enabled = YES;
    }
}

#pragma mark - 提交
- (void)takeItNow:(UIButton *)btn{
    
    if (name_TextView.text.length<1 || phone_TextView.text.length<1 || code_TextView.text.length<1 ||
        franchiseBrands_TextView.text.length<1 || address_TextView.text.length<1 ||
        company_TextView.text.length<1 || pastBackground_TextView.text.length<1 || !industryCategoryId ||
        !industryCategoryId2 || !investmentAmountCategoryId || !brandCustomerCategoryId ||
        !postCategoryId) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入完整信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        
        // 请求参数
//        NSDictionary *param = @{
//                                @"realName":name_TextView.text,
//                                @"phone":phone_TextView.text,
//                                @"code": code_TextView.text,
//                                @"company": company_TextView.text,
//                                @"operateBrand": franchiseBrands_TextView.text,
//                                @"storeAddress": address_TextView.text,
//                                @"userHistory": pastBackground_TextView.text,
//                                @"discountId":[NSNumber numberWithInteger:[_discountCoupons[@"discountId"] integerValue]],
//                                @"brandIndustryCategoryId1":[NSNumber numberWithInteger:industryCategoryId],
//                                @"brandIndustryCategoryId2":[NSNumber numberWithInteger:industryCategoryId2],
//                                @"brandInvestmentAmountCategoryId":[NSNumber numberWithInteger:investmentAmountCategoryId],
//                                @"postCategoryId":[NSNumber numberWithInteger:postCategoryId],
//                                @"brandCustomerCategoryId":[NSNumber numberWithInteger:brandCustomerCategoryId],
//                                @"gender":[NSNumber numberWithInteger:gender],
//                                };
        
        NSDictionary *param1 = @{@"sex":[NSNumber numberWithInteger:gender],
                                 @"phone":phone_TextView.text,
                                 @"guestTypeId":@1,
                                 @"industryCategoryId1":[NSNumber numberWithInteger:industryCategoryId],
                                 @"industryCategoryId2":[NSNumber numberWithInteger:industryCategoryId2],
                                 @"code":code_TextView.text,
                                 @"historyBackground":pastBackground_TextView.text,
                                 @"brandId":@2,
                                 @"postId":[NSNumber numberWithInteger:postCategoryId],
                                 @"message":address_TextView.text,
                                 @"address":address_TextView.text,
                                 @"addressImage":addressImage,
                                 @"name":name_TextView.text,
                                 @"company":company_TextView.text,
                                 @"brand":franchiseBrands_TextView.text,
                                 @"investmentAmountCategoryId":[NSNumber numberWithInteger:investmentAmountCategoryId]};
        ///brand/add/joined.do  /brandUserDiscountCoupons/add.do
        [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brand/add/joined.do" params:param1 success:^(id JSON) {
            
            NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
            
            
            if ([JSON[@"status"] intValue] == 1) {
                
//                SuccessReceiveViewController *srVC = [[SuccessReceiveViewController alloc] init];
//    
//                srVC.passValue = JSON[@"data"];
//                srVC.brankName = _brankName;
//                [self.navigationController pushViewController:srVC animated:YES];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:JSON[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:JSON[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        } failure:^(NSError *error) {
            
            NSLog(@"%@",error);
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
