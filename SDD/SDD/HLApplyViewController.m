//
//  HLApplyViewController.m
//  SDD
//
//  Created by hua on 15/4/15.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "HLApplyViewController.h"
#import "LabelTextfieldView.h"
#import "FindBrankModel.h"

#import "ApplySuccessViewController.h"

#import "FSDropDownMenu.h"
#import "UIImageView+WebCache.h"

@interface HLApplyViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,
FSDropDownMenuDataSource,FSDropDownMenuDelegate>{
    
    
    /*- ui -*/
    
    UITableView *table;
    FSDropDownMenu *dropMenu;
    
    // 中部
    UIView *bottonView;
    // 看房团标题
    UILabel *houseTitle;
    // 已报名
    UILabel *applicants;
    
    // 姓名
    UITextField *name;
    // 报名人数
    UITextField *applicantsNum;
    // 行业
    UITextField *industry;
    // 品牌
    UITextField *brankName;
    // 手机号
    UITextField *phoneNum;
    // 验证码
    UITextField *code;
    
    UIButton *getCode;                            /**< 获取验证码 */

    
    /*- data -*/
    
    FindBrankModel *currentModel;
    NSInteger industryCategoryId;
    NSInteger industryCategoryId2;
    
    NSTimer *timer;                  // 倒计时
    NSInteger _second;               // 秒数
    
    NSArray *contentTitle;          /**< 表格标题 */

}

// 行业类别
@property (nonatomic, strong) NSMutableArray *industryAll;

@end

@implementation HLApplyViewController

- (NSMutableArray *)industryAll{
    if (!_industryAll) {
        _industryAll = [[NSMutableArray alloc]init];
    }
    return _industryAll;
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
    self.view.backgroundColor = bgColor;
    
    industryCategoryId = 0;
    industryCategoryId2 = 0;
    _second = 60;
    // 导航条
    [self setNav:@"报名"];
    // 数据请求
    [self requestData];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    contentTitle = @[@[@"线路介绍:",@"商铺:",@"所属区域:"],
                     @[@"*姓名:",@"*报名人数:",@"行业:",@"品牌:"],
                     @[@"*手机号:",@"*验证码:"]];
    
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
    
    // head
    UIView *headView = [[UIView alloc] init];
    headView.frame = CGRectMake(0, 0, viewWidth, 90);
    headView.backgroundColor = [UIColor whiteColor];
    
    houseTitle = [[UILabel alloc] init];
    houseTitle.frame = CGRectMake(10, 25, viewWidth-20, 20);
    houseTitle.font =  largeFont;
    houseTitle.textColor = mainTitleColor;
    houseTitle.text = [NSString stringWithFormat:@"%@考察团报名",_model.hk_house[@"houseName"]];
    houseTitle.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:houseTitle];
    
    applicants = [[UILabel alloc] init];
    applicants.frame = CGRectMake(10, CGRectGetMaxY(houseTitle.frame)+10, viewWidth-20, 15);
    applicants.font = midFont;
    applicants.textColor = lgrayColor;
    applicants.text = [NSString stringWithFormat:@"已有%@人报名,报名截止至%@",_model.hk_applyPeopleQty,[Tools_F timeTransform:[_model.hk_showingsEndtime floatValue] time:days]];
    applicants.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:applicants];
    
    table.tableHeaderView = headView;
    
    // footer
    UIView *footer_bg = [[UIView alloc] init];
    footer_bg.frame = CGRectMake(0, 0, viewWidth, 65);
    footer_bg.backgroundColor = [UIColor whiteColor];
    
    // 报名按钮
    ConfirmButton *applyButton = [[ConfirmButton alloc] initWithFrame:CGRectMake(20, 10, viewWidth - 40, 45)
                                                                title:@"立即报名"
                                                               target:self
                                                               action:@selector(applyClick:)];
    applyButton.enabled = YES;
    [footer_bg addSubview:applyButton];
    
    table.tableFooterView = footer_bg;
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:{
            
            return 3;
        }
            break;
        case 1:{
            
            return 4;
        }
            break;
        default:
        {
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
    
    return 10;
}

#pragma mark - 设置section 脚高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 2) {
        return 10;
    }
    return 0.1;
}

