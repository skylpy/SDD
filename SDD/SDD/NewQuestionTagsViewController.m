//
//  NewQuestionTagsViewController.m
//  SDD
//
//  Created by hua on 15/7/28.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "NewQuestionTagsViewController.h"
#import "QuestionListModel.h"

#import "ProgressHUD.h"
#import "DWTagList.h"
#import "UIImageView+WebCache.h"

@interface NewQuestionTagsViewController ()<UIGestureRecognizerDelegate,UITableViewDataSource,
UITableViewDelegate,UISearchBarDelegate,DWTagListDelegate>{
    
    /*- ui -*/
    
    UITableView *table;
//    DWTagList *tagList;                 // 标签云
    
    
    /*- data -*/
    
    NSArray *sectionTitles;
    UIButton *addTag;
    NSMutableArray *selectedTags;       // 选择的tags
}

// 热搜列表
@property (nonatomic, strong) NSMutableArray *hotSearch;
// 热搜列表
@property (nonatomic, strong) NSMutableArray *keySearch;

@end

@implementation NewQuestionTagsViewController

- (NSMutableArray *)hotSearch{
    
    if (!_hotSearch) {
        _hotSearch = [[NSMutableArray alloc] init];
    }
    return _hotSearch;
}

- (NSMutableArray *)keySearch{
    
    if (!_keySearch) {
        _keySearch = [[NSMutableArray alloc] init];
    }
    return _keySearch;
}

#pragma mark - 热门标签
- (void)requestHotTag{
    
    NSDictionary *param = @{@"pageNumber":@1,
                            @"pageSize":@20,
                            @"params":@{@"tagName": @""}
                            };
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/questionsSystemTag/list.do" params:param success:^(id JSON) {
        
        //        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSArray *arr = JSON[@"data"];
        
        if (![arr isEqual:[NSNull null]]) {
            
            [_hotSearch removeAllObjects];
            for (NSString *tagName in arr) {
                
                [self.hotSearch addObject:tagName];
            }
            [table reloadData];
        }
    } failure:^(NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.view.backgroundColor = bgColor;
    
    selectedTags = [[NSMutableArray alloc] initWithCapacity:3];
    // 导航条
    [self setNav:@"选择标签"];
    // 请求
    [self requestHotTag];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置导航条
- (void)setupNav{
    
}

#pragma mark - 设置内容
- (void)setupUI{
    
    // 搜索栏
    UISearchBar *headSearch = [[UISearchBar alloc] init];
    headSearch.delegate = self;
    headSearch.placeholder = @"搜索标签并添加";
    
    [self.view addSubview:headSearch];
    [headSearch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 44));
    }];
    
    sectionTitles = @[@"已添加标签",@"推荐标签"];
    
    // 搜索列表
    table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    table.backgroundColor = bgColor;
    table.bounces = NO;
    table.delegate = self;
    table.dataSource = self;
    
    [self.view addSubview:table];
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headSearch.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(viewHeight/3+20);
    }];
    
    // 发布
    ConfirmButton *publish = [[ConfirmButton alloc] initWithFrame:CGRectZero
                                                                title:@"发布"
                                                               target:self
                                                           action:@selector(publish:)];
    publish.enabled = YES;
    [self.view addSubview:publish];
    
    [self.view addSubview:publish];
    [publish mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(table.mas_bottom).offset(35);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(viewWidth - 40, 45));
    }];
}

#pragma mark - 设置tableview头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *head_bg =[[UIView alloc] init];
    head_bg.backgroundColor = bgColor;
    
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(10, 0, viewWidth-20, 25);
    title.font = [UIFont systemFontOfSize:12];
    title.text = sectionTitles[section];
    title.textColor = lgrayColor;
    [head_bg addSubview:title];
    
    return head_bg;
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            return 44;
        }
        default:{
            return 105;
        }
    };
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
        {
            return 1;
        }
        default:{
            return 1;
        }
    }
}

#pragma mark - 设置section数 (tableView)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

#pragma mark - 设置section 头高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 25;
}

#pragma mark - 设置section 脚高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}

