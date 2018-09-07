//
//  IJoinViewController.m
//  SDD
//
//  Created by hua on 15/6/25.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "IJoinViewController.h"

@interface IJoinViewController ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    /*- ui -*/
    
    UITableView *table;
    UIButton *male;
    UIButton *female;
    
    UITextField *name;
    UITextField *phone;
    UITextField *message;
    
    /*- data -*/
    NSArray *cellTitle;
    
    NSInteger gender;
}

@end

@implementation IJoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    // 导航条
    [self setupNav];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置导航条
- (void)setupNav{
    
    [self setNav:@"我要加盟"];
    
    UIButton *commit = [[UIButton alloc] init];
    commit.frame = CGRectMake(0, 0, 55, 44);
    commit.titleLabel.font = largeFont;
    [commit setTitle:@"提交" forState:UIControlStateNormal];
    [commit addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:commit];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    gender = 1;         // 默认男性
    
    // table
    table = [[UITableView alloc] init];
    table.backgroundColor = bgColor;
    table.bounces = NO;
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
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
    
    if (section == 0) {
        
        return 3;
    }
    else {
        
        return 1;
    }
}

#pragma mark - 设置Sections数 (tableView)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
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
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //重用标识符
    static NSString *identifier = @"IJoin";
    //重用机制
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
    
    if (cell == nil) {
        //当不存在的时候用重用标识符生成
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
        cell.textLabel.font = midFont;
    }
    
    UITextField *textfield = [[UITextField alloc] init];
    textfield.font = midFont;
    textfield.backgroundColor = bgColor;
    [Tools_F setViewlayer:textfield cornerRadius:4 borderWidth:0 borderColor:nil];
    [cell addSubview:textfield];
    
    [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.mas_top).with.offset(10);
        make.bottom.equalTo(cell.mas_bottom).with.offset(-10);
        make.left.equalTo(cell.mas_left).with.offset(viewWidth*3/10);
        make.right.equalTo(cell.mas_right).with.offset(-10);
    }];
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text = @"*姓名";
                    name = textfield;
                }
                    break;
                case 1:
                {
                    cell.textLabel.text = @"*性别";
                    textfield.hidden = YES;
                    
                    // 男
                    male = [UIButton buttonWithType:UIButtonTypeCustom];
                    male.titleLabel.font = midFont;
                    [male setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [male setImage:[UIImage imageNamed:@"join_btn_unSelected"] forState:UIControlStateNormal];
                    [male setImage:[UIImage imageNamed:@"join_btn_selected"] forState:UIControlStateSelected];
                    [male setTitle:@" 男" forState:UIControlStateNormal];
                    male.selected = YES;
                    [male addTarget:self action:@selector(maleAction:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:male];

                    // 女
                    female = [UIButton buttonWithType:UIButtonTypeCustom];
                    female.titleLabel.font = midFont;
                    [female setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [female setImage:[UIImage imageNamed:@"join_btn_unSelected"] forState:UIControlStateNormal];
                    [female setImage:[UIImage imageNamed:@"join_btn_selected"] forState:UIControlStateSelected];
                    [female setTitle:@" 女" forState:UIControlStateNormal];
                    [female addTarget:self action:@selector(femaleAction:) forControlEvents:UIControlEventTouchUpInside];
                    [cell addSubview:female];
                    
                    [male mas_makeConstraints:^(MASConstraintMaker *make) {
                        
                        make.top.equalTo(cell.mas_top).with.offset(18);
                        make.bottom.equalTo(cell.mas_bottom).with.offset(-18);
                        make.left.equalTo(cell.mas_left).with.offset(viewWidth*3/10);
                        make.width.equalTo(@40);
                    }];
                    
                    [female mas_makeConstraints:^(MASConstraintMaker *make) {
                        
                        make.top.equalTo(cell.mas_top).with.offset(18);
                        make.bottom.equalTo(cell.mas_bottom).with.offset(-18);
                        make.left.equalTo(male.mas_right).with.offset(30);
                        make.width.equalTo(@40);
                    }];
                    
                }
                    break;
                case 2:
                {
                    cell.textLabel.text = @"*手机号";
                    phone = textfield;
                    phone.keyboardType = UIKeyboardTypePhonePad;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            cell.textLabel.text = @"*加盟留言";
            message = textfield;
        }
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - 男
- (void)maleAction:(UIButton *)btn{
    btn.selected = YES;
    female.selected = NO;
    gender = 1;
}

#pragma mark - 女
- (void)femaleAction:(UIButton *)btn{
    btn.selected = YES;
    male.selected = NO;
    gender = 0;
}

#pragma mark - 提交
- (void)commitAction:(UIButton *)btn{
    
    NSLog(@"%@ %d %@ %@",name.text,gender,phone.text,message.text);
    if (name.text.length<1 || phone.text.length<1 || message.text.length<1 ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入完整信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if (![Tools_F validateMobile:phone.text]){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入有效的手机号码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        
        // 请求参数
        NSDictionary *param = @{@"message":message.text,
                                @"phone":phone.text,
                                @"sex":[NSNumber numberWithInteger:gender],
                                @"name":name.text,
                                @"brandId":_brandId
                                };
        
        [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brand/add/joined.do" params:param success:^(id JSON) {
            
            NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
            
            if ([JSON[@"status"] intValue] == 1) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"数据提交成功，我们会在24小时内为您审核，审核结果将会以电话或短信的形式通知相关后续操作，请耐心等待。如有疑问，欢迎拨打客户电话:\n%@",_number] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else {
                
                [self showErrorWithText:JSON[@"message"]];
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
