//
//  ProjectActivitiesViewController.m
//  SDD
//
//  Created by mac on 15/8/19.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ProjectActivitiesViewController.h"
#import "ThemeApplyViewController.h"
#import "UIImageView+AFNetworking.h"
#import "sponsorViewController.h"
#import "photoABViewController.h"
#import "ShareHelper.h"

@interface ProjectActivitiesViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel * forecastContentLable;
    UILabel * forecastContentLable2;
    
    UILabel * itineraryLabel;
    
    UILabel * TheInvitationLable;
    UILabel * InviteBrLable;
    
    NSDictionary *tempDic;
}


@property (retain,nonatomic)UIScrollView * scrollView;
@property (retain,nonatomic) UITableView *tableView;

@end

@implementation ProjectActivitiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = bgColor;
    
    
    NSLog(@"tempDicisSsponsor  =====%@",tempDic[@"isSsponsor"]);
    
    [self createNvn];
//    [self createView];
    [self createTableView];
    [self requestData];
}

-(void)requestData
{
    //_dataArray = [NSMutableArray array];
    int forumsId = [[NSString stringWithFormat:@"%@",[_dataDic objectForKey:@"forumsId"]] intValue];
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/forums/detail.do" params:@{@"forumsId":@(forumsId)} success:^(id JSON) {
        
        NSLog(@"活动详情页面数据解析   ************         %@",JSON);
        
        if (![JSON[@"data"] isEqual:[NSNull null]]) {
            tempDic = JSON[@"data"];
        }
        
        [_tableView reloadData];
//        [self createView];
    } failure:^(NSError *error) {
        
    }];
}

-(void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-115) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tag = 999;
//    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0.1;
    }
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 8;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 150;
    }
    else if (indexPath.section == 1){
        return 130;
    }
    else if (indexPath.section == 2){
        return 80;
    }
    else if (indexPath.section == 3){
        return 80;
    }
    else if (indexPath.section == 4){
        return 140;
    }
    else if (indexPath.section == 5)
    {
        NSString *comment1 = [NSString stringWithFormat:@"%@",tempDic[@"inviteGuests"]];
        NSDictionary *attribute1 = @{NSFontAttributeName: [UIFont systemFontOfSize:12]};
        CGSize size1 = [comment1 boundingRectWithSize:CGSizeMake(320, 1500) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute1 context:nil].size;
        return size1.height+108;
    }
    else if (indexPath.section == 6)
    {
        NSString *comment2001 = [NSString stringWithFormat:@"%@",tempDic[@"supportUnits"]];
        NSDictionary *attribute1002 = @{NSFontAttributeName: midFont};
        CGSize size2 = [comment2001 boundingRectWithSize:CGSizeMake(320, 2000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute1002 context:nil].size;
        
        NSString *comment1 = [NSString stringWithFormat:@"%@",tempDic[@"organizers"]];
        NSDictionary *attribute1 = @{NSFontAttributeName: midFont};
        CGSize size1 = [comment1 boundingRectWithSize:CGSizeMake(320, 2000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute1 context:nil].size;
        
        return size1.height+size2.height+300;
        
    }
    else if (indexPath.section == 7)
    {
        return 160;
    }
//    else if (indexPath.section == 8){
//        return 0;
//    }
    return 150;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    
    switch (indexPath.section) {
        case 0:
        {
#pragma mark -- 标题
            UILabel *titLabel = [[UILabel alloc]init];
            titLabel.frame = CGRectMake(10, 5, viewWidth-20, 40);
            titLabel.font = titleFont_15;
            titLabel.numberOfLines = 2;
           
            [cell addSubview:titLabel];
            if (![tempDic[@"title"] isEqual:[NSNull null]]) {
                
                titLabel.text = [NSString stringWithFormat:@"%@",tempDic[@"title"]];
            }
            
//            [titLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self.view.mas_bottom).with.offset(0);
//                make.left.equalTo(self.view.mas_left).with.offset(10);
//                make.right.equalTo(self.view.mas_right).with.offset(-10);
//                make.height.equalTo(@50);
//            
//            }];
//            NSLog(@"%f",self.view.frame.size.width);
#pragma mark -- 线   这里有masony错误
            UILabel * lineLabel1 = [[UILabel alloc] init];
            lineLabel1.backgroundColor = bgColor;
            [cell addSubview:lineLabel1];
            [lineLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titLabel.mas_bottom).with.offset(8);
                make.left.equalTo(cell.mas_left).with.offset(10);
                make.right.equalTo(cell.mas_right).with.offset(-10);
//                make.width.equalTo(cell.mas_width).with.offset(0);
                make.height.equalTo(@1);
                
            }];
            
#pragma mark -- 左边图片
            UIImageView *leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 58, viewWidth/5*2, 80)];
