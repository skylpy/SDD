//
//  CPTowardsViewController.m
//  SDD
//
//  Created by mac on 15/5/13.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "CPTowardsViewController.h"

@interface CPTowardsViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *towardsList;

@end

@implementation CPTowardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.towardsList = @[@"南北通透",@"东西通透",@"东向",@"西向",@"南向",@"北向",@"东南向",@"东北向"];
    
    [self setupNaviBar];
    [self addTableView];
    
}

- (void)setupNaviBar{
    
    SDDButton *button = [[SDDButton alloc]init];
    button.frame = CGRectMake(0, 0, 40, 44);
    [button setTitle:@"" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

- (void)leftAction
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
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.towardsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"towardsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
       
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = self.towardsList[indexPath.row];
    
    return cell;


}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (_doTransferMeg) {
            _doTransferMeg(self.towardsList[indexPath.row],indexPath.row);
            _doTransferMeg = nil;
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        if (_doTransferMeg) {
            _doTransferMeg(self.towardsList[indexPath.row],indexPath.row);
            _doTransferMeg = nil;
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
