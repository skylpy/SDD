//
//  ReservationController.m
//  SDD
//
//  Created by Cola on 15/4/12.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ReservationController.h"
#import "FindBrankModel.h"
#import "DateSelectView.h"

#import "ReservationTableViewController.h"
#import "GRDetailViewController.h"
#import "OrderReservationSucceedViewController.h"

#import "UIImageView+WebCache.h"
#import "NSString+SDD.h"

#import "FSDropDownMenu.h"

typedef NS_ENUM(NSInteger, ColumnType)
{
    industryType = 0,
    jobType = 1,
    formatType = 2,
    floorType = 3,
    regionType = 4,
};

@interface ReservationController()<UITextFieldDelegate,FSDropDownMenuDataSource,FSDropDownMenuDelegate>{
    
    /*- ui -*/
    
    UIView *top_bg;
    UIView *first_bottombg;
    UIView *second_bottombg;
    UIView *last_bottombg;
    
    UIView *shadowView;
    DateSelectView *dateSelectView;             // 日期选择
    
    FSDropDownMenu *dropMenu;
    
    UITextField *nameTextfield;                   /**< 姓名 */
    UITextField *phoneTextfield;                  /**< 手机号 */
    UITextField *codeTextfield;                   /**< 验证码 */
    UITextField *industryTextfield;               /**< 行业 */
    UITextField *brandTextfield;                  /**< 品牌 */
    UITextField *companyTextfield;                /**< 公司 */
    UITextField *departmentTextfield;             /**< 部门 */
    UITextField *jobTextfield;                    /**< 职位 */
    UITextField *dateTextfield;                   /**< 预约时间 */
    UITextField *formatTextfield;                 /**< 业态 */
    UITextField *floorsTextfield;                 /**< 楼层 */
    UITextField *regionTextfield;                 /**< 区域 */
    UITextField *areaTextfield;                   /**< 面积 */

    UIButton *getCode;                            /**< 获取验证码 */
    
    /*- data -*/
    
    ColumnType cType;
    FindBrankModel *currentModel;                 /**< 行业当前模型 */
    FindBrankModel *currentModel2;                /**< 楼层当前模型 */
    NSDate *dateSelected;                         /**< 预约时间 */
    
    NSInteger industryCategoryId;                 /**< 行业父 */
    NSInteger industryCategoryId2;                /**< 行业子 */
    NSInteger postCategoryId;                     /**< 职业 */
    NSInteger industryId;                         /**< 业态 */
    NSInteger floor;                              /**< 楼层 */
    NSInteger appointmentAreaId;                  /**< 区域 */
    
    NSTimer *_timer;                              /**< 倒计时 */
    int _second;                                  /**< 秒数 */
}

// 行业类别
@property (nonatomic, strong) NSMutableArray *industryAll;
// 职务类别
@property (nonatomic, strong) NSMutableArray *jobAll;
// 业态类别
@property (nonatomic, strong) NSMutableArray *formatAll;
// 楼层类别
@property (nonatomic, strong) NSMutableArray *floorsAll;

@end

@implementation ReservationController

- (NSMutableArray *)industryAll{
    if (!_industryAll) {
        _industryAll = [[NSMutableArray alloc]init];
    }
    return _industryAll;
}

- (NSMutableArray *)jobAll{
    if (!_jobAll) {
        _jobAll = [[NSMutableArray alloc]init];
    }
    return _jobAll;
}

- (NSMutableArray *)formatAll{
    if (!_formatAll) {
        _formatAll = [[NSMutableArray alloc]init];
    }
    return _formatAll;
}

- (NSMutableArray *)floorsAll{
    if (!_floorsAll) {
        _floorsAll = [[NSMutableArray alloc]init];
    }
    return _floorsAll;
}

#pragma mark - 请求数据
- (void)requestData{
    
    // 行业类别
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/brandCategory/industryAllList.do" params:nil success:^(id JSON) {
        
        //        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSDictionary *dict = JSON[@"data"];
        
        if (![dict isEqual:[NSNull null]]) {
            
            [_industryAll removeAllObjects];
            
            BOOL flag = NO;
            for (NSDictionary *tempDic in dict) {
                flag = YES;
                FindBrankModel *model = [FindBrankModel findBrankWithDict:tempDic];
                [self.industryAll addObject:model];
            }
            FindBrankModel *model = _industryAll[0];
            currentModel = flag?model:nil;
        }
    } failure:^(NSError *error) {
        
    }];
    
    // 职务
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/houseFirstCategory/userPostCategorys.do" params:nil success:^(id JSON) {
        
//        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSDictionary *dict = JSON[@"data"];
        
        if (![dict isEqual:[NSNull null]]) {
            
            [_jobAll removeAllObjects];
            
            for (NSDictionary *tempDic in dict) {
                
                FindBrankModel *model = [FindBrankModel findBrankWithDict:tempDic];
                [self.jobAll addObject:model];
            }
        }
    } failure:^(NSError *error) {
        
    }];
    
    NSDictionary *param = @{@"houseId": _houseID};
    
    // 业态
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/houseAppointmentVisit/industryCategoryList.do" params:param success:^(id JSON) {
        
