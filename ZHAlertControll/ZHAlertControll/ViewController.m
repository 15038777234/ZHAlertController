//
//  ViewController.m
//  ZHAlertControll
//
//  Created by 张行 on 15/11/16.
//  Copyright © 2015年 张行. All rights reserved.
//

#import "ViewController.h"
#import "ZHAlertController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,ZHAlertControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    ZHAlertControllerType type ;
    
    if (indexPath.row == 0) {
        
        type = ZHAlertControllerTypeAlertView;
    }else {
    
        type = ZHAlertControllerTypeActionSheet;
        
    }
    ZHAlertController *alerController =[[ZHAlertController alloc]initWithdDelegate:self type:type title:@"测试ZHAlertControoler" message:@""];
    [alerController showInController:self];
    
}
- (NSArray<NSString *> *)buttonNamesWithAlertController:(ZHAlertController *)alertController {

    if (alertController.type == ZHAlertControllerTypeAlertView) {
        return @[@"确定",@"取消"];
    }else {
    
        return @[@"相机",@"相册",@"取消"];
    }
}
@end
