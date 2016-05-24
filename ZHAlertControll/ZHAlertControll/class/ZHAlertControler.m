//
//  ZHAlertControler.m
//  DressOnline
//
//  Created by 张行 on 16/4/1.
//  Copyright © 2016年 Sammydress. All rights reserved.
//

#import "ZHAlertControler.h"
#import <objc/runtime.h>
#define ZHWeakSelf __weak typeof(self) weakSelf=self
#define ZHStrongSelf __strong typeof(weakSelf) strongSelf=weakSelf;

NS_ASSUME_NONNULL_BEGIN
/*!
 *  @brief 储存ZHAlertController的对象 防止局部变量被释放掉
 */
static NSMutableArray *ZHAlertControlerArray;
@implementation ZHAlertControler{
    NSString *_title,*_message,*_cannelButton;
    NSArray *_otherButtons;
    ZHAlertControlerDidSelectComplete _complete;
    UIAlertActionStyle (^_configAlertActionStyleBlock)(NSUInteger buttonIndex);
}
-(void)dealloc{
    NSLog(@"ZHAlertControler dealloc = %@",@(self.currentSelectButtonIndex));
}
+(instancetype)alertControllerWithStyle:(ZHAlertControlerStyle)style title:(NSString * _Nullable)title message:(NSString * _Nullable)message cannelButton:(NSString * )cannelButton otherButtons:(NSArray * _Nullable)otherButtons complete:(ZHAlertControlerDidSelectComplete _Nullable)complete{
    return [[ZHAlertControler alloc]initAlertControllerWithStyle:style title:title message:message cannelButton:cannelButton otherButtons:otherButtons complete:complete];
}