//        NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        NSDictionary *dict = JSON[@"data"];
        
        if (![dict isEqual:[NSNull null]]) {
            
            [_formatAll removeAllObjects];
            
            for (NSDictionary *tempDic in dict) {
                
                FindBrankModel *model = [FindBrankModel findBrankWithDict:tempDic];
                [self.formatAll addObject:model];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 初始化
    industryCategoryId = 0;
    industryCategoryId2 = 0;
    industryId = 0;
    floor = 0;
    appointmentAreaId = 0;
    _second = 60;
    self.view.backgroundColor = bgColor;
    first_bottombg = [[UIView alloc] init];
    second_bottombg = [[UIView alloc] init];
    last_bottombg = [[UIView alloc] init];
    
    // nav
    [self setNav:_isOfficial? @"预约看铺":@"登记预约"];
    // 数据请求
    [self requestData];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    // 上方步骤
    top_bg = [[UIView alloc] init];
    top_bg.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:top_bg];
    
    [top_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(viewWidth, 45));
    }];
    
    NSArray *stepTitle = @[@"1、验证手机号",@"2、填写资料",@"3、填写需求"];
    
    UIButton *lastBtn;
    for (int i=0; i<stepTitle.count; i++) {
        
        // 步骤
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.font = midFont;
        btn.tag = 100+i;
        [btn setTitle:stepTitle[i] forState:UIControlStateNormal];
        [btn setTitleColor:lgrayColor forState:UIControlStateNormal];
        [btn setTitleColor:dblueColor forState:UIControlStateSelected];
        btn.userInteractionEnabled = NO;
        [btn addTarget:self action:@selector(stepClick:) forControlEvents:UIControlEventTouchUpInside];
        [top_bg addSubview:btn];
        
        btn.selected = lastBtn?NO:YES;
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(top_bg.mas_top);
            make.left.equalTo(lastBtn?lastBtn.mas_right:top_bg.mas_left);
            make.size.mas_equalTo(CGSizeMake(viewWidth/3, 45));
        }];
        
        if (lastBtn) {
            
            // 箭头
            UIImageView *arrow = [[UIImageView alloc] init];
            arrow.backgroundColor = [UIColor whiteColor];
            arrow.image = [UIImage imageNamed:@"home_top_arrow_deepblue"];
            arrow.contentMode = UIViewContentModeScaleAspectFit;
            [top_bg addSubview:arrow];
            
            [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(lastBtn.mas_centerY);
                make.centerX.equalTo(lastBtn.mas_right);
                make.size.mas_equalTo(CGSizeMake(13, 13));
            }];
        }
        
        lastBtn = btn;
    }
    
    // 下方内容
    NSArray *bottomViews = @[first_bottombg,second_bottombg,last_bottombg];
    for (int i=0; i<[bottomViews count]; i++) {
        
        UIView *view = bottomViews[i];
        view.backgroundColor = bgColor;
        view.hidden = YES;
        [self.view addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(top_bg.mas_bottom).offset(10);
            make.left.equalTo(self.view.mas_left);
            make.width.equalTo(self.view.mas_width);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    }
    
    // 设置内容
    [self setupFirst];
    [self setupSecond];
    [self setupLast];
    
    // 栏目选择
    dropMenu = [[FSDropDownMenu alloc] initWithOrigin:CGPointMake(0, viewHeight-364) andHeight:300];
    dropMenu.dataSource = self;
    dropMenu.delegate = self;
    [self.view addSubview:dropMenu];
}

