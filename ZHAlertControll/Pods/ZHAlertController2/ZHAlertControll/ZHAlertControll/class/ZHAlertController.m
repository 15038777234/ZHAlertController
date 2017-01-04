//
//  ZHAlertController.m
//  DressOnline
//
//  Created by 张行 on 16/4/1.
//  Copyright © 2016年 Sammydress. All rights reserved.
//

#import "ZHAlertController.h"
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN
/*!
 *  @brief 储存ZHAlertController的对象 防止局部变量呗释放掉
 */
static NSMutableArray *ZHAlertControllerArray;

@implementation ZHAlertController{
    ZHAlertControllerStyle _style;
    NSString *_title;
    NSString *_message;
    NSString *_cancelButton;
    NSArray<NSString *> *_otherButtons;
}

- (instancetype)initWithStyle:(ZHAlertControllerStyle)style title:(NSString *_Nullable)title message:(NSString *_Nullable)message cannelButton:(NSString *)cancelButton otherButtons:(NSArray *_Nullable)otherButtons {
    if (self = [super init]) {
        _style = style;
        _title = title;
        _message = message;
        _cancelButton = cancelButton;
        _otherButtons = otherButtons;
        if (!ZHAlertControllerArray) {
            ZHAlertControllerArray = [NSMutableArray array];
        }
        [self drawInitView];
    }
    return self;
}

-(void)drawInitView{
    switch (_style) {
        case ZHAlertControllerStyleAlertView:
        case ZHAlertControllerStyleActionSheet: {
                UIAlertControllerStyle alertControllerStyle=UIAlertControllerStyleAlert;
                if (_style==ZHAlertControllerStyleAlertView) {
                    alertControllerStyle=UIAlertControllerStyleActionSheet;
                }
                _alertController=[UIAlertController alertControllerWithTitle:_title message:_message preferredStyle:alertControllerStyle];
                if (_cancelButton) {
                    UIAlertAction *cancelAction=[self actionWithTitle:_cancelButton style:UIAlertActionStyleCancel handler:nil];
                    [_alertController addAction:cancelAction];
                }
                if (_otherButtons.count>0) {
                    __weak typeof(self) weakSelf = self;
                    [_otherButtons enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        __strong  typeof(weakSelf) strongSelf = weakSelf;
                        UIAlertAction *otherAction=[strongSelf actionWithTitle:obj style:UIAlertActionStyleDefault handler:nil];
                        [strongSelf->_alertController addAction:otherAction];
                    }];
                }
            }
            break;
        
    }
    
}
-(UIAlertAction *)actionWithTitle:(nullable NSString *)title style:(UIAlertActionStyle)style handler:(void (^ __nullable)(UIAlertAction *action))handler{
    
    
    __weak typeof(self) weakSelf = self;
    return [UIAlertAction actionWithTitle:title style:style handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf alertActionComplete:action];
    }];
}

-(void)showInController:(UIViewController * _Nullable)controller{
    if (!controller) {
        controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    if (!controller) {
        return;
    }
    [ZHAlertControllerArray addObject:self];
    switch (_style) {
        case ZHAlertControllerStyleAlertView:
        case ZHAlertControllerStyleActionSheet: {
            [controller presentViewController:_alertController animated:YES completion:nil];
        }
            break;
    }
    
}

-(void)completeWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == ZHAlertControlerButtonStyleCannel) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(alertControllerDidClickCancelButton:)]) {
            [self.delegate alertControllerDidClickCancelButton:self];
        }
    }else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(alertController:didClickOtherButtonAtIndex:)]) {
            [self.delegate alertController:self didClickOtherButtonAtIndex:buttonIndex];
        }
    }
    [ZHAlertControllerArray removeObject:self];
}
-(void)alertActionComplete:(UIAlertAction *)action{
    __block NSInteger index = ZHAlertControlerButtonStyleCannel;
    [_otherButtons enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([action.title isEqualToString:obj]) {
            index = idx;
        }
    }];
    [self completeWithButtonIndex:index];
}

@end

NS_ASSUME_NONNULL_END
