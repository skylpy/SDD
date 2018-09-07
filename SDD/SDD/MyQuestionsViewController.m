//
//  MyQuestionsViewController.m
//  问答的详情
//
//  Created by mac on 15/7/25.
//  Copyright (c) 2015年 linpeiyu. All rights reserved.
//

#import "MyQuestionsViewController.h"
#import "QueAndAnsTableViewCell.h"
#import "Httprequest.h"
#import "LPYModelTool.h"
#import "SinglePostDetailModel.h"
#import "UIImageView+AFNetworking.h"
#import "RelateQuestionCell.h"

@interface MyQuestionsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    SDDButton *SDDbutton;
    UILabel *titleLabel;
    
    NSString * author;
    UILabel * nameLabel;
    
    UIView * topView;//头部视图
    
    int answerId;//点赞
    int type;//类型
    
    int questionsId;//问题id
    
    NSString * questionsStr;//问题内容
    
    UILabel * titLable;//问题
    
    UILabel * timeLabel;//时间
    
    UILabel * numLable;//评论数
    
    UIView * maxView;//透明view
    UIView * minView ;//弹出view
    
    int judgeNum;//判断是否采纳
}
@property (retain,nonatomic)UITableView * tableView;

@property (retain,nonatomic)NSMutableArray * dataArray;
@property (retain,nonatomic)NSMutableArray * relatedArray;

@property (retain,nonatomic)UITextField * answerTextField;

@end

@implementation MyQuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    judgeNum= 0;
    answerId = 0;
    type = 0;
    //questionsId = 0;
    questionsStr = @"";
    self.view.backgroundColor = [UIColor whiteColor];
    [self creataView];
    [self createDetailsProblemDownLoad];
    
    [self createFiled];

}


-(void)createFiled
{
    UIView * answerView = [[UIView alloc] init];
    answerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:answerView];
    
    [answerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.equalTo(@50);
    }];
    
    _answerTextField = [[UITextField alloc] init];
    _answerTextField.placeholder = @"在此输入您的回答";
    _answerTextField.delegate = self;
    _answerTextField.keyboardAppearance=UIKeyboardAppearanceDefault;
    _answerTextField.borderStyle = UITextBorderStyleRoundedRect;
    [answerView addSubview:_answerTextField];
    
    [_answerTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(answerView.mas_bottom).with.offset(-12);
        make.left.equalTo(answerView.mas_left).with.offset(10);
        make.right.equalTo(answerView.mas_right).with.offset(-80);
        //make.height.equalTo(@10);
    }];
    
#pragma mark -- 设置通知中心监控textField.text的值得变化
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:_answerTextField];
    
    UIButton * answerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    answerButton.backgroundColor = [SDDColor colorWithHexString:@"#3366FF"];
    [answerButton setTitle:@"回答" forState:UIControlStateNormal];
    answerButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [answerButton addTarget:self action:@selector(answerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    answerButton.layer.cornerRadius = 5;
    answerButton.clipsToBounds = YES;
    [answerView addSubview:answerButton];
    
    [answerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(answerView.mas_top).with.offset(8);
        make.bottom.equalTo(answerView.mas_bottom).with.offset(-12);
        make.left.equalTo(_answerTextField.mas_right).with.offset(10);
        make.right.equalTo(answerView.mas_right).with.offset(-10);
        //make.height.equalTo(@10);
    }];
    
}
#pragma mark -- UItextFild监控值得变化
-(void)textFieldChanged:(NSNotification *)notification
{
    UITextField *textfield=[notification object];
    questionsStr = textfield.text;
    NSLog(@"%@",questionsStr);
}

#pragma mark -- 回答点击事件
-(void)answerButtonClick:(UIButton *)btn
{
    [_answerTextField resignFirstResponder];
    NSLog(@"gjgj");
    questionsId = [[NSString stringWithFormat:@"%@",self.model.questionsId] intValue];
    
    [self createQuestionsAnswer];
    
}
#pragma mark --_answerTextField代理事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_answerTextField resignFirstResponder];
    return YES;
}


