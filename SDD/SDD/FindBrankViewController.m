//
//  FindBrankViewController.m
//  SDD
//  
//  Created by hua on 15/6/29.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "FindBrankViewController.h"
#import "FindBrankModel.h"

#import "FindBrankResultViewController.h"

#import "FSDropDownMenu.h"
#import "UserInfo.h"

typedef NS_ENUM(NSInteger, ColumnType)
{
    exRegionType = 0,
    industryType = 1,
    regionLocationType = 2
};

@interface FindBrankViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,FSDropDownMenuDataSource,FSDropDownMenuDelegate>{
    
    /*- ui -*/
    
    UITableView *table;
    FSDropDownMenu *dropMenu;
    
    UILabel *exRegion;
    UILabel *industry;
    UILabel *regionLocation;
    UITextField *money;
    UITextField *name;
    UITextField *phone;
    
    
    /*- data -*/
    
    FindBrankModel *currentModel;
    FindBrankModel *currentModel2;
    
    NSInteger expandingRegion;
    NSInteger industryCategoryId;
    NSInteger industryCategoryId2;
    NSInteger regionalLocationCategoryId;
    
    NSInteger firstTap;
    ColumnType columntype;
}

// 区位位置
@property (nonatomic, strong) NSMutableArray *regionalLocation;
// 招商对象
@property (nonatomic, strong) NSMutableArray *industryAll;
// 省份、城市列表
@property (nonatomic, strong) NSMutableArray *province;
@property (nonatomic, strong) NSMutableArray *city;

@end

@implementation FindBrankViewController

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