#pragma mark - 第一步
- (void)setupFirst{
    
    first_bottombg.hidden = NO;
    
    UITextField *lastTextField;
    for (int i=0; i<3; i++) {
        
        // 标题
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 0, 70, 45);
        label.font = midFont;
        label.textColor = mainTitleColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        
        // 内容
        UITextField *textfield = [[UITextField alloc] init];
        textfield.font = midFont;
        textfield.textColor = mainTitleColor;
        textfield.backgroundColor = [UIColor whiteColor];
        textfield.leftView = label;
        textfield.leftViewMode = UITextFieldViewModeAlways;
        textfield.rightViewMode = UITextFieldViewModeAlways;
        [first_bottombg addSubview:textfield];
        
        [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastTextField?lastTextField.mas_bottom:first_bottombg.mas_top);
            make.left.equalTo(first_bottombg.mas_left);
            make.size.mas_equalTo(CGSizeMake(viewWidth, 45));
        }];
        
        // 分割线
        if (lastTextField) {
            
            UIView *cutoff = [[UIView alloc] init];
            cutoff.backgroundColor = ldivisionColor;
            [first_bottombg addSubview:cutoff];
            
            [cutoff mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastTextField.mas_bottom);
                make.left.equalTo(self.view.mas_left);
                make.size.mas_equalTo(CGSizeMake(viewWidth, 1));
            }];
        }
        
        switch (i) {
            case 0:
            {
                NSString *originalStr = @"*姓名:";
                NSMutableAttributedString *paintStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
                [paintStr addAttribute:NSForegroundColorAttributeName
                                 value:tagsColor
                                 range:[originalStr rangeOfString:@"*"]
                 ];
                label.attributedText = paintStr;
                textfield.placeholder = @"请输入您的姓名";
                nameTextfield = textfield;
            }
                break;
            case 1:
            {
                NSString *originalStr = @"*手机号:";
                NSMutableAttributedString *paintStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
                [paintStr addAttribute:NSForegroundColorAttributeName
                                 value:tagsColor
                                 range:[originalStr rangeOfString:@"*"]
                 ];
                label.attributedText = paintStr;
                textfield.placeholder = @"请输入您的手机号";
                
                phoneTextfield = textfield;
                phoneTextfield.keyboardType = UIKeyboardTypeNumberPad;//键盘类型
            }
                break;
            case 2:
            {
                NSString *originalStr = @"*验证码:";
                NSMutableAttributedString *paintStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
                [paintStr addAttribute:NSForegroundColorAttributeName
                                 value:tagsColor
                                 range:[originalStr rangeOfString:@"*"]
                 ];
                label.attributedText = paintStr;
                textfield.placeholder = @"请输入验证码";
                codeTextfield = textfield;
                
                UIView *rightView_bg = [[UIView alloc] init];
                rightView_bg.frame = CGRectMake(0, 0, 100, 45);
                rightView_bg.backgroundColor = [UIColor whiteColor];
                
                UIView *cutoff = [[UIView alloc] init];
                cutoff.frame = CGRectMake(0, 10, 1, 25);
                cutoff.backgroundColor = divisionColor;
                [rightView_bg addSubview:cutoff];
                
                getCode = [UIButton buttonWithType:UIButtonTypeCustom];
                getCode.frame = CGRectMake(CGRectGetMaxX(cutoff.frame), 0, 99, 45);
                [getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
                [getCode setTitleColor:mainTitleColor forState:UIControlStateNormal];
                getCode.titleLabel.font = midFont;
                [getCode addTarget:self action:@selector(verificationCode:) forControlEvents:UIControlEventTouchUpInside];
                [rightView_bg addSubview:getCode];
                
                textfield.rightView = rightView_bg;
                codeTextfield = textfield;
                codeTextfield.keyboardType = UIKeyboardTypeNumberPad;//键盘类型
            }
                break;
        }
        
        lastTextField = textfield;
    }
    
    // 下一步
    ConfirmButton *nextButton = [[ConfirmButton alloc] initWithFrame:CGRectZero
                                                               title:@"下一步"
                                                              target:self
                                                              action:@selector(toSecond)];
    nextButton.enabled = YES;
    [first_bottombg addSubview:nextButton];
    
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastTextField.mas_bottom).offset(40);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(viewWidth-40, 45));
    }];
}

#pragma mark - 第二步
- (void)setupSecond{
    
    UITextField *lastTextField;
    for (int i=0; i<5; i++) {
        
        // 标题
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 0, 70, 45);
        label.userInteractionEnabled = YES;
        label.font = midFont;
        label.textColor = mainTitleColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        
        // 内容
        UITextField *textfield = [[UITextField alloc] init];
        textfield.font = midFont;
        textfield.textColor = mainTitleColor;
        textfield.backgroundColor = [UIColor whiteColor];
        textfield.leftView = label;
        textfield.delegate = self;
        textfield.leftViewMode = UITextFieldViewModeAlways;
        textfield.rightViewMode = UITextFieldViewModeAlways;
        [second_bottombg addSubview:textfield];
        
        [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastTextField?lastTextField.mas_bottom:second_bottombg.mas_top);
            make.left.equalTo(first_bottombg.mas_left);
            make.size.mas_equalTo(CGSizeMake(viewWidth, 45));
        }];
        
        // 分割线
        if (lastTextField) {
            
            UIView *cutoff = [[UIView alloc] init];
            cutoff.backgroundColor = ldivisionColor;
            [second_bottombg addSubview:cutoff];
            
            [cutoff mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastTextField.mas_bottom);
                make.left.equalTo(self.view.mas_left);
                make.size.mas_equalTo(CGSizeMake(viewWidth, 1));
            }];
        }
        
        switch (i) {
            case 0:
            {
                UIImageView *arrow = [[UIImageView alloc] init];
                arrow.frame = CGRectMake(0, (45-13)/2, 18, 13);
                arrow.backgroundColor = [UIColor whiteColor];
                arrow.image = [UIImage imageNamed:@"gray_rightArrow"];
                arrow.contentMode = UIViewContentModeScaleAspectFit;
                textfield.rightView = arrow;
                
                label.text = @"行业:";
                textfield.placeholder = @"请输入您的行业";
                industryTextfield = textfield;
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button addTarget:self action:@selector(industrySelected) forControlEvents:UIControlEventTouchUpInside];
                [textfield addSubview:button];
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(textfield);
                }];
            }
                break;
            case 1:
            {
                label.text = @"品牌:";
                textfield.placeholder = @"请输入您的品牌名称";
                brandTextfield = textfield;
            }
                break;
            case 2:
            {
                label.text = @"公司:";
                textfield.placeholder = @"请输入您的公司";
                companyTextfield = textfield;
            }
                break;
            case 3:
            {
                label.text = @"部门:";
                textfield.placeholder = @"请输入您的部门";
                departmentTextfield = textfield;
            }
                break;
            case 4:
            {
                UIImageView *arrow = [[UIImageView alloc] init];
                arrow.frame = CGRectMake(0, (45-13)/2, 18, 13);
                arrow.backgroundColor = [UIColor whiteColor];
                arrow.image = [UIImage imageNamed:@"gray_rightArrow"];
                arrow.contentMode = UIViewContentModeScaleAspectFit;
                textfield.rightView = arrow;
                
                label.text = @"职位:";
                textfield.placeholder = @"请输入您的职位";
                jobTextfield = textfield;
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button addTarget:self action:@selector(jobSelected) forControlEvents:UIControlEventTouchUpInside];
                [textfield addSubview:button];
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(textfield);
                }];
            }
                break;
        }
        
        lastTextField = textfield;
    }
    
    // 下一步
    ConfirmButton *nextButton = [[ConfirmButton alloc] initWithFrame:CGRectZero
                                                               title:@"下一步"
                                                              target:self
                                                              action:@selector(toLast)];
    nextButton.enabled = YES;
    [second_bottombg addSubview:nextButton];
    
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastTextField.mas_bottom).offset(40);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(viewWidth-40, 45));
    }];
}

