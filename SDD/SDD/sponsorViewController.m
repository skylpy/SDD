//
//  sponsorViewController.m
//  SDD
//
//  Created by hua on 15/10/14.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "sponsorViewController.h"
#import "PublicCell.h"
#import "sponsorTableViewCell.h"
#import "sponsorSucceedViewController.h"

@interface sponsorViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (retain,nonatomic)UITableView * tableView;
@property (retain,nonatomic)NSMutableArray * dataArray;

@end

@implementation sponsorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = bgColor;
    _dataArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"", nil];
    
    [self createNvn];
    [self createView];
    
    // Do any additional setup after loading the view.
}

#pragma mark -- 提交数据下载
-(void)requestData
{
    NSString * telPhone = _dataArray[3];
    NSString * postName = _dataArray[2];
    NSString * email = _dataArray[4];
    NSString * company = _dataArray[0];
    NSString * realName = _dataArray[1];
//    NSString * forumsId = @"1";
    
//    int peopleQty  = [[NSString stringWithFormat:@"%@",_dataArray[3]] intValue];
    
//    NSDictionary * dict = @{@"phone":telPhone,
////                            @"peopleQty":@(peopleQty),
//                            @"postName":postName,
//                            @"email":email,
//                            @"company":company,
//                            @"realName":realName,
//                            @"forumsId":([NSString stringWithFormat:@"%d",_actNum]),
//                            };
    NSDictionary * dict = @{@"phone":telPhone,
                            @"postCategoryId":@1,
                            @"activityForumsId":_model.activityId,
                            @"email":email,
                            @"company":company,
                            @"realName":realName};
    //@"/forumsSponsor/addSponsor.do"
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/activityForums/addSponsor.do" params:dict success:^(id JSON) {
        
        NSLog(@"%@",JSON);
        //        NSString stringWithFormat:@"%@",JSON[@"status"]intValue
        if ([[NSString stringWithFormat:@"%@",JSON[@"status"]] intValue]==1) {
            [self showAlert:JSON[@"message"]];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            [self showAlert:JSON[@"message"]];
        }
//        [self showAlert:@"xx"];
        
    } failure:^(NSError *error) {
        
    }];
    [self nextVC];
}

