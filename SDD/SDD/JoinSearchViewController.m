//
//  JoinSearchViewController.m
//  SDD
//
//  Created by hua on 15/6/29.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "JoinSearchViewController.h"
#import "FranchiseesMobel.h"

#import "JoinDetailViewController.h"

#import "DWTagList.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"

@interface JoinSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,DWTagListDelegate>{
    
    /*- ui -*/
    
    UITableView *table;
    DWTagList *tagList;                 // 标签云
    UITextField * leftTextField;        // 搜索内容
    UILabel *footLabel;                 // 清除记录
    
    UITableView *resultTable;
    
    /*- data -*/
    
    NSString *searchKey;
    NSInteger currentTable;
    NSInteger pages;
}
// 热搜列表
@property (nonatomic, strong) NSMutableArray *hotSearch;
// 搜索记录
@property (nonatomic, strong) NSMutableArray *searchArray;
// 搜索结果列表
@property (nonatomic, strong) NSMutableArray *compositeDataArr;

@end

@implementation JoinSearchViewController

- (NSMutableArray *)compositeDataArr{
    if (!_compositeDataArr) {
        _compositeDataArr = [[NSMutableArray alloc]init];
    }
    return _compositeDataArr;
}

- (NSMutableArray *)hotSearch{
    
    if (!_hotSearch) {
        _hotSearch = [[NSMutableArray alloc] init];
    }
    return _hotSearch;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    self.searchArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey: @"JoinSearchHistory"]];
    if ([_searchArray count] > 0) {
        footLabel.hidden = NO;
    }
    
    [table reloadData];
}

#pragma mark - 请求数据
- (void)requestData{
    
//    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brandSearch/list.do" params:@{@"pageNumber":@1,@"pageSize":@10} success:^(id JSON) {
//        
//        NSLog(@"%@",JSON);
//        
//    } failure:^(NSError *error) {
//        
//    }];
    
    // 请求参数
    NSDictionary *dic = @{@"pageNumber":@1,@"pageSize":@15};
    
    NSString *urlString = [SDD_MainURL stringByAppendingString:@"/brandSearch/list.do"];              // 拼接主路径和请求内容成完整url
    
    [self.httpManager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = responseObject;
        NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
        if (![dict[@"data"] isEqual:[NSNull null]]) {
            
            
            [_hotSearch removeAllObjects];
            
//            [self.hotSearch addObject:dict[@"data"]];
            for (NSString *tempDic in dict[@"data"]) {
                
                [self.hotSearch addObject:tempDic];
            }
            
            [table reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
}

#pragma mark - 请求搜索
- (void)seacherData{
    
    // 请求参数
    NSDictionary *dic = @{
                          @"pageNumber":@1,
                          @"pageSize":[NSNumber numberWithInteger:pages],
                          @"params":@{
                                  @"keyword": searchKey,
                                  @"type": @0,
                                  }
                          };
    
    NSString *urlString = [SDD_MainURL stringByAppendingString:@"/brand/search.do"];              // 拼接主路径和请求内容成完整url
    
    [self.httpManager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [table.footer endRefreshing];
        NSDictionary *dict = responseObject;
        NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
        
        if ([dict[@"totalSize"] intValue] == 0) {
            
            [self showErrorWithText:@"无搜索结果，请尝试其他关键词"];
        }
        
        if (![dict[@"data"] isEqual:[NSNull null]]) {
            
            [_compositeDataArr removeAllObjects];
            [resultTable.footer endRefreshing];
            for (NSDictionary *tempDic in dict[@"data"]) {
                
                FranchiseesMobel *model = [[FranchiseesMobel alloc] init];
                model.f_brandId = tempDic[@"brandId"];
                model.f_storeName = tempDic[@"storeName"];
                
                [self.compositeDataArr addObject:model];
            }
            
            [resultTable reloadData];
            
            // 判断数据个数与请求个数
            if ([_compositeDataArr count]<pages) {
                
                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                [resultTable.footer noticeNoMoreData];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [table.footer endRefreshing];
        NSLog(@"错误 -- %@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (iOS_version>=7.0) {
        
        self.edgesForExtendedLayout=NO;
    }
    
    // 请求数据
    [self requestData];
    // 导航条
    [self setupNav];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置导航条
- (void)setupNav{
    
    // 导航条左btn
    UIButton*backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 9, 14);
    [backButton setBackgroundImage:[UIImage imageNamed:@"返回-图标"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 搜索栏
    UIView * frontView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    
    UIImageView * LeftImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 6, 12, 13)];
    LeftImage.image = [UIImage imageNamed:@"搜索-图标"];
    [frontView addSubview: LeftImage];
    
    leftTextField = [[UITextField alloc] init];
    leftTextField.frame = CGRectMake(0, 0, viewWidth*2/3, 25);
    leftTextField.delegate = self;
    leftTextField.textColor = lgrayColor;
    [leftTextField setBackgroundColor:[UIColor whiteColor]];
    leftTextField.placeholder = @"品牌名称/品牌商";
    leftTextField.font = midFont;
    leftTextField.returnKeyType = UIReturnKeyGo;
    
    [leftTextField.layer setMasksToBounds:YES];//允许圆角
    [leftTextField.layer setCornerRadius:3];//圆角幅度
    
    [leftTextField becomeFirstResponder];
    
    leftTextField.leftView = frontView;
    leftTextField.leftViewMode = 3;
    [leftTextField addTarget:self
                      action:@selector(textFieldDidChange:)
            forControlEvents:UIControlEventEditingChanged];
    
    UIBarButtonItem *barTitle = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    UIBarButtonItem *barBack = [[UIBarButtonItem alloc]initWithCustomView:leftTextField];
    
    self.navigationItem.leftBarButtonItems = @[barTitle,barBack];
    
    // 导航条右btn
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 15);
    [rightBtn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"取消" forState:UIControlStateNormal];
    [rightBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    // 背景
    UIView *view_bg = [[UIView alloc] init];
    view_bg.frame = self.view.bounds;
    view_bg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view_bg];
    
    /*-------------------------- 搜索首页 --------------------------*/
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight*2/3) style:UITableViewStylePlain];
    table.backgroundColor = [UIColor whiteColor];
    table.delegate = self;
    table.dataSource = self;
    
    [view_bg addSubview:table];
    
    /*-------------------------- 搜索结果 --------------------------*/
    resultTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight*2/3) style:UITableViewStyleGrouped];
    resultTable.backgroundColor = bgColor;
    resultTable.delegate = self;
    resultTable.dataSource = self;
    resultTable.hidden = YES;
    // 集成上拉加载
    [resultTable addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [view_bg addSubview:resultTable];
    
    /*-------------------------- 清除搜索记录按钮 --------------------------*/
    footLabel = [[UILabel alloc]init];
    footLabel.frame = CGRectMake(0, CGRectGetMaxY(table.frame), viewWidth, 40);
    footLabel.userInteractionEnabled = YES;
    footLabel.backgroundColor = [UIColor whiteColor];
    footLabel.text = @"清空搜索记录";
    footLabel.textColor = lgrayColor;
    footLabel.textAlignment = NSTextAlignmentCenter;
    footLabel.font = [UIFont systemFontOfSize:12];
    
    UITapGestureRecognizer *cleanHistory = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cleanHistory)];
    [footLabel addGestureRecognizer:cleanHistory];
    
    [view_bg addSubview:footLabel];
}

