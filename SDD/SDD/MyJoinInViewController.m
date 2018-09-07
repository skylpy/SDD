//
//  MyJoinInViewController.m
//  SDD
//
//  Created by hua on 15/7/2.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "MyJoinInViewController.h"
#import "NSString+SDD.h"

//#import "JoinInViewController.h"
#import "JoinInBeforeViewController.h"
#import "MyCollectionTableViewCell.h"
#import "JoinDetailViewController.h"

#import "UIImageView+WebCache.h"

#import "XDJoinDetailViewController.h"

#import "PersonalViewController.h"

@interface MyJoinInViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>{
    
    /*- ui -*/
    
    UITableView *table;
}

// 数据源
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation MyJoinInViewController

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

#pragma mark - 请求数据
- (void)requestData{
    
    // 请求参数
    NSDictionary *param = @{};
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brandUser/myJoined.do" params:param success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSDictionary *dict = JSON[@"data"];
        
        if (![dict isEqual:[NSNull null]]) {
            
            [_dataSource removeAllObjects];
            
            for (NSDictionary *tempDic in dict) {
                
                [self.dataSource addObject:tempDic];
            }
            
            if ([_dataSource count]>0) {
                [self hideNoDataTips];
            }
            else {
                
                [self showNoDataTipsWithText:@"您当前暂无品牌加盟，赶快去加盟吧~" buttonTitle:@"马上加盟" buttonTag:100 target:self action:@selector(joinNow)];
            }
            
            [table reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 马上加盟
- (void)joinNow{
    
    JoinInBeforeViewController *joinVC = [[JoinInBeforeViewController alloc] init];
    
    [self.navigationController pushViewController:joinVC animated:YES];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    // 导航条
    [self setNav:@"我的加盟"];
    // 加载数据
    [self requestData];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    // table
    table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    table.backgroundColor = bgColor;
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_dataSource count];
}

#pragma mark - 设置section 头高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.1;
}

#pragma mark - 设置section 脚高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}

#pragma mark - 设置cell (tableView)
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //重用标识符
    static NSString *identifier = @"JoinIn";
    //重用机制
    MyCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
    
    if (cell == nil) {
        //当不存在的时候用重用标识符生成
        cell = [[MyCollectionTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
        cell.time.hidden = NO;
    }
    
    NSDictionary *dict = _dataSource[indexPath.row];
    
    // 图片尺寸设定
    NSString *cutString = [NSString stringWithCurrentString:dict[@"defaultImage"] SizeWidth:viewWidth];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:cutString] placeholderImage:[UIImage imageNamed:@"loading_l"]];
    cell.brankName.text = [NSString stringWithFormat:@"%@",dict[@"brandName"]];
    
    
    cell.investmentAmountCategoryName.text = [NSString stringWithFormat:@"所属行业: %@",dict[@"industryCategoryName"]];
    cell.industryCategoryName.text = [NSString stringWithFormat:@"门店数量（约）: %@",dict[@"storeAmount"]];
    cell.storeAmount.text = [NSString stringWithFormat:@"投资额度: %@",dict[@"investmentAmountCategoryName"]];

    
//    cell.investmentAmountCategoryName.text = [NSString stringWithFormat:@"投资总额度: %@",dict[@"investmentAmountCategoryName"]];
//    cell.industryCategoryName.text = [NSString stringWithFormat:@"行业类别: %@",dict[@"industryCategoryName"]];
//    cell.storeAmount.text = [NSString stringWithFormat:@"门店数量: %@",dict[@"storeAmount"]];
    
    // 加盟时间
//    NSString *remain = [Tools_F timeTransform:[dict[@"addTime"] intValue] time:days];
    if ([dict[@"is_joined"]intValue]==0) {
        cell.time.text = @"进行中";
    }else if([dict[@"is_joined"]intValue]==1){
        cell.time.text = @"已加盟";
    }
    
    
    return cell;
}

#pragma mark - 点击cell (tableView)
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = _dataSource[indexPath.row];
//
    XDJoinDetailViewController *jdVC = [[XDJoinDetailViewController alloc] init];
    
    jdVC.titleLabelStr = dict[@"brandName"]; //九龙冰室
    jdVC.couponContentLabelStr = dict[@"discountNumber"]; //4622623823（优惠券号内容）
    
    jdVC.discountContentLabelStr = dict[@"preferentialContent"]; //8.5折加盟优惠（额外优惠内容）
    jdVC.brandLabelStr = dict[@"brandName"]; //品牌：蒙自源过桥米线
    jdVC.nameLabelStr = dict[@"name"]; //姓名：刘晓光
    if ([dict[@"sex"]intValue] == 0) {
        jdVC.sexLabelStr = @"女士";  //性别
    }else{
        jdVC.sexLabelStr = @"女士";  //性别：先生
    }
    jdVC.phoNumLabelStr = dict[@"phone"]; //手机号：18998989898
    jdVC.companyLabelStr = dict[@"company"]==nil?@"暂无":dict[@"company"]; //公司：广州市九合飞一
    jdVC.positionLabelStr = dict[@"postName"]==nil?@"暂无":dict[@"postName"]; //职位：总经理
    jdVC.brandOperationLabelStr = dict[@"brandName"]==nil?@"暂无":dict[@"brandName"]; //经营品牌：九龙冰室
    jdVC.industryLabelStr = dict[@"industryCategoryName"]==nil?@"暂无":dict[@"industryCategoryName"]; //意向行业
    jdVC.budgetLabelStr = dict[@"investmentAmountCategoryName"]==nil?@"暂无":dict[@"investmentAmountCategoryName"];  //投资预算
    
    
    if ([dict[@"is_joined"]intValue]==0) {
        jdVC.bookingType = BookingTypeBooking;
    }else if([dict[@"is_joined"]intValue]==1){
        jdVC.bookingType = BookingTypeSigned;
    }
    jdVC.bookingType = BookingTypeBooking;
    
    NSString *timeStr = [Tools_F timeTransform:[dict[@"addTime"] intValue] time:minutes];
    jdVC.dataArray = [[NSMutableArray alloc]initWithArray:@[@{@"title":@"成功预约",@"time":timeStr}]];
    
    
    [self.navigationController pushViewController:jdVC animated:YES];
}
- (void)finish
{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[PersonalViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
}

#pragma mark - leftaction
- (void)leftAction:(UIButton *)btn{
    
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[PersonalViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
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