#pragma mark - 最后一步
- (void)setupLast{
    
    if (_isOfficial) {
        
        // 标题
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 0, 85, 45);
        label.font = midFont;
        label.textColor = mainTitleColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        
        // 内容
        UITextField *textfield = [[UITextField alloc] init];
        textfield.font = midFont;
        textfield.textColor = mainTitleColor;
        textfield.backgroundColor = [UIColor whiteColor];
        textfield.leftView = label;
        textfield.delegate = self;
        textfield.leftViewMode = UITextFieldViewModeAlways;
        textfield.rightViewMode = UITextFieldViewModeAlways;
        [last_bottombg addSubview:textfield];
        
        [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(last_bottombg.mas_top);
            make.left.equalTo(first_bottombg.mas_left);
            make.size.mas_equalTo(CGSizeMake(viewWidth, 45));
        }];
        
        UIImageView *arrow = [[UIImageView alloc] init];
        arrow.frame = CGRectMake(0, (45-13)/2, 18, 13);
        arrow.backgroundColor = [UIColor whiteColor];
        arrow.image = [UIImage imageNamed:@"gray_rightArrow"];
        arrow.contentMode = UIViewContentModeScaleAspectFit;
        textfield.rightView = arrow;
        
        NSString *originalStr = @"*预约时间:";
        NSMutableAttributedString *paintStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
        [paintStr addAttribute:NSForegroundColorAttributeName
                         value:tagsColor
                         range:[originalStr rangeOfString:@"*"]
         ];
        label.attributedText = paintStr;
        textfield.placeholder = @"请选择预约看铺时间";
        dateTextfield = textfield;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(dateSelected) forControlEvents:UIControlEventTouchUpInside];
        [textfield addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(textfield);
        }];
    }
    
    UITextField *lastTextField;
    for (int i=0; i<4; i++) {
        
        // 标题
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 0, 70, 45);
        label.font = midFont;
        label.textColor = mainTitleColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor whiteColor];
        
        // 内容
        UITextField *textfield = [[UITextField alloc] init];
        textfield.font = midFont;
        textfield.textColor = mainTitleColor;
        textfield.backgroundColor = [UIColor whiteColor];
        textfield.leftView = label;
        textfield.delegate = self;
        textfield.leftViewMode = UITextFieldViewModeAlways;
        textfield.rightViewMode = UITextFieldViewModeAlways;
        [last_bottombg addSubview:textfield];
        
        [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
            if (_isOfficial) {
                make.top.equalTo(lastTextField?lastTextField.mas_bottom:@55);
            }
            else {
                make.top.equalTo(lastTextField?lastTextField.mas_bottom:last_bottombg.mas_top);
            }
            make.left.equalTo(first_bottombg.mas_left);
            make.size.mas_equalTo(CGSizeMake(viewWidth, 45));
        }];
        
        // 分割线
        if (lastTextField) {
            
            UIView *cutoff = [[UIView alloc] init];
            cutoff.backgroundColor = ldivisionColor;
            [last_bottombg addSubview:cutoff];
            
            [cutoff mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastTextField.mas_bottom);
                make.left.equalTo(self.view.mas_left);
                make.size.mas_equalTo(CGSizeMake(viewWidth, 1));
            }];
        }
        
        switch (i) {
            case 0:
            {
                UIImageView *arrow = [[UIImageView alloc] init];
                arrow.frame = CGRectMake(0, (45-13)/2, 18, 13);
                arrow.backgroundColor = [UIColor whiteColor];
                arrow.image = [UIImage imageNamed:@"gray_rightArrow"];
                arrow.contentMode = UIViewContentModeScaleAspectFit;
                textfield.rightView = arrow;
                
                NSString *originalStr = @"*业态:";
                NSMutableAttributedString *paintStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
                [paintStr addAttribute:NSForegroundColorAttributeName
                                 value:tagsColor
                                 range:[originalStr rangeOfString:@"*"]
                 ];
                label.attributedText = paintStr;
                textfield.placeholder = @"请选择您的业态";
                formatTextfield = textfield;
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button addTarget:self action:@selector(formatSelected) forControlEvents:UIControlEventTouchUpInside];
                [textfield addSubview:button];
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(textfield);
                }];
            }
                break;
            case 1:
            {
                UIImageView *arrow = [[UIImageView alloc] init];
                arrow.frame = CGRectMake(0, (45-13)/2, 18, 13);
                arrow.backgroundColor = [UIColor whiteColor];
                arrow.image = [UIImage imageNamed:@"gray_rightArrow"];
                arrow.contentMode = UIViewContentModeScaleAspectFit;
                textfield.rightView = arrow;
                
                NSString *originalStr = @"*楼层:";
                NSMutableAttributedString *paintStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
                [paintStr addAttribute:NSForegroundColorAttributeName
                                 value:tagsColor
                                 range:[originalStr rangeOfString:@"*"]
                 ];
                label.attributedText = paintStr;
                textfield.placeholder = @"请选择您的楼层";
                floorsTextfield = textfield;
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button addTarget:self action:@selector(floorsSelected) forControlEvents:UIControlEventTouchUpInside];
                [textfield addSubview:button];
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(textfield);
                }];
            }
                break;
            case 2:
            {
                UIImageView *arrow = [[UIImageView alloc] init];
                arrow.frame = CGRectMake(0, (45-13)/2, 18, 13);
                arrow.backgroundColor = [UIColor whiteColor];
                arrow.image = [UIImage imageNamed:@"gray_rightArrow"];
                arrow.contentMode = UIViewContentModeScaleAspectFit;
                textfield.rightView = arrow;
                
                NSString *originalStr = @"*区域:";
                NSMutableAttributedString *paintStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
                [paintStr addAttribute:NSForegroundColorAttributeName
                                 value:tagsColor
                                 range:[originalStr rangeOfString:@"*"]
                 ];
                label.attributedText = paintStr;
                textfield.placeholder = @"请选择您的区域";
                regionTextfield = textfield;
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button addTarget:self action:@selector(areaSelected) forControlEvents:UIControlEventTouchUpInside];
                [textfield addSubview:button];
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(textfield);
                }];
            }
                break;
            case 3:
            {
                UILabel *units = [[UILabel alloc] init];
                units.frame = CGRectMake(0, (45-13)/2, 25, 13);
                units.backgroundColor = [UIColor whiteColor];
                units.textColor = dblueColor;
                units.text = @"m²";
                units.font = midFont;
                textfield.rightView = units;
                
                NSString *originalStr = @"*面积:";
                NSMutableAttributedString *paintStr = [[NSMutableAttributedString alloc] initWithString:originalStr];
                [paintStr addAttribute:NSForegroundColorAttributeName
                                 value:tagsColor
                                 range:[originalStr rangeOfString:@"*"]
                 ];
                label.attributedText = paintStr;
                textfield.placeholder = @"请输入您的面积";
                areaTextfield = textfield;
            }
                break;
        }
        
        lastTextField = textfield;
    }
    
    // 下一步
    ConfirmButton *nextButton = [[ConfirmButton alloc] initWithFrame:CGRectZero
                                                               title:@"立即预约"
                                                              target:self
                                                              action:@selector(createAppointment)];
    nextButton.enabled = YES;
    [last_bottombg addSubview:nextButton];
    
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastTextField.mas_bottom).offset(40);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(viewWidth-40, 45));
    }];
}

