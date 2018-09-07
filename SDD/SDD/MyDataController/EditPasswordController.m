//
//  EditPasswordController.m
//  SDD
//  修改密码
//  Created by Cola on 15/4/17.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "EditPasswordController.h"
#import "UserInfo.h"

@interface EditPasswordController ()<UITextFieldDelegate>{
    
    NSArray *titleArr;
    
    NSString *oldPassword;
    NSString *newPassword;
}

@end

@implementation EditPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    titleArr = @[@"原密码:",@"新密码:"];
    
    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self setNav:@"reditPassword"];
    
    //确定按钮
    UIView * regBtn = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 75)];
    regBtn.backgroundColor = bgColor;
    self.tableView.tableFooterView = regBtn;
    
    // 确认按钮
    ConfirmButton *confirm = [[ConfirmButton alloc] initWithFrame:CGRectMake(20, 15, viewWidth - 40, 45)
                                                            title:@"确认修改"
                                                           target:self
                                                           action:@selector(confirm:)];
    confirm.enabled = YES;
    [regBtn addSubview:confirm];
    
    self.dataSource = [self getProfileConfigureArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableView Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}

#pragma mark - UITableView DataSource

#pragma mark - 设置cell (tableView)
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    
    NSMutableDictionary *sectionDictionary = self.dataSource[section][row];
    NSString *title = [sectionDictionary valueForKey:@"title"];
    if(cell == nil){
        //当不存在的时候用重用标识符生成
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
        cell.textLabel.font = midFont;
        cell.textLabel.textColor = mainTitleColor;
        
        CGFloat width = viewWidth - (viewWidth/2);
        
        //密码
        UITextField * _password = [[UITextField alloc] initWithFrame:CGRectMake(viewWidth/4,0, width - 10, 45)];
        _password.tag = 100+indexPath.row;
        _password.delegate = self;
        _password.textColor = [UIColor blackColor];//设置textview里面的字体颜色
        [_password setBorderStyle:UITextBorderStyleNone]; //外框类型
        _password.secureTextEntry = YES;
        _password.layer.borderColor = [[UIColor whiteColor] CGColor];
//        _password.layer.borderWidth =1.0;
        _password.font = midFont;//设置字体名字和字体大小
        _password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _password.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
        _password.placeholder = title; //默认显示的字
        _password.returnKeyType = UIReturnKeyDefault;//返回键的类型
        _password.keyboardType = UIKeyboardTypeDefault;//键盘类型
        [cell addSubview: _password];//加入到整个页面中
    }
    
    cell.textLabel.text = titleArr[indexPath.row];
    
    return cell;
}

#pragma mark - textfield代理
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (![Tools_F validatePassword:textField.text]) {
        
        [self showErrorWithText:@"输入的密码不规范，请检查"];
        return;
    }
}

- (void)confirm:(UIButton *)sender{
    
    UITextField *textfield = (UITextField *)[self.tableView viewWithTag:100];
    UITextField *textfield2 = (UITextField *)[self.tableView viewWithTag:101];
    if ([Tools_F validatePassword:textfield.text] && [Tools_F validatePassword:textfield2.text]) {
        
        oldPassword = textfield.text;
        newPassword = textfield2.text;
        
        NSDictionary *param = @{@"newPassword":[Tools_F Newmd5:newPassword],@"password":[Tools_F Newmd5:oldPassword]};
        NSString *urlString = [SDD_MainURL stringByAppendingString:@"/user/modifyPassword.do"];              // 拼接主路径和请求内容成完整url
        
        [self sendRequest:param url:urlString];
        [self showLoading:0];
    }
    else {
        
        [self showErrorWithText:@"输入的密码不规范，请检查"];
    }
}

- (void)onSuccess:(AFHTTPRequestOperation *)operation context:(id)responseObject{
    
    NSDictionary *dict = responseObject;
    NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
    if ([dict[@"status"] intValue] == 1) {
        
        // 设置登录状态
        [GlobalController setLoginStatus:NO];
        // 单例置空
        [UserInfo sharedInstance].userInfoDic = nil;
        // 注销环信
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES];
        // 发送取消自动登陆状态通知
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        // 显示hud
        [self showSuccessWithText:dict[@"message"]];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        
        [self showErrorWithText:dict[@"message"]];
    }
}

- (NSMutableArray *)getProfileConfigureArray {
    NSMutableArray *profiles = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSString *titleKey = @"title";
    NSString *imageKey = @"image";
    
    NSMutableArray *rows = [[NSMutableArray alloc] initWithCapacity:2];
    for (int i = 0; i < 2; i ++) {
        NSString *title;
        NSString *imageName;
        switch (i) {
            case 0:
                title = NSLocalizedString(@"输入当前密码", @"");
                break;
            case 1:
                title = NSLocalizedString(@"输入新密码", @"");
                break;
            default:
                break;
        }
        
        NSMutableDictionary *sectionDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:title, titleKey, imageName, imageKey, nil];
        [rows addObject:sectionDictionary];
    }
    [profiles addObject:rows];
    
    return profiles;
}

@end