//            leftImage.image = [UIImage imageNamed:@"jiashuju"];
            if (![tempDic[@"icon"] isEqual:[NSNull null]]) {
                
                [leftImage setImageWithURL:[NSURL URLWithString:tempDic[@"icon"]]placeholderImage:[UIImage imageNamed:@"商多多-LOGO"]];
            }
            
            [cell addSubview:leftImage];
            
#pragma mark --
            UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(viewWidth/5*2+20, 58, viewWidth/5*3-30, 80)];
            rightLabel.font = midFont;
            rightLabel.textColor = lgrayColor;
            
            rightLabel.numberOfLines = 0;
            [cell addSubview:rightLabel];
            if (![tempDic[@"summary"] isEqual:[NSNull null]]) {
                rightLabel.text = [NSString stringWithFormat:@"主办简介：%@",tempDic[@"summary"]];
            }
        }
            break;
            case 1:
        {
#pragma mark -- 活动图集
            UILabel *titLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 25)];
            titLabel.font = titleFont_15;
            titLabel.text = @"活动图集";
            [cell addSubview:titLabel];
            
#pragma mark -- 线
            UILabel * lineLabel1 = [[UILabel alloc] init];
            lineLabel1.backgroundColor = bgColor;
            [cell addSubview:lineLabel1];
            [lineLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titLabel.mas_bottom).with.offset(8);
                make.left.equalTo(cell.mas_left).with.offset(10);
                make.right.equalTo(cell.mas_right).with.offset(-10);
//                make.width.equalTo(cell.mas_width).with.offset(0);
                make.height.equalTo(@1);
                
            }];
            
#pragma mark -- 三张展示图片
            UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 48, (viewWidth-40)/3, 72)];
            
            [cell addSubview:image1];
            
            
            UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(20+(viewWidth-40)/3, 48, (viewWidth-40)/3, 72)];
            
            [cell addSubview:image2];
            
            UIImageView *image3 = [[UIImageView alloc]initWithFrame:CGRectMake(30+(viewWidth-40)/3*2, 48, (viewWidth-40)/3, 72)];
            
            [cell addSubview:image3];
            
            if (![tempDic[@"imageList"] isEqual:[NSNull null]]) {
                
                [image1 setImageWithURL:[NSURL URLWithString:[tempDic[@"imageList"][0] objectForKey:@"imageUrl"]] placeholderImage:[UIImage imageNamed:@"商多多-LOGO"]];
                [image2 setImageWithURL:[NSURL URLWithString:[tempDic[@"imageList"][1] objectForKey:@"imageUrl"]] placeholderImage:[UIImage imageNamed:@"商多多-LOGO"]];
                [image3 setImageWithURL:[NSURL URLWithString:[tempDic[@"imageList"][2] objectForKey:@"imageUrl"]] placeholderImage:[UIImage imageNamed:@"商多多-LOGO"]];
            }
        }
            break;
            case 2:
        {
#pragma mark -- 活动时间
            UILabel *titLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 25)];
            titLabel.font = titleFont_15;
            titLabel.text = @"活动时间";
            [cell addSubview:titLabel];
            
#pragma mark -- 线
            UILabel * lineLabel1 = [[UILabel alloc] init];
            lineLabel1.backgroundColor = bgColor;
            [cell addSubview:lineLabel1];
            [lineLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titLabel.mas_bottom).with.offset(8);
                make.left.equalTo(cell.mas_left).with.offset(10);
                make.right.equalTo(cell.mas_right).with.offset(-10);
