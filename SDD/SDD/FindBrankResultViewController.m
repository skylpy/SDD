//
//  FindBrankResultViewController.m
//  SDD
//
//  Created by hua on 15/7/4.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "FindBrankResultViewController.h"
#import "FindBrankResultTableViewCell.h"
#import "GroupPurchaseTableViewCell.h"
#import "NSString+SDD.h"

#import "ChatViewController.h"
#import "JoinDetailViewController.h"

#import "UIImageView+WebCache.h"
#import "JoinDatailBrandViewController.h"
#import "CommonBrandViewController.h"

@interface FindBrankResultViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    /*- ui -*/
    
    UITableView *table;
}

@end

@implementation FindBrankResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 导航条
    //[self setNav:@"一键找品牌"];
    [self setNav:@"查找结果"];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    // table头
    UIView *tableHeadView = [[UIView alloc] init];
    tableHeadView.frame = CGRectMake(0, 0, viewWidth, 100);
    tableHeadView.backgroundColor = [UIColor whiteColor];
    
    [tableHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(viewWidth, 100));
    }];
    
    NSArray *titleArr = @[@"加盟区域",@"加盟行业",@"物业要求"];
    
    UIView *lastView;
    for (int i=0; i<3; i++) {
        
        UILabel *title = [[UILabel alloc] init];
        title.font = midFont;
        title.textColor = lgrayColor;
        title.text = titleArr[i];
        [tableHeadView addSubview:title];
        
        UILabel *content = [[UILabel alloc] init];
        content.font = midFont;
        content.textColor = [UIColor blackColor];
        content.text = _conditionStr[i];
        [tableHeadView addSubview:content];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastView?lastView.mas_bottom:tableHeadView.mas_top).with.offset(10);
            make.left.equalTo(tableHeadView.mas_left).with.offset(10);
//            make.width.equalTo(@(viewWidth/4));
            make.height.equalTo(@13);
        }];
        
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(title.mas_top);
            make.left.equalTo(title.mas_right).with.offset(10);
            make.right.equalTo(tableHeadView.mas_right).with.offset(-10);
            make.height.equalTo(@13);
        }];
        
        lastView = title;
    }
    
    UIView *findResult_bg = [[UIView alloc] init];
    findResult_bg.backgroundColor = bgColor;
    [tableHeadView addSubview:findResult_bg];
    
    UILabel *resultLabel = [[UILabel alloc] init];
    resultLabel.font = littleFont;
    resultLabel.textColor = lgrayColor;
    resultLabel.text = @"我们为您寻找的以下符合条件的品牌";
    [tableHeadView addSubview:resultLabel];
    
    [findResult_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(tableHeadView.mas_bottom);
        make.left.equalTo(tableHeadView);
        make.right.equalTo(tableHeadView);
        make.height.equalTo(@25);
    }];
    
    [resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(tableHeadView.mas_bottom);
        make.left.equalTo(tableHeadView).with.offset(8);
        make.right.equalTo(tableHeadView).with.offset(-8);
        make.height.equalTo(@25);
    }];
    
    
    // table
    table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    table.backgroundColor = bgColor;
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    table.tableHeaderView = tableHeadView;
    
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
    static NSString *identifier = @"FindBrankResult";

    //重用机制
    GroupPurchaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
    
    if(cell == nil){
        //当不存在的时候用重用标识符生成
        cell = [[GroupPurchaseTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
        cell.cellType = index_hr;
    }
    
    NSDictionary *currentDic = _dataSource[indexPath.row];

    cell.teamImg.image = [UIImage imageNamed:@"icon-tip1"];
    /*- 推荐 -*///model.f_type
    cell.isRecommend = [currentDic[@"type"] integerValue]==1?YES:NO;
    // 图片尺寸设定
    NSString *tmpStr = [NSString stringWithCurrentString:currentDic[@"defaultImage"] SizeWidth:160];
    
    [cell.placeImage sd_setImageWithURL:[NSURL URLWithString:tmpStr] placeholderImage:[UIImage imageNamed:@"loading_l"]];
    // 品牌商名
    cell.placeTitle.text = currentDic[@"brandName"];
    // 投资额度
    cell.placeAdd.text = [NSString stringWithFormat:@"投资额度:%@",currentDic[@"investmentAmountCategoryName"]];
    // 行业
    cell.placeDiscount.text = currentDic[@"industryCategoryName"] == nil?@"所属行业: ":[NSString stringWithFormat:@"所属行业:%@",currentDic[@"industryCategoryName"]];
    // 门店数量
    cell.placePrice.text = [currentDic[@"storeAmount"] intValue] == 0?@"门店数量:暂无":[NSString stringWithFormat:@"门店数量:(约) %@",currentDic[@"storeAmount"]];
    //cell.placePriBtn.hidden = YES;
    
    return cell;
}

#pragma mark - 点击cell (tableView)
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *currentDic = _dataSource[indexPath.row];

//    FranchiseesMobel *model = _dataSource[indexPath.section];
//    
    NSInteger brandType = [currentDic[@"type"] integerValue];
    
//    // 发送顾问默认欢迎文本
//    NSDictionary *param = @{@"consultantUserId":currentDic[@"chatUserId"],
//                            @"type":@1,
//                            @"brandId":currentDic[@"brandId"]
//                            };
//    NSString *urlString = [SDD_MainURL stringByAppendingString:@"/user/getIMDefaultWelcomeText.do"];              // 拼接主路径和请求内容成完整url
//    [self sendRequest:param url:urlString];
//    
//    self.hidesBottomBarWhenPushed = YES;
//    ChatViewController *cvc = [[ChatViewController alloc] initWithChatter:[NSString stringWithFormat:@"%@",currentDic[@"chatUserId"]] isGroup:FALSE];
//    [self.navigationController pushViewController:cvc animated:true];
    
//    JoinDetailViewController *jdVC = [[JoinDetailViewController alloc] init];
//    jdVC.brandId = currentDic[@"brandId"];
//    [self.navigationController pushViewController:jdVC animated:YES];
    
    if (brandType == 1) {
        
        JoinDatailBrandViewController *jdVC = [[JoinDatailBrandViewController alloc] init];
        jdVC.brandId = currentDic[@"brandId"];
        //jdVC.brandType = brandType;
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:jdVC animated:YES];
    }
    else
    {
        CommonBrandViewController *jdVC = [[CommonBrandViewController alloc] init];
        jdVC.brandId = currentDic[@"brandId"];
        //jdVC.brandType = brandType;
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:jdVC animated:YES];
    }
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
