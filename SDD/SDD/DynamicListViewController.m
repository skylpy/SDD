//
//  DynamicListViewController.m
//  SDD
//
//  Created by hua on 15/6/23.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "DynamicListViewController.h"
#import "DynamicDetailViewController.h"

@interface DynamicListViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    /*- ui -*/
    
    UITableView *table;
}

// 数据源
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation DynamicListViewController

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

#pragma mark - 请求数据
- (void)requestData{
    
    // 请求参数
    NSDictionary *param = @{@"params":@{@"brandId":_brandId,}};
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brandDynamic/listByBrandId.do" params:param success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSDictionary *dict = JSON[@"data"];
        
        if (![dict isEqual:[NSNull null]]) {
            
            [_dataSource removeAllObjects];
            
            for (NSDictionary *tempDic in dict) {
                
                [self.dataSource addObject:tempDic];
            }

            [table reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 加载数据
    [self requestData];
    // 导航条
    [self setNav:@"最新动态"];
    // ui
    [self setupUI];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    // table
    table = [[UITableView alloc] init];
    table.backgroundColor = bgColor;
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 75;
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_dataSource count];
}

#pragma mark - 设置section 头高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}

#pragma mark - 设置section 脚高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}

#pragma mark - 设置cell (tableView)
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //重用标识符
    static NSString *identifier = @"DynamicList";
    //重用机制
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
    
    if (cell == nil) {
        //当不存在的时候用重用标识符生成
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.clipsToBounds = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
        cell.detailTextLabel.textColor =lgrayColor;
        [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.mas_top).with.offset(10);
            make.left.equalTo(cell.mas_left).with.offset(8);
        }];
    }
    
    NSDictionary *currentDic = _dataSource[indexPath.row];
    cell.textLabel.text = currentDic[@"title"];
    cell.detailTextLabel.text = currentDic[@"description"];
    cell.detailTextLabel.numberOfLines = 3;
    
    return cell;
}

#pragma mark - 点击cell (tableView)
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSDictionary *currentDic = _dataSource[indexPath.row];
    DynamicDetailViewController *ddVC = [[DynamicDetailViewController alloc] init];
    
    ddVC.dynamicTitle = currentDic[@"title"];
    ddVC.dynamicContent = currentDic[@"description"];
    
    [self.navigationController pushViewController:ddVC animated:YES];
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
