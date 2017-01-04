//
//  ZHAlertController.h
//  DressOnline
//
//  Created by 张行 on 16/4/1.
//  Copyright © 2016年 环球易购. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZHAlertController;
/*!
 *  @brief 封装的样式选择
 */
typedef NS_ENUM(NSInteger, ZHAlertControllerStyle) {
    /*!
     *  系统的UIAlertView 默认
     */
    ZHAlertControllerStyleAlertView,
    /*!
     *  系统的UIActionSheet
     */
    ZHAlertControllerStyleActionSheet
};
/*!
 *  @brief 按钮的类型
 */
typedef NS_ENUM(NSInteger,ZHAlertControlerButtonStyle) {
    /*!
     *  如果currentSelectButtonIndex==0 代表为ZHAlertControlerButtonStyleCannel 取消按钮
     */
    ZHAlertControlerButtonStyleCannel = -1
};

@protocol ZHAlertControllerDelegate <NSObject>

@optional 
/*!
 * 点击取消按钮的回调
 * @param alertController 弹出试图的对象
 */
- (void)alertControllerDidClickCancelButton:(ZHAlertController *)alertController;
/*!
 * 点击其他按钮的回调    
 * @param alertController 弹出试图的对象
 * @param otherButtonIndex 其他按钮的索引
 */
- (void)alertController:(ZHAlertController *)alertController didClickOtherButtonAtIndex:(NSInteger)otherButtonIndex;

@end

/*!
 *  @brief 自定义封装的基于UIAlertView UIActionSheet 支持8.0以后的UIAlertController
 */
@interface ZHAlertController : NSObject

@property (nullable, nonatomic, weak) id<ZHAlertControllerDelegate> delegate;

@property (nonatomic, strong, readonly) UIAlertController *alertController;

/*!
 * 初始化弹出框
 * @param style 弹出框的样式
 * @param title 弹出框的标题可以为空
 * @param message 弹出空的内容可以为空
 * @param cancelButton 取消的按钮 不能为空
 * @param otherButtons 其他的按钮数组 可以为空
 * @return ZHAlertController
 */
-(instancetype)initWithStyle:(ZHAlertControllerStyle)style title:(NSString * _Nullable)title message:(NSString * _Nullable)message cannelButton:(NSString * )cancelButton otherButtons:(NSArray * _Nullable)otherButtons NS_DESIGNATED_INITIALIZER;
/*!
 *  @brief 展示试图
 *
 *  @param controller 展示试图所在的UIViewController 可以为空 为空默认取window的第一个UIViewController
 */
-(void)showInController:(UIViewController * _Nullable)controller;
@end

NS_ASSUME_NONNULL_END
