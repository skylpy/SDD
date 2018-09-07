//
//  DevelopersViewController.m
//  SDD
//
//  Created by hua on 15/9/18.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "DevelopersViewController.h"
#import "VariousDimensionsModel.h"

#import "MJRefresh.h"

@interface DevelopersViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    /*- ui -*/
    
    UITableView *table;
    
    /*- data -*/
    
    NSInteger pages;
    NSArray *dataSource;
}

@end

@implementation DevelopersViewController

#pragma mark - 获取开发商
- (void)requestData{
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/house/developerList.do"
                       params:@{@"pageNumber":@1,@"pageSize":@(pages)} success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSArray *arr = JSON[@"data"];
        if (![arr isEqual:[NSNull null]]) {
            
            // 判断数据个数与请求个数
            if ([dataSource count]<pages) {
                
                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                [table.footer noticeNoMoreData];
            }
            dataSource = [VariousDimensionsModel objectArrayWithKeyValuesArray:arr];
            [table reloadData];
        }
        else {
            
            [self showErrorWithText:@"无结果"];
        }
                           
        [table.footer endRefreshing];
    } failure:^(NSError *error) {
        //
        [table.footer endRefreshing];
        NSLog(@"开发商错误 -- %@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 初始化数据
    pages = 20;
    
    [self setNav:@"附近开发商"];
    // 设置内容
    [self setupUI];
    // 获取数据
    [self requestData];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    
    table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    table.backgroundColor = bgColor;
    table.delegate = self;
    table.dataSource = self;
    
    [table addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [self.view addSubview:table];                            // add
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - 上拉加载
- (void)loadMoreData{
    
    pages+=10;
    [self requestData];
    NSLog(@"上拉加载%d个",pages);
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [dataSource count];
}

#pragma mark - 设置Sections数 (tableView)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

#pragma mark - 设置section 头高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}

#pragma mark - 设置section 脚高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

#pragma mark - 设置cell (tableView)
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //重用标识符
    static NSString *identifier = @"PersonalInfo";
    //重用机制
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];      //带标识符的出列
    
    if (cell == nil) {
        
        // 当不存在的时候用重用标识符生成
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;                // 设置选中背景色不变
        cell.textLabel.font = midFont;
        cell.textLabel.textColor = mainTitleColor;
        
    }
    
    VariousDimensionsModel *model = dataSource[indexPath.row];
    cell.textLabel.text = model.developersName;
    
    return cell;
}

#pragma mark - 点击cell (tableView)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VariousDimensionsModel *model = dataSource[indexPath.row];

    // block回传
    if (self.returnBlock != nil) {
        
        self.returnBlock(model.developersName,model.developersId);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)valueReturn:(ReturnDevelopersInfo)block{
    
    self.returnBlock = block;
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