//                make.width.equalTo(cell.mas_width).with.offset(0);
                make.height.equalTo(@1);
                
            }];
            
            NSString * str3;
            if (![tempDic[@"activityTime"] isEqual:[NSNull null]]) {
                
                str3 =[NSString stringWithFormat:@"%@",tempDic[@"activityTime"]];
            }
            
            
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            
            [formatter setDateFormat:@"  yyyy年MM月dd日 HH:MM"];
            
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[NSString stringWithFormat:@"%@",str3] intValue]];
            
            NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
            
            UILabel *timeLabel = [[UILabel alloc]init];
            timeLabel.font = midFont;
            timeLabel.text=confromTimespStr;
            timeLabel.textColor = [UIColor orangeColor];
            [cell addSubview:timeLabel];
            [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lineLabel1.mas_bottom).with.offset(8);
                make.left.equalTo(cell.mas_left).with.offset(20);
                make.right.equalTo(cell.mas_right).with.offset(-10);
                //make.width.equalTo(cell.mas_width).with.offset(0);
                make.height.equalTo(@30);
                
            }];
            
        }
            break;
            case 3:
        {
#pragma mark -- 活动地点
            UILabel *titLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 25)];
            titLabel.font = titleFont_15;
            titLabel.text = @"活动地点";
            [cell addSubview:titLabel];
            
#pragma mark -- 线
            UILabel * lineLabel1 = [[UILabel alloc] init];
            lineLabel1.backgroundColor = bgColor;
            [cell addSubview:lineLabel1];
            [lineLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titLabel.mas_bottom).with.offset(8);
                make.left.equalTo(cell.mas_left).with.offset(10);
                make.right.equalTo(cell.mas_right).with.offset(-10);
//                make.width.equalTo(cell.mas_width).with.offset(0);
                make.height.equalTo(@1);
                
            }];
            
            UILabel *addLabel = [[UILabel alloc]init];
            addLabel.font = midFont;
            
//            addLabel.textColor = [UIColor orangeColor];
            [cell addSubview:addLabel];
            [addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lineLabel1.mas_bottom).with.offset(8);
                make.left.equalTo(cell.mas_left).with.offset(20);
                make.right.equalTo(cell.mas_right).with.offset(-10);
//                make.width.equalTo(cell.mas_width).with.offset(0);
                make.height.equalTo(@30);
                
            }];
            if (![tempDic[@"activityAddress"] isEqual:[NSNull null]]) {
                
                addLabel.text=[NSString stringWithFormat:@"  %@",tempDic[@"activityAddress"]];
            }
        }
            break;
            case 4:
        {
#pragma mark -- 特邀嘉宾
            UILabel *titLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 25)];
            titLabel.font = titleFont_15;
            titLabel.text = @"特邀嘉宾";
            [cell addSubview:titLabel];
            
#pragma mark -- 线
            UILabel * lineLabel1 = [[UILabel alloc] init];
            lineLabel1.backgroundColor = bgColor;
            [cell addSubview:lineLabel1];
            [lineLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titLabel.mas_bottom).with.offset(8);
                make.left.equalTo(cell.mas_left).with.offset(10);
                make.right.equalTo(cell.mas_right).with.offset(-10);
//                make.width.equalTo(cell.mas_width).with.offset(0);
                make.height.equalTo(@1);
                
            }];
            
            UIImageView *leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 48, viewWidth/4, 82)];
            
            [cell addSubview:leftImage];
            
            UILabel *rightNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(viewWidth/4+20, 48, viewWidth/4*3-30, 25)];
            rightNameLabel.font = titleFont_15;
            
            [cell addSubview:rightNameLabel];
            
            UILabel *rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(viewWidth/4+20, 73, viewWidth/4*3-30, 57)];
            rightLabel.font = midFont;
            rightLabel.textColor = lgrayColor;
            rightLabel.numberOfLines = 0;
            
            [cell addSubview:rightLabel];
            
            
            if (![tempDic[@"guestsList"] isEqual:[NSNull null]]) {
                
                if ([tempDic[@"guestsList"] count] != 0) {
                    
                    [leftImage setImageWithURL:[NSURL URLWithString:[tempDic[@"guestsList"][0] objectForKey:@"guestsAvatar"]]placeholderImage:[UIImage imageNamed:@"商多多-LOGO"]];
                    
                    
                    rightNameLabel.text = [NSString stringWithFormat:@"%@",[tempDic[@"guestsList"][0] objectForKey:@"guestsName"]];
                    
                    rightLabel.text = [NSString stringWithFormat:@"%@",[tempDic[@"guestsList"][0] objectForKey:@"guestsPost"]];
                    
                }
                
            }
        }
            break;
            case 5:
        {
#pragma mark -- 论坛嘉宾
            UILabel *titLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 25)];
            titLabel.font = titleFont_15;
            titLabel.text = @"论坛嘉宾";
            [cell addSubview:titLabel];
            
