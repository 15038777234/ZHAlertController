//
//  ZHAlertControler.h
//  DressOnline
//
//  Created by 张行 on 16/4/1.
//  Copyright © 2016年 Sammydress. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define ZHAlertControlerDebug //是否开启调试



#define ZHIsMoreThanIOS8 NSFoundationVersionNumber>=NSFoundationVersionNumber_iOS_8_0

#ifdef ZHAlertControlerDebug
#warning @"开启ZHAlertControlerDebug可以轻松调试IOS8以上和IOS以下的代码运行情况"

#undef ZHIsMoreThanIOS8
#define ZHIsMoreThanIOS8 NO
#endif


NS_ASSUME_NONNULL_BEGIN
@class ZHAlertControler;
/*!
 *  @brief 封装的样式选择
 */
typedef NS_ENUM(NSInteger,ZHAlertControlerStyle) {
    /*!
     *  系统的UIAlertView 默认
     */
    ZHAlertControlerStyleAlertView,
    /*!
     *  系统的UIActionSheet
     */
    ZHAlertControlerStyleActionSheet
};
/*!
 *  @brief 按钮的类型
 */
typedef NS_ENUM(NSInteger,ZHAlertControlerButtonStyle) {
    /*!
     *  如果currentSelectButtonIndex==0 代表为ZHAlertControlerButtonStyleCannel 取消按钮
     */
    ZHAlertControlerButtonStyleCannel
};
/*!
 *  @brief 点击按钮的回掉方法
 *
 *  @param controller 当前弹出的试图对象
 */
typedef void(^ZHAlertControlerDidSelectComplete)(ZHAlertControler *controller);


/*!
 *  @brief 自定义封装的基于UIAlertView UIActionSheet 支持8.0以后的UIAlertController
 */
@interface ZHAlertControler : NSObject<UIAlertViewDelegate,UIActionSheetDelegate>
/*!
 *  @brief 当IOS8以下 ZHAlertControlerStyleAlertView 才存在 否则为nil
 */
@property (nullable,nonatomic, strong,readonly) UIAlertView *alertView;
/*!
 *  @brief 当IOS8以下 ZHAlertControlerStyleActionSheet 才存在 否则为nil
 */
@property (nullable,nonatomic, strong,readonly) UIActionSheet *actionSheet;
/*!
 *  @brief 当IOS8以上 ZHAlertControlerStyleAlertView或者ZHAlertControlerStyleActionSheet 才存在 否则为nil
 */

@property (nullable,nonatomic, strong,readonly) UIAlertController *alertController;
/*!
 *  @brief 当前展示的类型 目前只支持系统的UIAlertController UIAlertView UIActionSheet
 */
@property (nonatomic, assign,readonly) ZHAlertControlerStyle style;
/*!
 *  @brief 当前点击按钮的TAG 默认为ZHAlertControlerButtonStyleCannel
 */
@property (nonatomic, assign,readonly) NSInteger currentSelectButtonIndex;
/*!
 *  @brief 便利调用弹出框
 *
 *  @param style        类型
 *  @param title        标题
 *  @param message      描述信息
 *  @param cannelButton 取消按钮 不能为nil
 *  @param otherButtons 其他的按钮
 *  @param complete     完成的回掉
 *
 *  @return ZHAlertControler对象
 */
+(instancetype)alertControllerWithStyle:(ZHAlertControlerStyle)style title:(NSString * _Nullable)title message:(NSString * _Nullable)message cannelButton:(NSString * )cannelButton otherButtons:(NSArray * _Nullable)otherButtons complete:(ZHAlertControlerDidSelectComplete _Nullable)complete;
/*!
 *  @brief  建议使用+alertControllerWithStyle:title:message:cannelButton:otherButtons:complete
 *
 */
-(instancetype)initAlertControllerWithStyle:(ZHAlertControlerStyle)style title:(NSString * _Nullable)title message:(NSString * _Nullable)message cannelButton:(NSString * )cannelButton otherButtons:(NSArray * _Nullable)otherButtons complete:(ZHAlertControlerDidSelectComplete _Nullable)complete NS_DESIGNATED_INITIALIZER;
/*!
 *  @brief 展示试图
 *
 *  @param controller 展示试图所在的UIViewController
 */
-(void)showInController:(UIViewController *)controller;
@end
/*!
 *  @brief 用户设置UIAlertAction的索引
 */
@interface UIAlertAction (ZHAlertControllerTag)
@property (nonatomic, assign) NSInteger tag;
@end

NS_ASSUME_NONNULL_END