-(void)viewWillAppear:(BOOL)animated{

    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
}
#pragma mark - 请求数据
- (void)requestData{
    
    NSDictionary *param = @{};    // 请求参数
    // 区位位置
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brandCategory/regionalLocationList.do" params:param success:^(id JSON) {
        
//        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSArray *dict = JSON[@"data"];
        
        if (![dict isEqual:[NSNull null]]) {
            
            [_regionalLocation removeAllObjects];
            
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
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brandRegion/list.do" params:param success:^(id JSON) {
        
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
    
    // 给定初始值
    firstTap = 0;
    expandingRegion = 0;
    industryCategoryId = 0;
    industryCategoryId2 = 0;
    regionalLocationCategoryId = 0;
    
    // 维度选择
    [self requestData];
    // 导航条
    [self setupNav];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置导航条
- (void)setupNav{
    
    [self setNav:@"一键找品牌"];
    
    UIButton *commit = [[UIButton alloc] init];
    commit.frame = CGRectMake(0, 0, 50, 44);
    commit.titleLabel.font = largeFont;
    [commit setTitle:@"发送" forState:UIControlStateNormal];
    [commit addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:commit];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    // table
    table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    table.backgroundColor = bgColor;
    table.bounces = NO;
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    // 栏目选择
    dropMenu = [[FSDropDownMenu alloc] initWithOrigin:CGPointMake(0, viewHeight-300-64) andHeight:300];
    dropMenu.dataSource = self;
    dropMenu.delegate = self;
    [self.view addSubview:dropMenu];
    
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:{
            
            return 3;
        }
            break;
        case 1:{
           
            return 1;
        }
            break;
            
        default:{
            
            return 2;
        }
            break;
    }
}

#pragma mark - 设置Sections数 (tableView)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
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
    static NSString *identifier = @"FindBrank";
    //重用机制
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
    UILabel *label;
    if (cell == nil) {
        //当不存在的时候用重用标识符生成
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
        cell.textLabel.font = midFont;
        
        label = [[UILabel alloc] init];
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
    
    if (indexPath.section == 0) {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        switch (indexPath.row) {
            case 0:{
                
                NSString *originalStr = @"*拓展区域";
                NSMutableAttributedString *paintStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
                [paintStr addAttribute:NSForegroundColorAttributeName
                                 value:tagsColor
                                 range:[originalStr rangeOfString:@"*"]
                 ];
                cell.textLabel.attributedText = paintStr;
                label.text = @"请选择拓展区域";
                exRegion = label;
            }
                break;
            case 1:{
                
                NSString *originalStr = @"*行业类别";//@"*招商对象";
                NSMutableAttributedString *paintStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
                [paintStr addAttribute:NSForegroundColorAttributeName
                                 value:tagsColor
                                 range:[originalStr rangeOfString:@"*"]
                 ];
                cell.textLabel.attributedText = paintStr;
                label.text = @"请选择行业类别";
                industry = label;
            }
                break;
            default:{
                
                NSString *originalStr = @"*区域位置";
                NSMutableAttributedString *paintStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
                [paintStr addAttribute:NSForegroundColorAttributeName
                                 value:tagsColor
                                 range:[originalStr rangeOfString:@"*"]
                 ];
                cell.textLabel.attributedText = paintStr;
                label.text = @"请选择区域位置";
                regionLocation = label;
            }
                break;
        }
    }
    else {
        
        UITextField *textfield = [[UITextField alloc] init];
        textfield.font = midFont;
        textfield.backgroundColor = bgColor;
        [Tools_F setViewlayer:textfield cornerRadius:4 borderWidth:0 borderColor:nil];
        [cell addSubview:textfield];
        
        UILabel *blank = [[UILabel alloc] init];
        blank.frame = CGRectMake(0, 0, 8, 30);
        
        textfield.leftView = blank;
        textfield.leftViewMode = UITextFieldViewModeAlways;
        
        [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.mas_top).with.offset(10);
            make.bottom.equalTo(cell.mas_bottom).with.offset(-10);
            make.left.equalTo(cell.mas_left).with.offset(viewWidth*3/10);
            make.right.equalTo(cell.mas_right).with.offset(-10);
        }];

        switch (indexPath.section) {
            case 1:{
                
                NSString *originalStr = @"*投资额度";
                NSMutableAttributedString *paintStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
                [paintStr addAttribute:NSForegroundColorAttributeName
                                 value:tagsColor
                                 range:[originalStr rangeOfString:@"*"]
                 ];
                cell.textLabel.attributedText = paintStr;
                money = textfield;
                
                UILabel *units = [[UILabel alloc] init];
                units.frame = CGRectMake(0, 0, 50, 13);
                units.text = @"万元";
                units.font = midFont;
                units.textAlignment = NSTextAlignmentCenter;
                
                textfield.rightView = units;
                textfield.rightViewMode = UITextFieldViewModeAlways;
                textfield.keyboardType = UIKeyboardTypePhonePad;
            }
                break;
            default:{
                switch (indexPath.row) {
                    case 0:{
                        
                        NSString *originalStr = @"*姓名";
                        NSMutableAttributedString *paintStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
                        [paintStr addAttribute:NSForegroundColorAttributeName
                                         value:tagsColor
                                         range:[originalStr rangeOfString:@"*"]
                         ];
                        cell.textLabel.attributedText = paintStr;
                        textfield.text = [UserInfo sharedInstance].userInfoDic[@"realName"];
                        name = textfield;
                    }
                        break;
                    default:{
                        
                        NSString *originalStr = @"*联系电话";
                        NSMutableAttributedString *paintStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
                        [paintStr addAttribute:NSForegroundColorAttributeName
                                         value:tagsColor
                                         range:[originalStr rangeOfString:@"*"]
                         ];
                        cell.textLabel.attributedText = paintStr;
                        textfield.text = [UserInfo sharedInstance].userInfoDic[@"phone"];
                        phone = textfield;
                        textfield.keyboardType = UIKeyboardTypePhonePad;
                    }
                        break;
                }
            }
                break;
        }
    }
    return cell;
}

