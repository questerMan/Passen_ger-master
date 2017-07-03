//
//  Header.h
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-3.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#ifndef DriverProject_Header_h
#define DriverProject_Header_h


#endif

#ifdef __OBJC__
#import "UILabel+MapLable.h"
#import "QiFacade+postdemol.h"
#import "QiFacade+getmodel.h"
#import "QiFacade+putmodel.h"
#import "NSDate+TimeConversion.h"
#import "MAPHeader.h"
#endif


#define PLIST [NSUserDefaults standardUserDefaults]

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithHexString:rgbValue alpha:1.0]

//适配
#define MATCHSIZE(px) ([@"iPad" isEqualToString:[[UIDevice currentDevice] model]]? px*(SCREEN_W/750) : (SCREEN_W == 414)? px*414/750.0 : (SCREEN_W == 375)? px*0.5 : px*320/750.0)

//屏幕尺寸大小
#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

//  常见属性的设置
#define TEXTFIELD_HEIGHT                44
#define TABLEVIEWCELL_HEIGHT            44
#define CORNER_RADIUS                   4

#define FF                              0.5           //  大小与像素比例

//屏幕长宽
#define ViewHeight [[UIScreen mainScreen] bounds].size.height
#define ViewWidth  [[UIScreen mainScreen] bounds].size.width

//系统版本
#define IOS8LESS    [[[UIDevice currentDevice]systemVersion] floatValue] < 8.0
#define IOS7LATER   [[[UIDevice currentDevice]systemVersion] floatValue] > 7.0
#define IOS8LATER    [[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0
#define IOS9LATER   [[[UIDevice currentDevice]systemVersion] floatValue] >= 9.0

//4,4s
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
//5.5s
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//6
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

//6p
#define iPhone6p ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

//  定义UI部件之间的距离
#define GAP2                            2
#define GAP4                            4
#define GAP8                            8
#define GAP16                           16
#define GAP20                           20
#define GAP32                           32

//  定义字体大小
#define FONT8                           8
#define FONT10                          10
#define FONT12                          12
#define FONT14                          14
#define FONT16                          16

//  一些公用图片
#define RIGHT_ARROW_IMAGE               @"right_arrow.png"
#define ROUND_CIRCLE_IMAGE              @"round_circle.png"
#define CIRCLE_ARROW_IMAGE              @"circle_arrow.png"
#define RIGHT_STANDARD_IMAGE            @"right_standard_arrow.png"

//  状态图片
#define IMAGE_WAIT                  [UIImage imageNamed:@"engage_wait.png"]
#define IMAGE_SUCCESS               [UIImage imageNamed:@"engage_success.png"]
#define IMAGE_SUCCESS_EXPIRE        [UIImage imageNamed:@"engage_success_expire.png"]
#define IMAGE_CANCEL                [UIImage imageNamed:@"engage_cancel.png"]
#define IMAGE_FAIL                  [UIImage imageNamed:@"engaga_fail.png"]

//  公用颜色
#define TINT_COLOR                  [UIColor colorWithRed:231.0/255.0 green:139.0/255.0 blue:8.0/255.0 alpha:1.0]
#define NAV_BAR_TINT_COLOR          [UIColor colorWithRed:68.0/255.0 green:158.0/255.0 blue:254.0/255.0 alpha:1.0]
//  灰色字体颜色
#define TEXT_COLOR                  [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1];

//  灰色背景
#define BG_COLOR                    [UIColor colorWithRed:240/255.0 green:239/255.0 blue:245/255.0 alpha:1]
#define GRAY_TEXT_COLOR             [UIColor colorWithRed:140/255. green:140/255. blue:140/255. alpha:1.]
#define GRAY_LAYER_COLOR            [UIColor colorWithRed:218/255. green:218/255. blue:218/255. alpha:1.].CGColor

#define TEXT_GARY_COLOR             [UIColor colorWithRed:67.0/255.0 green:113.0/255.0 blue:124.0/255.0 alpha:1]

#define BG_COLOR_VIEW               [UIColor colorWithRed:249.0/255 green:250.0/255 blue:251.0/255 alpha:1]

#define BG_COLOR_GRAY               [UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1]

#define COLOR_LINE            RGB(235, 236, 237)
#define COLOR_ORANGE          RGB(242, 149, 45)

/*!
 将存放在NSUserDefaults中
 */
//  判断是否第一次运行
#define NOT_FIRST_RUN                   @"notFirstRun"

