//
//  ShopPhotoViewController.m
//  SDD
//
//  Created by mac on 15/12/30.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ShopPhotoViewController.h"
#import "UIImageView+EMWebCache.h"
#import "VIPhotoView.h"

@interface ShopPhotoViewController ()<UIScrollViewDelegate>
{

    // 图片
    UIScrollView *imageScrollView;
}
@end

@implementation ShopPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    [self setupUI];
}
#pragma mark - 设置内容
- (void)setupUI {
    
    [self setNav:@""];
    
    imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-64)];
    imageScrollView.backgroundColor = [UIColor blackColor];
    imageScrollView.delegate = self;
    imageScrollView.showsHorizontalScrollIndicator = NO;
    imageScrollView.showsVerticalScrollIndicator = NO;
    imageScrollView.pagingEnabled = YES;
    imageScrollView.bounces = NO;
    [self.view addSubview:imageScrollView];
    
    
    for (int i = 0; i < _imageArr.count; i ++) {
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.frame = CGRectMake(viewWidth*i, -64, viewWidth, viewHeight);
//        NSString *tmpStr = [NSString stringWithCurrentString:[NSString stringWithFormat:@"%@",_imageArr[i]] SizeWidth:(int)viewWidth*2];
        
        [imgView sd_setImageWithURL:[NSURL URLWithString:_imageArr[i]] placeholderImage:[UIImage imageNamed:@"loading_b"]];
        
        VIPhotoView *phoneView = [[VIPhotoView alloc] initWithFrame:imgView.frame andImageView:imgView];
        phoneView.autoresizingMask = (1 << 4) -1;
        [imageScrollView addSubview:phoneView];
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(10+viewWidth*i, imageScrollView.frame.size.height-80, viewWidth/2, 16);
        label.tag = 300+i;
        label.textColor = [UIColor whiteColor];
        label.font = largeFont;
        label.text = [NSString stringWithFormat:@" %d/%ld",i+1,[_imageArr count]];
        
        [imageScrollView addSubview:label];
    }
    imageScrollView.contentSize = CGSizeMake(viewWidth*(_imageArr.count), viewHeight-64);
    
}
//#pragma mark - scrollView(关联上方栏目标题移动)qi
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//
//    CGPoint point = scrollView.contentOffset;
//    int currentPage = point.x/viewWidth;
//    int i = (int)scrollView.tag-100;
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
