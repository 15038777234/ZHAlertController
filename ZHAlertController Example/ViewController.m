//
//  ViewController.m
//  ZHAlertController
//
//  Created by 张行 on 2018/5/4.
//  Copyright © 2018年 张行. All rights reserved.
//

#import "ViewController.h"
#import "ZHAlertController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [[ZHAlertController alertControllerWithStyle:ZHAlertControllerStyleAlertView
                                               title:@"这是只有标题和取消按钮的弹出框"
                                             message:nil
                                        cannelButton:@"取消"
                                        otherButtons:nil
                                            complete:nil] showInController:self];
    }
}


@end
