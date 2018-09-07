//
//  Tools_F.h
//  商多多
//
//  Created by hua on 15/4/9.
//  Copyright (c) 2015年 jofly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

#import "HttpTool.h"
#import "SDImageTool.h"
#import "SDDColor.h"
#import "SDDButton.h"
#import "ConfirmButton.h"
#import "SDDUITextField.h"

@interface Tools_F : NSObject

/**
 *  获取未来某个日期是星期几
 *  注意：featureDate 传递过来的格式 必须 和 formatter.dateFormat 一致，否则endDate可能为nil
 *
 */
- (NSString *)featureWeekdayWithDate:(NSString *)featureDate;

// 设置边框&圆角
+ (void)setViewlayer:(UIView *)view cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

// MD5加密
+ (NSString *)Newmd5:(NSString *)inPutText;

// 时间戳解析
typedef NS_ENUM(NSInteger, TimeLevel){
    
    years = 0,
    months = 1,
    days = 2,
    hours = 3,
    minutes = 4,
    seconds = 5,
    dayszw = 6
};

+ (NSString *)timeTransform:(int)time time:(TimeLevel)timeLevel;

// date转时间戳
//+ (NSInteger)timeTransformTimestamp:(NSDate *)date;
/**
 *  NSDate转时间戳
 *
 *  @param date 字符串时间
 *
 *  @return 返回时间戳
 */
+ (NSInteger)cTimestampFromDate:(NSDate *)date;

// 时间戳倒数天数
+ (NSString *)remainTime:(int)time;

// 手机正则判断
+ (BOOL)validateMobile:(NSString *)mobile;

// 密码正则判断
+ (BOOL)validatePassword:(NSString *)passWord;

// 邮箱
+ (BOOL)validateEmail:(NSString *)email;

// 中文正则判断
+ (BOOL)ValidChineseString:(NSString *)string;

// 过滤emoji表情
+ (NSString *)stringContainsEmoji:(NSString *)string;

// 动态高度
+ (CGSize)countingSize:(NSString *)str fontSize:(int)fontSize width:(float)width;

// 动态宽度
+ (CGSize)countingSize:(NSString *)str fontSize:(int)fontSize height:(float)height;

// 生成纯色图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

// 毛玻璃效果
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

//字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

// 常规按钮
+ (void)commonWithButton:(UIButton *)btn
                    font:(UIFont *)font
                   title:(NSString *)title
           selectedTitle:(NSString *)selectedTitle
              titleColor:(UIColor *)titleColor
      selectedtitleColor:(UIColor *)selectedtitleColor
           backgroundImg:(UIImage *)backgroundImg
   selectedBackgroundImg:(UIImage *)selectedBackgroundImg
                  target:(id)target
                  action:(SEL)action;
//UILabel转换颜色
+(NSMutableAttributedString *)transitionString:(NSString *)titles andStr:(NSString *)changeStr;

@end