#pragma mark - 步骤选择
- (void)stepClick:(UIButton *)btn{
    
    [self.view endEditing:YES];
    btn.selected = YES;
    // 全隐藏
    first_bottombg.hidden = YES;
    second_bottombg.hidden = YES;
    last_bottombg.hidden = YES;
    // 显示
    NSInteger index = (NSInteger)btn.tag-100;
    switch (index) {
        case 0:
        {
            first_bottombg.hidden = NO;
        }
            break;
        case 1:
        {
            second_bottombg.hidden = NO;
        }
            break;
        case 2:
        {
            last_bottombg.hidden = NO;
        }
            break;
    }
}

#pragma mark - 跳第二步
- (void)toSecond{
    
    if (nameTextfield.text.length<1) {
        
        [self showErrorWithText:@"请输入您的姓名"];
    }
    else if (![Tools_F validateMobile:phoneTextfield.text]) {
        
        [self showErrorWithText:@"请输入11位手机号码"];
    }
    else if (codeTextfield.text.length != 4) {
        
        [self showErrorWithText:@"请输入4位验证码"];
    }
    else {
        
        UIButton *btn = (UIButton *)[top_bg viewWithTag:101];
        [self stepClick:btn];
    }
}

#pragma mark - 跳第三步
- (void)toLast{
    
//    if (nameTextfield.text.length<1) {
//        
//        [self showErrorWithText:@"请输入您的姓名"];
//    }
//    else if (![Tools_F validateMobile:phoneTextfield.text]) {
//        
//        [self showErrorWithText:@"请输入11位手机号码"];
//    }
//    else if (codeTextfield.text.length != 4) {
//        
//        [self showErrorWithText:@"请输入4位验证码"];
//    }
//    else {
    
        UIButton *btn = (UIButton *)[top_bg viewWithTag:102];
        [self stepClick:btn];
//    }
}

