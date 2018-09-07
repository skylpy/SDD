//
//  MassOfRentViewController.m
//  CustomIntention
//  新项目团租
//  Created by mac on 15/7/9.
//  Copyright (c) 2015年 linpeiyu. All rights reserved.
//

#import "MassOfRentViewController.h"
#import "UIView+ZJQuickControl.h"
#import "RentShopsCellCell.h"
#import "Httprequest.h"
#import "LPYModelTool.h"
#import "RentShopsModel.h"

@interface MassOfRentViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    //控制电击的不限
    int num ;
    
    //产品类型
    int industryCategoryId;
    //类型
    int typeCategoryId;
    //项目性质
    int projectNatureCategoryId;
    //项目状态
    int stateCategoryId;
    
    NSArray * itemArray;
    UIView * RentShopsView;
    UIView * minRentShopsView;
    UILabel * DetIndustryShopsLabel;
    UILabel * DetTypeShopsLabel;
    UILabel * DetsTateShopsLabel;
    UILabel * DetProjectNatureShopsLabel;
    UIView * RentShopsIndustryView;
    UIView * minRentShopsIndustryView;
}

//行业，类型
@property (retain,nonatomic)UITableView * RentShopsTableView;
@property (retain,nonatomic)NSMutableArray * RentShopsArray;

//状态
@property (retain,nonatomic)UITableView * StateShopsTableView;
@property (retain,nonatomic)NSMutableArray * StateShopsArray;

//项目性质
@property (retain,nonatomic)UITableView * DetProjectNatureTableView;
@property (retain,nonatomic)NSMutableArray * DetProjectNatureArray;

@end

@implementation MassOfRentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    industryCategoryId = 0;
    typeCategoryId =  0;
    projectNatureCategoryId = 0;
    stateCategoryId = 0;
    
    num = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self CreateMinRentShopsView];
    [self createNabView];
}

#pragma mark --  导航条返回按钮
-(void)createNabView
{
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"全部项目";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
//    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 0, 120, 20);
//    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [backBtn setTitle:@"新项目团租" forState:UIControlStateNormal];
//    
//    UIImageView * backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
//    backImage.image = [UIImage imageNamed:@"返回-图标.png"];
//    [backBtn addSubview: backImage];
//    
//    UIBarButtonItem * backBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = backBtnItem;
}

