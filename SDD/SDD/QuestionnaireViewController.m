//
//  QuestionnaireViewController.m
//  SDD
//  调查问卷
//  Created by mac on 15/10/22.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "QuestionnaireViewController.h"
#import "QustModel.h"
#import "GetCouponTableViewCell.h"

@interface QuestionnaireViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSInteger question1;
    NSInteger question2;
    NSInteger question3;
    NSInteger question4;
    NSInteger question5;
    NSInteger question6;
    
    NSNumber * questionnaireId;
    NSNumber * optionsId;
    
    NSNumber * questionnaireId1;
    NSNumber * optionsId1;
    
    NSNumber * questionnaireId2;
    NSNumber * optionsId2;
    
    NSNumber * questionnaireId3;
    NSNumber * optionsId3;
    
    NSNumber * questionnaireId4;
    NSNumber * optionsId4;
    
    NSNumber * questionnaireId5;
    NSNumber * optionsId5;
    
    NSNumber * questionnaireId6;
    NSNumber * optionsId6;
    
    NSNumber * questionnaireId7;
    NSNumber * optionsId7;
    
    NSNumber * questionnaireId8;
    NSNumber * optionsId8;
    
    NSNumber * questionnaireId9;
    NSNumber * optionsId9;
}
@property (retain,nonatomic)UITableView * table ;
@property (retain,nonatomic)NSMutableArray * dataArray;
@end

@implementation QuestionnaireViewController

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

