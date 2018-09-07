//
//  ThemeViewController.m
//  SDD
//
//  Created by mac on 15/8/18.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ThemeViewController.h"
#import "ThemeApplyViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ThemeViewController ()
{

    UILabel * SponsorLable;//会议主办方
    UILabel * MeetingTimeLable;//会议时间
    UILabel * MeetingAddsLable;//会议地址
    UILabel * MeetingScaleLable;//会议规模
    UILabel * introducedContentLable;//会议介绍内容
    
    UILabel * organizersContentLable;//主办方内容
    UILabel * meetingProcessLabel ;//会议流程
    
    NSDictionary *tempDic;
    
    int statusNum;
}
@property (retain,nonatomic)UIScrollView * scrollView;
@property (retain,nonatomic)NSMutableArray * dataArray;

@end

@implementation ThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    
    statusNum = 0;
    
    [self createNvn];
    [self createView];
    [self requestData];
}

-(void)requestData
{
    _dataArray = [NSMutableArray array];
    int forumsId = [[NSString stringWithFormat:@"%@",_model.id] intValue];
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/forums/detail.do" params:@{@"forumsId":@(forumsId)} success:^(id JSON) {
        
//        NSLog(@"%@",JSON);dforums
        
        if (![JSON[@"data"] isEqual:[NSNull null]]) {
            tempDic = JSON[@"data"];
            statusNum = [[NSString stringWithFormat:@"%@",JSON[@"status"]] intValue];
        }
        else
        {
            [self showAlert:JSON[@"message"]];
        }
        [self createView];
    } failure:^(NSError *error) {
        
    }];
}

-(void)createView
{
    
    //ActivityModel * model = _dataArray[0];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    
    UIImageView * topImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 200)];
    [topImage setImageWithURL:[NSURL URLWithString:_model.defaultImage]placeholderImage:[UIImage imageNamed:@"商多多-LOGO"]];
    [_scrollView addSubview:topImage];
    
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:MM"];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[NSString stringWithFormat:@"%@",_model.time] intValue]];
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    NSMutableAttributedString *strTime = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"会议时间：%@",confromTimespStr]];
    [strTime addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(5,16)];
    
#pragma mark-- 会议地址
    SponsorLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 210, viewWidth-20, 20)];
    SponsorLable.font = midFont;
    
    SponsorLable.text = [NSString stringWithFormat:@"会议主办方:%@",tempDic[@"organizers"]];
    [_scrollView addSubview:SponsorLable];
    
#pragma mark-- 会议时间
    MeetingTimeLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 230, viewWidth-20, 20)];
    MeetingTimeLable.font = midFont;
    MeetingTimeLable.attributedText = strTime;
    [_scrollView addSubview:MeetingTimeLable];
    
#pragma mark-- 会议地址
    MeetingAddsLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 250, viewWidth-20, 20)];
    MeetingAddsLable.font = midFont;
    MeetingAddsLable.text = [NSString stringWithFormat:@"会议地址:%@",_model.address];
    [_scrollView addSubview:MeetingAddsLable];

#pragma mark-- 会议规模
    MeetingScaleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 270, viewWidth-20, 20)];
    MeetingScaleLable.font = midFont;
    MeetingScaleLable.text = [NSString stringWithFormat:@"会议规模: %@ 人",tempDic[@"peopleQty"]];
    [_scrollView addSubview:MeetingScaleLable];

#pragma mark -- 线
    UILabel * lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 295, viewWidth-20, 1)];
    lineLabel.backgroundColor = bgColor;
    [_scrollView addSubview:lineLabel];
    
#pragma mark-- 会议介绍
    UILabel * introducedLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 300, viewWidth-20, 20)];
    introducedLable.font = midFont;
    introducedLable.text = @"会议介绍";
    [_scrollView addSubview:introducedLable];
    
#pragma mark -- 线
    UILabel * lineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 325, viewWidth-20, 1)];
    lineLabel1.backgroundColor = bgColor;
    [_scrollView addSubview:lineLabel1];
    
