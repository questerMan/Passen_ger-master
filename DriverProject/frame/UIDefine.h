//
//  UIDefine.h
//  iPoS_IOS
//
//  Created by Cherish on 14/12/3.
//  Copyright (c) 2014年 AIA Information Technology (Beijing) Co., Ltd. All rights reserved.
//

#define TabBarViewController (IPOSTabBarController *)[(AppDelegate *)[UIApplication sharedApplication].delegate tabBarController]
#define CurrentViewController (UIViewController *)[(IPOSTabBarController *)[(AppDelegate *)[UIApplication sharedApplication].delegate tabBarController] currentController]

//#if __IPHONE_OS_VERSION_MAX_ALLOWED <80000
//       #define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.height)
//       #define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.width)
//#else
//       #define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
//       #define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
//#endif

#define CurrentController_isNav [CurrentController.parentViewController isKindOfClass:[UINavigationController class]]

#define Version_MaxAllowed __IPHONE_OS_VERSION_MAX_ALLOWED
#define Version_Device [[[UIDevice currentDevice] systemVersion] floatValue]

#define isIOS6 (Version_MaxAllowed >= 60000 && Version_MaxAllowed < 70000)
#define isIOS6Above (Version_MaxAllowed >= 60000)
#define isIOS7 (Version_MaxAllowed >= 70000 && Version_MaxAllowed < 80000)
#define isIOS7Above (Version_MaxAllowed >= 70000)
#define isIOS8 (Version_MaxAllowed >= 80000)

#define isIOS6_Device (Version_Device>= 6.0 && Version_Device < 7.0)
#define isIOS6Above_Device (Version_Device >= 6.0)
#define isIOS7_Device (Version_Device >=7.0 && Version_Device < 8.0)
#define isIOS7Above_Device (Version_Device >=7.0)
#define isIOS8_Device (Version_Device >= 8.0)

#define kHeight_Statuebar 20
#define kHeight_Tabbar 49
#define kHeight_Navbar 44

#define kBounds_Screen [UIScreen mainScreen].bounds
#define kWidth_Screen ((!isIOS8) ? kBounds_Screen.size.height : kBounds_Screen.size.width)
#define kHeight_Screen ((isIOS6 ||isIOS7) ? (kBounds_Screen.size.width - kHeight_Statuebar) : (isIOS7Above ? (kBounds_Screen.size.height - kHeight_Statuebar) : kBounds_Screen.size.height))
#define kBounds_Screen_Fixed CGRectMake(kBounds_Screen.origin.x, kBounds_Screen.origin.y, kWidth_Screen, kHeight_Screen)

#define kWidth_RootView kWidth_Screen
#define kHeight_RootView kHeight_Screen
#define kHeight_RootViewNoNav (kHeight_RootView - kHeight_Navbar)
#define kHeight_RootViewNoTab (kHeight_RootViewNoNav - kHeight_Tabbar)

#define kRect_RootView CGRectMake(0,0,kWidth_RootView,kHeight_RootView)
#define kRect_RootViewNoNav CGRectMake(0,0,kWidth_RootView,kHeight_RootViewNoNav)
#define kRect_RootViewNoTab CGRectMake(0,0,kWidth_RootView,kHeight_RootViewNoTab)

#define kRect_RootViewIMO CGRectMake(0,80,kWidth_RootView,kHeight_RootViewNoTab-80)

#define BENEFICARY_PA_COUNT 3
#define BENEFICARY_COUNT 4

#define LEFT_SCROLL_WIDTH  40
#define RIGHT_SCROLL_WIDTH  90

#define kWidth_FOR_TABLEVIEW  (kWidth_RootView-LEFT_SCROLL_WIDTH-RIGHT_SCROLL_WIDTH)