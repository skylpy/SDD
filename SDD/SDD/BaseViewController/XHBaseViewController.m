

#import "XHBaseViewController.h"



@interface XHBaseViewController ()<UIGestureRecognizerDelegate>{
    
    NSArray *loadingImages;
    NSArray *loadingImages2;
    
    UIView *noDataTipsView;         // 无提示提示
}

@property (nonatomic, copy) XHBarButtonItemActionBlock barbuttonItemAction;

@end

@implementation XHBaseViewController{
    
}

- (void)clickedBarButtonItemAction {
    if (self.barbuttonItemAction) {
        self.barbuttonItemAction();
    }
}

#pragma mark - Public Method

- (void)configureBarbuttonItemStyle:(XHBarbuttonItemStyle)style action:(XHBarButtonItemActionBlock)action {
    switch (style) {
        case XHBarbuttonItemStyleSetting: {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"barbuttonicon_set"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickedBarButtonItemAction)];
            break;
        }
        case XHBarbuttonItemStyleMore: {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"barbuttonicon_more"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickedBarButtonItemAction)];
            break;
        }
        case XHBarbuttonItemStyleCamera: {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"album_add_photo"] style:UIBarButtonItemStyleBordered target:self action:@selector(clickedBarButtonItemAction)];
            break;
        }
        default:
            break;
    }
    self.barbuttonItemAction = action;
}

- (void)setupBackgroundImage:(UIImage *)backgroundImage {
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundImageView.image = backgroundImage;
    [self.view insertSubview:backgroundImageView atIndex:0];
}

- (void)pushNewViewController:(UIViewController *)newViewController {
    [self.navigationController pushViewController:newViewController animated:YES];
}

#pragma mark - Loading
- (void)showLoading:(NSInteger)loadingType{
    
    switch (loadingType) {
        case 0:
        {
            // 标准菊花加载图
            TAOverlay *overlay  = [[TAOverlay alloc] init];
            overlay.spinner.color = lgrayColor;
            [TAOverlay showOverlayWithLabel:nil Options:TAOverlayOptionOverlayTypeActivityDefault|TAOverlayOptionOverlaySizeRoundedRect];
        }
            break;
        case 1:
        {
            // 自定义加载图 鸟人(详情)
            [TAOverlay showOverlayWithLabel:nil ImageArray:loadingImages2 Duration:0.3 Options:TAOverlayOptionOpaqueBackground | TAOverlayOptionOverlaySizeRoundedRect];
            [TAOverlay setNewFrame:CGRectMake(0, 0, 100, 100)];
        }
            break;
        case 2:
        {
            // 自定义加载图 房（维度）
            [TAOverlay showOverlayWithLabel:nil ImageArray:loadingImages Duration:0.8 Options:TAOverlayOptionOpaqueBackground | TAOverlayOptionOverlaySizeRoundedRect];
        }
            break;
            
        default:
            break;
    }
}

- (void)showLoadingWithText:(NSString *)text{
    
}

- (void)showSuccessWithText:(NSString *)text{
    
    [TAOverlay showOverlayWithLabel:text Options:TAOverlayOptionOverlayTypeSuccess |
                                                 TAOverlayOptionOverlaySizeRoundedRect |
                                                 TAOverlayOptionAutoHide];
}

- (void)showErrorWithText:(NSString *)text{
    
    [TAOverlay showOverlayWithLabel:text Options:TAOverlayOptionOverlayTypeError |
                                                 TAOverlayOptionOverlaySizeRoundedRect |
                                                 TAOverlayOptionAutoHide];
}

- (void)showInfoWithText:(NSString *)text{
    
    [TAOverlay showOverlayWithLabel:text Options:TAOverlayOptionOverlayTypeInfo |
     TAOverlayOptionOverlaySizeRoundedRect |
     TAOverlayOptionAutoHide];
}

- (void)hideLoading{
    
    [TAOverlay hideOverlay];
}

