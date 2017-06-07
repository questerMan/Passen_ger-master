//
//  UIFactory.h
//  MarketingManagement
//
//  Created by Good idea-杰 on 14-4-30.
//  Copyright (c) 2014年 ___GoodIdea168___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sys/utsname.h"

@interface UIFactory : NSObject<UITextFieldDelegate>

/**
 *  创建一个灰线
 *
 *  @return View
 */
+(UIView *)createLineView;

/**
 *  返回设备
 *
 *  @return nsstring
 */
+ (NSString*)deviceString;

/**
 *  创建一个圆形的view
 *
 *  @return UIview
 */
+(UIButton *)createTheCircleViewWithBorderColor:(UIColor *)color AndBorderWidth:(CGFloat)width  WithTarget:(id)target AndAction:(SEL)action ByTag:(int)tag;

/**
 *  打电话
 *
 *  @param phone
 */
+(void)callThePhone:(NSString *)phone;

//创建按钮(无图)
+(UIButton *)createButton:(NSString *)title BackgroundColor:(UIColor*)bgColor andTitleColor:(UIColor *)titleColor;

//创建按钮(有图)
+(UIButton *)createButton:(UIImage *)image;

//创建顶部栏
+(UIImageView*)createTopImageViewWithImgName:(NSString *)imgName;

//创建Label
+(UILabel *)createLabel:(NSString *)text Font:(UIFont *)font;

//创建ScrollView
+(UIScrollView *)createScrollViewWithContentSize:(CGSize)contentSize;

//创建文本框
+(UITextField *)createTextFieldWithFrame:(CGRect)frame ByDelegate:(id)delegate;

//创建表格
+(UITableView *)createTableView;

/**
 *  保存NSUserDefaults
 *
 *  @param data data
 *  @param key  key
 */
+(void)SaveNSUserDefaultsWithData:(id)data AndKey:(NSString *)key;

/**
 *  清空NSUserDefaults
 */
+(void)DeleteAllNSUserDefaults;

/**
 *  获取指定的NSUserDefaults中保存的值
 *
 *  @param key key
 *
 *  @return 
 */
+(id)getNSUserDefaultsDataWithKey:(NSString *)key;

/**
 *  检测是否已登录
 *
 *  @return 检测标准为NSUserDefaults中的UUID和Token是否为空
 */
+(BOOL)isLoginOrNot;

/**
 *  检测是否为企业账户
 *
 *  @return 判断company是否为空
 */
+(BOOL)isCompany;
/**
 *  获取UUID
 *
 *  @return
 */
+(NSString *)theUUID;

/**
 *  获取Access_Token；
 *
 *  @return 
 */
+(NSString *)theAccess_Token;

//获取签名验证信息
+(NSDictionary *)getSignDictionary;

//获取用户名
+(NSString *)theUserName;

//获取用户id
+(NSString *)theUserID;

//获取手机号码
+(NSString *)thePhoneNum;

//获取职位
+(NSString *)thePosition;

//写入文件到手机以备上传
+ (BOOL)wirteToDocument:(id)data path:(NSString *)path;
//读取文件
+ (NSArray *)readFromDocument:(NSString *)path;

//文件路径
+(NSString*)dataFilePath:(NSString *)path;
@end
