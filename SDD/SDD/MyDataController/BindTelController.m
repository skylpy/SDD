//
//  BindTelController.m
//  SDD
//
//  Created by Cola on 15/4/18.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "BindTelController.h"

@interface BindTelController ()<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView *table;
}

@property (nonatomic, strong) NSArray *lable;
@end

@implementation BindTelController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNav:@"editPhone"];
    // 设置内容
    [self setupUI];    
}

#pragma mark - 设置内容
- (void)setupUI{
    
    _lable = @[@"原手机号:",@"手机号:",@"验证码:"];
    
    // 内容
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-44) style:UITableViewStyleGrouped];
    table.backgroundColor = bgColor;
    table.delegate = self;
    table.dataSource = self;
    table.rowHeight = 45;
    [self.view addSubview:table];
    
    //确定按钮
    UIView * regBtn = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 75)];
    regBtn.backgroundColor = bgColor;
    table.tableFooterView = regBtn;
    // 确认按钮
    ConfirmButton *confirm = [[ConfirmButton alloc] initWithFrame:CGRectMake(20, 15, viewWidth - 40, 45)
                                                                title:@"确认修改"
                                                               target:self
                                                               action:@selector(confirm:)];
    confirm.enabled = YES;
    [confirm setTitleColor:dblueColor forState:UIControlStateNormal];
    [confirm setBackgroundImage:[Tools_F imageWithColor:[UIColor whiteColor]
                                               size:CGSizeMake(viewWidth-40, 45)]
                   forState:UIControlStateNormal];
    [regBtn addSubview:confirm];
}

- (void)valueReturn:(ReturnPhoneNum)block{
    
    self.returnBlock = block;
}

- (void)confirm:(UIButton *)sender{
    
    UITextField *newNumber = (UITextField *)[table viewWithTag:101];
    UITextField *codeNumber = (UITextField *)[table viewWithTag:102];
    
    NSDictionary *param = @{@"phone":newNumber.text,
                            @"code":codeNumber.text};
    NSString *urlString = [SDD_MainURL stringByAppendingString:@"/user/modifyPhone.do"];              // 拼接主路径和请求内容成完整url
    
    [self sendRequest:param url:urlString];
    [self showLoading:0];
}

- (void)onSuccess:(AFHTTPRequestOperation *)operation context:(id)responseObject{
    
    NSDictionary *dict = responseObject;
    NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
    if ([dict[@"status"] intValue] == 1) {
        
        [GlobalController setLoginStatus:NO];
        [self showSuccessWithText:dict[@"message"]];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        
        [self showErrorWithText:dict[@"message"]];
    }
    
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

#pragma mark - 设置section 头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

#pragma mark - 设置section 脚高
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

#pragma mark - 设置cell (tableView)
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"@row %d %d",indexPath.row,indexPath.section);
    //重用标识符
    static NSString *identifier = @"CELLMARK";
    //重用机制
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
    NSString * tmp = [_lable objectAtIndex:indexPath.row];
    if(cell == nil){
        //当不存在的时候用重用标识符生成
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
        cell.textLabel.font = midFont;
        cell.textLabel.textColor = mainTitleColor;
        
        CGFloat width = viewWidth - (viewWidth/2);
        
        //密码
        UITextField * _password = [[UITextField alloc] initWithFrame:CGRectMake(viewWidth/4,0, width - 10, 45)];
        _password.tag = 100+indexPath.row;
        _password.textColor = [UIColor blackColor]; //设置textview里面的字体颜色
        _password.font = midFont; //设置字体名字和字体大小
        _password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _password.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
        NSString *str = @"请输入";
        _password.placeholder = [str stringByAppendingString:tmp ]; //默认显示的字
        _password.returnKeyType = UIReturnKeyDefault;//返回键的类型
        _password.keyboardType = UIKeyboardTypeDefault;//键盘类型
        _password.textAlignment = NSTextAlignmentLeft;
        [cell addSubview: _password];//加入到整个页面中
        
        if (indexPath.row == 2) {
            
            NSString * tmp = NSLocalizedString(@"securityCode", @"");
            UIButton * _registerLabel = [UIButton buttonWithType:UIButtonTypeCustom];
            _registerLabel.frame = CGRectMake(viewWidth - viewWidth/3 - 12, cell.bounds.size.height/2-midFont.lineHeight/2, viewWidth/3, midFont.lineHeight);
            _registerLabel.titleLabel.font = midFont;
            _registerLabel.titleLabel.text = tmp;
            _registerLabel.titleLabel.textAlignment = NSTextAlignmentRight;
            [_registerLabel setTitle:tmp forState:UIControlStateNormal];
            [_registerLabel setTitleColor:dblueColor forState:UIControlStateNormal];
            [_registerLabel setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
            [_registerLabel addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview: _registerLabel]; //加入到整个页面中
            
            UIView *_transverse = [[UIView alloc] init];
            _transverse.frame = CGRectMake(CGRectGetMaxX(_password.frame), 10, 0.5, cell.bounds.size.height - 20);
            _transverse.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [cell addSubview: _transverse]; //加入到整个页面中
        }
        
        if (indexPath.row == 0) {
//            _password.text = _thePhoneNum;
        }
    }
    
    cell.textLabel.text = tmp;
    
    return cell;
}

#pragma mark - 获取验证码
- (void)getCode:(UIButton *)btn{
    
    UITextField *oldNumber = (UITextField *)[table viewWithTag:100];
    UITextField *newNumber = (UITextField *)[table viewWithTag:101];
    
    // 请求参数
    NSDictionary *dic = @{@"newPhone":newNumber.text,
                          @"oldPhone":oldNumber.text
                          };
    NSString *urlString = [SDD_MainURL stringByAppendingString:@"/sms/sendModifyPhoneCode.do"];              // 拼接主路径和请求内容成完整url
    
    [self.httpManager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = responseObject;
        NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
        if (![dict[@"status"] intValue] == 1) {
            
            [self showErrorWithText:dict[@"message"]];
        }
        else {
            
            [self showSuccessWithText:dict[@"message"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
