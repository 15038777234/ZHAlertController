//
//  ZHAlertController.h
//  DressOnline
//
//  Created by 张行 on 16/4/1.
//  Copyright © 2016年 Sammydress. All rights reserved.
//

#import <UIKit/UIKit.h>

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
typedef NS_ENUM(NSInteger, ZHAlertControllerButtonStyle) {
     ZHAlertControllerButtonStyleCancel = 0
};

/*!
 *  @brief 点击按钮的回掉方法
 *
 *  @param controller 当前弹出的试图对象
 */
typedef void (^ZHAlertControllerDidSelectComplete)(ZHAlertController * _Nullable controller);

/**
 * 创建输入框的回调函数 如果返回 NO 则停止创建 如果是 YES继续创建

 @param textFiled 当前需要配置的UITextField对象
 @param idx 索引
 @return 如果返回 NO 则停止创建 如果是 YES继续创建
 */
typedef BOOL (^ZHAlertControllerAddTextFiledWithConfigurationHandler)(UITextField * _Nullable textFiled, NSUInteger idx);


@interface ZHAlertController : NSObject

@property (nonatomic, strong, readonly) UIAlertController * _Nullable alertController;

@property (nonatomic, assign, readonly) ZHAlertControllerStyle style;

/*!
 *  @brief 当前点击按钮的TAG 默认为ZHAlertControllerButtonStyleCanncel
 */
@property (nonatomic, assign, readonly) NSInteger currentSelectButtonIndex;

/*!
 *  @brief 重新设置消息
 */
@property (nonatomic, copy) NSString * _Nullable message;


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
 *  @return ZHAlertController对象
 */
+ (instancetype _Nullable )alertControllerWithStyle:(ZHAlertControllerStyle)style
                                   title:(NSString *_Nullable)title
                                 message:(NSString *_Nullable)message
                            cannelButton:(NSString *_Nullable)cannelButton
                            otherButtons:(NSArray<NSString *> *_Nullable)otherButtons
                                complete:(ZHAlertControllerDidSelectComplete _Nullable )complete;

/**
 初始化函数

 @param style 样式
 @param title 标题
 @param message 描述信息
 @param cannelButton 取消按钮
 @param otherButtons 其他的按钮文本
 @param addTextFiledWithConfigurationHandle 添加输入框
 @return ZHAlertController
 */
+ (instancetype _Nullable )alertControllerWithStyle:(ZHAlertControllerStyle)style
                                              title:(NSString *_Nullable)title
                                            message:(NSString *_Nullable)message
                                       cannelButton:(NSString *_Nullable)cannelButton
                                       otherButtons:(NSArray<NSString *> *_Nullable)otherButtons
                addTextFiledWithConfigurationHandle:(ZHAlertControllerAddTextFiledWithConfigurationHandler _Nullable)addTextFiledWithConfigurationHandle
                                           complete:(ZHAlertControllerDidSelectComplete _Nullable)complete;

/*!
 *  @brief 展示试图
 *
 *  @param controller 展示试图所在的UIViewController
 */
- (void)showInController:(UIViewController *_Nullable)controller;

@end

/*!
 *  @brief 用户设置UIAlertAction的索引
 */
@interface UIAlertAction (ZHAlertControllerTag)

@property(nonatomic, assign) NSInteger tag;

@end

