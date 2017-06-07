//
//  QiMacro.h
//  77net
//  常用宏定义
//  Created by liyy on 14-4-9.
//  Copyright (c) 2014年 77. All rights reserved.
//

#ifndef _7net_QiMacro_h
#define _7net_QiMacro_h

#pragma mark - 单例模式
//单例模式宏

#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
        + (__class *)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
        + (__class *)sharedInstance \
        { \
            static dispatch_once_t once; \
            static __class * __singleton__; \
            dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
            return __singleton__; \
        }

#endif



#pragma mark - 颜色
//颜色

#ifndef RGB
#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#endif

#ifndef RGBA
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f \
alpha:(a)]
#endif

#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//#ifndef Color16
//#define Color16(str) [ToolObject colorWithHexString:(str)]
//#endif

#pragma mark - 字体
//字体
#ifndef SYSTEM_FONT
#define SYSTEM_FONT(size) [UIFont systemFontOfSize:(size)]
#endif

#ifndef BOLD_FONT
#define BOLD_FONT(size) [UIColor boldSystemFontOfSize:(size)]
#endif


//#pragma mark - log信息开关
////log信息
//
//#ifndef QI_LOG_FLAG
//#define QI_LOG_FLAG (1)
//#endif
//
//#if QI_LOG_FLAG > 0
//#define NSLog(...) NSLog(__VA_ARGS__)
//#else
//#define NSLog(...) {}
//#endif


#pragma mark - 系统版本号判断
//系统版本号判断
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



#pragma mark - 判断设备
//是否为iphone5
#define IS_IPHONE5 ([UIScreen mainScreen].bounds.size.height == 568)

//设备屏幕大小
#define kHeight_StatusBar 20
#define kHeight_Navbar 44

#define kBounds_Screen [UIScreen mainScreen].bounds
#define kWidth_Screen ((!isIOS8) ? kBounds_Screen.size.height : kBounds_Screen.size.width)
#define kHeight_Screen ((isIOS6 ||isIOS7) ? (kBounds_Screen.size.width - kHeight_Statuebar) : (isIOS7Above ? (kBounds_Screen.size.height - kHeight_Statuebar) : kBounds_Screen.size.height))
#define kBounds_Screen_Fixed CGRectMake(kBounds_Screen.origin.x, kBounds_Screen.origin.y, kWidth_Screen, kHeight_Screen)