#pragma mark - 立即预约(完成)
- (void)createAppointment{
    
    if (industryId == 0) {
        
        [self showErrorWithText:@"请选择业态"];
    }
    else if (floor == 0){
        
        [self showErrorWithText:@"请选择楼层"];
    }
    else if (appointmentAreaId == 0){
        
        [self showErrorWithText:@"请选择区域"];
    }
    else if (areaTextfield.text.length < 1){
        
        [self showErrorWithText:@"请填写面积需求"];
    }
    else {
        
        if (_isOfficial) {
            NSDictionary *param = @{
                                    @"activityCategoryId":@(_activityCategoryId),
                                    @"appointmentAreaId":@(appointmentAreaId),
                                    @"appointmentVisitTime":@([dateSelected timeIntervalSince1970]),
                                    @"area":areaTextfield.text,
                                    @"brandName":brandTextfield.text,
                                    @"code":codeTextfield.text,
                                    @"company":companyTextfield.text,
                                    @"deptName":departmentTextfield.text,
                                    @"floor":@(floor),
                                    @"industryCategoryId":@(industryId),
                                    @"phone":phoneTextfield.text,
                                    @"postCategoryId":@(postCategoryId),
                                    @"realName":nameTextfield.text,
                                    @"userIndustryCategoryIdList":@[@(industryCategoryId),@(industryCategoryId2)]};
            
            [HttpTool postWithBaseURL:SDD_MainURL Path:@"/houseAppointmentVisit/add.do" params:param success:^(id JSON) {
                
                NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
                
                if ([JSON[@"status"] intValue] == 1) {
                    
                    NSLog(@"详情页");
                    
                    OrderReservationSucceedViewController *orsVC = [[OrderReservationSucceedViewController alloc] init];
                    orsVC.houseName = _houseName;
                    orsVC.houseId = _houseID;
                    orsVC.isOfficial = _isOfficial;
                    [self.navigationController pushViewController:orsVC animated:YES];
                }
                else {
                    // 失败则跳回第一步
                    [self showErrorWithText:JSON[@"message"]];
                    UIButton *btn = (UIButton *)[top_bg viewWithTag:100];
                    [self stepClick:btn];
                }
            } failure:^(NSError *error) {
                [self showErrorWithText:[NSString stringWithFormat:@"%@",error]];
            }];
        }
        else {
            
            NSDictionary *param = @{
//                                    @"activityCategoryId":@2,
                                    @"appointmentAreaId":@(appointmentAreaId),
                                    @"area":areaTextfield.text,
                                    @"brandName":brandTextfield.text,
                                    @"code":codeTextfield.text,
                                    @"company":companyTextfield.text,
                                    @"deptName":departmentTextfield.text,
                                    @"floor":@(floor),
                                    @"industryCategoryId":@(industryId),
                                    @"phone":phoneTextfield.text,
                                    @"postCategoryId":@(postCategoryId),
                                    @"realName":nameTextfield.text,
                                    @"userIndustryCategoryIdList":@[@(industryCategoryId),@(industryCategoryId2)]};
            
            [HttpTool postWithBaseURL:SDD_MainURL Path:@"/houseAppointmentSign/add.do" params:param success:^(id JSON) {
                
                NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
                
                if ([JSON[@"status"] intValue] == 1) {
                    
                    NSLog(@"详情页");
                    
                    OrderReservationSucceedViewController *orsVC = [[OrderReservationSucceedViewController alloc] init];
                    orsVC.houseName = _houseName;
                    orsVC.houseId = _houseID;
                    orsVC.isOfficial = _isOfficial;
                    [self.navigationController pushViewController:orsVC animated:YES];
                }
                else {
                    // 失败则跳回第一步
                    [self showErrorWithText:JSON[@"message"]];
                    UIButton *btn = (UIButton *)[top_bg viewWithTag:100];
                    [self stepClick:btn];
                }
            } failure:^(NSError *error) {
                [self showErrorWithText:[NSString stringWithFormat:@"%@",error]];
            }];
        }
    }
}

