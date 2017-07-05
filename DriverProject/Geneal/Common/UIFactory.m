//
//  UIFactory.m
//  MarketingManagement
//
//  Created by Good idea-杰 on 14-4-30.
//  Copyright (c) 2014年 ___GoodIdea168___. All rights reserved.
//

#import "UIFactory.h"
#import <OpenUDID.h>
#import <CommonCrypto/CommonDigest.h>

@implementation UIFactory

+ (NSString*)deviceString
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    return deviceString;
}

+(UIButton *)createTheCircleViewWithBorderColor:(UIColor *)color AndBorderWidth:(CGFloat)width  WithTarget:(id)target AndAction:(SEL)action ByTag:(int)tag
{
    UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
    view.tag = tag;
    [view.layer setCornerRadius:30];
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = width;
    view.layer.borderColor = color.CGColor;
    [view addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return view;
}

+(UIView *)createLineView
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = RGB(235, 236, 237);
    
    return view;
}

+(UIButton *)createButton:(NSString *)title BackgroundColor:(UIColor*)bgColor andTitleColor:(UIColor *)titleColor
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button.layer setCornerRadius:5];
    button.backgroundColor = bgColor;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    
    return button;
}

+(void)callThePhone:(NSString *)phone
{
    NSString *callPhone = [NSString stringWithFormat:@"tel:%@",phone];
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
}

+(UIButton *)createButton:(UIImage *)image
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    return button;
}

+(UIImageView*)createTopImageViewWithImgName:(NSString *)imgName
{
    UIImageView *topView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgName]];
    topView.userInteractionEnabled = YES;
    return topView;
}

+(UILabel *)createLabel:(NSString *)text Font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    [label setFont:font];
    
    return label;
}

+(UIScrollView *)createScrollViewWithContentSize:(CGSize)contentSize;
{
    UIScrollView *itemsContent = [[UIScrollView alloc]init];
    itemsContent.contentSize = contentSize;
    
    return itemsContent;
}

+(UITextField *)createTextFieldWithFrame:(CGRect)frame ByDelegate:(id)delegate
{
    UITextField *txt = [[UITextField alloc]initWithFrame:frame];
    [txt setFont:[UIFont systemFontOfSize:12]];
    txt.delegate=delegate;
    
    return txt;
}

+(UITableView *)createTableView
{
    UITableView *table = [[UITableView alloc]init];
    return table;
}

+ (void)SaveNSUserDefaultsWithData:(id)data AndKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if (data != nil) {
        
        [userDefaults setObject:data forKey:key];

    }else{
        
        [userDefaults setObject:NULL_DATA forKey:key];
    }
    
    [userDefaults synchronize];
}

+(void)DeleteAllNSUserDefaults
{
    NSUserDefaults *userDefatluts = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [userDefatluts dictionaryRepresentation];
    for(NSString* key in [dictionary allKeys]){
        [userDefatluts removeObjectForKey:key];
        [userDefatluts synchronize];
    }
}

+ (void)DeleteAllSaveDataNSUserDefaults{
    
    NSString* deviceToken = [self getNSUserDefaultsDataWithKey:@"deviceToken"];
    
    NSString* fee = [self getNSUserDefaultsDataWithKey:@"processfee"];
    NSString* km = [self getNSUserDefaultsDataWithKey:@"km"];
    NSString* min = [self getNSUserDefaultsDataWithKey:@"min"];
    
    NSUserDefaults *userDefatluts = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [userDefatluts dictionaryRepresentation];
    for(NSString* key in [dictionary allKeys]){
        [userDefatluts removeObjectForKey:key];
        [userDefatluts synchronize];
    }
    
    [self SaveNSUserDefaultsWithData:deviceToken AndKey:@"deviceToken"];
    
    [self SaveNSUserDefaultsWithData:fee AndKey:@"processfee"];
    [self SaveNSUserDefaultsWithData:km AndKey:@"km"];
    [self SaveNSUserDefaultsWithData:min AndKey:@"min"];
}


+(id)getNSUserDefaultsDataWithKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults objectForKey:key]) {
        
        return (id)[userDefaults objectForKey:key];
    }else{
        
        return @" ";
    }
    
}

