//
//  photoABViewController.m
//  SDD
//
//  Created by hua on 15/10/15.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "photoABViewController.h"
#import "NSString+SDD.h"
#import "VIPhotoView.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "ShareHelper.h"
#import <MediaPlayer/MediaPlayer.h>

@interface photoABViewController ()<UIScrollViewDelegate>{
    
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
}
// 网络请求
@property (nonatomic, strong) AFHTTPRequestOperationManager *httpManager;
// 有图片的栏目
@property (nonatomic, strong) NSMutableArray *haveImageColumn;
// 视频URL
@property (nonatomic, strong) NSArray *videoUrlList;

@property(assign, nonatomic)int numiii;

@property(nonatomic , retain)UILabel *laabbeel;

@end

@implementation photoABViewController

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"imagedic   ========          %@",[_imageDict[0] objectForKey:@"imageUrl"]);
    
    
    [self createNvn];
    
    [self setupUI];
    // Do any additional setup after loading the view.
}

-(void)createNvn
{
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"实景图";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
//    UIButton * rightBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightBtn.frame = CGRectMake(0, 0, 15, 15);
//    [rightBtn setBackgroundImage:[UIImage imageNamed:@"分享-图标"] forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(GRshareBtn) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem * rigItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    self.navigationItem.rightBarButtonItem = rigItem;
    
    self.view.backgroundColor = [UIColor blackColor];
}
#pragma mark - 分享
- (void)GRshareBtn{
    
    [ShareHelper shareIn:self content:@"Hello" url:@"http://www.shangdodo.com"];
}

-(void)setupUI
{
    imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    imageScrollView.backgroundColor = [UIColor blackColor];
    imageScrollView.delegate = self;
    imageScrollView.showsHorizontalScrollIndicator = NO;
    imageScrollView.showsVerticalScrollIndicator = NO;
    imageScrollView.pagingEnabled = YES;
    imageScrollView.bounces = NO;
    [self.view addSubview:imageScrollView];
//    UIImageView *imgView = [[UIImageView alloc] init];
//    imgView.frame = CGRectMake(0, -64, viewWidth, viewHeight);
//    imgView.backgroundColor = [UIColor orangeColor];
//    
//    [imgView sd_setImageWithURL:[NSURL URLWithString:_imageStr] placeholderImage:[UIImage imageNamed:@"loading_b"]];
//    [imageScrollView addSubview:imgView];
    
    [self connect];
    _laabbeel = [[UILabel alloc] init];
    _laabbeel.frame = CGRectMake(10, imageScrollView.frame.size.height-100, viewWidth/2, 16);
    //    label.tag = 300+i;
    _laabbeel.textColor = [UIColor whiteColor];
    _laabbeel.font = largeFont;
    
    
    [self.view addSubview:_laabbeel];
    NSLog(@"setupUI ");
}

#pragma mark - 对接数据
- (void)connect{
    
    NSLog(@"对接数据");
    // 得到有图片的相册
    NSArray *allColumnName = [imageColumnDict allKeys];
    
    [_haveImageColumn removeAllObjects];
    for (int i=0; i<[allColumnName count]; i++) {
        
        if ([imagesDict[allColumnName[i]] count]>0) {           // 该栏目有图片
            
            [self.haveImageColumn addObject:[allColumnName objectAtIndex:i]];
        }
    }
    
    for (int i=0; i<1; i++) {
        
        // 图片scrollview
        UIScrollView *in_ScrollView = [[UIScrollView alloc] init];
        in_ScrollView.frame = CGRectMake(viewWidth*i, 0, viewWidth, viewHeight);
        in_ScrollView.tag = 100+i;
        in_ScrollView.delegate = self;
        in_ScrollView.showsHorizontalScrollIndicator = NO;
        in_ScrollView.showsVerticalScrollIndicator = NO;
        in_ScrollView.pagingEnabled = YES;
        in_ScrollView.bounces = NO;
        
        _inScrollView = in_ScrollView;
        
//        int len = [imagesDict[_haveImageColumn[i]] count];
        for (int j=0; j< [_imageDict count]; j++) {
            
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.frame = CGRectMake(viewWidth*j, -64, viewWidth, viewHeight);
//            imgView.backgroundColor = [UIColor orangeColor];
//            NSString *tmpStr = [NSString stringWithCurrentString:imagesDict[_haveImageColumn[i]][j] SizeWidth:(int)viewWidth*2];
            
            
            
            [imgView sd_setImageWithURL:[NSURL URLWithString:[_imageDict[j] objectForKey:@"imageUrl"]] placeholderImage:[UIImage imageNamed:@"loading_b"]];
            
            if ([imageColumnDict[_haveImageColumn[i]] isEqualToString:@"视频"]) {
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake(0, 0, 80, 80);
                btn.center = CGPointMake(viewWidth/2, viewHeight/2);
                [btn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(videoClick) forControlEvents:UIControlEventTouchUpInside];
                [imgView addSubview:btn];
                imgView.userInteractionEnabled = YES;
                
                [in_ScrollView addSubview:imgView];
            }
            else {
                
                VIPhotoView *phoneView = [[VIPhotoView alloc] initWithFrame:imgView.frame andImageView:imgView];
                phoneView.autoresizingMask = (1 << 4) -1;
                [in_ScrollView addSubview:phoneView];
            }
            
            in_ScrollView.contentSize = CGSizeMake(viewWidth*(j+1), viewHeight-94);
            
//            if (len == 1) {
//                
//                in_ScrollView.contentSize = CGSizeMake(viewWidth*(j+1)+1, viewHeight-94);
//            }
        }
        
        [imageScrollView addSubview:in_ScrollView];
        
//        UILabel *label = [[UILabel alloc] init];
//        label.frame = CGRectMake(10+viewWidth*i, imageScrollView.frame.size.height-100, viewWidth/2, 16);
//        label.tag = 300+i;
//        label.textColor = [UIColor whiteColor];
//        label.font = largeFont;
//        label.text = [NSString stringWithFormat:@"%d/%lu",_numiii,(unsigned long)[_imageDict count]];
//        
//        [imageScrollView addSubview:label];
        
        
        
        imageScrollView.contentSize = CGSizeMake(viewWidth*(i+1), viewHeight-94);
        
        
        titleScrollView.contentSize = CGSizeMake(viewWidth/4*(i+1), 30);
    }
    

    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //通过当前位置，设置当前的页码
    _numiii = scrollView.contentOffset.x/320;
    _laabbeel.text = [NSString stringWithFormat:@"%d/%lu",_numiii+1,(unsigned long)[_imageDict count]];
}

#pragma mark - videoClick
- (void)videoClick{
    
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

// 支持设备自动旋转
- (BOOL)shouldAutorotate{
    
    return YES;
}

// 支持横竖屏显示
- (NSUInteger)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskAll;
}

- (void)leftButtonClick:(UIButton *)btn
{
//    NSLog(@"left");
//    NSLog(@"%@",self.navigationController.viewControllers);
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
