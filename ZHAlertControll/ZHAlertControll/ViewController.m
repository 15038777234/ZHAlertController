//
//  ViewController.m
//  ZHAlertControll
//
//  Created by 张行 on 15/11/16.
//  Copyright © 2015年 张行. All rights reserved.
//

#import "ViewController.h"
#import "ZHAlertControler.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

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
    ZHAlertControlerStyle style = ZHAlertControlerStyleAlertView;
    if (indexPath.row == 1) {
        style = ZHAlertControlerStyleActionSheet;
    }
    [[ZHAlertControler alertControllerWithStyle:style title:@"这是标题" message:@"这是描述" cannelButton:@"取消" otherButtons:@[@"其他"] complete:^(ZHAlertControler * _Nonnull controller) {
        
    }] showInController:self];
}

@end
