//
//  ProjectReleViewController.m
//  SDD
//
//  Created by mac on 15/9/29.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ProjectReleViewController.h"
#import "ProPhoneTableCell.h"
#import "OnLineTableCell.h"
#import "ProcessTableCell.h"
#import "ImageTableCell.h"
#import "ButtonCell.h"
#import "UnfoldTableCell.h"
#import "headBtn.h"
#import "SDD_BasicInformation.h"
#import "DevCerViewController.h"
#import "UserInfo.h"
#import "BrankPublishViewController.h"

@interface ProjectReleViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    BOOL isOpen;
    NSInteger selectedIndex;
    
    NSMutableArray * titleQuestArray;
    
    NSMutableArray * gounpAnswerArray;
    
    NSMutableArray * selectedArr;
    
    NSInteger isHouseUser;      // 是否发展商
    NSInteger isBrandUser;      // 是否品牌商
    
    NSInteger houseTotal;       //项目发布数量
    
    NSString * PhoneStr;
    
    UILabel * topLable;
    
    NSString *originalString;                       // 原文本
    NSMutableAttributedString *paintString;         // 富文本
}
@property (retain,nonatomic)UITableView * tableView;

@property (retain,nonatomic)UITableView * footTableView;


@end

@implementation ProjectReleViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self requestUserInfo];
    
}
#pragma mark - 用户信息
- (void)requestUserInfo{
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/user/detail.do" params:nil success:^(id JSON) {
        //            NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSDictionary *dict = JSON[@"data"];
        
        if (![dict isEqual:[NSNull null]]) {
            
            isBrandUser = [dict[@"isBrandUser"] integerValue];
            isHouseUser = [dict[@"isHouseUser"] integerValue];
        }
    } failure:^(NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
}
#pragma mark - 用户数量
-(void)requestData
{
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/reservationPublish/countAll.do" params:nil success:^(id JSON) {
        //            NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSDictionary *dict = JSON[@"data"];
        
        NSLog(@"%@",JSON);
        
        if (![dict isEqual:[NSNull null]]) {
            
            houseTotal = [dict[@"houseTotal"] integerValue];
            //topLable.text =[NSString stringWithFormat:@"已有 %ld 位发展商成功发布项目",houseTotal] ;
            originalString = [NSString stringWithFormat:@"已有 %ld 位发展商成功发布项目",
                              houseTotal];
            paintString = [[NSMutableAttributedString alloc] initWithString:originalString];
            [paintString addAttribute:NSForegroundColorAttributeName
                                value:tagsColor
                                range:[originalString
                                       rangeOfString:[NSString stringWithFormat:@"%ld",houseTotal]]];
//            topLable.attributedText = paintString;
        }
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = bgColor;
    selectedArr = [[NSMutableArray alloc] init];
    PhoneStr = [UserInfo sharedInstance].userInfoDic[@"phone"];
    isOpen = NO;
    selectedIndex = 0;
    
    isHouseUser = 0;
    isBrandUser = 0;
    houseTotal = 0;
    [self createNvn];
    [self createView];
    [self initDataSource];
    [self requestData];
}

-(void)initDataSource{
    titleQuestArray = [[NSMutableArray alloc] initWithObjects:@"1.商多多是谁？",@"2.发布项目需要符合怎样的条件？",@"3.发布项目需要准备什么？",@"4.在线发布流程是怎样的？",@"5.是否收取费用？",@"6.发布项目带来什么价值？",@"7.预约发布和在线发布有什么区别？", nil];
    
    gounpAnswerArray = [[NSMutableArray alloc] initWithObjects:@"商多多——商业地产（招商+加盟）定制平台！\n【服务开发商】：推荐优质品牌及加盟商，业态科学组合，强化持续竞争力\n【服务品牌商】：推荐优质品牌商及项目场地，实现全国高效快速扩张\n【服务加盟商】：推荐优质品牌及项目场地，把握风险控制，快速匹配商机",@"项目需持有国家规定的《国有土地使用权证》、《建设用地规划许可证》、《建设工程规划许可证》、《建筑工程施工许可证》等证件，确保发布的信息与项目属实。",@"A、发布人身份证\nB、所发布项目的效果图",@"1.填写基本资料进行发展商认证，认证通过后即可发布项目。\n2.填写项目基本资料、项目详情、上传资料，审核通过后即可上线。",@"项目免费发布推广",@"1、针对全国近万家品牌定向推广，节省近千万广告价值\n2、全国全行业无间隙覆盖招商，为项目提供增值增量，快速实现价值匹配招商\n3、品牌商开发人员迅速与项目形成高效联动，降低考察及决策周期",@"A、预约发布：只需输入您的手机号，30分钟内我们的工作人员会与您取得联系。\nB、在线发布：在线填写基本信息、项目详细、上传资料实时审核，审核通过后即可上线。", nil];
}

