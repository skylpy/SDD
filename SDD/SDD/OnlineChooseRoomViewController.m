//
//  OnlineChooseRoomViewController.m
//  SDD
//
//  Created by hua on 15/6/3.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "OnlineChooseRoomViewController.h"
#import "HouseChooseModel.h"

#import "OrderConfirmationViewController.h"

#import "HouseChooseAddition.h"
#import "UIImageView+WebCache.h"

@interface OnlineChooseRoomViewController ()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>{
    
    /*- ui -*/
    
    UITableView *table;                                    // table主体
    
    UIImageView *headerView;                               // table头
    UIView *footerView;                                    // table脚
    
    HouseChooseAddition *hca;                              // 铺位
    
    /*- data -*/
    
    HouseChooseModel *model;
    
    NSMutableArray *tableTitle;                            // 标题
    NSMutableArray *tableContent;                          // 内容
    NSArray *industryCategorys;                            // 业态
    NSArray *buildingNames;                                // 楼座
    NSArray *floors;                                       // 楼层
    NSArray *stores;                                       // 铺位（面积）
    NSArray *typeCategorys;                                // 类型
    NSArray *unitIds;                                      // 铺位id
    
    NSString *currentTypeCategoryId;                       // 当前类型id
    NSString *currentIndustryCategoryId;                   // 当前业态id
    NSMutableArray *currentUnitId;                         // 当前铺位id
    NSString *currentBuilding;
    NSString *currentFloor;
    NSMutableArray *currentStore;
    
}

@end

@implementation OnlineChooseRoomViewController


#pragma mark - 请求数据
- (void)requestData{
    
    // 请求参数
    NSDictionary *dic = @{@"houseId":_houseID};
    
    NSString *urlString = [SDD_MainURL stringByAppendingString:@"/admin/house/onlineData.do"];              // 拼接主路径和请求内容成完整url
    
    [self sendRequest:dic url:urlString];
}

