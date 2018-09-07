//
//  PersonalViewController.m
//  SDD
//
//  Created by hua on 15/8/11.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "PersonalViewController.h"
#import "PersonalCollectionViewCell.h"
#import "PersonalTabButton.h"
#import "UserInfo.h"

#import "PersonalInfoViewController.h"
#import "ScanningViewController.h"
#import "ChatMessageController.h"
#import "CouponViewController.h"
#import "ProjectRentViewController.h"
#import "BBSActivitiesViewController.h"
#import "MyJoinInViewController.h"
#import "JoinInBeforeViewController.h"
#import "DynamicAnswerViewController.h"
#import "EvaluateManagerController.h"
#import "MyCollectionViewController.h"
#import "CommonToolController.h"
#import "MyPublishViewController.h"

#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

#import "MyCertificationViewController.h"

#import "MoreViewController.h"
#import "MyIssueViewController.h"
#import "personalTwoViewController.h"

#import "integralViewController.h"
#import "NewProjectRentViewController.h"

@interface PersonalViewController ()<IChatManagerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    
    /*- ui -*/
    
    UICollectionView *indexCollectionView;
    
    /*- data -*/
    
    NSDictionary *userInfoDic;
    NSDictionary *itemDic;
    
    /*- data -*/
    NSArray *dataSource;
    
    NSInteger unreadMessagesCount;//没读消息总数
}

@end

@implementation PersonalViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.viewForBaselineLayout.hidden = NO;      //  显示tabar
    
    [self initData];  //初始化环信数据
    
    
    // 判断是否登录状态
    if([GlobalController isLogin]){
        
        // 请求用户信息
        [self requestUserInfo];
    }
    else {
        
        // 设置头像
        UIButton *avatarBtn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
        [avatarBtn sd_setImageWithURL:[UserInfo sharedInstance].userInfoDic[@"icon"] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultAvatar_icon_"]];
        [indexCollectionView reloadData];
    }
}

