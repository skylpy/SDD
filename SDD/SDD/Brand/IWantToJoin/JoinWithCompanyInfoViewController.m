//
//  JoinWithCompanyInfoViewController.m
//  SDD
//  预约加盟 - （第二步）填写公司信息
//  Created by hua on 15/12/25.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "JoinWithCompanyInfoViewController.h"
#import "XDJoinDetailViewController.h"
#import "FSDropDownMenu.h"

#import "FindBrankModel.h"

typedef NS_ENUM(NSInteger, ColumnType)
{
    industryType = 0,  //意向
    investmentAmountsType = 1,  // 投资额度
    jobType = 2  //职务
};

//类别
typedef NS_ENUM(NSInteger, ClassType)
{
    ClassTypeDistributor = 100,  //经销商
    ClassTypeInvestor,  // 投资商
    ClassTypeBrand,  //品牌商
    ClassTypeOther,  //职务
};

@interface JoinWithCompanyInfoViewController ()<FSDropDownMenuDataSource,FSDropDownMenuDelegate>
/********************* UI *************************/
@property (weak, nonatomic) IBOutlet UIView *line1; //分割线
@property (weak, nonatomic) IBOutlet UIView *line2; //分割线
@property (weak, nonatomic) IBOutlet UIView *line3; //分割线
@property (weak, nonatomic) IBOutlet UIView *line4;  // 分割线

@property (weak, nonatomic) IBOutlet UILabel *company; //公司
@property (weak, nonatomic) IBOutlet UILabel *duties; //职务
@property (weak, nonatomic) IBOutlet UILabel *brand; //品牌
@property (weak, nonatomic) IBOutlet UILabel *industry; //意向行业
@property (weak, nonatomic) IBOutlet UILabel *budget; //投资预算

@property (weak, nonatomic) IBOutlet UITextField *companyTextField; //公司名输入框
@property (weak, nonatomic) IBOutlet UIButton *dutiesBtn; //选择职务

@property (weak, nonatomic) IBOutlet UILabel *classType;   //类别
@property (weak, nonatomic) IBOutlet UIButton *distributorBtn; //类别 - 经销商
@property (weak, nonatomic) IBOutlet UIButton *investorBtn; //类别 - 投资商
@property (weak, nonatomic) IBOutlet UIButton *otherBtn; //类别 - 其他


@property (weak, nonatomic) IBOutlet UITextField *brandTextField; //经营品牌输入框
@property (weak, nonatomic) IBOutlet UIButton *industryBtn; //选择意向行业
@property (weak, nonatomic) IBOutlet UIButton *budgetBtn; //选择预算
@property (weak, nonatomic) IBOutlet UIButton *submitBtn; //提交按钮
@property (weak, nonatomic) IBOutlet UIButton *agreementBtn; //注册协议按钮

@property(nonatomic,strong) FSDropDownMenu *dropMenu;  //栏目选择



/********************* Data *************************/
@property (nonatomic, strong) NSMutableArray *industryAll;  // 行业类别
@property (nonatomic, strong) NSMutableArray *investmentAmount;  // 投资额度
@property (nonatomic, strong) NSMutableArray *jobTypeAll;  // 省份、城市列表
@property(nonatomic,assign) ColumnType columntype;

@property(nonatomic,assign) NSInteger postCategoryId; //职务

@property(nonatomic,assign) NSInteger brandCustomerCategoryId; //类别 1：经销商（默认） 2：投资客 3：其它
@property(nonatomic,assign) NSInteger industryCategoryId; //行业品类1
@property(nonatomic,assign) NSInteger industryCategoryId2; //行业品类2
@property(nonatomic,assign) NSInteger investmentAmountCategoryId;  //投资能力
@property(nonatomic,strong) FindBrankModel *currentModel;

@property(nonatomic,assign) ClassType indexClassType;   //当前选中类别
- (IBAction)classTypeBtnClick:(UIButton *)sender;

@end

@implementation JoinWithCompanyInfoViewController