-(instancetype)initAlertControllerWithStyle:(ZHAlertControlerStyle)style title:(NSString * _Nullable)title message:(NSString * _Nullable)message cannelButton:(NSString *)cannelButton otherButtons:(NSArray * _Nullable)otherButtons complete:(ZHAlertControlerDidSelectComplete _Nullable)complete{
    NSParameterAssert(cannelButton);
    if (self=[super init]) {
        _style=style;
        _title=title;
        _message=message;
        _cannelButton=cannelButton;
        _otherButtons=otherButtons;
        _complete=complete;
        if (!ZHAlertControlerArray) {
            ZHAlertControlerArray =[NSMutableArray array];
        }
        
    }
    return self;
}
-(instancetype)init{
    if (self=[self initAlertControllerWithStyle:ZHAlertControlerStyleAlertView title:nil message:nil cannelButton:@"取消" otherButtons:nil complete:nil]) {
    }
    return self;
}
-(void)drawInitView{
    ZHWeakSelf;
    _currentSelectButtonIndex=ZHAlertControlerButtonStyleCannel;
    switch (_style) {
        case ZHAlertControlerStyleAlertView:
        case ZHAlertControlerStyleActionSheet: {
            if (ZHIsMoreThanIOS8) {
                UIAlertControllerStyle alertControllerStyle=UIAlertControllerStyleAlert;
                if (_style==ZHAlertControlerStyleActionSheet) {
                    alertControllerStyle=UIAlertControllerStyleActionSheet;
                }
                _alertController=[UIAlertController alertControllerWithTitle:_title message:_message preferredStyle:alertControllerStyle];
                __block  UIAlertActionStyle style = UIAlertActionStyleCancel;
                if (_cannelButton) {
                    if(_configAlertActionStyleBlock){
                        style = _configAlertActionStyleBlock(_currentSelectButtonIndex);
                    }
                    UIAlertAction *cannelAction=[self actionWithTitle:_cannelButton style:style handler:nil];
                    cannelAction.tag=_currentSelectButtonIndex;
                    [_alertController addAction:cannelAction];
                }
                if (_otherButtons.count>0) {
                    [_otherButtons enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        ZHStrongSelf;
                        style =  UIAlertActionStyleDefault;
                        if(strongSelf->_configAlertActionStyleBlock){
                            style = strongSelf->_configAlertActionStyleBlock(strongSelf->_currentSelectButtonIndex);
                        }
                        UIAlertAction *otherAction=[strongSelf actionWithTitle:obj style:style handler:nil];
                        strongSelf->_currentSelectButtonIndex++;
                        otherAction.tag=strongSelf->_currentSelectButtonIndex;
                        [strongSelf->_alertController addAction:otherAction];
                    }];
                }
            }else{
                if (_style==ZHAlertControlerStyleAlertView) {
                    _alertView=[[UIAlertView alloc]init];
                    _alertView.title=_title;
                    _alertView.message=_message;
                    if (_cannelButton) {
                        [_alertView addButtonWithTitle:_cannelButton];
                        _alertView.cancelButtonIndex=ZHAlertControlerButtonStyleCannel;
                    }
                    if (_otherButtons.count>0) {
                        [_otherButtons enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            ZHStrongSelf;
                            [strongSelf->_alertView addButtonWithTitle:obj];
                        }];
                    }
                    
                    _alertView.delegate=self;
                }else{
                    _actionSheet=[[UIActionSheet alloc]init];
                    _actionSheet.title=_title;
                    if (_cannelButton) {
                        [_actionSheet addButtonWithTitle:_cannelButton];
                        _actionSheet.cancelButtonIndex=ZHAlertControlerButtonStyleCannel;
                    }
                    if (_otherButtons.count>0) {
                        [_otherButtons enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            ZHStrongSelf;
                            [strongSelf->_actionSheet addButtonWithTitle:obj];
                        }];
                    }
                    _actionSheet.delegate=self;
                }
            }
            break;
        }
    }
}
-(UIAlertAction *)actionWithTitle:(nullable NSString *)title style:(UIAlertActionStyle)style handler:(void (^ __nullable)(UIAlertAction *action))handler{
    
    
    ZHWeakSelf;
    return [UIAlertAction actionWithTitle:title style:style handler:^(UIAlertAction * _Nonnull action) {
        ZHStrongSelf;
        [strongSelf alertActionComplete:action];
    }];
}
-(void)showInController:(UIViewController *)controller{
    NSParameterAssert(controller);
    [self drawInitView];
    [ZHAlertControlerArray addObject:self];
    switch (_style) {
        case ZHAlertControlerStyleAlertView:
        case ZHAlertControlerStyleActionSheet:{
            if (ZHIsMoreThanIOS8) {
                [controller presentViewController:_alertController animated:YES completion:nil];
            }else{
                if (_style==ZHAlertControlerStyleAlertView) {
                    [_alertView show];
                }else{
                    [_actionSheet showInView:controller.view];
                }
            }
            break;
        }
    }
}
-(void)completeWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        buttonIndex=ZHAlertControlerButtonStyleCannel;
    }
    _currentSelectButtonIndex=buttonIndex;
    if (_complete) {
        _complete(self);
    }
    [ZHAlertControlerArray removeObject:self];
}
-(void)alertActionComplete:(UIAlertAction *)action{
    
    [self completeWithButtonIndex:action.tag];
}


#pragma mark 用户自定义
- (instancetype)alertActionStyle:(UIAlertActionStyle (^)(NSUInteger buttonIndex))styleBlock {
    _configAlertActionStyleBlock = styleBlock;
    return self;
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    [self completeWithButtonIndex:buttonIndex];
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    [self completeWithButtonIndex:buttonIndex];
}

@end

@implementation UIAlertAction (ZHAlertControllerTag)

-(void)setTag:(NSInteger)tag{
    objc_setAssociatedObject(self, @selector(tag), @(tag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSInteger)tag{
    return  [objc_getAssociatedObject(self, @selector(tag)) integerValue];
}
@end

NS_ASSUME_NONNULL_END
