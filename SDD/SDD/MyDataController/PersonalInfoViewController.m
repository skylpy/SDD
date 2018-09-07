//
//  PersonalInfoViewController.m
//  SDD
//
//  Created by hua on 15/8/12.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "PersonalInfoViewController.h"
#import "UserInfo.h"
#import "FindBrankModel.h"

#import "BindTelController.h"
#import "EditNameController.h"
#import "EditBrandViewController.h"
#import "EditMailViewController.h"
#import "EditPasswordController.h"
#import "CommonToolController.h"

#import "FSDropDownMenu.h"
#import "UIImageView+WebCache.h"

@interface PersonalInfoViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,
UIImagePickerControllerDelegate,UINavigationControllerDelegate,FSDropDownMenuDataSource,FSDropDownMenuDelegate>{
    
    /*- ui -*/
    
    UITableView *table;
    UIImageView *avatar;
    
    FSDropDownMenu *dropMenu;
    
    /*- data -*/
    
    NSArray *contentTitle;
    
    FindBrankModel *currentModel;
    NSInteger industryCategoryId;
    NSInteger industryCategoryId2;
}

// 行业类别
@property (nonatomic, strong) NSMutableArray *industryAll;

@end

@implementation PersonalInfoViewController

- (NSMutableArray *)industryAll{
    if (!_industryAll) {
        _industryAll = [[NSMutableArray alloc]init];
    }
    return _industryAll;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    // 请求用户信息
    [self requestUserInfo];
}

#pragma mark - 用户信息
- (void)requestUserInfo{
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/user/detail.do" params:nil success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        
        if (![JSON[@"data"] isEqual:[NSNull null]]) {
            
            // 用户信息
            [UserInfo sharedInstance].userInfoDic = JSON[@"data"];
            _userInfoDic = nil;
            _userInfoDic = JSON[@"data"];
            [table reloadData];
        }
    } failure:^(NSError *error) {
        //
        NSLog(@"用户信息错误 -- %@", error);
    }];
}

