//
//  SDD_BasicInformation.m
//  ShopMoreAndMore
//  第一个界面
//  Created by mac on 15/7/4.
//  Copyright (c) 2015年 Mac. All rights reserved.
//
/*
 项目发布的基本信息界面
 开发商列表 合作方式
 */
#import "SDD_BasicInformation.h"
#import "Header.h"
#import "DevCerCell.h"
#import "ButtonCell.h"

@interface SDD_BasicInformation ()<UITextFieldDelegate>
{
//    合作列表
        UITableView    *cooperationTable;
        NSString      *cooperationStr;
        UIView        *bgView;
    
#pragma mark -- 修改 定义四个字符串，用来判断当四个有一个为空串是下一步按钮跳转并提示信息
    NSString * ProjectName;//项目名称
    NSString * ProjectIntroduction;//项目简介
    NSString * ProjectAddress;//项目地址
    NSString * Cooperation;//合作方式
    
    int sctNum;
    
    int ClickOnNum;
}
@property (retain,nonatomic)NSMutableArray * FirstFaceArray ;
@end

@implementation SDD_BasicInformation
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ProjectName = @"";
    ProjectIntroduction = @"";
    ProjectAddress = @"";
    Cooperation = @"";
    
    _FirstFaceArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"", nil];
    
    sctNum = 1;
    ClickOnNum = 1;
    
    // 导航条
    [self createNvn];
    
    [self displayContext];
    cooperationStr = @"请选择合作方式";
}

#pragma mark - 设置导航条
-(void)createNvn
{
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"项目发布";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
#pragma mark -- 隐藏预览
    UIButton *commit = [[UIButton alloc] init];
    commit.frame = CGRectMake(0, 0, 40, 44);
    commit.titleLabel.font = largeFont;
    [commit setTitle:@"预览" forState:UIControlStateNormal];
    [commit addTarget:self action:@selector(lookClick) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:commit];
    
}

- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)displayContext
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = bgColor;//[SDDColor colorWithHexString:@"#e5e5e5"]
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    cooperationTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 44*3) style:UITableViewStylePlain];
    cooperationTable.delegate = self;
    cooperationTable.dataSource = self;
    [self.view addSubview:cooperationTable];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == cooperationTable) {
        return 1;
    }
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == cooperationTable){
        return 2;
    }
    if (section == 1) {
        return 4;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == cooperationTable) {
        return 44;
    }
    if (indexPath.section == 1) {
        
        if (indexPath.row == 3) {
            return 90;
        }
        return 45;
    }
    if (indexPath.section == 3) {
        return 140;
    }
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        
        SDD_BasicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell) {
            cell = [[SDD_BasicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        for (int i=0; i<3; i++) {
            UIButton *button = (UIButton *)[cell viewWithTag:40+i];
            if (button.tag == 40) {
                [button setTitleColor:dblueColor forState:UIControlStateNormal];
            }
        }
        if (indexPath.section == 1) {
            DevCerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            if (!cell) {
                cell = [[DevCerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
            }
            NSArray *array = [NSArray arrayWithObjects:@"项目名称：",@"开 发  商：",@"项目地址：",@"项目简介：",@"请输入项目名称",@"请输入开发商",@"请输入项目地址",@"请介绍项目简介", nil];
            
            
            
            cell.nameLable.text = [array objectAtIndex:indexPath.row];
            cell.textField.placeholder = [array objectAtIndex:indexPath.row+4];
            [cell.textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.mas_top).with.offset(8);
                make.left.equalTo(cell.nameLable.mas_right).with.offset(5);
                make.bottom.equalTo(cell.mas_bottom).with.offset(-8);
                make.width.equalTo(@200);
            }];

#pragma mark -- 修改
            cell.textField.tag = 150+indexPath.row;
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(textFieldChanged:)
                                                         name:UITextFieldTextDidChangeNotification
                                                       object:cell.textField];
            
            
            UIColor *color = [SDDColor colorWithHexString:@"#999999"];
            cell.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[array objectAtIndex:indexPath.row+4] attributes:@{NSForegroundColorAttributeName: color}];
            if (indexPath.row == 1){
                cell.textField.enabled = NO;
                //开发商名字
                if (self.developName != NULL) {
                    cell.textField.text = self.developName;
                    NSLog(@"%@",_developName);
                }
                cell.textField.frame = CGRectMake(75, 16, 250, 13);
                
//                _developName = cell.textField.text;
            }
            if (indexPath.row == 3)
            {
                cell.textField.hidden = YES;
                
                [cell.textView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(cell.mas_top).with.offset(10);
                    make.left.equalTo(cell.nameLable.mas_right).with.offset(5);
                    make.bottom.equalTo(cell.mas_bottom).with.offset(-10);
                    make.width.equalTo(@200);
                }];
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(textViewChanged:)
                                                             name:UITextViewTextDidChangeNotification
                                                           object:cell.textView];
            }
            CELLSELECTSTYLE
            return cell;
        }
        if (indexPath.section == 2) {
            SDD_DetailValueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
            if (!cell) {
                cell = [[SDD_DetailValueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
            }
            cell.nameLable.text = @"合作方式：";
            cell.chooseLable.text = cooperationStr;
            cell.chooseLable.frame =  CGRectMake(170, 16, 120, 13);
            [cell.textField removeFromSuperview];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            CELLSELECTSTYLE
            return cell;
        }
        if (indexPath.section == 3) {
            SDD_NextButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
            if (!cell) {
                cell = [[SDD_NextButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell4"];
            }
            ConfirmButton * conBrandBtn = [[ConfirmButton alloc] initWithFrame:CGRectMake(20, 0, viewWidth-40, 45) title:@"下一步" target:self action:@selector(nextButtonClick)];
            conBrandBtn.enabled = YES;
            [cell.contentView addSubview:conBrandBtn];
            
            UIButton *nextButton = (UIButton*)[cell viewWithTag:10];
            [nextButton removeFromSuperview];
            
            UIButton *positionButton = (UIButton*)[cell viewWithTag:20];
            [positionButton addTarget:self action:@selector(positionClick) forControlEvents:UIControlEventTouchUpInside];
            cell.backgroundColor = [UIColor clearColor];
            
            UIButton * sctButton = (UIButton *)[cell viewWithTag:30];
            [sctButton addTarget:self action:@selector(sctButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            UIImage * setImage = [Tools_F imageWithColor:[SDDColor colorWithHexString:@"#FF9933"] size:CGSizeMake(15, 15)];
            UIImage * noSetImage = [Tools_F imageWithColor:[SDDColor colorWithHexString:@"#CCCCCC"] size:CGSizeMake(15, 15)];
            [sctButton setBackgroundImage:setImage forState:UIControlStateSelected];
            [sctButton setBackgroundImage:noSetImage forState:UIControlStateNormal];
            sctButton.selected = YES;
            CELLSELECTSTYLE
            return cell;
        }
        CELLSELECTSTYLE
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ceellH"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellH"];
        }
        NSArray *contextArr = [NSArray arrayWithObjects:@"新项目团租合作",@"新项目发布合作", nil];//,@"新项目团购合作"
        cell.textLabel.text = contextArr[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        CELLSELECTSTYLE
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == cooperationTable) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cooperationStr = cell.textLabel.text;
        [bgView removeFromSuperview];
        cooperationTable.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 44*3);
        [_tableView reloadData];
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            SDD_DeveloperList *developer = [[SDD_DeveloperList alloc] init];
            developer.page = _page;
            [self.navigationController pushViewController:developer animated:YES];
        }
        
    }
    if (indexPath.section == 2) {
          //关闭键盘
         [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.1];
        cooperationTable.frame = CGRectMake(0, self.view.frame.size.height-44*3, self.view.frame.size.width, 44*3);
        bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44*3)];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.5;
        [self.view addSubview:bgView];
        [UIView setAnimationCurve:7];
        [UIView commitAnimations];
        
