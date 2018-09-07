//
//  DynamicViewController.m
//  sdd_iOS_personal
//
//  Created by hua on 15/4/3.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "DynamicViewController.h"
#import "UserInfo.h"
#import "DynamicListTableViewCell.h"
#import "QuestionListTableViewCell.h"
#import "DynamicCategoryListModel.h"
#import "CategoryContentListModel.h"
#import "DynamicHeadImagesModel.h"
#import "QuestionListModel.h"
#import "FAQsView.h"

#import "DynamicAnswerViewController.h"
#import "DDetailViewController.h"
#import "QuestionSearchViewController.h"
#import "MyQuestionsViewController.h"
#import "NewQuestionViewController.h"
#import "TagSearchViewController.h"

#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

@interface DynamicViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,
UISearchBarDelegate,UITabBarControllerDelegate>{
    
    /*- ui -*/
    
    UIScrollView *titleScrollView;           // 标题底部ScrollView
    UIScrollView *tableScrollView;           // table底部ScrollView
    UIView *contentView_title;               // 标题底部
    UIView *contentView_table;               // table底部
    UIView *redLine;                         // 标题底部红线
    
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

@implementation DynamicViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];    
    
    UIButton *avatarBtn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
    [avatarBtn sd_setImageWithURL:[UserInfo sharedInstance].userInfoDic[@"icon"] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultAvatar_icon_"]];
    
    self.tabBarController.tabBar.viewForBaselineLayout.hidden = NO;      //  显示tabar
    
    self.tabBarController.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:YES];
    self.tabBarController.delegate = nil;
}

#pragma mark - 资讯栏目
- (void)requestDynadynamicCategorymicCategory{
    
    [self showLoading:1];
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/dynamicCategory/list.do" params:nil success:^(id JSON) {
        
//        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSArray *arr = JSON[@"data"];
        
        if (![arr isEqual:[NSNull null]]) {
            // 类目标题model
            NSArray *categoryList = [DynamicCategoryListModel objectArrayWithKeyValuesArray:arr];
            
            int categoryListCounts = [categoryList count];
            dataSource = [NSMutableArray array];
            headImages = [NSMutableArray array];
            
            // 循环获取列表内容
            for (int i=0; i<categoryListCounts; i++) {
                
                DynamicCategoryListModel *model = categoryList[i];
                
                // 第一次获取10个
                [self requestListWithCategoryName:model.categoryName
                                dynamicCategoryId:model.dynamicCategoryId
                                         pageSize:@10
                                            index:i
                                           counts:categoryListCounts];
            }
        }
    } failure:^(NSError *error) {
        
        [self hideLoading];
        NSLog(@"错误 -- %@", error);
    }];
}

