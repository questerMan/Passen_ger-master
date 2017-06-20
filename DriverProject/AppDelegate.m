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
#import "UMessage.h"
#import <UserNotifications/UserNotifications.h>
#define WXPAY_URL_SCHEME @"wx9cad54f0db833982" //微信支付URL
#define UM_KEY @"wx9cad54f0db833982"//友盟Key
@interface AppDelegate ()<WXApiDelegate,UNUserNotificationCenterDelegate>

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
//    bgView.frame = CGRectMake(0, 0, SCREEN_W, S   CREEN_H);
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
    [WXApi registerApp:UM_KEY withDescription:@"广汽丽新出行"];
    
    self.window.rootViewController = frostedViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    
#pragma mark - 添加注册友盟
    [self initUM:launchOptions];
    
    return YES;
}

#pragma mark - 添加注册友盟
-(void)initUM:(NSDictionary *)launchOptions{
    //初始化方法,也可以使用(void)startWithAppkey:(NSString *)appKey launchOptions:(NSDictionary * )launchOptions httpsenable:(BOOL)value;这个方法，方便设置https请求。
    [UMessage startWithAppkey:@"56559e1c67e58e56800022ad" launchOptions:launchOptions];
    //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
    [UMessage registerForRemoteNotifications];
    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    //打开日志，方便调试
    [UMessage setLogEnabled:YES];
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
    [UMessage registerDeviceToken:deviceToken];
    
    NSString *newDToken = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                            stringByReplacingOccurrencesOfString: @">" withString: @""]
                           stringByReplacingOccurrencesOfString: @" " withString: @""];
    [UIFactory SaveNSUserDefaultsWithData:newDToken AndKey:@"deviceToken"];
    NSLog(@"%@",newDToken);

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

//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    [UMessage didReceiveRemoteNotification:userInfo];
    
    //    self.userInfo = userInfo;
    //定制自定的的弹出框
    //        if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    //        {
    //            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标题"
    //                                                                message:@"Test On ApplicationStateActive"
    //                                                               delegate:self
    //                                                      cancelButtonTitle:@"确定"
    //                                                      otherButtonTitles:nil];
    //
    //            [alertView show];
    //
    //        }
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        if ([[userInfo objectForKey:@"type"] isEqualToString:@"orderAccept"] || [[userInfo objectForKey:@"type"] isEqualToString:@"orderSetoff"] ) {
            [self crateNotificationWithDic:userInfo];
        }
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
        [self crateNotificationWithDic:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
}
- (void)crateNotificationWithDic:(NSDictionary *) userInfo
{

    //创建一个消息对象
    NSNotification * notice = [NSNotification notificationWithName:@"NEWS_REFRESH" object:nil userInfo:userInfo];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
    
}


@end
