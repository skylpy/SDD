//
//  PersentViewController.m
//  ShopMoreAndMore
//  合作方式
//  Created by mac on 15/7/3.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "PersentViewController.h"

@interface PersentViewController ()

@end

@implementation PersentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITableView *tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-135, 320, 135) style:UITableViewStylePlain];
    tabelView.delegate = self;
    tabelView.dataSource = self;
    [tabelView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tabelView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSArray *arr = [NSArray arrayWithObjects:@"新项目团租合租",@"新项目团购合作",@"新项目发布合作", nil];
    cell.textLabel.text = arr[indexPath.row];
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
