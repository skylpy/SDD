//
//  FullScreenViewController.m
//  SDD
//
//  Created by hua on 15/4/23.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "FullScreenViewController.h"

#import "AllPhotoViewController.h"

#import "VIPhotoView.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "ShareHelper.h"
#import <MediaPlayer/MediaPlayer.h>
#import "NSString+SDD.h"
#import "PlayerViewController.h"

@interface FullScreenViewController ()<UIScrollViewDelegate>{
    
    /*- ui -*/
    // 图片
    UIScrollView *imageScrollView;
    // 标题
    UIScrollView *titleScrollView;
    
    /*- data -*/
    NSDictionary *imageColumnDict;
    NSDictionary *imagesDict;
    CGFloat lastScale;
    
    UIScrollView *_inScrollView;
    
    NSInteger index;//选择视频播放
}

// 网络请求
@property (nonatomic, strong) AFHTTPRequestOperationManager *httpManager;
// 有图片的栏目
@property (nonatomic, strong) NSMutableArray *haveImageColumn;
// 视频URL
@property (nonatomic, strong) NSArray *videoUrlList;

@end

@implementation FullScreenViewController

- (AFHTTPRequestOperationManager *)httpManager
{
    if(!_httpManager)
    {
        _httpManager = [AFHTTPRequestOperationManager manager];
        //        httpManager.requestSerializer.timeoutInterval = 15;         //设置超时时间
        _httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];        // ContentTypes 为json
    }
    return _httpManager;
}

- (NSMutableArray *)haveImageColumn{
    if (!_haveImageColumn) {
        _haveImageColumn = [[NSMutableArray alloc]init];
    }
    return _haveImageColumn;
}

#pragma mark - 请求数据
- (void)requestData{
    
    NSDictionary *dic;              // 参数
    NSString *urlString;            // url
    
    // 请求参数
    switch (_imagesFrom) {
        case 0:
        {
            dic = @{@"houseId":_paramID};
            urlString = [SDD_MainURL stringByAppendingString:@"/house/images.do"];              // 拼接主路径和请求内容成完整url

        }
            break;
        case 1:
        {
            dic = @{@"brandId":_paramID};
            urlString = [SDD_MainURL stringByAppendingString:@"/brand/images.do"];              // 拼接主路径和请求内容成完整url
        }
            break;
            
        default:
            break;
    }
    
    [self.httpManager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = responseObject;
        NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
        if (![dict[@"data"] isEqual:[NSNull null]]) {
            
            imagesDict = dict[@"data"];
         
            self.videoUrlList = dict[@"data"][@"videoUrls"];            
            
            [self connect];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"错误 -- %@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor blackColor];
    
    if (iOS_version>=7.0) {
        if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    index = 0;
    // 请求数据
    [self requestData];
    // 设置图片栏目字典
    [self imageColumn];
    // 导航条
    [self setupNav];
    // 设置内容
    [self setupUI];
}

#pragma mark - 设置
- (void)imageColumn {
    
    imageColumnDict = @{
                        @"videoDefaultImages": @"视频",
                        @"panorama360Urls": @"360全景图",
                        @"trafficMapUrls": @"商圈图",
                        @"formatFigureUrls": @"业态图",
                        @"floorPlanUrls": @"平面图",
//                        @"modelMapUrls": @"户型图",
                        @"realMapUrls": @"实景图",
                        @"renderingUrls": @"效果图",
                        @"openHousesUrls": @"样板房",
                        @"projectSiteUrls": @"项目现场",
                        @"promotionalMaterialsUrls": @"推广物料",
                        @"supportingMapUrls": @"配套图集",
                        @"activityDiagramUrls": @"活动相册",
                        @"brandVIUrls": @"品牌VI",
                        @"terminalUrls": @"实体图展示",
                        @"productUrls": @"产品展示",
                        @"exhibitionUrls": @"展览会",
                        };
}

#pragma mark - 设置导航条
- (void)setupNav{
    
    [self.navigationController.navigationBar setBackgroundImage:[Tools_F imageWithColor:[UIColor blackColor] size:CGSizeMake(viewWidth, 64)] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];

    SDDButton *button = [[SDDButton alloc]init];
    button.frame = CGRectMake(0, 0, 30, 44);
    [button setTitle:@"" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    // 导航条右
//    UIButton * titleLabel = [[UIButton alloc] init];
//    titleLabel.frame = CGRectMake(0, 0, 30, 20);
//    titleLabel.titleLabel.font = [UIFont systemFontOfSize:18];
//    [titleLabel addTarget:self action:@selector(allImage:) forControlEvents:UIControlEventTouchUpInside];
//    [titleLabel setTitle:@"全部图片" forState:UIControlStateNormal];
//    [titleLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    self.navigationItem.titleView = titleLabel;
    
    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
    share.frame = CGRectMake(0, 0, 19, 20);
    [share setBackgroundImage:[UIImage imageNamed:@"分享-图标"] forState:UIControlStateNormal];
    [share addTarget:self action:@selector(FSshareBtn) forControlEvents:UIControlEventTouchUpInside];
    
//    UIBarButtonItem *barTitle = [[UIBarButtonItem alloc]initWithCustomView:titleLabel];
    UIBarButtonItem *barShare = [[UIBarButtonItem alloc]initWithCustomView:share];
    self.navigationItem.rightBarButtonItems = @[barShare,
//                                                barTitle
                                                ];
}

- (void)FSshareBtn{
    
    [ShareHelper shareIn:self content:@"Hello" url:@"http://www.shangdodo.com"];
}

#pragma mark - 设置内容
- (void)setupUI {
    
    imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-94)];
    imageScrollView.backgroundColor = [UIColor blackColor];
    imageScrollView.delegate = self;
    imageScrollView.showsHorizontalScrollIndicator = NO;
    imageScrollView.showsVerticalScrollIndicator = NO;
    imageScrollView.pagingEnabled = YES;
    imageScrollView.bounces = NO;
    [self.view addSubview:imageScrollView];
    
    titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageScrollView.frame), viewWidth, 30)];
    titleScrollView.backgroundColor = setColor(20, 20, 20, 1);
    titleScrollView.delegate = self;
    titleScrollView.showsHorizontalScrollIndicator = NO;
    titleScrollView.showsVerticalScrollIndicator = NO;
    titleScrollView.bounces = NO;
    [self.view addSubview:titleScrollView];
}