#pragma mark -- 线
            UILabel * lineLabel1 = [[UILabel alloc] init];
            lineLabel1.backgroundColor = bgColor;
            [cell addSubview:lineLabel1];
            [lineLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titLabel.mas_bottom).with.offset(8);
                make.left.equalTo(cell.mas_left).with.offset(10);
                make.right.equalTo(cell.mas_right).with.offset(-10);
//                make.width.equalTo(cell.mas_width).with.offset(0);
                make.height.equalTo(@1);
                
            }];
            
            NSString *comment1;
            if (![tempDic[@"inviteGuests"] isEqual:[NSNull null]]) {
                
                comment1= [NSString stringWithFormat:@"%@",tempDic[@"inviteGuests"]];
            }
            
            NSDictionary *attribute1 = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
            CGSize size1 = [comment1 boundingRectWithSize:CGSizeMake(320, 2000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute1 context:nil].size;
            
            UILabel * inviteLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, viewWidth - 20, size1.height+50)];
            
            inviteLabel.numberOfLines = 0;
            inviteLabel.font = midFont;
            inviteLabel.textColor = lgrayColor;
            [cell addSubview:inviteLabel];
            if (![tempDic[@"inviteGuests"] isEqual:[NSNull null]]) {
                
                inviteLabel.text =tempDic[@"inviteGuests"];
            }
            
        }
            break;
            case 6:
        {
#pragma mark -- 组织单位
            UILabel *titLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 25)];
            titLabel.font = titleFont_15;
            titLabel.text = @"组织单位";
            [cell addSubview:titLabel];
            
#pragma mark -- 线
            UILabel * lineLabel1 = [[UILabel alloc] init];
            lineLabel1.backgroundColor = bgColor;
            [cell addSubview:lineLabel1];
            [lineLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titLabel.mas_bottom).with.offset(8);
                make.left.equalTo(cell.mas_left).with.offset(10);
                make.right.equalTo(cell.mas_right).with.offset(-10);
//                make.width.equalTo(cell.mas_width).with.offset(0);
                make.height.equalTo(@1);
                
            }];
            
            UILabel *leonLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, 80, 30)];
            leonLabel.font = midFont;
            leonLabel.textColor = [UIColor blackColor];
            leonLabel.text = @"主办单位:";
            [cell addSubview:leonLabel];
            
            NSString *comment1;
            if (![tempDic[@"organizers"] isEqual:[NSNull null]]) {
                
                comment1 = [NSString stringWithFormat:@"%@",tempDic[@"organizers"]];
            }
            
            NSDictionary *attribute1 = @{NSFontAttributeName: midFont};
            CGSize size1 = [comment1 boundingRectWithSize:CGSizeMake(320, 2000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute1 context:nil].size;
            
            UILabel *rionLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 45, viewWidth-120, size1.height +15)];
            rionLabel.font = midFont;
            rionLabel.textColor = lgrayColor;
            
            rionLabel.numberOfLines = 0;
            [cell addSubview:rionLabel];
            if (![tempDic[@"organizers"] isEqual:[NSNull null]]) {
                rionLabel.text = tempDic[@"organizers"];
            }
            
            UILabel *letwLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, size1.height + 30 + 45, 80, 30)];
            letwLabel.font = midFont;
            letwLabel.textColor = [UIColor blackColor];
            letwLabel.text = @"支持单位:";
            [cell addSubview:letwLabel];
            
            NSString *comment2001;
            if (![tempDic[@"supportUnits"] isEqual:[NSNull null]]) {
                
                comment2001= [NSString stringWithFormat:@"%@",tempDic[@"supportUnits"]];
            }
            
            NSDictionary *attribute1002 = @{NSFontAttributeName: midFont};
            CGSize size2 = [comment2001 boundingRectWithSize:CGSizeMake(320, 2000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute1002 context:nil].size;
            
            UILabel *ritwLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, size1.height + 30 + 45, viewWidth-120, size2.height + 30)];
            ritwLabel.font = midFont;
            ritwLabel.textColor = lgrayColor;
            
            ritwLabel.numberOfLines = 0;
            [cell addSubview:ritwLabel];
            if (![tempDic[@"supportUnits"] isEqual:[NSNull null]]) {
                ritwLabel.text = tempDic[@"supportUnits"];
            }
            
            UIImageView *ima= [[UIImageView alloc]initWithFrame:CGRectMake(10, size1.height + 30 + 45 + size2.height + 30, viewWidth-20, 180)];
            
            [cell addSubview:ima];
            if (![tempDic[@"unitsImage"] isEqual:[NSNull null]]) {
                
                [ima setImageWithURL:[NSURL URLWithString:tempDic[@"unitsImage"]]placeholderImage:[UIImage imageNamed:@"商多多-LOGO"]];
            }
            
        }
            break;
            case 7:
        {
#pragma mark -- 邀约媒体
            UILabel *titLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 20)];
            titLabel.font = titleFont_15;
            titLabel.text = @"邀约媒体";
            [cell addSubview:titLabel];
            