- (void)onSuccess:(AFHTTPRequestOperation *)operation context:(id)responseObject {
    
    NSDictionary *dict = responseObject;
    NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
    if (![dict[@"data"] isEqual:[NSNull null]]) {
        
        // 装入模型
        model = [[HouseChooseModel alloc] init];
        model.hc_houseIndustryCategorys = dict[@"data"][@"houseIndustryCategorys"];
        model.hc_houseTypeCategorys = dict[@"data"][@"houseTypeCategorys"];
        model.hc_houseBuildings = dict[@"data"][@"houseBuildings"];
        model.hc_brandPresenceNotice = dict[@"data"][@"brandPresenceNotice"];
        model.hc_rentPreferentialEndtimeStr = dict[@"data"][@"rentPreferentialEndtimeStr"];
        model.hc_rentRule = dict[@"data"][@"rentRule"];
        
        // 载入数据
        NSMutableArray *tempMuArr = [NSMutableArray array];
        
        for (NSDictionary *tempDic in model.hc_houseIndustryCategorys) {
            [tempMuArr addObject:tempDic];
        }
        industryCategorys = tempMuArr;           // 业态
        
        NSMutableArray *tempMuArr2 = [NSMutableArray array];
        for (NSDictionary *tempDic in model.hc_houseBuildings) {
            [tempMuArr2 addObject:tempDic[@"buildingName"]];
        }
        buildingNames = tempMuArr2;              // 楼座
        
        NSMutableArray *tempMuArr3 = [NSMutableArray array];
        for (NSDictionary *tempDic in model.hc_houseTypeCategorys) {
            [tempMuArr3 addObject:tempDic];
        }
        typeCategorys = tempMuArr3;              // 类型
        
        // 团购须知
        UILabel *title_f = [[UILabel alloc] init];
        title_f.frame = CGRectMake(8, 0, viewWidth-16, 35);
        title_f.font = midFont;
        title_f.text = @"团租须知";
        [footerView addSubview:title_f];
        
        UIView *cutOff = [[UIView alloc] init];
        cutOff.frame = CGRectMake(0, CGRectGetMaxY(title_f.frame), viewWidth, 1);
        cutOff.backgroundColor = bgColor;
        [footerView addSubview:cutOff];
        
        // 团租有效期
        UILabel *title_s = [[UILabel alloc] init];
        title_s.frame = CGRectMake(8, CGRectGetMaxY(cutOff.frame)+9, viewWidth-16, 10);
        title_s.font = littleFont;
        title_s.textColor = lgrayColor;
        title_s.text = @"团租截止日: ";
        [footerView addSubview:title_s];
        
        NSString *str_s = [NSString stringWithFormat:@"%@",model.hc_rentPreferentialEndtimeStr];
        CGSize size_s = [Tools_F countingSize:str_s fontSize:10 width:viewWidth-16];
        
        UILabel *content_s = [[UILabel alloc] init];
        content_s.frame = CGRectMake(8, CGRectGetMaxY(title_s.frame)+9, viewWidth-16, size_s.height);
        content_s.font = midFont;
        content_s.text = str_s;
        [footerView addSubview:content_s];
        
        // 品牌进驻须知
        UILabel *title_t = [[UILabel alloc] init];
        title_t.frame = CGRectMake(8, CGRectGetMaxY(content_s.frame)+9, viewWidth-16, 10);
        title_t.font = littleFont;
        title_t.textColor = lgrayColor;
        title_t.text = @"品牌进驻须知: ";
        [footerView addSubview:title_t];
        
        NSString *str_t = [NSString stringWithFormat:@"%@",model.hc_brandPresenceNotice];
        CGSize size_t = [Tools_F countingSize:str_s fontSize:10 width:viewWidth-16];
        
        UILabel *content_t = [[UILabel alloc] init];
        content_t.frame = CGRectMake(8, CGRectGetMaxY(title_t.frame)+9, viewWidth-16, size_t.height);
        content_t.font = midFont;
        content_t.text = str_t;
        [footerView addSubview:content_t];
        
        // 团租规则
        UILabel *title_fo = [[UILabel alloc] init];
        title_fo.frame = CGRectMake(8, CGRectGetMaxY(content_t.frame)+9, viewWidth-16, 10);
        title_fo.font = littleFont;
        title_fo.textColor = lgrayColor;
        title_fo.text = @"团租规则: ";
        [footerView addSubview:title_fo];
        
        NSString *str_fo = [NSString stringWithFormat:@"%@",model.hc_rentRule];
        CGSize size_fo = [Tools_F countingSize:str_s fontSize:10 width:viewWidth-16];
        
        UILabel *content_fo = [[UILabel alloc] init];
        content_fo.frame = CGRectMake(8, CGRectGetMaxY(title_fo.frame)+9, viewWidth-16, size_fo.height);
        content_fo.font = midFont;
        content_fo.text = str_fo;
        [footerView addSubview:content_fo];
        
        // 底部动态高度
        footerView.frame = CGRectMake(0, 0, viewWidth, 245);
        
        [table reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 加载数据
    [self requestData];
    // 导航条
    [self setupNav];
    // 设置内容
    [self setupUI];
    // 设置数据
    [self setupDataSource];
}

#pragma mark - 设置导航条
- (void)setupNav{
    
    [self setNav:@"在线选房"];
}

#pragma mark - 设置数据
- (void)setupDataSource{
    
    tableTitle = [[NSMutableArray alloc] initWithArray:@[@"业态: ",
                                                         @"楼座: ",
                                                         @"楼层: ",
                                                         @"铺位: ",
                                                         @"面积: ",
                                                         @"公司: ",
                                                         @"品牌: ",
                                                         @"类型: ",
                                                         @"姓名: ",
                                                         @"职务: ",
                                                         @"手机号: "
                                                         ]];
    
    tableContent = [[NSMutableArray alloc] initWithArray:@[@"请选择业态",
                                                           @"请选择楼座",
                                                           @"请选择楼层",
                                                           @"铺位",
                                                           @"面积",
                                                           @"请填写公司名",
                                                           @"请填写品牌",
                                                           @"请选择类型",
                                                           @"请填写姓名",
                                                           @"请填写职位",
                                                           @"请填写手机号"
                                                           ]];
    
    currentStore = [[NSMutableArray alloc] initWithArray:@[@"",
                                                           @"",
                                                           @""
                                                           ]];
    
    currentUnitId = [[NSMutableArray alloc] initWithArray:@[@"",
                                                           @"",
                                                           @""
                                                           ]];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    // 内容
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-64) style:UITableViewStyleGrouped];
    table.backgroundColor = bgColor;
    table.delegate = self;
    table.dataSource = self;
    
    headerView = [[UIImageView alloc] init];
    headerView.frame = CGRectMake(0, 0, viewWidth, 235);
    headerView.image = [UIImage imageNamed:@"loading_b"];
    
    table.tableHeaderView = headerView;
    
    footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, viewWidth, 245);
    footerView.backgroundColor = [UIColor whiteColor];
    
    table.tableFooterView = footerView;
    
    [self.view addSubview:table];
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 3) {
        return 60;
    }
    else if (indexPath.row == 10) {
        return 50;
    }
    else {
        return 30;
    }
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 11;
}