-(void)nextVC
{
    sponsorSucceedViewController * ssVC = [[sponsorSucceedViewController alloc] init];
    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;
    [self.navigationController pushViewController:ssVC animated:YES];
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

-(void)createNvn
{
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"赞助";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
//    UIButton * rightBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.frame = CGRectMake(0, 0, 15, 15);
//    [rightBtn setBackgroundImage:[UIImage imageNamed:@"分享-图标"] forState:UIControlStateNormal];
//    
//    UIBarButtonItem * rigItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem = rigItem;
    
}

-(void)createView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 4) {
        return 15;
    }
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        switch (indexPath.section) {
            case 0:
                return 80;
                break;
            case 1:
                return 45;
                break;
            case 2:
                return 55;
                break;
            case 3:
                return 300;
                break;
            case 4:
                return 50;
                break;
            default:
                return 44;
                break;
        }
    }
    
    return 40;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 1:
            return 5;
            break;
            
        default:
            break;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    
    switch (indexPath.section) {
        case 0:
        {
            UILabel *titLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, viewWidth-40, 80)];
            titLabel.font = midFont;
            titLabel.textColor = deepBLack;
            //如果设置为0的时候不限制
            titLabel.numberOfLines = 0;
            //字体的对齐方式（中间对齐）
            titLabel.textAlignment = NSTextAlignmentCenter;
            titLabel.text = @"  请认真填写以下信息，方便我们及时与您取得联系。申请提交后，我们将会对您提交的资料进行审核，请耐心等候  ";
            [cell addSubview:titLabel];
        }
            break;
        case 1:
        {
            static NSString * cellID = @"cellID";
            sponsorTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[sponsorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            NSArray * titArr = @[@"公司名称:",@"联系人:",@"职位:",@"联系电话:",@"EMALL:",@"请输入您的公司名称",@"请输入联系人名称",@"请输入您的职位名称",@"请输入联系电话",@"请输入您的邮箱"];
            if (indexPath.row == 4) {
//                [cell.textField removeFromSuperview];
                //                    cell.chooseLable.text = titArr[indexPath.row+4];
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell.starLable removeFromSuperview];
//                cell.chooseLable.textAlignment = NSTextAlignmentRight;
//                cell.chooseLable.text = _dataArray[indexPath.row];
                
            }
            cell.textField.text = _dataArray[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.nameLable.text =titArr[indexPath.row];
            cell.nameLable.textAlignment = NSTextAlignmentCenter;
            cell.textField.placeholder = titArr[indexPath.row+5];
            
            cell.textField.tag = 100+indexPath.row;
#pragma mark -- 设置通知中心监控textField.text的值得变化
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(textFieldChanged:)
                                                         name:UITextFieldTextDidChangeNotification
                                                       object:cell.textField];
            return cell;
        }
            break;
        case 2:
        {
            UILabel *titLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, viewWidth-20, 35)];
            titLabel.font = bottomFont_12;
            titLabel.textColor = lgrayColor;
            titLabel.text = @"备注：大会收到您赞助申请后，会尽快与您联系！如有任何问题，请及时联系我们！商多多：400-991-8829";
            titLabel.textAlignment = NSTextAlignmentCenter;
            titLabel.numberOfLines = 0;
            [cell addSubview:titLabel];
        }
            break;
        case 3:
        {
            UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 25)];
            label1.font = titleFont_15;
            label1.textColor = deepBLack;
            label1.text = @"赞助金额：";
            label1.textAlignment = NSTextAlignmentLeft;
            [cell addSubview:label1];
            
            UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, 80, 25)];
            label2.font = titleFont_15;
            label2.textColor = [UIColor orangeColor];
            label2.text = @"5万RMB";
            label2.textAlignment = NSTextAlignmentLeft;
            [cell addSubview:label2];
            
            UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, 100, 25)];
            label3.font = titleFont_15;
            label3.textColor = deepBLack;
            label3.text = @"赞助商回报：";
            label3.textAlignment = NSTextAlignmentLeft;
            [cell addSubview:label3];
            
            UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 100, 25)];
            label4.font = midFont;
            label4.textColor = deepBLack;
            label4.text = @"A.荣誉回报";
            label4.textAlignment = NSTextAlignmentLeft;
            [cell addSubview:label4];
            
            UILabel *label41 = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, viewWidth-20, 60)];
            label41.font = midFont;
            label41.textColor = lgrayColor;
            label41.text = @"赞助企业获得大会授予的“金牌赞助商”称号，并作为大会协办单位之一；赞助企业主要负责人作为“特邀加盟”出席大会活动，并就座于嘉宾席。";
            label41.textAlignment = NSTextAlignmentLeft;
            label41.numberOfLines = 0;
            [cell addSubview:label41];
            
            UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(10, 140, 100, 20)];
            label5.font = midFont;
            label5.textColor = deepBLack;
            label5.text = @"B.现场回报";
            label5.textAlignment = NSTextAlignmentLeft;
            [cell addSubview:label5];
            
            UILabel *label51 = [[UILabel alloc]initWithFrame:CGRectMake(10, 160, viewWidth-20, 40)];
            label51.font = midFont;
            label51.textColor = lgrayColor;
            label51.text = @"大会现场为赞助企业配置一个明星展示位（由组委会指定），进行企业宣传。";
            label51.textAlignment = NSTextAlignmentLeft;
            label51.numberOfLines = 0;
            [cell addSubview:label51];
            
            UILabel *label6 = [[UILabel alloc]initWithFrame:CGRectMake(10, 200, 100, 20)];
            label6.font = midFont;
            label6.textColor = deepBLack;
            label6.text = @"C.媒体回报";
            label6.textAlignment = NSTextAlignmentLeft;
            [cell addSubview:label6];
            
            UILabel *label61 = [[UILabel alloc]initWithFrame:CGRectMake(10, 220, viewWidth-20, 80)];
            label61.font = midFont;
            label61.textColor = lgrayColor;
            label61.text = @"会议专题页上，在“金牌赞助商”一栏展现赞助企业名称或LOGO，并提供赞助企业的超链接；会议活动的回顾页面（以照片,视频，文档形式展示），展示赞助企业名称或LOGO。";
            label61.textAlignment = NSTextAlignmentLeft;
            label61.numberOfLines = 0;
            [cell addSubview:label61];
        }
            break;
        case 4:
        {
            UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
            //            leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [leftButton setTitle:@"提交" forState:UIControlStateNormal];
            [leftButton.layer setMasksToBounds:YES];
            [leftButton.layer setCornerRadius:10.0];
            leftButton.frame = CGRectMake(20, 5, viewWidth-40, 40);
            leftButton.backgroundColor  = [UIColor colorWithRed:(16/255.0) green:(118/255.0) blue:(224/255.0) alpha:(1.0)];
            [leftButton addTarget:self action:@selector(ButtonDDD:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:leftButton];
        }
            break;
            
        default:
            break;
    }
    
    cell.selectionStyle=UITableViewCellAccessoryNone; //行不能被选中
    
    return cell;
}

-(void)ButtonDDD:(UIButton *)btn
{
    NSString *strT = @"";
    if (_dataArray[0] == strT || _dataArray[1] == strT || _dataArray[2] == strT || _dataArray[3] == strT) {
        [self showAlert:@"请讲必填信息补充完整"];
    }
    else
    {
        [self requestData];
    }
    NSLog(@"提交");
//    [self requestData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%ld",(long)indexPath.row);
    
}

#pragma mark -- UItextFild监控值得变化
-(void)textFieldChanged:(NSNotification *)notification
{
    UITextField *textfield=[notification object];
    switch (textfield.tag) {
        case 100:
            [_dataArray replaceObjectAtIndex:0 withObject:textfield.text];
            break;
        case 101:
            [_dataArray replaceObjectAtIndex:1 withObject:textfield.text];
            break;
        case 102:
            [_dataArray replaceObjectAtIndex:2 withObject:textfield.text];
            break;
        case 103:
            [_dataArray replaceObjectAtIndex:3 withObject:textfield.text];
            break;
        case 104:
            [_dataArray replaceObjectAtIndex:4 withObject:textfield.text];
            break;
        default:
            break;
    }
    NSLog(@"%@",_dataArray);
}

- (void)leftButtonClick
{
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