- (NSMutableArray *)industryAll{
    if (!_industryAll) {
        _industryAll = [[NSMutableArray alloc]init];
    }
    return _industryAll;
}

- (NSMutableArray *)investmentAmount{
    if (!_investmentAmount) {
        _investmentAmount = [[NSMutableArray alloc]init];
    }
    return _investmentAmount;
}

- (NSMutableArray *)jobTypeAll{
    if (!_jobTypeAll) {
        _jobTypeAll = [[NSMutableArray alloc]init];
    }
    return _jobTypeAll;
}

#pragma mark
#pragma mark 调接口
- (void)sendMessageToServer
{
    [self showLoading:1];
    NSDictionary *postDic = @{ @"sex": [NSNumber numberWithInteger:self.sex],   //性别 男：  女：
                               @"phone": [NSNumber numberWithInteger:self.phoneNumber], //电话号码
                               @"guestTypeId": @1,
                               @"industryCategoryId1": [NSNumber numberWithInteger:self.industryCategoryId], //意向行业id1
                               @"industryCategoryId2": [NSNumber numberWithInteger:self.industryCategoryId2], //意向行业id2
                               @"brandId": self.brandId,
                               @"postId": [NSNumber numberWithInteger:self.postCategoryId],
                               @"name": self.name,  //姓名
                               @"company": self.companyTextField.text,  //公司名
                               @"brand": self.brandTextField.text,
                               @"investmentAmountCategoryId": [NSNumber numberWithInteger:self.investmentAmountCategoryId] //投资预算
                               };
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brand/add/joined.do" params:postDic success:^(id JSON) {
        [self hideLoading];
        if (![JSON isKindOfClass:[NSNull class]]) {
            if([JSON[@"status"]intValue] == 1){
                //预约成功
                XDJoinDetailViewController *vc = [[XDJoinDetailViewController alloc]init];
                vc.backType = BackTypeDetail;
                vc.titleLabelStr = self.brandStr;
                vc.couponContentLabelStr = @"55555555";
                vc.discountContentLabelStr = self.discount;
                vc.brandLabelStr = self.brandStr;
                vc.nameLabelStr = self.name;
                if (self.sex == 0) {
                    vc.sexLabelStr = @"先生";
                }else{
                    vc.sexLabelStr = @"女士";
                }
                vc.phoNumLabelStr = [NSString stringWithFormat:@"%ld",(long)self.phoneNumber];
                vc.companyLabelStr = self.companyTextField.text;
                vc.positionLabelStr = self.dutiesBtn.currentTitle;
                vc.brandOperationLabelStr = self.brandTextField.text;
                vc.industryLabelStr = self.industryBtn.currentTitle;
                vc.budgetLabelStr = self.budgetBtn.currentTitle;
                vc.bookingType = BookingTypeBooking;
                
                NSDate *date = [[NSDate alloc]initWithTimeIntervalSinceNow:0];
                NSTimeInterval time = [Tools_F cTimestampFromDate:date];

                NSString *timeStr = [Tools_F timeTransform:time time:minutes];
                vc.dataArray = [[NSMutableArray alloc]initWithArray:@[@{@"title":@"成功预约",@"time":timeStr}]];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                //预约失败
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:JSON[@"message"]
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"连网失败"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    } failure:^(NSError *error) {
        [self hideLoading];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"连网失败"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.brandCustomerCategoryId = 1;
    self.postCategoryId = 0;
    self.industryCategoryId = 0;
    self.industryCategoryId2 = 0;
    self.investmentAmountCategoryId = 0;
    
    [self viewSetup];
    
    [self requestData];
}

#pragma mark
#pragma mark UI
- (void)viewSetup
{
    [self setNav];
    
    /************* 修改字体颜色 ************/
    self.line1.backgroundColor = divisionColor;
    self.line2.backgroundColor = divisionColor;
    self.line3.backgroundColor = divisionColor;
    self.line4.backgroundColor = divisionColor;
    
    self.company.textColor = mainTitleColor;
    self.duties.textColor = mainTitleColor;
    self.brand.textColor = mainTitleColor;
    self.industry.textColor = mainTitleColor;
    self.budget.textColor = mainTitleColor;
    self.classType.textColor = mainTitleColor;
    
    self.companyTextField.textColor = mainTitleColor;
    [self.dutiesBtn setTitleColor:lgrayColor forState:UIControlStateNormal];
    [self.distributorBtn setTitleColor:lgrayColor forState:UIControlStateNormal];
    [self.investorBtn setTitleColor:lgrayColor forState:UIControlStateNormal];
    [self.otherBtn setTitleColor:lgrayColor forState:UIControlStateNormal];
    
    self.brandTextField.textColor = mainTitleColor;
    [self.industryBtn setTitleColor:lgrayColor forState:UIControlStateNormal];
    [self.budgetBtn setTitleColor:lgrayColor forState:UIControlStateNormal];
    
    [self.submitBtn setBackgroundColor:dblueColor];
    self.submitBtn.layer.cornerRadius = 4;
    self.submitBtn.layer.masksToBounds = YES;
    
    /************* 类别按钮偏移 ************/
    self.distributorBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    self.investorBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    self.otherBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    
    
    /************* 添加点击事件 ************/
    [self.dutiesBtn addTarget:self action:@selector(dutiesBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.industryBtn addTarget:self action:@selector(industryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.budgetBtn addTarget:self action:@selector(budgetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.agreementBtn addTarget:self action:@selector(agreementBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    /************ 同意注册协议按钮 ***************/
    NSString *click = @"点击“";
    NSString *submit = @"提交";
    NSString *showYouAgree = @"”按钮表示您同意";
    NSString *agreement = @"《商多多加盟服务协议》";
    NSMutableAttributedString *submitStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@%@%@",click,submit,showYouAgree,agreement]];
    [submitStr addAttribute:NSForegroundColorAttributeName value:lgrayColor range:NSMakeRange(0, click.length)];
    [submitStr addAttribute:NSForegroundColorAttributeName value:dblueColor range:NSMakeRange(click.length, submit.length)];
    [submitStr addAttribute:NSForegroundColorAttributeName value:lgrayColor range:NSMakeRange(click.length+submit.length, showYouAgree.length)];
    [submitStr addAttribute:NSForegroundColorAttributeName value:dblueColor range:NSMakeRange(click.length+submit.length+showYouAgree.length, agreement.length)];
    [self.agreementBtn setAttributedTitle:submitStr forState:UIControlStateNormal];
    
    // 栏目选择
    /************ 栏目选择 ***************/
    self.dropMenu = [[FSDropDownMenu alloc] initWithOrigin:CGPointMake(0, viewHeight-300-64) andHeight:300];
    //    _menu.transformView = transformView;
    self.dropMenu.dataSource = self;
    self.dropMenu.delegate = self;
    [self.view addSubview:self.dropMenu];
}

#pragma mark
#pragma mark 选择职务点击事件
- (void)dutiesBtnClick:(UIButton*)sender
{
    [self.view endEditing:YES];
    self.columntype = jobType;
    [self.dropMenu.rightTableView reloadData];
    [self.dropMenu menuTapped];
}


#pragma mark 选择意向行业点击事件
- (void)industryBtnClick:(UIButton*)sender
{
    [self.view endEditing:YES];
    self.columntype = industryType;
    [self.dropMenu.rightTableView reloadData];
    [self.dropMenu menuTapped];
}


#pragma mark 选择预算点击事件
- (void)budgetBtnClick:(UIButton*)sender
{
    [self.view endEditing:YES];
    self.columntype = investmentAmountsType;
    [self.dropMenu.rightTableView reloadData];
    [self.dropMenu menuTapped];
}


#pragma mark 提交按钮点击事件
- (void)submitBtnClick:(UIButton*)sender
{
    /*
     @property(nonatomic,assign) NSInteger postCategoryId; //职务
     @property(nonatomic,assign) NSInteger industryCategoryId; //行业品类1
     @property(nonatomic,assign) NSInteger industryCategoryId2; //行业品类2
     @property(nonatomic,assign) NSInteger investmentAmountCategoryId;  //投资能力
     */
    NSLog(@"%ld - %ld - %ld - %ld",(long)self.postCategoryId,(long)self.industryCategoryId,(long)self.industryCategoryId2,(long)self.investmentAmountCategoryId);
    
    NSString *company = self.companyTextField.text;
    NSString *brand = self.brandTextField.text;  //品牌
    
    //判空
    if (company.length==0 || brand.length==0 || self.postCategoryId == 0 || self.industryCategoryId == 0 || self.investmentAmountCategoryId == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请填完信息"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self sendMessageToServer];
}


#pragma mark 注册协议按钮点击事件
- (void)agreementBtnClick:(UIButton*)sender
{
    
}

/*
 ]
 @property (weak, nonatomic) IBOutlet UIButton *distributorBtn; //类别 - 经销商
 @property (weak, nonatomic) IBOutlet UIButton *investorBtn; //类别 - 投资商
 @property (weak, nonatomic) IBOutlet UIButton *brandBtn; //类别 - 品牌商
 @property (weak, nonatomic) IBOutlet UIButton *otherBtn; //类别 - 其他
 */
#pragma mark 类别按钮点击事件
- (IBAction)classTypeBtnClick:(UIButton *)sender {
    self.brandCustomerCategoryId = sender.tag;
    if (sender == self.distributorBtn) {
        //经销商
        self.indexClassType = ClassTypeDistributor;
        self.distributorBtn.selected = YES;
        self.investorBtn.selected = NO;
        self.otherBtn.selected = NO;
        
    }else if (sender == self.investorBtn) {
        //投资商
        self.indexClassType = ClassTypeInvestor;
        self.distributorBtn.selected = NO;
        self.investorBtn.selected = YES;
        self.otherBtn.selected = NO;
        
    }else if (sender == self.otherBtn) {
        //其他
        self.indexClassType = ClassTypeOther;
        self.distributorBtn.selected = NO;
        self.investorBtn.selected = NO;
        self.otherBtn.selected = YES;
    }
}


#pragma mark
#pragma mark --  导航条返回按钮
-(void)setNav{
    self.view.backgroundColor = bgColor;
    
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"预约加盟";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

#pragma mark 返回按钮点击
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - FSDropDown datasource & delegate
- (NSInteger)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == menu.leftTableView) {
        
        switch (self.columntype) {
            case jobType:{
                
                return [_jobTypeAll count];
            }
                break;
            case industryType:{
                if (self.currentModel) {
                    
                    return [self.currentModel.children count];
                }
                else {
                    return 0;
                }
            }
                break;
            case investmentAmountsType:{
                
                return [_investmentAmount count];
            }
                break;
        }
    }
    else {
        
        switch (self.columntype) {
            case jobType:{
                
                return 1;
            }
                break;
            case industryType:{
                
                return [_industryAll count];
            }
                break;
            case investmentAmountsType:{
                
                return 1;
            }
                break;
        }
    }
}

- (NSString *)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView titleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == menu.leftTableView) {
        
        switch (self.columntype) {
            case jobType:{
                
                FindBrankModel *model = _jobTypeAll[indexPath.row];
                return model.categoryName;
            }
                break;
            case industryType:{
                
                NSDictionary *tempDic = self.currentModel.children[indexPath.row];
                return tempDic[@"categoryName"];
            }
                break;
            case investmentAmountsType:{
                
                FindBrankModel *model = _investmentAmount[indexPath.row];
                return model.categoryName;
            }
                break;
        }
    }
    else{
        
        switch (self.columntype) {
            case jobType:{
                
                return @"职务";
            }
                break;
            case industryType:{
                
                FindBrankModel *model = _industryAll[indexPath.row];
                return model.categoryName;
            }
                break;
            case investmentAmountsType:{
                
                return @"投资额度";
            }
                break;
        }
    }
}

- (void)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == menu.leftTableView) {
        
        switch (self.columntype) {
            case jobType:{
                
                //职务
                FindBrankModel *model = _jobTypeAll[indexPath.row];
                [self.dutiesBtn setTitle:model.categoryName   forState:UIControlStateNormal];
                self.postCategoryId = [model.postCategoryId integerValue];
            }
                break;
            case industryType:{
                
                NSDictionary *tempDic = self.currentModel.children[indexPath.row];
                [self.industryBtn setTitle:tempDic[@"categoryName"] forState:UIControlStateNormal];
                self.industryCategoryId2 = [tempDic[@"industryCategoryId"] integerValue];
            }
                break;
            case investmentAmountsType:{
                
                FindBrankModel *model = _investmentAmount[indexPath.row];
                [self.budgetBtn setTitle:model.categoryName forState:UIControlStateNormal];
                self.investmentAmountCategoryId = [model.investmentAmountCategoryId integerValue];
            }
                break;
        }
    }
    else{
        
        switch (self.columntype) {
            case jobType:{
                
            }
                break;
            case industryType:{
                
                FindBrankModel *model = _industryAll[indexPath.row];
                self.industryCategoryId = [model.industryCategoryId integerValue];
                self.currentModel = model;
            }
                break;
            case investmentAmountsType:{
                
            }
                break;
        }
        [menu.leftTableView reloadData];
    }
}


#pragma mark
#pragma mark - 请求数据
- (void)requestData{
    
    NSDictionary *param = @{};    // 请求参数
    
    // 投资额度
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brandCategory/investmentAmountCategoryList.do" params:param success:^(id JSON) {
        
        NSLog(@"投资额度\n%@ ",JSON);
        
        NSArray *dict = JSON[@"data"];
        
        if (![dict isEqual:[NSNull null]]) {
            
            [_investmentAmount removeAllObjects];
            
            // 第一个不限
            NSDictionary *firstDic = @{@"categoryName": @"不限",
                                       @"investmentAmountCategoryId": @0};
            FindBrankModel *model = [FindBrankModel findBrankWithDict:firstDic];
            [self.investmentAmount addObject:model];
            
            for (NSDictionary *tempDic in dict) {
                
                FindBrankModel *model = [FindBrankModel findBrankWithDict:tempDic];
                [self.investmentAmount addObject:model];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"投资额度 \n%@",error);
    }];
    
    // 行业类别
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brandCategory/industryAllList.do" params:nil success:^(id JSON) {
        
        NSLog(@"行业类别\n%@ ",JSON);
        
        NSDictionary *dict = JSON[@"data"];
        
        if (![dict isEqual:[NSNull null]]) {
            
            [_industryAll removeAllObjects];
            BOOL flag = NO;
            for (NSDictionary *tempDic in dict) {
                flag = YES;
                FindBrankModel *model = [FindBrankModel findBrankWithDict:tempDic];
                [self.industryAll addObject:model];
            }
//            FindBrankModel *model = _industryAll[0];
//            currentModel = flag?model:nil;
        }
    } failure:^(NSError *error) {
        
        NSLog(@"行业类别 \n%@",error);
    }];
    
    // 职务
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/houseFirstCategory/userPostCategorys.do" params:nil success:^(id JSON) {
        
        NSLog(@"职务\n%@ ",JSON);
        
        NSDictionary *dict = JSON[@"data"];
        
        if (![dict isEqual:[NSNull null]]) {
            
            [_jobTypeAll removeAllObjects];
            
            for (NSDictionary *tempDic in dict) {
                
                FindBrankModel *model = [FindBrankModel findBrankWithDict:tempDic];
                [self.jobTypeAll addObject:model];
            }
        }
    } failure:^(NSError *error) {
        
        NSLog(@"职务 \n%@",error);
    }];
}


@end
