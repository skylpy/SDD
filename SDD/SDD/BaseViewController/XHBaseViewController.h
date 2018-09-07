

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "TAOverlay.h"
#import "DWTagList.h"
#import "MobClick.h"
#import "NoDataTips.h"

typedef void(^XHBarButtonItemActionBlock)(void);

typedef NS_ENUM(NSInteger, XHBarbuttonItemStyle) {
    XHBarbuttonItemStyleSetting = 0,
    XHBarbuttonItemStyleMore,
    XHBarbuttonItemStyleCamera,
};

@interface XHBaseViewController : UIViewController


// 网络请求
@property (nonatomic, strong) AFHTTPRequestOperationManager *httpManager;
/**
 * 保存父 controller 的 nav
 **/
@property(nonatomic,strong) UINavigationController *superNavigationController;
/**
 *  统一设置背景图片
 *
 *  @param backgroundImage 目标背景图片
 */
- (void)setupBackgroundImage:(UIImage *)backgroundImage;

/**
 *  push新的控制器到导航控制器
 *
 *  @param newViewController 目标新的控制器对象
 */
- (void)pushNewViewController:(UIViewController *)newViewController;

/**
 *  显示加载的loading，没有文字的
 */
- (void)showLoading:(NSInteger)loadingType;
/**
 *  显示带有某个文本加载的loading
 *
 *  @param text 目标文本
 */
- (void)showLoadingWithText:(NSString *)text;
/**
 *  显示成功的HUD
 */
- (void)showSuccessWithText:(NSString *)text;
/**
 *  显示错误的HUD
 */
- (void)showErrorWithText:(NSString *)text;
/**
 *  显示信息的HUD
 */
- (void)showInfoWithText:(NSString *)text;
/**
 *  隐藏在该View上的所有HUD，不管有哪些，都会全部被隐藏
 */
- (void)hideLoading;
/**
 *  无数据时显示提示(带按钮)
 **/
- (void)showNoDataTipsWithText:(NSString *)text
                   buttonTitle:(NSString *)title
                     buttonTag:(NSInteger)theTag
                        target:(id)target
                        action:(SEL)action;
/**
 *  有数据隐藏提示
 **/
- (void)hideNoDataTips;
/**
 *
 **/
- (void)configureBarbuttonItemStyle:(XHBarbuttonItemStyle)style action:(XHBarButtonItemActionBlock)action;
/**
 * 设置导航条
 **/
- (void)setNav:(NSString *)title;
/**
 * 网络请求成功后返回
 **/
- (void)onSuccess:(AFHTTPRequestOperation *)operation context:(id) responseObject;
/**
 * 发送网络请求
 **/
- (void)sendRequest:(NSDictionary *)dic url:(NSString *)urlString;
/**
 * 网络请求失败
 **/
- (void)onFailure:(AFHTTPRequestOperation *) operation error: (NSError *) error;
/**
 * 发送顾问默认欢迎文本
 **/
//- (void)sendDefaultWelcome;

//弹窗
- (void)showDataWithText:(NSString *)text
                   buttonTitle:(NSString *)title
                   buttonTag:(NSInteger)btnTitle
                      target:(id)target
                      action:(SEL)action;

@property (retain,nonatomic)UIView  * bigView;
@property (retain,nonatomic)UIView  * minView;


//问答弹窗
- (void)showDataWithText:(NSString *)text
             buttonTitle:(NSString *)title
             btnTitle:(NSString *)btntitle
               buttonTag1:(NSInteger)btnTaG1
               buttonTag2:(NSInteger)btnTaG2
                  target:(id)target
                  action:(SEL)action
                  target1:(id)target1
                  action2:(SEL)action2;

@property (retain,nonatomic)UIView  * bigView1;
@property (retain,nonatomic)UIView  * minView1;

//加载失败之后的页面
- (void)showLoadfailedWithaction:(SEL)action;

@end