//  存放用户信息
#define PASSWORD                        @"password"
#define LOGIN_SUCCESS                   @"login_success"
#define LOGOUT_NOW                      @"logout_now"

//  存放个人信息(UD -- userDefault)
#define UD_NICK_NAME                    @"nickname"
#define UD_SEX                          @"sex"
#define UD_PORTRAIT                     @"portrait"
#define IF_TEST                         @"2"
//  >>> 暂时没用上
//  存储UI信息
#define NAVIGATIONBAR_HEIGHT            @"navigationbar_height"             //  导航栏高度
#define STATUS_NAVIGATIONBAR_HEIGHT     @"status_navigationbar_height"                //
#define TABBAR_HEIGHT                   @"tabbar_height"                    //  TabBar栏高度
#define STATUSBAR_HEIGHT                @"statusbar_height"                 //  顶部状态栏高度


//  存储UI信息（用于矩阵字典中）     在矩阵字典中使用后面部分
#define NAVBAR_H                        @"navbar_H"
#define STATUS_NAV_BAR_H                @"status_nav_bar_H"
#define TABBAR_H                        @"tabbar_H"
#define STATUSBAR_H                     @"statusbar_H"


/*!
 将存放在字典中
 */
//  用于json解析

#define GET_USER_INFO                   @"get_user_info"
#define GET_BUI_INFO                    @"get_bui_info"


//  “我的定一定” 现在 数据
#define Kindent_now_list            @"indent_now_list_path.xml"

//服务电话
#define ServicePhone            @"4008228846"
//取消、投诉
#define Title_key               @"title"
#define Question_key            @"question"
#define ButtonArray_key         @"buttonArray"
#define TextInput_key           @"textInput"
#define SubmitButton_key        @"submit"

//公用弹出页面
#define UTIL_USE_CAR_TYPE       @"util_use_car_type"
#define UTIL_BOOK_CAR_TYPE      @"util_book_car_type"
#define UTIL_TITLE_KEY          @"util_title_key"
#define UTIL_BUTTON_ARRAY_KEY          @"util_button_key"
#define UTIL_SUMBIT_KEY          @"util_sumbit_key"
#define UTIL_BUTTON_LOGOIMG         @"util_button_logoimg"
#define UTIL_BUTTON_TITLE           @"util_button_title"

//订单类型
#define ORDER_TYPE_KEY              @"order_type_key"
#define ORDER_TYPE_A                @"1"
#define ORDER_TYPE_B                @"2"
#define ORDER_TYPE_C                @"3"
#define ORDER_TYPE_D                @"4"

//订单状态
#define ORDER_STATUS_A              0        //下单
#define ORDER_STATUS_B              1        //司机应单
#define ORDER_STATUS_C              2        //司机发车
#define ORDER_STATUS_D              3        //司机到达上车点
#define ORDER_STATUS_E              4        //乘客上车行驶
#define ORDER_STATUS_G              5        //下车等待付款
#define ORDER_STATUS_H              6        //现金
#define ORDER_STATUS_K              7        //ping
#define ORDER_STATUS_I              9        //预约

//司机信息
#define DRIVER_NAME_KEY             @"nickname"
#define DRIVER_CAR_KEY              @"driver_car_key"
#define DRIVER_STAR_KEY             @"star"
#define DRIVER_ORDER_COUNT_KEY      @"order_num"
#define DRIVER_PHONE_NUMBER_KEY     @"driver_phone_number_key"
#define DRIVER_CANCEL_REASON        @"driver_cancel_reason"

//优惠券类型
#define COUPON_TYPE_FIRSTORDER      @"coupon_type_firstorder"
#define COUPON_TYPE_FESTIVAL        @"coupon_type_festival"
#define COUPON_TYPE_VOUCHER         @"coupon_type_voucher"

//支付详情页面类型
#define PAYVIEW_PAGETYPE_PAYBEFORE      @"paybefore"
#define PAYVIEW_PAGETYPE_PAYAFTER       @"payafter"

//空值
#define NULL_DATA                   @" "

//通知
#define NOTIFICATION_LOGIN_SUCCESS      @"notification_login_success"
#define NOTIFICATION_LOGIN_FAILURE      @"notification_login_failure"
#define NOTIFICATION_USER_DATA_CHANGE   @"notification_user_data_change"
#define NOTIFICATION_PAY_STATUS         @"notification_pay_status"

