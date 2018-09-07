//
//  InvestmentViewController.m
//  SDD
//  我要招商
//  Created by mac on 15/10/15.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "InvestmentViewController.h"
#import "BandMassCell.h"
#import "InvestmentTWOViewController.h"
#import "CategoryCell.h"

@interface InvestmentViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIButton *checkButton;
    
    NSTimer * timer;
    int allTime;
    
    NSString * positionStr;//职务
    NSString * phoneStr; //电话
    NSString * contactStr; //联系人
    NSString * departmentStr; //部门
    NSString * codeStr;//验证码
    
    UIView * view_max;//大view
    UIView * view_min;//小view
    
    NSInteger postCategoryId;
}

@property (retain,nonatomic)UITableView * tableView_zs;
@property (retain,nonatomic)UITableView * tableView_xzzw;

@property (retain,nonatomic)NSMutableArray * positArray;
@end

@implementation InvestmentViewController

-(NSMutableArray *)positArray
{
    if (!_positArray) {
        _positArray = [[NSMutableArray alloc] init];
    }
    return _positArray;
}

-(void)requestPosData
{
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/houseFirstCategory/userPostCategorys.do" params:nil success:^(id JSON) {
        
        NSLog(@"%@",JSON);
        if (![JSON[@"data"] isEqual:[NSNull null]]) {
        
            for (NSDictionary * dic in JSON[@"data"]) {
                
                CategoryCell * model = [[CategoryCell alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.positArray addObject:model];
            }
            [_tableView_xzzw reloadData];
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    [self setNav:@"我要招商"];
    [self setUpUI];
    [self initData];
    [self getTime];
    [self requestPosData];
    positionStr = @"请选择职务";
}



#pragma mark -- 初始化数据
-(void)initData
{
    checkButton = [[UIButton alloc] init];//WithFrame:CGRectMake(220, 16,80, 13)
    [checkButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    checkButton.titleLabel.font = [UIFont systemFontOfSize:12];
    checkButton.tag = 1500;
    [checkButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [checkButton addTarget:self action:@selector(checkClick) forControlEvents:UIControlEventTouchUpInside];
    
    phoneStr = @"";
    contactStr = @"";
    departmentStr = @"";
    codeStr = @"";
    allTime = 60;
    
    postCategoryId = 0;
}

//获取验证 登录状态
#pragma mark----获取验证
- (void)checkClick
{
    NSLog(@"获取验证");
    
    if ([Tools_F validateMobile:phoneStr]) {
        NSDictionary * param = @{@"phone":phoneStr};
        [HttpTool postWithBaseURL:SDD_MainURL Path:@"/sms/user/sendBrandMerchantCode.do" params:param success:^(id JSON) {
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[JSON objectForKey:@"message"] delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
            
            //[self getTime];
            if ([[JSON objectForKey:@"status"] intValue] == 1) {
                [checkButton setTitle:@"" forState:UIControlStateNormal];
                [timer setFireDate:[NSDate distantPast]];
                
            }

            
        } failure:^(NSError *error) {
            
        }];
        
        
    }
    else {
        //[self showAlert:@"请输入正确的手机号码！"];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码！" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
    }
}
-(void)getTime
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getTimeclick) userInfo:nil repeats:YES];
    [timer setFireDate:[NSDate distantFuture]];
}
-(void)getTimeclick
{
    //NSLog(@"%@",timer);
    allTime --;
    
    if (allTime ==59||allTime == 58) {
        [checkButton setTitle:@"" forState:UIControlStateNormal];
    }
    
    //NSLog(@"%@",timer);
    [checkButton setTitle:[NSString stringWithFormat:@"还剩(%d)",allTime] forState:UIControlStateNormal];
    [checkButton setTintColor:[UIColor grayColor]];
    
    
    if (allTime == 0) {
        [checkButton setTitle:@"重新获取" forState:UIControlStateNormal];
        allTime = 60;
        [timer setFireDate:[NSDate distantFuture]];
    }
    
}

#pragma mark -- 设置UI
-(void)setUpUI
{
    _tableView_zs = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView_zs.delegate = self;
    _tableView_zs.dataSource = self;
    _tableView_zs.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView_zs];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _tableView_zs) {
        if (section == 0) {
            return 0.01;
        }
        else
        {
            return 10;
        }
    }
    else
    {
        return 0.01;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView_zs) {
        if (indexPath.section == 2) {
            return 100;
        }
        else
        {
            return 44;
        }
    }
    else
    {
        return 44;
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _tableView_zs) {
        return 3;
    }
    else
    {
        return 1;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView_zs) {
        switch (section) {
            case 0:
                return 3;
                break;
            case 1:
                return 2;
                break;
            default:
                return 1;
                break;
        }
    }
    else
    {
        return _positArray.count;;
    }
    
    
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView_zs) {
        static NSString * cellID = @"cellId";
        BandMassCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[BandMassCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textView.hidden = YES;
#pragma mark -- 设置通知中心监控textField.text的值得变化
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldChanged:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:cell.textField];
        switch (indexPath.section) {
            case 0:
            {
                cell.receiveBtn.hidden = YES;
                switch (indexPath.row) {
                    case 0:
                    {
                        cell.nameLable.text = @"联系人：";
                        cell.textField.placeholder = @"请输入联系人姓名";
                        cell.textField.text = contactStr;
                        cell.textField.tag = 100;
                    }
                        break;
                    case 1:
                    {
                        cell.nameLable.text = @"部门：";
                        cell.textField.placeholder = @"请输入所在部门";
                        cell.textField.text = departmentStr;
                        cell.textField.tag = 101;
                    }
                        break;
                    default:
                    {
                        cell.textField.hidden = YES;
                        cell.nameLable.text = @"职务：";
                        //cell.textField.placeholder = @"请选择职务";
                        cell.chooseLable.text = positionStr;
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    }
                        break;
                }
            }
                break;
            case 1:
                cell.receiveBtn.hidden = YES;
                switch (indexPath.row) {
                    case 0:
                    {
                        cell.nameLable.text = @"手机号：";
                        cell.textField.placeholder = @"请输入您的手机号码";
                        cell.textField.text = phoneStr;
                        cell.textField.tag = 102;
                    }
                        break;
                        
                    default:
                    {
                        cell.nameLable.text = @"验证码：";
                        cell.textField.placeholder = @"请输入验证码";
                        cell.textField.text = codeStr;
                        cell.textField.tag = 103;
                        
                        [cell addSubview:checkButton];
                        
                        [checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(cell.mas_top).with.offset(13);
                            make.right.equalTo(cell.mas_right).with.offset(-20);
                            make.width.equalTo(@80);
                            make.height.equalTo(@20);
                        }];
                        
                        UILabel *line = [[UILabel alloc] init];//WithFrame:CGRectMake(200, 10, 1, 25)
                        line.backgroundColor = [SDDColor colorWithHexString:@"#e5e5e5"];
                        [cell addSubview:line];
                        
                        [line mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.top.equalTo(cell.mas_top).with.offset(10);
                            make.right.equalTo(checkButton.mas_left).with.offset(-10);
                            make.width.equalTo(@1);
                            make.bottom.equalTo(cell.mas_bottom).with.offset(-10);
                        }];
                        
                    }
                        break;
                }
                break;
            default:
            {
                cell.receiveBtn.hidden = NO;
                cell.starLable.hidden = YES;
                cell.nameLable.hidden = YES;
                cell.textField.hidden = YES;
                cell.chooseLable.hidden = YES;
                UIImageView * line = (UIImageView *)[cell viewWithTag:1005];
                line.hidden = YES;
                cell.backgroundColor = bgColor;
                [cell.receiveBtn setTitle:@"下一步" forState:UIControlStateNormal];
                [cell.receiveBtn addTarget:self action:@selector(receiveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
        }
        return cell;
    }
    else
    {
        static NSString * cellID = @"cellPos";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        CategoryCell * model = _positArray[indexPath.row];
        cell.textLabel.text = model.categoryName;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (tableView == _tableView_zs) {
        if (indexPath.section == 0) {
            if (indexPath.row == 2) {
                
                [self initPositionTable];
            }
        }
    }
    else
    {
        [view_max removeFromSuperview];
        [view_min removeFromSuperview];
        CategoryCell * model = _positArray[indexPath.row];
        positionStr =model.categoryName;
        postCategoryId = [model.postCategoryId integerValue];
        [_tableView_zs reloadData];
    }
    
}

-(void)initPositionTable
{
    view_max = [[UIView alloc] initWithFrame:self.view.bounds];
    view_max.backgroundColor = [UIColor blackColor];
    view_max.alpha = 0.7;
    [self.view addSubview:view_max];
    
    UIGestureRecognizer * tap_g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap_gClick:)];
    [view_max addGestureRecognizer:tap_g];
    
    view_min = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight/2, viewWidth, viewHeight/2)];
    view_min.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view_min];
    
    _tableView_xzzw = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight/2) style:UITableViewStylePlain];
    _tableView_xzzw.delegate = self;
    _tableView_xzzw.dataSource = self;
    [view_min addSubview:_tableView_xzzw];
    
}
-(void)tap_gClick:(UITapGestureRecognizer *)tap
{
    [view_max removeFromSuperview];
    [view_min removeFromSuperview];
}

