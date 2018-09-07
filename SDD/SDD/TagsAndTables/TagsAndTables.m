//
//  TagsAndTables.m
//  SDD
//
//  Created by hua on 15/8/13.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "TagsAndTables.h"

@interface TagsAndTables()<UIScrollViewDelegate>{
    
    /*- ui -*/
    
    UIScrollView *titleScrollView;           // 标题底部ScrollView
    UIScrollView *viewScrollView;            // table底部ScrollView
    UIView *contentView_title;               // 标题底部
    UIView *contentView_view;                // table底部
    
    UIView *underLine;
    
    /*- data -*/
    
    NSInteger pages;
    NSArray *titleArr;
    NSArray *viewArr;
    float titleWidth;
}

@end

@implementation TagsAndTables

- (id)initWithFrame:(CGRect)frame titles:(NSArray *)titles views:(NSArray *)views{
    
    self = [super initWithFrame:frame];
    
    if (!self) {
        return nil;
    }
    else {
        
        self.backgroundColor = bgColor;
        
        /*-                    标题底部ScrollView初始化                    -*/
        titleScrollView = [[UIScrollView alloc] init];
        titleScrollView.backgroundColor = [UIColor whiteColor];
        titleScrollView.delegate = self;
        titleScrollView.showsHorizontalScrollIndicator = NO;
        titleScrollView.showsVerticalScrollIndicator = NO;
        titleScrollView.alwaysBounceHorizontal = YES;
        titleScrollView.alwaysBounceVertical = NO;
        titleScrollView.bounces = NO;
        
        [self addSubview:titleScrollView];
        [titleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(viewWidth, 40));
        }];
        
        // 底部view， 用于计算scrollview高度
        contentView_title = [[UIView alloc] init];
        [titleScrollView addSubview:contentView_title];
        
        [contentView_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(titleScrollView);
            make.height.equalTo(titleScrollView.mas_height);
        }];
        
        /*-                    table底部ScrollView初始化                    -*/
        viewScrollView = [[UIScrollView alloc] init];
        viewScrollView.backgroundColor = [UIColor whiteColor];
        viewScrollView.delegate = self;
        viewScrollView.showsHorizontalScrollIndicator = NO;
        viewScrollView.showsVerticalScrollIndicator = NO;
        viewScrollView.bounces = NO;
        viewScrollView.pagingEnabled = YES;            // 整页滑动
        
        [self addSubview:viewScrollView];
        [viewScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleScrollView.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.width.mas_equalTo(viewWidth);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        // 底部view， 用于计算scrollview高度
        contentView_view = [[UIView alloc] init];
        [viewScrollView addSubview:contentView_view];
        
        [contentView_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(viewScrollView);
            make.height.equalTo(viewScrollView.mas_height);
        }];
        
        pages = [titles count];
        switch (pages) {
            case 2: titleWidth = viewWidth/2;
                break;
            case 3: titleWidth = viewWidth/3;
                break;
            default: titleWidth = viewWidth/4;
                break;
        }
        
        viewArr = views;
        titleArr = titles;
        [self setupUI];
        
        return self;
    }
}

#pragma mark - 设置ui
- (void)setupUI{
    
    UIView *lastTitle;
    UIView *lastView;
    
    for (int i=0; i<pages; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 100 +i;
        btn.titleLabel.font = titleFont_15;
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle: [titleArr objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:deepBLack forState:UIControlStateNormal];
        [btn setTitleColor:dblueColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(indexSelected:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {               // 默认选中‘全部’
            btn.selected = YES;
        }
        [contentView_title addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastTitle?lastTitle.mas_right:contentView_title.mas_left);
            make.size.mas_equalTo(CGSizeMake(titleWidth, 40));
            //make.centerY.equalTo(contentView_title);
        }];
        
        // 分割线
        if (lastTitle) {
            
            UIView *cutoff = [[UIView alloc] init];
            cutoff.backgroundColor = ldivisionColor;
            [contentView_title addSubview:cutoff];
            
            [cutoff mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@4);
                make.left.equalTo(lastTitle.mas_right);
                make.width.equalTo(@1);
                make.height.equalTo(@32);
            }];
        }
        lastTitle = btn;
        
        // table
        UIView *theview = viewArr[i];
        [contentView_view addSubview:theview];
        
        [theview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentView_view.mas_top);
            make.left.equalTo(lastView?lastView.mas_right:contentView_view.mas_left);
            make.width.mas_equalTo(viewWidth);
            make.bottom.equalTo(contentView_view.mas_bottom);
        }];
        
        lastView = theview = viewArr[i];
    }
    
    underLine = [[UIView alloc] init];
    underLine.backgroundColor = dblueColor;
    [titleScrollView addSubview:underLine];
    [underLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleScrollView.mas_left);
        make.bottom.equalTo(titleScrollView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(titleWidth, 2));
    }];
    
    // 自动scrollview宽度
    [contentView_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastTitle.mas_right);
    }];
    
    // 自动scrollview高度
    [contentView_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastView.mas_right);
    }];
}

#pragma mark - 标题点击
- (void)indexSelected:(UIButton *)btn{
    
    NSInteger currentIndex = (NSInteger)btn.tag-100;
    // 全部反选
    for (int i=100; i<pages+100; i++) {
        UIButton *traverseBtn = (UIButton *)[btn.superview viewWithTag:i];
        traverseBtn.selected = NO;
    }
    // 选中当前
    btn.selected = YES;
    
    NSLog(@"currentIndex %d",currentIndex);
    // ScrollView相应移动
    if (pages<5) {
        
    }
    else {
        
        if (currentIndex == 0) {
            
            [titleScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        else if (currentIndex == pages-2){
            
            [titleScrollView setContentOffset:CGPointMake((currentIndex-2)*titleWidth, 0) animated:YES];
        }
        else if (currentIndex == pages-1){
            
            [titleScrollView setContentOffset:CGPointMake((currentIndex-3)*titleWidth, 0) animated:YES];
        }
        else {
            
            [titleScrollView setContentOffset:CGPointMake((currentIndex-1)*titleWidth, 0) animated:YES];
        }
    }
    
    [viewScrollView setContentOffset:CGPointMake((currentIndex)*viewWidth, 0) animated:YES];
}

#pragma mark - scrollView 代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == viewScrollView) {
        
        CGPoint point = scrollView.contentOffset; //记录滑动
        [underLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(point.x*titleWidth/viewWidth);
            make.bottom.equalTo(titleScrollView.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(titleWidth, 2));
        }];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == viewScrollView) {
        
        CGPoint point = scrollView.contentOffset; //记录滑动
        NSInteger countTag = point.x/viewWidth+100;         // 计算按钮tag值
        UIButton *clickBtn = (UIButton *) [contentView_title viewWithTag:countTag];
        [self indexSelected:clickBtn];
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