#pragma mark - 设置section 头高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}

#pragma mark - 设置section 脚高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 8;
}

#pragma mark - 设置cell (tableView)
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=nil;
    // 重用标识符
    NSString *identifier = [NSString stringWithFormat:@"TimeLineCell%d%d",(int)indexPath.section,(int)indexPath.row];
    
    if (cell == nil) {
        //当不存在的时候用重用标识符生成
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.textLabel.font = midFont;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
    }
    
    if (indexPath.row < 3) {
        
        // 标题
        cell.textLabel.text = tableTitle[indexPath.row];
        
        UITextField *text = [[UITextField alloc] init];
        text.frame = CGRectMake(70, 0, viewWidth-70, 30);
        text.tag = 1000+indexPath.row;
        text.delegate = self;
        text.text = tableContent[indexPath.row];
        text.font = midFont;
        
        [cell addSubview:text];
        
        if (indexPath.row == 2 && !currentBuilding) {
            
            text.enabled = NO;
        }
        else {
            
            [self addPickViewAndToolBar:text tag:indexPath.row];
        }
    }
    else if (indexPath.row == 3){
        
        // 铺位+面积
        hca = [[HouseChooseAddition alloc] init];
        hca.frame = CGRectMake(0, 0, viewWidth, 60);
        hca.title_a.text = tableTitle[indexPath.row];
        hca.title_b.text = tableTitle[indexPath.row+1];
        hca.imgBg.image = [UIImage imageNamed:@"index_cutOffGroup"];
        
        for (int i=0; i<3; i++) {
            
            UITextField *text = (UITextField *)[hca viewWithTag:100+i];
            UITextField *text2 = (UITextField *)[hca viewWithTag:100+i+3];
            
            text.delegate = self;
            text2.delegate = self;
            text2.tag = text2.tag+100;
            
            NSArray *arr = [currentStore[i] componentsSeparatedByString:@"                 "];
            
            if ([arr count]>1) {
                
                text.text = arr[0];//
                text2.text = arr[1];
            }
            
            if (!currentFloor) {
                
                text.enabled = NO;
            }
            else {
                
                [self addPickViewAndToolBar:text tag:text.tag];
            }
        }
        
        [cell addSubview:hca];
    }
    else if (indexPath.row > 3 && indexPath.row < 10){
        
        // 标题
        cell.textLabel.text = tableTitle[indexPath.row+1];
        
        UITextField *text = [[UITextField alloc] init];
        text.frame = CGRectMake(70, 0, viewWidth-70, 30);
        text.tag = 1000+indexPath.row;
        text.delegate = self;
        text.text = tableContent[indexPath.row+1];
        text.clearsOnBeginEditing = YES;
        text.font = midFont;
        
        // 类型选择
        if (indexPath.row == 6) {
            
            text.clearsOnBeginEditing = NO;
            [self addPickViewAndToolBar:text tag:indexPath.row];
        }
        if (indexPath.row == 9) {
            
            text.keyboardType = UIKeyboardTypeNumberPad;
        }
        
        [cell addSubview:text];
    }
    else {
        
        UIButton *sighUp = [UIButton buttonWithType:UIButtonTypeCustom];
        sighUp.frame = CGRectMake(38, 9, viewWidth - 76, 32);
        sighUp.titleLabel.font = largeFont;
        sighUp.layer.cornerRadius = 5;
        sighUp.backgroundColor = deepOrangeColor;
        [sighUp setTitle:@"立即登记" forState:UIControlStateNormal];
        [sighUp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sighUp addTarget:self action:@selector(sighUpNow) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:sighUp];
    }
    
    return cell;
}

#pragma mark - 点击cell (tableView)
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == 2 && !currentBuilding) {
        
        [self showInfoWithText:@"请先选择楼座"];
    }
    if (indexPath.row == 3 && !currentFloor) {
        
        [self showInfoWithText:@"请先选择楼层"];
    }
}

