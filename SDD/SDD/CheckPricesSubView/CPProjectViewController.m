//
//  CPProjectViewController.m
//  SDD
//
//  Created by mac on 15/5/12.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "CPProjectViewController.h"
#import "HouseListModel.h"
#import "HouseListFrame.h"
#import "CPPCell.h"
#import "ProgressHUD.h"

@interface CPProjectViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UISearchBarDelegate>
{
    HouseListModel *_listModel;
    UITableView *_tableView;
    UITextField *_textField;
    NSArray *_array;
    UISearchBar *_search;
    NSMutableArray *_houseSections;
    NSMutableArray *_addressSections;
}

@property (nonatomic, strong) NSMutableArray *arrayList;

@property (nonatomic, strong) UISearchDisplayController *searchController;


@end

@implementation CPProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addTableView];
    
    [self setupNavi];
    
//    [self loadDataList];
    
}

- (void)setupNavi{
    
    SDDButton *button = [[SDDButton alloc]init];
    button.frame = CGRectMake(0, 0, 40, 44);
    [button setTitle:@"" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UISearchBar *search = [[UISearchBar alloc]init];
    search.frame = CGRectMake(0, 0, 160, 44);
    search.delegate = self;
    search.placeholder = @"请输入楼盘名称";
    search.barStyle = UIBarStyleDefault;
    self.navigationItem.titleView = search;
    _search = search;
    
    self.searchController = [[UISearchDisplayController alloc]initWithSearchBar:search contentsController:self];
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
}

#pragma make -- searchBar代理方法
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
   
    if ([self isValidChineseString]) {
//        NSLog(@"_search.text %@", _search.text);
        [self loadDataList];
    }else{
        [ProgressHUD showSuccess:@"请输入中文查询"];
    }
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [_search setShowsCancelButton:NO animated:YES];
    [_search resignFirstResponder];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [_search setShowsCancelButton:NO animated:YES];
    [_search resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];

    //改变searchBar取消按钮颜色
    for(id cc in [searchBar.subviews[0] subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    
//    [_textField resignFirstResponder];
//    
//    [self loadDataList];
//    
//    return YES;
//}


-(void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadDataList
{
    self.arrayList = [NSMutableArray array];
    
    _houseSections = [NSMutableArray array];
    _addressSections = [NSMutableArray array];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:_search.text forKey:@"houseName"];
    
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    [dict2 setObject:dict forKey:@"params"];
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/house/byHousName.do" params:dict2 success:^(id JSON) {
        
        NSArray *array = JSON[@"data"];
        _array = array;
        NSLog(@"array %@", array);

        if ([array isEqual:[NSNull null]]) {
            
            [ProgressHUD showSuccess:@"对不起,没有你输入的搜索结果"];
            
        }
        else{
        
            for (NSDictionary *dic in array) {
                _listModel = [[HouseListModel alloc]initWithHouseListDict:dic];
                [self.arrayList addObject:_listModel];
            }
            
            for (int i = 0; i<[array count]; i++) {
                
                [_houseSections addObject:array[i][@"houseName"]];
                [_addressSections addObject:array[i][@"address"]];
            }
      
        }
       
           [_tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)addTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height- 20)];
    tableView.backgroundColor = [SDDColor sddbackgroundColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    tableView.tableFooterView = [[UIView alloc]init];
    _tableView = tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [self.arrayList count];
    return [_houseSections count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cpProjectCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _houseSections[indexPath.row];
    cell.detailTextLabel.text = _addressSections[indexPath.row];
    
//    CPPCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (!cell) {
//        cell = [[CPPCell alloc]init];
//    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    HouseListFrame *f = [[HouseListFrame alloc] init];
//    f.listModel = self.arrayList[indexPath.row];
//    cell.listFrame = f;
  
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        if (_doTransferHouseName) {
            _doTransferHouseName(_array[indexPath.row][@"houseName"],_array[indexPath.row][@"houseId"]);
            _doTransferHouseName = nil;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
        if (_doTransferHouseName) {
           _doTransferHouseName(_array[indexPath.row][@"houseName"],_array[indexPath.row][@"houseId"]);
            _doTransferHouseName = nil;
        }        
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//正则表达式判断是否为中文（1-8）位
- (BOOL)isValidChineseString
{
    NSString *chineseRegex = @"[\u4e00-\u9fa5]{1,8}$";
    NSPredicate *chineseText = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",chineseRegex];
    
    return [chineseText evaluateWithObject:_search.text];
}



@end