#pragma mark -- 线
            UILabel * lineLabel1 = [[UILabel alloc] init];
            lineLabel1.backgroundColor = bgColor;
            [cell addSubview:lineLabel1];
            [lineLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titLabel.mas_bottom).with.offset(8);
                make.left.equalTo(cell.mas_left).with.offset(10);
                make.right.equalTo(cell.mas_right).with.offset(-10);
//                make.width.equalTo(cell.mas_width).with.offset(0);
                make.height.equalTo(@1);
                
            }];
            
            UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 43, (viewWidth-60)/3, 46)];
            
            [cell addSubview:image1];
            UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(30+(viewWidth-60)/3, 43, (viewWidth-60)/3, 46)];
            
            [cell addSubview:image2];
            UIImageView *image3 = [[UIImageView alloc]initWithFrame:CGRectMake(50+(viewWidth-60)/3*2, 43, (viewWidth-60)/3, 46)];
            
            [cell addSubview:image3];
            UIImageView *image4 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 104, (viewWidth-60)/3, 46)];
            
            [cell addSubview:image4];
            UIImageView *image5 = [[UIImageView alloc]initWithFrame:CGRectMake(30+(viewWidth-60)/3, 104, (viewWidth-60)/3, 46)];
            
            [cell addSubview:image5];
            UIImageView *image6 = [[UIImageView alloc]initWithFrame:CGRectMake(50+(viewWidth-60)/3*2, 104, (viewWidth-60)/3, 46)];
            
            [cell addSubview:image6];
            
            if (![tempDic[@"organizeList"] isEqual:[NSNull null]]) {
                [image1 setImageWithURL:[NSURL URLWithString:[tempDic[@"organizeList"][0] objectForKey:@"logo"]]placeholderImage:[UIImage imageNamed:@"商多多-LOGO"]];
                [image2 setImageWithURL:[NSURL URLWithString:[tempDic[@"organizeList"][1] objectForKey:@"logo"]]placeholderImage:[UIImage imageNamed:@"商多多-LOGO"]];
                [image3 setImageWithURL:[NSURL URLWithString:[tempDic[@"organizeList"][2] objectForKey:@"logo"]]placeholderImage:[UIImage imageNamed:@"商多多-LOGO"]];
                [image4 setImageWithURL:[NSURL URLWithString:[tempDic[@"organizeList"][3] objectForKey:@"logo"]]placeholderImage:[UIImage imageNamed:@"商多多-LOGO"]];
                [image5 setImageWithURL:[NSURL URLWithString:[tempDic[@"organizeList"][4] objectForKey:@"logo"]]placeholderImage:[UIImage imageNamed:@"商多多-LOGO"]];
                [image6 setImageWithURL:[NSURL URLWithString:[tempDic[@"organizeList"][4] objectForKey:@"logo"]]placeholderImage:[UIImage imageNamed:@"商多多-LOGO"]];
            }
        }
            break;
