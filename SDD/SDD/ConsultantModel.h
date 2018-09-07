//
//  ConsultantModel.h
//  SDD
//
//  Created by hua on 15/4/24.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConsultantModel : NSObject


/*- 顾问列表 -*/

// 头像
@property (nonatomic, strong) NSString *c_icon;
// 电话
@property (nonatomic, strong) NSString *c_phone;
// 姓名
@property (nonatomic, strong) NSString *c_realName;
// 用户ID
@property (nonatomic, strong) NSString *c_userId;
// 好评率
@property (nonatomic, strong) NSString *c_goodCommentRate;

/*- 顾问信息 -*/

// 平均分
@property (nonatomic, strong) NSString *c_avgScore;
// 评论列表
@property (nonatomic, strong) NSArray *c_commentList;
// 顾问ID
@property (nonatomic, strong) NSString *c_consultantUserId;
// 好评数
@property (nonatomic, strong) NSString *c_goodCommentQty;
// 中评数
@property (nonatomic, strong) NSString *c_middleCommentQty;
// 中评率
@property (nonatomic, strong) NSString *c_middleCommentRate;
// 差评数
@property (nonatomic, strong) NSString *c_poorCommentQty;
// 差评率
@property (nonatomic, strong) NSString *c_poorCoommentRate;
// 个性签名
@property (nonatomic, strong) NSString *c_signature;
// 总评数
@property (nonatomic, strong) NSString *c_totalCommentQty;

@end
