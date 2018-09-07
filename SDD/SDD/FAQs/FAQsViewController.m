//
//  FAQsViewController.m
//  SDD
//
//  Created by hua on 15/8/14.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "FAQsViewController.h"
#import "DynamicViewController.h"
#import "UserInfo.h"
#import "QuestionListTableViewCell.h"
#import "CategoryContentListModel.h"
#import "QuestionListModel.h"
#import "FAQsView.h"

#import "DynamicAnswerViewController.h"
#import "QuestionSearchViewController.h"
#import "MyQuestionsViewController.h"
#import "NewQuestionViewController.h"
#import "TagSearchViewController.h"

#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

@interface FAQsViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,
UISearchBarDelegate,UITabBarControllerDelegate>{
    
    /*- ui -*/
    
    FAQsView *faqsView;                      // 问答页
    
    /*- data -*/
    
    NSMutableArray *dataSource;              // 数据源
    NSMutableArray *headImages;              // 图片数据源
    NSArray *questions;                      // 问题
    
    NSInteger FAQsPageSize;
    BOOL haveImage;
    BOOL haveContent;
}


@end

@implementation FAQsViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    UIButton *avatarBtn = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
    [avatarBtn sd_setImageWithURL:[UserInfo sharedInstance].userInfoDic[@"icon"] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultAvatar_icon_"]];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
}

#pragma mark - 热门标签
- (void)requestHotTag{
    
    NSDictionary *param = @{@"pageNumber":@1,
                            @"pageSize":@15,
                            @"params":@{@"tagName": @""}
                            };
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/questionsSystemTag/list.do" params:param success:^(id JSON) {
        
        //        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSArray *arr = JSON[@"data"];
        
        if (![arr isEqual:[NSNull null]]) {
            
            UIView* contentView = UIView.new;
            [faqsView.hotTagScrollView addSubview:contentView];
            
            [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(faqsView.hotTagScrollView);
                make.height.equalTo(faqsView.hotTagScrollView);
            }];
            
            UILabel *lastLabel;
            for (NSString *tagName in arr) {
                
                UILabel *tagLabel = [[UILabel alloc] init];
                tagLabel.backgroundColor = setColor(188, 188, 188, 1);
                tagLabel.font = midFont;
                tagLabel.text = tagName;
                tagLabel.textAlignment = NSTextAlignmentCenter;
                CGSize tagSize = [Tools_F countingSize:tagName fontSize:13 height:13];
                //                tagLabel.frame = CGRectMake(10, 10, tagSize.width+16, 26);
                [contentView addSubview:tagLabel];
                
                [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(lastLabel?lastLabel.mas_right:faqsView.hotTagScrollView.mas_left).with.offset(10);
                    make.size.mas_equalTo(CGSizeMake(tagSize.width+16, 26));
                    make.centerY.equalTo(contentView);
                }];
                
                tagLabel.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagTap:)];
                [tagLabel addGestureRecognizer:tap];
                
                lastLabel = tagLabel;
            }
            
            [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(lastLabel.mas_right).offset(10);
            }];
        }
    } failure:^(NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
}