#pragma mark - 增加弹出窗
- (void)addPickViewAndToolBar:(UITextField *)textField tag:(NSInteger)theTag{
    
    // 增加pickview
    UIPickerView *pickView = [[UIPickerView alloc] init];
    pickView.tag = theTag+100;
    pickView.frame = CGRectMake(0, (viewHeight-64)/2+40, viewWidth, viewHeight/2);
    pickView.showsSelectionIndicator = YES;
    pickView.backgroundColor = [UIColor whiteColor];
    pickView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    pickView.delegate = self;
    
    // 增加工具条
    UIToolbar*tool=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, viewWidth, 40)];
    
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, 0, 40, 40);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:deepOrangeColor forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem*item1=[[UIBarButtonItem alloc]initWithCustomView:cancelButton];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 0, viewWidth/3, 40);
    titleLabel.text = theTag < 100? [NSString stringWithFormat:@"%@选择",[tableTitle[theTag] substringToIndex:2]]:@"铺位选择";       // 截除冒号后拼接‘选择’
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIBarButtonItem*item2=[[UIBarButtonItem alloc]initWithCustomView:titleLabel];
    
    UIButton *comfirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    comfirmButton.frame = CGRectMake(0, 0, 40, 40);
    [comfirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [comfirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [comfirmButton addTarget:self action:@selector(comfirmButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem*item3=[[UIBarButtonItem alloc]initWithCustomView:comfirmButton];
    
    tool.items=[[NSArray alloc]initWithObjects:item1,flexible,item2,flexible,item3, nil];
    
    // 加载
    textField.inputView = pickView;
    textField.inputAccessoryView = tool;
}

#pragma mark - 取消
- (void)cancelSelect:(UIButton *)btn{
    
    // 回收
    [self.view endEditing:YES];
}

#pragma mark - 确认
- (void)comfirmButton:(UIButton *)btn{
    
    [table reloadData];
}

#pragma mark - pickview设置列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView{
    
    return 1;
}

#pragma mark - pickview返回数组总数
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component{
    
    switch (thePickerView.tag) {
        case 100:
        {
            // 业态
            return [industryCategorys count];
        }
            break;
        case 101:
        {
            // 楼座
            return [buildingNames count];
        }
            break;
        case 102:
        {
            // 楼层
            return [floors count];
        }
            break;
        case 106:
        {
            // 类型
            return [typeCategorys count];
        }
            break;
        default:
        {
            // 铺位
            return [stores count];
        }
            break;
    }
}

#pragma mark - pickview显示内容
- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    switch (thePickerView.tag) {
        case 100:
        {
            // 业态
            return industryCategorys[row][@"categoryName"];
        }
            break;
        case 101:
        {
            // 楼座
            return buildingNames[row];
        }
            break;
        case 102:
        {
            // 楼层
            return floors[row];
        }
            break;
        case 106:
        {
            // 类型
            return typeCategorys[row][@"categoryName"];
        }
            break;
        default:
        {
            // 铺位
            return stores[row];
        }
            break;
    }
}

#pragma mark - pick选中事件
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    switch (thePickerView.tag) {
        case 100:
        {
            // 业态
            currentIndustryCategoryId = industryCategorys[row][@"industryCategoryId"];
            [tableContent replaceObjectAtIndex:0 withObject:industryCategorys[row][@"categoryName"]];
        }
            break;
        case 101:
        {
            // 楼座
            
            // 得到该楼座的所有层数
            NSMutableArray *arr = [NSMutableArray array];
            for (NSDictionary *tempDic in model.hc_houseBuildings) {
                if (tempDic[@"buildingName"] == buildingNames[row]) {
                    for (NSDictionary *tempDic2 in tempDic[@"houseBuildingFloors"]) {
                        [arr addObject:tempDic2[@"floorName"]];
                    }
                }
            }
            floors = arr;
            
            // 子属性跟着变化
            currentBuilding = buildingNames[row];
            currentFloor = nil;
            currentStore = nil;
            [tableContent replaceObjectAtIndex:1 withObject:buildingNames[row]];
            [tableContent replaceObjectAtIndex:2 withObject:@"请选择楼层"];
            
        }
            break;
        case 102:
        {
            // 楼层
            NSMutableArray *arr = [NSMutableArray array];
            NSMutableArray *arr2 = [NSMutableArray array];
            for (NSDictionary *tempDic in model.hc_houseBuildings) {
                if (tempDic[@"buildingName"] == currentBuilding) {
                    for (NSDictionary *tempDic2 in tempDic[@"houseBuildingFloors"]) {
                        if (tempDic2[@"floorName"] == floors[row]) {
                            // 显示楼层图片
                            [headerView sd_setImageWithURL:[NSURL URLWithString:tempDic2[@"imageUrl"]] placeholderImage:[UIImage imageNamed:@"loading_b"]];
                            for (NSDictionary *tempDic3 in tempDic2[@"floorUnits"]) {
                                if ([tempDic3[@"isRent"] intValue] == 0) {
                                    [arr addObject:[NSString stringWithFormat:@"%@                 %@",tempDic3[@"unitName"],tempDic3[@"area"]]];
                                    [arr2 addObject:tempDic3[@"unitId"]];
                                }
                            }
                        }
                    }
                }
            }
            
            stores = arr;
            unitIds = arr2;
            
            // 子属性跟着变化
            currentFloor = floors[row];
            currentStore = [NSMutableArray arrayWithArray:@[@"",@"",@""]];
            [tableContent replaceObjectAtIndex:2 withObject:floors[row]];
        }
            break;
        case 106:{
            
            // 类型
            currentTypeCategoryId = typeCategorys[row][@"typeCategoryId"];
            [tableContent replaceObjectAtIndex:7 withObject:typeCategorys[row][@"categoryName"]];
        }
            break;
            
        default:{
            
            // 检查是否有重复铺位
            [self checkRepetition:row index:thePickerView.tag-200];
        }
            break;
    }
}