#pragma mark -- 内容
    introducedContentLable = [[UILabel alloc] init];
    introducedContentLable.font = bottomFont_12;
    introducedContentLable.textColor = lgrayColor;
    introducedContentLable.numberOfLines = 0;
    introducedContentLable.text =tempDic[@"summary"];
    [_scrollView addSubview:introducedContentLable];
    [introducedContentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLabel1.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
    }];
    
#pragma mark -- 线
    UILabel * lineLabel2 = [[UILabel alloc] init];
    lineLabel2.backgroundColor = bgColor;
    [_scrollView addSubview:lineLabel2];
    [lineLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(introducedContentLable.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.equalTo(@1);
    }];
    
#pragma mark-- 主办方
    UILabel * organizersLable = [[UILabel alloc] init];
    organizersLable.font = midFont;
    organizersLable.text = @"主办方";
    [_scrollView addSubview:organizersLable];
    [organizersLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLabel2.mas_bottom).with.offset(8);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
    }];
    
#pragma mark -- 线
    UILabel * lineLabel3 = [[UILabel alloc] init];
    lineLabel3.backgroundColor = bgColor;
    [_scrollView addSubview:lineLabel3];
    [lineLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(organizersLable.mas_bottom).with.offset(8);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.equalTo(@1);
    }];
    
#pragma mark-- 主办方内容
    organizersContentLable = [[UILabel alloc] init];
    organizersContentLable.font = bottomFont_12;
    organizersContentLable.textColor = lgrayColor;
    organizersContentLable.numberOfLines = 0;
    organizersContentLable.text =tempDic[@"organizers"];
    [_scrollView addSubview:organizersContentLable];
    [organizersContentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLabel3.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
    }];
    
#pragma mark -- 线
    UILabel * lineLabel4 = [[UILabel alloc] init];
    lineLabel4.backgroundColor = bgColor;
    [_scrollView addSubview:lineLabel4];
    [lineLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(organizersContentLable.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.equalTo(@1);
    }];
    
#pragma mark -- 拟邀嘉宾
    UILabel * guestLable = [[UILabel alloc] init];
    guestLable.font = midFont;
    guestLable.text = @"拟邀嘉宾";
    [_scrollView addSubview:guestLable];
    [guestLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLabel4.mas_bottom).with.offset(8);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
    }];
    
#pragma mark -- 线
    UILabel * lineLabel7 = [[UILabel alloc] init];
    lineLabel7.backgroundColor = bgColor;
    [_scrollView addSubview:lineLabel7];
    [lineLabel7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(guestLable.mas_bottom).with.offset(8);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.equalTo(@1);
    }];
    
    UIScrollView * minScrollView = [[UIScrollView alloc] init];
    //minScrollView.backgroundColor = [UIColor redColor];
    
    [_scrollView addSubview:minScrollView];
    [minScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLabel7.mas_bottom).with.offset(8);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.equalTo(@130);
    }];
    
    NSArray * arr = tempDic[@"guestsList"];
    minScrollView.contentSize = CGSizeMake(165*arr.count, 130);
    for (int i = 0; i < arr.count; i ++) {
        UIView * imView = [[UIView alloc] initWithFrame:CGRectMake(i*165, 0, 135, 130)];
        //imView.backgroundColor = [UIColor redColor];
        [minScrollView addSubview:imView];
        
        NSDictionary * dict = arr[i];
        
        UIImageView * headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 135, 90)];
        [headImageView setImageWithURL:[NSURL URLWithString:dict[@"guestsAvatar"]]placeholderImage:[UIImage imageNamed:@"商多多-LOGO"]];
        [imView addSubview:headImageView];
        
        UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 95, 135, 15)];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.text = dict[@"guestsName"];
        nameLabel.font = bottomFont_12;
        nameLabel.textColor = lgrayColor;
        [imView addSubview:nameLabel];
        
        UILabel * officeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 110, 135, 15)];
        officeLabel.textAlignment = NSTextAlignmentCenter;
        officeLabel.text = dict[@"guestsPost"];
        officeLabel.font = bottomFont_12;
        officeLabel.textColor = lgrayColor;
        [imView addSubview:officeLabel];
    }
    
    