#define Search_User @"m.php/user/search"

#define PLIST [NSUserDefaults standardUserDefaults]
#define SVPERROR [SVProgressHUD showErrorWithStatus:@"对不起！出了点小错，工程师正在玩命修复。"];
#define SVPERRORDET [SVProgressHUD showErrorWithStatus:[result objectForKey:@"M"]];
#define KEY_ACTIVITY_LAST_TIME          @"ACTIVITY_LAST_TIME"
#define THEUSERNAME                     @"user_name"
#define THEPASSWORD                     @"pass_word"
#define THEUDID                         @"phone_udid"
#define THE_NEEDPASSWORD                @"net_password"
#define BTHEUSERNAME                    @"buser_name"
#define BTHEPASSWORD                    @"bpass_word"
#define TOKENKEY                        @"tokenkey"
#define BTOKENKEY                       @"btokenkey"
#define MEMBERINFO                      @"ismember"
#define HAVETABBAR                      @"1"
#define HAVENOTTABBAR                   @"0"
#define LASTPHONENUMBER                 @"lastPhoneNumber"

#define ADDRESS_UPDATE                  @"addr_update"
#define ENVIRONMENT                     @"ENVIRONMENT"           //1是正式服   2是测试服
//1是个人版  2代表企业版本
#define PERSON_YES                      1

//联系我们
#define CONTACT_APT                     @"https://www.gaclixin.com/help/contact.html"

//使用帮助
#define USER_MANUAL_API                 @"https://www.gaclixin.com/help/user_manual.html"

//用户协议
#define USER_AGREEMENT_API              @"https://www.gaclixin.com/help/user_policy.html"

//计价规则
#define VALUATION_RULES_API             @"https://www.gaclixin.com/help/price.html"

//后台接口
#define SEVER_API                       @"https://passenger.api.gaclixin.com"
//正式环境：http://passenger.api.gaclixin.com
//测试环境：http://passenger.api.dev.gaclixin.com

//支付接口
#define PAY_SEVER_API                   @"http://pay.gaclixin.com/wepay/"
//#define SEVER_API                       [PLIST objectForKey:ENVIRONMENT]

//版本号
#define PVC_VALUE                       @"1"

//UA 平台
#define UA_VLAUE                        @"ios"

#define WX_APPID                        @"wx9cad54f0db833982"//微信分配的公众账号ID
#define WX_PARTERID                     @""//微信支付分配的商户号
#define WX_PACKAGE                      @"Sign=WXPay"//扩展字段 暂填写固定值Sign=WXPay

#define BUS_LOGIN                       @"BUSLOGIN"
#define API_VERISION_NUM                @"30"
#define API_VERISION                    [NSString stringWithFormat:@"V=%@",API_VERISION_NUM]
#define GET_NEEDPASSWORD                [[PLIST objectForKey:THE_NEEDPASSWORD] intValue]
#define THE_BUSNOREAD                   [NSString stringWithFormat:@"%@_busnoread%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]
#define THE_USERNOREAD                  [NSString stringWithFormat:@"%@_usernoread%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]

#define THECART                         [NSString stringWithFormat:@"%@cart%@_",[PLIST objectForKey:THEUSERNAME],SEVER_API]
#define THEADDRESS                      [NSString stringWithFormat:@"%@_myaddress%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]
//当前位置
#define THECURRENTADDRESS               [NSString stringWithFormat:@"%@_mycurrentaddress%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]
//所选择城市
#define THESELECTCITY                   [NSString stringWithFormat:@"_selectcity"]
//启动应用的首次
#define THEFIRSTOPENAPP                 [NSString stringWithFormat:@"THEFIRSTOPENAPP"]
#define THEFIRSTLOC                     [NSString stringWithFormat:@"%@_firstloc%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]
#define BANK_CARD_NAME                  [NSString stringWithFormat:@"%@_backcardname%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]
#define BANK_CARD_TYPE                  [NSString stringWithFormat:@"%@_backcardtype%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]
#define BANK_CARD_NUM                   [NSString stringWithFormat:@"%@_backcardNum%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]
#define SHOWSHARE                       [NSString stringWithFormat:@"%@showshare%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]
//最后弹出商家详情页
#define LASTTIME                        [NSString stringWithFormat:@"%@lasttime%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]
//最后弹出网络激活成功的文字
#define LASTONLINETIME                  [NSString stringWithFormat:@"%@lastonlinetime%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]