#pragma mark - 请求数据
- (void)requestData{
    
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //
    [self requestData];
    // 导航条
    [self setNav:@"我的账号"];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    // 初始化
    industryCategoryId = 0;
    industryCategoryId2 = 0;
    contentTitle = @[
                     @[@"我的头像:"],
                     @[@"真实姓名:",@"性别:"],
                     @[@"行业:",@"品牌:"],
                     @[@"手机验证:",@"邮箱:"],
                     @[/*@"设置",*/@"修改密码"]
                     ];
    
    // 栏目选择
    dropMenu = [[FSDropDownMenu alloc] initWithOrigin:CGPointMake(0, viewHeight-300-64) andHeight:300];
    dropMenu.dataSource = self;
    dropMenu.delegate = self;
    [self.view addSubview:dropMenu];
    
    // table
    table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    table.backgroundColor = bgColor;
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // footer
    UIView *footer_bg = [[UIView alloc] init];
    footer_bg.backgroundColor = bgColor;
    footer_bg.frame = CGRectMake(0, 0, viewWidth, 55);
    
    // 退出按钮
    ConfirmButton *loginOutBtn = [[ConfirmButton alloc] initWithFrame:CGRectMake(20, 5, viewWidth - 40, 45)
                                               title:@"退出"
                                              target:self
                                              action:@selector(loginOut)];
    loginOutBtn.enabled = YES;
    [footer_bg addSubview:loginOutBtn];
    
    table.tableFooterView = footer_bg;
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return 70;
    }
    else {
        
        return 45;
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
            
            return 2;
        }
            break;
        case 2:{
            
            return 2;
        }
            break;
        case 3:{
            
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
    
    return 5;
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
    static NSString *identifier = @"PersonalInfo";
    //重用机制
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];      //带标识符的出列
    
    if (cell == nil) {
        
        // 当不存在的时候用重用标识符生成
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;                // 设置选中背景色不变
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;       // 显示箭头
        cell.textLabel.font = midFont;
        cell.textLabel.textColor = mainTitleColor;
        cell.detailTextLabel.font = midFont;
        cell.detailTextLabel.textColor = lgrayColor;
        
        if (indexPath.section == 0) {
            if (avatar == nil) {
                avatar = [[UIImageView alloc] init];
                avatar.contentMode = UIViewContentModeScaleAspectFill;
                [Tools_F setViewlayer:avatar cornerRadius:25 borderWidth:0 borderColor:nil];
                
                [cell addSubview:avatar];
                [avatar mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.mas_centerY);
                    make.right.equalTo(cell.mas_right).with.offset(-30);
                    make.size.mas_equalTo(CGSizeMake(50, 50));
                }];
            }
            
            [avatar sd_setImageWithURL:[NSURL URLWithString:_userInfoDic[@"icon"]]];
        }
    }
    
    cell.textLabel.text = contentTitle[indexPath.section][indexPath.row];
    switch (indexPath.section) {
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell.detailTextLabel.text = _userInfoDic[@"realName"];
                }
                    break;
                default:
                {
                    cell.detailTextLabel.text = [_userInfoDic[@"gender"] integerValue]==0?@"女":@"男";
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
                    cell.detailTextLabel.text = _userInfoDic[@"industryName"];
                }
                    break;
                default:
                {
                    cell.detailTextLabel.text = _userInfoDic[@"brand"];
                }
                    break;
            }
        }
            break;
        case 3:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell.detailTextLabel.text = _userInfoDic[@"phone"];
                }
                    break;
                default:
                {
                    cell.detailTextLabel.text = _userInfoDic[@"email"];
                }
                    break;
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - 点击cell (tableView)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 根据indexPath得到cell
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];

    switch (indexPath.section) {
        case 0:
        {
            UIActionSheet *shotOrAlbums = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照上传" otherButtonTitles:@"从手机相片选择", nil];
            shotOrAlbums.tag = 100;
            [shotOrAlbums showInView:self.view];
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    EditNameController *enc = [[EditNameController alloc] init];
                    
                    enc.theNickname = cell.detailTextLabel.text;
                    [enc valueReturn:^(NSString *theName) {
                        
                        cell.detailTextLabel.text = theName;
                    }];
                    [self.navigationController pushViewController:enc animated:YES];
                }
                    break;
                default:
                {
                    UIActionSheet *gender = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"男" otherButtonTitles:@"女", nil];
                    gender.tag = 101;
                    [gender showInView:self.view];
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
                    [self.view endEditing:YES];
                    [dropMenu.rightTableView reloadData];
                    [dropMenu menuTapped];
                }
                    break;
                default:
                {
                    EditBrandViewController *ebVC = [[EditBrandViewController alloc] init];
                    
                    ebVC.theBrandname = cell.detailTextLabel.text;
                    [ebVC valueReturn:^(NSString *theBrandname) {
                        
                        cell.detailTextLabel.text = theBrandname;
                    }];
                    [self.navigationController pushViewController:ebVC animated:YES];
                }
                    break;
            }
        }
            break;
        case 3:
        {
            switch (indexPath.row) {
                case 0:
                {
                    BindTelController *btc = [[BindTelController alloc] init];

                    btc.thePhoneNum = _userInfoDic[@"phone"];
                    [btc valueReturn:^(NSString *thePhoneNum) {
                        
                        cell.detailTextLabel.text = thePhoneNum;
                    }];
                    [self.navigationController pushViewController:btc animated:YES];
                }
                    break;
                default:
                {
                    EditMailViewController *emVC = [[EditMailViewController alloc] init];
                    
                    emVC.theMail = cell.detailTextLabel.text;
                    [emVC valueReturn:^(NSString *theMail) {
                        
                        cell.detailTextLabel.text = theMail;
                    }];
                    [self.navigationController pushViewController:emVC animated:YES];
                }
                    break;
            }
        }
            break;
        default:
        {
            switch (indexPath.row) {
//                case 0:
//                {
//                    CommonToolController *ctVC = [[CommonToolController alloc] init];
//                    [self.navigationController pushViewController:ctVC animated:YES];
//                }
//                    break;
                default:
                {
                    EditPasswordController *epc = [[EditPasswordController alloc] init];
                    [self.navigationController pushViewController:epc animated:YES];
                }
                    break;
            }
        }
            break;
    }
}