#pragma mark - 获取验证码
- (void)verificationCode:(id)sender{
    
    if (![Tools_F validateMobile:phoneTextfield.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请填写手机号"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSDictionary *dic = @{@"phone":phoneTextfield.text};
    
    NSString *urlString = [SDD_MainURL stringByAppendingString:@"/sms/user/sendAppointmentVisitCode.do"];              // 拼接主路径和请求内容成完整url
    [self sendRequest:dic url:urlString];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timingOfSixtySecond) userInfo:nil repeats:YES];
}

- (void)timingOfSixtySecond{
    
    getCode.userInteractionEnabled = NO;
    NSString *secondStr = [NSString stringWithFormat:@"%d秒后重新获取",(_second--) - 1];
    [getCode setTitleColor:[SDDColor sddSmallTextColor] forState:UIControlStateNormal];
    [getCode setTitle:secondStr forState:UIControlStateNormal];
    if (_second == 0) {
        [_timer invalidate];
        _timer = nil;
        _second = 60;
        [getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        [getCode setTitleColor:mainTitleColor forState:UIControlStateNormal];
        getCode.userInteractionEnabled = YES;
    }
}

- (void)onSuccess:(AFHTTPRequestOperation *)operation context:(id) responseObject{
    
    NSDictionary *dict = responseObject;
    
    NSInteger theStatus = [dict[@"status"] integerValue];
    if (theStatus != 1) {
        
        [_timer invalidate];
        _timer = nil;
        _second = 60;
        [getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        [getCode setTitleColor:mainTitleColor forState:UIControlStateNormal];
        getCode.userInteractionEnabled = YES;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:dict[@"message"]
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - FSDropDown datasource & delegate
- (NSInteger)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == menu.leftTableView) {
        switch (cType) {
            case industryType:{
                if (currentModel) {
                    return [currentModel.children count]+1;
                }
                else {
                    return 0;
                }
            }
                break;
            case jobType:{
                
                return [_jobAll count];
            }
                break;
            case formatType:{

                return [_formatAll count];
            }
                break;
            case floorType:{
                
                return [_floorsAll count];
            }
                break;
            case regionType:{
                
                return [currentModel2.areaList count];
            }
                break;
        }
    }
    else {
        switch (cType) {
            case industryType:{
                
                
                return [_industryAll count];
            }
                break;
            case jobType:{
                
                return 1;
            }
                break;
            case formatType:{
                
                return 1;
            }
                break;
            case floorType:{
                
                return 1;
            }
                break;
            case regionType:{
                
                return 1;
            }
                break;
        }
    }
}

- (NSString *)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView titleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == menu.leftTableView) {
        switch (cType) {
            case industryType:{
                
                if (indexPath.row == 0) {
                    return @"不限";
                }
                else {
                    
                    NSDictionary *tempDic = currentModel.children[indexPath.row-1];
                    return tempDic[@"categoryName"];
                }
            }
                break;
            case jobType:{
                
                FindBrankModel *model = _jobAll[indexPath.row];
                return model.categoryName;
            }
                break;
            case formatType:{
                
                FindBrankModel *model = _formatAll[indexPath.row];
                return model.categoryName;
            }
                break;
            case floorType:{
                
                FindBrankModel *model = _floorsAll[indexPath.row];
                return model.floorName;
            }
                break;
            case regionType:{
                
                NSDictionary *tempDic = currentModel2.areaList[indexPath.row];
                return tempDic[@"appointmentAreaName"];
            }
                break;
        }
        if (indexPath.row == 0) {
            return @"不限";
        }
        else {
            
            NSDictionary *tempDic = currentModel.children[indexPath.row-1];
            return tempDic[@"categoryName"];
        }
    }
    else {
        switch (cType) {
            case industryType:{
                
                FindBrankModel *model = _industryAll[indexPath.row];
                return model.categoryName;
            }
                break;
            case jobType:{
                
                return @"职务";
            }
                break;
            case formatType:{
                
                return @"业态";
            }
                break;
            case floorType:{
                
                return @"楼层";
            }
                break;
            case regionType:{
                
                return @"区域";
            }
                break;
        }
    }
}

