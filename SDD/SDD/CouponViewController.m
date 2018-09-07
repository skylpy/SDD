//
//  CouponViewController.m
//  SDD
//  我的折扣券
//  Created by mac on 15/7/21.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "CouponViewController.h"
#import "SlideTabBarView.h"
#import "CouponDetailsViewController.h"
#import "JoinCouponCell.h"
#import "Header.h"
#import "JoinCouponModel.h"
#import "LPYModelTool.h"
#import "UIImageView+AFNetworking.h"
#import "NoDataTips.h"
#import "JoinInBeforeViewController.h"
#import "MJRefresh.h"

@interface CouponViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    SDDButton *SDDbutton;
    NoDataTips * noProject2;
}
@property (strong, nonatomic) SlideTabBarView *slideTabBarView;
@property (assign) NSInteger tabCount;

///@brife TableViews的数据源
@property (strong, nonatomic) NSMutableArray * DuesDataSource;
@property (strong, nonatomic) NSMutableArray * uesDataSource;
@property (strong, nonatomic) NSMutableArray * overdueDataSource;

@end

@implementation CouponViewController

-(NSMutableArray *)DuesDataSource{

    if (!_DuesDataSource) {
        _DuesDataSource = [[NSMutableArray alloc] init];
    }
    return _DuesDataSource;
    
}
-(NSMutableArray *)uesDataSource{
    
    if (!_uesDataSource) {
        _uesDataSource = [[NSMutableArray alloc] init];
    }
    return _uesDataSource;
    
}
-(NSMutableArray *)overdueDataSource{
    
    if (!_overdueDataSource) {
        _overdueDataSource = [[NSMutableArray alloc] init];
    }
    return _overdueDataSource;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createNvn];
    
    _tabCount = 3;
    [self initSlideWithCount:_tabCount];
    
    [self initDataSource];
    
    
}