#pragma mark - 资讯栏目
- (void)requestListWithCategoryName:(NSString *)categortName
                  dynamicCategoryId:(NSInteger)dynamicCategoryId
                           pageSize:(NSNumber *)pageSize
                              index:(int)index
                              counts:(int)counts{

    
    NSDictionary *param = @{@"pageNumber":@1,
              @"pageSize":pageSize,
              @"params":@{
                      @"dynamicCategoryId": [NSNumber numberWithInteger:dynamicCategoryId]
                      }
              };
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/dynamic/list.do" params:param success:^(id JSON) {
        
        //        NSLog(@"\n参>>>>>>>%@\nmsg>>>>>>>%@\n完整数据>>>>>>>%@",param,JSON[@"message"],JSON);
        NSArray *arr = JSON[@"data"];
        
        if (![arr isEqual:[NSNull null]]) {
            
            NSArray *modelList = [CategoryContentListModel objectArrayWithKeyValuesArray:arr];
            
            // 建立数据结构
            NSDictionary *dic = @{
                                  @"categoryName":categortName,
                                  @"dynamicCategoryId":[NSNumber numberWithInteger:dynamicCategoryId],
                                  @"index":[NSNumber numberWithInt:index],
                                  @"pageSize": [NSNumber numberWithInteger:[modelList count]],
                                  @"content": modelList,
                                  };
            [dataSource addObject:dic];
            
            if ([dataSource count] == counts) {
                
                // 按index排序
                NSArray *sortDesc = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]];
                NSArray *sortedArr = [dataSource sortedArrayUsingDescriptors:sortDesc];
                dataSource = [NSMutableArray arrayWithArray:sortedArr];
                
                haveContent = YES;
                
                [self conntectData];
                [self setupHeadImage];
                [self hideLoading];
//                NSLog(@"排序后数据%@",dataSource);
            }
        }
        
    } failure:^(NSError *error) {
        
        [self hideLoading];
        NSLog(@"错误 -- %@", error);
    }];
    
    param = @{@"pageNumber":@1,
              @"pageSize":@1,
              @"params":@{@"type": [NSNumber numberWithInteger:dynamicCategoryId]}
              };
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/banner/list.do" params:param success:^(id JSON) {
        
        //        NSLog(@"\nmsg>>>>>>>%@\n完整数据>>>>>>>%@",JSON[@"message"],JSON);
        
        NSArray *arr = JSON[@"data"];
        if (![arr isEqual:[NSNull null]]) {
            
            NSArray *modelList = [DynamicHeadImagesModel objectArrayWithKeyValuesArray:arr];
            // 建立数据结构
            NSDictionary *dic = @{
                                  @"categoryName":categortName,
                                  @"dynamicCategoryId":[NSNumber numberWithInteger:dynamicCategoryId],
                                  @"index":[NSNumber numberWithInt:index],
                                  @"imgURL": modelList,
                                  };
            [headImages addObject:dic];
            
            if ([headImages count] == counts) {
                
                // 按index排序
                NSArray *sortDesc = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]];
                NSArray *sortedArr = [headImages sortedArrayUsingDescriptors:sortDesc];
                headImages = [NSMutableArray arrayWithArray:sortedArr];

                haveImage = YES;
                
                [self setupHeadImage];
            }
        }
    } failure:^(NSError *error) {
        
        [self hideLoading];
        NSLog(@"错误 -- %@", error);
    }];
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
        
        [faqsView.table reloadData];
        
    } failure:^(NSError *error) {
        
        [faqsView.table.footer endRefreshing];
        NSLog(@"错误 -- %@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    haveImage = NO;
    haveContent = NO;
    FAQsPageSize = 10;
    
    // 请求数据
    [self requestDynadynamicCategorymicCategory];
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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:avatarButton];
    
    // 中间选择
    UIView *titleView = [[UIView alloc] init];
    titleView.frame = CGRectMake(0, 0, 160, 30);
    [Tools_F setViewlayer:titleView cornerRadius:15 borderWidth:1 borderColor:[UIColor whiteColor]];
    
    UIButton *consult = [UIButton buttonWithType:UIButtonTypeCustom];
    consult.frame = CGRectMake(0, 0, 80, 30);
    consult.clipsToBounds = YES;
    consult.tag = 100;
    [Tools_F commonWithButton:consult font:biggestFont
                        title:@"资讯" selectedTitle:nil
                   titleColor:[UIColor whiteColor]
           selectedtitleColor:deepOrangeColor
                backgroundImg:[Tools_F imageWithColor:deepOrangeColor size:CGSizeMake(80, 30)]
        selectedBackgroundImg:[Tools_F imageWithColor:[UIColor whiteColor] size:CGSizeMake(80, 30)]
                       target:self
                       action:@selector(consult:)];
    [titleView addSubview:consult];
    
    UIButton *FAQs = [UIButton buttonWithType:UIButtonTypeCustom];
    FAQs.frame = CGRectMake(CGRectGetMaxX(consult.frame), 0, 80, 30);
    FAQs.clipsToBounds = YES;
    FAQs.tag = 101;
    [Tools_F commonWithButton:FAQs font:biggestFont
                        title:@"问答"
                selectedTitle:nil
                   titleColor:[UIColor whiteColor]
           selectedtitleColor:deepOrangeColor
                backgroundImg:[Tools_F imageWithColor:deepOrangeColor size:CGSizeMake(80, 30)]
        selectedBackgroundImg:[Tools_F imageWithColor:[UIColor whiteColor] size:CGSizeMake(80, 30)]
                       target:self
                       action:@selector(frequentlyAskedQuestions:)];
    [titleView addSubview:FAQs];
    
    consult.selected = YES;
    self.navigationItem.titleView = titleView;
    
    // 提问
    UIButton *askQuestion = [UIButton buttonWithType:UIButtonTypeCustom];
    askQuestion.frame = CGRectMake(0, 0, 40, 30);
    askQuestion.titleLabel.font = biggestFont;
    [askQuestion setTitle:@"提问" forState:UIControlStateNormal];
    [askQuestion addTarget:self action:@selector(askQuestions:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:askQuestion];
    
    self.navigationItem.leftBarButtonItem.customView.hidden = YES;
    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
}

#pragma mark - 设置内容
- (void)setupUI{

    /*-                    标题底部ScrollView初始化                    -*/
    titleScrollView = [[UIScrollView alloc] init];
    titleScrollView.backgroundColor = [UIColor whiteColor];
    titleScrollView.delegate = self;
    titleScrollView.showsHorizontalScrollIndicator = NO;
    titleScrollView.showsVerticalScrollIndicator = NO;
    titleScrollView.alwaysBounceHorizontal = YES;
    titleScrollView.alwaysBounceVertical = NO;
    titleScrollView.bounces = NO;
    
    [self.view addSubview:titleScrollView];
    [titleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 44));
    }];
    
    // 底部view， 用于计算scrollview高度
    contentView_title = [[UIView alloc] init];
    [titleScrollView addSubview:contentView_title];
    
    [contentView_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(titleScrollView);
        make.height.equalTo(titleScrollView.mas_height);
    }];

    /*-                    table底部ScrollView初始化                    -*/
    tableScrollView = [[UIScrollView alloc] init];
    tableScrollView.backgroundColor = [UIColor whiteColor];
    tableScrollView.delegate = self;
    tableScrollView.showsHorizontalScrollIndicator = NO;
    tableScrollView.showsVerticalScrollIndicator = NO;
    tableScrollView.bounces = NO;
    tableScrollView.pagingEnabled = YES;            // 整页滑动
    
    [self.view addSubview:tableScrollView];
    [tableScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleScrollView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.width.mas_equalTo(viewWidth);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-48);
    }];
    
    // 底部view， 用于计算scrollview高度
    contentView_table = [[UIView alloc] init];
    
    [tableScrollView addSubview:contentView_table];
    [contentView_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tableScrollView);
        make.height.equalTo(tableScrollView.mas_height);
    }];
    
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
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-48);
    }];
    
    faqsView.hidden = YES;
}