+ (BOOL)isCompany
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"company"] == nil || [[userDefaults objectForKey:@"company"] isEqualToString:NULL_DATA]) {
        
        return NO;
    }
    
    return YES;
}

+(BOOL)isLoginOrNot
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults objectForKey:@"uuid"] && [userDefaults objectForKey:@"access_token"]) {
        
        return YES;
    }
    
    return NO;
}

+(NSString *)theUUID
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return (NSString *)[userDefaults objectForKey:@"uuid"];
}

+(NSString *)theAccess_Token
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return (NSString *)[userDefaults objectForKey:@"access_token"];
}

+(NSDictionary *)getSignDictionaryAndPhone:(NSString *)phone password:(NSString *)password vcode:(NSString *)code
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* deviceToken = [UIFactory getNSUserDefaultsDataWithKey:@"deviceToken"];
    NSString *signTemp;
    if ([userDefaults objectForKey:@"access_token"] && ![[userDefaults objectForKey:@"access_token"] isEqualToString:NULL_DATA]) {
        
        signTemp = [[NSString stringWithFormat:@"password%@phone%@phoneid%@pvc%@timestamp%ldua%@vcode%@%@",password,phone,deviceToken,PVC_VALUE,(long)[[NSDate  date] timeIntervalSince1970],UA_VLAUE,code,[userDefaults objectForKey:@"access_token"]] uppercaseString];
    }else{
        
        signTemp = [[NSString stringWithFormat:@"password%@phone%@phoneid%@pvc%@timestamp%ldua%@vcode%@",password,phone,deviceToken,PVC_VALUE,(long)[[NSDate  date] timeIntervalSince1970],UA_VLAUE,code] uppercaseString];
    }
    
    const char *cStr = [[signTemp uppercaseString] UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (uint32_t)[signTemp uppercaseString].length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [result appendFormat:@"%02x", digest[i]];
    }
    NSString *sign = result;
    
    NSString *timestamp = [NSString stringWithFormat:@"%ld",(long)[[NSDate  date] timeIntervalSince1970]];
    NSDictionary *signDic = [NSDictionary dictionaryWithObjectsAndKeys:password,@"password",code,@"vcode",sign,@"sign",UA_VLAUE,@"ua",phone,@"phone",deviceToken,@"phoneid",timestamp,@"timestamp",PVC_VALUE,@"pvc", nil];
    
    NSLog(@"签名字典：%@",signDic);
    
    return signDic;
}

- (NSString *)getMd5_32Bit:(NSString *)input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (uint32_t)input.length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}

+(NSString *)theUserName
{
    NSUserDefaults *usr = [NSUserDefaults standardUserDefaults];
//    NSMutableDictionary *userInfo = [usr objectForKey:@"userinfo"];
    return (NSString *)[usr objectForKey:@"username"];
}

+(NSString *)thePhoneNum
{
    NSUserDefaults *usr = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [usr objectForKey:@"userinfo"];
    return (NSString *)[userDic objectForKey:@"phonenum"];
}

+(NSString *)theUserID
{
    NSUserDefaults *usr = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [usr objectForKey:@"userinfo"];
    return (NSString *)[userDic objectForKey:@"uid"];
}

+ (NSString *)thePosition
{
    NSUserDefaults *usr = [NSUserDefaults standardUserDefaults];
    NSDictionary *userDic = [usr objectForKey:@"userinfo"];
    return (NSString *)[userDic objectForKey:@"position"];
}

//写入文件到手机以备上传
+ (BOOL)wirteToDocument:(NSArray *)data path:(NSString *)path
{
    NSString *filePath=[self dataFilePath:path];
    NSLog(@"--文件目录地址--\n%@",filePath);
    
    BOOL iswrite =  [data writeToFile:filePath atomically:YES];
    return iswrite;
}

//读取文件
+ (NSArray *)readFromDocument:(NSString *)path
{
    NSString *filePath=[self dataFilePath:path];
    NSLog(@"--文件目录地址--\n%@",filePath);
    NSArray *arr = [[NSArray alloc]initWithContentsOfFile:filePath];
    return arr;
}

//文件路径
+(NSString*)dataFilePath:(NSString *)path
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doucumentsDirectory=[paths objectAtIndex:0];
    return [doucumentsDirectory stringByAppendingPathComponent:path];
}
@end