-(void)requestData
{
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/sysQuestionnaire/list.do" params:@{@"pageNumber":@1,@"pageSize":@10} success:^(id JSON) {
        
        NSLog(@"%@",JSON);
        if (![JSON[@"data"] isEqual:[NSNull null]]) {
            
            for (NSDictionary * dic in JSON[@"data"]) {
                
                QustModel * model = [[QustModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            
            [_table reloadData];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    question1 = 1;
    question2 = 1;
    question3 = 1;
    question4 = 1;
    question5 = 1;
    question6 = 1;
    questionnaireId = @0;
    optionsId = @0;
    
    questionnaireId1 = @0;
    optionsId1 = @0;
    
    questionnaireId2 = @0;
    optionsId2 = @0;
    
    questionnaireId3 = @0;
    optionsId3 = @0;
    
    questionnaireId4 = @0;
    optionsId4 = @0;
    
    questionnaireId5 = @0;
    optionsId5 = @0;
    
    questionnaireId6 = @0;
    optionsId6 = @0;
    
    questionnaireId7 = @0;
    optionsId7 = @0;
    
    questionnaireId8 = @0;
    optionsId8 = @0;
    
    questionnaireId9 = @0;
    optionsId9 = @0;
    [self requestData];
    [self createView];
    
    [self createNvn];
}
#pragma mark - 设置导航条
-(void)createNvn{
    
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"调查问卷";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
}
- (void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)createView
{
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10 , viewWidth-20, 20)];
    titleLabel.text = @"您的任何回答都会得到严格保密";
    titleLabel.textColor = lgrayColor;
    titleLabel.font = largeFont;
    [self.view addSubview:titleLabel];
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, viewWidth, viewHeight-150) style:UITableViewStyleGrouped];
    _table.delegate = self;
    _table.dataSource = self;
    _table.backgroundColor = bgColor;
    //_table.scrollEnabled = NO;
    [self.view addSubview:_table];
    
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"提交" forState:UIControlStateNormal];
    [button1 setBackgroundColor:dblueColor];
    [Tools_F setViewlayer:button1 cornerRadius:5 borderWidth:1 borderColor:dblueColor];
    [button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    //_table.tableFooterView = button1;
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-10);
        make.left.equalTo(self.view.mas_left).with.offset(10);

        make.height.equalTo(@45);
        make.width.equalTo(@(viewWidth-20));
    }];
}
-(void)buttonClick:(UIButton *)btn
{
    NSDictionary * dict = @{@"list":@[
  @{@"questionnaireId":questionnaireId,@"optionsId":optionsId},
  @{@"questionnaireId":questionnaireId1,@"optionsId":optionsId1},
  @{@"questionnaireId":questionnaireId2,@"optionsId":optionsId2},
  @{@"questionnaireId":questionnaireId3,@"optionsId":optionsId3},
  @{@"questionnaireId":questionnaireId4,@"optionsId":optionsId4},
  @{@"questionnaireId":questionnaireId5,@"optionsId":optionsId5},
  @{@"questionnaireId":questionnaireId6,@"optionsId":optionsId6},
  @{@"questionnaireId":questionnaireId7,@"optionsId":optionsId7},
  @{@"questionnaireId":questionnaireId8,@"optionsId":optionsId8},
  @{@"questionnaireId":questionnaireId9,@"optionsId":optionsId9}]};
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/sysQuestionnaireAnswered/add.do" params:dict success:^(id JSON) {
        
        NSLog(@"%@",JSON);
        if ([JSON[@"status"] integerValue]== 1) {
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:JSON[@"message"] delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [alert show];
        }

    } failure:^(NSError *error) {
        
    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }
    else
    {
        return 10;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QustModel * model = _dataArray[indexPath.section];
    if (model.options.count <= 2) {
        return 115;
    }
    else if (model.options.count == 3)
    {
        return 150;
    }
    else
    {
        return 180;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"GetCoupon%d%d",(int)indexPath.section,(int)indexPath.row];
    //    static NSString *identifier = @"GetCoupon";
    //重用机制
    GetCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: identifier];      //带标识符的出列
    
    
    if (cell == nil) {
        // 当不存在的时候用重用标识符生成
        cell = [[GetCouponTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellType = nothing;
        
        QustModel * model = _dataArray[indexPath.section];
        UILabel * question = [[UILabel alloc] init];
        question.text = [NSString stringWithFormat:@"Q%ld、%@",indexPath.section+1,model.question];
        question.numberOfLines = 0;
        question.font = titleFont_15;
        [cell addSubview:question];
        [question mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.mas_top).with.offset(10);
            make.left.equalTo(cell.mas_left).with.offset(10);
            make.right.equalTo(cell.mas_right).with.offset(-10);
        }];
        
        if (model.options.count <= 2) {
            
            UIButton * btnO = [UIButton buttonWithType:UIButtonTypeCustom];
            [self quicklyRadioButton:btnO Tag:100 Title:@""];
            [Tools_F setViewlayer:btnO cornerRadius:3 borderWidth:0.01 borderColor:[UIColor whiteColor]];
            [btnO addTarget:self action:@selector(btnCAction:) forControlEvents:UIControlEventTouchUpInside];
            btnO.tag = 100;
            [cell addSubview:btnO];
            [btnO mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(question.mas_bottom).with.offset(12);
                make.left.equalTo(cell.mas_left).with.offset(10);
                make.width.equalTo(@30);
                make.height.equalTo(@15);
            }];
            
            NSDictionary * dic = model.options[0];
            UILabel * label1 = [[UILabel alloc] init];
            label1.text = dic[@"option"];
            label1.font = titleFont_15;
            [cell addSubview:label1];
            [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(question.mas_bottom).with.offset(8);
                make.left.equalTo(btnO.mas_right).with.offset(10);
                make.right.equalTo(cell.mas_right).with.offset(-10);
            }];
            
            UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            [self quicklyRadioButton:btn1 Tag:101 Title:@""];
            [btn1 addTarget:self action:@selector(btnCAction:) forControlEvents:UIControlEventTouchUpInside];
            btn1.tag = 101;
            [Tools_F setViewlayer:btn1 cornerRadius:3 borderWidth:0.01 borderColor:[UIColor whiteColor]];
            [cell addSubview:btn1];
            [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(btnO.mas_bottom).with.offset(15);
                make.left.equalTo(cell.mas_left).with.offset(10);
                make.width.equalTo(@30);
                make.height.equalTo(@15);
            }];
            NSDictionary * dict = model.options[1];
            UILabel * label2 = [[UILabel alloc] init];
            label2.text = dict[@"option"];
            label2.font = titleFont_15;
            [cell addSubview:label2];
            [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(label1.mas_bottom).with.offset(12);
                make.left.equalTo(btn1.mas_right).with.offset(10);
                make.right.equalTo(cell.mas_right).with.offset(-10);
            }];
        }
        else if(model.options.count == 3)
        {
            
            UIButton * btnO = [UIButton buttonWithType:UIButtonTypeCustom];
            [self quicklyRadioButton:btnO Tag:100 Title:@""];
            [btnO addTarget:self action:@selector(btnCAction:) forControlEvents:UIControlEventTouchUpInside];
            btnO.tag = 100;
            [Tools_F setViewlayer:btnO cornerRadius:3 borderWidth:0.01 borderColor:[UIColor whiteColor]];
            [cell addSubview:btnO];
            [btnO mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(question.mas_bottom).with.offset(12);
                make.left.equalTo(cell.mas_left).with.offset(10);
                make.width.equalTo(@30);
                make.height.equalTo(@15);
            }];
            
            NSDictionary * dic = model.options[0];
            UILabel * label1 = [[UILabel alloc] init];
            label1.text = dic[@"option"];
            label1.font = titleFont_15;
            [cell addSubview:label1];
            [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(question.mas_bottom).with.offset(8);
                make.left.equalTo(btnO.mas_right).with.offset(10);
                make.right.equalTo(cell.mas_right).with.offset(-10);
            }];
            
            UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            [self quicklyRadioButton:btn1 Tag:101 Title:@""];
            [btn1 addTarget:self action:@selector(btnCAction:) forControlEvents:UIControlEventTouchUpInside];
            btn1.tag = 101;
            [Tools_F setViewlayer:btn1 cornerRadius:3 borderWidth:0.01 borderColor:[UIColor whiteColor]];
            [cell addSubview:btn1];
            [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(btnO.mas_bottom).with.offset(15);
                make.left.equalTo(cell.mas_left).with.offset(10);
                make.width.equalTo(@30);
                make.height.equalTo(@15);
            }];
            NSDictionary * dict = model.options[1];
            UILabel * label2 = [[UILabel alloc] init];
            label2.text = dict[@"option"];
            label2.font = titleFont_15;
            [cell addSubview:label2];
            [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(label1.mas_bottom).with.offset(12);
                make.left.equalTo(btn1.mas_right).with.offset(10);
                make.right.equalTo(cell.mas_right).with.offset(-10);
            }];
            
            UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
            [self quicklyRadioButton:btn2 Tag:102 Title:@""];
            [btn2 addTarget:self action:@selector(btnCAction:) forControlEvents:UIControlEventTouchUpInside];
            btn2.tag = 102;
            [Tools_F setViewlayer:btn2 cornerRadius:3 borderWidth:0.01 borderColor:[UIColor whiteColor]];
            [cell addSubview:btn2];
            [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(btn1.mas_bottom).with.offset(15);
                make.left.equalTo(cell.mas_left).with.offset(10);
                make.width.equalTo(@30);
                make.height.equalTo(@15);
            }];
            NSDictionary * dicts = model.options[2];
            UILabel * label3 = [[UILabel alloc] init];
            label3.text = dicts[@"option"];
            label3.font = titleFont_15;
            [cell addSubview:label3];
            [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(label2.mas_bottom).with.offset(12);
                make.left.equalTo(btn1.mas_right).with.offset(10);
                make.right.equalTo(cell.mas_right).with.offset(-10);
            }];
        }
        else
        {
            UIButton * btnO = [UIButton buttonWithType:UIButtonTypeCustom];
            [self quicklyRadioButton:btnO Tag:100 Title:@""];
            [btnO addTarget:self action:@selector(btnCAction:) forControlEvents:UIControlEventTouchUpInside];
            btnO.tag = 100;
            [Tools_F setViewlayer:btnO cornerRadius:3 borderWidth:0.01 borderColor:[UIColor whiteColor]];
            [cell addSubview:btnO];
            [btnO mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(question.mas_bottom).with.offset(12);
                make.left.equalTo(cell.mas_left).with.offset(10);
                make.width.equalTo(@30);
                make.height.equalTo(@15);
            }];
            
            NSDictionary * dic = model.options[0];
            UILabel * label1 = [[UILabel alloc] init];
            label1.text = dic[@"option"];
            label1.font = titleFont_15;
            [cell addSubview:label1];
            [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(question.mas_bottom).with.offset(8);
                make.left.equalTo(btnO.mas_right).with.offset(10);
                make.right.equalTo(cell.mas_right).with.offset(-10);
            }];
            
            UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            [self quicklyRadioButton:btn1 Tag:101 Title:@""];
            [btn1 addTarget:self action:@selector(btnCAction:) forControlEvents:UIControlEventTouchUpInside];
            btn1.tag = 101;
            [Tools_F setViewlayer:btn1 cornerRadius:3 borderWidth:0.01 borderColor:[UIColor whiteColor]];
            [cell addSubview:btn1];
            [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(btnO.mas_bottom).with.offset(15);
                make.left.equalTo(cell.mas_left).with.offset(10);
                make.width.equalTo(@30);
                make.height.equalTo(@15);
            }];
            NSDictionary * dict = model.options[1];
            UILabel * label2 = [[UILabel alloc] init];
            label2.text = dict[@"option"];
            label2.font = titleFont_15;
            [cell addSubview:label2];
            [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(label1.mas_bottom).with.offset(12);
                make.left.equalTo(btn1.mas_right).with.offset(10);
                make.right.equalTo(cell.mas_right).with.offset(-10);
            }];
            
            UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
            [self quicklyRadioButton:btn2 Tag:102 Title:@""];
            [btn2 addTarget:self action:@selector(btnCAction:) forControlEvents:UIControlEventTouchUpInside];
            btn2.tag = 102;
            [Tools_F setViewlayer:btn2 cornerRadius:3 borderWidth:0.01 borderColor:[UIColor whiteColor]];
            [cell addSubview:btn2];
            [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(btn1.mas_bottom).with.offset(15);
                make.left.equalTo(cell.mas_left).with.offset(10);
                make.width.equalTo(@30);
                make.height.equalTo(@15);
            }];
            NSDictionary * dicts = model.options[2];
            UILabel * label3 = [[UILabel alloc] init];
            label3.text = dicts[@"option"];
            label3.font = titleFont_15;
            [cell addSubview:label3];
            [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(label2.mas_bottom).with.offset(12);
                make.left.equalTo(btn1.mas_right).with.offset(10);
                make.right.equalTo(cell.mas_right).with.offset(-10);
            }];
            
            UIButton * btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
            [self quicklyRadioButton:btn3 Tag:103 Title:@""];
            [btn3 addTarget:self action:@selector(btnCAction:) forControlEvents:UIControlEventTouchUpInside];
            btn3.tag = 103;
            [Tools_F setViewlayer:btn3 cornerRadius:3 borderWidth:0.01 borderColor:[UIColor whiteColor]];
            [cell addSubview:btn3];
            [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(btn2.mas_bottom).with.offset(15);
                make.left.equalTo(cell.mas_left).with.offset(10);
                make.width.equalTo(@30);
                make.height.equalTo(@15);
            }];
            NSDictionary * dictst = model.options[3];
            UILabel * label4 = [[UILabel alloc] init];
            label4.text = dictst[@"option"];
            label4.font = titleFont_15;
            [cell addSubview:label4];
            [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(label3.mas_bottom).with.offset(12);
                make.left.equalTo(btn1.mas_right).with.offset(10);
                make.right.equalTo(cell.mas_right).with.offset(-10);
            }];
        }

    }
    
    return cell;
}

