//
//  SomeRecommandViewController.m
//  SDD
//
//  Created by hua on 15/6/25.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "SomeRecommandViewController.h"
#import "JoinCommendTableViewCell.h"

#import "RecommendViewController.h"

#import "UIImageView+WebCache.h"

@interface SomeRecommandViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    /*- ui -*/
    
    UITableView *table;
    
    NoDataTips *noData;
}

// 数据源
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation SomeRecommandViewController

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

#pragma mark - 请求数据
- (void)requestData{
    
    // 请求参数
    NSDictionary *param = @{@"params":@{@"brandId":_brandId}};
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brand/commentList.do" params:param success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSDictionary *dict = JSON[@"data"];
        
        if (![dict isEqual:[NSNull null]]) {
            
            [_dataSource removeAllObjects];
            
            for (NSDictionary *tempDic in dict) {
                
                [self.dataSource addObject:tempDic];
            }
            
            noData.hidden = [_dataSource count]>0? NO:YES;
            
            [table reloadData];
        }
        else {
            
            //noData.hidden = NO;
            noData = [[NoDataTips alloc] init];
            [noData setText:@"暂无点评"
                buttonTitle:nil
                  buttonTag:0
                     target:nil
                     action:nil];
            
            [table addSubview:noData];
            if (iOS_version < 7.5) {
                noData.frame = CGRectMake(0, 0, viewWidth, viewHeight);
            }
            else {
                [noData mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(table);
                    make.edges.equalTo(table);
                }];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    // 加载数据
    [self requestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 导航条
    [self setNav:@"加盟点评"];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    // table
    table = [[UITableView alloc] init];
    table.backgroundColor = bgColor;
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UIView *division = [[UIView alloc] init];
    division.backgroundColor = divisionColor;
    [bottomView addSubview:division];
    
    // 马上点评
    ConfirmButton *recommand = [[ConfirmButton alloc] initWithFrame:CGRectMake(20, 5, viewWidth - 40, 45)
                                                                title:@"马上点评"
                                                               target:self
                                                               action:@selector(publish:)];
    recommand.enabled = YES;
    [bottomView addSubview:recommand];
    
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.bottom.equalTo(bottomView.mas_top);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 55));
    }];
    
    [division mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top);
        make.left.equalTo(bottomView.mas_left);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 1));
    }];
    
    [recommand mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(division.mas_bottom).with.offset(5);
        make.bottom.equalTo(bottomView.mas_bottom).with.offset(-5);
        make.left.equalTo(bottomView.mas_left).with.offset(20);
        make.right.equalTo(bottomView.mas_right).with.offset(-20);
    }];
    
        // 无数据提示
    
    
    
}

#pragma mark - 设置行高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 110;
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
    static NSString *identifier = @"RegionList";
    //重用机制
    JoinCommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
    
    if (cell == nil) {
        //当不存在的时候用重用标识符生成
        cell = [[JoinCommendTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
        cell.textLabel.font = midFont;
    }
    
    NSDictionary *currentDic = _dataSource[indexPath.row];
    
    [cell.theAvatar sd_setImageWithURL:[NSURL URLWithString:currentDic[@"icon"]]];
    cell.theName.text = currentDic[@"realName"];
    cell.theStar.scorePercent = [currentDic[@"avgScore"] floatValue]/5.0;//starScore
    
    switch ([currentDic[@"avgScore"] integerValue]) {
        case 1:
        {
            cell.theAppraise.text = @"差评";
        }
            break;
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
            cell.theAppraise.text = @"";
        }
            break;
    }
    cell.theCommend.text = currentDic[@"description"];
    cell.theTime.text = [NSString stringWithFormat:@"%@",[Tools_F timeTransform:[currentDic[@"addTime"] intValue] time:seconds]];
    
    [cell.theLike setTitle:[NSString stringWithFormat:@"%@",currentDic[@"likeTotal"]] forState:UIControlStateNormal];
    cell.theLike.selected = [currentDic[@"isLike"] intValue] == 1? YES:NO;
    cell.theLike.tag = [currentDic[@"commentId"] intValue]+100;
    [cell.theLike addTarget:self action:@selector(clickLike:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - 发布
- (void)publish:(UIButton *)btn{
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else {
        RecommendViewController *rVC = [[RecommendViewController alloc] init];
        rVC.brandId = _brandId;
        [self.navigationController pushViewController:rVC animated:YES];
    }
}

#pragma mark - 点赞/取消点赞
- (void)clickLike:(UIButton *)btn{
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else {
        
        NSNumber *commentID = [NSNumber numberWithInt:(int)btn.tag-100];
        
        NSDictionary *dic = @{@"commentId":commentID};
        NSString *str = btn.isSelected?
        @"/brand/deleteLike/comment.do":
        @"/brand/like/comment.do";
        [self addOrCancelLike:str param:dic button:btn];
    }
}

- (void)addOrCancelLike:(NSString *)url param:(NSDictionary *)dic button:(UIButton *)btn{
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:url params:dic success:^(id JSON) {
        
        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        
        if ([JSON[@"status"] intValue] == 1) {
            
            int i = [btn.titleLabel.text intValue];
            NSLog(@"%d",i);
            if ([url isEqualToString:@"/brand/deleteLike/comment.do"]) {
                [btn setTitle:[NSString stringWithFormat:@"%d",--i] forState:UIControlStateNormal];
            }
            else {
                [btn setTitle:[NSString stringWithFormat:@"%d",++i] forState:UIControlStateSelected];
            }
            NSLog(@"%d",i);
            btn.selected = !btn.selected;
        }
    } failure:^(NSError *error) {
        
    }];
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