#pragma mark - 检查重复
- (void)checkRepetition:(NSInteger)row index:(NSInteger)theIndex{

    NSString *storeName = stores[row];
    NSString *storeId = unitIds[row];
    int i=0;

    for (NSString *str in currentStore) {
        if ([str isEqualToString:storeName]) {
            
            i++;
            [self showErrorWithText:@"不能选择重复铺位"];
        }
    }
    if (i==0) {
        
        [currentStore replaceObjectAtIndex:theIndex withObject:storeName];
        [currentUnitId replaceObjectAtIndex:theIndex withObject:storeId];
    }
}

#pragma mark - textfield代理
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    NSLog(@"开始编辑");
    NSInteger theIndex = textField.tag;
    
    // 各类选择默认选中第一个
    if (theIndex > 999 && theIndex < 1003) {   // 业态 楼座 楼层
        
        UIPickerView *pickView = (UIPickerView *)textField.inputView;
        [self pickerView:pickView didSelectRow:0 inComponent:0];
    }
    else if (theIndex == 1006) {                // 类型选择
        
        UIPickerView *pickView = (UIPickerView *)textField.inputView;
        [self pickerView:pickView didSelectRow:0 inComponent:0];
    }
    else if (theIndex < 203){                   // 店铺选择
        
        UIPickerView *pickView = (UIPickerView *)textField.inputView;
        [self pickerView:pickView didSelectRow:0 inComponent:0];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"结束编辑");
    
    NSInteger theIndex = textField.tag;
    
    // 自定义面积
    if (theIndex > 202 && theIndex < 206) {
        
        NSArray *arr = [currentStore[theIndex-203] componentsSeparatedByString:@"                 "];
        if ([arr count]>1) {
            
            NSString *newStr = [NSString stringWithFormat:@"%@                 %@",arr[0],textField.text];
            
            [currentStore replaceObjectAtIndex:theIndex-203 withObject:newStr];
        }
        NSLog(@"%@",currentStore);
    }
    
    // 填写内容
    if (theIndex > 1003 && theIndex < 1010) {
        
        // 除类型选择外 即时修改tableContent的值
        if (theIndex != 1006) {
            
            [tableContent replaceObjectAtIndex:theIndex-1000+1 withObject:textField.text];
        }
        
        // 手机正则验证通过再更新tableContent的值
        if (theIndex == 1009 && ![Tools_F validateMobile:textField.text]) {
            textField.text = @"";
            [self showErrorWithText:@"输入的手机号不规范，请检查"];
        }
    }
    NSLog(@"%@",tableContent);
    [table reloadData];
}

#pragma mark - 马上登记
- (void)sighUpNow{
    
    OrderConfirmationViewController *orderConfirmation = [[OrderConfirmationViewController alloc] init];
    
    orderConfirmation.theTitle = _theTitle;
    orderConfirmation.houseID = _houseID;
    orderConfirmation.orderType = @"1";
    orderConfirmation.commonData = tableContent;
    orderConfirmation.storesData = currentStore;
    orderConfirmation.currentIndustryCategoryId = currentIndustryCategoryId;
    orderConfirmation.currentTypeCategoryId = currentTypeCategoryId;
    orderConfirmation.currentUnitId = currentUnitId;
    
    [self.navigationController pushViewController:orderConfirmation animated:YES];
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