#pragma mark - 连接数据
- (void)conntectData{
    
    UIView *lastTitle;
    UIView *lastTable;
    // 标题
    for (int i=0; i<[dataSource count]; i++) {
        
        NSDictionary *dataDic = dataSource[i];
        
        // 标题
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 1000+i;
        [Tools_F commonWithButton:btn
                             font:largeFont
                            title:dataDic[@"categoryName"]
                    selectedTitle:nil
                       titleColor:[UIColor blackColor]
               selectedtitleColor:deepOrangeColor
                    backgroundImg:nil
            selectedBackgroundImg:nil
                           target:self
                           action:@selector(titleClick:)];
        
        [contentView_title addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(contentView_title.mas_top);
            make.left.equalTo(lastTitle?lastTitle.mas_right:contentView_title.mas_left);
            make.size.mas_equalTo(CGSizeMake(100, 44));
            make.centerY.equalTo(contentView_title);
        }];
        
        lastTitle = btn;
        
        // table
        UITableView *table = [[UITableView alloc] init];
        table.tag = 2000+i;
        table.delegate = self;
        table.dataSource = self;
        [table addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData:)];
        
        [contentView_table addSubview:table];
        [table mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView_table.mas_top);
            make.left.equalTo(lastTable?lastTable.mas_right:contentView_table.mas_left);
            make.width.mas_equalTo(viewWidth);
            make.bottom.equalTo(contentView_table.mas_bottom);
        }];
        
        lastTable = table;
    }
    
    // 标题底部红线
    redLine = [[UIView alloc] init];
    redLine.backgroundColor = deepOrangeColor;
    [contentView_title addSubview:redLine];
    
    // 自动scrollview高度
    [contentView_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastTitle.mas_right);
        redLine.frame = CGRectMake(0, 42, 100, 2);
    }];
    
    // 自动scrollview高度
    [contentView_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastTable.mas_right);
    }];
}

