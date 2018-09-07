//
//  BrankAuthenticationViewController.h
//  SDD
//  品牌商认证
//  Created by hua on 15/7/1.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrankAuthenticationViewController : XHBaseViewController

@property (retain,nonatomic)NSString *brankNameTFStr;                        // 品牌名称

@property (retain,nonatomic)NSString *companyNameTFStr;                      // 企业名称

@property (retain,nonatomic)NSString *brankPrincipalTFStr;                   // 品牌负责人

@property (retain,nonatomic)NSString *jobTFStr;                              // 职务

@property (retain,nonatomic)NSString *phoneTFStr;                            // 手机号码

@property (retain,nonatomic)NSString *storeQTYTFStr;                         // 门店数量

@property (retain,nonatomic)NSString *companyAgeTFStr;                       // 企业年限

@property (retain,nonatomic)NSString *brankIntroduceTFStr;                   // 品牌介绍





@property (assign,nonatomic)NSInteger industryCategoryId;

@property (assign,nonatomic)NSInteger industryCategoryId2;

@property (retain,nonatomic)NSString *idCardImage;                          // 身份证url

@property (retain,nonatomic)NSString *businessLicenseImage;                 // 名片url

@property (retain,nonatomic)NSString *businessCardImage;                    // 营业执照url

@property (retain,nonatomic)NSString *brandLogoImage;                       // 品牌LOGOurl

@property (assign,nonatomic)NSInteger imgType;                              // 0:身份证url 1:名片url 2:营业执照url 3:品牌LOGOurl

@end
