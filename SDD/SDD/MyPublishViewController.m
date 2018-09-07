//
//  MyPublishViewController.m
//  SDD
//
//  Created by hua on 15/7/4.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "MyPublishViewController.h"
#import "MyPublishTableViewCell.h"
#import "NSString+SDD.h"

#import "JoinDetailViewController.h"

#import "UIImageView+WebCache.h"

@interface MyPublishViewController ()<UITableViewDataSource,UITableViewDelegate,
UIScrollViewDelegate>{
    
    /*- ui -*/
    
    UIScrollView *index_scrollView;
    
    /*- data -*/
    
}

// 数据源
@property (nonatomic, strong) NSMutableArray *dataSource;
// 待审核列表
@property (nonatomic, strong) NSMutableArray *unCheckArr;
// 未通过列表
@property (nonatomic, strong) NSMutableArray *unPassArr;
// 已成功列表
@property (nonatomic, strong) NSMutableArray *completeArr;

@end

@implementation MyPublishViewController


- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (NSMutableArray *)unCheckArr{
    if (!_unCheckArr) {
        _unCheckArr = [[NSMutableArray alloc]init];
    }
    return _unCheckArr;
}

- (NSMutableArray *)unPassArr{
    if (!_unPassArr) {
        _unPassArr = [[NSMutableArray alloc]init];
    }
    return _unPassArr;
}

- (NSMutableArray *)completeArr{
    if (!_completeArr) {
        _completeArr = [[NSMutableArray alloc]init];
    }
    return _completeArr;
}