-(void)creataView
{
    //导航条
    SDDbutton = [[SDDButton alloc]init];
    [SDDbutton sizeToFit];
    [SDDbutton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:SDDbutton];
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.text = [NSString stringWithFormat:@"%@的问题",author];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;//largeFont  biggestFont
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
//    //导航条
//    SDDbutton = [[SDDButton alloc]init];
//    SDDbutton.frame = CGRectMake(0, 0, viewWidth*2/3, 44);
//    [SDDbutton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:SDDbutton];
    
    //分享
//    UIButton * ShareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    ShareBtn.frame = CGRectMake(0, 0, 20, 20);
//    [ShareBtn setBackgroundImage:[UIImage imageNamed:@"share_icon"] forState:UIControlStateNormal];
//    [self.view addSubview:ShareBtn];
//    
//    UIBarButtonItem * ShareBtnItem = [[UIBarButtonItem alloc] initWithCustomView:ShareBtn];
//    
//    self.navigationItem.rightBarButtonItem = ShareBtnItem;
    
    
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 100)];
    topView.backgroundColor = [UIColor whiteColor];
    
    titLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, viewWidth-20, 45)];
    titLable.numberOfLines = 2;
    titLable.font = [UIFont systemFontOfSize:15];
    [topView addSubview:titLable];
    
    
    UIImageView * coinImage = [[UIImageView alloc] init];
    coinImage.image = [UIImage imageNamed:@"label_icon.png"];
    [topView addSubview:coinImage];
    
    [coinImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titLable.mas_bottom).with.offset(10);
        make.left.equalTo(topView.mas_left).with.offset(10);
        make.width.equalTo(@15);
        make.height.equalTo(@10);
    }];
    
    UILabel * lable = [[UILabel alloc] initWithFrame:CGRectMake(35, 65, 200, 10)];
    lable.font = [UIFont systemFontOfSize:12];
    lable.tag = 100;
    [lable setTextColor:[UIColor redColor]];
    [topView addSubview:lable];
    
    
    
    UIButton * numButton = [UIButton buttonWithType:UIButtonTypeCustom];
    numButton.frame = CGRectMake(520/2, 65+3, 15, 15);
    [numButton setBackgroundImage:[UIImage imageNamed:@"answer_icon.png"] forState:UIControlStateNormal];
    [topView addSubview:numButton];
    
    numLable = [[UILabel alloc] initWithFrame:CGRectMake(520/2+20, 65, 50, 20)];
    numLable.font = [UIFont systemFontOfSize:13];
    [numLable setTextColor:[UIColor lightGrayColor]];
    [topView addSubview:numLable];
    
    
    nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:11];
    //nameLabel.text = author;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [nameLabel setTextColor:[UIColor lightGrayColor]];
    [topView addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(coinImage.mas_bottom).with.offset(5);
        make.left.equalTo(topView.mas_left).with.offset(10);
        make.height.equalTo(@15);
    }];
    
    
    UILabel * lineLabel = [[UILabel alloc] init];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:lineLabel];
    
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(coinImage.mas_bottom).with.offset(8);
        make.left.equalTo(nameLabel.mas_right).with.offset(10);
        make.width.equalTo(@1);
        make.height.equalTo(@10);
    }];
    
    timeLabel = [[UILabel alloc] init];
    timeLabel.font = [UIFont systemFontOfSize:11];
    [timeLabel setTextColor:[UIColor lightGrayColor]];
    [topView addSubview:timeLabel];
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(coinImage.mas_bottom).with.offset(8);
        make.left.equalTo(lineLabel.mas_right).with.offset(10);
        make.height.equalTo(@10);
    }];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-100) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle =UITableViewCellSelectionStyleNone;
    
    _tableView.tableHeaderView = topView;
}