#pragma mark - 加载headImage
- (void)setupHeadImage{
    
    if (haveContent && haveImage) {
        for (int i = 2000; i < [dataSource count]+2000; i++) {              // 遍历table 刷新
            
            NSDictionary *imgDic = headImages[i-2000];
            
            UITableView *tempTable = (UITableView *)[tableScrollView viewWithTag:i];
            
            UIImageView *headImage = [[UIImageView alloc] init];
            headImage.frame = CGRectMake(0, 0, viewWidth, 110);
            headImage.clipsToBounds = YES;
            headImage.contentMode = UIViewContentModeScaleAspectFill;
            DynamicHeadImagesModel *model;
            if ([imgDic[@"imgURL"] count]>0) {
                
                model = imgDic[@"imgURL"][0];
            }
            [headImage sd_setImageWithURL:model.bannerImage placeholderImage:[UIImage imageNamed:@"loading_m"]];
            tempTable.tableHeaderView = headImage;
            
            [tempTable reloadData];
        }
    }
}

#pragma mark - 加载更多咨询
- (void)loadMoreData:(MJRefreshFooter *)sender{
    
    UITableView *currentTable = (UITableView *)sender.superview;
    
    NSInteger currentIndex = (NSInteger)sender.superview.tag-2000;
    NSDictionary *dataDict = dataSource[currentIndex];
    NSNumber *newPageSize = [NSNumber numberWithInteger:[dataDict[@"pageSize"] integerValue]+10];
    NSString *currentCategoryName = dataDict[@"categoryName"];
    
    NSDictionary *param = @{@"pageNumber":@1,
                            @"pageSize":newPageSize,
                            @"params":@{
                                    @"dynamicCategoryId": [NSNumber numberWithInteger:[dataDict[@"dynamicCategoryId"] integerValue]]
                                    }
                            };
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/dynamic/list.do" params:param success:^(id JSON) {
        
//        NSLog(@"\n参>>>>>>>%@\nmsg>>>>>>>%@\n完整数据>>>>>>>%@",param,JSON[@"message"],JSON);
        NSArray *arr = JSON[@"data"];
        
        // 停止刷新
        [currentTable.footer endRefreshing];
        
        if (![arr isEqual:[NSNull null]]) {
            
            NSArray *modelList = [CategoryContentListModel objectArrayWithKeyValuesArray:arr];
            
            // 建立数据结构
            NSDictionary *dic = @{
                                  @"categoryName":currentCategoryName,
                                  @"index":@(currentIndex),
                                  @"pageSize": [NSNumber numberWithInt:[modelList count]],
                                  @"content": modelList,
                                  };
            
            
            [dataSource replaceObjectAtIndex:currentIndex withObject:dic];
            [currentTable reloadData];
            
            // 比较结果，获取数小于请求数则显示无更多数据字样
            if ([modelList count] < [dataDict[@"pageSize"] integerValue]+10) {
                
                [currentTable.footer noticeNoMoreData];
            }
        }
    } failure:^(NSError *error) {
        
        [currentTable.footer noticeNoMoreData];
        NSLog(@"错误 -- %@", error);
    }];
}

#pragma mark - 加载更多问题
- (void)loadMoreQuestion:(MJRefreshFooter *)sender{
    
    FAQsPageSize+=10;
    [self requestQuestionList];
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == faqsView.table) {
        
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
    else {
        
        return 90;
    }
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == faqsView.table) {
        
        return 1;
    }
    else {
        NSInteger index = (NSInteger)tableView.tag -2000;
        NSDictionary *dataDic = dataSource[index];
        return [dataDic[@"pageSize"] integerValue];
    }
}

#pragma mark - 设置Sections数 (tableView)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView == faqsView.table) {
        
        return [questions count];
    }
    else {
        
        return 1;
    }
}

#pragma mark - 设置section 头高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}

#pragma mark - 设置section 脚高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (tableView == faqsView.table) {
        
        return 10;
    }
    else {
        
        return 0.1;
    }
}

#pragma mark - 设置cell (tableView)
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == faqsView.table) {
        
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
    else {
        
        //重用标识符
        static NSString *identifier = @"DynamicListCell";
        //重用机制
        DynamicListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
        
        if (cell == nil) {
            //当不存在的时候用重用标识符生成
            cell = [[DynamicListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
        }
        
        NSInteger index = (NSInteger)tableView.tag -2000;
        NSDictionary *dataDic = dataSource[index];
        CategoryContentListModel *model = dataDic[@"content"][indexPath.row];
        [cell.listImage sd_setImageWithURL:model.icon placeholderImage:[UIImage imageNamed:@"loading_l"]];
        cell.listTitle.text = model.title;
        cell.listSummary.text = model.summary;
        
        return cell;
    }
}

#pragma mark - 点击cell (tableView)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == faqsView.table) {
        
        QuestionListModel *model = questions[indexPath.section];

        MyQuestionsViewController * myQVc = [[MyQuestionsViewController alloc] init];
        myQVc.questionsId = model.questionsId;
        
        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
        [self.navigationController pushViewController:myQVc animated:YES];
    }
    else {
        
        NSInteger index = (NSInteger)tableView.tag -2000;
        NSDictionary *dataDic = dataSource[index];
        CategoryContentListModel *model = dataDic[@"content"][indexPath.row];
        NSLog(@"%@",model.icon);
        DDetailViewController *ddVC = [[DDetailViewController alloc] init];
        ddVC.dynamicId = model.dynamicId;
        ddVC.model = model;
        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
        [self.navigationController pushViewController:ddVC animated:YES];
    }
}

