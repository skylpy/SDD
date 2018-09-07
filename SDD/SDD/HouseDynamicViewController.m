//
//  HouseDynamicViewController.m
//  商多多
//
//  Created by hua on 15/4/9.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "HouseDynamicViewController.h"
#import "HouseDynamicTableViewCell.h"

#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "Tools_F.h"

@interface HouseDynamicViewController ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    UITableView *table;
    
    NSArray *dynamic_DataArr;
    
    NSInteger judgeInt;
}

// 网络请求
@property (nonatomic, strong) AFHTTPRequestOperationManager *httpManager;
// 动态列表
//@property (nonatomic, strong) NSMutableArray *dynamic_DataArr;

@end

@implementation HouseDynamicViewController

- (AFHTTPRequestOperationManager *)httpManager
{
    if(!_httpManager)
    {
        _httpManager = [AFHTTPRequestOperationManager manager];
        //        httpManager.requestSerializer.timeoutInterval = 15;         //设置超时时间
        _httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];        // ContentTypes 为json
    }
    return _httpManager;
}

//- (NSMutableArray *)dynamic_DataArr{
//    if (!_dynamic_DataArr) {
//        _dynamic_DataArr = [[NSMutableArray alloc]init];
//    }
//    return _dynamic_DataArr;
//}

#pragma mark - 请求数据
- (void)requestData{
    
    // 请求参数
    NSDictionary *dic = @{@"params":@{@"houseId":_houseID}};
    
    NSString *urlString = [SDD_MainURL stringByAppendingString:@"/house/dynamicList.do"];              // 拼接主路径和请求内容成完整url
    
    [self.httpManager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = responseObject;
        NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
        if (![dict[@"data"] isEqual:[NSNull null]]) {
            
            dynamic_DataArr = dict[@"data"];
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
    
    judgeInt = 1;
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
    titleLabel.text = @"最新动态";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

#pragma mark - 设置内容
- (void)setupUI{
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-15) style:UITableViewStyleGrouped];
    table.backgroundColor = setColor(240, 240, 240, 1);
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (judgeInt == 1) {
        
        return 130;
    }else{
    
        NSDictionary *dict = dynamic_DataArr[indexPath.row];
        NSString *contentText = [NSString stringWithFormat:@"%@",dict[@"description"]];
        CGSize contentSize = [Tools_F countingSize:contentText fontSize:15 width:viewWidth-40];
        return contentSize.height+70;
        
    }
    
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [dynamic_DataArr count];
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
    
    //重用标识符
    static NSString *identifier = @"evaluation";
    //重用机制
    HouseDynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
    cell.backgroundColor = [UIColor whiteColor];
    if (cell == nil) {
        //当不存在的时候用重用标识符生成
        cell = [[HouseDynamicTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
    }
    if (judgeInt == 1) {
        NSDictionary *dict = dynamic_DataArr[indexPath.row];
        // 标题
        cell.theTitle.text = [NSString stringWithFormat:@"%@",dict[@"title"]];
        // 内容
        NSString *contentText = [NSString stringWithFormat:@"%@",dict[@"description"]];
        //CGSize contentSize = [Tools_F countingSize:contentText fontSize:15 width:viewWidth-40];
        cell.theContent.text = contentText;
        cell.theContent.frame = CGRectMake(10, CGRectGetMaxY(cell.theTitle.frame)+3, viewWidth-20, 60);
        // 时间
        cell.theTime.frame = CGRectMake(10, CGRectGetMaxY(cell.theContent.frame)+6, viewWidth-20, 10);
        cell.theTime.text = [Tools_F timeTransform:[dict[@"addTime"] floatValue] time:days];
        // 箭头
        cell.openDynamic.frame = CGRectMake(viewWidth/2-6, CGRectGetMaxY(cell.theTime.frame)+2, 15, 12);
        
        [cell.openDynamic addTarget:self action:@selector(openDynamicClick:) forControlEvents:UIControlEventTouchUpInside];
    }else{
    
        NSDictionary *dict = dynamic_DataArr[indexPath.row];
        // 标题
        cell.theTitle.text = [NSString stringWithFormat:@"%@",dict[@"title"]];
        // 内容
        NSString *contentText = [NSString stringWithFormat:@"%@",dict[@"description"]];
        CGSize contentSize = [Tools_F countingSize:contentText fontSize:15 width:viewWidth-40];
        cell.theContent.text = contentText;
        cell.theContent.frame = CGRectMake(10, CGRectGetMaxY(cell.theTitle.frame)+3, viewWidth-20, contentSize.height);
        // 时间
        cell.theTime.frame = CGRectMake(10, CGRectGetMaxY(cell.theContent.frame)+6, viewWidth-20, 10);
        cell.theTime.text = [Tools_F timeTransform:[dict[@"addTime"] floatValue] time:days];
        // 箭头
        cell.openDynamic.frame = CGRectMake(viewWidth/2-6, CGRectGetMaxY(cell.theTime.frame)+2, 15, 12);
        
        [cell.openDynamic addTarget:self action:@selector(openDynamicClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    
    return cell;
}

#pragma mark -- 点击收缩
-(void)openDynamicClick:(UIButton *)btn{

    //NSLog(@"%@",btn);
    judgeInt *= -1;
    
    [table reloadData];
    
}

#pragma mark - 点击cell (tableView)
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
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
