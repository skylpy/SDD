//
//  personalTwoViewController.m
//  SDD
//
//  Created by hua on 15/10/28.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "personalTwoViewController.h"
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

#import "JoinPDropDownMenu.h"
#import "UIImageView+WebCache.h"

typedef NS_ENUM(NSInteger, ColumnType)
{
    exRegionType = 0,
    industryType = 1,
    investmentAmountsType = 2
};

@interface personalTwoViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,
UIImagePickerControllerDelegate,UINavigationControllerDelegate,FSDropDownMenuDataSource,FSDropDownMenuDelegate,DOPDropDownMenuDataSource,DOPDropDownMenuDelegate>{
    
    /*- ui -*/
    
    UITableView *table;
    UIImageView *avatar;
    
    FSDropDownMenu *dropMenu;
    JoinPDropDownMenu *JdropMenu;
    
    UILabel *exRegion;
    UILabel *industry;
    UILabel *investmentAmounts;
    /*- data -*/
    
    NSArray *contentTitle;
    
    FindBrankModel *currentModel;
    FindBrankModel *currentModel2;
    NSInteger expandingRegion;
    NSInteger industryCategoryId;
    NSInteger industryCategoryId2;
    NSInteger industryCategoryId3;
    NSInteger investmentAmountCategoryId;
    
    ColumnType columntype;
}

// 行业类别
//@property (nonatomic, strong) NSMutableArray *industryAll;
// 区位位置
@property (nonatomic, strong) NSMutableArray *regionalLocation;  //←命名有歧义，有空改
// 招商对象
@property (nonatomic, strong) NSMutableArray *industryAll;
// 省份、城市列表
@property (nonatomic, strong) NSMutableArray *province;
@property (nonatomic, strong) NSMutableArray *city;

@end

@implementation personalTwoViewController

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

#pragma mark - 刷新代理（数据源）
- (void)delegateAgain{
    
    JdropMenu.delegate = nil;
    JdropMenu.dataSource = nil;
    JdropMenu.delegate = self;
    JdropMenu.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
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
            NSLog(@"##################################+++++++++++%@",[_userInfoDic objectForKey:@"lastUserType"]);
            NSLog(@"%d",[_userInfoDic[@"lastUserType"] intValue]);
            [table reloadData];
        }
    } failure:^(NSError *error) {
        //
        NSLog(@"用户信息错误 -- %@", error);
    }];
}

//#pragma mark - 请求数据
//- (void)requestData{
//    
//    // 行业类别
//    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brandCategory/industryAllList.do" params:nil success:^(id JSON) {
//        
//        //        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
//        NSDictionary *dict = JSON[@"data"];
//        
//        if (![dict isEqual:[NSNull null]]) {
//            
//            [_industryAll removeAllObjects];
//            
//            BOOL flag = NO;
//            for (NSDictionary *tempDic in dict) {
//                flag = YES;
//                FindBrankModel *model = [FindBrankModel findBrankWithDict:tempDic];
//                [self.industryAll addObject:model];
//            }
//            FindBrankModel *model = _industryAll[0];
//            currentModel = flag?model:nil;
//        }
//    } failure:^(NSError *error) {
//        
//    }];
//}

#pragma mark - 请求数据
- (void)requestData{
    
    NSDictionary *param = @{};    // 请求参数
    
    // 投资额度
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brandCategory/investmentAmountCategoryList.do" params:param success:^(id JSON) {
        
//                NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
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
        
//                NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
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
        
//                NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
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
    
    //
    
    
//    [self requestCity];
    
    // 导航条
    [self setNav:@"我的账号"];
    // 设置内容
    [self setupUI];
    
    [self requestData];
    
    
    [self changeIndustry];
    // Do any additional setup after loading the view.
}