#define LASTLCACTION                    [NSString stringWithFormat:@"%@LASTLCACTION%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]
#define ROOM                            [NSString stringWithFormat:@"%@ROOM%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]
#define RoutersBus                      [NSString stringWithFormat:@"%@RoutersBus%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]
#define HAVEMESSAGE                     [NSString stringWithFormat:@"%@HAVEMESSAGE%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]
#define FIRSTOPEN                       [NSString stringWithFormat:@"%@FIRSTOPEN%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]

//人均水平缓存值
#define RG                              [NSString stringWithFormat:@"%@RG%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]
//急送分类缓存值
#define KW                              [NSString stringWithFormat:@"%@KW%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]
//距离分类缓存值
#define FL                              [NSString stringWithFormat:@"%@FL%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]


#define TAKEOUTFL                       [NSString stringWithFormat:@"%@TAKEOUTFL%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]
#define TAKEOUTRG                       [NSString stringWithFormat:@"%@TAKEOUTRG%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]
#define TAKEOUTKW                       [NSString stringWithFormat:@"%@TAKEOUTKW%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]


#define ThemeColor                      [[[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"stye" ofType:@"plist"]] objectForKey:@"ThemeColor"]


#define ONLINESTATUS                    @"ONLINESTATUS"
#define SERVERMAC                       @"SERVERMAC"
#define SERVERWAN                       @"SERVERWAN"
#define SERVERLAN                       @"SERVERLAN"
#define THESERVERIP                     @"THESERVER_IP"
#define BID                             @"THE_BID"
#define BKEY                            @"THE_KEY"
#define MYIPHONEMAC                     @"THE_IPHONE_MAC"
#define GETDAGAERROR                    @"GETDAGAERROR"
#define HOMEPAGEKEY                     [NSString stringWithFormat:@"%@HOMEPAGEKEY%@",[PLIST objectForKey:THEUSERNAME],SEVER_API]
#define TYPETD                          @"TYPETD"
#define TYPELK                          @"TYPELK"
#define THEMONEY                        @"THEMONEY"
#define BUSDATA                         @"BUSDATA"
#define MOBCHECK                        @"MOBCHECK"
#define CANSHARE                        @"CANSHARE"
//定位成功，位置发生改变
#define LOACSUCCE                       @"LOACSUCCE"
//定位失败
#define LOACFAIL                        @"LOACFAIL"
//定位成功，位置未发生改变
#define LOACSUCCENOCHANCE               @"LOACSUCCE"
//是否切换位置
#define CHANCELOACSUCCENO               @"CHANCELOACSUCCENO"
//是否开启定位
#define LOACON                          @"LOACON"



#define CUSTOM_NAV_HEIGHT               60                   //  导航栏的高度
#define CUSTOM_TAB_TO_DELETE            110                  // tableView的高度需要减去的值

#define WX_SHARE_SUCCESS                @"WeiXinShareSuccess"
#define WX_SHARE_FAILED                 @"WeiXinShareFailed"
#define SINA_WEIBO_SHARE_SUCCESS        @"SinaWeiboShareSuccess"
#define SINA_WEIBO_SHARE_FAILED         @"SinaWeiboShareFailed "
#define hWX_SHARE_SUCCESS               @"hWeiXinShareSuccess"
#define hWX_SHARE_FAILED                @"hWeiXinShareFailed"
#define hSINA_WEIBO_SHARE_SUCCESS       @"hSinaWeiboShareSuccess"
#define hSINA_WEIBO_SHARE_FAILED        @"hSinaWeiboShareFailed "
#define WIFICHACE                       @"WIFICHACE"
#define GETMACFAIL                      @"GETMACFAIL"
#define GETMACSUCCESS                   @"GETMACSUCCESS"
#define BUI_ID_CHANGE                   @"ChangeStoreId"
#define GET_COUPON                      @"getCoupon"
#define NEED_RELOAD                     @"needReload"
#define WEB_RELOAD                      @"webReload"
#define LOADNEWWEB                      @"loadnewweb"
#define STOREHOME                       @"storeHome"





//get_address
//refusal


#define KScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define KScreenHeight  [[UIScreen mainScreen] bounds].size.height



//展开文字和压缩文字高度差
#define KAddHeight  self.currentHeight - self.initHeight
#define KInitStoreInfoHeight 95
#define KStoreInfoHeightAndConnectViewHeight 95+40