/**< 快速单选选项 */
- (void)quicklyRadioButton:(UIButton *)btn Tag:(NSInteger)theTag Title:(NSString *)string{
    
    UIImage * image = [Tools_F imageWithColor:lgrayColor size:CGSizeMake(15, 15)];
    UIImage * image1 = [Tools_F imageWithColor:tagsColor size:CGSizeMake(15, 15)];
    
    btn.tag = theTag;
    btn.titleLabel.font = midFont;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:image1 forState:UIControlStateSelected];
    [btn setTitle:string forState:UIControlStateNormal];
}


-(void)btnCAction:(UIButton *)btn
{
   
    UITableViewCell *cell = (UITableViewCell *)btn.superview;
    NSInteger  tag = (NSInteger)btn.tag-100;
    NSIndexPath * indexPath = [_table indexPathForCell:cell];
    
    QustModel * model = _dataArray[indexPath.section];
    NSLog(@"%ld----%ld--%ld",btn.tag, indexPath.section,tag);
    for (NSInteger i = 0; i < model.options.count; i ++) {
        
        UIButton * button = (UIButton *)[cell viewWithTag:100+i];
        button.selected = NO;
    }
    
    btn.selected = YES;
    NSDictionary * dic = model.options[btn.tag-100];
    
    switch (indexPath.section) {
        case 0:
        {
            questionnaireId = dic[@"questionnaireId"];
            optionsId = dic[@"optionsId"];
        }
            
            break;
         case 1:
        {
            questionnaireId1 = dic[@"questionnaireId"];
            optionsId1 = dic[@"optionsId"];
        }
            break;
        case 2:
        {
            questionnaireId2 = dic[@"questionnaireId"];
            optionsId2 = dic[@"optionsId"];
        }
            break;
        case 3:
        {
            questionnaireId3 = dic[@"questionnaireId"];
            optionsId3 = dic[@"optionsId"];
        }
            break;
        case 4:
        {
            questionnaireId4 = dic[@"questionnaireId"];
            optionsId4 = dic[@"optionsId"];
        }
            break;
        case 5:
        {
            questionnaireId5 = dic[@"questionnaireId"];
            optionsId5 = dic[@"optionsId"];
        }
            break;
        case 6:
        {
            questionnaireId6 = dic[@"questionnaireId"];
            optionsId6 = dic[@"optionsId"];
        }
            break;
        case 7:
        {
            questionnaireId7 = dic[@"questionnaireId"];
            optionsId7 = dic[@"optionsId"];
        }
            break;
        case 8:
        {
            questionnaireId8 = dic[@"questionnaireId"];
            optionsId8 = dic[@"optionsId"];
        }
            break;
        default:
        {
            questionnaireId9 = dic[@"questionnaireId"];
            optionsId9 = dic[@"optionsId"];
        }
            break;
    }

}
-(void)btnClick:(UIButton *)btn
{
    UITableViewCell *cell = (UITableViewCell *)btn.superview;
    
    for (int i = 0; i < 2; i ++) {
        
        UIButton * button = (UIButton *)[cell viewWithTag:100+i];
        button.selected = NO;
    }
    QustModel * model = _dataArray[0];
    btn.selected = YES;
    NSDictionary * dic = model.options[btn.tag-100];
    questionnaireId = dic[@"questionnaireId"];
    optionsId = dic[@"optionsId"];

   
}
-(void)btnAction:(UIButton *)btn
{
    UITableViewCell *cell = (UITableViewCell *)btn.superview;
    
    for (int i = 0; i < 2; i ++) {
        
        UIButton * button = (UIButton *)[cell viewWithTag:200+i];
        button.selected = NO;
    }
    QustModel * model = _dataArray[1];
    btn.selected = YES;
    NSDictionary * dic = model.options[btn.tag-200];
    questionnaireId1 = dic[@"questionnaireId"];
    optionsId1 = dic[@"optionsId"];

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