#pragma mark - 设置cell (tableView)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //重用标识符
    static NSString *identifier = @"Getdiscount";
    //重用机制
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
    
    UILabel *label;
    UITextField *textfield;
    if (cell == nil) {
        
        // 当不存在的时候用重用标识符生成
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;                // 设置选中背景色不变
        
        cell.textLabel.font = midFont;
        cell.textLabel.textColor = mainTitleColor;
        cell.detailTextLabel.font = midFont;
        cell.detailTextLabel.textColor = lgrayColor;
        
        if (indexPath.section == 0) {
            
            label = [[UILabel alloc] init];
            label.frame = CGRectMake(viewWidth*0.2, 0, viewWidth*0.7, 45);
            label.font = midFont;
            label.textColor = lgrayColor;
            [cell addSubview:label];
        }
        else {
            
            textfield = [[UITextField alloc] init];
            textfield.frame = CGRectMake(viewWidth*0.2, 0, viewWidth*0.7, 45);
            textfield.textAlignment = NSTextAlignmentRight;
            textfield.font = midFont;
            textfield.textColor = lgrayColor;
            textfield.delegate = self;
            [cell addSubview:textfield];
            
            if (indexPath.section == 2 && indexPath.row == 1) {
                
                UIView *rightView_bg = [[UIView alloc] init];
                rightView_bg.frame = CGRectMake(0, 0, 100, 45);
                rightView_bg.backgroundColor = [UIColor whiteColor];
                
                UIView *cutoff = [[UIView alloc] init];
                cutoff.frame = CGRectMake(0, 10, 1, 25);
                cutoff.backgroundColor = divisionColor;
                [rightView_bg addSubview:cutoff];
                
                getCode = [UIButton buttonWithType:UIButtonTypeCustom];
                getCode.frame = CGRectMake(CGRectGetMaxX(cutoff.frame), 0, 99, 45);
                [getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                [getCode setTitleColor:mainTitleColor forState:UIControlStateNormal];
                getCode.titleLabel.font = midFont;
                [getCode addTarget:self action:@selector(verificationCode:) forControlEvents:UIControlEventTouchUpInside];
                [rightView_bg addSubview:getCode];
                
                textfield.textAlignment = NSTextAlignmentLeft;
                textfield.rightView = rightView_bg;
                textfield.rightViewMode = UITextFieldViewModeAlways;
            }
            else if (indexPath.section == 1 && indexPath.row == 2) {
                
                textfield.frame = CGRectMake(viewWidth*0.5, 0, viewWidth*0.4, 45);
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;       // 显示箭头
            }
        }
        
        switch (indexPath.section) {
            case 0:
            {
                switch (indexPath.row) {
                    case 0:
                    {
                        label.text = _model.hk_showingsLineIntroduction;
                    }
                        break;
                    case 1:
                    {
                        label.text = _model.hk_house[@"perferentialContent"];
                    }
                        break;
                    default:
                    {
                        label.text = _model.hk_showingsErea;
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
                        textfield.placeholder = @"请输入您的真实姓名";
                        name = textfield;
                    }
                        break;
                    case 1:
                    {
                        textfield.placeholder = @"请输入报名人数";
                        applicantsNum = textfield;
                        applicantsNum.keyboardType = UIKeyboardTypeNumberPad;
                    }
                        break;
                    case 2:
                    {
                        textfield.placeholder = @"请选择您的行业";
                        industry = textfield;
                    }
                        break;
                    default:
                    {
                        textfield.placeholder = @"请输入您品牌名称";
                        brankName = textfield;
                    }
                        break;
                }
            }
                break;
            default:
            {
                switch (indexPath.row) {
                    case 0:
                    {
                        textfield.placeholder = @"请输入您的手机号";
                        phoneNum = textfield;
                        phoneNum.keyboardType = UIKeyboardTypeNumberPad;
                    }
                        break;
                    default:
                    {
                        textfield.placeholder = @"请输入验证码";
                        code = textfield;
                        code.keyboardType = UIKeyboardTypeNumberPad;
                    }
                        break;
                }
            }
                break;
        }
    }
    
    NSString *originalStr = contentTitle[indexPath.section][indexPath.row];
    NSMutableAttributedString *paintStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
    [paintStr addAttributes:@{NSForegroundColorAttributeName: tagsColor} range:[originalStr rangeOfString:@"*"]];
    cell.textLabel.attributedText = paintStr;
    
    return cell;
}

