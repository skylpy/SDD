//
//  XDJoinDetailViewController.m
//  SDD
//  预约详情（预约加盟之后显示）
//  Created by hua on 15/12/29.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "XDJoinDetailViewController.h"
#import "MyJoinInViewController.h"

#import "PreferentialJoinDetailViewController.h"
#import "PreferentialJoinDetailMoreViewController.h"
#import "DirectNormalViewController.h"
#import "DirectNormalMoreViewController.h"
#import "NormalJoinViewController.h"
#import "NormalJoinMoreViewController.h"


@interface XDJoinDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

/********************* UI *************************/
@property(nonatomic,strong) UITableView *stateTableView;

@property(nonatomic,strong) UIView *headView; //头部View

@property(nonatomic,strong) UILabel *titleLabel; //九龙冰室
@property(nonatomic,strong) UILabel *couponLabel; //优惠券号
@property(nonatomic,strong) UILabel *couponContentLabel; //4622623823（优惠券号内容）
@property(nonatomic,strong) UILabel *discountLabel; //额外优惠
@property(nonatomic,strong) UILabel *discountContentLabel; //8.5折加盟优惠（额外优惠内容）

@property(nonatomic,strong) UILabel *brandLabel; //品牌：蒙自源过桥米线
@property(nonatomic,strong) UILabel *nameLabel; //姓名：刘晓光
@property(nonatomic,strong) UILabel *sexLabel;  //性别：先生
@property(nonatomic,strong) UILabel *phoNumLabel; //手机号：18998989898
@property(nonatomic,strong) UILabel *companyLabel; //公司：广州市九合飞一
@property(nonatomic,strong) UILabel *positionLabel; //职位：总经理
@property(nonatomic,strong) UILabel *brandOperationLabel; //经营品牌：九龙冰室
@property(nonatomic,strong) UILabel *industryLabel; //意向行业
@property(nonatomic,strong) UILabel *budgetLabel;  //投资预算
@property(nonatomic,strong) UIImageView *stateImageView; //显示预约状态

/********************* Data *************************/

@end

@implementation XDJoinDetailViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
//        if (self.bookingType == BookingTypeBooking) {
//            NSDate *date = [[NSDate alloc]initWithTimeIntervalSinceNow:0];
//            NSTimeInterval time = [Tools_F cTimestampFromDate:date];
//            NSString *timeStr = [Tools_F timeTransform:time time:minutes];
//            _dataArray = [[NSMutableArray alloc]initWithArray:@[@{@"title":@"成功预约",@"time":timeStr}]];
//        }else{
//            _dataArray = [[NSMutableArray alloc]initWithArray:@[@""]];
//        }
        _dataArray = [[NSMutableArray alloc]initWithArray:@[@{@"title":@"",@"time":@""}]];
    }
    return _dataArray;
}

#pragma mark
#pragma mark 设置预约进度条显示状态
- (void)setBookingType:(BookingType )bookingType
{
    _bookingType = bookingType;
    if (bookingType == BookingTypeBooking) {
        self.stateImageView.image = [UIImage imageNamed:@"icon-order-progress1"];
    }else if (bookingType == BookingTypeSigned) {
        self.stateImageView.image = [UIImage imageNamed:@"icon-order-progress2"];
    }else if (bookingType == BookingTypeVisit) {
        self.stateImageView.image = [UIImage imageNamed:@"icon-order-progress3"];
    }
}

- (void)getData
{
    //假数据
    self.bookingType = BookingTypeBooking;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewSetup];
    
    [self getData];
}

- (void)viewSetup
{
    [self setNav];
    self.stateTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-self.navigationController.navigationBar.height-20) style:UITableViewStylePlain];
    self.stateTableView.delegate = self;
    self.stateTableView.dataSource = self;
    self.stateTableView.rowHeight = 61;
    self.stateTableView.backgroundColor = ldivisionColor;
    [self.view addSubview:self.stateTableView];
    
    self.stateTableView.tableHeaderView = self.headView;
//    [self setHeadViewData];
    
    self.stateTableView.tableFooterView = [self footView];
}