//导航条返回点击事件
- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return _dataArray.count;
    }
    if (section == 1) {
        return _relatedArray.count;
    }
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 50;
    }
    return 10;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        SinglePostDetailModel * model = _relatedArray[indexPath.row];
        MyQuestionsViewController * myQVc = [[MyQuestionsViewController alloc] init];
        myQVc.questionsId = [[NSString stringWithFormat:@"%@",model.questionsId] intValue];
        [self.navigationController pushViewController:myQVc animated:YES];
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView * hView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 44)];
        hView.backgroundColor = [UIColor whiteColor];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 200, 20)];
        label.text = @"  相关提问";
        
        [hView addSubview:label];
        
        UIImageView * lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, viewWidth, 1)];
        lineImageView.image = [UIImage imageNamed:@"line"];
        
        [hView addSubview:lineImageView];
        
        return hView;
    }
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 0.1)];
    return label;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SinglePostDetailModel * model = _dataArray[indexPath.row];
        NSString *comment = model.answerContent;
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:16]};
        CGSize size = [comment boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        
        return size.height+102;
    }
    if (indexPath.section==1) {
        
        return 44;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        QueAndAnsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
        if (cell == nil) {
            cell = [[QueAndAnsTableViewCell alloc] init];
        }
        cell.selectionStyle = UITableViewCellAccessoryNone;
        SinglePostDetailModel * model = _dataArray[indexPath.row];
        [cell.HeadImageView setImageWithURL:[NSURL URLWithString:model.authorIcon]];
        cell.nameLabel.text = model.author;
        cell.comLabel.text = model.answerContent;
        
        NSString *str=[NSString stringWithFormat:@"%@",model.addTime];//时间戳
        NSTimeInterval time=[str doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
        
        cell.timeLabel.text = currentDateStr;
        
        cell.noLabel.text = [NSString stringWithFormat:@"%@",model.treadQty];
        
        cell.numLabel.text = [NSString stringWithFormat:@"%@",model.likeQty];
        
        UIButton * noPraiseButton = (UIButton *)[cell viewWithTag:1000];
        noPraiseButton.tag = indexPath.row+100;
        [noPraiseButton addTarget:self action:@selector(noPraiseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton * PraiseButton = (UIButton *)[cell viewWithTag:1001];
        PraiseButton.tag = indexPath.row+200;
        [PraiseButton addTarget:self action:@selector(PraiseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
//        UIButton * reportBtn = (UIButton *)[cell viewWithTag:1003];
//        reportBtn.tag = indexPath.row+400;
//        [reportBtn addTarget:self action:@selector(ReportBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton * AdoptBtn = (UIButton *)[cell viewWithTag:1002];
        AdoptBtn.tag = indexPath.row+300;
        [AdoptBtn addTarget:self action:@selector(AdoptBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (judgeNum == 0) {
            [cell.AdoptImageView removeFromSuperview];
        }
        else
        {
            if ([[NSString stringWithFormat:@"%@",model.isGoodsAnswer] intValue] == 0) {
                [cell.AdoptImageView removeFromSuperview];
            }
            [AdoptBtn removeFromSuperview];
        }
        if (_userId != 0)
        {
            [AdoptBtn removeFromSuperview];
        }
        
        return cell;
    }
    static NSString * cellId =@"cellID";
    RelateQuestionCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if ( cell == nil) {
        cell = [[RelateQuestionCell alloc] init];
    }
    SinglePostDetailModel * model = _relatedArray[indexPath.row];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.relateQueLabel.text = model.content;
    
    return cell;
    
}
#pragma MARK -- 举报
-(void)ReportBtnClick:(UIButton *)btn
{
    SinglePostDetailModel * model = _dataArray[btn.tag-400];
    answerId = [[NSString stringWithFormat:@"%@",model.answerId] intValue];
    
    [self ReportView];
}
#pragma mark -- 采纳
-(void)AdoptBtnClick:(UIButton *)btn
{
    SinglePostDetailModel * model = _dataArray[btn.tag-300];
    answerId = [[NSString stringWithFormat:@"%@",model.answerId] intValue];
    
    //[self AdoptView];
//    [self showDataWithText:@"每个问题只有一个最佳答案，是否采纳？" buttonTitle:@"好" buttonTag:1020 target:self action:@selector(buttonClick:)];
    
    [self showDataWithText:@"每个问题只有一个最佳答案，是否采纳？" buttonTitle:@"取消" btnTitle:@"确定" buttonTag1:1010 buttonTag2:1011 target:self action:@selector(buttonClick:) target1:self action2:@selector(buttonClick:)];
}

#pragma mark -- 点赞点击事件
-(void)PraiseButtonClick:(UIButton *)btn
{
    NSLog(@"点赞%ld",btn.tag);
    SinglePostDetailModel * model = _dataArray[btn.tag-200];
    answerId = [[NSString stringWithFormat:@"%@",model.answerId] intValue];
    NSLog(@"%d",answerId);
    type = 1;
    [self createThumbUpDownLoad];
}

#pragma mark -- 踩点击事件
-(void)noPraiseButtonClick:(UIButton *)btn
{
    NSLog(@"%ld",btn.tag);
    SinglePostDetailModel * model = _dataArray[btn.tag-100];
    answerId = [[NSString stringWithFormat:@"%@",model.answerId] intValue];
    NSLog(@"%d",answerId);
    type = 0;
    [self createThumbUpDownLoad];
}
#pragma mark -- 举报弹出视图
-(void)ReportView
{
    maxView = [[UIView alloc] initWithFrame:self.view.bounds];
    maxView.backgroundColor = [UIColor blackColor];
    maxView.alpha = 0.7;
    [self.view addSubview:maxView];
    
    minView = [[UIView alloc] init];
    minView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:minView];
    
    [minView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(130);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
        make.height.equalTo(@180);
    }];
    
    UILabel * PromptLabel = [[UILabel alloc] init];
    PromptLabel.textColor = [UIColor blackColor];
    PromptLabel.text = @"提示";
    PromptLabel.textAlignment = NSTextAlignmentCenter;
    [minView addSubview:PromptLabel];
    
    [PromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(minView.mas_top).with.offset(10);
        make.left.equalTo(minView.mas_left).with.offset(20);
        make.right.equalTo(minView.mas_right).with.offset(-20);
        //make.height.equalTo(@180);
    }];
    
    UILabel * lineLabel = [[UILabel alloc] init];
    lineLabel.backgroundColor = tagsColor;
    lineLabel.textAlignment = NSTextAlignmentCenter;
    [minView addSubview:lineLabel];
    
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(PromptLabel.mas_bottom).with.offset(10);
        make.left.equalTo(minView.mas_left);
        make.right.equalTo(minView.mas_right);
        make.height.equalTo(@1);
    }];
    
    UILabel * comLabel = [[UILabel alloc] init];
    comLabel.numberOfLines = 0;
    comLabel.text =@"感谢您对问题的监督，多人举报后该内容将被删除，注意恶意举报会被处罚，是否举报？";
    comLabel.textColor = [UIColor blackColor];
    comLabel.font = titleFont_15;
    comLabel.textAlignment = NSTextAlignmentCenter;
    [minView addSubview:comLabel];
    
    [comLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(minView.mas_top).with.offset(60);
        make.left.equalTo(minView.mas_left).with.offset(20);
        make.right.equalTo(minView.mas_right).with.offset(-20);
    }];
    
    NSArray * array = @[@"取消",@"确定"];
    
    UIButton *lastBtn;
    for (int i = 0;  i < array.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = dblueColor;
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.tag = 1020+i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [minView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(minView.mas_bottom).with.offset(-10);
            if (lastBtn) {
                make.left.equalTo(minView.mas_left).with.offset(30);
            }
            else {
                make.right.equalTo(minView.mas_right).with.offset(-30);
            }
            make.size.mas_equalTo(CGSizeMake(80, 30));
        }];
        
        lastBtn = button;
    }
}

