//
//  integralViewController.m
//  SDD
//
//  Created by mac on 15/12/1.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "integralViewController.h"
#import "PersonalCollectionViewCell.h"
#import "PersonalTabButton.h"
#import "IntegralBtn.h"
#import "EarnPointsViewController.h"
#import "IntegralRecordViewController.h"
#import "ExplainViewController.h"
#import "ExchangeCollectionViewCell.h"

#import "ShopDetailsViewController.h"
#import "RecordViewController.h"
#import "ExpCollectionViewCell.h"
#import "ExpgCollectionViewCell.h"
#import "CollectionCell.h"
#import "SDCycleScrollView.h"
#import "UserInfo.h"
#import "IntegralModel.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"

@interface integralViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SDCycleScrollViewDelegate>{

    /*- ui -*/
    
    UICollectionView *indexCollectionView;
    
    /*- data -*/
    
    NSDictionary *userInfoDic;
    NSDictionary *itemDic;
    
    /*- data -*/
    NSArray *dataSource;
    
    NSInteger unreadMessagesCount;//没读消息总数
    
    SDCycleScrollView * headScrollView;
    
    NSDictionary * dictD;
    
    NSInteger pages;
}
@property (retain,nonatomic)NSMutableArray *imageArr;
@property (retain,nonatomic)NSMutableArray *GoodsArr;
@end

@implementation integralViewController

-(NSMutableArray *)GoodsArr{
    
    if (!_GoodsArr) {
        
        _GoodsArr = [[NSMutableArray alloc] init];
    }
    return _GoodsArr;
}

-(NSMutableArray *)imageArr{

    if (!_imageArr) {
        
        _imageArr = [[NSMutableArray alloc] init];
    }
    return _imageArr;
}

-(void)viewWillAppear:(BOOL)animated{

    [self reqtestData];
    [self requestListGoods];
}

-(void)requestListGoods{

    [self showLoading:2];
    //商品列表
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/score/searchRewardGoods.do" params:@{@"pageNumber":@1,@"pageSize":@(pages)} success:^(id JSON) {
        
        NSLog(@"商品列表 %@-----",JSON);
        if (![JSON[@"data"] isEqual:[NSNull null]]) {
            
            [self.GoodsArr removeAllObjects];
            [indexCollectionView.footer endRefreshing];
            for (NSDictionary * dict in JSON[@"data"]) {
                
                IntegralModel * model = [[IntegralModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.GoodsArr addObject:model];
                
            }
            // 判断数据个数与请求个数
            if ([_GoodsArr count]<pages) {
                
                // 拿到当前的上拉刷新控件，变为没有更多数据的状态
                [indexCollectionView.footer noticeNoMoreData];
            }
            
        }
        [self hideLoading];
        [indexCollectionView reloadData] ;
        [indexCollectionView.header endRefreshing];
        
    } failure:^(NSError *error) {
        [self hideLoading];
        [indexCollectionView.footer endRefreshing];
        [indexCollectionView.header endRefreshing];
    }];

}

-(void)requestData{

    
    //轮播图
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/score/bannerList.do" params:nil success:^(id JSON) {
        
        NSLog(@"轮播图  %@",JSON);
        
        if (![JSON[@"data"] isEqual:[NSNull null]]) {
            
            NSArray * bannerArr = JSON[@"data"];
            
            //imageArr = [NSMutableArray array];
            [self.imageArr removeAllObjects];
            for (NSDictionary *dict in bannerArr) {
                [self.imageArr addObject:dict[@"defaultImage"]];
            }
            headScrollView.imageURLStringsGroup = self.imageArr;
        }
        //[indexCollectionView reloadData] ;
        
    } failure:^(NSError *error) {
        
        
    }];
}

-(void)reqtestData{

    //我的积分 + 是否已签到
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/score/myScoreAndCheckSignup.do" params:nil success:^(id JSON) {
        
        NSLog(@"%@",JSON);
        if (![JSON[@"data"] isEqual:[NSNull null]]) {
            
            dictD = JSON[@"data"];
        }
        
        [indexCollectionView reloadData] ;
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    
    //NSLog(@"%@",[UserInfo sharedInstance].userInfoDic[@"realName"]);
    pages = 6;
    [self setUpNav];
    [self setupUI];
    [self requestData];
    //[self reqtestData];
}

-(void)setUpNav{

    [self setNav:@"积分商城"];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 30);
    [button setTitle:@"说明" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = titleFont_15;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * baItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = baItem;
}