#pragma mark - 用户信息
- (void)requestUserInfo{
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/user/detail.do" params:nil success:^(id JSON) {
        
//      NSLog(@"%@>>>>>>>%@",JSON[@"message"],JSON);
        
        if (![JSON[@"data"] isEqual:[NSNull null]]) {
            
            // 用户信息
            [UserInfo sharedInstance].userInfoDic = JSON[@"data"];
            userInfoDic = JSON[@"data"];
            
            // 设置头像
            UIButton *avatarBtn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
            [avatarBtn sd_setImageWithURL:[UserInfo sharedInstance].userInfoDic[@"icon"] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultAvatar_icon_"]];
            [indexCollectionView reloadData];
        }
    } failure:^(NSError *error) {
        //
        NSLog(@"错误 -- %@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 导航条
    [self setupNav];
    // 设置内容
    [self setupUI];
    // 读取未读消息和监听未读消息通知
    [self registerNotifications];
    [self setupUnreadMessageCount];
    
    
}

#pragma  mark -- 初始化环信数据
-(void)initData
{
    dataSource = [self loadDataSource];
    unreadMessagesCount = 0;
    NSLog(@"dataSource == %@",dataSource);
    for (int i = 0; i < dataSource.count; i ++) {
        
        EMConversation *conversation = dataSource[i];
        unreadMessagesCount += conversation.unreadMessagesCount;
        
    }
    indexCollectionView.delegate = self;
    indexCollectionView.dataSource = self;
}

#pragma mark -- 环信接收的消息
- (NSMutableArray *)loadDataSource
{
    NSMutableArray *ret = nil;
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    
    NSArray* sorte = [conversations sortedArrayUsingComparator:
                      ^(EMConversation *obj1, EMConversation* obj2){
                          EMMessage *message1 = [obj1 latestMessage];
                          EMMessage *message2 = [obj2 latestMessage];
                          if(message1.timestamp > message2.timestamp) {
                              return(NSComparisonResult)NSOrderedAscending;
                          }else {
                              return(NSComparisonResult)NSOrderedDescending;
                          }
                      }];
    
    ret = [[NSMutableArray alloc] initWithArray:sorte];
    return ret;
}


#pragma mark - 设置导航条
- (void)setupNav{
    
    // 个人信息
    UIButton *avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    avatarButton.frame = CGRectMake(0, 0, 35, 35);
    avatarButton.titleLabel.font = biggestFont;
    [avatarButton sd_setImageWithURL:[UserInfo sharedInstance].userInfoDic[@"icon"] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultAvatar_icon_"]];
    [avatarButton addTarget:self action:@selector(myInfo:) forControlEvents:UIControlEventTouchUpInside];
    [Tools_F setViewlayer:avatarButton cornerRadius:35/2 borderWidth:1 borderColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:avatarButton];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"我的";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    // 扫一扫
//    UIButton *scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    scanButton.frame = CGRectMake(0, 0, 35, 35);
//    scanButton.titleLabel.font = biggestFont;
//    [scanButton setImage:[UIImage imageNamed:@"mine_item_saoyisao"] forState:UIControlStateNormal];
//    [scanButton addTarget:self action:@selector(scanner:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:scanButton];
    
    UIButton * setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.frame = CGRectMake(0, 0, 20, 20);
    [setBtn setBackgroundImage:[UIImage imageNamed:@"set_icon"] forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(setBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * setBtnItem = [[UIBarButtonItem alloc] initWithCustomView:setBtn];
    self.navigationItem.rightBarButtonItem = setBtnItem;
}

#pragma mark - 设置
-(void)setBtnClick:(UIButton *)btn
{
    CommonToolController *ctVC = [[CommonToolController alloc] init];
    
    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
    [self.navigationController pushViewController:ctVC animated:YES];

}
#pragma mark - 设置内容
- (void)setupUI{
    
    itemDic = @{@"headerTitle":@[@"消息",@"优惠券",@"积分"],
                @"headerIcon":@[@"mine_item_message",@"mine_item_coupon",@"mine_item_goal"],
                @"icon": @[@"项目团租",@"论坛/活动",@"品牌加盟",
                           @"我的问答",@"我的发布",@"我的认证",
                           @"评价/举报",@"收藏",@"更多",@""],
                @"title":@[@"mine_item_rent",@"mine_item_activity",@"pinpaiguwen",
                           @"mine_item_myask",@"mine_item_publish",@"mine_item_approve",
                           @"mine_item_evaluation",@"mine_item_collection",@"icon_more1",@""]//mine_item_hope
                };

    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.minimumLineSpacing = 2;
    
    indexCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-104)collectionViewLayout:flowLayout];
    indexCollectionView.delegate = self;
    indexCollectionView.dataSource = self;
    indexCollectionView.backgroundColor = bgColor;
    
    [indexCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    [indexCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    [indexCollectionView registerNib:[UINib nibWithNibName:@"PersonalCollectionViewCell"
                                               bundle:nil]
     forCellWithReuseIdentifier:@"PersonalCell"];     // 通过xib创建cell
    
    [self.view addSubview:indexCollectionView];
}

#pragma mark - 定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 9;
}

#pragma mark - 定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

#pragma mark - 每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * identifier = @"PersonalCell";
    PersonalCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.title.text = itemDic[@"icon"][indexPath.row];
    cell.icon.contentMode = UIViewContentModeScaleAspectFit;
    cell.icon.image = [UIImage imageNamed:itemDic[@"title"][indexPath.row]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout 定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(viewWidth/3-2, viewWidth/3);
}

#pragma mark - 定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(1, 1, 15, 1);
}

#pragma mark - 返回头headerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = {viewWidth,viewWidth/3};
    return size;
}

//#pragma mark - 返回脚footerView的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
//    CGSize size = {viewWidth,45};
//    return size;
//}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        if (reusableview == nil) {
            
            reusableview = [[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewWidth/3)];
        }
        // 背景颜色
        reusableview.backgroundColor = mainTitleColor;
        // 移除旧，新增视图
        for (UIView *all in reusableview.subviews) {
            [all removeFromSuperview];
        }
        for (int i=0; i<3; i++) {
            
            PersonalTabButton *tabButton = [[PersonalTabButton alloc] init];
            tabButton.frame = CGRectMake(viewWidth/3*i, 0, viewWidth/3, viewWidth/3);
            tabButton.tag = 100+i;
            tabButton.titleLabel.font = titleFont_15;
            tabButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            [tabButton setTitle:itemDic[@"headerTitle"][i] forState:UIControlStateNormal];
            [tabButton setTitleColor:ldivisionColor forState:UIControlStateNormal];
            [tabButton setImage:[UIImage imageNamed:itemDic[@"headerIcon"][i]] forState:UIControlStateNormal];
            [tabButton addTarget:self action:@selector(topTabJump:) forControlEvents:UIControlEventTouchUpInside];
            [reusableview addSubview:tabButton];
            
            if (i == 0) {
                
                UILabel * unMessCLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth/3-30, 20, 20, 20)];
                unMessCLabel.text = [NSString stringWithFormat:@"%ld",unreadMessagesCount];
                unMessCLabel.textAlignment = NSTextAlignmentCenter;
                unMessCLabel.backgroundColor = [UIColor redColor];
                unMessCLabel.textColor = [UIColor whiteColor];
                unMessCLabel.layer.cornerRadius = 10;
                unMessCLabel.clipsToBounds = YES;
                [tabButton addSubview:unMessCLabel];
                if (unreadMessagesCount == 0) {
                    unMessCLabel.hidden = YES;
                }
                else
                {
                    unMessCLabel.hidden = NO;
                }
            }
        }
        return reusableview;
    }