-(void)createView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = bgColor;
    [self.view addSubview:_tableView];
    
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 200)];
    topView.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = topView;
    
    UIImageView * topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 200)];
    //topImageView.backgroundColor = [UIColor blackColor];
    topImageView.image = [UIImage imageNamed:@"brand10.jpg"];
    [topView addSubview:topImageView];
    
    topLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 205, viewWidth-20, 20)];
    topLable.font = titleFont_15;
    [topView addSubview:topLable];
    
    
    
    
    //UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 300)];
    
    
    _footTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 500) style:UITableViewStyleGrouped];
    _footTableView.delegate = self;
    _footTableView.dataSource = self;
    _footTableView.backgroundColor = bgColor;
    //_footTableView.scrollEnabled = NO;
    _tableView.tableFooterView = _footTableView;
    
    UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 80)];
    footView.backgroundColor = [UIColor whiteColor];
    _footTableView.tableFooterView = footView ;
    
    UIView * minView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 10)];
    minView.backgroundColor = bgColor;
    [footView addSubview:minView];
    
    UIButton * conBrandBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [conBrandBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    conBrandBtn.tag = 1100;
    [conBrandBtn setBackgroundImage:[Tools_F imageWithColor:dblueColor
                                                       size:CGSizeMake(viewWidth-40, 45)]
                           forState:UIControlStateNormal];
    
    [conBrandBtn setBackgroundImage:[Tools_F imageWithColor:[SDDColor colorWithHexString:@"006699"]
                                                       size:CGSizeMake(viewWidth-40, 45)]
                           forState:UIControlStateHighlighted];
    [Tools_F setViewlayer:conBrandBtn cornerRadius:5 borderWidth:1 borderColor:dblueColor];
    [footView addSubview:conBrandBtn];
    
    [conBrandBtn setTitle:@"预约发布" forState:UIControlStateNormal];
    
    [conBrandBtn addTarget:self action:@selector(conBrandBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [conBrandBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footView.mas_top).with.offset(20);
        make.left.equalTo(footView.mas_left).with.offset(20);
        make.right.equalTo(footView.mas_right).with.offset(-20);
        make.height.equalTo(@45);
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        if (section == 5) {
            return 10;
        }
        else
        {
            return 0.01;
        }
    }
    else
    {
        
        return 0.01;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _footTableView) {
        return 50;
    }
    else
    {
        if (section == 2) {
            return 40;
        }
        else
        {
            return 10;
        }

    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        switch (indexPath.section) {
            case 0:
            case 1:
                return 120;
                break;
            case 2:
                return 120;
                break;
            default:
                return 200;
                break;
        }

    }
    else
    {
        NSString *comment = gounpAnswerArray[indexPath.section];
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
        CGSize size = [comment boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        
        return size.height+50;
        //return 100;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _footTableView) {
        return  titleQuestArray.count;
    }
    else
    {
        return 6;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        switch (section) {
            case 6:
                return 7;
                break;
                
            default:
                return 1;
                break;
        }
    }
    else
    {
        NSString *string = [NSString stringWithFormat:@"%ld",section];
        
        if ([selectedArr containsObject:string]) {
            
            return 1;
        }
        return 0;
    }
    
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        switch (indexPath.section) {
            case 0:
            {
                static NSString * cellId = @"cellYY";
                ProPhoneTableCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (!cell) {
                    cell = [[ProPhoneTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.PhoneBtn setTitle:@"预约发布" forState:UIControlStateNormal];
                [cell.PhoneBtn addTarget:self action:@selector(PhoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.textField.placeholder = [NSString stringWithFormat:@"  %@",PhoneStr];
                
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(textFieldChanged:)
                                                             name:UITextFieldTextDidChangeNotification
                                                           object:cell.textField];
                return cell;
            }
                break;
            case 1:
            {
                static NSString * cellId = @"cellZX";
                OnLineTableCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (!cell) {
                    cell = [[OnLineTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.OnLineBtn setTitle:@"在线发布" forState:UIControlStateNormal];
                [cell.OnLineBtn addTarget:self action:@selector(OnLineBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
                break;
            case 2:
            {
                static NSString * cellId = @"cellLC";
                ProcessTableCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (!cell) {
                    cell = [[ProcessTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
                break;
                
            default:
            {
                static NSString * cellId = @"cellIm";
                ImageTableCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (!cell) {
                    cell = [[ImageTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.imageIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"brand0%ld.jpg",indexPath.section-2]];
                return cell;
            }
                break;
        }
        
       
    }
    else
    {
        static NSString * cellId = @"cellID";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@",gounpAnswerArray[indexPath.section]];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = titleFont_15;
        return cell;
    }
    
}

-(void)conBrandBtnClick:(UIButton *)btn
{
    
//    UITableViewCell *cell ;//= (UITableViewCell *)btn.superview;
//    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
//    [_tableView scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
     [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark -- UItextFild监控值得变化
-(void)textFieldChanged:(NSNotification *)notification
{
    UITextField *textfield=[notification object];
    PhoneStr = textfield.text;
}
//预约发布
-(void)PhoneBtnClick:(UIButton *)btn
{
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/reservationPublish/save.do" params:@{@"reservationPhone":PhoneStr,@"type":@0} success:^(id JSON) {
        //            NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        //NSDictionary *dict = JSON[@"data"];
        if ([JSON[@"status"] integerValue] == 1) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:JSON[@"message"] delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//            [alert show];
            [self showDataWithText:@"预约成功！\n我们的工作人员尽快与您联系" buttonTitle:@"确定" buttonTag:123 target:self action:@selector(alertClick:)];
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];

}
-(void)alertClick:(UIButton *)btn
{
    [self.bigView removeFromSuperview];
    [self.minView removeFromSuperview];
}

//在线发布
-(void)OnLineBtnClick:(UIButton *)btn
{

    if (isHouseUser == 0) {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲，您当前还未申请发展商认证，认证后即可在线发布项目哦！" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];//大人！您还没认证，请先去认证再来发布吧！
        alert.tag = 100;
        [alert show];
    }
    else if (isHouseUser == 1){
        
        SDD_BasicInformation *itemVC  =[[SDD_BasicInformation alloc] init];
        
        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
        [self.navigationController pushViewController:itemVC animated:YES];
    }
    else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的认证正在审核中哦" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }
}

//设置view，将替代titleForHeaderInSection方法
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _footTableView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 50)];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, tableView.frame.size.width-45, 50)];
        titleLabel.numberOfLines = 2;
        titleLabel.font = titleFont_15;
        titleLabel.text = [titleQuestArray objectAtIndex:section];
        [view addSubview:titleLabel];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 12, 15, 15)];
        imageView.tag = 20000+section;
        
        //判断是不是选中状态
        //    NSString *string = [NSString stringWithFormat:@"%d",section];
        
        
        
        headBtn *button = [headBtn buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(0, 0, viewWidth, 50);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = 100+section;
        [button addTarget:self action:@selector(doButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"below2"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"below"] forState:UIControlStateSelected];
        [view addSubview:button];
        
        NSString *string = [NSString stringWithFormat:@"%ld",section];
        if ([selectedArr containsObject:string])
        {
            button.selected = YES;
        }
        else
        {
            button.selected = NO;
        }
        
        UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 49, viewWidth, 1)];
        lineImage.image = [UIImage imageNamed:@"line.png"];
        [view addSubview:lineImage];
        
        return view;
    }
    else
    {
        if (section == 2) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 40)];
            
            for (UIView * view_bg in view.subviews) {
                
                [view_bg removeFromSuperview];
            }
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 40)];
            titleLabel.font = titleFont_15;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [view addSubview:titleLabel];
            
            NSMutableAttributedString *strTime = [[NSMutableAttributedString alloc] initWithString:@"资询电话：400-991-8829"];
            
            [strTime addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,5)];
            
            [strTime addAttribute:NSForegroundColorAttributeName value:dblueColor range:NSMakeRange(5,12)];
            titleLabel.attributedText = strTime;
            titleLabel.userInteractionEnabled = YES;
            
            UITapGestureRecognizer * taptitle = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taptitleClick:)];
            [titleLabel addGestureRecognizer:taptitle];
            
            return view;
            
        }
        else
        {
            UIView * view1 = [[UIView alloc] init];
            
            return view1;
        }
    }
}

-(void)taptitleClick:(UITapGestureRecognizer *)tap{
    
    NSString *telNumber = [[NSString alloc] initWithFormat:@"telprompt://%@",@"4009918829"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telNumber]];
}

-(void)doButton:(headBtn *)sender
{
    NSString *string = [NSString stringWithFormat:@"%d",sender.tag-100];
    
    //sender.selected = YES;
    //数组selectedArr里面存的数据和表头想对应，方便以后做比较
    if ([selectedArr containsObject:string])
    {
        [selectedArr removeObject:string];
    }
    else
    {
        [selectedArr addObject:string];
    }
    
    [_footTableView reloadData];
}

#pragma mark - alertView代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 1:
        {
            switch (alertView.tag) {
                case 100:
                {
                    
                    //CertifyFirstStep * cerVc = [[CertifyFirstStep alloc] init];
                    DevCerViewController * cerVc = [[DevCerViewController alloc] init];
                    
                    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
                    [self.navigationController pushViewController:cerVc animated:YES];
                }
                    break;
                case 101:
                {
                    
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

-(void)createNvn
{
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"项目发布";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
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
