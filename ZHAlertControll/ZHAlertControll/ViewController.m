//
//  ViewController.m
//  ZHAlertControll
//
//  Created by 张行 on 15/11/16.
//  Copyright © 2015年 张行. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, ZHAlertControllerDelegate>

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
    ZHAlertControllerStyle style = ZHAlertControllerStyleAlertView;
    if (indexPath.row == 1) {
        style = ZHAlertControllerStyleActionSheet;
    }
    ZHAlertController *controller = [[ZHAlertController alloc] initWithStyle:style title:@"这是标题" message:@"这是描述" cannelButton:@"取消" otherButtons:@[@"其他按钮"]];
    controller.delegate = self;
    [controller showInController:self];
}

#pragma mark - ZHAlertControllerDelegate
- (void)alertControllerDidClickCancelButton:(ZHAlertController *)alertController {
    NSLog(@"你点击了取消按钮");
}

- (void)alertController:(ZHAlertController *)alertController didClickOtherButtonAtIndex:(NSInteger)otherButtonIndex {
    NSLog(@"你点击了其他按钮");
}

@end