#pragma mark -- 说明文本点击事件
-(void)buttonClick:(UIButton *)btn{

    ExplainViewController * explanVc = [[ExplainViewController alloc] init];
    [self.navigationController pushViewController:explanVc animated:YES];
    
}

#pragma mark -- 设置UI界面
-(void)setupUI{

    
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.minimumLineSpacing = 2;
    
    indexCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-20)collectionViewLayout:flowLayout];
    indexCollectionView.delegate = self;
    indexCollectionView.dataSource = self;
    indexCollectionView.backgroundColor = bgColor;
    
    [indexCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    [indexCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    [indexCollectionView registerNib:[UINib nibWithNibName:@"CollectionCell"
                                                    bundle:nil]
          forCellWithReuseIdentifier:@"PersonalCell"];     // 通过xib创建cell
    
    [self.view addSubview:indexCollectionView];
    
    [indexCollectionView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [indexCollectionView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(DropDownRefresh)];
}
#pragma mark -下拉刷新
-(void)DropDownRefresh{
    
    pages = 6;
    
    [self requestListGoods];
}
#pragma mark - 上拉加载
- (void)loadMoreData{
    
    pages+=6;
    [self showLoading:2];
    [self requestListGoods];
    NSLog(@"上拉加载%d个",pages);
}
#pragma mark - 定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _GoodsArr.count;
}

#pragma mark - 定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

#pragma mark - 每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellIdentifier = @"PersonalCell";
    CollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
   
    IntegralModel * model = _GoodsArr[indexPath.row];
    
    cell.titleLabel.text = model.goodsName;
    cell.iconimage1.image = [UIImage imageNamed:@"icon-points-y"];
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.numberlabel1.text = [NSString stringWithFormat:@"%@",model.score];
    cell.numberlabel1.textColor = tagsColor;
    
    [cell.buttongood setTitle:@"兑换" forState:UIControlStateNormal];
    //cell.headerImage.image = [UIImage imageNamed:@"cell_loading"];
    [cell.headerImage sd_setImageWithURL:[NSURL URLWithString:model.defaultImage] placeholderImage:[UIImage imageNamed:@"cell_loading"]];
    
    cell.buttongood.backgroundColor = tagsColor;
    [cell.buttongood setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cell.buttongood.titleLabel.font = midFont;

    cell.buttongood.layer.cornerRadius = 5;
    cell.buttongood.clipsToBounds = YES;
//    [cell.buttongood addTarget:self action:@selector(IntegralBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout 定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(viewWidth/2-2, viewWidth/2);
}

#pragma mark - 定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(1, 1, 15, 1);
}
#pragma mark - 返回头headerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = {viewWidth,250};
    return size;
}

#pragma mark -- 返回头headerView 或 尾FooterView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        if (reusableview == nil) {
            
            reusableview = [[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 250)];//320
        }
        // 背景颜色
        reusableview.backgroundColor = [UIColor whiteColor];
        // 移除旧，新增视图
        for (UIView *all in reusableview.subviews) {
            [all removeFromSuperview];
        }
        headScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, viewWidth,120) imageURLStringsGroup:self.imageArr];
        headScrollView.autoScrollTimeInterval = 4;
        headScrollView.infiniteLoop = YES;
        headScrollView.delegate = self;
        headScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        headScrollView.dotColor = tagsColor;
        headScrollView.placeholderImage = [UIImage imageNamed:@"cell_loading"];
        [reusableview addSubview:headScrollView];
        
        
        UILabel * coustLable = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(headScrollView.frame)+10, viewWidth/2, 20)];
        coustLable.font = titleFont_15;
        [reusableview addSubview:coustLable];
        NSString * originalString = [NSString stringWithFormat:@"%@  %@  积分",[UserInfo sharedInstance].userInfoDic[@"realName"],dictD[@"score"]];
        NSMutableAttributedString * paintString = [[NSMutableAttributedString alloc] initWithString:originalString];
        [paintString addAttribute:NSForegroundColorAttributeName
                            value:tagsColor
                            range:[originalString
                                   rangeOfString:[NSString stringWithFormat:@"%@",dictD[@"score"]]]];
        coustLable.attributedText = paintString;
        
        UIButton * Signbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        Signbtn.frame = CGRectMake(CGRectGetMaxX(reusableview.frame)-110, CGRectGetMaxY(headScrollView.frame)+10, 90, 25);
        
        Signbtn.layer.cornerRadius = 5;
        if ([dictD[@"isCanSignup"] integerValue] == 1) {
            
            [Signbtn setTitle:@"每日签到+1" forState:UIControlStateNormal];
            Signbtn.backgroundColor = tagsColor;
        }else{
        
            [Signbtn setTitle:@"今日已签" forState:UIControlStateNormal];
            Signbtn.backgroundColor = lgrayColor;
            Signbtn.enabled = NO;
        }
        
        Signbtn.titleLabel.font = midFont;
        Signbtn.clipsToBounds = YES;
        [Signbtn addTarget:self action:@selector(SignbtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [reusableview addSubview:Signbtn];
        
        
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(coustLable.frame)+10, viewWidth, 1)];
        lineView.backgroundColor = bgColor;
        [reusableview addSubview:lineView];
        
        UIView * btnView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame), viewWidth, 40)];
        btnView.backgroundColor = bgColor;
        [reusableview addSubview:btnView];
        
        NSArray * IntegralArr = @[@"赚积分",@"积分记录",@"兑换记录"];
        NSArray * imageArr = @[@"icon-points-b",@"icon-record",@"icon-order"];
        
        for (int i = 0; i < IntegralArr.count; i ++) {
            
            IntegralBtn * Integral = [[IntegralBtn alloc] initWithFrame:CGRectMake(i*(viewWidth/3), 0, viewWidth/3-1, 40)];
            Integral.backgroundColor = [UIColor whiteColor];
            [Integral setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
            [Integral setTitle:IntegralArr[i] forState:UIControlStateNormal];
            [Integral setTitleColor:lgrayColor forState:UIControlStateNormal];
            Integral.titleLabel.font = titleFont_15;
            Integral.tag = 1000+i;
            [Integral addTarget:self action:@selector(IntegralClick:) forControlEvents:UIControlEventTouchUpInside];
            [btnView addSubview:Integral];
        }
        
        UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(btnView.frame), viewWidth, 10)];
        bgView.backgroundColor = bgColor;
        [reusableview addSubview:bgView];
        
        UIView * imageView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame), viewWidth, 0)];
        imageView.backgroundColor = bgColor;
        [reusableview addSubview:imageView];
        
