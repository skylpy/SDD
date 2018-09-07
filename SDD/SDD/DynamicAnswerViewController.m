//
//  DynamicAnswerViewController.m
//  SDD
//  我的问答页面
//  Created by mac on 15/7/20.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "DynamicAnswerViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UserInfo.h"
#import "Httprequest.h"
#import "LPYModelTool.h"
#import "DynamicAnswerModel.h"
#import "ProblemCell.h"
#import "AnswerCell.h"
#import "QuestionAndAnswerTableViewCell.h"
#import "MyQuestionsViewController.h"
#import "NewQuestionViewController.h"



@interface DynamicAnswerViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    //SDDButton *SDDbutton;
    UIImageView *  ButImageView;
    UILabel * numLable;
    
    UIView * NoProblemView;
    UIView * NoAnswerView;
    
    UIImageView * logoImageViewPro;
    UILabel * promptLabelPro;
    UIButton * AskQuestionsBtnPro;
    
    int statePage;
    
    NSUInteger userId;
}
@property (retain,nonatomic) UITableView * ProblemTableView;
@property (retain,nonatomic) NSMutableArray * ProblemArray;


@property (retain,nonatomic) UITableView * AnswerTableView;
@property (retain,nonatomic) NSMutableArray * AnswerArray;


@property (retain,nonatomic) UITableView * WaitAnswerTableView;
@property (retain,nonatomic) NSMutableArray * WaitAnswerArray;

@end

@implementation DynamicAnswerViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self createDownLoad];
    [_ProblemTableView reloadData];
    
    NSLog(@"%d",statePage);
    
    if (statePage == 1) {
        _ProblemTableView.hidden = NO;
    }
    
    if (statePage == 2) {
        _AnswerTableView.hidden = NO;
        NoProblemView.hidden = YES;
    }
    
    if (statePage == 3) {
        _WaitAnswerTableView.hidden = NO;
        NoProblemView.hidden = YES;
        NoAnswerView.hidden = YES;
        
    }

   
    
    for (int i = 0; i < 3; i ++) {
        
        UIImageView *tempImageView = (UIImageView *)[self.view viewWithTag:100+i];
        UILabel * numlbel = (UILabel *)[tempImageView viewWithTag:200+i];
        UILabel * titlbel = (UILabel *)[tempImageView viewWithTag:300+i];
        NSLog(@"%@",numlbel);
        [numlbel setTextColor:[UIColor whiteColor]];
        [titlbel setTextColor:[UIColor whiteColor]];
        
        if (i==statePage-1) {
            [numlbel setTextColor:tagsColor];
            [titlbel setTextColor:tagsColor];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createView];
    
    //[self createDownLoad];
    
    statePage = 1;
    userId = 0;
    
    
    [self createAnswerDownLoad];//回答数据下载
    
    [self createWaitAnswerDownLoad];//等我答数据下载
    
    [self createAnswerTableView];//回答tableView
    [self createNoAnswerView];//没有回答的时候显示的视图
    
    [self createWaitAnswerTableView];//等我答tableView
    
    [self createTableView];//第一个问题tableView
    [self createNoProblem];//没有问题时显示的视图
    
    [self HotWheelsView];//菊花
}


#pragma mark -- 菊花（风火轮）显现出来
-(void)HotWheelsView
{
    UIActivityIndicatorView * activ = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    //    activ.backgroundColor = [UIColor redColor];
    activ.frame = CGRectMake(self.view.bounds.size.width/2-50, self.view.bounds.size.height/2-50, 100, 100);
    activ.tag = 1001;
    //    开始动画
    [activ startAnimating];
    //    停止动画
    //    [activ stopAnimating];
    
    NSLog(@"%f %f",activ.bounds.size.width,activ.bounds.size.height);;
    [self.view addSubview:activ];
    
    
    UIView * view = [[UIView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.3;
    view.tag = 1002;
    [self.view addSubview:view];
    
    //[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerAction) userInfo:nil repeats:NO];
}


//-(void)timerAction{
//    UIActivityIndicatorView * active = (UIActivityIndicatorView *)[self.view viewWithTag:1001];
//    [active stopAnimating];
//    UIView * view = [self.view viewWithTag:1002];
//    [view removeFromSuperview];
//    
//}

#pragma mark -- 创建问题的TableView
-(void)createTableView
{
    _ProblemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 370/2, viewWidth, viewHeight-372/2-60) style:UITableViewStyleGrouped];
    _ProblemTableView.delegate = self;
    _ProblemTableView.dataSource = self;
    [self.view addSubview:_ProblemTableView];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _AnswerTableView) {
        DynamicAnswerModel * model = _AnswerArray[indexPath.section];
        NSString *comment = model.content;
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:16]};
        CGSize size = [comment boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        
        NSDictionary * dict = model.myLastOrBaseAnswer;
        NSString * answerStr = dict[@"answerContent"];
        
        CGSize size1 = [answerStr boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        
        return size.height+55+size1.height;
        //return 130;
    }
    if (tableView == _WaitAnswerTableView) {
        DynamicAnswerModel * model = _WaitAnswerArray[indexPath.section];
        NSString *comment = model.content;
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:16]};
        CGSize size = [comment boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        
        return size.height+90;
    }
    
    DynamicAnswerModel * model = _ProblemArray[indexPath.section];
    NSString *comment = model.content;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:16]};
    CGSize size = [comment boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return size.height + 55;
}

