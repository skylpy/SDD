//
//  QuestViewController.m
//  SDD
//
//  Created by mac on 15/10/27.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "QuestViewController.h"
#import "QustModel.h"

@interface QuestViewController ()
{
    UIScrollView * bg_scrollView;
    UIView* contentView;
}
@property (retain,nonatomic)NSMutableArray * dataArray;
@end

@implementation QuestViewController

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
            
            [self createView]; 
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestData];
    [self createNvn];
}
-(void)createView
{
    // 底部滚动
    bg_scrollView = [[UIScrollView alloc] init];
    bg_scrollView.backgroundColor = [UIColor whiteColor];
    //bg_scrollView.backgroundColor = bgColor;
    [self.view addSubview:bg_scrollView];
    [bg_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 底部view， 用于计算scrollview高度
    contentView = UIView.new;
    [bg_scrollView addSubview:contentView];
    contentView.backgroundColor = bgColor;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bg_scrollView);
        make.width.equalTo(bg_scrollView);
    }];
    
    for (int i = 0; i < _dataArray.count; i ++) {
       
        QustModel * model = _dataArray[i];
        
        UIView * commomView = [[UIView alloc] initWithFrame:CGRectMake(0, i*140, viewWidth, 150)];
        commomView.tag = 1200+i;
        commomView.backgroundColor = [UIColor whiteColor];
        [contentView addSubview:commomView];
        
        UILabel * question= [[UILabel alloc] init];
        question.text = [NSString stringWithFormat:@"Q%d、%@",i+1,model.question];
        question.numberOfLines = 0;
        question.tag = 1000+i;
        question.font = titleFont_15;
        [commomView addSubview:question];
        [question mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(commomView.mas_top).with.offset(10);
            make.left.equalTo(commomView.mas_left).with.offset(10);
            make.right.equalTo(commomView.mas_right).with.offset(-10);
        }];
        
        UIImage * image = [Tools_F imageWithColor:lgrayColor size:CGSizeMake(15, 15)];
        UIImage * image1 = [Tools_F imageWithColor:tagsColor size:CGSizeMake(15, 15)];
        
        
        if (model.options.count <= 2) {
            
            UIButton * btnO = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnO setImage:image forState:UIControlStateNormal];
            [btnO setImage:image1 forState:UIControlStateSelected];
            [btnO addTarget:self action:@selector(btnCAction:) forControlEvents:UIControlEventTouchUpInside];
            btnO.tag = 100;
            [commomView addSubview:btnO];
            [btnO mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(question.mas_bottom).with.offset(8);
                make.left.equalTo(commomView.mas_left).with.offset(10);
                make.width.equalTo(@30);
                make.height.equalTo(@15);
            }];
            
            NSDictionary * dic = model.options[0];
            UILabel * label1 = [[UILabel alloc] init];
            label1.text = dic[@"option"];
            label1.font = titleFont_15;
            [commomView addSubview:label1];
            [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(question.mas_bottom).with.offset(8);
                make.left.equalTo(btnO.mas_right).with.offset(10);
                make.right.equalTo(commomView.mas_right).with.offset(-10);
            }];
            
            UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn1 setImage:image forState:UIControlStateNormal];
            [btn1 setImage:image1 forState:UIControlStateSelected];
            [btn1 addTarget:self action:@selector(btnCAction:) forControlEvents:UIControlEventTouchUpInside];
            btn1.tag = 101;
            [commomView addSubview:btn1];
            [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(btnO.mas_bottom).with.offset(15);
                make.left.equalTo(commomView.mas_left).with.offset(10);
                make.width.equalTo(@30);
                make.height.equalTo(@15);
            }];
            NSDictionary * dict = model.options[1];
            UILabel * label2 = [[UILabel alloc] init];
            label2.text = dict[@"option"];
            label2.font = titleFont_15;
            [commomView addSubview:label2];
            [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(label1.mas_bottom).with.offset(12);
                make.left.equalTo(btn1.mas_right).with.offset(10);
                make.right.equalTo(commomView.mas_right).with.offset(-10);
            }];
        }
        else if(model.options.count == 3)
        {
            
            UIButton * btnO = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnO setImage:image forState:UIControlStateNormal];
            [btnO setImage:image1 forState:UIControlStateSelected];
            [btnO addTarget:self action:@selector(btnCAction:) forControlEvents:UIControlEventTouchUpInside];
            btnO.tag = 100;
            [commomView addSubview:btnO];
            [btnO mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(question.mas_bottom).with.offset(8);
                make.left.equalTo(commomView.mas_left).with.offset(10);
                make.width.equalTo(@30);
                make.height.equalTo(@15);
            }];
            
            NSDictionary * dic = model.options[0];
            UILabel * label1 = [[UILabel alloc] init];
            label1.text = dic[@"option"];
            label1.font = titleFont_15;
            [commomView addSubview:label1];
            [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(question.mas_bottom).with.offset(8);
                make.left.equalTo(btnO.mas_right).with.offset(10);
                make.right.equalTo(commomView.mas_right).with.offset(-10);
            }];
            
            UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn1 setImage:image forState:UIControlStateNormal];
            [btn1 setImage:image1 forState:UIControlStateSelected];
            [btn1 addTarget:self action:@selector(btnCAction:) forControlEvents:UIControlEventTouchUpInside];
            btn1.tag = 101;
            [commomView addSubview:btn1];
            [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(btnO.mas_bottom).with.offset(15);
                make.left.equalTo(commomView.mas_left).with.offset(10);
                make.width.equalTo(@30);
                make.height.equalTo(@15);
            }];
            NSDictionary * dict = model.options[1];
            UILabel * label2 = [[UILabel alloc] init];
            label2.text = dict[@"option"];
            label2.font = titleFont_15;
            [commomView addSubview:label2];
            [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(label1.mas_bottom).with.offset(12);
                make.left.equalTo(btn1.mas_right).with.offset(10);
                make.right.equalTo(commomView.mas_right).with.offset(-10);
            }];
            
            UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn2 setImage:image forState:UIControlStateNormal];
            [btn2 setImage:image1 forState:UIControlStateSelected];
            [btn2 addTarget:self action:@selector(btnCAction:) forControlEvents:UIControlEventTouchUpInside];
            btn2.tag = 102;
            [commomView addSubview:btn2];
            [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(btn1.mas_bottom).with.offset(15);
                make.left.equalTo(commomView.mas_left).with.offset(10);
                make.width.equalTo(@30);
                make.height.equalTo(@15);
            }];
            NSDictionary * dicts = model.options[2];
            UILabel * label3 = [[UILabel alloc] init];
            label3.text = dicts[@"option"];
            label3.font = titleFont_15;
            [commomView addSubview:label3];
            [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(label2.mas_bottom).with.offset(12);
                make.left.equalTo(btn1.mas_right).with.offset(10);
                make.right.equalTo(commomView.mas_right).with.offset(-10);
            }];
        }
        else
        {
            UIButton * btnO = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnO setImage:image forState:UIControlStateNormal];
            [btnO setImage:image1 forState:UIControlStateSelected];
            [btnO addTarget:self action:@selector(btnCAction:) forControlEvents:UIControlEventTouchUpInside];
            btnO.tag = 100;
            [commomView addSubview:btnO];
            [btnO mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(question.mas_bottom).with.offset(8);
                make.left.equalTo(commomView.mas_left).with.offset(10);
                make.width.equalTo(@30);
                make.height.equalTo(@15);
            }];
            
            NSDictionary * dic = model.options[0];
            UILabel * label1 = [[UILabel alloc] init];
            label1.text = dic[@"option"];
            label1.font = titleFont_15;
            [commomView addSubview:label1];
            [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(question.mas_bottom).with.offset(8);
                make.left.equalTo(btnO.mas_right).with.offset(10);
                make.right.equalTo(commomView.mas_right).with.offset(-10);
            }];
            
            UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn1 setImage:image forState:UIControlStateNormal];
            [btn1 setImage:image1 forState:UIControlStateSelected];
            [btn1 addTarget:self action:@selector(btnCAction:) forControlEvents:UIControlEventTouchUpInside];
            btn1.tag = 101;
            [commomView addSubview:btn1];
            [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(btnO.mas_bottom).with.offset(15);
                make.left.equalTo(commomView.mas_left).with.offset(10);
                make.width.equalTo(@30);
                make.height.equalTo(@15);
            }];
            NSDictionary * dict = model.options[1];
            UILabel * label2 = [[UILabel alloc] init];
            label2.text = dict[@"option"];
            label2.font = titleFont_15;
            [commomView addSubview:label2];
            [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(label1.mas_bottom).with.offset(12);
                make.left.equalTo(btn1.mas_right).with.offset(10);
                make.right.equalTo(commomView.mas_right).with.offset(-10);
            }];
            
            UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn2 setImage:image forState:UIControlStateNormal];
            [btn2 setImage:image1 forState:UIControlStateSelected];
            [btn2 addTarget:self action:@selector(btnCAction:) forControlEvents:UIControlEventTouchUpInside];
            btn2.tag = 102;
            [commomView addSubview:btn2];
            [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(btn1.mas_bottom).with.offset(15);
                make.left.equalTo(commomView.mas_left).with.offset(10);
                make.width.equalTo(@30);
                make.height.equalTo(@15);
            }];
            NSDictionary * dicts = model.options[2];
            UILabel * label3 = [[UILabel alloc] init];
            label3.text = dicts[@"option"];
            label3.font = titleFont_15;
            [commomView addSubview:label3];
            [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(label2.mas_bottom).with.offset(12);
                make.left.equalTo(btn1.mas_right).with.offset(10);
                make.right.equalTo(commomView.mas_right).with.offset(-10);
            }];
            
            UIButton * btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn3 setImage:image forState:UIControlStateNormal];
            [btn3 setImage:image1 forState:UIControlStateSelected];
            [btn3 addTarget:self action:@selector(btnCAction:) forControlEvents:UIControlEventTouchUpInside];
            btn3.tag = 103;
            [commomView addSubview:btn3];
            [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(btn2.mas_bottom).with.offset(15);
                make.left.equalTo(contentView.mas_left).with.offset(10);
                make.width.equalTo(@30);
                make.height.equalTo(@15);
            }];
            NSDictionary * dictst = model.options[3];
            UILabel * label4 = [[UILabel alloc] init];
            label4.text = dictst[@"option"];
            label4.font = titleFont_15;
            [commomView addSubview:label4];
            [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(label3.mas_bottom).with.offset(12);
                make.left.equalTo(btn1.mas_right).with.offset(10);
                make.right.equalTo(commomView.mas_right).with.offset(-10);
            }];
        }
        
    }
    UILabel * label = (UILabel *)[contentView viewWithTag:1000+_dataArray.count-1];
    
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"提交" forState:UIControlStateNormal];
    [button1 setBackgroundColor:dblueColor];
    [Tools_F setViewlayer:button1 cornerRadius:5 borderWidth:1 borderColor:dblueColor];
    [button1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:button1];
    //_table.tableFooterView = button1;
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).with.offset(130);
        make.left.equalTo(label.mas_left).with.offset(10);
        
        make.height.equalTo(@45);
        make.width.equalTo(@(viewWidth-20));
    }];
    // 自动scrollview高度
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(button1.mas_bottom).with.offset(45);
    }];
}

