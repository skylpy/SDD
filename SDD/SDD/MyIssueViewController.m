//
//  MyIssueViewController.m
//  SDD
//
//  Created by mac on 15/8/20.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "MyIssueViewController.h"
#import "LPYModelTool.h"
#import "MyIssueModel.h"
#import "MyIssueSlideView.h"
#import "MyIsuuePCell.h"
#import "UIImageView+WebCache.h"
#import "SDD_Preview.h"
#import "JoinInBeforeViewController.h"
#import "BrankAuthenticationViewController.h"
#import "CommonBrandViewController.h"

@interface MyIssueViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (strong, nonatomic) MyIssueSlideView *myIssueSlideView;
@property (assign) NSInteger tabCount;
@property (retain,nonatomic)NSMutableArray * ProjectArray;
@property (retain,nonatomic)UITableView * tabelView;

@property (retain,nonatomic)NSMutableArray * BrandArray;
@end

@implementation MyIssueViewController

-(void)requestData
{

    _ProjectArray = [NSMutableArray array];
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/userHouseFirst/myPublish.do" params:@{@"pageNumber":@0,@"pageSize":@0} success:^(id JSON) {
        
        NSLog(@"%@",JSON);
        
        NSArray *arr = JSON[@"data"];
        if (![arr isEqual:[NSNull null]]) {
            
            for (NSDictionary * dict in arr) {
                MyIssueModel * model = [[MyIssueModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [_ProjectArray addObject:model];
            }
            
        }
        if(arr.count == 0)
        {
            //没有数据的页面
            UIView * NODataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
            
            [_myIssueSlideView.ProjectTableView addSubview:NODataView];;
            
            UIImageView * imageV = [[UIImageView alloc] init];
            imageV.image = [UIImage imageNamed:@"icon_nodataface"];
            [NODataView addSubview:imageV];
            [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(NODataView.mas_top).offset(30);
                make.centerX.equalTo(NODataView.mas_centerX);
                make.size.mas_equalTo(CGSizeMake(135, 135));
            }];
            
            UILabel * label = [[UILabel alloc] init];
            label.font = titleFont_15;
            label.textColor = lgrayColor;
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"您目前还没有项目发布哦~~";
            label.numberOfLines = 0;
            [NODataView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(imageV.mas_bottom).offset(15);
                make.centerX.equalTo(NODataView.mas_centerX);
                make.height.greaterThanOrEqualTo(@14);
                make.width.mas_equalTo(viewWidth-20);
            }];
        }
        [_myIssueSlideView.ProjectTableView reloadData];
        
    } failure:^(NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
    
    _BrandArray = [NSMutableArray array];
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brandUser/myPublish.do" params:@{@"pageNumber":@0,@"pageSize":@0,@"params":@{@"type":@0}} success:^(id JSON) {
        
        NSLog(@"%@",JSON);
        
        NSArray *arr = JSON[@"data"];
        if (![arr isEqual:[NSNull null]]) {
            
            for (NSDictionary * dict in arr) {
                MyIssueModel * model = [[MyIssueModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [_BrandArray addObject:model];
                
            }
            
        }
        if(arr.count == 0)
        {
            //没有数据的页面
            UIView * NODataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
            
            [_myIssueSlideView.BrandTableView addSubview:NODataView];;
            
            UIImageView * imageV = [[UIImageView alloc] init];
            imageV.image = [UIImage imageNamed:@"icon_nodataface"];
            [NODataView addSubview:imageV];
            [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(NODataView.mas_top).offset(30);
                make.centerX.equalTo(NODataView.mas_centerX);
                make.size.mas_equalTo(CGSizeMake(135, 135));
            }];
            
            UILabel * label = [[UILabel alloc] init];
            label.font = titleFont_15;
            label.textColor = lgrayColor;
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
            label.text = @"您目前还没有品牌发布哦~~";
            [NODataView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(imageV.mas_bottom).offset(15);
                make.centerX.equalTo(NODataView.mas_centerX);
                make.height.greaterThanOrEqualTo(@14);
                make.width.mas_equalTo(viewWidth-20);
            }];
        }
        [_myIssueSlideView.BrandTableView reloadData];
        
    } failure:^(NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    //[self createView];
    
    [self createNvn];
    [self requestData];
    
    _tabCount = 2;
    [self initSlideWithCount:_tabCount];

}

