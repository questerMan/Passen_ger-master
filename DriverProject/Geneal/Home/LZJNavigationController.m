//
//  LZJNavigationController.m
//  DriverProject
//
//  Created by 林镇杰 on 15/9/6.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "LZJNavigationController.h"
#import "LZJMenuViewController.h"
#import "UIViewController+REFrostedViewController.h"

@interface LZJNavigationController ()

@end

@implementation LZJNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.barTintColor = [UIColor whiteColor];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil];
    self.navigationBar.titleTextAttributes = dic;
    
}

- (void)showMenu
{
    // Dismiss keyboard (optional)
    //
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    self.frostedViewController.menuViewSize = CGSizeMake(KScreenWidth * 0.75, KScreenHeight);
    // Present the view controller
    //
    [self.frostedViewController presentMenuViewController];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
