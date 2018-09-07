//
//  CommonToolController.m
//  SDD
//
//  Created by Cola on 15/4/12.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "CommonToolController.h"
#import "HouseToolsHeader.h"

#import "FeedbackViewController.h"
#import "HelpViewController.h"
#import "AboutViewController.h"
#import "StatementViewController.h"
#import "JoinUsViewController.h"

#import "SDImageTool.h"
#import "ProgressHUD.h"

@interface CommonToolController()<UIAlertViewDelegate>{
    
    NSMutableArray *tableContent;
    
    NSTimer *_timer;
}

@end

@implementation CommonToolController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.viewForBaselineLayout.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTableContent];
    [self setNav:@"设置"];
}

- (void)setTableContent {
    
    tableContent = [[NSMutableArray alloc] initWithArray:@[
                                                           @[
                                                               @{@"title": @"清理缓存",
                                                                 @"icon": @"set_clean"}
                                                               ],
                                                           @[
                                                               @{@"title": @"使用帮助",
                                                                 @"icon": @"set_help"},
                                                               
                                                               @{@"title": @"免责声明",
                                                                 @"icon": @"set_state"},
                                                               @{@"title": @"关于我们",
                                                                
                                                                 @"icon": @"set_league"}
                                                               ]

                                                           
                                                           ]];//
//    @{@"title": @"用户反馈",
//      @"icon": @"set_tickling@2x"},
//    @"icon": @"set_about@2x"},
//],
//@[
//@{@"title": @"加入我们",
//@"icon": @"set_league@2x"},
//@{@"title": @"加盟商多多",
}

#pragma mark - UITableView DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = midFont;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
    }
    cell.textLabel.text = tableContent[indexPath.section][indexPath.row][@"title"];
    cell.imageView.image = [UIImage imageNamed:tableContent[indexPath.section][indexPath.row][@"icon"]];
    
    return cell;
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45;
}

#pragma mark - 设置行数 (tableView)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [tableContent[section] count];
}

#pragma mark - 设置Sections数 (tableView)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [tableContent count];
}

#pragma mark - 设置section 头高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

#pragma mark - 设置section 脚高 (tableView)
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIViewController *viewController;
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否清理缓存" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [alert show];
                }
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    HelpViewController *helpVC = [[HelpViewController alloc] init];
                    viewController = helpVC;
                }
                    break;

                case 1:
                {
                    StatementViewController *statementVC = [[StatementViewController alloc] init];
                    viewController = statementVC;
                }
                    break;
                case 2:
                {
                    AboutViewController *aboutVC = [[AboutViewController alloc] init];
                    viewController = aboutVC;
                }
                    break;
            }
        }
            break;
        case 2:
        {
            switch (indexPath.row) {

                    break;
                case 0:
                {
                    NSLog(@"去评价");
                    
                }
                    break;
            }
        }
    }
    if (viewController) {
        [self.navigationController pushViewController:viewController animated:YES];
    }
}



#pragma mark - AlertView代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [SDImageTool clear];
    [self showLoading:0];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(cleanCache) userInfo:nil repeats:YES];
    
}

- (void)cleanCache{
    
    [_timer invalidate];
    _timer = nil;
    
    [self showSuccessWithText:@"清理完成"];
}


@end