#pragma mark -- 报名
//            case 8:
//        {
//            UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
////            leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//            
//            [leftButton.layer setMasksToBounds:YES];
//            [leftButton.layer setCornerRadius:10.0];
//            leftButton.frame = CGRectMake(20, 5, viewWidth/2-40, 40);
//            
//            if (tempDic[@"isSignup"] != nil)
//            {
//                [leftButton setTitle:@"立即报名" forState:UIControlStateNormal];
//                leftButton.backgroundColor  = [UIColor colorWithRed:(253/255.0) green:(149/255.0) blue:(10/255.0) alpha:(1.0)];
//
//            }
//            else
//            {
//                [leftButton setTitle:@"已结束" forState:UIControlStateNormal];
//                leftButton.backgroundColor = lgrayColor;
//                leftButton.enabled = NO;
//                
//            }
//            
//            [leftButton addTarget:self action:@selector(leftButtonDDD:) forControlEvents:UIControlEventTouchUpInside];
//            [cell addSubview:leftButton];
//            UIButton *rightButton   = [UIButton buttonWithType:UIButtonTypeCustom];
//            
//            if (tempDic[@"isSsponsor"] != nil) {
//                [rightButton setTitle:@"我要赞助" forState:UIControlStateNormal];
//                rightButton.backgroundColor  = [UIColor colorWithRed:(16/255.0) green:(118/255.0) blue:(224/255.0) alpha:(1.0)];
//
//            }
//            else
//            {
//                [rightButton setTitle:@"我要赞助" forState:UIControlStateNormal];
//                rightButton.backgroundColor = lgrayColor;
//                rightButton.enabled = NO;
//            }
////            rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//            
//            [rightButton.layer setMasksToBounds:YES];
//            [rightButton.layer setCornerRadius:10.0];
//            rightButton.frame = CGRectMake(20+viewWidth/2, 5, viewWidth/2-40, 40);
//                        [rightButton addTarget:self action:@selector(rightButtonDDD:) forControlEvents:UIControlEventTouchUpInside];
//            [cell addSubview:rightButton];
//        }
//            break;
            
        default:
            break;
    }
    cell.selectionStyle=UITableViewCellAccessoryNone; //行不能被选中
    
    return cell;
    
    
}

-(void)leftButtonDDD:(UIButton *)btn
{
    NSLog(@"left");
    NSString * str3 =[NSString stringWithFormat:@"%@",tempDic[@"activityTime"]];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:MM"];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[NSString stringWithFormat:@"%@",str3] intValue]];
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    ThemeApplyViewController * thVc = [[ThemeApplyViewController alloc] init];
    thVc.actNum = 2;
    NSLog(@"001");
    thVc.temDic = tempDic;
    NSLog(@"002");
    thVc.confromTimespStr = confromTimespStr;
    NSLog(@"003");
    thVc.str2 = tempDic[@"activityAddress"];
    NSLog(@"004");
    thVc.str1 = tempDic[@"title"];
    
    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;
    [self.navigationController pushViewController:thVc animated:YES];
}

-(void)rightButtonDDD:(UIButton *)btn
{
    NSLog(@"right");
    sponsorViewController *sVC = [[sponsorViewController alloc]init];
//    sVC.actNum = [[NSString stringWithFormat:@"%@",_model.id] intValue];
    NSLog(@"%d",sVC.actNum);
//    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;
    [self.navigationController pushViewController:sVC animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ((long)indexPath.section == 1) {
        photoABViewController * pABVC = [[photoABViewController alloc]init];
//        pABVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        pABVC.imageDict = tempDic [@"imageList"];
        pABVC.imageStr = tempDic[@"icon"];
        [self.navigationController pushViewController:pABVC animated:YES];
        
//        UINavigationController *nav_houseLookingVC = [[UINavigationController alloc]initWithRootViewController:pABVC];
//        
//        [self presentViewController:nav_houseLookingVC animated:YES completion:nil];
    }
    
    NSLog(@"%ld",(long)indexPath.section);
    
}

-(void)createView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    UIImageView * topImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 200)];
    //topImage.image = [UIImage imageNamed:@"jiashuju"];
    [topImage setImageWithURL:[NSURL URLWithString:tempDic[@"activityImage"]]placeholderImage:[UIImage imageNamed:@"商多多-LOGO"]];
    [_scrollView addSubview:topImage];
    
#pragma mark-- 活动预报
    UILabel * forecastLable = [[UILabel alloc] init];
    forecastLable.font = midFont;
    forecastLable.text = @"活动详情";
    [_scrollView addSubview:forecastLable];
    [forecastLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImage.mas_bottom).with.offset(8);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
    }];
    
#pragma mark -- 线
    UILabel * lineLabel1 = [[UILabel alloc] init];
    lineLabel1.backgroundColor = bgColor;
    [_scrollView addSubview:lineLabel1];
    [lineLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(forecastLable.mas_bottom).with.offset(8);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.equalTo(@1);
    }];
    