#pragma mark -- 加载失败
- (void)showLoadfailedWithaction:(SEL)action{
    
    UIView * view1 = [[UIView alloc] initWithFrame:self.view.bounds];
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:action];
    [view1 addGestureRecognizer:tap];
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"icon_duanwang"];
    [view1 addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(view1.mas_top).with.offset(100);
        make.centerX.equalTo(view1);
        make.size.mas_equalTo(CGSizeMake(100, 80));
    }];
    
    UILabel * titlabel = [[UILabel alloc] init];
    titlabel.text = @"世界上最遥远的距离就是没有网\n点击屏幕重新加载";
    titlabel.textAlignment = NSTextAlignmentCenter;
    titlabel.numberOfLines = 0;
    titlabel.textColor = lgrayColor;
    [view1 addSubview:titlabel];
    [titlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(imageView.mas_bottom).with.offset(20);
        make.left.equalTo(view1.mas_left).with.offset(0);
        make.right.equalTo(view1.mas_right).with.offset(0);
        make.height.equalTo(@80);
    }];
    
}
//问答弹窗
- (void)showDataWithText:(NSString *)text
             buttonTitle:(NSString *)title
                btnTitle:(NSString *)btntitle
              buttonTag1:(NSInteger)btnTaG1
              buttonTag2:(NSInteger)btnTaG2
                  target:(id)target
                  action:(SEL)action
                 target1:(id)target1
                 action2:(SEL)action2{

    _bigView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    _bigView.alpha = 0.7;
    _bigView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_bigView];
    
    _minView = [[UIView alloc] init];
    _minView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_minView];
    [_minView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(100);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
        //make.bottom.equalTo(self.view.mas_bottom).with.offset(-100);
        make.height.equalTo(@200);
    }];
    
    UILabel * title1 = [[UILabel alloc] init];
    title1.text = @"提示";
    title1.font = [UIFont systemFontOfSize:18];
    title1.textAlignment = NSTextAlignmentCenter;
    [_minView addSubview:title1];
    [title1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_minView.mas_top).with.offset(20);
        make.left.equalTo(_minView.mas_left).with.offset(20);
        make.right.equalTo(_minView.mas_right).with.offset(-20);
        make.height.equalTo(@20);
    }];
    
    UILabel * line = [[UILabel alloc] init];
    line.backgroundColor = tagsColor;
    line.textAlignment = NSTextAlignmentCenter;
    [_minView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(title1.mas_bottom).with.offset(10);
        make.left.equalTo(_minView.mas_left).with.offset(20);
        make.right.equalTo(_minView.mas_right).with.offset(-20);
        make.height.equalTo(@1);
    }];
    
    UILabel * titlelie = [[UILabel alloc] init];
    titlelie.text = text;
    titlelie.textAlignment = NSTextAlignmentCenter;
    titlelie.textColor = [UIColor blackColor];
    titlelie.numberOfLines = 2;
    [_minView addSubview:titlelie];
    [titlelie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).with.offset(20);
        make.left.equalTo(_minView.mas_left).with.offset(20);
        make.right.equalTo(_minView.mas_right).with.offset(-20);
    }];
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundColor:dblueColor];
    button.tag = btnTaG1;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [_minView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_minView.mas_bottom).with.offset(-10);
        //make.centerX.equalTo(_minView);
        make.left.equalTo(_minView.mas_left).with.offset(30);
        make.size.mas_equalTo(CGSizeMake(90, 33));
    }];
    
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:btntitle forState:UIControlStateNormal];
    [button1 setBackgroundColor:dblueColor];
    button1.tag = btnTaG2;
    [button1 addTarget:self action:action2 forControlEvents:UIControlEventTouchUpInside];
    [_minView addSubview:button1];
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_minView.mas_bottom).with.offset(-10);
        //make.centerX.equalTo(_minView);
        make.right.equalTo(_minView.mas_right).with.offset(-30);
        make.size.mas_equalTo(CGSizeMake(90, 33));
    }];
    
}

