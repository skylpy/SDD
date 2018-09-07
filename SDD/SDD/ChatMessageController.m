//
//  ChatMessage.m
//  SDD
//
//  Created by Cola on 15/4/12.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import "ChatMessageController.h"
#import "ChatHistoryCell.h"

#import "ChatViewController.h"

#import "NSDate+Category.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "UIImageView+WebCache.h"
#import "ChatListCell.h"


@interface ChatMessageController()<UITableViewDataSource,UITableViewDelegate,IChatManagerDelegate>{
    
    /*- ui-*/
    UITableView *table;
    
    /*- data -*/
    NSArray *dataSource;
}

@property (nonatomic, strong) NSMutableArray *otherAvatars;

@end

@implementation ChatMessageController

- (NSMutableArray *)otherAvatars{
    if (!_otherAvatars) {
        _otherAvatars = [[NSMutableArray alloc]init];
    }
    return _otherAvatars;
}

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

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav:NSLocalizedString(@"myMsg", @"")];
    // 读取未读消息和监听未读消息通知
    [self registerNotifications];
    [self refreshDataSource];
    // 设置内容
    [self setupUI];
}

- (void)refreshDataSource{
    
    dataSource = [self loadDataSource];
    // 获取头像
    [self getAvatars];
    [table reloadData];
}

#pragma mark - 获取对方头像
- (void)getAvatars{
    
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    NSLog(@"dataSource %@",dataSource);

    for (EMConversation *conversation in dataSource) {
        
        NSString *userName = conversation.chatter;
        NSLog(@"userName %@",userName);
        [tempArr addObject:userName];
    }
    
    if (tempArr.count > 0) {
        
        NSDictionary *param = @{@"userIds":tempArr};
        NSString *urlString = [SDD_MainURL stringByAppendingString:@"/user/getCharUserInfos.do"];              // 拼接主路径和请求内容成完整url
        [self sendRequest:param url:urlString];
    }
    else {
        NSLog(@"没有消息");
    }
}

- (void)onSuccess:(AFHTTPRequestOperation *)operation context:(id)responseObject{
    
    NSDictionary *dict = responseObject;
    NSLog(@"%@>>>>>>>%@",dict[@"message"],dict);
    
    [_otherAvatars removeAllObjects];
    if (![dict[@"data"] isEqual:[NSNull null]]) {
        
        for (NSDictionary *tempDic in dict[@"data"]) {
            
            [self.otherAvatars addObject:tempDic];
        }
        
        [table reloadData];
    }
}

#pragma mark - 设置内容
- (void)setupUI{
    
    // 内容
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-64) style:UITableViewStyleGrouped];
    table.backgroundColor = bgColor;
    table.delegate = self;
    table.dataSource = self;
    
    [self.view addSubview:table];
}

#pragma mark - private
-(void)registerNotifications
{
    [self unregisterNotifications];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    //    [[EMSDKFull sharedInstance].callManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    //    [[EMSDKFull sharedInstance].callManager removeDelegate:self];
}

-(void)didUnreadMessagesCountChanged{
    
    NSLog(@"有新消息");
    // 得到未读消息时刷新数据源
    [self refreshDataSource];
}

#pragma mark -
#pragma mark UITableView Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

#pragma mark -
#pragma mark UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSource count] > 1? 1:[dataSource count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - 设置section 头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 1;
}

#pragma mark - 设置section 脚高
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //重用标识符
    static NSString *identifier = @"CELLMARK";
    //重用机制
    ChatHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];      //带标识符的出列
    
    if(cell == nil){
        //当不存在的时候用重用标识符生成
        cell = [[ChatHistoryCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        // 设置选中背景色不变
    }
    
    EMConversation *conversation = dataSource[indexPath.row];
    
    cell.backgroundColor = lgrayColor;
    // 预览消息
    cell.userChat.text = [self subTitleMessageByConversation:conversation];
    // 时间
    cell.postTime.text = [self lastMessageTimeByConversation:conversation];
    cell.postTime.frame = CGRectMake(viewWidth - 10 - (cell.postTime.text.length * cell.postTime.font.pointSize), 10, cell.postTime.text.length * cell.postTime.font.pointSize, cell.postTime.font.lineHeight);
    cell.postTime.textAlignment = NSTextAlignmentRight;
    
    if ([_otherAvatars count] == [dataSource count]) {
        // 用户名+头像
        cell.userName.text = _otherAvatars[indexPath.row][@"chatName"];
        [cell.imageFace sd_setImageWithURL:[NSURL URLWithString:_otherAvatars[indexPath.row][@"icon"]]];
    }
    // 未读消息
    cell.unreadCount = conversation.unreadMessagesCount;
    NSLog(@"%ld",conversation.unreadMessagesCount);
    return cell;
}



#pragma mark - 点击cell进入详细页面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EMConversation *conversation = dataSource[indexPath.row];
    
    ChatViewController *cvc = [[ChatViewController alloc] initWithChatter:conversation.chatter isGroup:FALSE];
    
    cvc.userName = _otherAvatars[indexPath.row][@"chatName"];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cvc animated:true];
}

// 得到最后消息文字或者类型
-(NSString *)subTitleMessageByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Image:{
                ret = NSLocalizedString(@"message.image1", @"[image]");
            } break;
            case eMessageBodyType_Text:{
                // 表情映射。
                NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                ret = didReceiveText;
            } break;
            case eMessageBodyType_Voice:{
                ret = NSLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case eMessageBodyType_Location: {
                ret = NSLocalizedString(@"message.location1", @"[location]");
            } break;
            case eMessageBodyType_Video: {
                ret = NSLocalizedString(@"message.vidio1", @"[vidio]");
            } break;
            default: {
            } break;
        }
    }
    
    return ret;
}

// 得到最后消息时间
-(NSString *)lastMessageTimeByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];;
    if (lastMessage) {
        ret = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    
    return ret;
}

@end