#define KConnectionViewHeight 40



//////////////////////////////////////////////////////
//记录当前cell是否是展开状态
//static BOOL isUnfold;

#define kSectionButtonHeight 35
#define KStoreImageWidth 87
#define KAddressTitleWidth 45
//#define KAddressContentWidth KScreenWidth-(_storeImage.frame.size.width+14)-20-45
#define KAddressContentWidth KScreenWidth-166

#define KConnectionViewHeight 40
#define KDishesCellHeight 60


//  成功、确认中、待支付、已到店、已取消、失败
#define XS_IMAGE_SUCCESS               [UIImage imageNamed:@"成功.png"]
#define XS_IMAGE_CONFIRMING            [UIImage imageNamed:@"确认中.png"]
#define XS_IMAGE_NEEDS_PAY             [UIImage imageNamed:@"待支付.png"]
#define XS_IMAGE_REACHED               [UIImage imageNamed:@"已到店.png"]
#define XS_IMAGE_CANCELED              [UIImage imageNamed:@"已取消.png"]
#define XS_IMAGE_FAIL                  [UIImage imageNamed:@"失败.png"]

#define AUTH_KEY    @"c84999f738ec6b"//密码加密KEY


#define FONT(x)                         [UIFont systemFontOfSize:x]
#define DEFAULTS                        [NSUserDefaults standardUserDefaults]
#define SCREEN_H                        [UIScreen mainScreen].bounds.size.height
#define SCREEN_W                        [UIScreen mainScreen].bounds.size.width
#define ViewBounds                      self.view.bounds.size.height

#define DEAD_ERROR                      @"对不起！出了点小错，工程师真在玩命修复！";

//带有RGBA的颜色设置
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]


#define FRAME(A,B,C,D)                      CGRectMake(A,B,C,D)



//颜色
//主蓝色
#define Main_COLOR                 [UIColor colorWithRed:(float)0x3a/255 green:(float)0xb4/255 blue:(float)0x8f/255 alpha:1]

//普通文字 黑色
#define Textblack_COLOR                 [UIColor colorWithRed:(float)0x21/255 green:(float)0x21/255 blue:(float)0x21/255 alpha:1]

//减淡文字 黑色
#define Textgray_COLOR                 [UIColor colorWithRed:(float)0x72/255 green:(float)0x72/255 blue:(float)0x72/255 alpha:1]

//禁用文字 提示文字 黑色
#define TextDisable_COLOR                 [UIColor colorWithRed:(float)0xb6/255 green:(float)0xb6/255 blue:(float)0xb6/255 alpha:1]

//分割线 黑色
#define Dividingline_COLOR                 [UIColor colorWithRed:(float)0xd8/255 green:(float)0xd8/255 blue:(float)0xd8/255 alpha:1]

//底色
#define Background_COLOR                 [UIColor colorWithRed:(float)0xfa/255 green:(float)0xfa/255 blue:(float)0xfa/255 alpha:1]


//高亮文字 图标 橙色
#define Assist_COLOR                 [UIColor colorWithRed:(float)0xf4/255 green:(float)0x94/255 blue:(float)0x2d/255 alpha:1]


//普通文字 白色
#define Textwhite_COLOR                 [UIColor colorWithRed:(float)0xff/255 green:(float)0xff/255 blue:(float)0xff/255 alpha:1]

//减淡文字 白色
#define Textlightwhite_COLOR                 [UIColor colorWithRed:(float)0xfc/255 green:(float)0xfc/255 blue:(float)0xfc/255 alpha:1]

//禁用文字 提示文字 白色
#define TextwhiteDisable_COLOR                 [UIColor colorWithRed:(float)0xf9/255 green:(float)0xf9/255 blue:(float)0xf9/255 alpha:1]

//分割线 白色
#define whiteDividingline_COLOR                 [UIColor colorWithRed:(float)0xf9/255 green:(float)0xf9/255 blue:(float)0xf9/255 alpha:1]

//辅色 蓝色
#define AssistMain_COLOR                 [UIColor colorWithRed:(float)0x0e/255 green:(float)0x8b/255 blue:(float)0x65/255 alpha:1]

//线的高度
#define LINE_HEIGHT   (1.0f/[[UIScreen mainScreen]scale])

//规范小数点后两位
#define FAMAT_NUM(a) [NSString stringWithFormat:@"%0.2f",[a doubleValue]]