#pragma mark -- 线
    UILabel * lineLabel5 = [[UILabel alloc] init];
    lineLabel5.backgroundColor = bgColor;
    [_scrollView addSubview:lineLabel5];
    [lineLabel5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(minScrollView.mas_bottom).with.offset(8);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.equalTo(@1);
    }];
    
#pragma mark -- 会议流程
    UILabel * processLable = [[UILabel alloc] init];
    processLable.font = midFont;
    processLable.text = @"会议流程";
    [_scrollView addSubview:processLable];
    [processLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLabel5.mas_bottom).with.offset(8);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
    }];
    
#pragma mark -- 线
    UILabel * lineLabel6 = [[UILabel alloc] init];
    lineLabel6.backgroundColor = bgColor;
    [_scrollView addSubview:lineLabel6];
    [lineLabel6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(processLable.mas_bottom).with.offset(8);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.equalTo(@1);
    }];
    
#pragma mark-- 会议流程
    meetingProcessLabel = [[UILabel alloc] init];
    meetingProcessLabel.font = bottomFont_12;
    meetingProcessLabel.textColor = lgrayColor;
    meetingProcessLabel.numberOfLines = 0;
    meetingProcessLabel.text = tempDic[@"meetingProcess"];
    [_scrollView addSubview:meetingProcessLabel];
    [meetingProcessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLabel6.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
    }];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font= largeFont ;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[Tools_F imageWithColor:dblueColor size:CGSizeMake(viewWidth-40, 45)]
                      forState:UIControlStateNormal];
    [Tools_F setViewlayer:button cornerRadius:5 borderWidth:1 borderColor:dblueColor];
    button.tag = 1000;
    [button setTitle:@"立即报名" forState:UIControlStateNormal];
    [_scrollView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(meetingProcessLabel.mas_bottom).with.offset(50);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
    }];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *comment1 = tempDic[@"organizers"];
    NSDictionary *attribute1 = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize size1 = [comment1 boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute1 context:nil].size;
    
    NSString *comment2 = tempDic[@"meetingProcess"];
    NSDictionary *attribute2 = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize size2 = [comment2 boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute2 context:nil].size;
    
    _scrollView.contentSize = CGSizeMake(viewWidth, size1.height+size2.height+viewHeight*1.5);
    
    //NSLog(@"%@",button.frame);
    
    //_scrollView.contentSize = CGSizeMake(viewWidth, CGRectGetMaxY(button.frame)+74);
}
-(void)buttonClick:(UIButton *)btn
{
    
    
    if (statusNum == 1) {
//        NSString * str4 = _dataArray[1];
//        NSString * strname = _dataArray[0];
//        NSString * indStr = _dataArray[2];
//        NSString * brandStr = _dataArray[3];
        
        NSString * str3 =[NSString stringWithFormat:@"%@",tempDic[@"forumsTime"]];
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        
        [formatter setDateFormat:@"yyyy-MM-dd HH:MM"];
        
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[NSString stringWithFormat:@"%@",str3] intValue]];
        
        NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        
        ThemeApplyViewController * thVc = [[ThemeApplyViewController alloc] init];
        
        thVc.temDic = tempDic;
//        thVc.actNum = 1;
        
        thVc.confromTimespStr = confromTimespStr;
        thVc.str2 = tempDic[@"forumsAddress"];
        thVc.str1 = tempDic[@"title"];
//        thVc.str4 = str4;
//        thVc.strname = strname;
//        thVc.indStr = indStr;
//        thVc.brandStr = brandStr;
        
        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;
        [self.navigationController pushViewController:thVc animated:YES];

    }
    else {
        [self showAlert:@"请先登录"];
    }
    
}

-(void)createNvn
{
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"主题论坛详情";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    UIButton * rightBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 15, 15);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"分享-图标"] forState:UIControlStateNormal];
    
    UIBarButtonItem * rigItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rigItem;
    
}
- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
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