#pragma mark --  导航条返回按钮点击事件
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 租商铺视图详细信息
-(void)CreateMinRentShopsView
{
    minRentShopsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, self.view.frame.size.height)];
    minRentShopsView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:minRentShopsView];
    
    NSArray * DetailsArray = @[@"行业",@"类型",@"状态",@"项目性质"];
    NSArray * DetItemArray = @[@"请选择行业",@"请选择类型",@"请选择状态",@""];
    for (int i = 0; i < DetailsArray.count; i ++) {
        
        //每一行的信息（添加手势）
        UIImageView * DetailsImageView = [minRentShopsView addImageViewWithFrame:CGRectMake(0, 44*i, viewWidth, 44) image:nil];
        [DetailsImageView addImageViewWithFrame:CGRectMake(0, 43, viewWidth, 1) image:@"line.png"];
        [DetailsImageView addLabelWithFrame:CGRectMake(10, 15, 80, 14) text:DetailsArray[i]];
        DetailsImageView.tag = 130+i;
        
        //在每个DetailsImageView上添加手势
        UITapGestureRecognizer * DetailsTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DetailsTapClick:)];
        [DetailsImageView addGestureRecognizer:DetailsTap];
        
        //跳转页面箭头
        [DetailsImageView addImageViewWithFrame:CGRectMake(viewWidth-25, 16, 8, 12) image:@"the next_icon.png"];
        
        if (i == 0) {
            DetIndustryShopsLabel = [DetailsImageView addLabelWithFrame:CGRectMake(viewWidth-120, 15, 80, 14) text:DetItemArray[i]];
            DetIndustryShopsLabel.textAlignment = NSTextAlignmentRight;
            DetIndustryShopsLabel.textColor = [UIColor lightGrayColor];
            DetIndustryShopsLabel.font = [UIFont systemFontOfSize:15];
        }
        if (i == 1) {
            DetTypeShopsLabel = [DetailsImageView addLabelWithFrame:CGRectMake(viewWidth-120, 15, 80, 14) text:DetItemArray[i]];
            DetTypeShopsLabel.textAlignment = NSTextAlignmentRight;
            DetTypeShopsLabel.textColor = [UIColor lightGrayColor];
            DetTypeShopsLabel.font = [UIFont systemFontOfSize:15];
        }
        if (i == 2) {
            DetsTateShopsLabel = [DetailsImageView addLabelWithFrame:CGRectMake(viewWidth-120, 15, 80, 14) text:DetItemArray[i]];
            DetsTateShopsLabel.textAlignment = NSTextAlignmentRight;
            DetsTateShopsLabel.textColor = [UIColor lightGrayColor];
            DetsTateShopsLabel.font = [UIFont systemFontOfSize:15];
        }
        if (i == 3) {
            DetProjectNatureShopsLabel =[DetailsImageView addLabelWithFrame:CGRectMake(viewWidth-150, 15, 110, 14) text:@"请选择项目性质"];
            DetProjectNatureShopsLabel.textAlignment = NSTextAlignmentRight;
            DetProjectNatureShopsLabel.textColor = [UIColor lightGrayColor];
            DetProjectNatureShopsLabel.font = [UIFont systemFontOfSize:15];
        }
    }
    
    //尾部视图
    UIImageView * FootImageView = [minRentShopsView addImageViewWithFrame:CGRectMake(0, 175, viewWidth, minRentShopsView.frame.size.height-175) image:@"rent shops_frame2.png"];
    
    //定制我的意向按钮@"custom_btn.png"
    UIButton * CustomIntentionBtn =[FootImageView addImageButtonWithFrame:CGRectMake(10, 20, viewWidth-20, 44) title:nil backgroud:nil action:^(UIButton *button) {
        
         NSDictionary * dict = @{
                                 @"houseIndustryCategoryId":@(industryCategoryId),
                                 @"houseProjectNatureCategoryId":@(projectNatureCategoryId),
                                 @"houseStatus":@(stateCategoryId),
                                 @"houseTypeCategoryId":@(typeCategoryId),
                                 @"type":@2
                                 };
        
        // 定制
        [HttpTool postWithBaseURL:SDD_MainURL Path:@"/userCustomize/save.do" params:dict success:^(id JSON) {
            
            NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
            
            if ([JSON[@"status"] intValue] == 1) {
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:JSON[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    [CustomIntentionBtn setTitle:@"定制我的意向" forState:UIControlStateNormal];
    [CustomIntentionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [CustomIntentionBtn setBackgroundImage:[Tools_F imageWithColor:dblueColor size:CGSizeMake(viewWidth-40, 45)]forState:UIControlStateNormal];
    CustomIntentionBtn.layer.cornerRadius = 5;
    CustomIntentionBtn.clipsToBounds = YES;
    
//    ConfirmButton * conBrandBtn = [[ConfirmButton alloc] initWithFrame:CGRectMake(20, 20, viewWidth-40, 44) title:@"定制我的意向" target:self action:@selector(ConBrand:)];
//    conBrandBtn.enabled = YES;
//    [FootImageView addSubview:conBrandBtn];
}

#pragma maek -- 取消视图
-(void)tapRClick:(UITapGestureRecognizer *)tap {
    
    [RentShopsIndustryView removeFromSuperview];
    [minRentShopsIndustryView removeFromSuperview];
}

#pragma mark -- 租商铺视图详细信息手势
-(void)DetailsTapClick:(UITapGestureRecognizer *)tap
{

    NSLog(@"%ld",tap.view.tag);
    RentShopsIndustryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    RentShopsIndustryView.backgroundColor = [UIColor blackColor];
    RentShopsIndustryView.alpha = 0.5;
    [self.view addSubview:RentShopsIndustryView];
    
    UITapGestureRecognizer * tapR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRClick:)];
    [RentShopsIndustryView addGestureRecognizer:tapR];
    
    if (tap.view.tag == 130) {
        num = 130;
        [self createRentShopsDownLoad];
    }
    else if (tap.view.tag == 131)
    {
        num = 131;
        [self createTypeShopsDownLoad];
    }
    else if (tap.view.tag == 132)
    {
        num = 132;
        [self createStateShopsTableView];
    }
    else if (tap.view.tag == 133)
    {
        num = 133;
        [self createProjectNatureShopsDownLoad];
    }
}

#pragma mark -- 选择状态视图表格
-(void)createStateShopsTableView
{
    
    _StateShopsArray = [[NSMutableArray alloc] initWithObjects:@"不限",@"意向登记期项目",@"意向金收取期项目",@"转定签约期项目",@"已开业项目", nil];
    minRentShopsIndustryView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight-230, viewWidth, 220)];
    minRentShopsIndustryView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:minRentShopsIndustryView];
    
    _StateShopsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 180) style:UITableViewStylePlain];
    _StateShopsTableView.delegate = self;
    _StateShopsTableView.dataSource = self;
    _StateShopsTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    //[_StateShopsTableView registerNib:[UINib nibWithNibName:@"RentShopsCellCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    [minRentShopsIndustryView addSubview:_StateShopsTableView];
    
}

