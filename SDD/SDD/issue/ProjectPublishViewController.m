//
//  ProjectPublishViewController.m
//  SDD
//
//  Created by hua on 15/9/14.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ProjectPublishViewController.h"
#import "FormTableViewCell.h"

#import "DevelopersViewController.h"

#import "FSDropDownMenu.h"

typedef NS_ENUM(NSInteger, ColumnType)
{
    developersType = 0,
    cooperationType = 1,
    formatType = 2,
    floorType = 3,
    regionType = 4,
};

@interface ProjectPublishViewController ()<FSDropDownMenuDataSource,FSDropDownMenuDelegate,
UITableViewDataSource,UITableViewDelegate>{
    
    /*- ui -*/
    
    UIView *top_bg;
    UIView *first_bottombg;
    UIView *second_bottombg;
    UIView *last_bottombg;
    
    UITableView *first_table;
    UITableView *second_table;
    UITableView *last_table;
    
    FSDropDownMenu *dropMenu;
    
    /*- data -*/
    
    ColumnType cType;
    
    NSString *projectName;    /**< 项目名称 */
    NSString *projectAddress;    /**< 项目地址 */
    NSString *projectIntroduce;    /**< 项目介绍 */
    
    NSString *developersId;    /**< 开发商 */
    NSInteger cooperationId;    /**< 合作方式 */
    
    
    // cell上的text
    
}

@end

@implementation ProjectPublishViewController

#pragma mark - 请求数据
- (void)requestData{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = bgColor;
    first_bottombg = [[UIView alloc] init];
    second_bottombg = [[UIView alloc] init];
    last_bottombg = [[UIView alloc] init];
    
    // nav
    [self setNav:@"项目发布"];
    // 数据请求
    [self requestData];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    // 上方步骤
    top_bg = [[UIView alloc] init];
    top_bg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:top_bg];
    
    [top_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 45));
    }];
    
    NSArray *stepTitle = @[@"1、基本信息",@"2、项目详情",@"3、上传资料"];
    
    UIButton *lastBtn;
    for (int i=0; i<stepTitle.count; i++) {
        
        // 步骤
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.font = midFont;
        btn.tag = 100+i;
        [btn setTitle:stepTitle[i] forState:UIControlStateNormal];
        [btn setTitleColor:lgrayColor forState:UIControlStateNormal];
        [btn setTitleColor:dblueColor forState:UIControlStateSelected];
        btn.userInteractionEnabled = NO;
        [btn addTarget:self action:@selector(stepClick:) forControlEvents:UIControlEventTouchUpInside];
        [top_bg addSubview:btn];
        
        btn.selected = lastBtn?NO:YES;
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(top_bg.mas_top);
            make.left.equalTo(lastBtn?lastBtn.mas_right:top_bg.mas_left);
            make.size.mas_equalTo(CGSizeMake(viewWidth/3, 45));
        }];
        
        if (lastBtn) {
            
            // 箭头
            UIImageView *arrow = [[UIImageView alloc] init];
            arrow.backgroundColor = [UIColor whiteColor];
            arrow.image = [UIImage imageNamed:@"home_top_arrow_deepblue"];
            arrow.contentMode = UIViewContentModeScaleAspectFit;
            [top_bg addSubview:arrow];
            
            [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(lastBtn.mas_centerY);
                make.centerX.equalTo(lastBtn.mas_right);
                make.size.mas_equalTo(CGSizeMake(13, 13));
            }];
        }
        
        lastBtn = btn;
    }
    
    // 下方内容
    NSArray *bottomViews = @[first_bottombg,second_bottombg,last_bottombg];
    for (int i=0; i<[bottomViews count]; i++) {
        
        UIView *view = bottomViews[i];
        view.backgroundColor = bgColor;
        view.hidden = YES;
        [self.view addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(top_bg.mas_bottom).offset(10);
            make.left.equalTo(self.view.mas_left);
            make.width.equalTo(self.view.mas_width);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    }
    
    // 设置内容
    [self setupFirst];
    [self setupSecond];
    [self setupLast];
    
    // 栏目选择
    dropMenu = [[FSDropDownMenu alloc] initWithOrigin:CGPointMake(0, viewHeight-364) andHeight:300];
    dropMenu.dataSource = self;
    dropMenu.delegate = self;
    [self.view addSubview:dropMenu];
}

