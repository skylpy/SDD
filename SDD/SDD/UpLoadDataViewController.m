//
//  UpLoadDataViewController.m
//  SDD
//
//  Created by mac on 15/9/23.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "UpLoadDataViewController.h"
#import "SDD_Preview.h"
#import "DevCerCell.h"
#import "SDD_BasicCell.h"
#import "SDD_DoubleImageViewCell.h"
#import "SDD_SaveIssueCell.h"
#import "SDD_MoreInfomation.h"

@interface UpLoadDataViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>
{
    UIButton * ImageBtn;//第一个按钮
    
    NSString * licenseImageStr; //营业执照
    NSString * figureImageStr; //公司形象
    int imageNumber;
    
    NSArray * nameArr; //名称
    NSArray * explainArr; //说明
    
    UIButton *checkButton;//验证按钮
    
    NSTimer * timer;
    int allTime;
}
@property (retain,nonatomic)UITableView * tableView;
@property (retain,nonatomic)NSMutableArray * FirstGroupArray;

@property (retain,nonatomic)NSMutableArray * SecondGroupArray;
@property (retain,nonatomic)NSMutableArray * ThirdGroupArray;

@property (retain,nonatomic)NSMutableArray * TotalArray;//更多界面回传


@end

@implementation UpLoadDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgColor;
    [self setUpNvc];
    [self createView];
    [self initData];
    [self getTime];
}
#pragma mark -- 初始化数据
-(void)initData
{
    nameArr = @[@"联系人：",@"部门：",@"职务：",@"手机号：",@"验证码：",@"更多项目信息"];
    
    explainArr = @[@"请输入公联系人姓名",@"请输入所在部门",@"请选择职务",@"请输入手机号码",@"请输入验证码"];
    
    
    
    
    licenseImageStr = @"";
    figureImageStr = @"";
    
    allTime = 60;
}
#pragma mark -- 主界面
-(void)createView
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = bgColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    checkButton = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth-100, 16,80, 13)];
    [checkButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    checkButton.titleLabel.font = [UIFont systemFontOfSize:12];
    checkButton.tag = 1500;
    [checkButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [checkButton addTarget:self action:@selector(checkClick) forControlEvents:UIControlEventTouchUpInside];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _tableView) {
        return 10;
    }
    else
    {
        return 0.01;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        
        switch (indexPath.section) {
            case 0:
                return 45;
                break;
            case 1:
                return 135;
                break;
            case 5:
                return 80;
                break;
            default:
                return 44;
                break;
        }
    }
    else
    {
        return 44;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _tableView)
    {
        return 6;
    }
    else
    {
        return 1;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tableView)
    {
        switch (section) {
            case 2:
                return 3;
                break;
            case 3:
                return 2;
                break;
            default:
                return 1;
                break;
        }
    }
    else
    {
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView)
    {
        switch (indexPath.section) {
            case 0:
            {
                SDD_BasicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
                if (!cell) {
                    cell = [[SDD_BasicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                for (int i=0; i<3; i++) {
                    UIButton *button = (UIButton *)[cell viewWithTag:40+i];
                    [button setTitleColor:dblueColor forState:UIControlStateNormal];
                    
                }
                return cell;
            }
                break;
            case 1:
            {
                SDD_DoubleImageViewCell *cellBtn = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
                if (!cellBtn) {
                    cellBtn = [[SDD_DoubleImageViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
                }
                cellBtn.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *lableF = (UILabel*)[cellBtn viewWithTag:333];
                UILabel *lableS = (UILabel*)[cellBtn viewWithTag:334];
                lableF.text = @"上传整体效果图";
                lableS.text = @"上传营销中心图";
                for (int i = 0; i<2; i++) {
                    UIButton *button = (UIButton*)[cellBtn viewWithTag:222+i];
                    [button addTarget:self action:@selector(upDataClick:) forControlEvents:UIControlEventTouchUpInside];
                    button.tag = 1000+i;
                }
                //CELLSELECTSTYLE
                return cellBtn;
            }
                break;
            default:
            {
                static NSString * cellID = @"cellID";
                DevCerCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
                if (!cell) {
                    cell = [[DevCerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                [cell.textField mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(cell.mas_top).with.offset(8);
                    make.left.equalTo(cell.nameLable.mas_right).with.offset(5);
                    make.bottom.equalTo(cell.mas_bottom).with.offset(-8);
                    make.width.equalTo(@200);
                }];
                switch (indexPath.section) {
                    case 2:
                    {
                        cell.nameLable.text = nameArr[indexPath.row];
                        cell.textField.placeholder = explainArr[indexPath.row];
                        cell.chooseLable.hidden = YES;
                    }
                        break;
                    case 3:
                    {
                        cell.nameLable.text = nameArr[indexPath.row+3];
                        cell.textField.placeholder = explainArr[indexPath.row+3];
                        cell.chooseLable.hidden = YES;
                        if (indexPath.row == 1) {
                            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth-120, 10, 1, 25)];
                            line.backgroundColor = [SDDColor colorWithHexString:@"#e5e5e5"];
                            [cell addSubview:line];
                            
                            [cell addSubview:checkButton];
                        }
                        
                        
                    }
                        break;
                    case 4:
                    {
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        cell.nameLable.text = nameArr[indexPath.row+5];
                        cell.chooseLable.text = @"选填";
                        cell.starLable.hidden = YES;
                        cell.textField.hidden = YES;
                    }
                        break;
                    default:
                    {
                        SDD_SaveIssueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell5"];
                        if (!cell) {
                            cell = [[SDD_SaveIssueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell5"];
                        }
                        for (int i=0; i<2; i++) {
                            UIButton *button = (UIButton*)[cell viewWithTag:333+i];
                            [button addTarget:self action:@selector(savaAndIssueClick:) forControlEvents:UIControlEventTouchUpInside];
                        }
                        cell.backgroundColor = [UIColor clearColor];
                        
                        return cell;
                    }
                        break;
                }
                return cell;
            }
                break;
        }
        
        
        
    }
    else
    {
        static NSString * cellID = @"cellID";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 4:
        {
            SDD_MoreInfomation *moreInfoVC = [[SDD_MoreInfomation alloc] init];
            moreInfoVC.BasicArray = _BasicArray;//第一个界面
            moreInfoVC.DetailsArray  = _DetailsArray;//第二个界面
            moreInfoVC.UploadDataArray = _FirstGroupArray;//上传界面上数组
            [self.navigationController pushViewController:moreInfoVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}


//#pragma mark----保存
//- (void)savaAndIssueClick:(UIButton *)sender
//{
//    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"大人!填写“更多新项目信息”更利于通过审核哦!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"继续填写",@"我要发布", nil];
//    switch (sender.tag) {
//        case 333:
//        {
//            
//            
//            
//#pragma mark -- 第一个界面传过来的数组
//            NSString * ProjectNameStr = _BasicArray[0];//项目名称
//            NSString * developersName = _BasicArray[1];//开发商
//            NSString * ProjectAddress = _BasicArray[2];//项目地址
//            NSString * ProjectIntroduction = _BasicArray[3];//项目简介
//            NSString * Cooperation = _BasicArray[4];//合作方式
//            
//#pragma mark -- 第二个界面传过来的数组
//            //第一组
//            NSArray * FirArray = _DetailsArray[0];
//            NSString * ReferAverage = FirArray[0];//参考均价
//            NSString * ReferRent = FirArray[1];//参考租金
//            NSString * MerchantsStateNode = FirArray[2];//招商状态节点
//            
//            //第二组
//            NSArray * SecArray = _DetailsArray[1];
//            NSString * OpenedTime = SecArray[0];//开盘时间
//            NSString * OpeningTime = SecArray[1];//开业时间
//            
//            int OpenedTime1 = [[self TimestampConversion:OpeningTime] intValue];
//            int OpeningTime1 = [[self TimestampConversion:OpenedTime] intValue];
//            
//            NSLog(@"%d -- %d",OpenedTime1,OpeningTime1);
//            
//            //第三组
//            NSArray * ThiArray = _DetailsArray[2];
//            NSString * PlanningArea = ThiArray[0];//规划面积
//            NSString * BuildArea = ThiArray[1];//建设面积
//            
//            //第四组
//            NSArray * fouArray = _DetailsArray[3];
//            NSString * PlanningForms = fouArray[0];//规划业态
//            NSString * ProjectType = fouArray[1];//项目类型
//            
//#pragma mark -- 第三个界面//= =
//            NSString * OverallEffectImage =_FirstGroupArray[0];//整体效果图
//            NSString * MarketingCenterImage=_FirstGroupArray[1] ;//营销中心图
//            
//            NSString * Contact = _SecondGroupArray[0];//联系人
//            NSString * Department = _SecondGroupArray[1];//部门
//            NSString * Position = _SecondGroupArray[2];//职务
//            
//            NSString * phoneStr = _ThirdGroupArray[0];//手机号码
//            NSString * codeStr = _ThirdGroupArray[1];//验证码
//            
//#pragma amrk -- 更多界面的
//            int buildingStartTime1 = 0;
//            NSString * businessComment = @"";
//            NSString * surroundingCompetingProducts = @"";
//            NSString * publicRoundRate = @"";
//            NSString * greeningRate = @"";
//            NSString * volumeRate = @"";
//            NSString * propertyAge = @"";
//            NSString * groundParkingSpaces = @"";
//            NSString * undergroundParkingSpaces = @"";
//            
//            if (_TotalArray.count>0) {
//                NSArray * buiArray = _TotalArray[0];
//                NSString * buildingStartTime = buiArray[1];
//                buildingStartTime1 = [[self TimestampConversion:buildingStartTime] intValue];//开工时间
//                
//                NSArray * ComArray = _TotalArray[3];
//                businessComment = ComArray[2];
//                surroundingCompetingProducts = ComArray[0];
//                
//                NSArray * rateArray = _TotalArray[1];
//                publicRoundRate = [NSString stringWithFormat:@"%@",rateArray[0]];
//                greeningRate = [NSString stringWithFormat:@"%@",rateArray[1]];
//                volumeRate = [NSString stringWithFormat:@"%@",rateArray[2]];
//                
//                NSArray * numArray = _TotalArray[2];
//                propertyAge = [NSString stringWithFormat:@"%@",numArray[0]];
//                groundParkingSpaces = [NSString stringWithFormat:@"%@",numArray[1]];
//                undergroundParkingSpaces = [NSString stringWithFormat:@"%@",numArray[2]];
//            }
//            
//            NSDictionary * dict;
//            if ([OverallEffectImage isEqualToString:@""]|[MarketingCenterImage isEqualToString:@""]|[Contact isEqualToString:@""]|[Department isEqualToString:@""]|[Position isEqualToString:@""]|[phoneStr isEqualToString:@""]|[codeStr isEqualToString:@""])
//            {
//                [self showAlert:@"请把信息填写完整"];
//            }
//            else
//            {
//                dict =@{
//                        @"activityCategoryIds":@[@1],
//                        @"address":ProjectAddress,
//                        @"buildingArea":@([BuildArea intValue]),
//                        @"buildingStartTime":@(buildingStartTime1),
//                        @"businessComment":businessComment,
//                        @"code":codeStr,
//                        @"contacts":Contact,
//                        @"defaultImage":OverallEffectImage,
//                        @"department":Department,
//                        @"developersId":@1,
//                        @"developersName":developersName,
//                        @"formatAreas":@[@{@"areaCategoryId":@3,@"industryCategoryId":@2},@{@"areaCategoryId":@2,@"industryCategoryId":@1}],
//                        
//                        @"greeningRate":greeningRate,
//                        @"groundParkingSpaces":groundParkingSpaces,
//                        @"houseDescription":ProjectIntroduction,
//                        @"houseFirstId":@0,
//                        @"houseName":ProjectNameStr,
//                        @"industryCategoryId":@"",
//                        @"industryCategoryIds":@[@4,@5],
//                        @"investmentPolicy":@"招商政策",
//                        @"mainStoreCategoryId":@1,
//                        @"merchantsState":MerchantsStateNode,
//                        @"merchantsStatus":@1,
//                        @"openedTime":@(OpenedTime1),
//                        @"openingTime":@(OpeningTime1),
//                        @"phone":phoneStr,
//                        @"planArea":@([PlanningArea intValue]),
//                        @"planFormat":PlanningForms,
//                        @"postCategoryId":@2,
//                        @"price":@([ReferAverage intValue]),
//                        @"projectCircleCategoryId":@1,
//                        @"projectNatureCategoryId":@1,
//                        @"properties":@100,
//                        @"propertyAge":propertyAge,
//                        @"publicRoundRate":publicRoundRate,
//                        @"realMapImage":MarketingCenterImage,
//                        @"rentPrice":@([ReferRent intValue]),
//                        @"surroundingCompetingProducts":surroundingCompetingProducts,
//                        @"teamDescription":@"运营团队描述",
//                        @"typeCategoryId":@1,
//                        @"undergroundParkingSpaces":undergroundParkingSpaces,
//                        @"volumeRate":volumeRate
//                        };
//                
//            }
//            
//            [HttpRequest postWithNewIssueSavaURL:SDD_MainURL path:@"/houseFirst/saveOnly.do" parameter:dict success:^(id Josn) {
//                NSLog(@"%@",Josn);
//                if ([[Josn objectForKey:@"status"] integerValue] == 1) {
//                    houseFirstId = [Josn[@"data"][@"houseFirstId"] integerValue];
//                    NSLog(@"%ld",houseFirstId);
//                }
//                [self showAlert:[Josn objectForKey:@"message"]];
//                
//            } failure:^(NSError *error) {
//                NSLog(@"%@",error);
//            }];
//        }
//            break;
//        case 334:
//            [alter show];
//            break;
//        default:
//            break;
//    }
//}

#pragma mark -- 获取当前时间
-(NSString *)TimestampConversion:(NSString *)Times
{
    NSString* timeStr = Times;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    NSDate* date = [formatter dateFromString:timeStr];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    
    NSLog(@"timeSp:%@",timeSp);
    return timeSp;
}

#pragma mark----获取验证
- (void)checkClick
{
    NSLog(@"获取验证");
    [timer setFireDate:[NSDate distantPast]];
    [self requestPhoneData];
}
#pragma mark -- 获取验证码数据下载
-(void)requestPhoneData
{
    
    [HttpTool postWithBaseURL:SDD_MainURL Path:@"/sms/user/saveHouseCode.do" params:@{@"phone":@"18042843895"} success:^(id JSON) {
        
        NSLog(@"%@",JSON);
        if ([[NSString stringWithFormat:@"%@",JSON[@"status"]] intValue]==1) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"短信已发送，请在10分钟内输入"
                                                           delegate:self
                                                  cancelButtonTitle:@"好"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:JSON[@"message"]
                                                           delegate:self
                                                  cancelButtonTitle:@"好"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)getTime
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getTimeclick) userInfo:nil repeats:YES];
    [timer setFireDate:[NSDate distantFuture]];
}
-(void)getTimeclick
{
    //NSLog(@"%@",timer);
    allTime --;
    
    if (allTime ==59||allTime == 58) {
        [checkButton setTitle:@"" forState:UIControlStateNormal];
    }
    
    [checkButton setTitle:[NSString stringWithFormat:@"还剩(%d)",allTime] forState:UIControlStateNormal];
    [checkButton setTintColor:[UIColor grayColor]];
    
    
    if (allTime == 0) {
        [checkButton setTitle:@"重新获取(59)" forState:UIControlStateNormal];
        allTime = 60;
        [timer setFireDate:[NSDate distantFuture]];
    }
    
}



#pragma mark---点击上传
- (void)upDataClick:(UIButton*)sender
{
    
    SDD_DoubleImageViewCell *cell = (SDD_DoubleImageViewCell *)sender.superview;
    ImageBtn = (UIButton *)[cell viewWithTag:sender.tag];
    
    
    UIActionSheet *shotOrAlbums = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册中选择", nil];
    [shotOrAlbums showInView:self.view];
    switch (sender.tag) {
        case 1000:
            imageNumber = 0;
            break;
        case 1001:
            imageNumber = 1;
            break;
        default:
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"拍照");
            [self pickImageFromCamera];
        }
            break;
        case 1:
        {
            NSLog(@"相册选择");
            [self pickImageFromAlbum];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 从用户相册获取活动图片
- (void)pickImageFromAlbum{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - 调用摄像机
- (void)pickImageFromCamera{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - 当用户取消选取时调用；
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 当用户选取完成后调用；
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //初始化imageNew为从相机中获得的--
    UIImage *imageNew = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        
        UIImageWriteToSavedPhotosAlbum(imageNew, nil, nil, nil);
    }
    
    [self showLoading:0];
    [HttpTool uploadWithBaseURL:SDD_MainURL Path:@"/upload/images.do" params:nil dataName:@"images" AlbumImage:imageNew success:^(id responseObject) {
        
        [self hideLoading];
        NSDictionary *dict = responseObject;
        NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
        if (![dict[@"data"] isEqual:[NSNull null]]) {
            
            // 0:身份证url 1:名片url 2:营业执照url 3:品牌LOGOurl
            [ImageBtn setBackgroundImage:imageNew forState:UIControlStateNormal];
            
            [self showSuccessWithText:dict[@"message"]];
            switch (imageNumber) {
                case 0:
                    licenseImageStr = dict[@"data"][0];
                    break;
                case 1:
                    figureImageStr = dict[@"data"][0];
                    break;
                default:
                    
                    
                    break;
            }
            NSLog(@"licenseImageStr-->%@  , figureImageStr--->%@",licenseImageStr,figureImageStr);
        }
        
    } fail:^{
        
        [self showErrorWithText:@"上传失败"];
    }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)setUpNvc
{
    SDDButton *button = [[SDDButton alloc]init];
    [button sizeToFit];
    [button addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"项目发布";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = biggestFont;
    [titleLabel sizeToFit];
    self.navigationItem.titleView = titleLabel;
    
    UIButton *commit = [[UIButton alloc] init];
    commit.frame = CGRectMake(0, 0, 40, 44);
    commit.titleLabel.font = largeFont;
    [commit setTitle:@"预览" forState:UIControlStateNormal];
    [commit addTarget:self action:@selector(lookClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:commit];
}

- (void)lookClick
{
    //PREVIEW
    SDD_Preview *preview = [[SDD_Preview alloc] init];
    preview.BasicArray = _BasicArray;
    preview.DetailsArray = _DetailsArray;
    //preview.MorePagesArray = _TotalArray;
    
    //preview.UploadDataArray = _FirstGroupArray;
    NSLog(@"%@",preview.UploadDataArray);
    [self.navigationController pushViewController:preview animated:YES];
}

- (void)leftButtonClick:(UIButton*)sender
{
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