#pragma mark
#pragma mark 设置headView里面的数据
- (void)setHeadViewData
{
    /*
     * 假数据
     */
    self.titleLabel.text = @"九龙冰室";
    self.couponContentLabel.text = @"4622623823";
    self.discountContentLabel.text = @"8.5折加盟优惠";
    
    self.brandLabel.text = @"品牌：蒙自源过桥米线";
    self.nameLabel.text = @"姓名：刘晓光";
    self.sexLabel.text = @"性别：先生";
    self.phoNumLabel.text = @"手机号：18998989898";
    self.companyLabel.text = @"公司：广州市九合飞一";
    self.positionLabel.text = @"职位：总经理";
    self.brandOperationLabel.text = @"经营品牌：九龙冰室";
    self.industryLabel.text = @"意向行业：餐饮美食";
    self.budgetLabel.text = @"投资预算：20-50万";
}

#pragma mark headView
- (UIView *)headView
{
    if (!_headView) {
        
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, 416)];
        _headView.backgroundColor = [UIColor whiteColor];
        
        //title
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 44.5)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        self.titleLabel.textColor = mainTitleColor;
        self.titleLabel.text = self.titleLabelStr;
        [_headView addSubview:self.titleLabel];
        
        [_headView addSubview:[self lineViewWithFrame:CGRectMake(0, 44.5, viewWidth, 0.5)]];
        
        //优惠券号
        self.couponLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 65, 44.5)];
        self.couponLabel.font = midFont;
        self.couponLabel.textColor = mainTitleColor;
        self.couponLabel.text = @"优惠券号:";
        [_headView addSubview:self.couponLabel];
        
        self.couponContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 45, viewWidth-75, 44.5)];
        self.couponContentLabel.font = midFont;
        self.couponContentLabel.textColor = tagsColor;
        self.couponContentLabel.text = self.couponContentLabelStr;
        [_headView addSubview:self.couponContentLabel];
        
        [_headView addSubview:[self lineViewWithFrame:CGRectMake(0, 89.5, viewWidth, 0.5)]];
        
        //额外优惠
        self.discountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 89.5, 65, 44.5)];
        self.discountLabel.font = midFont;
        self.discountLabel.textColor = mainTitleColor;
        self.discountLabel.text = @"额外优惠:";
        [_headView addSubview:self.discountLabel];
        
        self.discountContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 89.5, viewWidth-75, 44.5)];
        self.discountContentLabel.font = midFont;
        self.discountContentLabel.textColor = tagsColor;
        self.discountContentLabel.text = self.discountContentLabelStr;
        [_headView addSubview:self.discountContentLabel];
        
        [_headView addSubview:[self lineViewWithFrame:CGRectMake(0, 135, viewWidth, 11)]];
        
        //品牌
        self.brandLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 155, viewWidth, 20)];
        self.brandLabel.font = midFont;
        self.brandLabel.textColor = mainTitleColor;
        self.brandLabel.text = [NSString stringWithFormat:@"品牌: %@",self.brandLabelStr];
        [_headView addSubview:self.brandLabel];
        
        //姓名
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 175, viewWidth, 20)];
        self.nameLabel.font = midFont;
        self.nameLabel.textColor = mainTitleColor;
        self.nameLabel.text = [NSString stringWithFormat:@"姓名: %@",self.nameLabelStr];
        [_headView addSubview:self.nameLabel];
        
        //性别
        self.sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 195, viewWidth, 20)];
        self.sexLabel.font = midFont;
        self.sexLabel.textColor = mainTitleColor;
        self.sexLabel.text = [NSString stringWithFormat:@"性别: %@",self.sexLabelStr];
        [_headView addSubview:self.sexLabel];
        
        //手机号
        self.phoNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 215, viewWidth, 20)];
        self.phoNumLabel.font = midFont;
        self.phoNumLabel.textColor = mainTitleColor;
        self.phoNumLabel.text = [NSString stringWithFormat:@"手机号: %@",self.phoNumLabelStr];
        [_headView addSubview:self.phoNumLabel];
        
        //公司
        self.companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 235, viewWidth, 20)];
        self.companyLabel.font = midFont;
        self.companyLabel.textColor = mainTitleColor;
        self.companyLabel.text = [NSString stringWithFormat:@"公司: %@",self.companyLabelStr];
        [_headView addSubview:self.companyLabel];
        
        //职位
        self.positionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 255, viewWidth, 20)];
        self.positionLabel.font = midFont;
        self.positionLabel.textColor = mainTitleColor;
        self.positionLabel.text = [NSString stringWithFormat:@"职位: %@",self.positionLabelStr];
        [_headView addSubview:self.positionLabel];
        
        //经营品牌
        self.brandOperationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 275, viewWidth, 20)];
        self.brandOperationLabel.font = midFont;
        self.brandOperationLabel.textColor = mainTitleColor;
        self.brandOperationLabel.text = [NSString stringWithFormat:@"经营品牌: %@",self.brandOperationLabelStr];
        [_headView addSubview:self.brandOperationLabel];
        
        //意向行业
        self.industryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 295, viewWidth, 20)];
        self.industryLabel.font = midFont;
        self.industryLabel.textColor = mainTitleColor;
        self.industryLabel.text = [NSString stringWithFormat:@"意向行业: %@",self.industryLabelStr];
        [_headView addSubview:self.industryLabel];
        
        //投资预算
        self.budgetLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 315, viewWidth, 20)];
        self.budgetLabel.font = midFont;
        self.budgetLabel.textColor = mainTitleColor;
        self.budgetLabel.text = [NSString stringWithFormat:@"投资预算: %@",self.budgetLabelStr];
        [_headView addSubview:self.budgetLabel];
        
        [_headView addSubview:[self lineViewWithFrame:CGRectMake(0, 345, viewWidth, 11)]];
        
        //进度状态
        self.stateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 370, viewWidth-40, 15)];
        self.stateImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self setBookingType:self.bookingType];
        [_headView addSubview:self.stateImageView];
        
        NSArray *arr = @[@"预约",@"到访",@"签约"];
        for(int i=0 ;i<3 ;i++)
        {
            CGFloat width = viewWidth/3;
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(width*i, 390, width, 10)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = littleFont;
            label.textColor = mainTitleColor;
            label.text = arr[i];
            [_headView addSubview:label];
        }
        
        
        [_headView addSubview:[self lineViewWithFrame:CGRectMake(0, 415, viewWidth, 0.5)]];
        
    }
    return _headView;
}