//    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
//        
//        UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
//                                                                                    withReuseIdentifier:@"FooterView"
//                                                                                           forIndexPath:indexPath];
//        
//        if (reusableview == nil) {
//            
//            reusableview = [[UICollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 45)];
//        }
//        // 背景颜色
//        reusableview.backgroundColor = [UIColor whiteColor];
//        // 移除旧，新增视图
//        for (UIView *all in reusableview.subviews) {
//            [all removeFromSuperview];
//        }
//        
//        UILabel *settings = [[UILabel alloc] init];
//        settings.frame = CGRectMake(30, 0, viewWidth-100, 45);
//        settings.font = titleFont_15;
//        settings.textColor = mainTitleColor;
//        settings.text = @"设置";
//        [reusableview addSubview:settings];
//        
//        UITapGestureRecognizer *footerTap = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                                    action:@selector(goToSettiong)];
//        [reusableview addGestureRecognizer:footerTap];
//        
//        return reusableview;
//    }
    
    return nil;
}

#pragma mark - UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UIViewController *viewController;
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        viewController = loginVC;
    }
    else {
        switch (indexPath.row) {
            case 0:
            {
                NewProjectRentViewController *jrVC = [[NewProjectRentViewController alloc] init];
                //ProjectRentViewController *jrVC = [[ProjectRentViewController alloc] init];
                viewController = jrVC;
            }
                break;
            case 1:
            {
                BBSActivitiesViewController *bbsaVC = [[BBSActivitiesViewController alloc] init];
                viewController = bbsaVC;
            }
                break;
            case 2:
            {
                MyJoinInViewController *jiVC = [[MyJoinInViewController alloc] init];
                viewController = jiVC;
            }
                break;
            case 3:
            {
                DynamicAnswerViewController *daVC = [[DynamicAnswerViewController alloc] init];
                viewController = daVC;
            }
                break;
            case 4:
            {
                MyIssueViewController *myIssVc = [[MyIssueViewController alloc] init];
                viewController = myIssVc;
            }
                break;
            case 5:
            {
                MyCertificationViewController *myCer = [[MyCertificationViewController alloc] init];
                viewController = myCer;
            }
                break;
            case 6:
            {
//                EvaluateManagerController *emVC = [[EvaluateManagerController alloc] init];
//                viewController = emVC;
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"开发中"
                                                               delegate:self
                                                      cancelButtonTitle:@"好"
                                                      otherButtonTitles:nil, nil];
                [alert show];
            }
                break;
            case 7:
            {
                MyCollectionViewController *mcVC = [[MyCollectionViewController alloc] init];
                viewController = mcVC;
            }
                break;
            case 8:
            {
                NSLog(@"jhjkhfkhsfd");
                MoreViewController * moreVc = [[MoreViewController alloc] init];
                viewController = moreVc;
            }
                break;
            default:
            {
                NSLog(@"jhjkhfkhsfd");
                MoreViewController * moreVc = [[MoreViewController alloc] init];
                viewController = moreVc;
            }
                break;
        }
    }
    
    if (viewController) {
        
        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

//返回这个UICollectionView是否可以被选择
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return indexPath.row<=8?YES:NO;
}

