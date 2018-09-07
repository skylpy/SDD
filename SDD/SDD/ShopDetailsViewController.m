//
//  ShopDetailsViewController.m
//  SDD
//
//  Created by mac on 15/12/1.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ShopDetailsViewController.h"
#import "IntegralDetailsView.h"
#import "TextExplainsView.h"
#import "bottomView.h"
#import "IntegralModel.h"
#import "UIImageView+WebCache.h"
#import "RecordViewController.h"

@interface ShopDetailsViewController ()<UIAlertViewDelegate>

@property (retain,nonatomic)NSDictionary *GoodsDict;
@end

@implementation ShopDetailsViewController


-(void)requestData{

    [self showLoading:2];
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/score/rewardGoodsDetail.do" params:@{@"rewardGoodsId":_rewardGoodsId} success:^(id JSON) {
        
        NSLog(@"xiangq%@",JSON);
        if (![JSON[@"data"] isEqual:[NSNull null]]) {
            
            //[self.GoodsArr removeAllObjects];
            _GoodsDict = JSON[@"data"];
            
        }
        
        [self setupUI];
        [self hideLoading];
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    [self setNav:@"商铺详情"];
    //[self setupUI];
    [self requestData];
}

#pragma mark -- 设置UI
-(void)setupUI{

    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    
    [self.view addSubview:scrollView];
    
   
    
    IntegralDetailsView * integDVc = [[IntegralDetailsView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 200)];
    integDVc.identity.text = [NSString stringWithFormat:@"%@ 积分",_GoodsDict[@"score"]];//@"100 积分";
    [integDVc.exchangeBtn addTarget:self action:@selector(ExpBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [integDVc.exchangeBtn setTitle:@"马上兑换" forState:UIControlStateNormal];
//    if ([_GoodsDict[@"isDelete"] integerValue] == 0) {
//        
//        
//    }else{
//    
//        [integDVc.exchangeBtn setTitle:@"已兑换" forState:UIControlStateNormal];
//        integDVc.exchangeBtn.backgroundColor = lgrayColor;
//    }
    
    [integDVc.avatar sd_setImageWithURL:[NSURL URLWithString:_GoodsDict[@"defaultImage"]] placeholderImage:[UIImage imageNamed:@"cell_loading"]];
    integDVc.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:integDVc];
    
    NSString * originalString = [NSString stringWithFormat:@" %@ 积分",_GoodsDict[@"score"]];
    NSMutableAttributedString * paintString = [[NSMutableAttributedString alloc] initWithString:originalString];
    [paintString addAttribute:NSForegroundColorAttributeName
                        value:tagsColor
                        range:[originalString
                               rangeOfString:[NSString stringWithFormat:@"%@",_GoodsDict[@"score"]]]];
    integDVc.identity.attributedText = paintString;
    
    UILabel * lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(integDVc.frame), viewWidth, 1)];
    lineLabel.backgroundColor = lgrayColor;
    [scrollView addSubview:lineLabel];
    
    TextExplainsView * textExp = [[TextExplainsView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineLabel.frame), viewWidth, [Tools_F countingSize:_GoodsDict[@"goodsContent"] fontSize:16 width:viewWidth].height+60)];
    textExp.backgroundColor = [UIColor whiteColor];
    textExp.titleLable.text = @"商品详情";
    textExp.explainsLabel.text = _GoodsDict[@"goodsContent"];
    [scrollView addSubview:textExp];
    
    
    TextExplainsView * textPro = [[TextExplainsView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(textExp.frame)+10, viewWidth, [Tools_F countingSize:_GoodsDict[@"rewardRule"] fontSize:16 width:viewWidth].height+60)];
    textPro.backgroundColor = [UIColor whiteColor];
    textPro.titleLable.text = @"兑换流程";
    textPro.explainsLabel.text = _GoodsDict[@"rewardRule"];
    [scrollView addSubview:textPro];
    
    TextExplainsView * textAttention = [[TextExplainsView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(textPro.frame)+10, viewWidth, [Tools_F countingSize:_GoodsDict[@"precautions"] fontSize:16 width:viewWidth].height+60)];
    textAttention.backgroundColor = [UIColor whiteColor];
    textAttention.titleLable.text = @"注意事项";
    textAttention.explainsLabel.text =_GoodsDict[@"precautions"];
    [scrollView addSubview:textAttention];
    
    scrollView.contentSize = CGSizeMake(viewWidth, CGRectGetMaxY(textAttention.frame)+80);
    
    
    bottomView * boyView = [[bottomView alloc] initWithFrame:CGRectMake(0, viewHeight-114, viewWidth, 50)];
    [boyView.freeBtn setTitle:[NSString stringWithFormat:@"消耗 %@ 积分",_GoodsDict[@"score"]] forState:UIControlStateNormal];
    [boyView.ExpBtn setTitle:@"马上兑换" forState:UIControlStateNormal];
    [boyView.ExpBtn addTarget:self action:@selector(ExpBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:boyView];
    
}

#pragma mark -- 兑换记录
-(void)ExpBtnClick:(UIButton *)btn{

    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                     message:[NSString stringWithFormat:@"您将消耗%@积分兑换商品,确定兑换？",_GoodsDict[@"score"]]
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"确定", nil];
    [alert show];
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {
        
        [HttpTool postWithBaseURL:SDD_MainURL Path:@"/score/addConverGoodsLog.do" params:@{@"rewardGoodsId":_GoodsDict[@"rewardGoodsId"],@"goodsQty":@1} success:^(id JSON) {
            
            NSLog(@"%@%@",JSON[@"message"],JSON[@"status"]);
            if ([JSON[@"status"] integerValue] == 1) {
                
                RecordViewController * recordVc = [[RecordViewController alloc] init];
                
                [self.navigationController pushViewController:recordVc animated:YES];
                
            }else{
                
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:JSON[@"message"]
                                                                delegate:self
                                                       cancelButtonTitle:@"好"
                                                       otherButtonTitles:nil, nil];
                [alert show];
            }
            
            
        } failure:^(NSError *error) {
            
        }];
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