-(void) initSlideWithCount: (NSInteger) count{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    screenBound.origin.y = 0;
    
    _myIssueSlideView = [[MyIssueSlideView alloc] initWithFrame:screenBound WithCount:count];
    
    _myIssueSlideView.ProjectTableView.delegate = self;
    _myIssueSlideView.ProjectTableView.dataSource = self;
    _myIssueSlideView.ProjectTableView.backgroundColor = bgColor;
    
    _myIssueSlideView.BrandTableView.delegate = self;
    _myIssueSlideView.BrandTableView.dataSource = self;
    _myIssueSlideView.BrandTableView.backgroundColor = bgColor;
    
    
    [self.view addSubview:_myIssueSlideView];
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }
    else
    {
        return 10;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 145;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _myIssueSlideView.ProjectTableView) {
        return _ProjectArray.count;
    }
    else
    {
        return _BrandArray.count;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cellID";
    MyIsuuePCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[MyIsuuePCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (tableView == _myIssueSlideView.ProjectTableView)
    {
        MyIssueModel * model = _ProjectArray[indexPath.section];
        [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:model.defaultImage] placeholderImage:[UIImage imageNamed:@"loading_l"]];
        cell.titleLabel.text = model.houseName;
        
        //时间戳转时间
        NSString *str=[NSString stringWithFormat:@"%@",model.addTime];//时间戳
        NSTimeInterval time=[str doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        
        NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
        cell.IsuueTimeLabel.text = [NSString stringWithFormat:@"发布时间：%@",currentDateStr];
        
        NSInteger status = [model.status integerValue];
        [cell.statusBtn addTarget:self action:@selector(statusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        switch (status) {
            case -2:
            {
                cell.statusLabel.text = @"您的项目没发布，请尽快完善资料并发布";
                [cell.statusBtn setTitle:@"继续编辑>" forState:UIControlStateNormal];
            }
                break;
            case 0:
            {
                cell.statusLabel.text = @"您的项目正在审核中，如有疑问请致电";
                [cell.statusBtn setTitle:@"预览>" forState:UIControlStateNormal];
            }
                break;
            case 1:
            {
                cell.statusLabel.text = @"发布成功，敬请留意，如有疑问请致电";
                [cell.statusBtn setTitle:@"查看>" forState:UIControlStateNormal];
            }
                break;
            default:
            {
                cell.statusLabel.text = @"发布失败，如有疑问请致电";
                [cell.statusBtn setTitle:@"继续编辑>" forState:UIControlStateNormal];
            }
                break;
        }
        
        [cell.PhoneBtn addTarget:self action:@selector(PhoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else
    {
        MyIssueModel * model = _BrandArray[indexPath.section];
        [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:model.defaultImage] placeholderImage:[UIImage imageNamed:@"loading_l"]];
        cell.titleLabel.text = model.brandName;
        
        //时间戳转时间
        NSString *str=[NSString stringWithFormat:@"%@",model.addTime];//时间戳
        NSTimeInterval time=[str doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        
        NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
        cell.IsuueTimeLabel.text = [NSString stringWithFormat:@"发布时间：%@",currentDateStr];
        
        NSInteger status = [model.status integerValue];
        
        
        
        switch (status) {
            case -2:
            {
                cell.statusLabel.text = @"您的项目没发布，请尽快完善资料并发布";
                [cell.statusBtn setTitle:@"继续编辑>" forState:UIControlStateNormal];
            }
                break;
            case 0:
            {
                cell.statusLabel.text = @"您的项目正在审核中，如有疑问请致电";
                [cell.statusBtn setTitle:@"" forState:UIControlStateNormal];
                
            }
                break;
            case 1:
            {
                cell.statusLabel.text = @"发布成功，敬请留意，如有疑问请致电";
                [cell.statusBtn setTitle:@"查看>" forState:UIControlStateNormal];
                [cell.statusBtn addTarget:self action:@selector(staBankBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            default:
            {
                cell.statusLabel.text = @"发布失败，如有疑问请致电";
                [cell.statusBtn setTitle:@"继续编辑>" forState:UIControlStateNormal];
                [cell.statusBtn addTarget:self action:@selector(staBankFailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
        }
        
        [cell.PhoneBtn addTarget:self action:@selector(PhoneBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

#pragma mark -- 品牌发布失败继续编辑按钮
-(void)staBankFailBtnClick:(UIButton *)btn
{
//    MyIsuuePCell *cell = (MyIsuuePCell *)btn.superview;
//    NSIndexPath *indexPath = [_myIssueSlideView.BrandTableView indexPathForCell:cell];
//    MyIssueModel * model = _BrandArray[indexPath.section];
    BrankAuthenticationViewController *baVC = [[BrankAuthenticationViewController alloc] init];
    
    
    [self.navigationController pushViewController:baVC animated:YES];
}

#pragma mark -- 品牌查看按钮
-(void)staBankBtnClick:(UIButton *)btn
{
    MyIsuuePCell *cell = (MyIsuuePCell *)btn.superview;
    NSIndexPath *indexPath = [_myIssueSlideView.BrandTableView indexPathForCell:cell];
    MyIssueModel * model = _BrandArray[indexPath.section];
    NSLog(@"%@-----%@",model.brandName,model.brandId);
    
    //JoinInBeforeViewController *joinVC = [[JoinInBeforeViewController alloc] init];
    CommonBrandViewController *joinVC = [[CommonBrandViewController alloc] init];
    joinVC.brandId = [NSString stringWithFormat:@"%@",model.brandId];
    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
    [self.navigationController pushViewController:joinVC animated:YES];
}

#pragma mark -- 状态按钮
-(void)statusBtnClick:(UIButton *)btn
{
    MyIsuuePCell *cell = (MyIsuuePCell *)btn.superview;
    NSIndexPath *indexPath = [_myIssueSlideView.ProjectTableView indexPathForCell:cell];
    MyIssueModel * model = _ProjectArray[indexPath.section];
    
    SDD_Preview * sdd_PreView = [[SDD_Preview alloc] init];
    
    sdd_PreView.houseFirstId = [model.houseFirstId integerValue];
    [self.navigationController pushViewController:sdd_PreView animated:YES];
}

#pragma mark 调用拨号
-(void)PhoneBtnClick:(UIButton *)btn
{
    NSString *telNumber = [[NSString alloc] initWithFormat:@"telprompt://%@",@"4009918829"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telNumber]];
}

-(void)createNvn
{
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"我的发布";
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