#pragma mark-- 活动预报内容
    forecastContentLable = [[UILabel alloc] init];
    forecastContentLable.font = bottomFont_12;
    forecastContentLable.textColor = lgrayColor;
    forecastContentLable.numberOfLines = 0;
    forecastContentLable.text = tempDic[@"activityDetail"];
    [_scrollView addSubview:forecastContentLable];
    [forecastContentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLabel1.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
    }];
    
    UIImageView * babyImage = [[UIImageView alloc] init];
    //babyImage.image = [UIImage imageNamed:@"jiashuju"];
    
    [babyImage setImageWithURL:[NSURL URLWithString:tempDic[@"icon"]] placeholderImage:[UIImage imageNamed:@"商多多-LOGO"]];
    
    [_scrollView addSubview:babyImage];
    [babyImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(forecastContentLable.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.equalTo(@150);
    }];
    
    forecastContentLable2 = [[UILabel alloc] init];
    forecastContentLable2.font = bottomFont_12;
    forecastContentLable2.textColor = lgrayColor;
    forecastContentLable2.numberOfLines = 0;
    forecastContentLable2.text = tempDic[@"houseDetail"];
    [_scrollView addSubview:forecastContentLable2];
    [forecastContentLable2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(babyImage.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
    }];
    
#pragma mark -- 线
    UILabel * lineLabel2 = [[UILabel alloc] init];
    lineLabel2.backgroundColor = bgColor;
    [_scrollView addSubview:lineLabel2];
    [lineLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(forecastContentLable2.mas_bottom).with.offset(8);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.equalTo(@1);
    }];
    
#pragma mark -- 活动日程
    UILabel * processLable = [[UILabel alloc] init];
    processLable.font = midFont;
    processLable.text = @"活动日程";
    [_scrollView addSubview:processLable];
    [processLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLabel2.mas_bottom).with.offset(8);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
    }];
    
#pragma mark -- 线
    UILabel * lineLabel3 = [[UILabel alloc] init];
    lineLabel3.backgroundColor = bgColor;
    [_scrollView addSubview:lineLabel3];
    [lineLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(processLable.mas_bottom).with.offset(8);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.equalTo(@1);
    }];
    
    itineraryLabel = [[UILabel alloc] init];
    itineraryLabel.font = bottomFont_12;
    itineraryLabel.textColor = lgrayColor;
    itineraryLabel.numberOfLines = 0;
    itineraryLabel.text = tempDic[@"activityObject"];
    [_scrollView addSubview:itineraryLabel];
    [itineraryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLabel3.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
    }];

#pragma mark -- 线
    UILabel * lineLabel4 = [[UILabel alloc] init];
    lineLabel4.backgroundColor = bgColor;
    [_scrollView addSubview:lineLabel4];
    [lineLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(itineraryLabel.mas_bottom).with.offset(8);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.equalTo(@1);
    }];
    
//#pragma mark -- 拟邀嘉宾
//    UILabel * invitedLable = [[UILabel alloc] init];
//    invitedLable.font = midFont;
//    invitedLable.text = @"活动日程11";
//    [_scrollView addSubview:invitedLable];
//    [invitedLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(lineLabel4.mas_bottom).with.offset(8);
//        make.left.equalTo(self.view.mas_left).with.offset(10);
//        make.right.equalTo(self.view.mas_right).with.offset(-10);
//    }];
    
//#pragma mark -- 线
//    UILabel * lineLabel5 = [[UILabel alloc] init];
//    lineLabel5.backgroundColor = bgColor;
//    [_scrollView addSubview:lineLabel5];
//    [lineLabel5 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(invitedLable.mas_bottom).with.offset(8);
//        make.left.equalTo(self.view.mas_left).with.offset(10);
//        make.right.equalTo(self.view.mas_right).with.offset(-10);
//        make.height.equalTo(@1);
//    }];

    
//    TheInvitationLable = [[UILabel alloc] init];
//    TheInvitationLable.font = bottomFont_12;
//    TheInvitationLable.textColor = lgrayColor;
//    TheInvitationLable.numberOfLines = 0;
//    TheInvitationLable.text = tempDic[@"organizers"];
//    [_scrollView addSubview:TheInvitationLable];
//    [TheInvitationLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(lineLabel4.mas_bottom).with.offset(10);
//        make.left.equalTo(self.view.mas_left).with.offset(10);
//        make.right.equalTo(self.view.mas_right).with.offset(-10);
//    }];
//
//#pragma mark -- 线
//    UILabel * lineLabel6 = [[UILabel alloc] init];
//    lineLabel6.backgroundColor = bgColor;
//    [_scrollView addSubview:lineLabel6];
//    [lineLabel6 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(TheInvitationLable.mas_bottom).with.offset(8);
//        make.left.equalTo(self.view.mas_left).with.offset(10);
//        make.right.equalTo(self.view.mas_right).with.offset(-10);
//        make.height.equalTo(@1);
//    }];
////
#pragma mark -- 拟邀品牌
    UILabel * InviteBrandLable = [[UILabel alloc] init];
    InviteBrandLable.font = midFont;
    InviteBrandLable.text = @"拟邀嘉宾";
    [_scrollView addSubview:InviteBrandLable];
    [InviteBrandLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLabel4.mas_bottom).with.offset(8);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
    }];