- (void)menu:(FSDropDownMenu *)menu tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == menu.leftTableView) {
        switch (cType) {
            case industryType:{
                if (indexPath.row == 0) {
                    
                    industryTextfield.text = [NSString stringWithFormat:@"%@-不限",currentModel.categoryName];
                    industryCategoryId2 = 0;
                }
                else {
                    
                    NSDictionary *tempDic = currentModel.children[indexPath.row-1];
                    industryTextfield.text = tempDic[@"categoryName"];
                    industryCategoryId2 = [tempDic[@"industryCategoryId"] integerValue];
                }
            }
                break;
            case jobType:{
                
                FindBrankModel *model = _jobAll[indexPath.row];
                jobTextfield.text = model.categoryName;
                postCategoryId = [model.postCategoryId integerValue];
            }
                break;
            case formatType:{
                
                FindBrankModel *model = _formatAll[indexPath.row];
                formatTextfield.text = model.categoryName;
                industryId = [model.industryCategoryId integerValue];
                
                // 重置楼层、区域
                floorsTextfield.text = @"";
                floor = 0;
                appointmentAreaId = 0;
                regionTextfield.text = @"";
            }
                break;
            case floorType:{
                
                FindBrankModel *model = _floorsAll[indexPath.row];
                floorsTextfield.text = model.floorName;
                floor = [model.floor integerValue];
                currentModel2 = model;
                
                // 重置区域
                appointmentAreaId = 0;
                regionTextfield.text = @"";
            }
                break;
            case regionType:{
                
                NSDictionary *tempDic = currentModel2.areaList[indexPath.row];
                appointmentAreaId = [tempDic[@"appointmentAreaId"] integerValue];
                regionTextfield.text = tempDic[@"appointmentAreaName"];
            }
                break;
        }
    }
    else {
        switch (cType) {
            case industryType:{
                
                FindBrankModel *model = _industryAll[indexPath.row];
                industryCategoryId = [model.industryCategoryId integerValue];
                currentModel = model;
            }
                break;
            case jobType:{
                
            }
                break;
            case formatType:{
                
            }
                break;
            case floorType:{
                
            }
                break;
            case regionType:{
                
            }
                break;
        }
        [menu.leftTableView reloadData];
    }
}

#pragma mark - textField代理
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField == industryTextfield || textField == jobTextfield || textField == formatTextfield
        || textField == floorsTextfield || textField == regionTextfield) {
        
        return NO;
    }
    else {
        
        return YES;
    }
}

#pragma mark - 日期变动
- (void)dateChange:(UIDatePicker *)sender{
    
    dateSelected = sender.date;
    NSLog(@"时间——%@",dateSelected);
}

#pragma mark - 确认日期
- (void)selectedDate:(UIButton *)btn{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    dateTextfield.text = [formatter stringFromDate:dateSelected];    // table显示
    
    [UIView animateWithDuration:0.3 animations:^{
        shadowView.alpha = 0;
        [shadowView removeFromSuperview];
        [dateSelectView removeFromSuperview];
    }];
}

#pragma mark - 各类维度选择
- (void)industrySelected{
    
    cType = industryType;
    [self.view endEditing:YES];
    [dropMenu.rightTableView reloadData];
    [dropMenu menuTapped];
}

- (void)jobSelected{
    
    cType = jobType;
    [self.view endEditing:YES];
    [dropMenu.rightTableView reloadData];
    [dropMenu menuTapped];
}

- (void)formatSelected{
    
    cType = formatType;
    [self.view endEditing:YES];
    [dropMenu.rightTableView reloadData];
    [dropMenu menuTapped];
}

- (void)dateSelected{
    
    shadowView = [[UIView alloc] init];
    shadowView.backgroundColor = [UIColor blackColor];
    shadowView.alpha = 0;
    [self.view addSubview:shadowView];
    
    [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.edges.equalTo(self.view);
    }];
    
    dateSelectView = [[DateSelectView alloc] init];
    dateSelectView.theTitle.text = @"预约时间";
    
    NSTimeInterval a_day = 24*60*60;
    NSTimeInterval a_month = 24*60*60*60;
    NSDate *date = [NSDate date];
    NSDate *tomorrow = [date dateByAddingTimeInterval:a_day];          // 设置明天
    NSDate *monthsAgo = [date dateByAddingTimeInterval:a_month];          // 设置明天
    
    dateSelectView.theDatePicker.minimumDate = tomorrow;
    dateSelectView.theDatePicker.maximumDate = monthsAgo;       // 设置上下限日期
    
    dateSelected = tomorrow;           // 默认选明天
    [dateSelectView.theDatePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    [dateSelectView.confirmButton addTarget:self action:@selector(selectedDate:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:dateSelectView];
    [dateSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeZero);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        shadowView.alpha = 0.5;
        [dateSelectView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(viewWidth-40, 235));
        }];
    }];
}

- (void)floorsSelected{
    
    if (industryId == 0) {
        
        [self showErrorWithText:@"请先选择业态"];
    }
    else {
        
        NSDictionary *param = @{@"houseId": _houseID,@"industryCategoryId":@(industryId)};
        // 业态
        [HttpTool postWithBaseURL:SDD_MainURL Path:@"/houseAppointmentVisit/floorList.do" params:param success:^(id JSON) {
            
            NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
            NSDictionary *dict = JSON[@"data"];
            
            if (![dict isEqual:[NSNull null]]) {
                
                [_floorsAll removeAllObjects];
                
                for (NSDictionary *tempDic in dict) {
                    
                    FindBrankModel *model = [FindBrankModel findBrankWithDict:tempDic];
                    [self.floorsAll addObject:model];
                }
                
                cType = floorType;
                [self.view endEditing:YES];
                [dropMenu.rightTableView reloadData];
                [dropMenu menuTapped];
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)areaSelected{
    
    if (floor == 0) {
        
        [self showErrorWithText:@"请先选择楼层"];
    }
    else {
        
        cType = regionType;
        [self.view endEditing:YES];
        [dropMenu.rightTableView reloadData];
        [dropMenu menuTapped];
    }
}

@end
