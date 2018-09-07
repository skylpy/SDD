//
//  ALDViewController.m
//  商多多
//
//  Created by hua on 15/4/9.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ALDViewController.h"
#import "ALDTableViewCell.h"
#import "PlanModel.h"

#import "ALDDetailViewController.h"

#import "VIPhotoView.h"
#import "UIImageView+WebCache.h"

@interface ALDViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    /* ui */
    
    UITableView *table;
    
    /* data */
    
    NSArray *planArr;
}

@end

@implementation ALDViewController

#pragma mark - 请求数据
- (void)requsetData{
    
    // 请求参数
    NSDictionary *dic = @{@"houseId":_houseID};
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/house/buildingImages.do" params:dic success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSArray *arr = JSON[@"data"];
        if (![arr isEqual:[NSNull null]]) {
            if ([arr count]>0) {
                
                // JSON array -> User array
                planArr = [PlanModel objectArrayWithKeyValuesArray:arr];
                [table reloadData];
            }
        }
    } failure:^(NSError *error) {
        
        NSLog(@"业态平面图列表错误 -- %@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];
    // 请求数据
    [self requsetData];
    // 导航条
    [self setNav:@"业态平面图"];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    table.backgroundColor = bgColor;
    table.delegate = self;
    table.dataSource = self;
    
    [self.view addSubview:table];
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIImageView *headerImage = [[UIImageView alloc] init];
    [headerImage sd_setImageWithURL:_imageUrl placeholderImage:[UIImage imageNamed:@"loading_b"]];
    VIPhotoView *phoneView = [[VIPhotoView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, (viewHeight-64)*0.4)
                                                   andImageView:headerImage];
    phoneView.autoresizingMask = (1 << 6) -1;
    
    return phoneView;
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [planArr count];
}

#pragma mark - 设置section 头高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return (viewHeight-64)*0.4;
}

#pragma mark - 设置section 脚高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

#pragma mark - 设置cell (tableView)
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //重用标识符
    static NSString *identifier = @"Plan";
    //重用机制
    ALDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
    
    if (cell == nil) {
        //当不存在的时候用重用标识符生成
        cell = [[ALDTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    PlanModel *model = planArr[indexPath.row];
    
    [cell.imgView sd_setImageWithURL:model.buildingImage placeholderImage:[UIImage imageNamed:@"cell_loading"]];
    cell.houseType.text = [NSString stringWithFormat:@"%@",model.buildingName];
    cell.houseSize.text = [NSString stringWithFormat:@"面积： %.0fm²",model.buildingArea];
    cell.houseIndustry.text = [NSString stringWithFormat:@"业态： %@",model.formatName];

    return cell;
}

#pragma mark - 点击cell (tableView)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PlanModel *model = planArr[indexPath.row];

    ALDDetailViewController *aldDetail = [[ALDDetailViewController alloc] init];
    aldDetail.theTitle = model.buildingName;
    aldDetail.buildingId = model.buildingId;
    aldDetail.canAppointment = _canAppointment;
    [self.navigationController pushViewController:aldDetail animated:YES];
}

#pragma mark - leftaction
- (void)leftAction:(UIButton *)btn{
    
    NSLog(@"返回");
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
