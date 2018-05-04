//
//  ZHAlertController.m
//  DressOnline
//
//  Created by 张行 on 16/4/1.
//  Copyright © 2016年 Sammydress. All rights reserved.
//

#import "ZHAlertController.h"
#import <objc/runtime.h>

#define ZHWeakSelf __weak typeof(self) weakSelf=self
#define ZHStrongSelf __strong typeof(weakSelf) strongSelf=weakSelf;
/*!
 *  @brief 储存ZHAlertController的对象 防止局部变量呗释放掉
 */
static NSMutableArray *ZHAlertControlerArray;

@implementation ZHAlertController {
    NSString *_title,*_message,*_cannelButton;
    NSArray *_otherButtons;
    ZHAlertControllerDidSelectComplete _complete;
    ZHAlertControllerAddtextFieldWithConfigurationHandler _addtextFieldWithConfigurationHandler;
}

#pragma mark - Life Cycle
+ (instancetype)alertControllerWithStyle:(ZHAlertControllerStyle)style
                                   title:(NSString *)title
                                 message:(NSString *)message
                            cannelButton:(NSString *)cannelButton
                            otherButtons:(NSArray *)otherButtons
                                complete:(ZHAlertControllerDidSelectComplete)complete {
    return [self alertControllerWithStyle:style
                                    title:title
                                  message:message
                             cannelButton:cannelButton
                             otherButtons:otherButtons
      addtextFieldWithConfigurationHandle:nil
                                 complete:complete];
}

+ (instancetype)alertControllerWithStyle:(ZHAlertControllerStyle)style
                                   title:(NSString *)title
                                 message:(NSString *)message
                            cannelButton:(NSString *)cannelButton
                            otherButtons:(NSArray<NSString *> *)otherButtons
     addtextFieldWithConfigurationHandle:(ZHAlertControllerAddtextFieldWithConfigurationHandler)addtextFieldWithConfigurationHandle
                                complete:(ZHAlertControllerDidSelectComplete)complete {
    return [[ZHAlertController alloc] initAlertControllerWithStyle:style
                                                             title:title
                                                           message:message
                                                      cannelButton:cannelButton
                                                      otherButtons:otherButtons
                               addtextFieldWithConfigurationHandle:addtextFieldWithConfigurationHandle
                                                          complete:complete];
}

- (instancetype)initAlertControllerWithStyle:(ZHAlertControllerStyle)style
                                       title:(NSString *)title
                                     message:(NSString *)message
                                cannelButton:(NSString *)cannelButton
                                otherButtons:(NSArray *)otherButtons
         addtextFieldWithConfigurationHandle:(ZHAlertControllerAddtextFieldWithConfigurationHandler)addtextFieldWithConfigurationHandle
                                    complete:(ZHAlertControllerDidSelectComplete)complete {
    NSParameterAssert(cannelButton);
    if (self=[super init]) {
        _style=style;
        _title=title;
        _message=message;
        _cannelButton=cannelButton;
        _otherButtons=otherButtons;
        _complete=complete;
        _addtextFieldWithConfigurationHandler = addtextFieldWithConfigurationHandle;
        if (!ZHAlertControlerArray) {
            ZHAlertControlerArray =[NSMutableArray array];
        }
        [self drawInitView];
    }
    return self;
}

- (instancetype)init {
    return [self initAlertControllerWithStyle:ZHAlertControllerStyleAlertView
                                        title:nil
                                      message:nil
                                 cannelButton:@"取消"
                                 otherButtons:nil
          addtextFieldWithConfigurationHandle:nil
                                     complete:nil];
}

- (void)dealloc {
    NSLog(@"ZHAlertController dealloc = %@",@(self.currentSelectButtonIndex));
}

#pragma mark - Method
- (void)drawInitView {
    ZHWeakSelf;
    _currentSelectButtonIndex = ZHAlertControllerButtonStyleCancel;
    UIAlertControllerStyle alertControllerStyle = UIAlertControllerStyleAlert;
    if (_style == ZHAlertControllerStyleActionSheet) {
        alertControllerStyle = UIAlertControllerStyleActionSheet;
    }
    _alertController = [UIAlertController alertControllerWithTitle:_title
                                                           message:_message
                                                    preferredStyle:alertControllerStyle];
    if (_cannelButton) {
        UIAlertAction *cannelAction = [self actionWithTitle:_cannelButton
                                                      style:UIAlertActionStyleCancel
                                                    handler:^(UIAlertAction *action) {
                                                        ZHStrongSelf;
                                                        [strongSelf completeWithButtonIndex:0];
                                                    }];
        cannelAction.tag = _currentSelectButtonIndex;
        [_alertController addAction:cannelAction];
    }
    if (_otherButtons.count > 0) {
        [_otherButtons enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            ZHStrongSelf;
            NSUInteger index = idx + 1;
            UIAlertAction *otherAction=[strongSelf actionWithTitle:obj
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *action) {
                                                               ZHStrongSelf;
                                                               [strongSelf completeWithButtonIndex:index];
                                                           }];
            strongSelf->_currentSelectButtonIndex++;
            otherAction.tag = strongSelf->_currentSelectButtonIndex;
            [strongSelf->_alertController addAction:otherAction];
        }];
    }
    
    if (_addtextFieldWithConfigurationHandler) {
        NSUInteger index = 0;
        __block BOOL continueAddtextField = YES;
        while (continueAddtextField) {
            [_alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                ZHStrongSelf;
                continueAddtextField = strongSelf->_addtextFieldWithConfigurationHandler(textField,index);
            }];
            index ++;
        }
    }
}

- (UIAlertAction *)actionWithTitle:(NSString *)title
                             style:(UIAlertActionStyle)style
                           handler:(void (^)(UIAlertAction *action))handler {
    return [UIAlertAction actionWithTitle:title
                                    style:style
                                  handler:handler];
}

- (void)showInController:(UIViewController *)controller {
    NSParameterAssert(controller);
    // 防止 多个 UIAlertController 进行覆盖
    if ([NSStringFromClass([controller class]) isEqualToString:NSStringFromClass([UIAlertController class])]) {
        return;
    }
    // 真正开始的展现
    [ZHAlertControlerArray addObject:self];
    [controller presentViewController:_alertController
                             animated:YES
                           completion:nil];
}

- (void)completeWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        buttonIndex = ZHAlertControllerButtonStyleCancel;
    }
    _currentSelectButtonIndex = buttonIndex;
    if (_complete) {
        _complete(self);
    }
    [ZHAlertControlerArray removeObject:self];
}

#pragma mark - Setter
- (void)setMessage:( NSString *)message {
    if (_message != message) {
        _message = message;
    }
    self.alertController.message = message;
}

@end

#pragma mark - UIAlertAction + ZHAlertControllerTag
@implementation UIAlertAction (ZHAlertControllerTag)

- (void)setTag:(NSInteger)tag {
    objc_setAssociatedObject(self, @selector(tag), @(tag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)tag {
    return [objc_getAssociatedObject(self, @selector(tag)) integerValue];
}

@end