#pragma mark -- 初始化表格的数据源
-(void) initDataSource{
    
    NSString * path = @"/brandDiscountCoupons/userDiscountCoupons.do";
    NSDictionary * dic = @{@"pageNumber":@0,@"pageSize":@0,@"params":@{@"type":@1}};
    
    [HttpRequest postWithNewIssueURL:SDD_MainURL path:path parameter:dic success:^(id Josn) {
        
        NSDictionary * dict = Josn;
        NSLog(@"%@",dict);
        if (![dict[@"data"] isEqual:[NSNull null]]) {
            
            [self.DuesDataSource removeAllObjects];
            NSArray * array = dict[@"data"];
            for (NSDictionary * dic in array) {
                JoinCouponModel * model = [[JoinCouponModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.DuesDataSource addObject:model];
            }
        }else{
        
            noProject2 = [[NoDataTips alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-64)];
            [noProject2 setText:@"目前暂无优惠券哦,赶快去领取吧~"
                    buttonTitle:@"马上预约"
                      buttonTag:101
                         target:self
                         action:@selector(jumpToReservation:)];
            
            [_slideTabBarView.DuseTableView addSubview:noProject2];
        }
        
        
        [_slideTabBarView.DuseTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
    
    NSDictionary * dic1 = @{@"pageNumber":@0,@"pageSize":@0,@"params":@{@"type":@2}};
    [HttpRequest postWithNewIssueURL:SDD_MainURL path:path parameter:dic1 success:^(id Josn) {
        
        NSDictionary * dict = Josn;
        NSLog(@"%@",dict);
        
        if (![dict[@"data"] isEqual:[NSNull null]]) {
            [self.uesDataSource removeAllObjects];
            NSArray * array = dict[@"data"];
            for (NSDictionary * dic in array) {
                JoinCouponModel * model = [[JoinCouponModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.uesDataSource addObject:model];
            }
        }else{
            
            noProject2  = [[NoDataTips alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-64)];
            [noProject2 setText:@"目前暂无已使用优惠券哦~"];//@"您当前还没有已完成的项目，赶快去完成吧~"];
            
            
            [_slideTabBarView.useTableView addSubview:noProject2];
        }
        
        [_slideTabBarView.useTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
    

    NSDictionary * dic2 = @{@"pageNumber":@0,@"pageSize":@0,@"params":@{@"type":@3}};
    [HttpRequest postWithNewIssueURL:SDD_MainURL path:path parameter:dic2 success:^(id Josn) {
        
        NSDictionary * dict = Josn;
        NSLog(@"%@",dict);
        //判断数组类型 不可以直接用nil ，否则会蹦
        if (![dict[@"data"] isEqual:[NSNull null]]) {
            [self.overdueDataSource removeAllObjects];
            NSArray * array = dict[@"data"];
            for (NSDictionary * dic in array) {
                JoinCouponModel * model = [[JoinCouponModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.overdueDataSource addObject:model];
            }
        }else{

            noProject2  = [[NoDataTips alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-64)];
            [noProject2 setText:@"目前暂无已过期优惠券哦~"];//@"您当前还没有已完成的项目，赶快去完成吧~"];
            
            [_slideTabBarView.overdueTableView addSubview:noProject2];
        }
        
        [_slideTabBarView.overdueTableView reloadData];
    } failure:^(NSError *error) {
        
    }];

}

#pragma mark - 去预约
- (void)jumpToReservation:(UIButton *)btn{

    JoinInBeforeViewController * joinB = [[JoinInBeforeViewController alloc] init];
    
    [self.navigationController pushViewController:joinB animated:YES];
}

#pragma mark -- 没有优惠券数据的时候显示的视图
-(void)createNoAnswerView
{
    
    UIImageView * logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(182/2, 64/2, 138, 138)];
    logoImageView.image = [UIImage imageNamed:@"icon_nodataface"];
    [_slideTabBarView.DuseTableView addSubview:logoImageView];
    
    UILabel * promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(168/2, 64/2+138+40/2, 152, 20)];
    promptLabel.text = @"目前暂无优惠券哦~";
    [promptLabel setTextColor:[UIColor lightGrayColor]];
    promptLabel.font = [UIFont systemFontOfSize:13];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    [_slideTabBarView.DuseTableView addSubview:promptLabel];
    
}

#pragma mark -- 没有抵用券数据的时候显示的视图
-(void)createNorView
{
    
    UIImageView * logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(182/2, 64/2, 138, 138)];
    logoImageView.image = [UIImage imageNamed:@"icon_nodataface"];
    [_slideTabBarView.useTableView addSubview:logoImageView];
    
    UILabel * promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(168/2, 64/2+138+40/2, 152, 20)];
    promptLabel.text = @"目前暂无优惠券哦~";
    [promptLabel setTextColor:[UIColor lightGrayColor]];
    promptLabel.font = [UIFont systemFontOfSize:13];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    [_slideTabBarView.useTableView addSubview:promptLabel];
    
}

-(void) initSlideWithCount: (NSInteger) count{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    screenBound.origin.y = 0;
    
    _slideTabBarView = [[SlideTabBarView alloc] initWithFrame:screenBound WithCount:count];
    
    _slideTabBarView.DuseTableView.delegate = self;
    _slideTabBarView.DuseTableView.dataSource = self;
    
    //[_slideTabBarView.DuseTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(moreData)];
    
    _slideTabBarView.useTableView.delegate = self;
    _slideTabBarView.useTableView.dataSource = self;
    
    _slideTabBarView.overdueTableView.delegate = self;
    _slideTabBarView.overdueTableView.dataSource = self;
    
    [self.view addSubview:_slideTabBarView];
}

-(void)moreData{

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",indexPath.section);
    if(tableView == _slideTabBarView.DuseTableView)
    {
        JoinCouponModel * model = _DuesDataSource[indexPath.section];
        CouponDetailsViewController * couDVc = [[CouponDetailsViewController alloc] init];
        couDVc.state = 1;
        couDVc.model =model;
        [self.navigationController pushViewController:couDVc animated:YES];
    }
    if (tableView == _slideTabBarView.useTableView) {
        JoinCouponModel * model = _uesDataSource[indexPath.section];
        CouponDetailsViewController * couDVc = [[CouponDetailsViewController alloc] init];
        couDVc.state = 2;
        couDVc.model =model;
        [self.navigationController pushViewController:couDVc animated:YES];
    }
    if (tableView == _slideTabBarView.overdueTableView) {
        JoinCouponModel * model = _overdueDataSource[indexPath.section];
        CouponDetailsViewController * couDVc = [[CouponDetailsViewController alloc] init];
        couDVc.state = 3;
        couDVc.model =model;
        [self.navigationController pushViewController:couDVc animated:YES];
    }
}

#pragma mark -- talbeView的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView == _slideTabBarView.DuseTableView) {
        
        return _DuesDataSource.count;
    }
    if (tableView == _slideTabBarView.useTableView) {
        return _uesDataSource.count;
    }
    return _overdueDataSource.count;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //NSMutableArray *tempArray = _dataSource[_currentPage];
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(UITableViewCell *)tableView:tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    JoinCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (cell == nil) {
        cell = [[JoinCouponCell alloc] init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (tableView == _slideTabBarView.DuseTableView) {
        JoinCouponModel * model = _DuesDataSource[indexPath.section];
        if ([[NSString stringWithFormat:@"%@",model.isUsed] integerValue]==0) {
            [cell.useImageView removeFromSuperview];
            [cell.overdueImageView removeFromSuperview];
        }
        if ([[NSString stringWithFormat:@"%@",model.isUsed] integerValue]==1) {
            //indexPath.row==0;
            [cell.overdueImageView removeFromSuperview];
            cell.bobyImageView.image = [Tools_F imageWithColor:[UIColor lightGrayColor] size:CGSizeMake(viewWidth-20, 150/2 )];
        }
        if ([[NSString stringWithFormat:@"%@",model.isUsed] integerValue]==2) {
            
            [cell.useImageView removeFromSuperview];
        }
        
        [cell.HeadImageView setImageWithURL:[NSURL URLWithString:model.brandLogo]];
        cell.nameLable.text = model.brandName;
        
        //将时间戳转为时间
        double lastactivityInterval = [model.endTime doubleValue];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:lastactivityInterval];
        NSString* Str = [formatter stringFromDate:date];
        NSString * dateString = [NSString stringWithFormat:@"有效期至%@",Str];
        cell.EffectiveLabel.text = dateString;
        
        
        NSString* str = [[NSString stringWithFormat:@"%@",model.discount ] substringToIndex:3];
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@折",str]];
        [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:40.0] range:NSMakeRange(0, 3)];//Arial-BoldItalicMT//HelveticaNeue-Bold
        [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:NSMakeRange(3, 1)];
        cell.DiscountLable.attributedText = str1;

    }
    
    else if (tableView == _slideTabBarView.useTableView) {
        JoinCouponModel * model = _uesDataSource[indexPath.section];
        if ([[NSString stringWithFormat:@"%@",model.isUsed] integerValue]==0) {
            [cell.useImageView removeFromSuperview];
            [cell.overdueImageView removeFromSuperview];
        }
        if ([[NSString stringWithFormat:@"%@",model.isUsed] integerValue]==1) {
            //indexPath.row==0;
            [cell.overdueImageView removeFromSuperview];
            cell.bobyImageView.image = [Tools_F imageWithColor:[UIColor lightGrayColor] size:CGSizeMake(viewWidth-20, 150/2 )];
        }
        if ([[NSString stringWithFormat:@"%@",model.isUsed] integerValue]==2) {
            
            [cell.useImageView removeFromSuperview];
        }
        
        [cell.HeadImageView setImageWithURL:[NSURL URLWithString:model.brandLogo]];
        cell.nameLable.text = model.brandName;
        
        //将时间戳转为时间
        double lastactivityInterval = [model.endTime doubleValue];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:lastactivityInterval];
        NSString* Str = [formatter stringFromDate:date];
        NSString * dateString = [NSString stringWithFormat:@"有效期至%@",Str];
        cell.EffectiveLabel.text = dateString;
        
        
         NSString* str = [[NSString stringWithFormat:@"%@",model.discount] substringToIndex:3];
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@折",str]];
        [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:40.0] range:NSMakeRange(0, 3)];//Arial-BoldItalicMT//HelveticaNeue-Bold
        [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:NSMakeRange(3, 1)];
        cell.DiscountLable.attributedText = str1;
    }else{
    
        JoinCouponModel * model = _overdueDataSource[indexPath.section];
        if ([[NSString stringWithFormat:@"%@",model.isUsed] integerValue]==0) {
            [cell.useImageView removeFromSuperview];
            [cell.overdueImageView removeFromSuperview];
        }
        if ([[NSString stringWithFormat:@"%@",model.isUsed] integerValue]==1) {
            //indexPath.row==0;
            [cell.overdueImageView removeFromSuperview];
            cell.bobyImageView.image = [Tools_F imageWithColor:[UIColor lightGrayColor] size:CGSizeMake(viewWidth-20, 150/2 )];
        }
        if ([[NSString stringWithFormat:@"%@",model.isUsed] integerValue]==2) {
            
            [cell.useImageView removeFromSuperview];
        }
        
        [cell.HeadImageView setImageWithURL:[NSURL URLWithString:model.brandLogo]];
        cell.nameLable.text = model.brandName;
        
        //将时间戳转为时间
        double lastactivityInterval = [model.endTime doubleValue];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:lastactivityInterval];
        NSString* Str = [formatter stringFromDate:date];
        NSString * dateString = [NSString stringWithFormat:@"有效期至%@",Str];
        cell.EffectiveLabel.text = dateString;
        
         NSString* str = [[NSString stringWithFormat:@"%@",model.discount ] substringToIndex:3];
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@折",str]];
        [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:40.0] range:NSMakeRange(0, 3)];//Arial-BoldItalicMT//HelveticaNeue-Bold
        [str1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:NSMakeRange(3, 1)];
        cell.DiscountLable.attributedText = str1;
    }
    
    
    return cell;
}


-(void)createNvn
{
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"我的折扣券";
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
