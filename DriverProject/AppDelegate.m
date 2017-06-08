//
//  AppDelegate.m
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-3.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "LZJMenuViewController.h"
#import "LZJNavigationController.h"
#import "newLoginViewController.h"
#import "SocketOne.h"
#import "WXApi.h"

#define WXPAY_URL_SCHEME @"wx9cad54f0db833982" //微信支付URL

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    LZJNavigationController *navigation = [[LZJNavigationController alloc] initWithRootViewController: [[HomeViewController alloc] init]];
    navigation.navigationBar.barTintColor = [UIColor whiteColor];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil];
    navigation.navigationBar.titleTextAttributes = dic;
    LZJMenuViewController *menu = [[LZJMenuViewController alloc] initWithStyle:UITableViewStylePlain];
    
    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:navigation menuViewController:menu];
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    frostedViewController.liveBlur = YES;
    frostedViewController.delegate = self;
    
//    UIView * bgView = [[UIView alloc] init];
//    bgView.backgroundColor = [UIColor whiteColor];
//    bgView.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
//    [frostedViewController.view addSubview:bgView];
//    
//    UIImageView* launchImage1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"launchImage1"]];
//    launchImage1.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
//    [frostedViewController.view addSubview:launchImage1];
//    
//    UIImageView* launchImage2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"launchImage2"]];
//    launchImage2.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
//    launchImage2.alpha = 0;
//    [frostedViewController.view addSubview:launchImage2];
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [UIView animateWithDuration:0.5 animations:^{
//            launchImage1.alpha = 0;
//            launchImage2.alpha = 1;
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:1 animations:^{
//                [bgView removeFromSuperview];
//                launchImage2.alpha = 0;
//            } completion:^(BOOL finished) {
//                [launchImage1 removeFromSuperview];
//                [launchImage2 removeFromSuperview];
//            }];
//        }];
//    });
    
    
    //向微信注册
    [WXApi registerApp:@"wx9cad54f0db833982" withDescription:@"广汽丽新出行"];
    
    self.window.rootViewController = frostedViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    return YES;
}

#pragma - mark REFrostedViewController Delegate
- (void)frostedViewController:(REFrostedViewController *)frostedViewController didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer
{
    
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController willShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willShowMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didShowMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController willHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willHideMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didHideMenuViewController");
}

- (void)onResp:(BaseResp*)resp{
    
    NSString *success;
    
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp *response = (PayResp*)resp;
        
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                success = @"成功";
        
                break;
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                if (resp.errCode == -2) {
                    success = @"取消";
                }else{
                    success = @"失败";
                }
                
                break;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PAY_STATUS object:success];
    }
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.absoluteString rangeOfString:WXPAY_URL_SCHEME].location == 0)//微信支付
    {
        [WXApi handleOpenURL:url delegate:self];
        NSLog(@"sourceApplication:%@\nannotation:%@",sourceApplication,annotation);
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