#pragma mark - 第一步
- (void)setupFirst{
    
    first_bottombg.hidden = NO;
    
    first_table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    first_table.backgroundColor = bgColor;
    first_table.delegate = self;
    first_table.dataSource = self;
    
    [first_bottombg addSubview:first_table];
    [first_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(first_bottombg);
    }];
    
    // 下一步footer
    UIView *footer_bg = [[UIView alloc] init];
    footer_bg.backgroundColor = bgColor;
    footer_bg.frame = CGRectMake(0, 0, viewWidth, 115);
    
    // 按钮
    ConfirmButton *nextButton = [[ConfirmButton alloc] initWithFrame:CGRectMake(20, 20, viewWidth - 40, 45)
                                                                title:@"下一步"
                                                               target:self
                                                               action:@selector(toSecondStep)];
    [footer_bg addSubview:nextButton];
    
    // 协议
    UILabel *protocolLabel = [[UILabel alloc] init];
    protocolLabel.frame = CGRectMake(10, CGRectGetMaxY(nextButton.frame)+10, viewWidth-20, 30);
    protocolLabel.textAlignment = NSTextAlignmentCenter;
    protocolLabel.font = midFont;
    protocolLabel.textColor = lgrayColor;
    [footer_bg addSubview:protocolLabel];
    
    NSString *originalString = @"我已阅读并同意商多多用户协议";
    NSMutableAttributedString *paintString = [[NSMutableAttributedString alloc]initWithString:originalString];
    [paintString addAttributes:@{NSForegroundColorAttributeName: tagsColor,
                                 NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]}
                         range:[originalString rangeOfString:@"商多多用户协议"]];
    protocolLabel.attributedText = paintString;
    
    first_table.tableFooterView = footer_bg;
}

#pragma mark - 第二步
- (void)setupSecond{
    
}

#pragma mark - 最后一步
- (void)setupLast{
    
}

#pragma mark - 步骤选择
- (void)stepClick:(UIButton *)btn{
    
    [self.view endEditing:YES];
    btn.selected = YES;
    // 全隐藏
    first_bottombg.hidden = YES;
    second_bottombg.hidden = YES;
    last_bottombg.hidden = YES;
    // 显示
    NSInteger index = (NSInteger)btn.tag-100;
    switch (index) {
        case 0:
        {
            first_bottombg.hidden = NO;
        }
            break;
        case 1:
        {
            second_bottombg.hidden = NO;
        }
            break;
        case 2:
        {
            last_bottombg.hidden = NO;
        }
            break;
    }
}

#pragma mark - 跳第二步
- (void)toSecondStep{
    
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == first_table) {
        
        if (indexPath.section == 1) {
            
            return 120;
        }
        else {
            
            return 45;
        }
    }
    else {
        
        return 50;
    }
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == first_table) {
        
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
                
                return 1;
            }
                break;
        }
    }
    else {
        return 0;
    }
}

#pragma mark - 设置Sections数 (tableView)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView == first_table) {
        
        return 3;
    }
    else {
        
        return 0;
    }
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //重用标识符
    NSString *identifier = [NSString stringWithFormat:@"GetCoupon%d%d",(int)indexPath.section,(int)indexPath.row];
    //    static NSString *identifier = @"GetCoupon";
    //重用机制
    FormTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
    
    if (cell == nil) {
        // 当不存在的时候用重用标识符生成
        cell = [[FormTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
        cell.textLabel.font = midFont;
    }
    
    if (tableView == first_table) {
        
        switch (indexPath.section) {
            case 0:{
                
                switch (indexPath.row) {
                    case 0:
                    {
                        cell.cellType = withTextView;
                        cell.theTitle.text = @"*项目名称";
                        cell.theSingleDetail.placeholder = @"请输入项目名称";
                    }
                        break;
                    case 1:
                    {
                        cell.cellType = withLabel;
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        cell.theTitle.text = @"*开发商";
                        cell.theSelected.text = @"请选择开发商名称";
                    }
                        break;
                    case 2:
                    {
                        cell.cellType = withTextView;
                        cell.theTitle.text = @"*项目地址";
                        cell.theSingleDetail.placeholder = @"请输入项目地址";
                    }
                        break;
                }
                
                return cell;
            }
            case 1:{
                
                cell.cellType = withLongTextView;
                cell.theTitle.text = @"项目简介";
                cell.theMultipleDetail.placeholderText = @"请输入项目简介";
                return cell;
            }
            default:{
                
                cell.cellType = withLabel;
                cell.theTitle.text = @"*合作方式";
                cell.theSelected.text = @"请输入合作方式";
                return cell;
            }
        }
    }
    else if (tableView == second_table){
        
        return cell;
    }
    else {
        
        return cell;
    }
}

#pragma mark - 点击cell (tableView)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == first_table) {
        switch (indexPath.section) {
            case 0:{
                switch (indexPath.row) {
                    case 0:{
                        
                    }
                        break;
                    case 1:{
                        
                        DevelopersViewController *dVC = [[DevelopersViewController alloc] init];
                        [dVC valueReturn:^(NSString *developerName, NSNumber *developerId) {
                            
                            
                            
                            developerId = developerId;
                        }];
                        
                        [self.navigationController pushViewController:dVC animated:YES];
                    }
                        break;
                    case 2:{
                        
                    }
                        break;
                }
            }
                break;
            case 1:{
                
            }
                break;
            case 2:{
                
            }
        }
    }
}