#pragma mark - 设置cell (tableView)
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //重用标识符
    static NSString *identifier = @"QuestionTags";
    //重用机制
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列

    if (cell == nil) {
        //当不存在的时候用重用标识符生成
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
    }
    
    switch (indexPath.section) {
        case 0:
        {
            for (UIView *allView in cell.subviews) {
                [allView removeFromSuperview];
            }
            
            NSString *canAdd = [NSString stringWithFormat:@"可添加%d个",3-[selectedTags count]];
            
            if ([selectedTags count]<3) {
                if ([selectedTags containsObject:canAdd]) {
                    [selectedTags removeObject:canAdd];
                }
                [selectedTags addObject:canAdd];
            }
            
            UIButton *lastButton;
            for (NSString *tagName in selectedTags) {
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.titleLabel.font = midFont;
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"you_can_add_frame"] forState:UIControlStateNormal];
                [button setTitle:tagName forState:UIControlStateNormal];
                [button addTarget:self action:@selector(cancelSelecte:) forControlEvents:UIControlEventTouchUpInside];
                // 计算宽度
                CGSize buttonSize = [Tools_F countingSize:tagName fontSize:13 height:13];
                
                [cell addSubview:button];
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(cell.mas_top).offset(8);
                    make.bottom.equalTo(cell.mas_bottom).offset(-8);
                    make.left.equalTo(lastButton?lastButton.mas_right:cell.mas_left).offset(10);
                    make.width.equalTo(@(buttonSize.width+24));
                }];
                
                lastButton = button;
            }
            [selectedTags removeLastObject];  // 移除“可添加XXX”
            
//            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//            button.titleLabel.font = midFont;
//            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [button setBackgroundImage:[UIImage imageNamed:@"you_can_add_frame"] forState:UIControlStateNormal];
//            [button setTitle:@"ttttttt" forState:UIControlStateNormal];
//            [button addTarget:self action:@selector(cancelSelecte:) forControlEvents:UIControlEventTouchUpInside];
//            // 计算宽度
//            CGSize buttonSize = [Tools_F countingSize:@"ttttttt" fontSize:13 height:13];
//            button.frame = CGRectMake(10, 10, buttonSize.width+24, 13);
//            [cell addSubview:button];
            
        }
            break;
        default:
        {
            for (UIView *allView in cell.subviews) {
                [allView removeFromSuperview];
            }
            
            DWTagList *tagList = [[DWTagList alloc] initWithFrame:CGRectMake(10, 10, viewWidth-20, 85)];
            tagList.tagDelegate = self;
            tagList.backgroundColor = [UIColor whiteColor];
            [tagList setAutomaticResize:YES];
            tagList.automaticResize = YES;
            tagList.Tags = [_keySearch count]>0?_keySearch:_hotSearch;           // 对入数据
            
            // Customisation
            [tagList setTagBackgroundColor:[UIColor whiteColor]];
            [tagList setCornerRadius:0];
            [tagList setBorderColor:divisionColor];
            [tagList setBorderWidth:1.0f];
            [cell addSubview:tagList];
        }
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     [self.view endEditing:YES];
}

#pragma mark - UISearchBar代理
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (searchText.length>0) {
        
        [self seacherKeyword:searchText];
    }
    else {
        
        [_keySearch removeAllObjects];
        [table reloadData];
    }
}

#pragma mark - 搜索关键词
- (void)seacherKeyword:(NSString *)string{
    
    NSDictionary *param = @{@"pageNumber":@1,
                            @"pageSize":@20,
                            @"params":@{@"tagName": string}
                            };
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/questionsSystemTag/list.do" params:param success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSArray *arr = JSON[@"data"];
        
        [_keySearch removeAllObjects];
        
        if (![arr isEqual:[NSNull null]]) {
            
            for (NSString *tagName in arr) {
                
                [self.keySearch addObject:tagName];
            }
            [table reloadData];
        }
        else {
            [self.keySearch addObject:string];
            [table reloadData];
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
}

#pragma mark - 点击tag取消
- (void)cancelSelecte:(UIButton *)btn{
    
    NSString *currentTagName = btn.titleLabel.text;
    if ([selectedTags containsObject:currentTagName]) {
        [selectedTags removeObject:currentTagName];
    }
    [table reloadData];
}
#pragma mark - 点击tag添加
- (void)selectedTag:(NSString *)tagName{
    
    if ([selectedTags containsObject:tagName]) {
        
    }
    else if (selectedTags.count>3) {
        
        [ProgressHUD showSuccess:@"最多选择3个标签"];
    }
    else {
        
        [selectedTags addObject:tagName];
        [table reloadData];
    }
}

#pragma mark - 发布
- (void)publish:(UIButton *)btn{
    
    NSDictionary *param = @{@"content":_questionDescribe,
                            @"tagList":selectedTags,
                            @"rewardScore":@([_integralStr integerValue])};//
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/questions/add.do" params:param success:^(id JSON) {
        
//        NSLog(@"%@\n%@>>>>>>>%@",param,JSON[@"message"],JSON);
        NSInteger theStatus = [JSON[@"status"] integerValue];
        
        [ProgressHUD showSuccess:JSON[@"message"]];
        if (theStatus == 1) {
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
}

#pragma mark - leftaction
- (void)leftAction:(UIButton *)btn{
    
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