#pragma mark - 请求数据
- (void)requestData{
    
    // 请求参数
    NSDictionary *param = @{@"params":@{@"type":@0}};
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brandUser/myPublish.do" params:param success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSArray *arr = JSON[@"data"];
        
        if (![arr isEqual:[NSNull null]]) {
            
            [_dataSource removeAllObjects];
            
            for (NSDictionary *tempDic in arr) {
                
                [self.dataSource addObject:tempDic];
                
                switch ([tempDic[@"type"] integerValue]) {
                    case 1: // 待审核
                    {
                        [self.unCheckArr addObject:tempDic];
                    }
                        break;
                    case 2: // 已成功
                    {
                        [self.completeArr addObject:tempDic];
                    }
                        break;
                    case 3: // 未通过
                    {
                        [self.unPassArr addObject:tempDic];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
            [self reloadAllTable];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 刷新所有table
- (void)reloadAllTable{
    for (int i = 200; i < 204; i++) {              // 遍历table 刷新
        
        UITableView *tempTable = (UITableView *)[self.view viewWithTag:i];
        [tempTable reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 导航条
    [self setupNav];
    // 加载数据
    [self requestData];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置导航条
- (void)setupNav{
    
    [self setNav:@"我的发布"];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    // 标签
    NSArray *titleArr = @[@"全部",@"待审核",@"未通过",@"已成功"];
    for (int i=0; i<4; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 100 +i;
        btn.backgroundColor = [UIColor whiteColor];
        btn.frame = CGRectMake(0 + (viewWidth*i/4), 0, viewWidth/4, 40);
        [btn setTitle: [titleArr objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:lgrayColor forState:UIControlStateNormal];
        [btn setTitleColor:deepBLack forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageNamed:@"personal_btn_bottonLine_blue"] forState:UIControlStateSelected];
        btn.titleLabel.font =  [UIFont fontWithName:@"Helvetica-Bold" size:13];
        [btn addTarget:self action:@selector(indexSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {               // 默认选中‘全部’
            btn.selected = YES;
        }
        [self.view addSubview:btn];
    }
    
    // 分割线
    UIView *cutOff = [[UIView alloc] init];
    cutOff.frame = CGRectMake(0, 40, viewWidth, 0.5);
    cutOff.backgroundColor = divisionColor;
    [self.view addSubview:cutOff];
    
    // 添加滚动
    index_scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(cutOff.frame), viewWidth, viewHeight-64)];
    index_scrollView.contentSize=CGSizeMake(viewWidth * 5, viewHeight-64);
    index_scrollView.delegate = self;
    index_scrollView.directionalLockEnabled=YES;
    index_scrollView.showsHorizontalScrollIndicator = NO;
    index_scrollView.showsVerticalScrollIndicator = NO;
    index_scrollView.pagingEnabled = YES;           //整页侧滑
    
    for (int i=0 ; i<4; i++) {
        
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(viewWidth*i, 0, viewWidth, viewHeight-105) style:UITableViewStyleGrouped];
        table.tag = 200+i;
        table.delegate = self;
        table.dataSource = self;
        [index_scrollView addSubview:table];
    }
    
    [self.view addSubview:index_scrollView];
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 130;
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

#pragma mark - 设置Sections数 (tableView)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    switch (tableView.tag) {
        case 200:
        {
            return [_dataSource count];
        }
            break;
        case 201:
        {
            return [_unCheckArr count];
        }
            break;
        case 202:
        {
            return [_unPassArr count];
        }
            break;
        case 203:
        {
            return [_completeArr count];
        }
            break;
        default:
        {
            return 0;
        }
            break;
    }
}

#pragma mark - 设置section 头高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

#pragma mark - 设置section 脚高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}

#pragma mark - 设置cell (tableView)
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //重用标识符
    static NSString *identifier = @"MyPublish";
    //重用机制
    MyPublishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
    
    if (cell == nil) {
        //当不存在的时候用重用标识符生成
        cell = [[MyPublishTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
    }
    
    NSDictionary *dict;
    
    switch (tableView.tag) {
        case 200:
        {
            dict = _dataSource[indexPath.section];
        }
            break;
        case 201:
        {
            dict = _unCheckArr[indexPath.section];
        }
            break;
        case 202:
        {
            dict = _unPassArr[indexPath.section];
        }
            break;
        case 203:
        {
            dict = _completeArr[indexPath.section];
        }
            break;
    }
    
    NSString *status;

    switch ([dict[@"type"] integerValue]) {
        case 2:
        {
            status = @"已成功";
        }
            break;
        case 3:
        {
            status = @"未通过";
        }
            break;
        default:{
            status = @"待审核";
        }
            break;
    }
    
    cell.publishStatus.text = status;
    // 图片尺寸设定
    NSString *cutString = [NSString stringWithCurrentString:dict[@"defaultImage"] SizeWidth:viewWidth];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:cutString] placeholderImage:[UIImage imageNamed:@"loading_l"]];
    cell.brankName.text = [NSString stringWithFormat:@"%@",dict[@"brandName"]];
    cell.investmentAmountCategoryName.text = [NSString stringWithFormat:@"投资总额度: %@",dict[@"investmentAmountCategoryName"]];
    cell.industryCategoryName.text = [NSString stringWithFormat:@"行业类别: %@",dict[@"industryCategoryName"]];
    cell.storeAmount.text = [NSString stringWithFormat:@"门店数量: %@",dict[@"storeAmount"]];
    
    return cell;
}

#pragma mark - 点击cell (tableView)
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict;
    switch (tableView.tag) {
        case 200:
        {
            dict = _dataSource[indexPath.section];
        }
            break;
        case 201:
        {
            dict = _unCheckArr[indexPath.section];
        }
            break;
        case 202:
        {
            dict = _unPassArr[indexPath.section];
        }
            break;
        case 203:
        {
            dict = _completeArr[indexPath.section];
        }
            break;
    }
    
//    JoinDetailViewController *jdVC = [[JoinDetailViewController alloc] init];
//    jdVC.brandId = dict[@"brandId"];
//    [self.navigationController pushViewController:jdVC animated:YES];
}


#pragma mark - indexSelected
- (void)indexSelected:(UIButton *)sender{
    
    // 设置按钮选择状态
    for ( UIButton *tempBtn in self.view.subviews) {
        if (tempBtn.tag >99 && tempBtn.tag < 104) {
            tempBtn.selected = NO;      // 全部设置未选中
        }
    }
    
    sender.selected = YES;          // 当前按钮设置选中
    
    // indexScrollView 随着变化
    [index_scrollView setContentOffset:CGPointMake((sender.tag-100)*viewWidth, 0) animated:YES];
}

#pragma mark - scrollView 代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView != index_scrollView) {
        return;
    }
    CGPoint point = scrollView.contentOffset; //记录滑动
    
    // 设置按钮选择状态
    for ( UIButton *tempBtn in self.view.subviews) {
        if (tempBtn.tag >99 && tempBtn.tag < 104) {
            tempBtn.selected = NO;      // 全部设置未选中
        }
    }
    
    int countTag = point.x/self.view.frame.size.width +100;         // 计算按钮tag值
    UIButton *clickBtn = (UIButton *) [self.view viewWithTag:countTag];
    clickBtn.selected = YES;
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