#pragma mark -- 点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_ProblemTableView == tableView) {
        DynamicAnswerModel * model = _ProblemArray[indexPath.section];
        MyQuestionsViewController * myQVc = [[MyQuestionsViewController alloc] init];
        myQVc.questionsId = [[NSString stringWithFormat:@"%@",model.questionsId] intValue];
        myQVc.userId = 0;
        [self.navigationController pushViewController:myQVc animated:YES];
    }
    if (_AnswerTableView == tableView) {
        DynamicAnswerModel * model = _AnswerArray[indexPath.section];
        MyQuestionsViewController * myQVc = [[MyQuestionsViewController alloc] init];
        myQVc.questionsId = [[NSString stringWithFormat:@"%@",model.questionsId] intValue];
        myQVc.userId = 1;
        [self.navigationController pushViewController:myQVc animated:YES];
    }
    if (_WaitAnswerTableView == tableView) {
        DynamicAnswerModel * model = _WaitAnswerArray[indexPath.section];
        MyQuestionsViewController * myQVc = [[MyQuestionsViewController alloc] init];
        myQVc.questionsId = [[NSString stringWithFormat:@"%@",model.questionsId] intValue];
        myQVc.userId = 1;
        [self.navigationController pushViewController:myQVc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _ProblemTableView) {
        if (section == 0) {
            return 1;
        }
    }
    if (tableView == _AnswerTableView) {
        if (section == 0) {
            return 1;
        }
    }
    if (tableView == _WaitAnswerTableView) {
        if (section == 0) {
            return 1;
        }
    }
    return 10;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _ProblemTableView) {
        return _ProblemArray.count;
    }
    if (tableView == _AnswerTableView) {
        return _AnswerArray.count;
    }
    if (tableView == _WaitAnswerTableView) {
        return _WaitAnswerArray.count;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _ProblemTableView) {
        static NSString * cellId = @"cellID";
        ProblemCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[ProblemCell alloc] init];
        }
        cell.selectionStyle = UITableViewCellAccessoryNone;
        DynamicAnswerModel * model = _ProblemArray[indexPath.section];
        cell.contentLabel.text = model.content;
        
        //将时间戳转为时间
        double lastactivityInterval = [model.addTime doubleValue];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:lastactivityInterval];
        NSString* dateString = [formatter stringFromDate:date];
        cell.timeLabel.text = dateString;
        
        cell.numLabel.text = [NSString stringWithFormat:@"%@",model.totalAnswerQty];
        
        int newAnswerQty = [[NSString stringWithFormat:@"%@",model.AnswerQty] intValue];
        if (newAnswerQty != 0) {
            cell.redLabel.text = [NSString stringWithFormat:@"%d",newAnswerQty];
        }
        else
        {
            [cell.redLabel removeFromSuperview];
        }
        return cell;
    }
    if (tableView == _AnswerTableView) {
        AnswerCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
        if (cell == nil) {
            cell = [[AnswerCell alloc] init];
        }
        cell.selectionStyle = UITableViewCellAccessoryNone;
        DynamicAnswerModel * model = _AnswerArray[indexPath.section];
        cell.contentLabel.text = model.content;
        NSDictionary * dict = model.myLastOrBaseAnswer;
        NSString * answerStr = dict[@"answerContent"];
        cell.answerLabel.text =answerStr;
        
        //将时间戳转为时间
        double lastactivityInterval = [model.addTime doubleValue];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:lastactivityInterval];
        NSString* dateString = [formatter stringFromDate:date];
        cell.timeLabel.text = dateString;
        
        cell.numLabel.text = [NSString stringWithFormat:@"%@",model.totalAnswerQty];
        
        
        return cell;
    }
    QuestionAndAnswerTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[QuestionAndAnswerTableViewCell alloc] init];
    }
    cell.selectionStyle = UITableViewCellAccessoryNone;
    DynamicAnswerModel * model = _WaitAnswerArray[indexPath.section];
    cell.comLabel.text = model.content;
    [cell.HeadImageView setImageWithURL:[NSURL URLWithString:model.authorIcon]];
    cell.nameLabel.text = model.author;
    
    //将时间戳转为时间
    double lastactivityInterval = [model.addTime doubleValue];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:lastactivityInterval];
    NSString* dateString = [formatter stringFromDate:date];
    cell.timeLabel.text = dateString;
    
    cell.numLabel.text = [NSString stringWithFormat:@"%@",model.totalAnswerQty];
    
    return cell;
    
}

