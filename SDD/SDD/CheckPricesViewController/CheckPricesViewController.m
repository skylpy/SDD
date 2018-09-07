//
//  CheckPricesViewController.m
//  SDD
//
//  Created by mac on 15/5/12.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "CheckPricesViewController.h"
#import "CPProjectViewController.h"
#import "CPTowardsViewController.h"
#import "CheckPricesResultsViewController.h"
#import "ProgressHUD.h"

@interface CheckPricesViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *_tableView;
    UITextField *_textField; //平方米  户型面积
    UILabel *_towardsLabel;  //朝向
    UILabel *_houseLabel;    //项目名称
}

@property (nonatomic, strong) NSArray *arrayList;
@property (nonatomic, assign) NSInteger houseID;
@property (nonatomic, assign) NSInteger towardsID;

@end

@implementation CheckPricesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrayList = @[@"项目名称:",@"户型面积:",@"项目朝向:"];
        
    [self addTableView];
    
    [self setupNaviBar];
}

- (void)setupNaviBar{
    
    SDDButton *button = [[SDDButton alloc]init];
    button.frame = CGRectMake(0, 0, 150, 44);
    [button setTitle:@"快速查房价" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftBackAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

- (void)leftBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    tableView.backgroundColor = [SDDColor sddbackgroundColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    tableView.tableFooterView = [[UIView alloc]init];
    tableView.scrollEnabled = NO; // 设置tableview 不能滚动
    
    UIButton *footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    footerButton.frame = CGRectMake(0, self.view.frame.size.height-64-44, self.view.frame.size.width, 44);
    [footerButton setTitle:@"查房价" forState:UIControlStateNormal];
    [footerButton setTintColor:[UIColor whiteColor]];
    [footerButton setBackgroundColor:[SDDColor sddRedColor]];
    [footerButton addTarget:self action:@selector(checkAction) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:footerButton];
}

- (void)checkAction
{
    
//    NSLog(@" %@  %ld  %ld" ,_textField.text,_houseID , _towardsID);
    if (_textField.text.length == 0 || _houseID == 0 || _towardsID+1 == 0) {
        
        [ProgressHUD showSuccess:@"请输入完整查询信息"];
    }
    else{
        
        CheckPricesResultsViewController *cprVC = [[CheckPricesResultsViewController alloc]init];
        [cprVC saveWithHouseName:_houseLabel.text HouseID:_houseID Area:_textField.text.integerValue TowardsID:_towardsID+1];
        [self.navigationController pushViewController:cprVC animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.row == 0){
        cell.textLabel.text = self.arrayList[0];
        
        UILabel *houseLabel = [[UILabel alloc]init];
        houseLabel.text = @"";
        houseLabel.frame = CGRectMake(150, 0, self.view.frame.size.width-160, 44);
        houseLabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:houseLabel];
        _houseLabel = houseLabel;
    }
    else if (indexPath.row == 1){
        UITableViewCell *cell2 = [[UITableViewCell alloc]init];
        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(10, 0, 80, 44);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = self.arrayList[1];
        [cell2.contentView addSubview:label];
        
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 0, self.view.frame.size.width - 120, 44)];
        textField.textAlignment = NSTextAlignmentRight;
        textField.delegate = self;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        
        [cell2.contentView addSubview:textField];
        _textField = textField;
        
        UILabel *labelM = [[UILabel alloc]init];
        labelM.frame = CGRectMake(CGRectGetMaxX(textField.frame), 0, 20, 44);
        labelM.textAlignment = NSTextAlignmentCenter;
        labelM.text = @"㎡";
        [cell2.contentView addSubview:labelM];

        
        return cell2;
    }
    else if (indexPath.row == 2){
        UITableViewCell *cell3 = [[UITableViewCell alloc]init];
        cell3.selectionStyle = UITableViewCellSelectionStyleNone;
        cell3.textLabel.text = self.arrayList[2];
        
        UILabel *towardsLabel = [[UILabel alloc]init];
        towardsLabel.text = @"";
        towardsLabel.frame = CGRectMake(150, 0, self.view.frame.size.width-160, 44);
        towardsLabel.textAlignment = NSTextAlignmentRight;
        [cell3.contentView addSubview:towardsLabel];
        _towardsLabel = towardsLabel;
        
        return cell3;
    }
    else{
//        UITableViewCell *cell4 = [[UITableViewCell alloc]init];
//        cell4.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell4.textLabel.text = self.arrayList[3];
//        
//        
//        return cell4;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            CPProjectViewController *cppView = [[CPProjectViewController alloc]init];
            
            [cppView setDoTransferHouseName:^(NSString *_houseName, NSString *_houseId) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (indexPath.row == 0) {
                        _houseLabel.text = _houseName;
                        self.houseID = _houseId.integerValue;
                    }
                    [_tableView reloadData];
                });
            }];
            
            
            [self.navigationController pushViewController:cppView animated:YES];
        }
            break;
        case 1:
        {
        
        }
            break;
        case 2:
        {
            CPTowardsViewController *towards = [[CPTowardsViewController alloc]init];
            
            [towards setDoTransferMeg:^(NSString *_msg,NSInteger _towardsId) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (indexPath.row == 2) {
                        _towardsLabel.text = _msg;
                        _towardsID = _towardsId;
                    }
                    [_tableView reloadData];
                    
                });
            }];
            
            [self.navigationController pushViewController:towards animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_textField resignFirstResponder];
    return YES;
}


@end