#pragma mark - 点击cell (tableView)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1 && indexPath.row == 2) {
        
        [self.view endEditing:YES];
        [dropMenu.rightTableView reloadData];
        [dropMenu menuTapped];
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
            
            industry.text = [NSString stringWithFormat:@"%@-不限",currentModel.categoryName];
            industryCategoryId2 = 0;
        }
        else {
            
            NSDictionary *tempDic = currentModel.children[indexPath.row-1];
            industry.text = tempDic[@"categoryName"];
            industryCategoryId2 = [tempDic[@"industryCategoryId"] integerValue];
        }
    }
    else{
        
        FindBrankModel *model = _industryAll[indexPath.row];
        industryCategoryId = [model.industryCategoryId integerValue];
        currentModel = model;
        [menu.leftTableView reloadData];
    }
}

#pragma mark - textField代理
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return textField == industry?NO:YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

#pragma mark - 获取验证码
- (void)verificationCode:(UIButton *)btn{
    
    if ([Tools_F validateMobile:phoneNum.text]) {
        
        NSDictionary *dic = @{@"phone": phoneNum.text};
        [self requesCode:dic];
    } else {
        
        UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入有效的手机号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)requesCode:(NSDictionary *)dic{
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timingOfSixtySecond) userInfo:nil repeats:YES];
    
    // 请求参数
    NSString *urlString = [SDD_MainURL stringByAppendingString:@"/sms/sendHouseShowingsCode.do"];              // 拼接主路径和请求内容成完整url
    
    [self.httpManager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = responseObject;
        NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
        
        if ([dict[@"status"] intValue] == 1) {
            
            UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"提示" message:dict[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
}

- (void)timingOfSixtySecond{
    
    getCode.userInteractionEnabled = NO;
    NSString *secondStr = [NSString stringWithFormat:@"%d秒后重新获取",(_second--) - 1];
    [getCode setTitleColor:[SDDColor sddSmallTextColor] forState:UIControlStateNormal];
    [getCode setTitle:secondStr forState:UIControlStateNormal];
    if (_second == 0) {
        [timer invalidate];
        timer = nil;
        _second = 60;
        [getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        [getCode setTitleColor:mainTitleColor forState:UIControlStateNormal];
        getCode.userInteractionEnabled = YES;
    }
}

#pragma mark - 立刻报名
- (void)applyClick:(UIButton *)btn{
    
    if (name.text.length<1 || applicantsNum.text.length<1 || industry.text.length<1 ||
        brankName.text.length<1 ||!industryCategoryId || !industryCategoryId2 ||
        phoneNum.text.length<1 || code.text.length<1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入完整信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        
        NSDictionary *dic = @{@"realName":name.text,
                              @"peopleQty":applicantsNum.text,
                              @"phone":phoneNum.text,
                              @"code":code.text,
                              @"houseShowingsId":_model.hk_houseShowingsId,
                              @"preferentialCategoryId1":[NSNumber numberWithInteger:industryCategoryId],
                              @"preferentialCategoryId2":[NSNumber numberWithInteger:industryCategoryId2],
                              @"brandName":brankName.text
                              };

        [HttpTool postWithBaseURL:SDD_MainURL Path:@"/user/house/apply.do" params:dic success:^(id JSON) {
            
            NSLog(@"%@\n%@>>>>>>>%@",dic,JSON[@"message"],JSON);
            
            if ([JSON[@"status"] intValue] == 1) {
        
                ApplySuccessViewController *appSuccessVC = [[ApplySuccessViewController alloc] init];
                
                appSuccessVC.hkTitle = _model.hk_showingsTitle;        
                appSuccessVC.hkInfo = @[_model.hk_showingsLineIntroduction,_model.hk_house[@"perferentialContent"],
                                        _model.hk_showingsErea,applicantsNum.text,name.text,industry.text,
                                        brankName.text
                                        ];
                appSuccessVC.houseID = _model.hk_houseId;
        
                [self.navigationController pushViewController:appSuccessVC animated:YES];
            }
            else {
                
                UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"提示"
                                                               message:JSON[@"message"]
                                                              delegate:self
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil, nil];
                [alert show];
            }
            
        } failure:^(NSError *error) {
            
            NSLog(@"考察团错误 -- %@", error);
        }];
    }
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