#pragma mark - 设置内容
- (void)setupUI{
    
    // 初始化
    industryCategoryId = 0;
    industryCategoryId2 = 0;
    industryCategoryId3 = 0;
//    contentTitle = @[
//                     @[@"我的头像:"],
//                     @[@"真实姓名:",@"性别:"],
//                     @[@"行业:",@"品牌:"],
//                     @[@"手机验证:",@"邮箱:"],
//                     @[/*@"设置",*/@"修改密码"]
//                     ];
//    contentTitle = @[
//                     @[@"头像"],
//                     @[@"姓名",@"性别"],
//                     @[@[@"身份",@"发展商名称",@"项目名称",@"所在城市"],@[@"身份",@"行业类别",@"品牌名称",@"所在城市"],@[@"身份",@"投资能力",@"投资行业",@"所在城市"],@[@"身份",@"投资能力",@"投资行业",@"所在城市"]],
//                     @[@"登录手机号",@"邮箱"],
//                     ];
    // 栏目选择
    dropMenu = [[FSDropDownMenu alloc] initWithOrigin:CGPointMake(0, viewHeight-300-64) andHeight:300];
    dropMenu.dataSource = self;
    dropMenu.delegate = self;
//    dropMenu.indicatorColor = lgrayColor;
//    dropMenu.textColor = deepBLack;
//    [dropMenu setMoreSelectMode:TRUE:3];  //设置多选模式
    [self.view addSubview:dropMenu];
    
    
//    // 添加下拉菜单
//    JdropMenu = [[JoinPDropDownMenu alloc] initWithOrigin:CGPointMake(0, viewHeight-400-64) andHeight:40];
//    JdropMenu.indicatorColor = lgrayColor;
//    JdropMenu.textColor = deepBLack;
//    [JdropMenu setMoreSelectMode:TRUE:3];  //设置多选模式
//    
//    [self.view addSubview:JdropMenu];
    
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
                                                                title:@"退出当前账户"
                                                               target:self
                                                               action:@selector(loginOut)];
    loginOutBtn.enabled = YES;
    [footer_bg addSubview:loginOutBtn];
    
    table.tableFooterView = footer_bg;
}

//#pragma mark - 菜单多选功能
//-(void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPaths:(NSMutableArray *)indexPaths{
//    
//    // 重置
//    
//    for (int i = 0; i < [indexPaths count]; i++) {
//        NSMutableArray *mu = [indexPaths objectAtIndex:i];
//        NSLog(@"~~~~%d有%d个",i,[mu count]);
//        for (NSIndexPath *indexPath in mu) {
//            switch (i) {
//                case 0:
//                {
//                    // 项目性质
//                    FindBrankModel *model = _allNature[indexPath.item];
//                    projectNatureCategoryId = [model.projectNatureCategoryId integerValue];
//                }
//                    break;
//                case 1:
//                {
//                    // 智能排序
//                    smartSortingId = indexPath.item;
//                }
//                    break;
//                case 2:
//                {
//                    // 行业
//                    FindBrankModel *model = _allIndustry[indexPath.row];
//                    industryCategoryID = [model.industryCategoryId integerValue];
//                }
//                    break;
//            }
//        }
//    }
//    [self requestData];
//}

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
            
            return 4;
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
    
    UIImage * image = [Tools_F imageWithColor:dblueColor size:CGSizeMake(50, 50)];
    
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
            
            [avatar sd_setImageWithURL:[NSURL URLWithString:_userInfoDic[@"icon"]]placeholderImage:image];
            
        }
    }
    
    switch (indexPath.section) {
        case 0:
        {
            cell.textLabel.text = @"头像";
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text = @"姓名";
                }
                    break;
                case 1:
                {
                    cell.textLabel.text = @"性别";
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            NSArray *arr = @[
                             @[@"身份",@"发展商名称",@"项目名称",@"所在城市"],
                             @[@"身份",@"行业类别",@"品牌名称",@"所在城市"],
                             @[@"身份",@"投资能力",@"投资行业",@"所在城市"],
                             @[@"身份",@"投资能力",@"投资行业",@"所在城市"]];
            
            if (![_userInfoDic[@"lastUserType"] isEqual:[NSNull null]]) {
                
                switch (indexPath.row) {
                        
                    case 0:
                    {
                        cell.textLabel.text = arr[[_userInfoDic[@"lastUserType"] intValue]][0];
                    }
                        break;
                    case 1:
                    {
                        cell.textLabel.text = arr[[_userInfoDic[@"lastUserType"] intValue]][1];
                    }
                        break;
                    case 2:
                    {
                        cell.textLabel.text = arr[[_userInfoDic[@"lastUserType"] intValue]][2];
                    }
                        break;
                    case 3:
                    {
                        cell.textLabel.text = arr[[_userInfoDic[@"lastUserType"] intValue]][3];
                    }
                        break;
                    default:
                        break;
                }

                
            }
            }
            break;
        case 3:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text = @"登录手机号";
                }
                    break;
                case 1:
                {
                    cell.textLabel.text = @"邮箱";
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 4:
        {
            cell.textLabel.text = @"修改密码";
        }
            break;
            
        default:
            break;
    }
