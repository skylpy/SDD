//
//  EvaluationViewController.m
//  商多多
//
//  Created by hua on 15/4/9.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "EvaluationViewController.h"
#import "EvaluationModel.h"
#import "ReviewView.h"
#import "EvalutaionTableViewCell.h"

#import "ReviewViewController.h"
#import "CWStarRateView.h"
#import "LPlaceholderTextView.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"

@interface EvaluationViewController ()<CWStarRateViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    /* 模型 */
    
    EvaluationModel *model;
    
    /* ui */
    
    // 星星
    CWStarRateView *rateView;
    // 平均分
    UILabel *averageScore;
    // 详细得分
    UILabel *detailScore;
    
    UITableView *table;
    
    NSInteger pages;
}

@property (retain,nonatomic)NSMutableArray * listArr;

@end

@implementation EvaluationViewController


-(NSMutableArray *)listArr{

    if (!_listArr) {
        _listArr = [[NSMutableArray alloc] init];
    }
    return _listArr;
}

-(void)requestListData{

    NSDictionary * dict = @{@"pageNumber":@1,@"pageSize":@(pages),@"params":@{@"type":@1,@"houseId":_houseID}};

    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/houseComment/commentList.do" params:dict success:^(id JSON) {
        
        NSLog(@"%@",JSON);
        
        if (![JSON[@"data"] isEqual:[NSNull null]]) {
            
            [self.listArr removeAllObjects];
            [table.footer endRefreshing];
            for (NSDictionary * dic in JSON[@"data"]) {
                
                EvaluationModel * emodel = [[EvaluationModel alloc] init];
                //[emodel setValuesForKeysWithDictionary:dic];
                emodel.addTime = dic[@"addTime"];
                emodel.areaScore = dic[@"areaScore"];
                emodel.avgScore = dic[@"avgScore"];
                emodel.commentId = dic[@"commentId"];
                emodel.competeScore = dic[@"competeScore"];
                emodel.hd_description = dic[@"description"];
                emodel.houseId = dic[@"houseId"];
                emodel.icon = dic[@"icon"];
                emodel.isSystemUser = dic[@"isSystemUser"];
                emodel.isTop = dic[@"isTop"];
                emodel.likeTotal = dic[@"likeTotal"];
                emodel.milieuScore = dic[@"milieuScore"];
                emodel.policyScore = dic[@"policyScore"];
                emodel.priceScore = dic[@"priceScore"];
                emodel.realName = dic[@"realName"];
                emodel.replyTotal = dic[@"replyTotal"];
                emodel.supportingScore = dic[@"supportingScore"];
                emodel.trafficScore = dic[@"trafficScore"];
                emodel.treadTotal = dic[@"treadTotal"];
                emodel.userId = dic[@"userId"];
                
                [self.listArr addObject:emodel];
            }
            
            // 判断数据个数与请求个数
            if ([_listArr count]<pages) {
                
                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                [table.footer noticeNoMoreData];
            }
            
        }
        [self hideLoading];
        [table reloadData];
        
    } failure:^(NSError *error) {
        [table.footer endRefreshing];
        [self hideLoading];
    }];
}