#pragma mark -- 新项目团租项目性质视图表格
-(void)createProjectNatureTableView
{
    minRentShopsIndustryView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight-230, viewWidth, 220)];
    minRentShopsIndustryView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:minRentShopsIndustryView];
    
    _DetProjectNatureTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 180) style:UITableViewStylePlain];
    _DetProjectNatureTableView.delegate = self;
    _DetProjectNatureTableView.dataSource = self;
    _DetProjectNatureTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    //[_DetProjectNatureTableView registerNib:[UINib nibWithNibName:@"RentShopsCellCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    [minRentShopsIndustryView addSubview:_DetProjectNatureTableView];
    
    UIView * NoLimitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 44)];
    UILabel * NoLimitLabel = [NoLimitView addLabelWithFrame:CGRectMake(18, 15, viewWidth, 25) text:@"不限"];
    NoLimitLabel.font = [UIFont systemFontOfSize:18];
    //[NoLimitView addImageViewWithFrame:CGRectMake(10,43 ,viewWidth-20 , 1) image:@"line.png"];
    _DetProjectNatureTableView.tableHeaderView = NoLimitView;
    
    UITapGestureRecognizer * NoLimitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(NoLimitTapClick:)];
    [NoLimitView addGestureRecognizer:NoLimitTap];
}