//
#pragma mark -- 线
    UILabel * lineLabel7 = [[UILabel alloc] init];
    lineLabel7.backgroundColor = bgColor;
    [_scrollView addSubview:lineLabel7];
    [lineLabel7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(InviteBrandLable.mas_bottom).with.offset(8);
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.height.equalTo(@1);
    }];

    InviteBrLable = [[UILabel alloc] init];
    InviteBrLable.font = bottomFont_12;
    InviteBrLable.textColor = lgrayColor;
    InviteBrLable.numberOfLines = 0;
    InviteBrLable.text = tempDic[@"title"];
    [_scrollView addSubview:InviteBrLable];
    [InviteBrLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineLabel7.mas_bottom).with.offset(10);
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
        make.top.equalTo(InviteBrLable.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
    }];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *comment1 = tempDic[@"activityDetail"];
    NSDictionary *attribute1 = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize size1 = [comment1 boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute1 context:nil].size;
    
    NSString *comment2 = tempDic[@"houseDetail"];
    NSDictionary *attribute2 = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize size2 = [comment2 boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute2 context:nil].size;
    
    _scrollView.contentSize = CGSizeMake(viewWidth, size1.height+size2.height+viewHeight);
}
-(void)buttonClick:(UIButton *)btn
{
    NSString * str3 =[NSString stringWithFormat:@"%@",tempDic[@"activityTime"]];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:MM"];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[NSString stringWithFormat:@"%@",str3] intValue]];
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    ThemeApplyViewController * thVc = [[ThemeApplyViewController alloc] init];
    thVc.actNum = 2;
    thVc.temDic = tempDic;
    
    thVc.confromTimespStr = confromTimespStr;
    thVc.str2 = tempDic[@"activityAddress"];
    thVc.str1 = tempDic[@"title"];
    
    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;
    [self.navigationController pushViewController:thVc animated:YES];
}


-(void)createNvn
{
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"活动详情";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    
//    分享图标
//    UIButton * rightBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.frame = CGRectMake(0, 0, 15, 15);
//    [rightBtn setBackgroundImage:[UIImage imageNamed:@"分享-图标"] forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(GRshareBtn) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem * rigItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem = rigItem;
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //            leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [leftButton.layer setMasksToBounds:YES];
    [leftButton.layer setCornerRadius:10.0];
    leftButton.frame = CGRectMake(20, viewHeight-110, viewWidth/2-40, 40);
    
    if (tempDic[@"isSignup"] == nil)
    {
        [leftButton setTitle:@"立即报名" forState:UIControlStateNormal];
        leftButton.backgroundColor  = [UIColor colorWithRed:(253/255.0) green:(149/255.0) blue:(10/255.0) alpha:(1.0)];
        
    }
    else
    {
        [leftButton setTitle:@"已结束" forState:UIControlStateNormal];
        leftButton.backgroundColor = lgrayColor;
        leftButton.enabled = NO;
        
    }
    
    [leftButton addTarget:self action:@selector(leftButtonDDD:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    UIButton *rightButton   = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (tempDic[@"isSsponsor"] == nil) {
        [rightButton setTitle:@"我要赞助" forState:UIControlStateNormal];
        rightButton.backgroundColor  = [UIColor colorWithRed:(16/255.0) green:(118/255.0) blue:(224/255.0) alpha:(1.0)];
        
    }
    else
    {
        [rightButton setTitle:@"我要赞助" forState:UIControlStateNormal];
        rightButton.backgroundColor = lgrayColor;
        rightButton.enabled = NO;
    }
    //            rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [rightButton.layer setMasksToBounds:YES];
    [rightButton.layer setCornerRadius:10.0];
    rightButton.frame = CGRectMake(20+viewWidth/2, viewHeight-110, viewWidth/2-40, 40);
    [rightButton addTarget:self action:@selector(rightButtonDDD:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
}
#pragma mark - 分享
- (void)GRshareBtn{
    
    [ShareHelper shareIn:self content:@"Hello" url:@"http://www.shangdodo.com"];
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
