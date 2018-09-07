//
//  MainBrankListViewController.m
//  SDD
//
//  Created by hua on 15/8/3.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "MainBrankListViewController.h"
#import "MainBrankCollectionViewCell.h"

#import "UIButton+WebCache.h"
#import "NSString+SDD.h"

@interface MainBrankListViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>{
    
    /*- ui -*/
    
//    UIScrollView *index_scrollView;
    
    /*- data -*/
    
    
}

@end

@implementation MainBrankListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = bgColor;
    
    [self setNav:_brandTitle];
    // 设置ui
    [self setupUI];
}

- (void)setupUI{
    
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-64)collectionViewLayout:flowLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = bgColor;
    [collectionView registerClass:[MainBrankCollectionViewCell class]
       forCellWithReuseIdentifier:@"CollectionViewCell"];
    
    [self.view addSubview:collectionView];
}

#pragma mark - 定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [_brandList count];
}

#pragma mark - 定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

#pragma mark - 每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * identifier = @"CollectionViewCell";
    MainBrankCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSArray *currentArr = _brandList;
    
    NSDictionary *currentDict = currentArr[indexPath.row];
    
    [cell.mainButton setTitle:currentDict[@"objectName"] forState:UIControlStateNormal];    
    [cell.mainButton sd_setImageWithURL:currentDict[@"objectLogo"]
                               forState:UIControlStateNormal
                       placeholderImage:[UIImage imageNamed:@"square_loading"]];

    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout 定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(viewWidth/3, 90);
}

#pragma mark - 定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"点击cell");
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//#pragma mark - indexSelected
//- (void)indexSelected:(UIButton *)btn{
//    
//    // 设置按钮选择状态
//    for (UIButton *tempBtn in self.view.subviews) {
//        if (tempBtn.tag >99 && tempBtn.tag < 103) {
//            tempBtn.selected = NO;      // 全部设置未选中
//        }
//    }
//    
//    btn.selected = YES;      // 当前按钮设置选中
//    // indexScrollView 随着变化
//    [index_scrollView setContentOffset:CGPointMake((btn.tag-100)*viewWidth, 0) animated:YES];
//}
//
//#pragma mark - scrollView 代理方法
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    
//    if (scrollView != index_scrollView) {
//        return;
//    }
//    CGPoint point = scrollView.contentOffset;      //记录滑动
//    
//    // 设置按钮选择状态
//    for ( UIButton *tempBtn in self.view.subviews) {
//        if (tempBtn.tag >99 && tempBtn.tag < 103) {
//            tempBtn.selected = NO;      // 全部设置未选中
//        }
//    }
//    
//    int countTag = point.x/self.view.frame.size.width+100;      // 计算按钮tag值
//    UIButton *clickBtn = (UIButton *)[self.view viewWithTag:countTag];
//    clickBtn.selected = YES;
//}

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
