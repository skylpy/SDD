//
//  CouponDetailsViewController.m
//  SDD
//  折扣券详情
//  Created by mac on 15/7/22.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "CouponDetailsViewController.h"
#import "numCouponCell.h"
#import "PrivilegeCell.h"
#import "UIImageView+AFNetworking.h"

@interface CouponDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    //SDDButton *SDDbutton;
}
@property (retain,nonatomic)UITableView * DateilTableView;
@end

@implementation CouponDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.[UIColor colorWithPatternImage:[UIImage imageNamed:@"line"]]
    [self createNvn];
    self.view.backgroundColor = bgColor;
    
    [self createView];
}

-(void)createView
{
    UIImageView * topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 348/2)];
    topImageView.image = [UIImage imageNamed:@"details_frame"];
    [self.view addSubview:topImageView];
    
    
    UIImageView * HeadImageView = [[UIImageView alloc] init];//WithFrame:CGRectMake(266/2, 20/2, 100/2, 100/2)];
    HeadImageView.layer.cornerRadius = 25;
    HeadImageView.clipsToBounds = YES;
    HeadImageView.backgroundColor = [UIColor redColor];
    [HeadImageView setImageWithURL:[NSURL URLWithString:_model.brandLogo]];
    [topImageView addSubview:HeadImageView];
    
    [HeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topImageView.mas_top).with.offset(10);
        make.left.equalTo(topImageView.mas_left).with.offset(viewWidth/2-25);
        //make.right.equalTo(topImageView.mas_right).with.offset(-270/2);
        make.height.equalTo(@50);
        make.width.equalTo(@50);
    }];
    
    
    UILabel * nameLabel = [[UILabel alloc] init];
    nameLabel.text = _model.brandName;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont systemFontOfSize:13];
    [topImageView addSubview:nameLabel];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(HeadImageView.mas_bottom).with.offset(10);
        make.left.equalTo(topImageView.mas_left).with.offset(230/2);
        make.right.equalTo(topImageView.mas_right).with.offset(-230/2);
        make.height.equalTo(@20);
        //make.width.equalTo(@20);
    }];
    
    
    _DiscountLable = [[UILabel alloc] init];
   
    [_DiscountLable setTextColor:[UIColor whiteColor]];
    _DiscountLable.textAlignment = NSTextAlignmentCenter;
    [topImageView addSubview:_DiscountLable];
    
    if (_state == 3) {
        NSString* str = [NSString stringWithFormat:@"%@",_model.discount] ;
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@.0折",str]];
        
        [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:50] range:NSMakeRange(0, 3)];//Arial-BoldItalicMT//HelveticaNeue-Bold//fontWithName:@"HelveticaNeue-Bold" size:15.0
        [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(3, 1)];
        _DiscountLable.attributedText = str1;
    }
   else
   {
       NSString* str = [[NSString stringWithFormat:@"%@",_model.discount] substringToIndex:3];
       NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@折",str]];
       
       [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:50] range:NSMakeRange(0, 3)];//Arial-BoldItalicMT//HelveticaNeue-Bold//fontWithName:@"HelveticaNeue-Bold" size:15.0
       [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(3, 1)];
       _DiscountLable.attributedText = str1;
   }
    
    [_DiscountLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).with.offset(7);
        make.left.equalTo(topImageView.mas_left).with.offset(200/2);
        make.right.equalTo(topImageView.mas_right).with.offset(-200/2);
        make.height.equalTo(@44);
        //make.width.equalTo(@20);
    }];
    
    
    //将时间戳转为时间
    double lastactivityInterval = [_model.endTime doubleValue];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:lastactivityInterval];
    NSString* Str = [formatter stringFromDate:date];
    NSString * dateString = [NSString stringWithFormat:@"有效期至%@",Str];
    
    _EffectiveLabel = [[UILabel alloc] init];
    _EffectiveLabel.text = dateString;
    [_EffectiveLabel setTextColor:[UIColor grayColor]];
    _EffectiveLabel.font = [UIFont systemFontOfSize:13];
    _EffectiveLabel.textAlignment = NSTextAlignmentCenter;
    [topImageView addSubview:_EffectiveLabel];
    
    [_EffectiveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_DiscountLable.mas_bottom).with.offset(10);
        make.left.equalTo(topImageView.mas_left).with.offset(20);
        make.right.equalTo(topImageView.mas_right).with.offset(-20);
        make.height.equalTo(@15);
        //make.width.equalTo(@20);
    }];
    
    
    _DateilTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight) style:UITableViewStyleGrouped];
    _DateilTableView.backgroundColor = bgColor;
    _DateilTableView.delegate = self;
    _DateilTableView.dataSource =self;
    [self.view addSubview:_DateilTableView];
    
    _DateilTableView.tableHeaderView = topImageView;
    
    if ([[NSString stringWithFormat:@"%@",self.model.isUsed] integerValue] == 1) {
        [self stataUseView];
    }
    if ([[NSString stringWithFormat:@"%@",self.model.isUsed] integerValue] == 2) {
        [self stataExpiredView];
    }
}
-(void)stataUseView
{
    UIImageView * useImageView = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth/2-70, 190/2, 280/2, 280/2)];
    useImageView.image = [UIImage imageNamed:@"use_icon"];
    [_DateilTableView addSubview:useImageView];

}

-(void)stataExpiredView
{
    UIImageView * overdueImageView = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth/2-70, 190/2, 280/2, 280/2)];
    overdueImageView.image = [UIImage imageNamed:@"expired_icon"];
    [_DateilTableView addSubview:overdueImageView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 72;
    }
    //ReviewModel *model = _dataArray[indexPath.row];
    NSString *comment = _model.preferentialDescription;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGSize size = [comment boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    return size.height+60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        numCouponCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[numCouponCell alloc] init];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.numLabel.text = _model.discountNumber;
        
        return cell;
    }
    PrivilegeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ceooui"];
    if (cell == nil) {
        cell = [[PrivilegeCell alloc] init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 1) {
        cell.ContentLabel.text = _model.preferentialDescription;
    }
    if (indexPath.section == 2) {
        cell.titLabel.text = @"使用说明";
        cell.ContentLabel.text = _model.usedDescription;
    }
    return cell;
}

-(void)createNvn
{
    //导航条
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"折扣券详情";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
//    //导航条
//    SDDbutton = [[SDDButton alloc]init];
//    SDDbutton.frame = CGRectMake(0, 0, viewWidth*2/3, 44);
//    [SDDbutton setTitle:@"折扣券详情" forState:UIControlStateNormal];
//    [SDDbutton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:SDDbutton];
    
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