#pragma mark -- 采纳弹出视图
-(void)AdoptView
{
    maxView = [[UIView alloc] initWithFrame:self.view.bounds];
    maxView.backgroundColor = [UIColor blackColor];
    maxView.alpha = 0.7;
    [self.view addSubview:maxView];
    
    minView = [[UIView alloc] init];
    minView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:minView];
    
    [minView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(130);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
        make.height.equalTo(@180);
    }];
    
    UILabel * PromptLabel = [[UILabel alloc] init];
    PromptLabel.textColor = [UIColor redColor];
    PromptLabel.text = @"提示";
    PromptLabel.textAlignment = NSTextAlignmentCenter;
    [minView addSubview:PromptLabel];
    
    [PromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(minView.mas_top).with.offset(10);
        make.left.equalTo(minView.mas_left).with.offset(20);
        make.right.equalTo(minView.mas_right).with.offset(-20);
        //make.height.equalTo(@180);
    }];
    
    UILabel * lineLabel = [[UILabel alloc] init];
    lineLabel.backgroundColor = [SDDColor colorWithHexString:@"#F5F5F5"];
    lineLabel.textAlignment = NSTextAlignmentCenter;
    [minView addSubview:lineLabel];
    
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(PromptLabel.mas_bottom).with.offset(10);
        make.left.equalTo(minView.mas_left).with.offset(10);
        make.right.equalTo(minView.mas_right).with.offset(-10);
        
        make.height.equalTo(@2);
    }];
    
    UILabel * comLabel = [[UILabel alloc] init];
    comLabel.numberOfLines = 0;
    comLabel.text =@"每个问题只有一个最佳答案，是否采纳？";
    comLabel.textColor = [UIColor blackColor];
    comLabel.font = [UIFont systemFontOfSize:15];
    comLabel.textAlignment = NSTextAlignmentCenter;
    [minView addSubview:comLabel];
    
    [comLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(minView.mas_top).with.offset(60);
        make.left.equalTo(minView.mas_left).with.offset(20);
        make.right.equalTo(minView.mas_right).with.offset(-20);
        //make.height.equalTo(@180);
    }];
    
    NSArray * array = @[@"取消",@"确定"];
    for (int i = 0;  i < array.count; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(50+i*120, 135, 70, 30);
        button.backgroundColor = [UIColor redColor];
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.tag = 1010+i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [minView addSubview:button];
    }
    
}

