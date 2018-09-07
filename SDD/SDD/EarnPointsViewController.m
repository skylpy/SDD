//
//  EarnPointsViewController.m
//  SDD
//
//  Created by mac on 15/12/1.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "EarnPointsViewController.h"
#import "ExplainViewController.h"
#import "SignInViewController.h"
#import "IntegralReviewViewController.h"
#import "InformationViewController.h"
#import "ParInProViewController.h"
#import "SDCycleScrollView.h"

@interface EarnPointsViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>{

    NSArray * arrTitle;
    NSArray * imageArr;
    
    SDCycleScrollView * headScrollView;
}
@property (retain,nonatomic) UITableView * table;
@property (retain,nonatomic)NSMutableArray *imageArr;
@end

@implementation EarnPointsViewController

-(NSMutableArray *)imageArr{
    
    if (!_imageArr) {
        
        _imageArr = [[NSMutableArray alloc] init];
    }
    return _imageArr;
}

-(void)requestData{
    
    
    //轮播图
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/score/bannerList.do" params:nil success:^(id JSON) {
        
        NSLog(@"轮播图  %@",JSON);
        
        if (![JSON[@"data"] isEqual:[NSNull null]]) {
            
            NSArray * bannerArr = JSON[@"data"];
            
            //imageArr = [NSMutableArray array];
            [self.imageArr removeAllObjects];
            for (NSDictionary *dict in bannerArr) {
                [self.imageArr addObject:dict[@"defaultImage"]];
            }
            headScrollView.imageURLStringsGroup = self.imageArr;
        }
        [_table reloadData] ;
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    [self setNav:@"赚积分"];
    arrTitle = @[@"签到",@"点评",@"完善资料",@"参与问答",@"积分说明"];
    imageArr = @[@"icon-earnpoints-signin",@"icon-earnpoints-remark",@"icon-earnpoints-completedata",@"icon-earnpoints-qa",@"icon-earnpoints-explain"];
    [self setupUI];
    
    [self requestData];
}


-(void)setupUI{

    _table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.backgroundColor = bgColor;
    [self.view addSubview:_table];
    

    UIView * footerView = [[UIView alloc] init];
    _table.tableFooterView = footerView;
    
    
    headScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, viewWidth,120) imageURLStringsGroup:self.imageArr];
    headScrollView.autoScrollTimeInterval = 4;
    headScrollView.infiniteLoop = YES;
    headScrollView.delegate = self;
    headScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    headScrollView.dotColor = tagsColor;
    headScrollView.placeholderImage = [UIImage imageNamed:@"cell_loading"];
    
    _table.tableHeaderView = headScrollView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return arrTitle.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString * cellID = @"cellID";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage imageNamed:imageArr[indexPath.row]];
    cell.textLabel.text = arrTitle[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:{
        
            SignInViewController * siginVc = [[SignInViewController alloc] init];
            [self.navigationController pushViewController:siginVc animated:YES];
        }
            break;
        case 1:{
            
            IntegralReviewViewController * intgRVc = [[IntegralReviewViewController alloc] init];
            [self.navigationController pushViewController:intgRVc animated:YES];
        }
            break;
        case 2:{
            InformationViewController * siginVc = [[InformationViewController alloc] init];
            [self.navigationController pushViewController:siginVc animated:YES];
            
        }
            break;
        case 3:{
            ParInProViewController * siginVc = [[ParInProViewController alloc] init];
            [self.navigationController pushViewController:siginVc animated:YES];
            
        }
            break;
        default:{
            
            ExplainViewController * explanVc = [[ExplainViewController alloc] init];
            [self.navigationController pushViewController:explanVc animated:YES];
        }
            break;
    }

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
