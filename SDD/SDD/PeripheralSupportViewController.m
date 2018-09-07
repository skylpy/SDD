//
//  PeripheralSupportViewController.m
//  SDD
//
//  Created by mac on 15/11/18.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "PeripheralSupportViewController.h"
#import "HouseDetailTitle.h"
#import "MapViewController.h"

@interface PeripheralSupportViewController ()<BMKPoiSearchDelegate,UITableViewDelegate,UITableViewDataSource>
{
    BMKPoiSearch * _searcher;
    BMKPoiSearch * _searcher1;
    BMKPoiSearch * _searcher2;
    BMKPoiSearch * _searcher3;
    BOOL flag;
    BOOL flag1;
    BOOL flag2;
    BOOL flag3;
    
    NSMutableArray * schoolArr;
    NSMutableArray * subwayArr;
    NSMutableArray * BusArr;
    NSMutableArray * hospitalArr;
    
    NSMutableString * schoolStr;
    NSMutableString * subwayStr;
    NSMutableString * BusStr;
    NSMutableString * hospitalStr;
    
    UIScrollView *bg_scrollView;
    
    UITableView * table;
    
    MapViewController * _mapVC;
}

@end

@implementation PeripheralSupportViewController

-(NSMutableArray *)schoolArr{
    if (!schoolArr) {
        schoolArr = [[NSMutableArray alloc]init];
    }
    return schoolArr;
}
-(NSMutableArray *)subwayArr{
    if (!subwayArr) {
        subwayArr = [[NSMutableArray alloc]init];
    }
    return subwayArr;
}
-(NSMutableArray *)BusArr{
    if (!BusArr) {
        BusArr = [[NSMutableArray alloc]init];
    }
    return BusArr;
}
-(NSMutableArray *)hospitalArr{
    if (!hospitalArr) {
        hospitalArr = [[NSMutableArray alloc]init];
    }
    return hospitalArr;
}
//不使用时将delegate设置为 nil
-(void)viewWillDisappear:(BOOL)animated
{
    _searcher.delegate = nil;
    _searcher1.delegate = nil;
    _searcher2.delegate = nil;
    _searcher3.delegate = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    [self setNav:@"周边配套"];
    
    
    
    [self school];
    [self subway];
    [self Bus];
    [self hospital];
    [self createView];
}
//点击
-(void)mapClick:(UIButton *)sender{
    
    if (!sender.selected) {
        
        _mapVC = [[MapViewController alloc] init];
        
        //_mapVC.regionId = _regionId;
        _mapVC.theLatitude = _theLatitude;
        _mapVC.theLongitude = _theLongitude;
        _mapVC.fromIndex = 0;
        
        _mapVC.view.frame = CGRectMake(0, 0, viewWidth, viewHeight - 40 - 64);
        
        [self addChildViewController:_mapVC];
        
        [self.view addSubview:_mapVC.view];
        
        sender.selected = YES;
        //[sender setImage:[UIImage imageNamed:@"home_top_liebiao"] forState:UIControlStateNormal];
        
        
    }else{
        
        //[sender setImage:[UIImage imageNamed:@"index_btn_map"] forState:UIControlStateNormal];
        [_mapVC removeFromParentViewController];
        [_mapVC.view removeFromSuperview];
        sender.selected = NO;
    }
}

