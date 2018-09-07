//
//  ConsultantViewController.m
//  商多多
//
//  Created by hua on 15/4/9.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ConsultantViewController.h"
#import "ConsultantTableViewCell.h"
#import "ConsultantModel.h"

#import "CounselorInfoViewController.h"
#import "ChatViewController.h"

#import "UIImageView+WebCache.h"

@interface ConsultantViewController ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    UITableView *table;
    // 个数
    UILabel *counts;
}

// 房源列表
@property (nonatomic, strong) NSMutableArray *consultant_DataArr;

@end

@implementation ConsultantViewController

- (NSMutableArray *)consultant_DataArr{
    if (!_consultant_DataArr) {
        _consultant_DataArr = [[NSMutableArray alloc]init];
    }
    return _consultant_DataArr;
}

#pragma mark - 请求数据
- (void)requestData{
    
    // 请求参数
    NSDictionary *dic = @{@"houseId":_houseID};
    
    NSString *urlString = [SDD_MainURL stringByAppendingString:@"/house/consultantList.do"];              // 拼接主路径和请求内容成完整url
    
    [self.httpManager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = responseObject;
        NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
        if (![dict[@"data"] isEqual:[NSNull null]]) {
            
            [_consultant_DataArr removeAllObjects];
            for (NSDictionary *tempDict in dict[@"data"]){
                
                ConsultantModel *model = [[ConsultantModel alloc] init];
                model.c_icon = tempDict[@"icon"];
                model.c_phone = tempDict[@"phone"];
                model.c_realName = tempDict[@"realName"];
                model.c_userId = tempDict[@"userId"];
                model.c_goodCommentRate = tempDict[@"goodCommentRate"];
                
                [self.consultant_DataArr addObject:model];
            }
            counts.text = [NSString stringWithFormat:@"共%d位招商顾问",[_consultant_DataArr count]];
            [table reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.view.backgroundColor = bgColor;
    
    // 请求数据
    [self requestData];
    // 导航条
    [self setupNav];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置导航条
- (void)setupNav{
    
    SDDButton *button = [[SDDButton alloc]init];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"招商顾问";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

#pragma mark - 设置内容
- (void)setupUI{
    
    // 个数
    counts = [[UILabel alloc] init];
    counts.frame = CGRectMake(10, 0, viewWidth-20, 22);
    counts.textColor = lgrayColor;
    counts.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:counts];
    
    // 内容
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(counts.frame), viewWidth, viewHeight-124) style:UITableViewStyleGrouped];
    table.backgroundColor = bgColor;
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [_consultant_DataArr count];
}

#pragma mark - 设置section 头高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

#pragma mark - 设置section 脚高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

#pragma mark - 设置cell (tableView)
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier2 = @"consultant";
    //重用机制
    ConsultantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier2];      //带标识符的出列
    
    if (cell == nil) {
        //当不存在的时候用重用标识符生成
        cell = [[ConsultantTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier2];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
        // 打电话
        [cell.makeCall addTarget:self action:@selector(makeCall:) forControlEvents:UIControlEventTouchUpInside];
        // 在线咨询
        [cell.makeContact addTarget:self action:@selector(chat:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    ConsultantModel *model = _consultant_DataArr[indexPath.row];
    cell.tag = 100+(int)indexPath.row;
    // 头像
    [cell.avatar sd_setImageWithURL:[NSURL URLWithString:model.c_icon]];
    // 昵称
    cell.nickname.frame = CGRectMake(CGRectGetMaxX(cell.avatar.frame)+8, 15, viewWidth/3, 15);
    cell.nickname.text = [NSString stringWithFormat:@"%@",model.c_realName];
    [cell.starRate removeFromSuperview];
    // 好评率
    cell.comment.frame = CGRectMake(CGRectGetMaxX(cell.avatar.frame)+8, CGRectGetMaxY(cell.nickname.frame)+8, viewWidth/3, 15);
    NSString *gr = [model.c_goodCommentRate isEqual:[NSNull null]]?@"0":[NSString stringWithFormat:@"%@",model.c_goodCommentRate];
    cell.comment.text = [NSString stringWithFormat:@"好评率:%@%%",gr];
    
    return cell;
}

#pragma mark - 点击cell (tableView)
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
//    ConsultantModel *model = _consultant_DataArr[indexPath.row];
//    
//    CounselorInfoViewController *counselorInfoVC = [[CounselorInfoViewController alloc] init];
//    
//    counselorInfoVC.userID = model.c_userId;
//    counselorInfoVC.houseID = _houseID;
//    counselorInfoVC.phone = model.c_phone;
//    [self.navigationController pushViewController:counselorInfoVC animated:YES];
}

#pragma mark - 打电话
- (void)makeCall:(UIButton *)btn{
    
    ConsultantModel *model = _consultant_DataArr[(int)btn.superview.tag-100];
    NSString *num = [NSString stringWithFormat:@"tel:%@",model.c_phone];
    
    NSLog(@"%@",num);
    // 联系顾问
    UIWebView*callWebview =[[UIWebView alloc] init];
    NSURL *telURL =[NSURL URLWithString:num];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}

#pragma mark - 聊天
- (void)chat:(UIButton *)btn{
    
    // 获得indexpath
    ConsultantModel *model = _consultant_DataArr[(int)btn.superview.tag-100];
    NSString *userID = [NSString stringWithFormat:@"%@",model.c_userId];
    
    // 发送顾问默认欢迎文本
    NSDictionary *param = @{@"consultantUserId":userID};
    NSString *urlString = [SDD_MainURL stringByAppendingString:@"/user/getIMDefaultWelcomeText.do"];              // 拼接主路径和请求内容成完整url
    [self sendRequest:param url:urlString];
    // 用户id
    NSLog(@"对方id:%@",userID);
    
    self.hidesBottomBarWhenPushed = YES;
    ChatViewController *cvc = [[ChatViewController alloc] initWithChatter:userID isGroup:FALSE];
    cvc.userName = model.c_realName;
    [self.navigationController pushViewController:cvc animated:true];
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