#pragma mark - 请求数据
- (void)requsetData{
    
    // 请求参数
    NSDictionary *dic = _houseID?@{@"houseId":_houseID}:nil;
    NSString *urlString = [SDD_MainURL stringByAppendingString:@"/houseComment/comments.do"];              // 拼接主路径和请求内容成完整url
    
    [self.httpManager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = responseObject;
        //NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
        
        if (![dict[@"data"] isEqual:[NSNull null]]) {
            
            if ([dict[@"data"][@"total"] integerValue] == 0) {
                [self showNoDataTipsWithText:@"暂无评论~马上点评"
                                 buttonTitle:@"马上点评"
                                   buttonTag:100
                                      target:self
                                      action:@selector(evaluationClick:)];
            }
            else {
                
                [self hideNoDataTips];
                model = [[EvaluationModel alloc] init];
                model.e_avgScore = dict[@"data"][@"avgScore"];
                model.e_priceScore = dict[@"data"][@"priceScore"];
                model.e_areaScore = dict[@"data"][@"areaScore"];
                model.e_supportingScore = dict[@"data"][@"supportingScore"];
                model.e_trafficScore = dict[@"data"][@"trafficScore"];
                model.e_policyscore = dict[@"data"][@"policyScore"];
                model.e_competescore = dict[@"data"][@"competeScore"];
                model.e_commentList = dict[@"data"][@"commentList"];
                model.e_total = dict[@"data"][@"total"];
                model.e_topTotal = dict[@"data"][@"topTotal"];
            }
            
            [self connect];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    pages = 10;
    // 请求数据
    [self requsetData];
    [self requestListData];
    // 导航条
    [self setupNav];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置导航条
- (void)setupNav{
    
    SDDButton *button = [[SDDButton alloc]init];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"在线点评";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

#pragma mark - 设置内容
- (void)setupUI{
    
    // table
    table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    table.backgroundColor = bgColor;
    table.delegate = self;
    table.dataSource = self;
    
    [self.view addSubview:table];
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [table addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    // head
    UIView *headView = [[UIView alloc] init];
    headView.frame = CGRectMake(0, 0, viewWidth, 80);
    headView.backgroundColor = [UIColor whiteColor];
    
    // 分数条
    rateView = [[CWStarRateView alloc]initWithFrame:CGRectMake(25, 15, viewWidth*0.65, 25) numberOfStars:5];
    rateView.userInteractionEnabled = NO;
    rateView.scorePercent = 0;
    rateView.hasAnimation = YES;
    [headView addSubview:rateView];
    
    // 平均分
    averageScore = [[UILabel alloc] init];
    averageScore.frame = CGRectMake(CGRectGetMaxX(rateView.frame)+25, 15, viewWidth*0.35-60, 25);
    averageScore.textAlignment = NSTextAlignmentCenter;
    averageScore.font = biggestFont;
    averageScore.textColor = lorangeColor;
    [headView addSubview:averageScore];
    
    detailScore = [[UILabel alloc] init];
    detailScore.frame = CGRectMake(10, CGRectGetMaxY(averageScore.frame)+15, viewWidth-20, 20);
    detailScore.font = littleFont;
    detailScore.textColor = lblueColor;
    detailScore.text = @"价格0.0分 低端0.0分 配套0.0分 交通0.0分 政策0.0分 竞争0.0分";
    [headView addSubview:detailScore];
    
    table.tableHeaderView = headView;
    
    // 马上点评
    ConfirmButton *applyBtn = [[ConfirmButton alloc] initWithFrame:CGRectMake(20, viewHeight-119, viewWidth - 40, 45)
                                                             title:@"马上点评"
                                                            target:self
                                                            action:@selector(evaluationClick:)];
    applyBtn.enabled = YES;
    [self.view addSubview:applyBtn];
}
#pragma mark - 上拉加载
- (void)loadMoreData{
    
    pages+=10;
    [self showLoading:2];
    [self requestListData];
    NSLog(@"上拉加载%d个",pages);
}

#pragma mark - 连接数据
- (void)connect{
    
    if ([model.e_total intValue] != 0) {
        
        // 平均分
        averageScore.text = [NSString stringWithFormat:@"%.1f",[model.e_avgScore floatValue]];
        rateView.scorePercent = [model.e_avgScore floatValue]/5;
        detailScore.text = [NSString stringWithFormat:@"价格%.1f分 地段%.1f分 配套%.1f分 交通%.1f分 政策%.1f分 竞争%.1f分",
                                              [model.e_priceScore floatValue],
                                              [model.e_areaScore floatValue],
                                              [model.e_supportingScore floatValue],
                                              [model.e_trafficScore floatValue],
                                              [model.e_policyscore floatValue],
                                              [model.e_competescore floatValue]];
        
        [table reloadData];
    }
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EvaluationModel * emodel = _listArr[indexPath.row];
    NSString *contentText = emodel.hd_description;//model.e_commentList[indexPath.row][@"description"];
    CGSize contentSize = [Tools_F countingSize:contentText fontSize:13*1.1 width:viewWidth-40];
    return contentSize.height+75;
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return [model.e_commentList count];
    return _listArr.count;//
}

#pragma mark - 设置section 头高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

#pragma mark - 设置section 脚高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

#pragma mark - 设置cell (tableView)
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //重用标识符
    static NSString *identifier = @"evaluation";
    //重用机制
    EvalutaionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
    
    if (cell == nil) {
        //当不存在的时候用重用标识符生成
        cell = [[EvalutaionTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
        cell.userType = 1;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
    }
    
    EvaluationModel * Emodel = _listArr[indexPath.row];
    
    [cell.avatar sd_setImageWithURL:[NSURL URLWithString:Emodel.icon] placeholderImage:[UIImage imageNamed:@""]];
    cell.nickname.text = Emodel.realName;
    cell.starRate.scorePercent = [Emodel.avgScore floatValue]/5;
    NSString *contentText = Emodel.hd_description;
    CGSize contentSize = [Tools_F countingSize:contentText fontSize:13 width:viewWidth-40];
    cell.comment.frame = CGRectMake(8, CGRectGetMaxY(cell.avatar.frame)+8, viewWidth-16, contentSize.height);
    cell.comment.text = contentText;
    
    cell.commentTime.frame = CGRectMake(8, CGRectGetMaxY(cell.comment.frame)+5, viewWidth-16, 11);
    cell.commentTime.text = [Tools_F timeTransform:[Emodel.addTime intValue] time:seconds];
    
    // 头像
//    [cell.avatar sd_setImageWithURL:[NSURL URLWithString:[model.e_commentList[indexPath.row][@"icon"] isEqual:[NSNull null]]?
//                                     @"":model.e_commentList[indexPath.row][@"icon"]]];
//    cell.nickname.text = [model.e_commentList[indexPath.row][@"realName"] isEqual:[NSNull null]]?
//    @"":model.e_commentList[indexPath.row][@"realName"];
//    cell.starRate.scorePercent = [model.e_commentList[indexPath.row][@"avgScore"] floatValue]/5;
//
//    NSString *contentText = model.e_commentList[indexPath.row][@"description"];
//    CGSize contentSize = [Tools_F countingSize:contentText fontSize:13 width:viewWidth-40];
//    cell.comment.frame = CGRectMake(8, CGRectGetMaxY(cell.avatar.frame)+8, viewWidth-16, contentSize.height);
//    cell.comment.text = contentText;
//    
//    cell.commentTime.frame = CGRectMake(8, CGRectGetMaxY(cell.comment.frame)+5, viewWidth-16, 11);
//    cell.commentTime.text = [Tools_F timeTransform:[model.e_commentList[indexPath.row][@"addTime"] intValue] time:seconds];
    
    return cell;
}

#pragma mark - 点击cell (tableView)
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

#pragma mark - 马上点评
- (void)evaluationClick:(UIButton *)btn{
    
    NSLog(@"马上点评");
    
    ReviewViewController *reviewVC = [[ReviewViewController alloc] init];
    reviewVC.houseID = _houseID;
    [self.navigationController pushViewController:reviewVC animated:YES];
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