-(void)school{
    //初始化检索对象
    _searcher =[[BMKPoiSearch alloc]init];
    _searcher.delegate = self;
    //发起检索
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = 0;
    option.pageCapacity = 10;
    option.location = CLLocationCoordinate2DMake(_theLatitude, _theLongitude);//{39.915, 116.404}
    option.keyword = @"学校";
    flag = [_searcher poiSearchNearBy:option];
    
    if(flag)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
}
-(void)subway{
    //初始化检索对象
    _searcher1 =[[BMKPoiSearch alloc]init];
    _searcher1.delegate = self;
    
    //发起检索
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = 0;
    option.pageCapacity = 10;
    option.location = CLLocationCoordinate2DMake(_theLatitude, _theLongitude);//{39.915, 116.404}
    option.keyword = @"地铁";
    flag1 = [_searcher1 poiSearchNearBy:option];
    
    if(flag1)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
}
-(void)Bus{
    //初始化检索对象
    _searcher2 =[[BMKPoiSearch alloc]init];
    _searcher2.delegate = self;
    //发起检索
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = 0;
    option.pageCapacity = 10;
    option.location = CLLocationCoordinate2DMake(_theLatitude, _theLongitude);//{39.915, 116.404}
    option.keyword = @"公交";
    flag2 = [_searcher2 poiSearchNearBy:option];
    
    if(flag2)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
}
-(void)hospital{
    //初始化检索对象
    _searcher3 =[[BMKPoiSearch alloc]init];
    _searcher3.delegate = self;
    //发起检索
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = 0;
    option.pageCapacity = 10;
    option.location = CLLocationCoordinate2DMake(_theLatitude, _theLongitude);//{39.915, 116.404}
    option.keyword = @"医院";
    flag3 = [_searcher3 poiSearchNearBy:option];
    
    if(flag3)
    {
        NSLog(@"周边检索发送成功");
    }
    else
    {
        NSLog(@"周边检索发送失败");
    }
}
//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        //NSLog(@"正常结果 %@",poiResultList.poiInfoList);
        if (searcher == _searcher) {
            schoolStr = [[NSMutableString alloc] init];
            for (BMKPoiInfo * info in poiResultList.poiInfoList) {
                
                NSLog(@"学校---%@",info.name);
                [self.schoolArr addObject:info.name];
                [schoolStr appendFormat:@" %@ ,",info.name];
                
            }
            [table reloadData];
        }else if (searcher == _searcher1){
            subwayStr = [[NSMutableString alloc] init];
            for (BMKPoiInfo * info in poiResultList.poiInfoList) {
                
                NSLog(@"地铁---%@",info.name);
                [self.subwayArr addObject:info.name];
                [subwayStr appendFormat:@" %@ ,",info.name];
            }
            [table reloadData];
        }else if (searcher == _searcher2) {
            BusStr = [[NSMutableString alloc] init];
            for (BMKPoiInfo * info in poiResultList.poiInfoList) {
                
                NSLog(@"公交---%@",info.name);
                [self.BusArr addObject:info.name];
                [BusStr appendFormat:@" %@ ,",info.name];
            }
            [table reloadData];
        }else{
            hospitalStr = [[NSMutableString alloc] init];
            for (BMKPoiInfo * info in poiResultList.poiInfoList) {
                
                NSLog(@"医院---%@",info.name);
                [self.hospitalArr addObject:info.name];
                [hospitalStr appendFormat:@" %@ ,",info.name];
            }
           [table reloadData];
        }
        
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
    
    //[self createView];
}

-(void)createView{
    

    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-30) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundColor = bgColor;
    [self.view addSubview:table];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0.01;
    }else{
        return 10;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
        {
            if (![BusStr isEqualToString:@""]) {
                if (indexPath.row%2 != 0) {
                    
                    NSString *contentText = BusStr;
                    CGSize contentSize = [Tools_F countingSize:contentText fontSize:15*1.1 width:viewWidth-40];
                    return contentSize.height+35;
                    //return 100;
                }else{
                    return 44;
                }
            }else{
            
                return 0;
            }
            
        }
            break;
        case 1:
        {
            if (![subwayStr isEqualToString:@""]) {
                
                if (indexPath.row%2 != 0) {
                    
                    NSString *contentText = subwayStr;
                    CGSize contentSize = [Tools_F countingSize:contentText fontSize:15*1.1 width:viewWidth-40];
                    return contentSize.height+35;
                    //return 100;
                }else{
                    return 44;
                }
            }else{
            
                return 0;
            }
            
        }
            break;
        case 2:
        {
            if (![schoolStr isEqualToString:@""]) {
                
                if (indexPath.row%2 != 0) {
                    
                    NSString *contentText = schoolStr;
                    CGSize contentSize = [Tools_F countingSize:contentText fontSize:15*1.1 width:viewWidth-40];
                    return contentSize.height+35;
                    //return 100;
                }else{
                    return 44;
                }
            }else{
            
                return 0;
            }
            
            
        }
            break;
            
        default:
        {
            if (![hospitalStr isEqualToString:@""]) {
                if (indexPath.row%2 != 0) {
                    
                    NSString *contentText = hospitalStr;
                    CGSize contentSize = [Tools_F countingSize:contentText fontSize:15*1.1 width:viewWidth-40];
                    return contentSize.height+35;
                    //return 100;
                }else{
                    return 44;
                }
            }else{
            
                return 0;
            }
            
        }
            break;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellID = @"cellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = titleFont_15;
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row%2 != 0) {
                
                cell.textLabel.text = BusStr;
                
            }else{
                
                cell.textLabel.text = @"公交";
            }
            
            
        }
            break;
        case 1:
        {
            if (indexPath.row%2 != 0) {
                
                cell.textLabel.text = subwayStr;
                
            }else{
                
                cell.textLabel.text = @"地铁";
            }
        }
            break;
        case 2:
        {
            if (indexPath.row%2 != 0) {
                
                cell.textLabel.text = schoolStr;
                
            }else{
                
                cell.textLabel.text = @"学校";
            }
        }
            break;
        default:
        {
            if (indexPath.row%2 != 0) {
                
                cell.textLabel.text = hospitalStr;
                
            }else{
                
                cell.textLabel.text = @"医院";
            }
        }
            break;
    }
    
    return cell;
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