#pragma mark - 设置
- (void)goToSettiong{
    
    CommonToolController *ctVC = [[CommonToolController alloc] init];
    
    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
    [self.navigationController pushViewController:ctVC animated:YES];
}

#pragma mark - 我的信息
- (void)topTabJump:(UIButton *)btn{
    
    NSInteger index = (NSInteger)btn.tag-100;
    
    UIViewController *vc;
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        vc = loginVC;
    }
    else {
        
        switch (index) {
            case 0:
            {
                // 消息
                ChatMessageController *cmVC = [ChatMessageController alloc];
                vc = cmVC;
            }
                break;
            case 1:
            {
                // 优惠券
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"开发中"
                                                               delegate:self
                                                      cancelButtonTitle:@"好"
                                                      otherButtonTitles:nil, nil];
                [alert show];
//                // 优惠券
//                CouponViewController * couVc = [[CouponViewController alloc] init];
//                vc = couVc;
            }
                break;
            case 2:
            {
                // 积分
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                                message:@"开发中"
//                                                               delegate:self
//                                                      cancelButtonTitle:@"好"
//                                                      otherButtonTitles:nil, nil];
//                [alert show];
                
                integralViewController *itgVc = [[integralViewController alloc] init];
                vc = itgVc;
                
                
            }
                break;
        }
    }
    if (vc) {
        
        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - 我的信息
- (void)myInfo:(UIButton *)btn{
    
    if (![GlobalController isLogin]) {
        
        LoginController *loginVC = [[LoginController alloc] init];
        
        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    else {
        //personalTwoViewController
        //PersonalInfoViewController *myDataVC = [[PersonalInfoViewController alloc] init];
        personalTwoViewController *myDataVC = [[personalTwoViewController alloc] init];
        myDataVC.userInfoDic = userInfoDic;

        self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
        [self.navigationController pushViewController:myDataVC animated:YES];
    }
}

#pragma mark - 扫一扫
- (void)scanner:(UIButton *)btn{
    
    ScanningViewController *scanView = [[ScanningViewController alloc] init];
    
    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;      //  隐藏tabar
    [self.navigationController pushViewController:scanView animated:YES];
}

#pragma mark - private
- (void)registerNotifications{
    
    [self unregisterNotifications];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    //    [[EMSDKFull sharedInstance].callManager addDelegate:self delegateQueue:nil];
}

- (void)unregisterNotifications{
    
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    //    [[EMSDKFull sharedInstance].callManager removeDelegate:self];
}

- (void)didUnreadMessagesCountChanged{
    
    [self setupUnreadMessageCount];
}

// 统计未读消息数
- (void)setupUnreadMessageCount{
    
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
    NSInteger unReadCount = 0;
    for (EMConversation *conversation in conversations) {
        unReadCount += conversation.unreadMessagesCount;
    }
    
    NSLog(@"未读消息%d",unReadCount);
    if (unReadCount != 0) {
//        _la.ffc.unRead.hidden = NO;
//        _la.ffc.unRead.text = [NSString stringWithFormat:@"%d",unreadCount];
    }
    else {
//        _la.ffc.unRead.hidden = YES;
    }
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unReadCount];
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