#pragma mark - 点击cell (tableView)
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0:{
                columntype = exRegionType;
            }
                break;
            case 1:{
                columntype = industryType;
            }
                break;
            case 2:{
                columntype = regionLocationType;
            }
                break;
        }
        
        [self.view endEditing:YES];
        [dropMenu.rightTableView reloadData];
        [dropMenu menuTapped];
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
                    
                    return [currentModel.children count]+1;
                }
                else {
                    return 0;
                }
            }
                break;
            case regionLocationType:{
                
                return 0;
            }
                break;
        }
    }
    else {
        
        switch (columntype) {
            case exRegionType:{

                return [_province count]+1;
            }
                break;
            case industryType:{

                return [_industryAll count];
            }
                break;
            case regionLocationType:{
                
                return [_regionalLocation count]+1;
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
                
                if (indexPath.row == 0) {
                    return @"不限";
                }
                else {
                    
                    NSDictionary *tempDic = currentModel.children[indexPath.row-1];
                    return tempDic[@"categoryName"];
                }
            }
                break;
            case regionLocationType:{
                
                return @"";
            }
                break;
        }
    }
    else{
        
        switch (columntype) {
            case exRegionType:{
                
                if (indexPath.row == 0) {
                    return @"全国";
                }
                else {
                    
                    FindBrankModel *model = _province[indexPath.row-1];
                    return model.regionName;
                }
            }
                break;
            case industryType:{
                
                FindBrankModel *model = _industryAll[indexPath.row];
                return model.categoryName;
            }
                break;
            case regionLocationType:{
                if (indexPath.row == 0) {
                    return @"不限";
                }
                else {
                    
                    FindBrankModel *model = _regionalLocation[indexPath.row-1];
                    return model.categoryName;
                }
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
                
                // 清除内容 重置状态
                firstTap = 0;
                [_city removeAllObjects];
            }
                break;
            case industryType:{
                
                if (indexPath.row == 0) {

                    industry.text = [NSString stringWithFormat:@"%@-不限",currentModel.categoryName];
                    industryCategoryId2 = 0;
                }
                else {
                    
                    NSDictionary *tempDic = currentModel.children[indexPath.row-1];
                    industry.text = tempDic[@"categoryName"];
                    industryCategoryId2 = [tempDic[@"industryCategoryId"] integerValue];
                }
            }
                break;
            case regionLocationType:{
                
            }
                break;
        }
    }
    else{
        
        switch (columntype) {
            case exRegionType:{
                
                if (indexPath.row == 0) {
                    if (firstTap == 0) {
                        
                        firstTap++;
                    }
                    else {
                        
                        [menu menuClose];
                        exRegion.text = @"全国";
                        expandingRegion = 0;
                        // 清除内容 重置状态
                        firstTap = 0;
                        [_city removeAllObjects];
                    }
                }
                else {
                    
                    FindBrankModel *model = _province[indexPath.row-1];
                    [self requestCityWithID:[model.regionId integerValue]];
                }
            }
                break;
            case industryType:{
                
                FindBrankModel *model = _industryAll[indexPath.row];
                industryCategoryId = [model.industryCategoryId integerValue];
                currentModel = model;
            }
                break;
            case regionLocationType:{
                
                if (firstTap == 0) {
                    
                    firstTap++;
                }
                else {
                    
                    if (indexPath.row == 0) {
                        
                        regionLocation.text = @"不限";
                        regionalLocationCategoryId = 0;
                    }
                    else {
                        
                        FindBrankModel *model = _regionalLocation[indexPath.row-1];
                        regionLocation.text = model.categoryName;
                        regionalLocationCategoryId = [model.regionalLocationCategoryId integerValue];
                    }
                    
                    [menu menuClose];
                    // 重置状态
                    firstTap = 0;
                }
            }
                break;
        }
        [menu.leftTableView reloadData];
    }
}

- (void)requestCityWithID:(NSInteger)parentId{
    
    NSDictionary *param = @{@"parentId":[NSNumber numberWithInteger:parentId]};
    
    // 省市
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brandRegion/list.do" params:param success:^(id JSON) {
        
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

#pragma mark - 提交
- (void)commitAction:(UIButton *)btn{
    
    NSLog(@"%@ %@ %@ %d %d %d %d",name.text,phone.text,money.text,industryCategoryId,industryCategoryId2 ,regionalLocationCategoryId,expandingRegion);
    if (name.text.length<1 || phone.text.length<1 || money.text.length<1 || industryCategoryId == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入完整信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (![Tools_F validateMobile:phone.text]){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入有效的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        
        // 请求参数
        NSDictionary *param = @{
                                @"expandingRegion":[NSNumber numberWithInteger:expandingRegion],
                                @"industryCategoryId1":[NSNumber numberWithInteger:industryCategoryId],
                                @"industryCategoryId2":[NSNumber numberWithInteger:industryCategoryId2],
                                @"investmentAmount":money.text,
                                @"name":name.text,
                                @"phone":phone.text,
                                @"regionalLocationCategoryId":[NSNumber numberWithInteger:regionalLocationCategoryId]
                                };
        
        [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brandFind/add.do" params:param success:^(id JSON) {
            
            NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
            
            NSArray *arr = JSON[@"data"];

            if ([JSON[@"status"] intValue] == 1) {
                
                if ([arr isEqual:[NSNull null]]) {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"找不到相应品牌" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
                else {
                    
                    FindBrankResultViewController *fbrVC = [[FindBrankResultViewController alloc] init];
                    fbrVC.dataSource = arr;
                    fbrVC.conditionStr = @[exRegion.text,industry.text,regionLocation.text];
                    [self.navigationController pushViewController:fbrVC animated:YES];
                }
            }
            
        } failure:^(NSError *error) {
            
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