//        cell.textLabel.text = contentTitle[indexPath.section][indexPath.row];


    switch (indexPath.section) {
            case 0:
        {
            UILabel *titLabel = [[UILabel alloc]init];
            //titLabel.backgroundColor =[UIColor colorWithRed:(0/255.0) green:((115)/255.0) blue:((226)/255.0) alpha:(1.0)];

            NSString *a = [NSString stringWithFormat:@"%@",_userInfoDic[@"realName"]];
            
            NSLog(@"%@",_userInfoDic[@"realName"]);
            NSMutableString *c = [[NSMutableString alloc] init];
            
            //需要的长度
            
            for(int i = 0; i < a.length; i++){
                
                unichar ch = [a characterAtIndex:0];
                if (0x4e00 < ch  && ch < 0x9fff)
                {
                    //若为汉字
                    [c appendString:[a substringWithRange:NSMakeRange(i,1)]];
                    break;
                    
                } else {
                    [c appendString:[a substringWithRange:NSMakeRange(i,1)]];
                    
                    break;
                }
            }
            cell.detailTextLabel.hidden = YES;
           // NSLog(@"^^^^^^^^^^^^^^^^%@", c);
            titLabel.text = c;
            titLabel.textColor = [UIColor whiteColor];
            titLabel.textAlignment = NSTextAlignmentCenter;
            
            titLabel.font = largeFont;
            titLabel.frame = CGRectMake(0, 0, 50, 50);
            [avatar addSubview:titLabel];
            [avatar sd_setImageWithURL:[NSURL URLWithString:_userInfoDic[@"icon"]]placeholderImage:image];
            if (![_userInfoDic[@"icon"] isEqualToString:@""]) {
                
                titLabel.hidden = YES;
            }
        }
        case 1:
        {
            if (indexPath.row == 0) {
                
                cell.detailTextLabel.text = _userInfoDic[@"realName"];
            }
            else
            {
                cell.detailTextLabel.text = [_userInfoDic[@"gender"] integerValue]==0?@"女":@"男";
            }
        }
            break;

        case 2:
        {
            NSArray *arrL = @[@"发展商",@"品牌商",@"经销商",@"其他"];
            switch (indexPath.row) {
                case 0:
                {
                    
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.detailTextLabel.text = arrL[[_userInfoDic[@"lastUserType"] intValue]];
                }
                    break;
                case 1:
                {
                    switch ([_userInfoDic[@"lastUserType"] intValue]) {
                        case 0:
                        {
                            if (![_userInfoDic[@"lastDeveloperName"] isEqual:[NSNull null]]) {
                                
                                if (![_userInfoDic[@"lastDeveloperName"] isEqualToString:@""]) {
                                   cell.detailTextLabel.text = _userInfoDic[@"lastDeveloperName"];
                                }
                                else{
                                    
                                    cell.detailTextLabel.text = @"未设置";
                                }
                                //cell.detailTextLabel.text = _userInfoDic[@"lastDeveloperName"];
                            }
                            else{
                                cell.detailTextLabel.text = @"未设置";
                            }
                        }
                            break;
                            
                        case 1:
                        {
                            industry = cell.detailTextLabel;
                            
                            if (![_userInfoDic[@"lastDeveloperName"] isEqual:[NSNull null]]) {
                                
                                if (![_userInfoDic[@"lastDeveloperName"] isEqualToString:@""]) {
                                    cell.detailTextLabel.text = _userInfoDic[@"lastDeveloperName"];
                                }
                                else{
                                    
                                    cell.detailTextLabel.text = @"未设置";
                                }
                                //cell.detailTextLabel.text = _userInfoDic[@"lastDeveloperName"];
                            }
                            else{
                                cell.detailTextLabel.text = @"未设置";
                            }
                        }
                            break;
                            
                        case 2:
                        {
                            
                            investmentAmounts = cell.detailTextLabel;
                            if (![_userInfoDic[@"lastDeveloperName"] isEqual:[NSNull null]]) {
                                
                                if (![_userInfoDic[@"lastDeveloperName"] isEqualToString:@""]) {
                                    cell.detailTextLabel.text = _userInfoDic[@"lastDeveloperName"];
                                }
                                else{
                                    
                                    cell.detailTextLabel.text = @"未设置";
                                }
                                //cell.detailTextLabel.text = _userInfoDic[@"lastDeveloperName"];
                            }
                            else{
                                cell.detailTextLabel.text = @"未设置";
                            }
                        }
                            break;
                            
                        case 3:
                        {
                            investmentAmounts = cell.detailTextLabel;
                            if (![_userInfoDic[@"lastDeveloperName"] isEqual:[NSNull null]]) {
                                
                                if (![_userInfoDic[@"lastDeveloperName"] isEqualToString:@""]) {
                                    cell.detailTextLabel.text = _userInfoDic[@"lastDeveloperName"];
                                }
                                else{
                                    
                                    cell.detailTextLabel.text = @"未设置";
                                }
                                //cell.detailTextLabel.text = _userInfoDic[@"lastDeveloperName"];
                            }
                            else{
                                cell.detailTextLabel.text = @"未设置";
                            }
                        }
                            break;
                        default:
                            break;
                    }
                }
                    break;
                
                case 2:
                {
                    switch ([_userInfoDic[@"lastUserType"] intValue]) {
                        case 0:
                        {
                            if (![_userInfoDic[@"lastHouseName"] isEqual:[NSNull null]]) {
                                
                                if (![_userInfoDic[@"lastHouseName"] isEqualToString:@""]) {
                                    
                                    cell.detailTextLabel.text = _userInfoDic[@"lastHouseName"];
                                }
                                else{
                                    cell.detailTextLabel.text = @"未设置";
                                }
                            }
                            else{
                                cell.detailTextLabel.text = @"未设置";
                            }
                        }
                            break;
                            
                        case 1:
                        {
                            if (![_userInfoDic[@"lastBrandName"]isEqual:[NSNull null]]) {
                                
                                if (![_userInfoDic[@"lastBrandName"] isEqualToString:@""]) {
                                    
                                    cell.detailTextLabel.text = _userInfoDic[@"lastBrandName"];
                                }
                                else{
                                    cell.detailTextLabel.text = @"未设置";
                                }
                                
                            }
                            else{
                                cell.detailTextLabel.text = @"未设置";
                            }
                        }
                            break;
                            
                        case 2:
                        {
                            if (![_userInfoDic[@"lastInvestmentIndustry"]isEqual:[NSNull null]]) {
                                cell.detailTextLabel.text = _userInfoDic[@"lastInvestmentIndustry"];
                            }
                            else{
                                cell.detailTextLabel.text = @"未设置";
                            }
                        }
                            break;
                            
                        case 3:
                        {
                            if (![_userInfoDic[@"lastInvestmentIndustry"]isEqual:[NSNull null]]) {
                                cell.detailTextLabel.text = _userInfoDic[@"lastInvestmentIndustry"];
                            }
                            else{
                                cell.detailTextLabel.text = @"未设置";
                            }
                        }
                            break;
                        default:
                            break;
                    }
                }
                    break;
                case 3:
                {
                    if (![_userInfoDic[@"city"] isEqual:[NSNull null]]) {
                        
                        if (![_userInfoDic[@"city"] isEqualToString:@""]) {
                            
                            cell.detailTextLabel.text = _userInfoDic[@"city"];
                        }
                        else{
                            
                            cell.detailTextLabel.text = @"未设置";
                        }
                        
                    }
                    else{
                        cell.detailTextLabel.text = @"未设置";
                    }
                    exRegion = cell.detailTextLabel;
                }
                    break;
                default:
                
                    break;
            }
        }
            break;
        case 3:
        {
            switch (indexPath.row)
            {
                case 0:
                {
                    if (![_userInfoDic[@"phone"] isEqual:[NSNull null]]) {
                        
                        cell.detailTextLabel.text = _userInfoDic[@"phone"];
                    }
                    else{
                        cell.detailTextLabel.text = @"未设置";
                    }
                    
                }
                    break;
                default:
                {
                    if (![_userInfoDic[@"email"] isEqual:[NSNull null]]) {
                        
                        cell.detailTextLabel.text = _userInfoDic[@"email"];
                    }
                    else{
                        cell.detailTextLabel.text = @"未设置";
                    }
                    
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
#pragma mark -  bug 修改*******************

                }
                    break;
                case 1:
                {
                    
                    switch ([_userInfoDic[@"lastUserType"] intValue]) {
                        case 0:
                        {
                            EditBrandViewController *ebVC = [[EditBrandViewController alloc] init];
                            
                            ebVC.NvcName = @"发展商修改";
                            ebVC.theBrandname = cell.detailTextLabel.text;
                            [ebVC valueReturn:^(NSString *theBrandname) {
                                
                                cell.detailTextLabel.text = theBrandname;
                                NSString *sr =cell.detailTextLabel.text;
                                [self changeone:sr];
                            }];
                            [self.navigationController pushViewController:ebVC animated:YES];
                        }
                            break;
                        case 1:
                        {
                            EditBrandViewController *ebVC = [[EditBrandViewController alloc] init];
                            
                            ebVC.NvcName = @"品牌商修改";
                            ebVC.theBrandname = cell.detailTextLabel.text;
                            [ebVC valueReturn:^(NSString *theBrandname) {
                                
                                cell.detailTextLabel.text = theBrandname;
                                NSString *sr =cell.detailTextLabel.text;
                                [self changeone:sr];
                            }];
                            [self.navigationController pushViewController:ebVC animated:YES];
//                            {
//                                [self.view endEditing:YES];
//                                columntype = industryType;
//                                [dropMenu.rightTableView reloadData];
//                                [dropMenu menuTapped];
//                            }
                        }
                            break;
                        case 2:
                        {
                            EditBrandViewController *ebVC = [[EditBrandViewController alloc] init];
                            
                            ebVC.NvcName = @"经销商修改";
                            ebVC.theBrandname = cell.detailTextLabel.text;
                            [ebVC valueReturn:^(NSString *theBrandname) {
                                
                                cell.detailTextLabel.text = theBrandname;
                                NSString *sr =cell.detailTextLabel.text;
                                [self changeone:sr];
                            }];
                            [self.navigationController pushViewController:ebVC animated:YES];
//                            {
//                                [self.view endEditing:YES];
//                                columntype = investmentAmountsType;
//                                [dropMenu.rightTableView reloadData];
//                                [dropMenu menuTapped];
//                            }
                        }
                            break;
                        case 3:
                        {
                            EditBrandViewController *ebVC = [[EditBrandViewController alloc] init];
                            
                            ebVC.NvcName = @"其他修改";
                            ebVC.theBrandname = cell.detailTextLabel.text;
                            [ebVC valueReturn:^(NSString *theBrandname) {
                                
                                cell.detailTextLabel.text = theBrandname;
                                NSString *sr =cell.detailTextLabel.text;
                                [self changeone:sr];
                            }];
                            [self.navigationController pushViewController:ebVC animated:YES];
//                            {
//                                [self.view endEditing:YES];
//                                columntype = investmentAmountsType;
//                                [dropMenu.rightTableView reloadData];
//                                [dropMenu menuTapped];
//                            }
                        }
                            break;
                            
                        default:
                            break;
                    }
                    
                }
                    break;
                case 2:
                {
                    switch ([_userInfoDic[@"lastUserType"] intValue]) {
                        case 0:
                        {
                            {
                                EditBrandViewController *ebVC = [[EditBrandViewController alloc] init];
                                
                               ebVC.NvcName = @"项目名称修改";
                                ebVC.theBrandname = cell.detailTextLabel.text;
                                [ebVC valueReturn:^(NSString *theBrandname) {
                                    
                                    cell.detailTextLabel.text = theBrandname;
                                    NSString *sr = cell.detailTextLabel.text;
                                    [self changetwo:sr];

                                }];
                                [self.navigationController pushViewController:ebVC animated:YES];
                                
                            }
                        }
                            break;
                        case 1:
                        {
                            {
                                EditBrandViewController *ebVC = [[EditBrandViewController alloc] init];
                                
                            
                                ebVC.theBrandname = cell.detailTextLabel.text;
                                [ebVC valueReturn:^(NSString *theBrandname) {
                                    
                                    cell.detailTextLabel.text = theBrandname;
                                    NSString *sr = cell.detailTextLabel.text;
                                    [self changethree:sr];
                                }];
                                [self.navigationController pushViewController:ebVC animated:YES];
                                
                            }
                        }
                            break;
                        case 2:
                        {
                            {
                                EditBrandViewController *ebVC = [[EditBrandViewController alloc] init];
                                
                                ebVC.theBrandname = cell.detailTextLabel.text;
                                [ebVC valueReturn:^(NSString *theBrandname) {
                                    
                                    cell.detailTextLabel.text = theBrandname;
                                    NSString *sr = cell.detailTextLabel.text;
                                    [self changefour:sr];
                                }];
                                [self.navigationController pushViewController:ebVC animated:YES];
                                
                            }
                        }
                            break;
                        case 3:
                        {
                            {
                                EditBrandViewController *ebVC = [[EditBrandViewController alloc] init];
                                
                                ebVC.theBrandname = cell.detailTextLabel.text;
                                [ebVC valueReturn:^(NSString *theBrandname) {
                                    
                                    cell.detailTextLabel.text = theBrandname;
                                    NSString *sr = cell.detailTextLabel.text;
                                    [self changefour:sr];
                                }];
                                [self.navigationController pushViewController:ebVC animated:YES];
                                
                            }
                        }
                            break;
                            
                        default:
                            break;
                    }

                }
                    break;
                case 3:
                {
                    switch ([_userInfoDic[@"lastUserType"] intValue]) {
                        case 0:
                        {
                            {
                                            [self.view endEditing:YES];
                                            columntype = exRegionType;
                                            [dropMenu.rightTableView reloadData];
                                            [dropMenu menuTapped];
                            }
                        }
                            break;
                        case 1:
                        {
                            {
                                            [self.view endEditing:YES];
                                            columntype = exRegionType;
                                            [dropMenu.rightTableView reloadData];
                                            [dropMenu menuTapped];
                            }
                        }
                            break;
                        case 2:
                        {
                            {
                                            [self.view endEditing:YES];
                                            columntype = exRegionType;
                                            [dropMenu.rightTableView reloadData];
                                            [dropMenu menuTapped];
                            }
                        }
                            break;
                        case 3:
                        {
                            {
                                            [self.view endEditing:YES];
                                            columntype = exRegionType;
                                            [dropMenu.rightTableView reloadData];
                                            [dropMenu menuTapped];
                            }
                        }
                            break;
                            
                        default:
                            break;
                    }
                }
                    break;
                default:
                
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
        
//        if (indexPath.row == 0) {
//            
//            //            industryTextfield.text = [NSString stringWithFormat:@"%@-不限",currentModel.categoryName];
//            industryCategoryId2 = 0;
//        }
//        else {
//            
//            NSDictionary *tempDic = currentModel.children[indexPath.row-1];
//            //            industryTextfield.text = tempDic[@"categoryName"];
//            industryCategoryId2 = [tempDic[@"industryCategoryId"] integerValue];
//        }
//        [self changeIndustry];
        
        switch (columntype) {
            case exRegionType:{
                
                FindBrankModel *model = _city[indexPath.row];
                exRegion.text = model.regionName;
                expandingRegion = [model.regionId integerValue];
                [self changeCity];
            }
                break;
            case industryType:{
                #pragma mark - 此处可能需要后台进行修改
                //获的当前选择项
                
//                UITableViewCell *cell = [ tableView cellForRowAtIndexPath: indexPath.section ];
//                
//                //显示复选框
//                
//                if (cell.accessoryType == UITableViewCellAccessoryNone)
//                    
//                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
//                
//                else
//                    
//                    cell.accessoryType = UITableViewCellAccessoryNone; 
                

                NSDictionary *tempDic = currentModel.children[indexPath.row];
                industry.text = tempDic[@"categoryName"];
                industryCategoryId2 = [tempDic[@"industryCategoryId"] integerValue];
                [self changeIndustry];
            }
                break;
            case investmentAmountsType:{
                
                FindBrankModel *model = _regionalLocation[indexPath.row];
                investmentAmounts.text = model.categoryName;
                investmentAmountCategoryId = [model.investmentAmountCategoryId integerValue];
                [self changeYo];
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

#pragma mark - 发展商名称修改
- (void)changeone:(NSString *)str{
    
    NSDictionary *param = @{@"lastDeveloperName":str};
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/user/modify_last_developer_name.do" params:param success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        if ([JSON[@"status"] intValue] == 1) {
            
            [self requestUserInfo];
            
        }
    } failure:^(NSError *error) {
        //
        NSLog(@"发展商名称修改错误 -- %@", error);
    }];
}

#pragma mark - 项目名称修改
- (void)changetwo:(NSString *)str{
    
    NSDictionary *param = @{@"lastHouseName":str};
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/user/modify_last_house_name.do" params:param success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        if ([JSON[@"status"] intValue] == 1) {
            
            [self requestUserInfo];
            
        }
    } failure:^(NSError *error) {
        //
        NSLog(@"项目名称修改错误 -- %@", error);
    }];
}
#pragma mark - 品牌名称修改
- (void)changethree:(NSString *)str{
    
    NSDictionary *param = @{@"lastBrandName":str};
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/user/modify_last_brand_name.do" params:param success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        if ([JSON[@"status"] intValue] == 1) {
            
            [self requestUserInfo];
            
        }
    } failure:^(NSError *error) {
        //
        NSLog(@"项目名称修改错误 -- %@", error);
    }];
}
#pragma mark - 投资行业修改
- (void)changefour:(NSString *)str{
    
    NSDictionary *param = @{@"lastInvestmentIndustry":str};
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/user/modify_last_investment_industry.do" params:param success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        if ([JSON[@"status"] intValue] == 1) {
            
            [self requestUserInfo];
            
        }
    } failure:^(NSError *error) {
        //
        NSLog(@"项目名称修改错误 -- %@", error);
    }];
}

#pragma mark - 行业修改
- (void)changeIndustry{
    
    NSDictionary *param = @{@"industryCategoryId":@25,@"industryCategoryId":@24};
//    NSDictionary *param = @{@"industryCategoryId":[NSNumber numberWithInteger:industryCategoryId2]};
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
#pragma mark - 城市修改
- (void)changeCity{
    
    NSDictionary *param = @{@"city":exRegion.text};
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/user/modify_city.do" params:param success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        if ([JSON[@"status"] intValue] == 1) {
            [self requestUserInfo];
        }
    } failure:^(NSError *error) {
        //
        NSLog(@"行业修改错误 -- %@", error);
    }];
}
#pragma mark - 投资修改
- (void)changeYo{
    
    NSDictionary *param = @{@"lastInvestmentAmountCategoryId":[NSNumber numberWithInteger:investmentAmountCategoryId]};
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/user/modify_last_investment_amount_category_id.do" params:param success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        if ([JSON[@"status"] intValue] == 1) {
            [self requestUserInfo];
        }
    } failure:^(NSError *error) {
        //
        NSLog(@"投资修改错误 -- %@", error);
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
            
            [self requestUserInfo];
            [table reloadData];
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
