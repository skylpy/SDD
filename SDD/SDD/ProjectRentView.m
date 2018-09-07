//
//  ProjectRentView.m
//  SDD
//
//  Created by mac on 15/12/22.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ProjectRentView.h"
#define TOPHEIGHT 40
@interface ProjectRentView()<UIScrollViewDelegate>
{
    UIView * Btnview;
    
#pragma mark -- 记录滚动值
    NSInteger btncountTag;
    NSInteger countTag;
}
///@brife 整个视图的大小
@property (assign) CGRect mViewFrame;

///@brife 下方的ScrollView
@property (strong, nonatomic) UIScrollView *scrollView;

///@brife 上方的按钮数组
@property (strong, nonatomic) NSMutableArray *topViews;

///@brife 下方的表格数组
@property (strong, nonatomic) NSMutableArray *scrollTableViews;



///@brife 当前选中页数
@property (assign) NSInteger currentPage;

///@brife 下面滑动的View
@property (strong, nonatomic) UIView *slideView;

///@brife 上方的ScrollView
@property (strong, nonatomic) UIScrollView *topScrollView;

///@brife 上方的view
@property (strong, nonatomic) UIView *topMainView;

@end

@implementation ProjectRentView

@synthesize ProceedTableView,CompleteTableView,FailureTableView;

-(instancetype)initWithFrame:(CGRect)frame WithCount: (NSInteger) count{
    self = [super initWithFrame:frame];
    
    if (self) {
        _mViewFrame = frame;
        _tabCount = count;
        _topViews = [[NSMutableArray alloc] init];
        _scrollTableViews = [[NSMutableArray alloc] init];
        
        btncountTag = 0;
        countTag = 0;
        
        [self initScrollView];
        
        [self initTopTabs];
        
        [self initDownTables];
        
        
        [self initSlideView];
        
    }
    
    return self;
}


#pragma mark -- 初始化滑动的指示View

-(void) initSlideView{
    
    CGFloat width = _mViewFrame.size.width / 3;
    
    if(self.tabCount <=3){
        width = _mViewFrame.size.width / self.tabCount;
    }
    
    _slideView = [[UIView alloc] initWithFrame:CGRectMake(0, TOPHEIGHT - 3, width, 3)];
    [_slideView setBackgroundColor:dblueColor];//[SDDColor colorWithHexString:@"#0099CC"]
    [_topScrollView addSubview:_slideView];
}

#pragma mark -- 滚动红条



#pragma mark -- 实例化ScrollView
-(void) initScrollView{
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _mViewFrame.origin.y+TOPHEIGHT, _mViewFrame.size.width, _mViewFrame.size.height )];
    _scrollView.contentSize = CGSizeMake(_mViewFrame.size.width * _tabCount, _mViewFrame.size.height - 60);
    _scrollView.backgroundColor = [UIColor whiteColor];
    
    _scrollView.pagingEnabled = YES;
    _scrollView.directionalLockEnabled=YES;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
}



#pragma mark -- 实例化顶部的tab
-(void) initTopTabs{
    CGFloat width = _mViewFrame.size.width / 3;
    
    if(self.tabCount <=3){
        width = _mViewFrame.size.width / self.tabCount;
    }
    
    _topMainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _mViewFrame.size.width, TOPHEIGHT)];
    
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _mViewFrame.size.width, TOPHEIGHT)];
    
    _topScrollView.showsHorizontalScrollIndicator = NO;
    
    _topScrollView.showsVerticalScrollIndicator = YES;
    
    _topScrollView.bounces = NO;
    
    _topScrollView.delegate = self;
    
    if (_tabCount >= 2) {
        _topScrollView.contentSize = CGSizeMake(width * _tabCount, TOPHEIGHT);
        
    } else {
        _topScrollView.contentSize = CGSizeMake(_mViewFrame.size.width, TOPHEIGHT);
    }
    
    
    [self addSubview:_topMainView];
    
    [_topMainView addSubview:_topScrollView];
    
    
    NSArray * array = @[@"进行中",@"已完成",@"已失效"];
    for (int i = 0; i < array.count; i ++) {
        
        Btnview = [[UIView alloc] initWithFrame:CGRectMake(i * width, 0, width, TOPHEIGHT)];
        Btnview.tag = 100+i;
        Btnview.backgroundColor = [UIColor whiteColor];
        
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width-0.5, TOPHEIGHT)];
        button.tag = i+10;
        button.titleLabel.font = titleFont_15;
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:dblueColor forState:UIControlStateSelected];
        button.backgroundColor = [UIColor whiteColor];
        //[button setTitle:[NSString stringWithFormat:@"按钮%d", i+1] forState:UIControlStateNormal];
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tabButton:) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [Btnview addSubview:button];
        
        
        if (i == 0) {
            button.selected = YES;
            UILabel * lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(width-0.5, 5, 0.5, TOPHEIGHT-10)];
            lineLabel.backgroundColor = [UIColor lightGrayColor];
            [Btnview addSubview:lineLabel];
        }
        if (i == 1) {
            
            UILabel * lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(width-0.5, 5, 0.5, TOPHEIGHT-10)];
            lineLabel.backgroundColor = [UIColor lightGrayColor];
            [Btnview addSubview:lineLabel];
        }
        [_topViews addObject:Btnview];
        [_topScrollView addSubview:Btnview];
    }
}