#pragma mark - 标题点击
- (void)titleClick:(UIButton *)btn{
    
    NSInteger currentIndex = (NSInteger)btn.tag-1000;
    NSInteger categoryCount = [dataSource count];
    
    // 全部反选
    for (NSInteger i=1000; i<categoryCount+1000; i++) {
        UIButton *traverseBtn = (UIButton *)[btn.superview viewWithTag:i];
        traverseBtn.selected = NO;
    }
    // 选中当前
    btn.selected = YES;
    // 红块相应移动
    [UIView animateWithDuration:0.2 animations:^{
        redLine.frame = CGRectMake(btn.frame.origin.x, btn.frame.size.height-2, 100, 2);
    }];
    
    // 标题相应移动
    if (currentIndex == 0) {
        
        [titleScrollView setContentOffset:CGPointMake(currentIndex*100, 0) animated:YES];
    }
    else if (currentIndex==categoryCount-2){
        
        [titleScrollView setContentOffset:CGPointMake((currentIndex+2)*100-viewWidth, 0) animated:YES];
    }
    else if (currentIndex==categoryCount-1){
        
        [titleScrollView setContentOffset:CGPointMake((currentIndex+1)*100-viewWidth, 0) animated:YES];
    }
    else {
        
        [titleScrollView setContentOffset:CGPointMake((currentIndex-1)*100, 0) animated:YES];
    }
    
    // tableview相应移动
    [tableScrollView setContentOffset:CGPointMake((currentIndex)*viewWidth, 0) animated:YES];
}

#pragma mark - scrollView 代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == tableScrollView) {
        
        CGPoint point = scrollView.contentOffset; //记录滑动
        NSInteger countTag = point.x/viewWidth+1000;         // 计算按钮tag值
        UIButton *clickBtn = (UIButton *) [contentView_title viewWithTag:countTag];
        [self titleClick:clickBtn];
    }
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

#pragma mark - 资讯
- (void)consult:(UIButton *)btn{
    
    UIButton *otherBtn = (UIButton *)[btn.superview viewWithTag:101];
    otherBtn.selected = NO;
    btn.selected = YES;
    
    faqsView.hidden = YES;
    titleScrollView.hidden = NO;
    tableScrollView.hidden = NO;
    self.navigationItem.leftBarButtonItem.customView.hidden = YES;
    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
}

#pragma mark - 问答
- (void)frequentlyAskedQuestions:(UIButton *)btn{
    
    UIButton *otherBtn = (UIButton *)[btn.superview viewWithTag:100];
    otherBtn.selected = NO;
    btn.selected = YES;
    
    faqsView.hidden = NO;
    titleScrollView.hidden = YES;
    tableScrollView.hidden = YES;
    self.navigationItem.leftBarButtonItem.customView.hidden = NO;
    self.navigationItem.rightBarButtonItem.customView.hidden = NO;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(titleScrollView == scrollView){
        //禁止标题导航上下滑动
        [scrollView setContentOffset: CGPointMake(scrollView.contentOffset.x, 0)];
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{

    if (tabBarController.selectedIndex == 2) {
        
        if ([dataSource count] == 0 || [headImages count] == 0 || [questions count] == 0) {
            
            for (UIView *all in self.view.subviews) {
                [all removeFromSuperview];
            }
            
            haveImage = NO;
            haveContent = NO;
            FAQsPageSize = 10;
            
            // 请求数据
            [self requestDynadynamicCategorymicCategory];
            [self requestHotTag];
            [self requestQuestionList];
            // 导航条
            [self setupNav];
            [self setupUI];
        }
    }
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
//