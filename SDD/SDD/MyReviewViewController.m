//
//  MyReviewViewController.m
//  SDD
//
//  Created by hua on 15/7/2.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "MyReviewViewController.h"
#import "NSString+SDD.h"

#import "MyReviewTableViewCell.h"
#import "JoinDetailViewController.h"

#import "UIImageView+WebCache.h"

@interface MyReviewViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>{
    
    /*- ui -*/
    
    UITableView *table;
}

// 数据源
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation MyReviewViewController

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
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brandUser/myComment.do" params:param success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSDictionary *dict = JSON[@"data"];
        
        if (![dict isEqual:[NSNull null]]) {
            
            [_dataSource removeAllObjects];
            
            for (NSDictionary *tempDic in dict) {
                
                [self.dataSource addObject:tempDic];
            }
            
            [table reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    // 导航条
    [self setupNav];
    // 加载数据
    [self requestData];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置导航条
- (void)setupNav{
    
    SDDButton *button = [[SDDButton alloc]init];
    button.frame = CGRectMake(0, 0, 100, 44);
    [button setTitle:@"我的点评" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
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
    static NSString *identifier = @"Review";
    //重用机制
    MyReviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
    
    if (cell == nil) {
        //当不存在的时候用重用标识符生成
        cell = [[MyReviewTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
    }
    
    NSDictionary *dict = _dataSource[indexPath.row];
    
    // 图片尺寸设定
    NSString *cutString = [NSString stringWithCurrentString:dict[@"defaultImage"] SizeWidth:viewWidth];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:cutString] placeholderImage:[UIImage imageNamed:@"loading_l"]];
    cell.brankName.text = [NSString stringWithFormat:@"%@",dict[@"brandName"]];
    cell.theStar.scorePercent = [dict[@"starScore"] floatValue]/5.0;
    switch ([dict[@"starScore"] integerValue]) {
        case 2:
        {
            cell.theAppraise.text = @"一般";
        }
            break;
        case 3:
        {
            cell.theAppraise.text = @"满意";
        }
            break;
        case 4:
        {
            cell.theAppraise.text = @"非常满意";
        }
            break;
        case 5:
        {
            cell.theAppraise.text = @"无可挑剔";
        }
            break;
        default:{
            cell.theAppraise.text = @"差评";
        }
            break;
    }
    
    return cell;
}

#pragma mark - 点击cell (tableView)
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = _dataSource[indexPath.row];
    
    JoinDetailViewController *jdVC = [[JoinDetailViewController alloc] init];
    jdVC.brandId = dict[@"brandId"];
    [self.navigationController pushViewController:jdVC animated:YES];
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
