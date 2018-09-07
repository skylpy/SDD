//
//  AllPhotoViewController.m
//  SDD
//
//  Created by hua on 15/5/12.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "AllPhotoViewController.h"
#import "TagsAndTables.h"

#import "FullScreenViewController.h"

#import "UIImageView+WebCache.h"

@interface AllPhotoViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    
    /*- data -*/
    
    NSMutableArray *haveImageColumnTitle; // 有图片的栏目标题
    
    // '全部'栏目的
    NSMutableArray *theAllUrl;
//    NSMutableArray *theAllPhotoUrlWithColumn;
    
}

// 有图片的栏目
@property (nonatomic, strong) NSMutableArray *haveImageColumn;
// 全部图片url
@property (nonatomic, strong) NSMutableArray *allPhotoUrl;
// 图片url对应栏目
@property (nonatomic, strong) NSMutableDictionary *allPhotoUrlWithColumn;

@end

@implementation AllPhotoViewController

- (NSMutableArray *)haveImageColumn{
    if (!_haveImageColumn) {
        _haveImageColumn = [[NSMutableArray alloc]init];
    }
    return _haveImageColumn;
}

- (NSMutableArray *)allPhotoUrl{
    if (!_allPhotoUrl) {
        _allPhotoUrl = [[NSMutableArray alloc]init];
    }
    return _allPhotoUrl;
}

- (NSMutableDictionary *)allPhotoUrlWithColumn{
    if (!_allPhotoUrlWithColumn) {
        _allPhotoUrlWithColumn = [[NSMutableDictionary alloc]init];
    }
    return _allPhotoUrlWithColumn;
}

#pragma mark - 设置
- (void)imageColumn{
    
    NSDictionary *imageColumnDict = @{
                        @"videoDefaultImages": @"视频",
                        @"panorama360Urls": @"360全景图",
                        @"trafficMapUrls": @"商圈图",
                        @"formatFigureUrls": @"业态图",
                        @"floorPlanUrls": @"平面图",
                        //@"modelMapUrls": @"户型图",
                        @"realMapUrls": @"实景图",
                        @"renderingUrls": @"效果图",
                        @"openHousesUrls": @"样板房",
                        @"projectSiteUrls": @"项目现场",
                        @"promotionalMaterialsUrls": @"推广物料",
                        @"supportingMapUrls": @"配套图集",
                        @"activityDiagramUrls": @"活动相册",
                        @"brandVIUrls": @"品牌VI",
                        @"terminalUrls": @"实体店展示",
                        @"productUrls": @"产品展示",
                        @"exhibitionUrls": @"展览会",
                        };
    
    // 得到有图片的相册
    NSArray *allColumnName = [imageColumnDict allKeys];
    
    [_haveImageColumn removeAllObjects];
    
    // 第一个全部
    [haveImageColumnTitle addObject:@"全部"];
    
    for (int i=0; i<[allColumnName count]; i++) {
        
        if ([_imageDict[allColumnName[i]] count]>0) {           // 该栏目有图片
            
            [self.haveImageColumn addObject:[allColumnName objectAtIndex:i]];
            [haveImageColumnTitle addObject: imageColumnDict[[allColumnName objectAtIndex:i]]];
        }
    }
    
    // 得到所有图片的url
    for (int i=0; i<[_haveImageColumn count]; i++) {
        
        NSArray *arr = _imageDict[_haveImageColumn[i]];
        NSInteger count1 = [arr count];
        
        for (int j=0; j<count1; j++) {

            [theAllUrl addObject:arr[j]];
            [self.allPhotoUrlWithColumn setValue:@[@(i),@(j)] forKey:arr[j]];
        }
        
        [self.allPhotoUrl addObject:arr];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 初始化
    //有图片的栏目标题
    haveImageColumnTitle = [NSMutableArray array];
    //'全部'栏目的
    theAllUrl = [NSMutableArray array];
    
    // 设置图片栏目字典
    [self imageColumn];
    
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置内容
- (void)setupUI{
    
    NSLog (@"theAll%@\n allPhotoUrl %@\n  allPhotoUrlWithColumn%@\n  haveImageColumnTitle%@\n",theAllUrl,_allPhotoUrl,_allPhotoUrlWithColumn,haveImageColumnTitle);
    
    switch (_imageFrom) {
        case Rent:
        {
            // 导航条
            [self setNav:@"项目相册"];
            
            NSMutableArray *viewArr = [NSMutableArray array];
            for (int i=0; i<[haveImageColumnTitle count]; i++) {
                
                // 初始化collectionView
                UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc] init];
                UICollectionView *myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-64)collectionViewLayout:flowLayout];
                myCollectionView.tag = 100+i;
                myCollectionView.delegate = self;
                myCollectionView.dataSource = self;
                myCollectionView.bounces = NO;
                myCollectionView.backgroundColor = [UIColor whiteColor];
                [myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"AllPhotoCell"];
                
                [viewArr addObject:myCollectionView];
            }
            
            TagsAndTables *baseView = [[TagsAndTables alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-64)
                                                                    titles:haveImageColumnTitle
                                                                     views:viewArr];
            [self.view addSubview:baseView];
        }
            break;
        case Brand:
        {
            // 导航条
            [self setNav:@"品牌相册"];
            
            NSMutableArray *viewArr = [NSMutableArray array];
            for (int i=0; i<[haveImageColumnTitle count]; i++) {
                
                // 初始化collectionView
                UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc] init];
                UICollectionView *myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-64)collectionViewLayout:flowLayout];
                myCollectionView.tag = 100+i;
                myCollectionView.delegate = self;
                myCollectionView.dataSource = self;
                myCollectionView.bounces = NO;
                myCollectionView.backgroundColor = [UIColor whiteColor];
                [myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"AllPhotoCell"];
                
                [viewArr addObject:myCollectionView];
            }
            
            TagsAndTables *baseView = [[TagsAndTables alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-64)
                                                                    titles:haveImageColumnTitle
                                                                     views:viewArr];
            [self.view addSubview:baseView];
        }
            break;
    }
}

