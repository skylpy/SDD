//
//  NewFeatureViewController.m
//  SDD
//
//  Created by mac on 15/5/12.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "NewFeatureViewController.h"
#import "AppDelegate.h"

#define kCount 4

@interface NewFeatureViewController ()<UIScrollViewDelegate>
{
    UIPageControl *_page;
    UIScrollView *_scroll;
}
@end

@implementation NewFeatureViewController

- (void)addScrollView
{
    UIScrollView *scroll = [[UIScrollView alloc]init];
    scroll.frame = self.view.bounds;
    scroll.showsHorizontalScrollIndicator = NO;
    CGSize size = scroll.frame.size;
    scroll.contentSize = CGSizeMake(size.width * kCount, 0);
    scroll.pagingEnabled = YES; // 分页
    scroll.delegate = self;
    [self.view addSubview:scroll];
    _scroll = scroll;
}


- (void)addScrollImage
{
    CGSize size = _scroll.frame.size;
    CGFloat startW = viewWidth*5/8;
    
    for (int i=0; i<kCount; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        NSString *name = [NSString stringWithFormat:@"guide page_image_%d.png",i + 2];
        imageView.image = [UIImage imageNamed:name];
        
        imageView.center = CGPointMake(i * (self.view.frame.size.width/2), (self.view.frame.size.height/2));
        imageView.frame = CGRectMake(i * size.width, 0, size.width, size.height);
        [_scroll addSubview:imageView];
        
        if (i == kCount - 1) {
            
            UIButton *start = [UIButton buttonWithType:UIButtonTypeCustom];
            start.frame = CGRectMake((size.width * 0.5) - (startW * 0.5) , size.height * 0.75, startW, 40);
            [start setTitle:@"马上体验" forState:UIControlStateNormal];
            [start setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [start setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [Tools_F setViewlayer:start cornerRadius:10 borderWidth:1 borderColor:[UIColor whiteColor]];
            [start addTarget:self action:@selector(startBtn) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:start];
            imageView.userInteractionEnabled = YES;
        }
    }
}

- (void)startBtn{
    
    [AppDelegateShare toMainView];
}

#pragma mark 添加分页指示器
- (void)addPageControl{
    
    CGSize size = self.view.frame.size;
    UIPageControl *page = [[UIPageControl alloc] init];
    page.center = CGPointMake(size.width * 0.5, size.height * 0.95);
    page.numberOfPages = kCount;
    
    page.pageIndicatorTintColor = [SDDColor sddbackgroundColor];
    page.currentPageIndicatorTintColor = tagsColor;
    //    page.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"new_feature_pagecontrol_checked_point.png"]];
    //    page.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"new_feature_pagecontrol_point.png"]];
    page.bounds = CGRectMake(0, 0, 150, 0);
    [self.view addSubview:page];
    _page = page;
}

#pragma mark - 滚动代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    _page.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
}


- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self addScrollView];
    
    [self addScrollImage];
    
    [self addPageControl];
}

@end