- (void)showDataWithText:(NSString *)text
             buttonTitle:(NSString *)title
               buttonTag:(NSInteger)btnTag
                  target:(id)target
                  action:(SEL)action{
    
    _bigView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    _bigView.alpha = 0.7;
    _bigView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_bigView];
    
    _minView = [[UIView alloc] init];
    _minView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_minView];
    [_minView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(100);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
        //make.bottom.equalTo(self.view.mas_bottom).with.offset(-100);
        make.height.equalTo(@200);
    }];
    
    UILabel * title1 = [[UILabel alloc] init];
    title1.text = @"提示";
    title1.font = [UIFont systemFontOfSize:18];
    title1.textAlignment = NSTextAlignmentCenter;
    [_minView addSubview:title1];
    [title1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_minView.mas_top).with.offset(20);
        make.left.equalTo(_minView.mas_left).with.offset(20);
        make.right.equalTo(_minView.mas_right).with.offset(-20);
        make.height.equalTo(@20);
    }];
    
    UILabel * line = [[UILabel alloc] init];
    line.backgroundColor = tagsColor;
    line.textAlignment = NSTextAlignmentCenter;
    [_minView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(title1.mas_bottom).with.offset(10);
        make.left.equalTo(_minView.mas_left).with.offset(20);
        make.right.equalTo(_minView.mas_right).with.offset(-20);
        make.height.equalTo(@1);
    }];
    
    UILabel * titlelie = [[UILabel alloc] init];
    titlelie.text = text;
    titlelie.textAlignment = NSTextAlignmentCenter;
    titlelie.textColor = [UIColor blackColor];
    titlelie.numberOfLines = 2;
    [_minView addSubview:titlelie];
    [titlelie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).with.offset(20);
        make.left.equalTo(_minView.mas_left).with.offset(20);
        make.right.equalTo(_minView.mas_right).with.offset(-20);
    }];
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundColor:dblueColor];
    button.tag = btnTag;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [_minView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_minView.mas_bottom).with.offset(-10);
        make.centerX.equalTo(_minView);
        make.size.mas_equalTo(CGSizeMake(90, 33));
    }];
}

#pragma mark - 无数据提示
- (void)showNoDataTipsWithText:(NSString *)text
                   buttonTitle:(NSString *)title
                     buttonTag:(NSInteger)theTag
                        target:(id)target
                        action:(SEL)action{
    
    [noDataTipsView removeFromSuperview];
    
    noDataTipsView = [[UIView alloc] init];
    noDataTipsView.backgroundColor = bgColor;
    [self.view addSubview:noDataTipsView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"icon_nodataface"];
    [noDataTipsView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = titleFont_15;
    label.textColor = lgrayColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    label.numberOfLines = 0;
    [noDataTipsView addSubview:label];
    
    [noDataTipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(30);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(135, 135));
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(15);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.greaterThanOrEqualTo(@14);
        make.width.mas_equalTo(viewWidth-20);
    }];
    
    if (title) {
        
        ConfirmButton *button = [[ConfirmButton alloc] initWithFrame:CGRectZero
                                                               title:title
                                                              target:target
                                                              action:action];
        button.tag = theTag;
        button.enabled = YES;
        
        [noDataTipsView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(15);
            make.centerX.equalTo(self.view.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(viewWidth-40, 45));
        }];
    }
}

- (void)hideNoDataTips{
    
    [noDataTipsView removeFromSuperview];
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor whiteColor];
    
    // 加载图片数组（商）
    NSMutableArray *muArr = [[NSMutableArray alloc] init];
    for (int i=0; i<18; i++) {
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loadingIcon_%d",i+1]];
        [muArr addObject:image];
    }
    
    // 加载图片数组（鸟人）
    NSMutableArray *muArr2 = [[NSMutableArray alloc] init];
    for (int i=1; i<3; i++) {
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loadingBird_%d",i]];
        [muArr2 addObject:image];
    }
    
    loadingImages = muArr;
    loadingImages2 = muArr2;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View rotation

- (BOOL)shouldAutorotate{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)finish{
    
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
     #pragma clang diagnostic pop
    
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

- (void)setNav:(NSString *) title{
    
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = NSLocalizedString(title, @"");
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
}

- (AFHTTPRequestOperationManager *)httpManager
{
    if(!_httpManager)
    {
        _httpManager = [AFHTTPRequestOperationManager manager];
        _httpManager.requestSerializer.timeoutInterval = 10;         //设置超时时间
        _httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];        // ContentTypes 为json
    }
    return _httpManager;
}

#pragma mark - 请求数据
- (void)sendRequest:(NSDictionary *)dic url:(NSString *)urlString{

    [self.httpManager POST:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self onSuccess:operation context:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self onFailure:operation error:error];
        NSLog(@"错误 -- %@", error);
    }];
}

- (void)onFailure:(AFHTTPRequestOperation *)operation error:(NSError *)error{
    
}

- (void)onSuccess:(AFHTTPRequestOperation *)operation context:(id)responseObject{
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

#ifdef _FOR_DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif
@end
