//
//  CalcDetailViewController.m
//  SDD
//
//  Created by hua on 15/5/6.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "CalcDetailViewController.h"

@interface CalcDetailViewController ()<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    /*- ui -*/
    
    UITableView *table;
    
    /*- data -*/
    
    NSArray *downPayment;
    NSArray *mortgageYears;
    NSArray *interestRateName;
}

@end

@implementation CalcDetailViewController

#pragma mark - 利率表
- (void)arrayInitialization{
    
    // 首付比例
    downPayment = @[@"一成",@"二成",@"三成",@"四成",@"五成",@"六成",@"七成",@"八成",@"九成",@"十成"];
    
    // 按揭年数
    NSMutableArray *muArr = [[NSMutableArray alloc] init];
    for (int i=0; i<30; i++) {
        
        NSString *str = [NSString stringWithFormat:@"%d年(%d期)",i+1,(i+1)*12];
        [muArr addObject:str];
    }
    mortgageYears = muArr;
    
    // 利率
    interestRateName = @[@"12年6月8日基准利率",
                         @"12年6月8日利率下限（7折）",
                         @"12年6月8日利率下限（85折）",
                         @"12年6月8日利率上限（1.1倍）",
                         @"12年7月6日基准利率",
                         @"12年7月6日利率下限（7折）",
                         @"12年7月6日利率下限（85折）",
                         @"12年7月6日利率上限（1.1倍）",
                         @"14年11月22日基准利率",
                         @"14年11月22日利率下限（7折）",
                         @"14年11月22日利率下限（85折）",
                         @"14年11月22日利率上限（1.1倍）",
                         @"2015年3月1日基准利率",
                         @"2015年3月1日利率下限（7折）",
                         @"2015年3月1日利率下限（85折）",
                         @"2015年3月1日利率上限（1.1倍）",
                         ];
}

// nav
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 加载数据
    [self arrayInitialization];
    // 导航条
    [self setupNav];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置导航条
- (void)setupNav{
    
    SDDButton *button = [[SDDButton alloc]init];
    button.frame = CGRectMake(0, 0, 30, 44);
    [button setTitle:@"" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    // 内容
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-64) style:UITableViewStyleGrouped];
    table.backgroundColor = bgColor;
    table.delegate = self;
    table.dataSource = self;
    
    [self.view addSubview:table];
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (_detailType) {
        case 0:
        {
            return [downPayment count]+2;
        }
            break;
        case 1:
        {
            return [mortgageYears count]+2;
        }
            break;
        default:
        {
            return [interestRateName count]+2;
        }
            break;
    }
}

#pragma mark - 设置section 头高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

#pragma mark - 设置section 脚高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

#pragma mark - 设置cell (tableView)
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=nil;
    //重用标识符
    NSString *identifier = [NSString stringWithFormat:@"TimeLineCell%d%d",(int)indexPath.section,(int)indexPath.row];

    if (cell == nil) {
        //当不存在的时候用重用标识符生成
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
        cell.textLabel.font = midFont;
    }
    
    switch (indexPath.row) {
        case 0:
        {
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.text = @"自定义:";
            
            // 自定义
            UITextField *textField = [[UITextField alloc] init];
            textField.frame = CGRectMake(60, 0, viewWidth*2/3, 40);
            textField.font = midFont;
            textField.keyboardType = UIKeyboardTypeDecimalPad;
            [cell addSubview:textField];
            
            // 单位
            UILabel *units = [[UILabel alloc] init];
            units.frame = CGRectMake(CGRectGetMaxX(textField.frame), 0, 20, 40);
            units.font = midFont;
            units.textColor = lgrayColor;
            [cell addSubview:units];
            
            switch (_detailType) {
                case 0:
                {
                    units.text = @"万";
                }
                    break;
                case 1:
                {
                    textField.keyboardType = UIKeyboardTypeDefault;
                    units.text = @"年";
                }
                    break;
                    
                default:
                {
                    units.text = @"%";
                }
                    break;
            }
        }
            break;
        case 1:
        {
            cell.textLabel.textColor = lgrayColor;
            switch (_detailType) {
                case 0:
                {
                    cell.textLabel.text = @"或选择首付比例";
                }
                    break;
                case 1:
                {
                    cell.textLabel.text = @"或选择按揭年数";
                }
                    break;
                    
                default:
                {
                    cell.textLabel.text = @"或选择商贷利率";
                }
                    break;
            }
        }
            break;
            
        default:{
            
            cell.textLabel.textColor = [UIColor blackColor];
            switch (_detailType) {
                case 0:
                {
                    cell.textLabel.text = downPayment[indexPath.row-2];
                }
                    break;
                case 1:
                {
                    cell.textLabel.text = mortgageYears[indexPath.row-2];
                }
                    break;
                    
                default:
                {
                    cell.textLabel.text = interestRateName[indexPath.row-2];
                }
                    break;
            }
        }
            break;
    }
    
    return cell;
}

#pragma mark - 点击cell (tableView)
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row<2) {
        
        return;
    }
    UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    // block回传
    if (self.returnBlock != nil) {
        
        self.returnBlock(cell.textLabel.text,indexPath.row-2);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)valueReturn:(ReturnValueblocks)block{
    
    self.returnBlock = block;
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