#pragma mark -- UItextFild监控值得变化
-(void)textFieldChanged:(NSNotification *)notification
{
    UITextField *textfield=[notification object];
    
    switch (textfield.tag) {
        case 100:
        {
            contactStr = textfield.text;
        }
            break;
        case 101:
        {
            departmentStr = textfield.text;
        }
            break;
        case 102:
        {
            phoneStr = textfield.text;
        }
            break;
        default:
        {
            codeStr = textfield.text;
        }
            break;
    }
}

#pragma mark -- 下一步按钮
-(void)receiveBtnClick:(UIButton *)btn
{
    if (![contactStr isEqualToString:@""]&&![departmentStr isEqualToString:@""]&&![positionStr isEqualToString:@"请选择职务"]&&![phoneStr isEqualToString:@""]&&![codeStr isEqualToString:@""]) {
        
        InvestmentTWOViewController * investVc = [[InvestmentTWOViewController alloc] init];
        investVc.brandId = _brandId;
        investVc.phoneStr = phoneStr;
        investVc.positionStr = positionStr;
        investVc.contactStr = contactStr;
        investVc.departmentStr = departmentStr;
        investVc.codeStr = codeStr;
        investVc.postCategoryId = postCategoryId;
        [self.navigationController pushViewController:investVc animated:YES];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入完整信息" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
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