#pragma mark - FSDropDown datasource & delegate
- (NSInteger)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == menu.leftTableView) {
        if (currentModel) {
            
            return [currentModel.children count]+1;
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
        
        if (indexPath.row == 0) {
            return @"不限";
        }
        else {
            
            NSDictionary *tempDic = currentModel.children[indexPath.row-1];
            return tempDic[@"categoryName"];
        }
    }
    else{
        
        FindBrankModel *model = _industryAll[indexPath.row];
        return model.categoryName;
    }
}

- (void)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == menu.leftTableView) {
        
        if (indexPath.row == 0) {
            
//            industryTextfield.text = [NSString stringWithFormat:@"%@-不限",currentModel.categoryName];
            industryCategoryId2 = 0;
        }
        else {
            
            NSDictionary *tempDic = currentModel.children[indexPath.row-1];
//            industryTextfield.text = tempDic[@"categoryName"];
            industryCategoryId2 = [tempDic[@"industryCategoryId"] integerValue];
        }
        [self changeIndustry];
    }
    else{
        
        FindBrankModel *model = _industryAll[indexPath.row];
        industryCategoryId = [model.industryCategoryId integerValue];
        currentModel = model;
        [menu.leftTableView reloadData];
    }
}

#pragma mark - 行业修改
- (void)changeIndustry{
    
    NSDictionary *param = @{@"industryCategoryId":[NSNumber numberWithInteger:industryCategoryId2]};
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/user/modify_industry_category_id.do" params:param success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        if ([JSON[@"status"] intValue] == 1) {
            [self requestUserInfo];
        }
    } failure:^(NSError *error) {
        //
        NSLog(@"行业修改错误 -- %@", error);
    }];
}

#pragma mark - UIActionSheet代理
- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == 100) {
        
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
        }
    }
    else {
        
        if (buttonIndex<2) {
            
            NSDictionary *param = @{@"gender":[NSNumber numberWithInteger:buttonIndex==0?1:0]};
            
            [HttpTool postWithBaseURL:SDD_MainURL Path:@"/user/modify_gender.do" params:param success:^(id JSON) {
                
                NSLog(@"%@>>>>>>>%@",JSON[@"message"],param);
                
                [self requestUserInfo];
            } failure:^(NSError *error) {
                NSLog(@"修改性别失败");
            }];
        }
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
    
    // 初始化imageNew为从相机中获得的--
    UIImage *imageNew = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        
        UIImageWriteToSavedPhotosAlbum(imageNew, nil, nil, nil);
    }
    
    [self showLoading:0];
    
    [HttpTool uploadWithBaseURL:SDD_MainURL Path:@"/upload/icon.do" params:nil dataName:@"icon" AlbumImage:imageNew success:^(id responseObject) {
        
        [self hideLoading];
        NSDictionary *dict = responseObject;
        NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
        if (![dict[@"data"] isEqual:[NSNull null]]) {
            
            avatar.image = imageNew;
        }
        
    } fail:^{
        
        [self showErrorWithText:@"上传失败"];
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 退出登录
- (void)loginOut{
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/login/logout.do" params:nil success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        // 设置登录状态
        [GlobalController setLoginStatus:NO];
        // 单例置空
        [UserInfo sharedInstance].userInfoDic = nil;
        // 注销环信
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES];
        // 发送取消自动登陆状态通知
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        NSLog(@"注销错误 -- %@", error);
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