#pragma mark - 上拉加载
- (void)loadMoreData{
    
    pages+=10;
    [self seacherData];
    NSLog(@"上拉加载%d个",pages);
}

#pragma mark - 设置tableview头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView == table) {
        UIView *head_bg =[[UIView alloc] init];
        head_bg.backgroundColor = bgColor;
        
        if (section==0) {
            
            UIImageView *hotImage = [[UIImageView alloc] init];
            hotImage.frame = CGRectMake(10, 5, 12, 16);
            hotImage.image = [UIImage imageNamed:@"index_icon_hotsearch_gray"];
            [head_bg addSubview:hotImage];
            
            UILabel *title = [[UILabel alloc] init];
            title.frame = CGRectMake(CGRectGetMaxX(hotImage.frame)+10, 0, viewWidth-20, 30);
            title.font = [UIFont systemFontOfSize:12];
            title.textColor = lgrayColor;
            title.text = @"搜索历史";
            [head_bg addSubview:title];
        }
        
        return head_bg;
    }
    else {
        return nil;
    }
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == resultTable) {
        return 40;
    }
    else {
        switch (indexPath.section) {
            case 0:
            {
                return 105;
            }
                break;
            default:{
                return 40;
            }
                break;
        };
    }
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == resultTable) {
        return [_compositeDataArr count];
    }
    else {
        switch (section) {
            case 0:
            {
                return 1;
            }
                break;
                
            default:{
                
                return [_searchArray count];
            }
                break;
        };
    }
}

#pragma mark - 设置section数 (tableView)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView == resultTable) {
        return 1;
    }
    return 2;
}

#pragma mark - 设置section 头高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView == resultTable) {
        return 0.01;
    }
    return 30;
}