-(void)btnCAction:(UIButton *)btn
{
    
//    UITableViewCell *cell = (UITableViewCell *)btn.superview;
//    NSInteger  tag = (NSInteger)btn.tag-100;
//    NSIndexPath * indexPath = [_table indexPathForCell:cell];
//    
//    QustModel * model = _dataArray[indexPath.section];
//    NSLog(@"%ld----%ld--%ld",btn.tag, indexPath.section,tag);
//    for (NSInteger i = 0; i < model.options.count; i ++) {
//        
//        UIButton * button = (UIButton *)[cell viewWithTag:100+i];
//        button.selected = NO;
//    }
//    
//    btn.selected = YES;
//    NSDictionary * dic = model.options[btn.tag-100];
//    
//    switch (indexPath.section) {
//        case 0:
//        {
//            questionnaireId2 = dic[@"questionnaireId"];
//            optionsId2 = dic[@"optionsId"];
//        }
//            
//            break;
//        case 1:
//        {
//            questionnaireId3 = dic[@"questionnaireId"];
//            optionsId3 = dic[@"optionsId"];
//        }
//            break;
//        case 2:
//        {
//            questionnaireId4 = dic[@"questionnaireId"];
//            optionsId4 = dic[@"optionsId"];
//        }
//            break;
//        default:
//        {
//            questionnaireId5 = dic[@"questionnaireId"];
//            optionsId5 = dic[@"optionsId"];
//        }
//            break;
//    }
    
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
