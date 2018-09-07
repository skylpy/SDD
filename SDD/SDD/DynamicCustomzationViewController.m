//
//  DynamicViewController.m
//  CustomIntention
//  订阅动态
//  Created by mac on 15/7/10.
//  Copyright (c) 2015年 linpeiyu. All rights reserved.
//

#import "DynamicCustomzationViewController.h"
#import "UIView+ZJQuickControl.h"
#import "Httprequest.h"

#import "RentShopsModel.h"

@interface DynamicCustomzationViewController ()
{
    int selectNum;
    int stateNum;
    UIView * bobyView;
    
    int indexListOne;
    int indexListTwo;
    int indexListThree;

    
    NSMutableArray * indexListArray;
    
}

@property (retain,nonatomic)NSMutableArray * dataArray;

@end

@implementation DynamicCustomzationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    indexListOne = 0;
    indexListTwo = 0;
    indexListThree = 0;
    
    selectNum = 0;
    stateNum = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    
    indexListArray = [[NSMutableArray alloc] init];
    
    [self createDownLoad];
    
    //[self createView];
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
    titleLabel.text = @"订阅资讯";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
//    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 0, 110, 20);
//    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [backBtn setTitle:@"订阅动态" forState:UIControlStateNormal];
//    
//    UIImageView * backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
//    backImage.image = [UIImage imageNamed:@"返回-图标.png"];
//    [backBtn addSubview: backImage];
//    
//    UIBarButtonItem * backBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem = backBtnItem;
}

#pragma mark -- 数据下载
-(void)createDownLoad
{
    //NSString * url = @"http://192.168.1.234:8180/user_mobile";
    NSString * path = @"/dynamicCategory/list.do";
    
    
    _dataArray = [[NSMutableArray alloc] init];
    [HttpRequest postWithNewIssueURL:SDD_MainURL path:path parameter:nil success:^(id Josn) {
        
        NSDictionary * dict = Josn;
        NSArray * ShopsArray = dict[@"data"];
        NSLog(@"%ld",ShopsArray.count);
        
        NSLog(@"%@",dict);
        
        for (NSDictionary * ShopsDict in ShopsArray) {
            RentShopsModel * model = [[RentShopsModel alloc] init];
            [model setValuesForKeysWithDictionary:ShopsDict];
            [_dataArray addObject:model];
        }
        [self createView];
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark --  导航条返回按钮点击事件
-(void)backBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 创建定制主界面UI
-(void)createView{
    //提示信息下的线
    UIImageView * SettingImageView =[self.view addImageViewWithFrame:CGRectMake(0,0, viewWidth, 30) image:@"line.png"];
    
    //设置提示信息
    UILabel * SettingLabel = [SettingImageView addLabelWithFrame:CGRectMake(10, 9, viewWidth, 12) text:@"最多可选择3项"];
    
    SettingLabel.font = bottomFont_12;
    SettingLabel.textColor = lgrayColor;
    
    bobyView = [[UIView alloc] initWithFrame:CGRectMake(0, 94-64, viewWidth, 146)];
    //bobyView.backgroundColor = [UIColor redColor];
    [self.view addSubview:bobyView];
    
    //NSArray * DynamicArray = @[@"今日头条",@"地产视点",@"产业聚焦",@"明星活动",@"人物访谈"];
    for (int i = 0; i < _dataArray.count; i ++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i%3*(viewWidth/3)+15, i/3*43+10, viewWidth/3-40, 30);
        [button setBackgroundImage:[UIImage imageNamed:@"today's headline_frame.png"] forState:UIControlStateNormal];
        
        RentShopsModel * model = _dataArray[i];
        NSString * titleStr  = model.categoryName;
        
        
        [button setTitle:titleStr forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
       
        UIImage * imageBtn = [Tools_F imageWithColor:dblueColor size:CGSizeMake(viewWidth/3-40, 30)];
         [button setBackgroundImage:imageBtn forState:UIControlStateSelected];
//        button.layer.cornerRadius = 5;
//        button.clipsToBounds = YES;
        button.tag = 200+i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bobyView addSubview:button];
    }
    
    //尾部视图
    UIImageView * FootImageView = [self.view addImageViewWithFrame:CGRectMake(0, 94+146-64, viewWidth, viewHeight-94+146-64
                                                                              ) image:@"rent shops_frame2.png"];
    
    //定制我的意向按钮
    UIButton * CustomIntentionBtn =[FootImageView addImageButtonWithFrame:CGRectMake(10, 20, viewWidth-20, 44) title:nil backgroud:nil action:^(UIButton *button) {
        
        
        RentShopsModel * model ;
        if(indexListArray.count > 0)
        {
            if (indexListArray.count >0) {
                indexListOne = 0;
                int indexOne = [indexListArray[0] intValue];
                model = _dataArray[indexOne];
                indexListOne = [model.dynamicCategoryId intValue];
                
                indexListTwo = 0;
                if (indexListArray.count > 1) {
                    //indexListTwo = 0;
                    int indexTwo = [indexListArray[1] intValue];
                    model = _dataArray[indexTwo];
                    indexListTwo = [model.dynamicCategoryId intValue];
                    indexListThree = 0;
                }
                if (indexListArray.count > 2) {
                    
                    int indexThree = [indexListArray[2] intValue];
                    model = _dataArray[indexThree];
                    indexListThree = [model.dynamicCategoryId intValue];
                }
            }
            
            NSDictionary * dict = @{
                                    @"indexList":@[@(indexListOne),
                                                   @(indexListTwo),
                                                   @(indexListThree)
                                                   ],
                                    @"type":@4
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
        }
        
        
    }];
    [CustomIntentionBtn setTitle:@"定制我的意向" forState:UIControlStateNormal];
    [CustomIntentionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [CustomIntentionBtn setBackgroundImage:[Tools_F imageWithColor:dblueColor size:CGSizeMake(viewWidth-40, 45)]forState:UIControlStateNormal];
    CustomIntentionBtn.layer.cornerRadius = 5;
    CustomIntentionBtn.clipsToBounds = YES;
    
}

#pragma mark -- 订阅动态五个选择按钮

-(void)buttonClick:(UIButton *)btn
{
    
    if (btn.selected == NO) {
        if (selectNum < 3) {
            btn.selected = YES;
            selectNum ++;
            [indexListArray addObject:[NSString stringWithFormat:@"%ld",btn.tag-200]];
        }
    }
    else
    {
        [indexListArray removeObject:[NSString stringWithFormat:@"%ld",btn.tag-200]];
        
        NSLog(@"indexListArray=%@",indexListArray);
        btn.selected = NO;
        selectNum --;
    }
    
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
