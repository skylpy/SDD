//
//  SDD_Preview.m
//  ShopMoreAndMore
//
//  Created by mac on 15/7/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//
/*
 预览界面 
 基本信息  项目详情  更多选填信息
 */
#import "SDD_Preview.h"
#import "Header.h"
#import "UIImageView+AFNetworking.h"


@interface SDD_Preview ()
{
    UIImageView * headImageView;
    //SDDButton *SDDbutton;
    UILabel *titleLabel;
}

@end

@implementation SDD_Preview

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNvn];
    [self displayContext];
    [self createDownLoad];
    
}

-(void)createNvn
{
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20,viewWidth , 20)];
    titleLabel.text = _BasicArray[0];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    
}

-(void)leftButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)displayContext
{

    self.view.backgroundColor = [SDDColor colorWithHexString:@"#e5e5e5"];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIScrollView *mainScroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:mainScroll];
    UIImageView *previewImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 225)];
    previewImage.image = [UIImage imageNamed:@""];
    previewImage.backgroundColor = bgColor;
    [mainScroll addSubview:previewImage];
    
    mainScroll.contentSize = CGSizeMake(self.view.frame.size.width, 1156);
    mainScroll.showsVerticalScrollIndicator = NO;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 225, self.view.frame.size.width, 937) style:UITableViewStylePlain];//225
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [mainScroll addSubview:self.tableView];
    
    headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 225)];
    [mainScroll addSubview:headImageView];
    
    [headImageView setImageWithURL:[NSURL URLWithString:_UploadDataArray[0]] placeholderImage:[UIImage imageNamed:@"loading_m"]];
    NSLog(@"%@",_UploadDataArray[0]);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 141;
            break;
        case 1:
            return 250;
            break;
        case 2:
            return 285;
            break;
        default:
            break;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0f;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *headerTitle = [NSArray arrayWithObjects:@"基本信息",@"项目详情",@"更多选填", nil];
    return headerTitle[section];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SDD_previewBasicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[SDD_previewBasicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        for (int i = 0; i < _BasicArray.count; i ++) {
            UILabel * contextLa = (UILabel *)[cell viewWithTag:i+100];
            contextLa.text = _BasicArray[i];
        }
        
    }
    if (indexPath.section == 1) {
        SDD_PreviewDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell) {
            cell = [[SDD_PreviewDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSLog(@"_DetailsArray%@",_DetailsArray);
        
        NSArray * arrayOne = _DetailsArray[0];
        NSArray * arrayTwo = _DetailsArray[1];
        NSArray * arrayThree = _DetailsArray[2];
        NSArray * arrayFour = _DetailsArray[3];
        for (int i = 0; i < 9; i ++) {
            UILabel * contextLa = (UILabel *)[cell viewWithTag:i+200];
            if (i == 0 || i == 1 || i == 2) {
                contextLa.text = arrayOne[i];
            }
            if (i == 3 || i == 4) {
                contextLa.text = arrayTwo[i-3];
            }
            if (i == 5 || i == 6) {
                contextLa.text = arrayThree[i - 5];
            }
            if (i == 7 || i == 8) {
                contextLa.text = arrayFour[i - 7];
            }
        }
        
        return cell;
    }
    if (indexPath.section == 2) {
        SDD_PreviewOptionalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (!cell) {
            cell = [[SDD_PreviewOptionalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_MorePagesArray.count >0) {
            NSArray * arrayOne = _MorePagesArray[0];
            NSArray * arrayTwo = _MorePagesArray[1];
            NSArray * arrayThree = _MorePagesArray[2];
            NSArray * arrayFour = _MorePagesArray[3];
            for (int i = 0; i < 11; i ++) {
                UILabel * contextLa = (UILabel *)[cell viewWithTag:i+300];
                if (i == 0 || i == 1 || i == 2) {
                    contextLa.text = arrayOne[i];
                }
                if (i == 3 || i == 4 || i == 5) {
                    contextLa.text = arrayTwo[i-3];
                }
                if (i == 6 || i == 7 || i == 8) {
                    contextLa.text = arrayThree[i - 6];
                }
                if (i == 9 ) {
                    contextLa.text = arrayFour[i - 9];
                }
                if (i == 10) {
                    contextLa.text = arrayFour[i - 8];
                }
                if (i == 11) {
                    NSLog(@"i == 11");
                }
            }
        }
       
        
        return cell;
    }
    return cell;
}


#pragma mark -- 数据下载
-(void)createDownLoad
{
    
    
    [self showLoading:2];
    NSDictionary * dict = @{@"houseFirstId":@(_houseFirstId)};
    
    NSString * path = @"/houseFirst/detail.do";
    
    [HttpRequest postWithNewIssueURL:SDD_MainURL path:path parameter:dict success:^(id Josn) {
        
        NSDictionary * dict = Josn;
        
        NSLog(@"%@--%@",Josn,[Josn objectForKey:@"status"]);
        
        if (_houseFirstId != 0) {
            
            if (![Josn[@"data"] isEqual:[NSNull null]]) {
                
                _BasicArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"意向合作", nil];
                NSLog(@"%@",dict);
                [_BasicArray replaceObjectAtIndex:2 withObject:dict[@"data"][@"address"]];
                [_BasicArray replaceObjectAtIndex:1 withObject:dict[@"data"][@"developersName"]];
                [_BasicArray replaceObjectAtIndex:0 withObject:dict[@"data"][@"houseName"] ];
                [_BasicArray replaceObjectAtIndex:3 withObject:dict[@"data"][@"houseDescription"]];
                
                titleLabel.text = _BasicArray[0];
                
                
                NSMutableArray * oneArray = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"%@",dict[@"data"][@"price"]],[NSString stringWithFormat:@"%@",dict[@"data"][@"rentPrice"]],[NSString stringWithFormat:@"%@",dict[@"data"][@"merchantsState"]], nil];
                //
                
                //时间戳转时间
                NSString *str=[NSString stringWithFormat:@"%@",dict[@"data"][@"openedTime"]];//时间戳
                NSTimeInterval time=[str doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
                NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
                //实例化一个NSDateFormatter对象
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                //设定时间格式,这里可以设置成自己需要的格式
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                
                NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
                
                
                //时间戳转时间
                NSString *str1=[NSString stringWithFormat:@"%@",dict[@"data"][@"openingTime"]];//时间戳
                NSTimeInterval time1=[str1 doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
                NSDate *detaildate1=[NSDate dateWithTimeIntervalSince1970:time1];
                //实例化一个NSDateFormatter对象
                NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
                //设定时间格式,这里可以设置成自己需要的格式
                [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
                
                NSString *currentDateStr1 = [dateFormatter1 stringFromDate: detaildate1];
                
                NSMutableArray * twoArray = [[NSMutableArray alloc] initWithObjects:currentDateStr,currentDateStr1, nil];
                NSMutableArray * thriArray = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"%@",dict[@"data"][@"planArea"]],[NSString stringWithFormat:@"%@",dict[@"data"][@"buildingArea"]], nil];
                NSMutableArray * fourArray = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"%@",dict[@"data"][@"planFormat"]],[NSString stringWithFormat:@"哈哈"], nil];
                
                //        NSLog(@"%@---%@---%@",oneArray,twoArray,thriArray);
                
                _DetailsArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"", nil];
                [_DetailsArray replaceObjectAtIndex:0 withObject:oneArray];
                [_DetailsArray replaceObjectAtIndex:1 withObject:twoArray];
                [_DetailsArray replaceObjectAtIndex:2 withObject:thriArray];
                [_DetailsArray replaceObjectAtIndex:3 withObject:fourArray];
                
                
                NSMutableArray * oneArray1 = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"%@",dict[@"data"][@"merchantsState"]],[NSString stringWithFormat:@"%@",dict[@"data"][@"buildingStartTime"]],[NSString stringWithFormat:@"%@",dict[@"data"][@"propertyAge"]], nil];
                
                NSMutableArray * twoArray2 = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"%@",dict[@"data"][@"publicRoundRate"]],[NSString stringWithFormat:@"%@",dict[@"data"][@"greeningRate"]],[NSString stringWithFormat:@"%@",dict[@"data"][@"volumeRate"]], nil];
                
                NSMutableArray * thriArray3 = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"%@",dict[@"data"][@"properties"]],[NSString stringWithFormat:@"%@",dict[@"data"][@"groundParkingSpaces"]],[NSString stringWithFormat:@"%@",dict[@"data"][@"undergroundParkingSpaces"]], nil];
                
                NSMutableArray * fourArray4 = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"%@",dict[@"data"][@"surroundingCompetingProducts"]],[NSString stringWithFormat:@"哈哈"],[NSString stringWithFormat:@"%@",dict[@"data"][@"businessComment"]], nil];
                
                NSLog(@"%@---%@---%@ -- %@",oneArray1,twoArray2,thriArray3,fourArray4);
                
                _MorePagesArray = [NSMutableArray array] ;
                [_MorePagesArray addObject:oneArray1];
                [_MorePagesArray addObject:twoArray2];
                [_MorePagesArray addObject:thriArray3];
                [_MorePagesArray addObject:fourArray4];
                
                NSLog(@"_MorePagesArray %@",_MorePagesArray);
                
                _UploadDataArray = [[NSMutableArray alloc] initWithObjects:@"",@"",nil];
                [_UploadDataArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%@",dict[@"data"][@"defaultImage"]]];
                [_UploadDataArray replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%@",dict[@"data"][@"realMapImage"]]];
                [headImageView setImageWithURL:[NSURL URLWithString:_UploadDataArray[0]]];
                
                [_tableView reloadData];
            }
            
        }
        [self hideLoading];
        [self showSuccessWithText:@"加载完成"];
        
    } failure:^(NSError *error) {
        [self hideLoading];
        [self showErrorWithText:@"加载失败"];
    }];
    
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