#pragma mark - 问题列表
- (void)requestQuestionList{
    
    [self showLoading:1];
    NSDictionary *param = @{@"pageNumber":@1,
                            @"pageSize":[NSNumber numberWithInteger:FAQsPageSize],
                            @"params":@{@"keyword": @""}
                            };
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/questions/list.do" params:param success:^(id JSON) {
        
        //        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSArray *arr = JSON[@"data"];
        
        [faqsView.table.footer endRefreshing];
        if (![arr isEqual:[NSNull null]]) {
            
            questions = [QuestionListModel objectArrayWithKeyValuesArray:arr];
        }
        
        // 判断数据个数与请求个数
        if ([questions count]<FAQsPageSize) {
            
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [faqsView.table.footer noticeNoMoreData];
        }
        
        [self hideLoading];
        [faqsView.table reloadData];
        
    } failure:^(NSError *error) {
        
        [self hideLoading];
        [faqsView.table.footer endRefreshing];
        NSLog(@"问题列表错误 -- %@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    haveImage = NO;
    haveContent = NO;
    FAQsPageSize = 10;
    
    // 请求数据
    [self requestHotTag];
    [self requestQuestionList];
    // 导航条
    [self setupNav];
    [self setupUI];
}

#pragma mark - 设置导航条
- (void)setupNav{
    
    // 个人问答
    UIButton *avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    avatarButton.frame = CGRectMake(0, 0, 35, 35);
    avatarButton.titleLabel.font = biggestFont;
    [avatarButton sd_setImageWithURL:[UserInfo sharedInstance].userInfoDic[@"icon"] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultAvatar_icon_"]];
    [avatarButton addTarget:self action:@selector(myFAQs:) forControlEvents:UIControlEventTouchUpInside];
    [Tools_F setViewlayer:avatarButton cornerRadius:35/2 borderWidth:1 borderColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:avatarButton];
    
    [self setNav:@"问答"];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    /*-                    问答                    -*/
    faqsView = [[FAQsView alloc] init];
    faqsView.frame = self.view.bounds;
    faqsView.headSearch.delegate = self;
    faqsView.table.delegate = self;
    faqsView.table.dataSource = self;
    [faqsView.table addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreQuestion:)];
    
    [self.view addSubview:faqsView];
    
    [faqsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.width.mas_equalTo(viewWidth);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    // 提问
    UIButton *askQuestion = [UIButton buttonWithType:UIButtonTypeCustom];
    askQuestion.titleLabel.font = titleFont_15;
    askQuestion.backgroundColor = dblueColor;
    [askQuestion setTitle:@"提问" forState:UIControlStateNormal];
    [askQuestion setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [Tools_F setViewlayer:askQuestion cornerRadius:20 borderWidth:2 borderColor:[UIColor whiteColor]];
    [askQuestion addTarget:self action:@selector(askQuestions:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:askQuestion];
    
    [askQuestion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.bottom.equalTo(self.view.mas_bottom).offset(-25);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
}

#pragma mark - 加载更多问题
- (void)loadMoreQuestion:(MJRefreshFooter *)sender{
    
    FAQsPageSize+=10;
    [self requestQuestionList];
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 计算高度
    QuestionListModel *model = questions[indexPath.section];
    
    CGSize question = [Tools_F countingSize:model.content fontSize:13 width:viewWidth-20];
    if (model.goodsAnswerContent.length > 0) {
        
        CGSize answer = [Tools_F countingSize:model.goodsAnswerContent fontSize:13 width:viewWidth-36];
        answer.height = answer.height > 55? 55:answer.height;
        return question.height + 50 + answer.height + 16;
    }
    else {
        return question.height+50;
    }
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

#pragma mark - 设置Sections数 (tableView)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [questions count];
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
    static NSString *identifier = @"FAQs";
    //重用机制
    QuestionListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
    
    if (cell == nil) {
        //当不存在的时候用重用标识符生成
        cell = [[QuestionListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
    }
    
    QuestionListModel *model = questions[indexPath.section];
    
    // 问题
    cell.theQuestion.text = model.content;
    // 回答
    cell.haveBestAnswer = model.goodsAnswerContent.length > 0? YES:NO;
    cell.theAnswer.text = model.goodsAnswerContent;
    
    // 标签
    NSString *tagString = @"";
    if (![model.tagList isEqual:[NSNull null]]) {
        for (NSString *str in model.tagList) {
            tagString = [tagString stringByAppendingString:[NSString stringWithFormat:@"   %@",str]];
        }
    }
    cell.theTags.text = tagString;
    // 回答数量
    [cell.theAnswerQty setTitle:[NSString stringWithFormat:@"%d",model.totalAnswerQty] forState:UIControlStateNormal];
    
    return cell;
}

#pragma mark - 点击cell (tableView)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QuestionListModel *model = questions[indexPath.section];
    
    MyQuestionsViewController * myQVc = [[MyQuestionsViewController alloc] init];
    myQVc.questionsId = model.questionsId;
    
    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
    [self.navigationController pushViewController:myQVc animated:YES];
}

#pragma mark - 我的问答
- (void)myFAQs:(UIButton *)btn{
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        
        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else {
        
        DynamicAnswerViewController *daVC = [[DynamicAnswerViewController alloc] init];
        
        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
        [self.navigationController pushViewController:daVC animated:YES];
    }
}

#pragma mark - 提问
- (void)askQuestions:(UIButton *)btn{
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        
        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else {
        
        NewQuestionViewController *nqVC = [[NewQuestionViewController alloc] init];
        
        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
        [self.navigationController pushViewController:nqVC animated:YES];
    }
}

#pragma mark - 跳去搜索
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    QuestionSearchViewController *qsVC = [[QuestionSearchViewController alloc] init];
    
    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
    [self.navigationController pushViewController:qsVC animated:YES];
    return NO;
}

#pragma mark - tag点击
- (void)tagTap:(UITapGestureRecognizer *)tap{
    
    UILabel *label = (UILabel *)tap.view;
    TagSearchViewController *tsVC = [[TagSearchViewController alloc] init];
    tsVC.tagName = label.text;
    
    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
    [self.navigationController pushViewController:tsVC animated:YES];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

