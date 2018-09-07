//
//  TagSearchViewController.m
//  SDD
//
//  Created by hua on 15/7/28.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "TagSearchViewController.h"
#import "QuestionListModel.h"

#import "QuestionListTableViewCell.h"
#import "MyQuestionsViewController.h"

#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

@interface TagSearchViewController ()<UIGestureRecognizerDelegate,UITableViewDataSource,
UITableViewDelegate>{
    
    /*- ui -*/
    
    UITableView *table;
    
    /*- data -*/
    
    NSArray *questions;                      // 问题
    NSInteger FAQsPageSize;
}

@end

@implementation TagSearchViewController

#pragma mark - 问题列表
- (void)requestQuestionList{
    
    NSDictionary *param = @{@"pageNumber":@1,
                            @"pageSize":[NSNumber numberWithInteger:FAQsPageSize],
                            @"params":@{@"keyword": _tagName}
                            };
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/questions/list.do" params:param success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSArray *arr = JSON[@"data"];
        
        [table.footer endRefreshing];
        if (![arr isEqual:[NSNull null]]) {
            
            questions = [QuestionListModel objectArrayWithKeyValuesArray:arr];
        }
        
        // 判断数据个数与请求个数
        if ([questions count]<FAQsPageSize) {
            
            // 拿到当前的上拉刷新控件，变为没有更多数据的状态
            [table.footer noticeNoMoreData];
        }
        
        [table reloadData];
        
    } failure:^(NSError *error) {
        
        [table.footer endRefreshing];
        NSLog(@"错误 -- %@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.view.backgroundColor = bgColor;
    
    FAQsPageSize = 10;
    
    // 请求数据
    [self requestQuestionList];
    // 导航条
    [self setNav:_tagName];
    [self setupUI];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    table.backgroundColor = bgColor;
    table.delegate = self;
    table.dataSource = self;
    [table addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreQuestion:)];
    [self.view addSubview:table];
    
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
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