#pragma mark -- 新项目团租项目性质数据下载
-(void)createProjectNatureShopsDownLoad
{
    //NSString * url = @"http://192.168.1.234:8180/user_mobile";
    NSString * path = @"/houseCategory/natureCategorys.do";
    
    
    _DetProjectNatureArray = [[NSMutableArray alloc] init];
    [HttpRequest postWithNewIssueURL:SDD_MainURL path:path parameter:nil success:^(id Josn) {
        
        NSDictionary * dict = Josn;
        NSArray * ShopsArray = dict[@"data"];
        NSLog(@"%ld",ShopsArray.count);
        
        NSLog(@"%@",dict);
        
        for (NSDictionary * ShopsDict in ShopsArray) {
            RentShopsModel * model = [[RentShopsModel alloc] init];
            [model setValuesForKeysWithDictionary:ShopsDict];
            [_DetProjectNatureArray addObject:model];
        }
        
        [self createProjectNatureTableView];
        
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -- 新项目团租类型数据下载
-(void)createTypeShopsDownLoad
{
    //NSString * url = @"http://192.168.1.234:8180/user_mobile";
    NSString * path = @"/houseCategory/typeCategorys.do";
    
    
    _RentShopsArray = [[NSMutableArray alloc] init];
    [HttpRequest postWithNewIssueURL:SDD_MainURL path:path parameter:nil success:^(id Josn) {
        
        NSDictionary * dict = Josn;
        NSArray * ShopsArray = dict[@"data"];
        NSLog(@"%ld",ShopsArray.count);
        
        NSLog(@"%@",dict);
        
        for (NSDictionary * ShopsDict in ShopsArray) {
            RentShopsModel * model = [[RentShopsModel alloc] init];
            [model setValuesForKeysWithDictionary:ShopsDict];
            [_RentShopsArray addObject:model];
        }
        [self createTableView];
        
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -- 新项目团租行业数据下载
-(void)createRentShopsDownLoad
{
    //NSString * url = @"http://192.168.1.234:8180/user_mobile";
    NSString * path = @"/houseCategory/industryCategorys.do";

    
    _RentShopsArray = [[NSMutableArray alloc] init];
    [HttpRequest postWithNewIssueURL:SDD_MainURL path:path parameter:nil success:^(id Josn) {
        
        NSDictionary * dict = Josn;
        NSArray * ShopsArray = dict[@"data"];
        NSLog(@"%ld",ShopsArray.count);
        
        NSLog(@"%@",dict);
        
        for (NSDictionary * ShopsDict in ShopsArray) {
            RentShopsModel * model = [[RentShopsModel alloc] init];
            [model setValuesForKeysWithDictionary:ShopsDict];
            [_RentShopsArray addObject:model];
        }
        
        [self createTableView];
        
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark -- 创建TableView
-(void)createTableView
{

    minRentShopsIndustryView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight-418, viewWidth, 418)];
    minRentShopsIndustryView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:minRentShopsIndustryView];
    
    _RentShopsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 400-44) style:UITableViewStylePlain];
    _RentShopsTableView.delegate = self;
    _RentShopsTableView.dataSource = self;
    _RentShopsTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    //[_RentShopsTableView registerNib:[UINib nibWithNibName:@"RentShopsCellCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    [minRentShopsIndustryView addSubview:_RentShopsTableView];
    
    UIView * NoLimitView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 44)];
    UILabel * NoLimitLabel = [NoLimitView addLabelWithFrame:CGRectMake(18, 15, viewWidth, 25) text:@"不限"];
    NoLimitLabel.font = [UIFont systemFontOfSize:18];
    //[NoLimitView addImageViewWithFrame:CGRectMake(10,43 ,viewWidth-20 , 1) image:@"line.png"];
    _RentShopsTableView.tableHeaderView = NoLimitView;
    
    UITapGestureRecognizer * NoLimitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(NoLimitTapClick:)];
    [NoLimitView addGestureRecognizer:NoLimitTap];
    
}

#pragma mark -- 创建TableView头部视图的点击手势

-(void)NoLimitTapClick:(UITapGestureRecognizer *)tap
{
    //        int industryCategoryId;
    //        int typeCategoryId;
    //        int projectNatureCategoryId;
    if (num == 130) {
        DetIndustryShopsLabel.text = @"不限";
        industryCategoryId = 0;
    }
    if (num == 131) {
        DetTypeShopsLabel.text = @"不限";
        typeCategoryId = 0;
    }
    if (num == 132) {
        DetsTateShopsLabel.text = @"不限";
        stateCategoryId = 0;
    }
    if (num == 133) {
        DetProjectNatureShopsLabel.text = @"不限";
        projectNatureCategoryId = 0;
    }
    
    [minRentShopsIndustryView removeFromSuperview];
    [RentShopsIndustryView removeFromSuperview];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _RentShopsTableView) {
       RentShopsModel * model = _RentShopsArray[indexPath.row];
        if (num == 130) {
            DetIndustryShopsLabel.text = model.categoryName;
            industryCategoryId = [[NSString stringWithFormat:@"%@",model.industryCategoryId] intValue];
            NSLog(@"%d",industryCategoryId);
        }
        

        if (num == 131) {
            DetTypeShopsLabel.text = model.categoryName;
            typeCategoryId = [[NSString stringWithFormat:@"%@",model.typeCategoryId] intValue];
            NSLog(@"%d",typeCategoryId);
        }
        
    }
    if (tableView == _StateShopsTableView) {
        if (num == 132) {
            DetsTateShopsLabel.text = _StateShopsArray[indexPath.row];
            if (indexPath.row == 0) {
                stateCategoryId = 0;
                NSLog(@"stateCategoryId");
            }
            if (indexPath.row == 1) {
                stateCategoryId = 1;
                NSLog(@"stateCategoryId = %d",stateCategoryId);
            }
            if (indexPath.row == 2) {
                stateCategoryId = 2;
                 NSLog(@"stateCategoryId = %d",stateCategoryId);
            }
        }
    }
    if(tableView == _DetProjectNatureTableView){
        RentShopsModel * model = _DetProjectNatureArray[indexPath.row];
        if (num == 133) {
            DetProjectNatureShopsLabel.text = model.categoryName;
            projectNatureCategoryId = [[NSString stringWithFormat:@"%@",model.projectNatureCategoryId] intValue];
            NSLog(@"%d",projectNatureCategoryId);
        }
    }

    [minRentShopsIndustryView removeFromSuperview];
    [RentShopsIndustryView removeFromSuperview];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _RentShopsTableView)
    {
        NSLog(@"%ld",_RentShopsArray.count);
        return _RentShopsArray.count;
    }
    if (tableView == _StateShopsTableView)
    {
        return _StateShopsArray.count;
    }
    if (tableView == _DetProjectNatureTableView)
    {
        return _DetProjectNatureArray.count-1;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellId = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    if (tableView == _RentShopsTableView) {
        RentShopsModel * model = _RentShopsArray[indexPath.row];
        cell.textLabel.text = model.categoryName;
    }
    if (tableView == _StateShopsTableView) {
        cell.textLabel.text = _StateShopsArray[indexPath.row];
    }
    if (tableView == _DetProjectNatureTableView) {
        RentShopsModel * model = _DetProjectNatureArray[indexPath.row];
        cell.textLabel.text = model.categoryName;
    }
    
    
    return cell;
}

#pragma mark -- 租商铺视图手势
-(void)RentShopsTapClick:(UITapGestureRecognizer *)tap{
    //    [RentShopsView removeFromSuperview];
    //    [minRentShopsView removeFromSuperview];
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