#pragma mark footView
- (UIView *)footView
{
    UIView *footView = [self lineViewWithFrame:CGRectMake(0, 0, viewWidth, 95)];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 15, viewWidth-40, 45);
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    btn.titleLabel.font = largeFont;
    [btn setBackgroundColor:dblueColor];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"进入品牌加盟" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(bottomBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btn];
    
    return footView;
}

#pragma mark 返回灰色分割线
- (UIView*)lineViewWithFrame:(CGRect)frame
{
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = ldivisionColor;
    return view;
}

#pragma mark
#pragma mark tableDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"XDJoinDetailTableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.textLabel.font = midFont;
        cell.textLabel.textColor = mainTitleColor;
        cell.detailTextLabel.font = midFont;
        cell.detailTextLabel.textColor = lgrayColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.textLabel.text = dic[@"title"];
    cell.detailTextLabel.text = dic[@"time"];
    return cell;
}

#pragma mark
#pragma mark 进入品牌加盟按钮点击
- (void)bottomBtnClick
{
    MyJoinInViewController *vc = [[MyJoinInViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark
#pragma mark --  导航条返回按钮
-(void)setNav{
    
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"预约详情";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

#pragma mark 返回按钮点击
-(void)backBtnClick
{
    if (self.backType == BackTypeNormal) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (self.backType == BackTypeDetail) {
        for (UIViewController *vc in self.navigationController.childViewControllers) {
            if ([vc isKindOfClass:[PreferentialJoinDetailViewController class]] || [vc isKindOfClass:[PreferentialJoinDetailMoreViewController class]] || [vc isKindOfClass:[DirectNormalViewController class]] || [vc isKindOfClass:[DirectNormalMoreViewController class]] || [vc isKindOfClass:[NormalJoinViewController class]] || [vc isKindOfClass:[NormalJoinMoreViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }
}

@end