//        for (int i = 0; i < 2; i ++) {
//            
//            UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(i*(viewWidth/2-5)+5, 0, viewWidth/2-5, 60)];
//            imageV.image = [UIImage imageNamed:@"cell_loading"];
//            [imageView addSubview:imageV];
//        }
        
        
        UIView * bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame), viewWidth, 0)];
        bgView1.backgroundColor = bgColor;
        [reusableview addSubview:bgView1];
        
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(bgView1.frame)+10, viewWidth-20, 15)];
        titleLabel.text = @"商品兑换";
        titleLabel.font = titleFont_15;
        [reusableview addSubview:titleLabel];
        
        return reusableview;
    }
 
    
    return nil;
}

#pragma mark - UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                     message:@"努力开发中"
//                                                    delegate:self
//                                           cancelButtonTitle:@"好"
//                                           otherButtonTitles:nil, nil];
//    [alert show];
    IntegralModel * model = _GoodsArr[indexPath.row];
    ShopDetailsViewController * shopDVc = [[ShopDetailsViewController alloc] init];
    shopDVc.rewardGoodsId = model.rewardGoodsId;
    
    [self.navigationController pushViewController:shopDVc animated:YES];
}


#pragma mark -- 兑换点击事件
-(void)IntegralBtnClick:(UIButton *)btn{

    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                     message:@"兑换成功"
                                                    delegate:self
                                           cancelButtonTitle:@"好"
                                           otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark -- 签到
-(void)SignbtnClick:(UIButton *)btn{

    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/score/addSignup.do" params:nil success:^(id JSON) {
        
        if ([JSON[@"status"] integerValue]== 1) {
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                             message:@"恭喜你签到成功"
                                                            delegate:self
                                                   cancelButtonTitle:@"好"
                                                   otherButtonTitles:nil, nil];
            [alert show];
            [self reqtestData];
            
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

-(void)IntegralClick:(UIButton *)btn{

    switch (btn.tag) {
        case 1000:
        {
            EarnPointsViewController * eapVc = [[EarnPointsViewController alloc] init];
            [self.navigationController pushViewController:eapVc animated:YES];
        }
            break;
        case 1001:
        {
            IntegralRecordViewController * intrVc = [[IntegralRecordViewController alloc] init];
            [self.navigationController pushViewController:intrVc animated:YES];
        }
            break;
        default:
        {
        
//            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                             message:@"赶命开发中"
//                                                            delegate:self
//                                                   cancelButtonTitle:@"好"
//                                                   otherButtonTitles:nil, nil];
//            [alert show];
            RecordViewController * recordVc = [[RecordViewController alloc] init];
            [self.navigationController pushViewController:recordVc animated:YES];
        }
            break;
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
