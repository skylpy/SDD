//
//  JoinContactViewController.m
//  SDD
//
//  Created by hua on 15/6/25.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "JoinContactViewController.h"
#import "JoinContactTableViewCell.h"
#import "ContactModel.h"

@interface JoinContactViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    /*- ui -*/
    
    UITableView *table;
}

// 数据源
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation JoinContactViewController

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

#pragma mark - 请求数据
- (void)requestData{
    
    // 请求参数
    NSDictionary *param = @{@"brandId":_brandId};
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brand/getContactInfo.do" params:param success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSDictionary *dict = JSON[@"data"];
        
        if (![dict isEqual:[NSNull null]]) {
            
            [_dataSource removeAllObjects];
            
//            for (NSDictionary *tempDic in dict) {
            
                ContactModel *model = [ContactModel contactWithDict:dict];
                
                [self.dataSource addObject:model];
//            }
            
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
    [self setupNav];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置导航条
- (void)setupNav{
    
    SDDButton *button = [[SDDButton alloc]init];
    button.frame = CGRectMake(0, 0, 100, 44);
    [button setTitle:@"联系方式" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    // table
    table = [[UITableView alloc] init];
    table.backgroundColor = bgColor;
    table.separatorStyle = NO;                  // 隐藏分割线
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 150;
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

#pragma mark - 设置Sections数 (tableView)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [_dataSource count];
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
    static NSString *identifier = @"Contact";
    //重用机制
    JoinContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
    
    if (cell == nil) {
        //当不存在的时候用重用标识符生成
        cell = [[JoinContactTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
        cell.textLabel.font = midFont;
    }
    
    ContactModel *model = _dataSource[indexPath.section];
    
    cell.peopleName.text = model.peopleName == nil?@"暂无":[NSString stringWithFormat:@"%@",model.peopleName];
    cell.peoplePosition.text = model.peoplePosition == nil?@"暂无":[NSString stringWithFormat:@"%@",model.peoplePosition];
    cell.peopleRegion.text = model.peopleRegion == nil?@"暂无":[NSString stringWithFormat:@"%@",model.peopleRegion];
    cell.peopleTel.text = model.peopleTel == nil?@"暂无":[NSString stringWithFormat:@"%@",model.peopleTel];
    cell.peopleMobileNum.text = model.peopleMobileNum == nil?@"暂无":[NSString stringWithFormat:@"%@",model.peopleMobileNum];
    cell.peopleEmail.text = model.peopleEmail == nil?@"暂无":[NSString stringWithFormat:@"%@",model.peopleEmail];
    cell.peopleAddress.text = model.peopleAddress == nil?@"暂无":[NSString stringWithFormat:@"%@",model.peopleAddress];
    
    return cell;
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