//- (NSInteger)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
//    
//    if (tableView == menu.leftTableView) {
//        switch (cType) {
//            case industryType:{
//                if (currentModel) {
//                    return [currentModel.children count]+1;
//                }
//                else {
//                    return 0;
//                }
//            }
//                break;
//            case jobType:{
//                
//                return [_jobAll count];
//            }
//                break;
//            case formatType:{
//                
//                return [_formatAll count];
//            }
//                break;
//            case floorType:{
//                
//                return [_floorsAll count];
//            }
//                break;
//            case regionType:{
//                
//                return [currentModel2.areaList count];
//            }
//                break;
//        }
//    }
//    else {
//        switch (cType) {
//            case industryType:{
//                
//                
//                return [_industryAll count];
//            }
//                break;
//            case jobType:{
//                
//                return 1;
//            }
//                break;
//            case formatType:{
//                
//                return 1;
//            }
//                break;
//            case floorType:{
//                
//                return 1;
//            }
//                break;
//            case regionType:{
//                
//                return 1;
//            }
//                break;
//        }
//    }
//}
//
//- (NSString *)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView titleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if (tableView == menu.leftTableView) {
//        switch (cType) {
//            case industryType:{
//                
//                if (indexPath.row == 0) {
//                    return @"不限";
//                }
//                else {
//                    
//                    NSDictionary *tempDic = currentModel.children[indexPath.row-1];
//                    return tempDic[@"categoryName"];
//                }
//            }
//                break;
//            case jobType:{
//                
//                FindBrankModel *model = _jobAll[indexPath.row];
//                return model.categoryName;
//            }
//                break;
//            case formatType:{
//                
//                FindBrankModel *model = _formatAll[indexPath.row];
//                return model.categoryName;
//            }
//                break;
//            case floorType:{
//                
//                FindBrankModel *model = _floorsAll[indexPath.row];
//                return model.floorName;
//            }
//                break;
//            case regionType:{
//                
//                NSDictionary *tempDic = currentModel2.areaList[indexPath.row];
//                return tempDic[@"appointmentAreaName"];
//            }
//                break;
//        }
//        if (indexPath.row == 0) {
//            return @"不限";
//        }
//        else {
//            
//            NSDictionary *tempDic = currentModel.children[indexPath.row-1];
//            return tempDic[@"categoryName"];
//        }
//    }
//    else {
//        switch (cType) {
//            case industryType:{
//                
//                FindBrankModel *model = _industryAll[indexPath.row];
//                return model.categoryName;
//            }
//                break;
//            case jobType:{
//                
//                return @"职务";
//            }
//                break;
//            case formatType:{
//                
//                return @"业态";
//            }
//                break;
//            case floorType:{
//                
//                return @"楼层";
//            }
//                break;
//            case regionType:{
//                
//                return @"区域";
//            }
//                break;
//        }
//    }
//}
//
//- (void)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (tableView == menu.leftTableView) {
//        switch (cType) {
//            case industryType:{
//                if (indexPath.row == 0) {
//                    
//                    industryTextfield.text = [NSString stringWithFormat:@"%@-不限",currentModel.categoryName];
//                    industryCategoryId2 = 0;
//                }
//                else {
//                    
//                    NSDictionary *tempDic = currentModel.children[indexPath.row-1];
//                    industryTextfield.text = tempDic[@"categoryName"];
//                    industryCategoryId2 = [tempDic[@"industryCategoryId"] integerValue];
//                }
//            }
//                break;
//            case jobType:{
//                
//                FindBrankModel *model = _jobAll[indexPath.row];
//                jobTextfield.text = model.categoryName;
//                postCategoryId = [model.postCategoryId integerValue];
//            }
//                break;
//            case formatType:{
//                
//                FindBrankModel *model = _formatAll[indexPath.row];
//                formatTextfield.text = model.categoryName;
//                industryId = [model.industryCategoryId integerValue];
//                
//                // 重置楼层、区域
//                floorsTextfield.text = @"";
//                floor = 0;
//                appointmentAreaId = 0;
//                regionTextfield.text = @"";
//            }
//                break;
//            case floorType:{
//                
//                FindBrankModel *model = _floorsAll[indexPath.row];
//                floorsTextfield.text = model.floorName;
//                floor = [model.floor integerValue];
//                currentModel2 = model;
//                
//                // 重置区域
//                appointmentAreaId = 0;
//                regionTextfield.text = @"";
//            }
//                break;
//            case regionType:{
//                
//                NSDictionary *tempDic = currentModel2.areaList[indexPath.row];
//                appointmentAreaId = [tempDic[@"appointmentAreaId"] integerValue];
//                regionTextfield.text = tempDic[@"appointmentAreaName"];
//            }
//                break;
//        }
//    }
//    else {
//        switch (cType) {
//            case industryType:{
//                
//                FindBrankModel *model = _industryAll[indexPath.row];
//                industryCategoryId = [model.industryCategoryId integerValue];
//                currentModel = model;
//            }
//                break;
//            case jobType:{
//                
//            }
//                break;
//            case formatType:{
//                
//            }
//                break;
//            case floorType:{
//                
//            }
//                break;
//            case regionType:{
//                
//            }
//                break;
//        }
//        [menu.leftTableView reloadData];
//    }
//}

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