//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSInteger colunmIndex = (NSInteger)collectionView.tag-100;
    return colunmIndex==0? [theAllUrl count]:[_allPhotoUrl[colunmIndex-1] count];
//    return 1;
}

//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * identifier = @"AllPhotoCell";
    
    UICollectionViewCell *cell;
    UIImageView *imageView;
    if (!cell) {
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        imageView = [[UIImageView alloc] init];
        imageView.frame = cell.frame;
        imageView.contentMode = UIViewContentModeScaleToFill;
    }
    
    
    
    NSInteger colunmIndex = (NSInteger)collectionView.tag-100;
//    NSLog(@"%d %@",collectionView.tag,_allPhotoUrl[colunmIndex]);
    
    // ‘全部’时取不同
    if (colunmIndex == 0) {
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:theAllUrl[indexPath.row]]
                     placeholderImage:[UIImage imageNamed:@"loading_l"]];
    }
    else {
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:_allPhotoUrl[colunmIndex-1][indexPath.row]]
                     placeholderImage:[UIImage imageNamed:@"loading_l"]];
    }
    
    cell.backgroundView = imageView;
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout 定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((viewWidth-38)/4,(viewWidth-38)/4*8/11);
}


#pragma mark - 定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(4, 4, 4, 4);
}

#pragma mark - UICollectionViewDelegate UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(_imageFrom==1)
    {
        NSInteger colunmIndex = (NSInteger)collectionView.tag-100;
        
        FullScreenViewController *fsVC = [[FullScreenViewController alloc] init];
        fsVC.imagesFrom = 1;
        fsVC.paramID = _paramID;
        // ‘全部’时取不同
        fsVC.theValue = colunmIndex == 0?
        [_allPhotoUrlWithColumn objectForKey:theAllUrl[indexPath.row]]:
        [_allPhotoUrlWithColumn objectForKey:_allPhotoUrl[colunmIndex-1][indexPath.row]];
        
        fsVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        UINavigationController *nav_houseLookingVC = [[UINavigationController alloc]initWithRootViewController:fsVC];
        
        [self presentViewController:nav_houseLookingVC animated:YES completion:nil];
    }
    else
    {
        NSInteger colunmIndex = (NSInteger)collectionView.tag-100;
        FullScreenViewController *fsVC = [[FullScreenViewController alloc] init];
        fsVC.imagesFrom = 0;
        fsVC.paramID = _paramID;
        
        fsVC.theValue = colunmIndex == 0?
        [_allPhotoUrlWithColumn objectForKey:theAllUrl[indexPath.row]]:
        [_allPhotoUrlWithColumn objectForKey:_allPhotoUrl[colunmIndex-1][indexPath.row]];
        
        fsVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        UINavigationController *nav_houseLookingVC = [[UINavigationController alloc]initWithRootViewController:fsVC];
        
        [self presentViewController:nav_houseLookingVC animated:YES completion:nil];

    }
    
}

#pragma mark - 返回这个UICollectionView是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

- (void)valueReturn:(ReturnImages)block{
    
    self.returnBlock = block;
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
