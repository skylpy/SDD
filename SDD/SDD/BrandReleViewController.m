//
//  BrandReleViewController.m
//  SDD
//
//  Created by mac on 15/10/9.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "BrandReleViewController.h"
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
#import "BrandProcessTableCell.h"
#import "BrankAuthenticationViewController.h"
#import "BrankPublishViewController.h"

@interface BrandReleViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    BOOL isOpen;
    NSInteger selectedIndex;
    
    NSMutableArray * titleQuestArray;
    
    NSMutableArray * gounpAnswerArray;
    
    NSMutableArray * selectedArr;
    
    NSInteger isHouseUser;      // 是否发展商
    NSInteger isBrandUser;      // 是否品牌商
    
    NSInteger brandTotal;       //项目发布数量
    
    NSString * PhoneStr;
    
    UILabel * topLable;
    
    NSString *originalString;                       // 原文本
    NSMutableAttributedString *paintString;         // 富文本
}
@property (retain,nonatomic)UITableView * tableView;

@property (retain,nonatomic)UITableView * footTableView;



@end

@implementation BrandReleViewController


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
            
            brandTotal = [dict[@"brandTotal"] integerValue];
            //topLable.text =[NSString stringWithFormat:@"已有 %ld 位发展商成功发布项目",houseTotal] ;
            originalString = [NSString stringWithFormat:@"已有 %ld 位品牌商成功发布项目",
                              brandTotal];
            paintString = [[NSMutableAttributedString alloc] initWithString:originalString];
            [paintString addAttribute:NSForegroundColorAttributeName
                                value:tagsColor
                                range:[originalString
                                       rangeOfString:[NSString stringWithFormat:@"%ld",brandTotal]]];
//            topLable.attributedText = paintString;
        }
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = bgColor;
    selectedArr = [[NSMutableArray alloc] init];
    PhoneStr = [UserInfo sharedInstance].userInfoDic[@"phone"];
    isOpen = NO;
    selectedIndex = 0;
    
    isHouseUser = 0;
    isBrandUser = 0;
    brandTotal = 0;
    [self createNvn];
    [self createView];
    [self initDataSource];
    [self requestData];
}

-(void)initDataSource{
    titleQuestArray = [[NSMutableArray alloc] initWithObjects:@"1.商多多是谁？",@"2.发布品牌需要符合怎样的条件？",@"3.在线发布流程是怎样的？",@"4.发布品牌需要准备什么？",@"5.发布品牌带来什么价值？",@"6.是否收取费用？",@"7.预约发布和在线发布有什么区别？", nil];
    
    gounpAnswerArray = [[NSMutableArray alloc] initWithObjects:@"商多多——商业地产（招商+加盟）定制平台！\n【服务开发商】：推荐优质品牌及加盟商，业态科学组合，强化持续竞争力\n【服务品牌商】：推荐优质品牌商及项目场地，实现全国高效快速扩张\n【服务加盟商】：推荐优质品牌及项目场地，把握风险控制，快速匹配商机",@"发布的信息必须与品牌属实",@"A.填写基本资料进行品牌商认证，认证通过后即可发布品牌。\nB.填写品牌基本资料、品牌详情、上传资料，审核通过后即可上线。",@"A．企业基本资料\nB.需求类别\nC.品牌信息\nD.品牌开发人员信息\nE.拓展区域信息\nF.投资分析信息。",@"A.全国全行业渠道推广，节省近千万广告价值\nB.针对全国近万个商业项目定向推广，一键定制需求\nC.近百万优质加盟商关注，快速高效拓展\nD.随时随地预约看铺，享最低优惠",@"A方式一：优质品牌入驻平台发布品牌信息，进行全国范围内推广。（需发送品牌资料审核、前一年免费试用）\nB.方式二：品牌商给加盟商享受额外加盟优惠（见协议、平台不收费），",@"A、预约发布：只需输入您的手机号，30分钟内我们的工作人员会与您取得联系。\nB、在线发布：在线填写基本信息、项目详细、上传资料实时审核，审核通过后即可上线。", nil];
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
    topImageView.image = [UIImage imageNamed:@"top.jpg"];
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
        if (section == 6) {
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
        return 7;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        switch (section) {
            case 6:
                return 1;
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
                BrandProcessTableCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (!cell) {
                    cell = [[BrandProcessTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
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
                cell.imageIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"bra0%ld.jpg",indexPath.section-2]];
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
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/reservationPublish/save.do" params:@{@"reservationPhone":PhoneStr,@"type":@1} success:^(id JSON) {
       
        if ([JSON[@"status"] integerValue] == 1) {

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
    if (isBrandUser == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲，您当前还未申请品牌商认证，认证后即可在线发布项目哦！" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];//大人！您还没认证，请先去认证再来发布吧！
        alert.tag = 101;
        [alert show];
    }
    else if (isBrandUser == 1){
        
        BrankPublishViewController *bpVC = [[BrankPublishViewController alloc] init];
        [self.navigationController pushViewController:bpVC animated:YES];
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
            
//
            
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
                    BrankAuthenticationViewController *baVC = [[BrankAuthenticationViewController alloc] init];
                    
                    [self.navigationController pushViewController:baVC animated:YES];
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
    titleLabel.text = @"品牌发布";
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
