//
//  SDD_DeveloperList.m
//  ShopMoreAndMore
//
//  Created by mac on 15/7/4.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SDD_DeveloperList.h"
#import "Header.h"
#import "MJRefresh.h"

@interface SDD_DeveloperList (){

    NSInteger pages;
}
@property (nonatomic ,strong)NSArray *dataArray;
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)UITextField * DevTextField;
@end

@implementation SDD_DeveloperList



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [SDDColor colorWithHexString:@"#e5e5e5"];
    pages = 10;
    [self displayContext];
    [self requestData];

}
-(void)requestData{

    [self showLoading:2];
    [HttpRequest postWithBaseURL:SDD_MainURL path:@"/house/developerList.do" parameter:@{@"pageNumber":@0,@"pageSize":@(pages)} success:^(id Josn) {
        NSLog(@"%@",Josn);
        
        
        self.dataArray = Josn[@"data"];
        
        // 判断数据个数与请求个数
        if ([_dataArray count]<pages) {
            
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [self.tableView.footer noticeNoMoreData];
        }
        
        [self.tableView.footer endRefreshing];
        [self.tableView.header endRefreshing];
        [self hideLoading];
        [self.tableView reloadData];
        
        
    } failure:^(NSError *error){
        NSLog(@"%@",error);
        [self hideLoading];
        [self.tableView.footer endRefreshing];
        [self.tableView.header endRefreshing];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.dataArray[indexPath.row][@"developersName"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (_page == 1) {
        SDD_BasicInformation *basicInfo = [[self.navigationController viewControllers] objectAtIndex:2];
        basicInfo.developName = cell.textLabel.text;
        [self.navigationController popToViewController:basicInfo animated:YES];
    }
    else
    {
        SDD_BasicInformation *basicInfo = [[self.navigationController viewControllers] objectAtIndex:2];
        basicInfo.developName = cell.textLabel.text;
        [self.navigationController popToViewController:basicInfo animated:YES];
    }
   
}
- (void)displayContext
{
   
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"开发商";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(0, 0, 60, 25);
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = titleFont_15;
    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * BarItem = [[UIBarButtonItem alloc] initWithCustomView:confirmBtn];
    
    self.navigationItem.rightBarButtonItem = BarItem;
    
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 50)];
    _DevTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 8,viewWidth-20 , 35)];
    _DevTextField.placeholder = @"请输入开发商";
    _DevTextField.borderStyle = UITextBorderStyleRoundedRect;
    [topView addSubview:_DevTextField];
    
    self.tableView.tableHeaderView = topView;
    
    [self.tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadRefreshData)];
    
    UIView * footerView = [[UIView alloc] init];
    
    self.tableView.tableFooterView = footerView;
}

-(void)confirmBtnClick:(UIButton *)btn{

    if (![_DevTextField.text isEqualToString:@""]) {
        
        SDD_BasicInformation *basicInfo = [[self.navigationController viewControllers] objectAtIndex:2];
        basicInfo.developName = _DevTextField.text;
        [self.navigationController popToViewController:basicInfo animated:YES];
    }else{
    
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                         message:@"请选择开发商"
                                                        delegate:self
                                               cancelButtonTitle:@"知道了"
                                               otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

- (void)leftButtonClick
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 下拉刷新
- (void)loadRefreshData{
    
    pages = 10;
    //[self showLoading:2];
    [self requestData];
    NSLog(@"上拉加载%d个",pages);
}
#pragma mark - 上拉加载
- (void)loadMoreData{
    
    pages+=10;
    //[self showLoading:2];
    [self requestData];
    NSLog(@"上拉加载%d个",pages);
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