#pragma mark -- 采纳点击
-(void)buttonClick:(UIButton *)btn
{
    if(btn.tag == 1010)
    {
        [self.bigView removeFromSuperview];
        [self.minView removeFromSuperview];
    }
    if (btn.tag == 1011)
    {
        [self.bigView removeFromSuperview];
        [self.minView removeFromSuperview];
        
        [self createAdoptDownLoad];
    }
    if(btn.tag == 1020)
    {
        [maxView removeFromSuperview];
        [minView removeFromSuperview];
    }
    if(btn.tag == 1021)
    {
        [maxView removeFromSuperview];
        [minView removeFromSuperview];
        [self createReportDownLoad];
    }
    
}

#pragma mark -- 回答数据下载、、Details
-(void)createDetailsProblemDownLoad
{
    [self showLoading:2];
    
    NSString * path = @"/questions/detail.do";
    
    _dataArray = [[NSMutableArray alloc] init];
    _relatedArray = [[NSMutableArray alloc] init];
    //questionsId = [[NSString stringWithFormat:@"%@",self.model.questionsId] intValue];
    [HttpRequest postWithNewIssueURL:SDD_MainURL path:path parameter:@{@"questionsId":@(_questionsId)} success:^(id Josn) {
        
        NSDictionary * dict = Josn;
        
        NSLog(@"%@",dict[@"data"]) ;
        
        if ([dict[@"data"] isEqual:[NSNull null]])
        {
        
        }
        else
        {
#pragma mark --  问题的数据解析
            if ([dict[@"data"][@"questions"] isEqual:[NSNull null]]) {
                
            }
            else
            {
                //NSArray * ShopsArray = dict[@"data"][@"questions"];
                
                author = dict[@"data"][@"questions"][@"author"];
                nameLabel.text = author;
                titLable.text = dict[@"data"][@"questions"][@"content"];//问题
                
                NSString *str=[NSString stringWithFormat:@"%@",dict[@"data"][@"questions"][@"addTime"]];//时间戳
                NSTimeInterval time=[str doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
                NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
                //实例化一个NSDateFormatter对象
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                //设定时间格式,这里可以设置成自己需要的格式
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                
                NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
                
                timeLabel.text = currentDateStr;//时间
                
                numLable.text = [NSString stringWithFormat:@"%@",dict[@"data"][@"questions"][@"totalAnswerQty"]];//评论数
                
                judgeNum = [[NSString stringWithFormat:@"%@",dict[@"data"][@"questions"][@"goodsAnswerId"]] intValue];
                

                titleLabel.text =[NSString stringWithFormat:@"%@的问题",author];
                if ([self.model.tagList isEqual:[NSNull null]])
                {
                    
                }
                else
                {
                    NSArray * array = dict[@"data"][@"questions"][@"tagList"];
                    
                    UILabel * lable = (UILabel *)[topView viewWithTag:100];
                    if (array.count > 0) {
                        lable.text = [NSString stringWithFormat:@"%@",array[0]];
                        if (array.count > 1) {
                            lable.text = [NSString stringWithFormat:@"%@  %@",array[0],array[1]];
                        }
                        if (array.count > 2) {
                            lable.text = [NSString stringWithFormat:@"%@  %@  %@",array[0],array[1],array[2]];
                        }
                    }
                    
                }
                

            }
#pragma mark --  回答的数据解析
            NSLog(@"%@",dict[@"data"]);
            if ([dict[@"data"][@"answerList"] isEqual:[NSNull null]]) {
                
            }
            else
            {
                NSArray * ShopsArray = dict[@"data"][@"answerList"];
                for (NSDictionary * dic in ShopsArray) {
                    
                    SinglePostDetailModel * model = [[SinglePostDetailModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_dataArray addObject:model];
                    
                }
            }
            
#pragma mark --  相关问题的数据解析
            if ([dict[@"data"][@"relatedQuestions"] isEqual:[NSNull null]]) {
                
            }
            else
            {
                NSArray * ShopsArray = dict[@"data"][@"relatedQuestions"];
                for (NSDictionary * dic in ShopsArray) {
                    SinglePostDetailModel * model = [[SinglePostDetailModel alloc] init];
                    model.addTime = dic[@"addTime"];
                    model.author = dic[@"author"];
                    model.authorIcon = dic[@"authorIcon"];
                    model.autoClosed = dic[@"autoClosed"];
                    model.content = dic[@"content"];
                    model.finishTime = dic[@"finishTime"];
                    model.goodsAnswerContent = dic[@"goodsAnswerContent"];
                    model.goodsAnswerId = dic[@"goodsAnswerId"];
                    model.goodsUserId = dic[@"goodsUserId"];
                    model.isDelete = dic[@"isDelete"];
                    model.AnswerQty = dic[@"newAnswerQty"];
                    model.questionsId = dic[@"questionsId"];
                    model.reportQty = dic[@"reportQty"];
                    model.rewardScore = dic[@"rewardScore"];
                    model.tagList = dic[@"tagList"];
                    model.totalAnswerQty = dic[@"totalAnswerQty"];
                    model.userId = dic[@"userId"];
                    
                    [_relatedArray addObject:model];
                    
                }
            }
            
            
        }
        
        
        [self hideLoading];
        [_tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -- 举报数据下载
-(void)createReportDownLoad
{
    NSString * path = @"/questions/addReport.do";
    
    [HttpRequest postWithNewIssueURL:SDD_MainURL path:path parameter:@{@"objectId":@(answerId),@"objectType":@1} success:^(id Josn) {
        
        NSDictionary * dict = Josn;
        
        [self showAlert:dict[@"message"]];
        
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -- 采纳数据下载
-(void)createAdoptDownLoad
{
    NSString * path = @"/questionsAnswer/changeToGoodsAnswer.do";
    
    [HttpRequest postWithNewIssueURL:SDD_MainURL path:path parameter:@{@"answerId":@(answerId)} success:^(id Josn) {
        
        NSDictionary * dict = Josn;
        
        [self showAlert:dict[@"message"]];
        [self createDetailsProblemDownLoad];
        [_tableView reloadData];
        
        
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark -- 赞数据下载
-(void)createThumbUpDownLoad
{
    NSString * path = @"/questionsAnswer/addLikeOrTread.do";
    
    [HttpRequest postWithNewIssueURL:SDD_MainURL path:path parameter:@{@"answerId":@(answerId),@"type":@(type)} success:^(id Josn) {
        
        NSDictionary * dict = Josn;
        
        [self showAlert:dict[@"message"]];
        [self createDetailsProblemDownLoad];
        [_tableView reloadData];
        
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -- 回答问题
-(void)createQuestionsAnswer
{
    NSString * path = @"/questionsAnswer/addAnswer.do";
    
    
    [HttpRequest postWithNewIssueURL:SDD_MainURL path:path parameter:@{@"answerContent":questionsStr,@"questionsId":@(_questionsId)} success:^(id Josn) {
        
        NSDictionary * dict = Josn;
        
        
        [self showAlert:dict[@"message"]];
        _answerTextField.text = @"";
        questionsStr = @"";
        [self createDetailsProblemDownLoad];
        [_tableView reloadData];
        
        
    } failure:^(NSError *error) {
        
        
    }];
}


#pragma mark -- 必选的没选提示按钮
- (void)showAlert:(NSString *) _message{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}
- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
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
