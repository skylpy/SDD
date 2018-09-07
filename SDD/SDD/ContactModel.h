//
//  ContactModel.h
//  SDD
//  联系方式
//  Created by hua on 15/6/25.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactModel : NSObject


// 名
@property (nonatomic, strong) NSString *peopleName;
// 职位
@property (nonatomic, strong) NSString *peoplePosition;
// 地方
@property (nonatomic, strong) NSString *peopleRegion;
// 固话
@property (nonatomic, strong) NSString *peopleTel;
// 手机号
@property (nonatomic, strong) NSString *peopleMobileNum;
// 邮箱
@property (nonatomic, strong) NSString *peopleEmail;
// 地址
@property (nonatomic, strong) NSString *peopleAddress;

+ (instancetype)contactWithDict:(NSDictionary *)dict;

@end