#pragma mark -- 等我答TableView
-(void)createWaitAnswerTableView
{
    _WaitAnswerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 370/2, viewHeight, viewHeight-372/2-60) style:UITableViewStyleGrouped];
    _WaitAnswerTableView.delegate = self;
    _WaitAnswerTableView.dataSource = self;
    _WaitAnswerTableView.hidden = YES;
    [self.view addSubview:_WaitAnswerTableView];
}

#pragma mark -- 等我答数据下载
-(void)createWaitAnswerDownLoad
{
    NSString * path = @"/questions/withoutCurrentUserQuestionsList.do";
    
    _WaitAnswerArray = [[NSMutableArray alloc] init];
    
    [HttpRequest postWithNewIssueURL:SDD_MainURL path:path parameter:@{@"pageNumber":@1,@"pageSize":@20} success:^(id Josn) {
        
        NSDictionary * dict = Josn;
        
        NSLog(@"%@",dict);
        
        if ([dict[@"data"] isEqual:[NSNull null]]) {
            
        }
        else
        {
            NSArray * ShopsArray = dict[@"data"];
            for (NSDictionary * dic in ShopsArray) {
                
                
                DynamicAnswerModel * model = [[DynamicAnswerModel alloc] init];
                model.AnswerQty = dic[@"newAnswerQty"];
                model.addTime = dic[@"addTime"];
                model.author = dic[@"author"];
                model.autoClosed = dic[@"autoClosed"];
                model.content = dic[@"content"];
                model.finishTime = dic[@"finishTime"];
                model.goodsAnswerContent = dic[@"goodsAnswerContent"];
                model.goodsAnswerId = dic[@"goodsAnswerId"];
                model.goodsUserId = dic[@"goodsUserId"];
                model.isDelete = dic[@"isDelete"];
                model.questionsId = dic[@"questionsId"];
                model.reportQty = dic[@"reportQty"];
                model.rewardScore = dic[@"rewardScore"];
                model.tagList = dic[@"tagList"];
                model.totalAnswerQty = dic[@"totalAnswerQty"];
                model.userId = dic[@"userId"];
                model.myLastOrBaseAnswer = dic[@"myLastOrBaseAnswer"];
                model.authorIcon = dic[@"authorIcon"];
                [_WaitAnswerArray addObject:model];
                
                //NSLog(@"%@",model.myLastOrBaseAnswer);
            }
        }
        
        UIActivityIndicatorView * active = (UIActivityIndicatorView *)[self.view viewWithTag:1001];
        [active stopAnimating];
        UIView * view = [self.view viewWithTag:1002];
        [view removeFromSuperview];
        
        UIImageView * ImageView = (UIImageView *)[self.view viewWithTag:102];
        UILabel * numLabel1 = (UILabel *)[ImageView viewWithTag:202];
        numLabel1.text = [NSString stringWithFormat:@"%ld",_WaitAnswerArray.count];
        
        [_WaitAnswerTableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}



#pragma mark -- 问答的tableView
-(void)createAnswerTableView
{
    _AnswerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 370/2, viewWidth, viewHeight-372/2-60) style:UITableViewStyleGrouped];
    _AnswerTableView.delegate = self;
    _AnswerTableView.dataSource =self;
    _AnswerTableView.hidden = YES;
    [self.view addSubview:_AnswerTableView];
    
    _AnswerTableView.estimatedRowHeight = 44.0f;
    _AnswerTableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark -- 问答按钮数据下载
-(void)createAnswerDownLoad
{
    NSString * path = @"/questionsUser/myAnswers.do";
    
    _AnswerArray = [[NSMutableArray alloc] init];
    
    [HttpRequest postWithNewIssueURL:SDD_MainURL path:path parameter:@{@"pageNumber":@1,@"pageSize":@10} success:^(id Josn) {
        
        NSDictionary * dict = Josn;
        
        
        
        NSLog(@"%@",dict);
        if ([dict[@"data"] isEqual:[NSNull null]]) {
            
        }
        else
        {
            NSArray * ShopsArray = dict[@"data"];
            for (NSDictionary * dic in ShopsArray) {
                
                DynamicAnswerModel * model = [[DynamicAnswerModel alloc] init];
                model.AnswerQty = dic[@"newAnswerQty"];
                model.addTime = dic[@"addTime"];
                model.author = dic[@"author"];
                model.autoClosed = dic[@"autoClosed"];
                model.content = dic[@"content"];
                model.finishTime = dic[@"finishTime"];
                model.goodsAnswerContent = dic[@"goodsAnswerContent"];
                model.goodsAnswerId = dic[@"goodsAnswerId"];
                model.goodsUserId = dic[@"goodsUserId"];
                model.isDelete = dic[@"isDelete"];
                model.questionsId = dic[@"questionsId"];
                model.reportQty = dic[@"reportQty"];
                model.rewardScore = dic[@"rewardScore"];
                model.tagList = dic[@"tagList"];
                model.totalAnswerQty = dic[@"totalAnswerQty"];
                model.userId = dic[@"userId"];
                model.myLastOrBaseAnswer = dic[@"myLastOrBaseAnswer"];
                [_AnswerArray addObject:model];
                
                //NSLog(@"%@",model.myLastOrBaseAnswer);
            }
        }
        
        
        UIImageView * ImageView = (UIImageView *)[self.view viewWithTag:101];
        UILabel * numLabel1 = (UILabel *)[ImageView viewWithTag:201];
        numLabel1.text = [NSString stringWithFormat:@"%ld",_AnswerArray.count];
        
        [_AnswerTableView reloadData];
        if (_AnswerArray.count > 0) {
            
        }
        else
        {
            NoAnswerView.hidden = NO;
        }
        
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -- 问题按钮数据下载
-(void)createDownLoad
{
    NSString * path = @"/questionsUser/myQuestions.do";

    _ProblemArray = [[NSMutableArray alloc] init];
    [HttpRequest postWithNewIssueURL:SDD_MainURL path:path parameter:@{@"pageNumber":@1,@"pageSize":@10} success:^(id Josn) {
        
        NSDictionary * dict = Josn;
        
        
        

        NSLog(@"%@",dict);
        if ([dict[@"data"] isEqual:[NSNull null]]) {
            
        }
        else
        {
            NSArray * ShopsArray = dict[@"data"];
            for (NSDictionary * dic in ShopsArray) {
                DynamicAnswerModel * model = [[DynamicAnswerModel alloc] init];
                model.AnswerQty = dic[@"newAnswerQty"];
                model.addTime = dic[@"addTime"];
                model.author = dic[@"author"];
                model.autoClosed = dic[@"autoClosed"];
                model.content = dic[@"content"];
                model.finishTime = dic[@"finishTime"];
                model.goodsAnswerContent = dic[@"goodsAnswerContent"];
                model.goodsAnswerId = dic[@"goodsAnswerId"];
                model.goodsUserId = dic[@"goodsUserId"];
                model.isDelete = dic[@"isDelete"];
                model.questionsId = dic[@"questionsId"];
                model.reportQty = dic[@"reportQty"];
                model.rewardScore = dic[@"rewardScore"];
                model.tagList = dic[@"tagList"];
                model.totalAnswerQty = dic[@"totalAnswerQty"];
                model.userId = dic[@"userId"];
                [_ProblemArray addObject:model];
                userId = [[NSString stringWithFormat:@"%@",dic[@"userId"]] integerValue];
            }
        }
        
        
        UIImageView * ImageView = (UIImageView *)[self.view viewWithTag:100];
        UILabel * numLabel1 = (UILabel *)[ImageView viewWithTag:200];
        numLabel1.text = [NSString stringWithFormat:@"%ld",_ProblemArray.count];
        
        [_ProblemTableView reloadData];
        if (_ProblemArray.count > 0) {
            
        }
        else
        {
            if (statePage == 1) {
                NoProblemView.hidden = NO;
            }
            
        }
       
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark -- 没有回答数据的时候显示的视图
-(void)createNoAnswerView
{
    //没回答的视图
    NoAnswerView = [[UIView alloc] initWithFrame:CGRectMake(0, 372/2, self.view.bounds.size.width, self.view.bounds.size.height-372/2)];
    NoAnswerView.hidden = YES;
    [self.view addSubview:NoAnswerView];
    
    
    UIImageView * logoImageView = [[UIImageView alloc] init];
    logoImageView.image = [UIImage imageNamed:@"icon_nodataface"];
    [NoAnswerView addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(NoAnswerView.mas_top).with.offset(32);
        make.left.equalTo(NoAnswerView.mas_left).with.offset(viewWidth/3-15);
        make.size.mas_equalTo(CGSizeMake(138, 138));
    }];

    
    UILabel * promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64/2+138+40/2, viewWidth, 20)];
    promptLabel.text = @"暂无回答，赶快去回答吧";
    [promptLabel setTextColor:[UIColor lightGrayColor]];
    promptLabel.font = [UIFont systemFontOfSize:13];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    [NoAnswerView addSubview:promptLabel];
    
}


#pragma mark -- 没有问题数据的时候显示的视图
-(void)createNoProblem
{
    //没问题是的视图
    NoProblemView = [[UIView alloc] initWithFrame:CGRectMake(0, 372/2, self.view.bounds.size.width, self.view.bounds.size.height-372/2)];
    NoProblemView.hidden = YES;
    //NoProblemView.backgroundColor = [UIColor redColor];
    [self.view addSubview:NoProblemView];
    
    logoImageViewPro = [[UIImageView alloc] init];
    logoImageViewPro.image = [UIImage imageNamed:@"icon_nodataface"];
    [NoProblemView addSubview:logoImageViewPro];
    [logoImageViewPro mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(NoProblemView.mas_top).with.offset(32);
        make.left.equalTo(NoProblemView.mas_left).with.offset(viewWidth/3-15);
        make.size.mas_equalTo(CGSizeMake(138, 138));
    }];
    
    
    promptLabelPro = [[UILabel alloc] initWithFrame:CGRectMake(0, 64/2+138+40/2, viewWidth, 20)];
    promptLabelPro.text = @"暂无问题，赶快去提问吧~";
    [promptLabelPro setTextColor:[UIColor lightGrayColor]];
    promptLabelPro.font = [UIFont systemFontOfSize:13];
    promptLabelPro.textAlignment = NSTextAlignmentCenter;
    [NoProblemView addSubview:promptLabelPro];
    
    ConfirmButton * conBrandBtn = [[ConfirmButton alloc] initWithFrame:CGRectMake(20, 64/2+138+40/2+40, viewWidth-40, 45) title:@"马上提问" target:self action:@selector(AskQuestionsBtnProClick:)];
    conBrandBtn.enabled = YES;
    [NoProblemView addSubview:conBrandBtn];
}
-(void)AskQuestionsBtnProClick:(UIButton *)btn
{
    NewQuestionViewController *nqVC = [[NewQuestionViewController alloc] init];
    
    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
    [self.navigationController pushViewController:nqVC animated:YES];
}

-(void)createView
{
    //导航条
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"我的问答";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    

    
    //头部视图
    UIImageView * TopImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 372/2)];
    TopImageView.image = [Tools_F imageWithColor:mainTitleColor size:CGSizeMake(self.view.bounds.size.width, 372/2)];
    //TopImageView.image = [UIImage imageNamed:@"question_and_answer_frame"];
    TopImageView.userInteractionEnabled = YES;
    [self.view addSubview:TopImageView];
    
    //头像
    UIImageView * HeadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth/2-32, 40/2, 128/2, 128/2)];
    [HeadImageView setImageWithURL:[NSURL URLWithString:[UserInfo sharedInstance].userInfoDic[@"icon"]] placeholderImage:[UIImage imageNamed:@"defaultAvatar_icon_"]];
    [Tools_F setViewlayer:HeadImageView cornerRadius:128/4 borderWidth:2 borderColor:[UIColor whiteColor]];
    HeadImageView.layer.cornerRadius = 128/2/2;
    HeadImageView.clipsToBounds = YES;
    [TopImageView addSubview:HeadImageView];
    //用户名
    UILabel * nameLable = [[UILabel alloc] initWithFrame:CGRectMake(0, (40+128+16)/2, viewWidth, 20)];
    nameLable.text = [UserInfo sharedInstance].userInfoDic[@"realName"];
    nameLable.textAlignment = NSTextAlignmentCenter;
    //nameLable.backgroundColor = [UIColor yellowColor];
    [nameLable setTextColor:[UIColor whiteColor]];
    [TopImageView addSubview:nameLable];
    
    NSArray * array = @[@"问题",@"回答",@"等我答"];
    for (int i = 0;  i < array.count; i ++) {
        
        ButImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+i * (viewWidth/3), 260/2, 150/2, 100/2)];
        ButImageView.tag = 100+i;
        ButImageView.userInteractionEnabled = YES;
        //ButImageView.backgroundColor = [UIColor yellowColor];
        [self.view addSubview:ButImageView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgVClick:)];
        [ButImageView addGestureRecognizer:tap];
        
        
        numLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150/2, 100/2/2)];
        numLable.text = @"0";
        numLable.textAlignment = NSTextAlignmentCenter;
        [numLable setTextColor:[UIColor whiteColor]];
        numLable.tag = 200+i;
        [ButImageView addSubview:numLable];
        
        UILabel * titLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 100/2/2, 150/2, 100/2/2)];
        titLable.text = array[i];
        titLable.textAlignment = NSTextAlignmentCenter;
        [titLable setTextColor:[UIColor whiteColor]];
        titLable.tag = 300+i;
        [ButImageView addSubview:titLable];
        
    }
    
    
}
-(void)imgVClick:(UITapGestureRecognizer *)tap
{
    NSLog(@"tap.view.tag = %ld",tap.view.tag);
    for (int i = 0; i < 3; i ++) {
        
        UIImageView *tempImageView = (UIImageView *)[self.view viewWithTag:100+i];
        UILabel * numlbel = (UILabel *)[tempImageView viewWithTag:200+i];
        UILabel * titlbel = (UILabel *)[tempImageView viewWithTag:300+i];
        [numlbel setTextColor:[UIColor whiteColor]];
        [titlbel setTextColor:[UIColor whiteColor]];
    }
    UILabel * numlbel = (UILabel *)[tap.view viewWithTag:100+tap.view.tag];
    UILabel * titlbel = (UILabel *)[tap.view viewWithTag:200+tap.view.tag];
    
    [numlbel setTextColor:tagsColor];
    [titlbel setTextColor:tagsColor];
    
    
    if (tap.view.tag == 100) {
        statePage = 1;
        _WaitAnswerTableView.hidden = YES;
        _AnswerTableView.hidden = YES;
        
        NoAnswerView.hidden = YES;
        if (_ProblemArray.count > 0) {
            _ProblemTableView.hidden = NO;
        }
        else
        {
            NoProblemView.hidden = NO;
        }
        
    }
    if (tap.view.tag == 101) {
        statePage = 2;
        _WaitAnswerTableView.hidden = YES;
        
        _ProblemTableView.hidden = YES;
        
        NoProblemView.hidden = YES;
        
        
        if (_AnswerArray.count > 0) {
            _AnswerTableView.hidden = NO;
        }
        else
        {
            NoAnswerView.hidden = NO;
        }
        
        //[self createAnswerDownLoad];
        //[_AnswerTableView reloadData];
    }
    if (tap.view.tag == 102) {
        statePage = 3;
        _WaitAnswerTableView.hidden = NO;
        _AnswerTableView.hidden = YES;
        _ProblemTableView.hidden = YES;
        NoProblemView.hidden = YES;
        NoAnswerView.hidden = YES;
        
//        [self createWaitAnswerDownLoad];
//        [_WaitAnswerTableView reloadData];
    }
    
}
- (void)leftButtonClick
{
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