#pragma mark -- 修改，记录合作方式的值
        SDD_DetailValueCell *cell =  (SDD_DetailValueCell *)[tableView cellForRowAtIndexPath:indexPath];
        Cooperation = cell.chooseLable.text;
    }
    
}

#pragma mark -- 监控有没有选择阅读协议按钮
-(void)sctButtonClick:(UIButton *)btn
{
    NSLog(@"asdasd");
    sctNum*=-1;
    if (sctNum == 1) {
        ClickOnNum = 1;
        btn.selected = YES;
    }
    else
    {
        ClickOnNum = 0;
        btn.selected = NO;
    }
}

#pragma mark -- UItextFild监控值得变化
-(void)textFieldChanged:(NSNotification *)notification
{
    UITextField *textfield=[notification object];
    //NSLog(@"%@",textfield.text);
    if(textfield.tag == 150)
    {
        ProjectName = textfield.text;
        //NSLog(@"ProjectName=%@",ProjectName);
    }
    if (textfield.tag == 151) {
       
    }
    if (textfield.tag == 152) {
        ProjectAddress = textfield.text;
       // NSLog(@"ProjectAddress = %@",ProjectAddress);
    }
}

-(void)textViewChanged:(NSNotification *)notification
{
    UITextView * textView = [notification object];
    ProjectIntroduction = textView.text;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 3) {
        return 20.0f;
    }
    return 0.1f;
}
#pragma mark -- 预览按钮点击事件
- (void)lookClick
{
    if ([ProjectName isEqualToString:@""]||[ProjectAddress isEqualToString:@""]||[_developName isEqualToString:@""]||[Cooperation isEqualToString:@""]){
        
        [self showAlert:@"请把信息填完整"];
    }
    else {
        
        //_FirstFaceArray = [NSMutableArray array];
        [_FirstFaceArray replaceObjectAtIndex:0 withObject:ProjectName];
        [_FirstFaceArray replaceObjectAtIndex:1 withObject:_developName];
        [_FirstFaceArray replaceObjectAtIndex:2 withObject:ProjectAddress];
        [_FirstFaceArray replaceObjectAtIndex:3 withObject:ProjectIntroduction];
        [_FirstFaceArray replaceObjectAtIndex:4 withObject:Cooperation];
    
        SDD_Preview *preview = [[SDD_Preview alloc] init];
        preview.BasicArray = _FirstFaceArray;
        [self.navigationController pushViewController:preview animated:YES];
    }
}

#pragma mark---下一界面
- (void)nextButtonClick{
    
    if ([ProjectName isEqualToString:@""]||[ProjectAddress isEqualToString:@""]||[_developName isEqualToString:@""]||[Cooperation isEqualToString:@""]){
        
        [self showAlert:@"请把信息填完整"];
    }
    else if (ClickOnNum == 0) {
        
        [self showAlert:@"请选择商多多发布协议"];
    }
    else {
        
        [_FirstFaceArray replaceObjectAtIndex:0 withObject:ProjectName];
        [_FirstFaceArray replaceObjectAtIndex:1 withObject:_developName];
        [_FirstFaceArray replaceObjectAtIndex:2 withObject:ProjectAddress];
        [_FirstFaceArray replaceObjectAtIndex:3 withObject:ProjectIntroduction];
        [_FirstFaceArray replaceObjectAtIndex:4 withObject:Cooperation];
        
        SDD_ItemDetail *itemDetail = [[SDD_ItemDetail alloc] init];
        itemDetail.BasicArray = _FirstFaceArray;
        [self.navigationController pushViewController:itemDetail animated:YES];
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


- (void)positionClick
{
    NSLog(@"商多多发布协议");
}

//textView键盘下去
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)basicButtonClick:(UIButton*)button
{

    if (button.tag == 41) {
        SDD_ItemDetail *itemDetail = [[SDD_ItemDetail alloc] init];
        [self.navigationController pushViewController:itemDetail animated:YES];
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