#pragma mark - 设置cell (tableView)
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == resultTable) {
        
        //重用标识符
        static NSString *identifier = @"CELLMARK";
        //重用机制
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
        
        if(cell == nil){
            //当不存在的时候用重用标识符生成
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
        }
        
        FranchiseesMobel *model = _compositeDataArr[indexPath.row];
        // 地名
        cell.textLabel.text = model.f_storeName;
        
        return cell;
    }
    else {
        
        UITableViewCell *cell=nil;
        //重用标识符
        NSString *identifier = [NSString stringWithFormat:@"TimeLineCell%d%d",(int)indexPath.section,(int)indexPath.row];
        if (cell == nil) {
            //当不存在的时候用重用标识符生成
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
            cell.textLabel.font = midFont;
            if (indexPath.section != 0) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        
        switch (indexPath.section) {
            case 0:
            {
                if (tagList) {
                    [tagList removeFromSuperview];
                }
                tagList = [[DWTagList alloc] initWithFrame:CGRectMake(10, 10, viewWidth-20, 105)];
                tagList.delegate = self;
                [tagList setTagDelegate: self];
                tagList.backgroundColor = [UIColor whiteColor];
                [tagList setAutomaticResize:YES];
                [tagList setTags:_hotSearch];           // 对入数据
                
                // Customisation
                [tagList setTagBackgroundColor:[UIColor whiteColor]];
                [tagList setCornerRadius:0];
                [tagList setBorderColor:divisionColor];
                [tagList setBorderWidth:1.0f];
                [cell addSubview:tagList];
            }
                break;
                
            default:
            {
                cell.textLabel.text = _searchArray[indexPath.row];
            }
                break;
        }
        return cell;
    }
}

#pragma mark - 点击cell (tableView)
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView == resultTable) {
        
        [self searchHistory];
        
        FranchiseesMobel *model = _compositeDataArr[indexPath.section];
        
        JoinDetailViewController *jdVC = [[JoinDetailViewController alloc] init];
        jdVC.brandId = model.f_brandId;
        [self.navigationController pushViewController:jdVC animated:YES];
    }
    else {
        
        if (indexPath.section != 0) {
            
            UITableViewCell *cell = (UITableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
            
            // 搜索关键词
            leftTextField.text = cell.textLabel.text;
            searchKey = cell.textLabel.text;
            pages = 10;
            [self seacherData];
            
            table.hidden = YES;
            footLabel.hidden = YES;
            resultTable.hidden = NO;
        }
    }
}

#pragma mark - 点击tag搜索
- (void)selectedTag:(NSString *)tagName{
    
    // 搜索关键词
    leftTextField.text = tagName;
    
    searchKey = tagName;
    pages = 10;
    [self seacherData];
    [self searchHistory];
    
    table.hidden = YES;
    footLabel.hidden = YES;
    resultTable.hidden = NO;
}

#pragma mark - 搜索
-(void)textFieldDidChange:(UITextField *)textField
{
    if ([Tools_F ValidChineseString:textField.text]) {
        
        // 搜索关键词
        searchKey = textField.text;
        pages = 10;
        [self seacherData];
        
        table.hidden = YES;
        footLabel.hidden = YES;
        resultTable.hidden = NO;
    }
    else if (textField.text.length < 1){
        
        table.hidden = NO;
        footLabel.hidden = NO;
        resultTable.hidden = YES;
    }
}

#pragma mark - 保存搜索记录数据
- (void)searchHistory{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([_searchArray containsObject:leftTextField.text]) {
        [_searchArray removeObject:leftTextField.text];
    }
    [_searchArray insertObject:leftTextField.text atIndex:0];
    [defaults setObject: _searchArray forKey: @"JoinSearchHistory"];    // 做本地化处理
    [defaults synchronize];
}

#pragma mark - 删除搜索记录数据
- (void)cleanHistory{
    
    [self showSuccessWithText:@"搜索记录删除成功"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"JoinSearchHistory"];
    
    [_searchArray removeAllObjects];
    
    [table reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [leftTextField resignFirstResponder];    //回收键盘
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (![leftTextField isExclusiveTouch]) {
        [leftTextField resignFirstResponder];    //回收键盘
    }
}

#pragma mark - leftaction
- (void)rightAction:(UIButton *)btn{
    
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    if(iOS_version < 8){
        
        UITextField * inputTF = ((UIBarButtonItem * )[self.navigationItem.leftBarButtonItems objectAtIndex:1]).customView;
        UIButton * backBtn = ((UIBarButtonItem * )[self.navigationItem.leftBarButtonItems objectAtIndex:0]).customView;
        UIButton * rightBtn = (UIBarButtonItem * )self.navigationItem.leftBarButtonItem.customView;
        [backBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [backBtn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        backBtn.layer.hidden = true;
        [rightBtn addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        [inputTF addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        inputTF.layer.hidden = TRUE;
        inputTF = nil;
        self.navigationItem.leftBarButtonItems = nil;
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationController.navigationBarHidden = YES;
        super.navigationController.navigationBarHidden = NO;
    }
}


@end