#pragma mark --点击顶部的按钮所触发的方法
-(void) tabButton: (id) sender{
    UIButton *button = sender;
    
    [_scrollView setContentOffset:CGPointMake((button.tag-10) * _mViewFrame.size.width, 0) animated:YES];
    
    for (int i = 0;  i < 3; i ++) {
        UIView * view1 = (UIView *)[_topScrollView viewWithTag:100+i];
        UIButton * bbutton = (UIButton *)[view1 viewWithTag:10+i];
        bbutton.selected = NO;
        
    }
    
    button.selected = YES;
    
}

#pragma mark --初始化下方的TableViews
-(void) initDownTables{
    
    ProceedTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _mViewFrame.size.width, _mViewFrame.size.height - TOPHEIGHT*2)style:UITableViewStyleGrouped];
    ProceedTableView.tag = 100;
    ProceedTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [_scrollTableViews addObject:ProceedTableView];
    [_scrollView addSubview:ProceedTableView];
    
    
    
    CompleteTableView = [[UITableView alloc] initWithFrame:CGRectMake(1*_mViewFrame.size.width, 0, _mViewFrame.size.width, _mViewFrame.size.height - TOPHEIGHT*2)style:UITableViewStyleGrouped];
    CompleteTableView.tag = 101;
    CompleteTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [_scrollTableViews addObject:CompleteTableView];
    [_scrollView addSubview:CompleteTableView];
    
    FailureTableView = [[UITableView alloc] initWithFrame:CGRectMake(2*_mViewFrame.size.width, 0, _mViewFrame.size.width, _mViewFrame.size.height - TOPHEIGHT*2)style:UITableViewStyleGrouped];
    FailureTableView.tag = 102;
    FailureTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [_scrollTableViews addObject:FailureTableView];
    [_scrollView addSubview:FailureTableView];
    
}


#pragma mark --根据scrollView的滚动位置复用tableView，减少内存开支
-(void) updateTableWithPageNumber: (NSUInteger) pageNumber{
    int tabviewTag = pageNumber % 3;
    
    CGRect tableNewFrame = CGRectMake(pageNumber * _mViewFrame.size.width, 0, _mViewFrame.size.width, _mViewFrame.size.height - TOPHEIGHT);
    
    UITableView *reuseTableView = _scrollTableViews[tabviewTag];
    reuseTableView.frame = tableNewFrame;
    [reuseTableView reloadData];
}




#pragma mark -- scrollView的代理方法

-(void) modifyTopScrollViewPositiong: (UIScrollView *) scrollView{
    if ([_topScrollView isEqual:scrollView]) {
        CGFloat contentOffsetX = _topScrollView.contentOffset.x;
        
        CGFloat width = _slideView.frame.size.width;
        
        int count = (int)contentOffsetX/(int)width;
        
        CGFloat step = (int)contentOffsetX%(int)width;
        
        CGFloat sumStep = width * count;
        
        if (step > width/3) {
            
            sumStep = width * (count + 1);
            
        }
        
        [_topScrollView setContentOffset:CGPointMake(sumStep, 0) animated:YES];
        return;
    }
    
}

///拖拽后调用的方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //[self modifyTopScrollViewPositiong:scrollView];
}



-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidEndDecelerating:scrollView];
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView

{
    if ([scrollView isEqual:_scrollView]) {
        _currentPage = _scrollView.contentOffset.x/_mViewFrame.size.width;
        
        _currentPage = _scrollView.contentOffset.x/_mViewFrame.size.width;
        
        
        [self updateTableWithPageNumber:_currentPage];
        
#pragma mark -- 滚动获取按钮变色
        CGPoint point = scrollView.contentOffset; //记录滑动
        //NSLog(@"%f %f",point.x,point.y);
        countTag = point.x/viewWidth+100;         // 计算按钮tag值
        btncountTag = point.x/viewWidth+10;         // 计算按钮tag值
        UIView * Btnview1 = (UIView *) [_topScrollView viewWithTag:countTag];
        UIButton * clickBtn =(UIButton *) [Btnview1 viewWithTag:btncountTag];
        [self titleClick:clickBtn];
        
        return;
    }
    [self modifyTopScrollViewPositiong:scrollView];
    
}


#pragma mark - 标题点击   滚动获取按钮变色显示
- (void)titleClick:(UIButton *)btn{
    
    // 全部反选
    for (NSInteger i=0; i<3; i++) {
        UIView * Btnview1 = (UIView *) [_topScrollView viewWithTag:i+100];
        UIButton * traverseBtn =(UIButton *) [Btnview1 viewWithTag:i+10];
        traverseBtn.selected = NO;
    }
    // 选中当前
    btn.selected = YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([_scrollView isEqual:scrollView]) {
        CGRect frame = _slideView.frame;
        
        if (self.tabCount <= 3) {
            frame.origin.x = scrollView.contentOffset.x/_tabCount;
        } else {
            frame.origin.x = scrollView.contentOffset.x/3;
            
        }
        
        _slideView.frame = frame;
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
