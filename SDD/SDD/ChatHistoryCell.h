//
//  ChatHistoryCell.h
//  SDD
//  我的历史聊天记录
//  Created by Cola on 15/4/12.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatHistoryCell : UITableViewCell
@property (nonatomic, strong) UIImageView *imageFace;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *userChat;
@property (nonatomic, strong) UILabel *postTime;
@property (nonatomic, assign) NSInteger unreadCount;

@end