#pragma mark - 对接数据
- (void)connect{
    
    // 得到有图片的相册
    NSArray *allColumnName = [imageColumnDict allKeys];
    
    [_haveImageColumn removeAllObjects];
    for (int i=0; i<[allColumnName count]; i++) {
        
        if ([imagesDict[allColumnName[i]] count]>0) {           // 该栏目有图片

            [self.haveImageColumn addObject:[allColumnName objectAtIndex:i]];
        }
    }
    
    for (int i=0; i<[_haveImageColumn count]; i++) {
        
        // 图片scrollview
        UIScrollView *in_ScrollView = [[UIScrollView alloc] init];
        in_ScrollView.frame = CGRectMake(viewWidth*i, 0, viewWidth, viewHeight-94);
        in_ScrollView.tag = 100+i;
        in_ScrollView.delegate = self;
        in_ScrollView.showsHorizontalScrollIndicator = NO;
        in_ScrollView.showsVerticalScrollIndicator = NO;
        in_ScrollView.pagingEnabled = YES;
        in_ScrollView.bounces = NO;
        
        _inScrollView = in_ScrollView;
        
        int len = [imagesDict[_haveImageColumn[i]] count];
        for (int j=0; j< len; j++) {
            
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.frame = CGRectMake(viewWidth*j, -64, viewWidth, viewHeight);
            NSString *tmpStr = [NSString stringWithCurrentString:imagesDict[_haveImageColumn[i]][j] SizeWidth:(int)viewWidth*2];
          
            //占位图片
            NSString *imageName = @"loading_b";
            [imgView setImage:[UIImage imageNamed:imageName]];
            
            if ([imageColumnDict[_haveImageColumn[i]] isEqualToString:@"视频"]) {
                [imgView sd_setImageWithURL:[NSURL URLWithString:tmpStr] placeholderImage:[UIImage imageNamed:imageName]];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(0, 0, 80, 80);
                btn.center = CGPointMake(viewWidth/2, viewHeight/2);
                [btn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(videoClick:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag = 100+j;
                [imgView addSubview:btn];
                imgView.userInteractionEnabled = YES;
                
                [in_ScrollView addSubview:imgView];
            }
            else {
                
                VIPhotoView *phoneView = [[VIPhotoView alloc] initWithFrame:imgView.frame andImageView:imgView];
                phoneView.autoresizingMask = (1 << 4) -1;
                [in_ScrollView addSubview:phoneView];
                
                __weak VIPhotoView *weakVIPhotoView = phoneView;
                [imgView sd_setImageWithURL:[NSURL URLWithString:tmpStr] placeholderImage:[UIImage imageNamed:imageName] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    [weakVIPhotoView updateImageSize:image.size];
                }];
            }
            
            in_ScrollView.contentSize = CGSizeMake(viewWidth*(j+1), viewHeight-94);
            
            if (len == 1) {
                
                in_ScrollView.contentSize = CGSizeMake(viewWidth*(j+1)+1, viewHeight-94);
            }
        }

        [imageScrollView addSubview:in_ScrollView];
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(10+viewWidth*i, imageScrollView.frame.size.height-100, viewWidth/2, 16);
        label.tag = 300+i;
        label.textColor = [UIColor whiteColor];
        label.font = largeFont;
        label.text = [NSString stringWithFormat:@"%@ 1/%d",imageColumnDict[_haveImageColumn[i]],(int)[imagesDict[_haveImageColumn[i]] count]];
        
        [imageScrollView addSubview:label];
        
        imageScrollView.contentSize = CGSizeMake(viewWidth*(i+1), viewHeight-94);
        
        // 标题scrollView
        UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        titleBtn.frame = CGRectMake(viewWidth/4*i, 0, viewWidth/4, 30);
        titleBtn.tag = 500+i;
        titleBtn.titleLabel.font = midFont;
        [titleBtn setTitle:imageColumnDict[_haveImageColumn[i]] forState:UIControlStateNormal];
        [titleBtn setTitleColor:lgrayColor forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [titleBtn addTarget:self action:@selector(columnClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleScrollView addSubview:titleBtn];
        // 默认选中第一个
        if (i==0) {
            titleBtn.selected = YES;
        }
        
        titleScrollView.contentSize = CGSizeMake(viewWidth/4*(i+1), 30);
    }
    
    /*-                跳到某栏目                -*/
    
    if (_jumpColumn) {
        
        for (UIButton *everyBtn in titleScrollView.subviews) {      // 遍历所有栏目btn
            
            if ([everyBtn.titleLabel.text isEqualToString:_jumpColumn]) {
                
                [self columnClick:everyBtn];
                break;
            }
        }
    }
    
    if (_theValue) {
        
        UIButton *btn = (UIButton *)[titleScrollView viewWithTag:[_theValue[0] intValue]+500];
        [self columnClick:btn];
        UIScrollView *currentIn = (UIScrollView *)[imageScrollView viewWithTag:100+[_theValue[0] intValue]];
        [currentIn setContentOffset:CGPointMake(viewWidth*[_theValue[1] intValue], 0) animated:NO];
    }
}

#pragma mark - scrollView(关联上方栏目标题移动)qi
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    if (scrollView == imageScrollView) {
        CGPoint point = scrollView.contentOffset;
        int currentPage = point.x/viewWidth;
        
        // 获取栏目button
        UIButton *button = (UIButton *)[titleScrollView viewWithTag:currentPage+500];
        [self columnClick:button];
    }
    
    if (scrollView != imageScrollView && scrollView != titleScrollView) {
        
        CGPoint point = scrollView.contentOffset;
        int currentPage = point.x/viewWidth;
        int i = (int)scrollView.tag-100;
        // 获取页码label
        UILabel *label = (UILabel *)[imageScrollView viewWithTag:i+300];
        label.text = [NSString stringWithFormat:@"%@ %d/%d",imageColumnDict[_haveImageColumn[i]],currentPage+1,(int)[imagesDict[_haveImageColumn[i]] count]];
    }
}

#pragma mark - 栏目点击
- (void)columnClick:(UIButton *)btn{
    
    for (UIButton *everyBtn in titleScrollView.subviews) {      // 遍历所有栏目btn
        // 所有栏目设为未选中状态
        everyBtn.selected = NO;
    }
    // 点击的btn设为选中状态
    btn.selected = YES;
    
    int i = (int)btn.tag -500;
    //
    if (i==0) {
        
        [titleScrollView setContentOffset:CGPointMake(i*viewWidth/4, 0) animated:NO];          // 标题随着移动。
    }
    else if (i==(int)[_haveImageColumn count]-2){
        
        [titleScrollView setContentOffset:CGPointMake((i-2)*viewWidth/4, 0) animated:NO];      // 标题随着移动。
    }
    else if (i==(int)[_haveImageColumn count]-1){
        
        [titleScrollView setContentOffset:CGPointMake((i-3)*viewWidth/4, 0) animated:NO];      // 标题随着移动。
    }
    else {
        
        [titleScrollView setContentOffset:CGPointMake((i-1)*viewWidth/4, 0) animated:NO];      // 标题随着移动。
    }
    
    [imageScrollView setContentOffset:CGPointMake(i*viewWidth, 0) animated:NO];                // 图片随着移动。
}

#pragma mark - 全部图片
- (void)allImage:(UIButton *)btn{
    
    AllPhotoViewController *allPhoto = [[AllPhotoViewController alloc] init];
    allPhoto.imageDict = imagesDict;
    allPhoto.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    // block
    [allPhoto valueReturn:^(NSArray *theValue) {
       
        UIButton *btn = (UIButton *)[titleScrollView viewWithTag:[theValue[0] intValue]+500];
        [self columnClick:btn];
        UIScrollView *currentIn = (UIScrollView *)[imageScrollView viewWithTag:100+[theValue[0] intValue]];
        [currentIn setContentOffset:CGPointMake(viewWidth*[theValue[1] intValue], 0) animated:YES];
    }];
    
    UINavigationController *nav_houseLookingVC = [[UINavigationController alloc]initWithRootViewController:allPhoto];
    [self presentViewController:nav_houseLookingVC animated:YES completion:nil];
}

#pragma mark - videoClick
- (void)videoClick:(UIButton *)btn{
    
    NSLog(@"%ld",btn.tag);
//    PlayerViewController * play = [[PlayerViewController alloc] init];
//    play.urlString = self.videoUrlList[btn.tag - 100];
//    [self.navigationController pushViewController:play animated:YES];
    
    for (int i = 0; i < [self.videoUrlList count]; i++) {
        
        NSString *string = self.videoUrlList[i];
        MPMoviePlayerViewController *playView = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:string]];
        // 横屏
        playView.view.frame = CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width);
        playView.view.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/2);
        [playView.view setTransform:transform];
        
        [self presentMoviePlayerViewControllerAnimated:playView];
        
    }
}
- (void) movieFinishedCallback:(NSNotification*) aNotification {
    MPMoviePlayerController *player = [aNotification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    [player stop];
//    [self.view removeFromSuperView];
    
}
// 支持设备自动旋转
- (BOOL)shouldAutorotate{
    
    return YES;
}

// 支持横竖屏显示
- (NSUInteger)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskAll;
}

#pragma mark - leftaction
- (void)leftAction:(UIButton *)btn{
    
    NSLog(@"返回");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated. [super didReceiveMemoryWarning];//即使没有显示在window上，也不会自动的将self.view释放。
    // Add code to clean up any of your own resources that are no longer necessary.
    
    // 此处做兼容处理需要加上ios6.0的宏开关，保证是在6.0下使用的,6.0以前屏蔽以下代码，否则会在下面使用self.view时自动加载viewDidLoad
    if (iOS_version>6.0 && [self.view window] == nil)// 是否是正在使用的视图
    {
        // Add code to preserve data stored in the views that might be
        // needed later.
        
        // Add code to clean up other strong references to the view in
        // the view hierarchy.
//        self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
    }
}

@end
