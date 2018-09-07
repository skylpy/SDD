//
//  ProjectCoopViewController.m
//  SDD
//
//  Created by mac on 15/11/25.
//  Copyright (c) 2015年 jofly. All rights reserved.
//
#define nav_titleWidth (viewHeight == 736? 110:viewHeight == 667? 80:72)
#import "ProjectCoopViewController.h"
#import "VIPhotoView.h"
#import "PanoramicMapViewController.h"
#import "UIImageView+WebCache.h"
@interface ProjectCoopViewController ()<VIPhotoViewDelegate>
{

    UIButton *projectButton;
    UIButton *mapButton;
    PanoramicMapViewController *psVC;
    VIPhotoView *photoView;
    
    UILabel *peopleLabel;                      // 商圈人口
    UILabel *similerProjectLabel;                          // 周边
    UILabel *homeLabel;                      // 住宅
    UILabel *trafficLabel;                       // 交通
    UIView *bottomView;
    UIButton *drawButton;
    CGFloat y;
}
@end

@implementation ProjectCoopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSLog(@"%@",_model.hd_house);
    self.view.backgroundColor = bgColor;
    [self setNav];
    [self createMainView];
    // Do any additional setup after loading the view.
}
- (void)setNav{

    
    [self setNav:@""];
    // 中间选择
    UIView *titleView = [[UIView alloc] init];
    titleView.frame = CGRectMake(0, 0, nav_titleWidth*2, 30);
    
    [Tools_F setViewlayer:titleView cornerRadius:15 borderWidth:1 borderColor:[UIColor whiteColor]];
    
    projectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    projectButton.frame = CGRectMake(0, 0, nav_titleWidth, 30);
    projectButton.clipsToBounds = YES;
    projectButton.tag = 100;
    [Tools_F commonWithButton:projectButton font:biggestFont
                        title:@"项目商圈" selectedTitle:nil
                   titleColor:[UIColor whiteColor]
           selectedtitleColor:mainTitleColor
                backgroundImg:[Tools_F imageWithColor:mainTitleColor size:CGSizeMake(1, 1)]
        selectedBackgroundImg:[Tools_F imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)]
                       target:self
                       action:@selector(projectCopp:)];
    projectButton.titleLabel.font = midFont;
    [titleView addSubview:projectButton];
    
    mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mapButton.frame = CGRectMake(CGRectGetMaxX(projectButton.frame), 0, nav_titleWidth, 30);
    mapButton.clipsToBounds = YES;
    mapButton.tag = 101;
    [Tools_F commonWithButton:mapButton font:biggestFont
                        title:@"360全景图"
                selectedTitle:nil
                   titleColor:[UIColor whiteColor]
           selectedtitleColor:mainTitleColor
                backgroundImg:[Tools_F imageWithColor:mainTitleColor size:CGSizeMake(1, 1)]
        selectedBackgroundImg:[Tools_F imageWithColor:[UIColor whiteColor] size:CGSizeMake(1, 1)]
                       target:self
                       action:@selector(mapVC:)];
    mapButton.titleLabel.font = midFont;
    [titleView addSubview:mapButton];
    
    projectButton.selected = YES;
    self.navigationItem.titleView = titleView;
}
- (void)createMainView{

    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    if([_model.hd_images[@"trafficMapUrls"] count]>0) {
        
        NSString *imageURL = _model.hd_images[@"trafficMapUrls"][0];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"loading_b"]];
        photoView = [[VIPhotoView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight - 210)
                                                       andImageView:imageView];
        photoView.movingDelegate = self;
        
        photoView.autoresizingMask = (1 << 6) -1;
        
        UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(drawClickImage)];
        [imageView addGestureRecognizer:tapImage];
        [self.view addSubview:photoView];
        [self.view sendSubviewToBack:photoView];
        
        
    }
    
    bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(drawClick)];
    [bottomView addGestureRecognizer:tap];
    [self.view addSubview:bottomView];

    drawButton = [UIButton buttonWithType:UIButtonTypeCustom];
   
    [drawButton setImage:[UIImage imageNamed:@"icon-chevron-down"] forState:UIControlStateNormal];
    [drawButton setImage:[UIImage imageNamed:@"icon-chevron-up"] forState:UIControlStateSelected];
    drawButton.frame = CGRectMake(0, 0, viewWidth, 20);
    [drawButton addTarget:self action:@selector(drawClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:drawButton];
    
    peopleLabel = [[UILabel alloc] init];
    peopleLabel.font = titleFont_15;
    peopleLabel.textColor = mainTitleColor;
    peopleLabel.numberOfLines = 0;
 
    NSString *peoString = [NSString stringWithFormat:@"商圈人口数:  %@",_model.hd_house[@"surroundingPersons"]];
    NSMutableAttributedString *peopleString = [[NSMutableAttributedString alloc] initWithString:peoString];
    [peopleString addAttribute:NSForegroundColorAttributeName
                        value:lgrayColor
                        range:[peoString
                               rangeOfString:_model.hd_house[@"surroundingPersons"]]];
    peopleLabel.attributedText = peopleString;
    
    //ReviewModel *model = _dataArray[indexPath.row];
//    NSString *comment = peoString;
//    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:15]};
//    CGSize size = [comment boundingRectWithSize:CGSizeMake(viewWidth, 1000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    
    CGSize peopleSize = [Tools_F countingSize:peoString fontSize:15 width:viewWidth - 20];
    
    NSLog(@"%f",peopleSize.height);
    
    peopleLabel.frame = CGRectMake(10, drawButton.y + drawButton.height + 3, viewWidth - 20, peopleSize.height+10);
    [bottomView addSubview:peopleLabel];

    
    
    similerProjectLabel = [[UILabel alloc] init];
    similerProjectLabel.font = titleFont_15;
    similerProjectLabel.textColor = mainTitleColor;
    similerProjectLabel.numberOfLines = 0;

    NSString *simString = [NSString stringWithFormat:@"周边同类项目:  %@",_model.hd_house[@"similarProjects"]];
    NSMutableAttributedString *similerString = [[NSMutableAttributedString alloc] initWithString:simString];
    [similerString addAttribute:NSForegroundColorAttributeName
                         value:lgrayColor
                         range:[simString
                                rangeOfString:_model.hd_house[@"similarProjects"]]];
    similerProjectLabel.attributedText = similerString;
    
    CGSize simSize = [Tools_F countingSize:simString fontSize:15 width:viewWidth - 20];
    
    similerProjectLabel.frame = CGRectMake(10, peopleLabel.y + peopleLabel.height , viewWidth - 20, simSize.height+20);
    
    [bottomView addSubview:similerProjectLabel];


    
    homeLabel = [[UILabel alloc] init];
    homeLabel.font = titleFont_15;
    homeLabel.textColor = mainTitleColor;
    homeLabel.numberOfLines = 0;

    NSString *hoString = [NSString stringWithFormat:@"住宅小区:  %@",_model.hd_house[@"residentialArea"]];
    NSMutableAttributedString *homeString = [[NSMutableAttributedString alloc] initWithString:hoString];
    [homeString addAttribute:NSForegroundColorAttributeName
                          value:lgrayColor
                          range:[hoString
                                 rangeOfString:_model.hd_house[@"residentialArea"]]];
    
    homeLabel.attributedText = homeString;
    
    
    CGSize homeSize = [Tools_F countingSize:hoString fontSize:15 width:viewWidth - 20];
    
    homeLabel.frame = CGRectMake(10, similerProjectLabel.y + similerProjectLabel.height , viewWidth - 20, homeSize.height);
    [bottomView addSubview:homeLabel];

    trafficLabel = [[UILabel alloc] init];
    trafficLabel.font = titleFont_15;
    trafficLabel.textColor = mainTitleColor;
    trafficLabel.numberOfLines = 0;

    NSString *traString = [NSString stringWithFormat:@"交通枢纽:  %@",_model.hd_house[@"transportationHub"]];
    NSMutableAttributedString *trafficString = [[NSMutableAttributedString alloc] initWithString:traString];
    [trafficString addAttribute:NSForegroundColorAttributeName
                       value:lgrayColor
                       range:[traString
                              rangeOfString:_model.hd_house[@"transportationHub"]]];
    trafficLabel.attributedText = trafficString;
    
    CGSize traSize = [Tools_F countingSize:traString fontSize:15 width:viewWidth - 20];
    
    trafficLabel.frame = CGRectMake(10, homeLabel.y + homeLabel.height + 1 , viewWidth - 20, traSize.height+10);
    [bottomView addSubview:trafficLabel];


    y = peopleLabel.height + similerProjectLabel.height + homeLabel.height + trafficLabel.height;
    bottomView.frame = CGRectMake(0, viewHeight - y -40 -64, viewWidth,
                                  peopleLabel.height + similerProjectLabel.height + homeLabel.height + trafficLabel.height + 40  + 64);

    NSLog(@"%d",y);
}
- (void)drawClick{

    
    NSLog(@"进来了");
    
    if (!drawButton.selected) {
        bottomView.frame = CGRectMake(0, viewHeight - 20-64, viewWidth, 20+64);
        photoView.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    }else{
    
        bottomView.frame = CGRectMake(0, viewHeight - y - 40 - 64, viewWidth,
                                      peopleLabel.height + similerProjectLabel.height + homeLabel.height + trafficLabel.height + 40 + 64);
    }
    drawButton.selected = !drawButton.selected;
}
- (void)drawClickImage{

    bottomView.frame = CGRectMake(0, viewHeight - 20-64, viewWidth, 20+64);
    photoView.frame = CGRectMake(0, 0, viewWidth, viewHeight);

}
- (void)projectCopp:(UIButton *)button{
    
//    UIButton *otherBtn = (UIButton *)[button.superview viewWithTag:100];
//    otherBtn.selected = NO;
//    button.selected = YES;
    projectButton.selected = YES;
    mapButton.selected = NO;
    [psVC removeFromParentViewController];
    [psVC.view removeFromSuperview];
}
- (void)mapVC:(UIButton *)button{
    
    projectButton.selected = NO;
    mapButton.selected = YES;
    psVC = [[PanoramicMapViewController alloc]init];
    psVC.titleTStr = _model.hd_house[@"houseName"];
    psVC.latitude = _model.hd_house[@"latitude"];
    psVC.longitude = _model.hd_house[@"longitude"];
    psVC.view.frame = self.view.bounds;
    [self addChildViewController:psVC];
    [self.view addSubview:psVC.view];
    
    
}
#pragma mark - 伸缩图片代理
-(void)moving:(BOOL)isMoving{

    bottomView.hidden = isMoving;
    
    if (isMoving) {
        
        NSLog(@"%d",drawButton.selected);
      drawButton.selected = YES;
       photoView.frame = CGRectMake(0, 0, viewWidth, viewHeight);
       bottomView.frame = CGRectMake(0, viewHeight - 20-64, viewWidth, 20+64);
        
    }

    
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
