//
//  NewActivityViewController.m
//  SDD
//
//  Created by mac on 15/12/1.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "NewActivityViewController.h"
#import "ActivityTableVCell.h"
#import "ActivityTableCell.h"
#import "ActivityNModel.h"
#import "UIImageView+EMWebCache.h"
#import "ActivityDataViewController.h"
#import "InspectViewController.h"

@interface NewActivityViewController ()<UITableViewDataSource,UITableViewDelegate>
{

    NSInteger todayD;
}
@property (retain,nonatomic)UITableView * table;
@property (retain,nonatomic)NSMutableArray * dataArray;
@end

@implementation NewActivityViewController

-(NSMutableArray *)dataArray{

    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

-(void)requestData{

    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/activityForums/list.do" params:@{@"pageNumber":@1,@"pageSize":@10} success:^(id JSON) {
        
        NSLog(@"%@",JSON);
        if (![JSON[@"data"] isEqual:[NSNull null]]) {
            
            for (NSDictionary * dict in JSON[@"data"] ) {
                
                ActivityNModel * model = [ActivityNModel ActivityDict:dict];
                
                [self.dataArray addObject:model];
            }
        }
        [_table reloadData];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    [self setNav:@"活动"];
    
    NSDate *datenow = [NSDate date];  // 获取现在时间
    todayD = (NSInteger)[datenow timeIntervalSince1970];
    
    [self setupUI];
    [self requestData];
}

-(void)setupUI{

    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-20) style:UITableViewStyleGrouped];
    _table.delegate = self;
    _table.dataSource = self;
    _table.backgroundColor = bgColor;
    [self.view addSubview:_table];

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

//    ActivityNModel * model = _dataArray[indexPath.section];
//    CGSize summarySize = [Tools_F countingSize:model.summary fontSize:13 width:viewWidth-20];
//    NSLog(@"%@",model.summary);
    return 280;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString * cellID = @"CELLID";
    ActivityTableCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ActivityTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    ActivityNModel * model = _dataArray[indexPath.section];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"cell_loading"]];//cell_loading
    cell.timeLable.text = [Tools_F timeTransform:[model.time intValue] time:minutes];
    cell.addressLable.text = model.addressShort;
    cell.invitationLable.text = model.summary;
    cell.titleLable.text = model.title;
    
    cell.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",(todayD - [model.time integerValue]) < 0 ? @"act-tip-rigsting":@"act-tip-rigover"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    ActivityNModel * model = _dataArray[indexPath.section];
    
    if ([model.type integerValue] == 0) {
        
        ActivityDataViewController * actVc = [[ActivityDataViewController alloc] init];
        
        actVc.activityId = model.activityId;
        actVc.titles = model.title;
        actVc.model = model;
        actVc.isSignup = model.isSignup;
        actVc.isSponsor = model.isSponsor;
        actVc.activityTime = model.time;
        [self.navigationController pushViewController:actVc animated:YES];
        
    }else{
    
        InspectViewController * insVc = [[InspectViewController alloc] init];
        insVc.titles = model.title;
        insVc.model = model;
        [self.navigationController pushViewController:insVc animated:YES];
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
