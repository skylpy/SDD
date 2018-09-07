//
//  SDD_MyIssueViewController.m
//  ShopMoreAndMore
//  我的发布
//  Created by mac on 15/7/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SDD_MyIssueViewController.h"
#import "Header.h"
#import "MyPublicBean.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "SDD_Preview.h"

@interface SDD_MyIssueViewController ()
{
    NSInteger pages;
    CGPoint startPoint;             // 记录初始点
}
// 数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation SDD_MyIssueViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataSource = [[NSMutableArray alloc]init];
    [self displayContext];

    [self loadMoreData];
    
}
- (void)leftButtonClick:(UIButton*)sender
{
//    if ([self.navigationController viewControllers].count <5) {
//        SDD_MyNewIssue *vc = [[self.navigationController viewControllers] objectAtIndex:1];
//        [self.navigationController popToViewController:vc animated:YES];
//    }
//    if ([self.navigationController viewControllers].count >6) {
//        SDD_MyNewIssue *vc = [[self.navigationController viewControllers] objectAtIndex:6];
//        [self.navigationController popToViewController:vc animated:YES];
//    }
}
- (void)displayContext
{
//    self.title = @"我的发布";
//
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(10, 30, 10, 20);
//    [button setBackgroundImage:[UIImage imageNamed:@"return_icon"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    self.navigationItem.leftBarButtonItem = leftButton;
    
    SDDButton *button = [[SDDButton alloc]init];
    button.frame = CGRectMake(0, 0, viewWidth*2/3, 44);
    [button setTitle:@"我的发布" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.backgroundColor = [SDDColor colorWithHexString:@"#e5e5e5"];
    UIView *backgroundView = [[UIView alloc] initWithFrame:_tableView.bounds];
    backgroundView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _tableView.backgroundView = backgroundView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView.panGestureRecognizer addTarget:self action:@selector(pan:)];      // 添加拖拽手势
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.view addSubview:_tableView];
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view.mas_top).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewWidth, viewHeight - StatusbarSize));
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section == 0) {
//        return 0;
//    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 0) {
//        return 43;
//    }
    return 173;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDD_MyIssueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[SDD_MyIssueCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
    }
    MyPublicBean *model = _dataSource[indexPath.row];
    
    UIButton *statusButton = (UIButton*)[cell viewWithTag:1000];
    [cell.nameLable setText:model.houseName];
    switch ([model.status intValue]) {
        case -2:
            [statusButton setTitle:NSLocalizedString(@"p.save", @"") forState:UIControlStateNormal];
            break;
        case 0:
            [statusButton setTitle:NSLocalizedString(@"p.check", @"") forState:UIControlStateNormal];
            break;
        case 1:
            [statusButton setTitle:NSLocalizedString(@"p.success", @"") forState:UIControlStateNormal];
            break;
        case 3:
            [statusButton setTitle:NSLocalizedString(@"p.failure", @"") forState:UIControlStateNormal];
            break;
    }
    
    [statusButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.cityImage sd_setImageWithURL:[NSURL URLWithString:model.defaultImage]  placeholderImage:[UIImage imageNamed:@"loading_b"]];
    UIButton *telButton = (UIButton*)[cell viewWithTag:1001];
    [telButton addTarget:self action:@selector(takePhone:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[NSString stringWithFormat:@"%@",model.status] intValue] == 1) {
        cell.contextLable.text = @"发布成功！敬请留意，如有疑问请致电...";
    }
    if ([[NSString stringWithFormat:@"%@",model.status] intValue] == 3) {
        cell.contextLable.text = @"发布失败！如有疑问请致电...";
    }
    if ([[NSString stringWithFormat:@"%@",model.status] intValue] == 0) {
        cell.contextLable.text = @"您的项目正在审核中，如有疑问请致电...";
    }
    if ([[NSString stringWithFormat:@"%@",model.status] intValue] == -2) {
        cell.contextLable.text = @"保存成功！如有疑问请致电...";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //SDD_MyIssueCell *cell = (SDD_MyIssueCell *)[tableView cellForRowAtIndexPath:indexPath];
    MyPublicBean *model = _dataSource[indexPath.row];
    SDD_Preview * sdd_Vc = [[SDD_Preview alloc] init];
    sdd_Vc.model = model;
    [self.navigationController pushViewController:sdd_Vc animated:YES];
    
}

- (void)buttonClick:(UIButton *)sender
{
    NSLog(@"%ld",sender.tag);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onSuccess:(AFHTTPRequestOperation *)operation context:(id)responseObject{
    
    [self hideLoading];
    NSDictionary *dict = responseObject;
    NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
    if (![dict[@"data"] isEqual:[NSNull null]]) {
        
        NSLog(@"dict = %@",dict[@"data"]);
        
//        [_mgpArr removeAllObjects];
//        [table.footer endRefreshing];
        for (NSDictionary *tempDict in dict[@"data"]) {
            
            MyPublicBean *model = [[MyPublicBean alloc] init];
            model.houseFirstId = tempDict[@"houseFirstId"];
            model.defaultImage = tempDict[@"defaultImage"];
            model.status = tempDict[@"status"];
            model.houseName = tempDict[@"houseName"];
            [_dataSource addObject:model];
        }

//        // 判断数据个数与请求个数
        if ([_dataSource count]<pages) {
            
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [_tableView.footer noticeNoMoreData];
        }
        [self hideLoading];
        [_tableView reloadData];
    }
}

#pragma mark - 上拉加载
- (void)loadMoreData{
    
    // 请求参数
    NSDictionary *param = @{@"pageNumber":@1,
                            @"pageSize":[NSNumber numberWithInteger:pages]
                            };
    NSString *urlString = [SDD_MainURL stringByAppendingString:@"/userHouseFirst/myPublish.do"];
    [self sendRequest:param url:urlString];
    pages+=10;
}

- (void)onFailure:(AFHTTPRequestOperation *)operation error:(NSError *)error{
    [self hideLoading];
    [_tableView.footer endRefreshing];
}

#pragma mark - ScrollView拖拽
- (void)pan:(UIPanGestureRecognizer *)panParam{
    
    
    if (panParam.state == UIGestureRecognizerStateBegan){          //条件内：每次移动只调用一次
        
        startPoint = [panParam locationInView:self.view];          //记录起始点
    }
    else {
        
        CGPoint newPoint=[panParam locationInView:self.view];      //记录当前点
        //得到y的偏移量
        CGFloat contextOffY = newPoint.y-startPoint.y;
        if (contextOffY > 20) {
            //        NSLog(@"往下拖拽显示");
//            bottomViews.hidden = NO;
            
//            [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//                
//                make.bottom.equalTo(self.view.mas_bottom).with.offset(-44);
//            }];
        } else if (contextOffY < -20) {
            //        NSLog(@"往上拖拽隐藏");
//            bottomViews.hidden = YES;
//            [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//                
//                make.bottom.equalTo(self.view.mas_bottom);
//            }];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 滚动停止显示
//    bottomViews.hidden = NO;
//    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//        
//        make.bottom.equalTo(self.view.mas_bottom).with.offset(-44);
//    }];
}

- (void)takePhone:(id)sender{
    
    // 联系客服
    UIWebView*callWebview =[[UIWebView alloc] init];
    
    NSString *telNumber = [NSString stringWithFormat:@"tel:%@",@4009918829];
    
    NSURL *telURL = [NSURL URLWithString:telNumber];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}

@end
