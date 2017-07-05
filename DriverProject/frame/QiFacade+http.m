//
//  QiFacade+http.m
//  77net
//
//  Created by liyy on 14-4-9.
//  Copyright (c) 2014年 77. All rights reserved.
//

#import "QiFacade+http.h"
#import "newLoginViewController.h"
//#import "QiFacade+account.h"
//#import "UIDevice_GUniqueIdentifier.h"
//#import "NSString+QiEncoding.h"
//#import "NSString+json.h"
//#import "Util.h"


#define HTTP_REQUEST_TIME_OUT 15

@implementation QiFacade (http)

#pragma mark - 基本功能接口


-(QiHttpRequest*)httpRequestDelete:(NSString*)strUrl
                          paraDict:(NSDictionary*)paraDict
                          userInfo:(NSDictionary*)userInfo
{
    NSLog(@"REQUEST data:%@---%@", strUrl, paraDict);
    
    if (strUrl == nil)
    {
        return nil;
    }
    
    //拼接请求参数
    NSArray* keyArray = [paraDict allKeys];
    NSString* strKey = nil;
    NSString* strVal = nil;
    
    if ([keyArray count] > 0)
    {
        strUrl = [strUrl stringByAppendingString:@""];
    }
    
    for (int i = 0; i < [keyArray count]; ++i)
    {
        strKey = [keyArray objectAtIndex:i];
        strVal = [paraDict objectForKey:strKey];
        if(i==([keyArray count]-1))
        {
            strUrl = [strUrl stringByAppendingFormat:@"%@=%@", strKey, strVal];
        }
        else
        {
            strUrl = [strUrl stringByAppendingFormat:@"%@=%@&", strKey, strVal];
        }
    }
    NSLog(@"REQUEST URL: %@\nUUID:%@\nToken:%@",strUrl,[UIFactory getNSUserDefaultsDataWithKey:@"uuid"],[UIFactory getNSUserDefaultsDataWithKey:@"access_token"]);
    
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURL* usrString = [NSURL URLWithString:strUrl];
    
    QiHttpRequest* request = [[QiHttpRequest alloc] initWithURL:usrString];
    
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:HTTP_REQUEST_TIME_OUT];
    [request setUserInfo:userInfo];
    
    [request setRequestMethod:@"DELETE"];
    [request setUserAgentString:[ToolObject getuseragernt]];
    
    //添加基础参数+++++++
    [request setAuthenticationScheme:(NSString *)kCFHTTPAuthenticationSchemeBasic];
    request.shouldPresentCredentialsBeforeChallenge = YES;          //  NO 表示取消Basic验证
    [request addBasicAuthenticationHeaderWithUsername:[UIFactory getNSUserDefaultsDataWithKey:@"uuid"] andPassword:[UIFactory getNSUserDefaultsDataWithKey:@"access_token"]];//这里的参数的每次登录成功返回的,所以需要从本地提取
    //设置请求tag
    request.tag = ++_iRequestTagCount;
    
    //http请求失败时统一处理
    __weak QiHttpRequest* safeRequest = request;
    [request setFailedBlock:^{
        
        id response = [safeRequest jsonValue];
        NSLog(@"REQUEST error:%@", response);
        
        [self dealRequestFail:response request:safeRequest];
        
        //移除观察者
        [self removerHttpObserverWithTag:safeRequest.tag];
        
    }];
    
    [_httpRequestQueue addOperation:request]; // 加入队列
    
    return request;
    
}
-(QiHttpRequest*)httpRequestPut:(NSString*)strUrl
                       paraDict:(NSDictionary*)paraDict
                       userInfo:(NSDictionary*)userInfo
{
    
    if (strUrl == nil)
    {
        return nil;
    }
    NSLog(@"REQUEST URL: %@\nUUID:%@\nToken:%@",strUrl,[UIFactory getNSUserDefaultsDataWithKey:@"uuid"],[UIFactory getNSUserDefaultsDataWithKey:@"access_token"]);
    
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURL* usrString = [NSURL URLWithString:strUrl];
    
    QiHttpRequest* request = [[QiHttpRequest alloc] initWithURL:usrString];
    
    [request setShouldAttemptPersistentConnection:NO];
    [request setRequestMethod:@"PUT"];
    [request setTimeOutSeconds:HTTP_REQUEST_TIME_OUT];
    [request setUserInfo:userInfo];
    [request setUserAgentString:[ToolObject getuseragernt]];
    
    //添加基础参数+++++++
    [request setAuthenticationScheme:(NSString *)kCFHTTPAuthenticationSchemeBasic];
    request.shouldPresentCredentialsBeforeChallenge = YES;          //  NO 表示取消Basic验证
    [request addBasicAuthenticationHeaderWithUsername:[UIFactory getNSUserDefaultsDataWithKey:@"uuid"] andPassword:[UIFactory getNSUserDefaultsDataWithKey:@"access_token"]];//这里的参数的每次登录成功返回的,所以需要从本地提取
    
    //添加请求参数
    NSArray* keyArray = [paraDict allKeys];
    NSString* strKey = nil;
    NSString* strVal = nil;
    for (int i = 0; i < [keyArray count]; ++i)
    {
        strKey = [keyArray objectAtIndex:i];
        strVal = [paraDict objectForKey:strKey];
        
        [request setPostValue:strVal forKey:strKey];
    }
    
    //设置请求tag
    request.tag = ++_iRequestTagCount;
    
    //http请求失败时统一处理
    __weak QiHttpRequest* safeRequest = request;
    [request setFailedBlock:^{
        
        id response = [safeRequest jsonValue];
        NSLog(@"REQUEST error:%@", response);
        
        [self dealRequestFail:response request:safeRequest];
        
        //移除观察者
        [self removerHttpObserverWithTag:safeRequest.tag];
        
    }];
    
    [_httpRequestQueue addOperation:request]; // 加入队列
    
    return request;
    
}
-(QiHttpRequest*)httpRequestPut:(NSString*)strUrl
                      paraArray:(NSArray*)paraArray
                       userInfo:(NSDictionary*)userInfo
{
    
    NSLog(@"REQUEST data:%@---%@", strUrl, paraArray);
    
    if (strUrl == nil)
    {
        return nil;
    }
    
    //拼接请求参数
    NSString* strVal = nil;
    if ([paraArray count] > 0)
    {
        strUrl = [strUrl stringByAppendingString:@""];
    }
    
    for (int i = 0; i < [paraArray count]; ++i)
    {
        strVal = [paraArray objectAtIndex:i];
        strUrl = [strUrl stringByAppendingFormat:@"/%@", strVal];
        
    }
    NSLog(@"REQUEST URL: %@\nUUID:%@\nToken:%@",strUrl,[UIFactory getNSUserDefaultsDataWithKey:@"uuid"],[UIFactory getNSUserDefaultsDataWithKey:@"access_token"]);
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURL* usrString = [NSURL URLWithString:strUrl];
    
    QiHttpRequest* request = [[QiHttpRequest alloc] initWithURL:usrString];
    
    [request setShouldAttemptPersistentConnection:NO];
    [request setRequestMethod:@"PUT"];
    [request setTimeOutSeconds:HTTP_REQUEST_TIME_OUT];
    [request setUserInfo:userInfo];
    [request setUserAgentString:[ToolObject getuseragernt]];
    //添加基础参数+++++++
    [request setAuthenticationScheme:(NSString *)kCFHTTPAuthenticationSchemeBasic];
    request.shouldPresentCredentialsBeforeChallenge = YES;          //  NO 表示取消Basic验证
    [request addBasicAuthenticationHeaderWithUsername:[UIFactory getNSUserDefaultsDataWithKey:@"uuid"] andPassword:[UIFactory getNSUserDefaultsDataWithKey:@"access_token"]];//这里的参数的每次登录成功返回的,所以需要从本地提取
    
    
    //设置请求tag
    request.tag = ++_iRequestTagCount;
    
    //http请求失败时统一处理
    __weak QiHttpRequest* safeRequest = request;
    [request setFailedBlock:^{
        
        id response = [safeRequest jsonValue];
        NSLog(@"REQUEST error:%@", response);
        
        [self dealRequestFail:response request:safeRequest];
        
        //移除观察者
        [self removerHttpObserverWithTag:safeRequest.tag];
        
    }];
    
    [_httpRequestQueue addOperation:request]; // 加入队列
    
    return request;
    
}



//+++++++++++++++++++++++++++++++++++++++++++
-(QiHttpRequest*)httpRequest:(NSString*)strUrl
                    paraDict:(NSDictionary*)paraDict
                    userInfo:(NSDictionary*)userInfo
{
    NSLog(@"REQUEST data:%@---%@", strUrl, paraDict);
    
    if (strUrl == nil)
    {
        return nil;
    }
    
    //拼接请求参数
    NSArray* keyArray = [paraDict allKeys];
    NSString* strKey = nil;
    NSString* strVal = nil;
    
    if ([keyArray count] > 0)
    {
        strUrl = [strUrl stringByAppendingString:@""];
    }
    
    for (int i = 0; i < [keyArray count]; ++i)
    {
        strKey = [keyArray objectAtIndex:i];
        strVal = [paraDict objectForKey:strKey];
        
        if(i==([keyArray count]-1))
        {
            strUrl = [strUrl stringByAppendingFormat:@"%@=%@", strKey, strVal];
        }
        else
        {
            strUrl = [strUrl stringByAppendingFormat:@"%@=%@&", strKey, strVal];
        }
    }
    
    /*=========================暂时屏蔽=====================
    strUrl = [strUrl stringByAppendingFormat:@"%@=%@&", strKey, strVal];
    for (int i = 0; i < [[[UIFactory getSignDictionary] allKeys] count]; i ++) {
        
        if(i==([[[UIFactory getSignDictionary] allKeys] count]-1))
        {
            strUrl = [strUrl stringByAppendingFormat:@"%@=%@", [[[UIFactory getSignDictionary] allKeys] objectAtIndex:i], [[[UIFactory getSignDictionary] allValues] objectAtIndex:i]];
        }
        else
        {
            strUrl = [strUrl stringByAppendingFormat:@"%@=%@&", [[[UIFactory getSignDictionary] allKeys] objectAtIndex:i], [[[UIFactory getSignDictionary] allValues] objectAtIndex:i]];
        }
    }
    =====================================================*/
    NSLog(@"REQUEST URL: %@\nUUID:%@\nToken:%@",strUrl,[UIFactory getNSUserDefaultsDataWithKey:@"uuid"],[UIFactory getNSUserDefaultsDataWithKey:@"access_token"]);
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURL* usrString = [NSURL URLWithString:strUrl];
    
    QiHttpRequest* request = [[QiHttpRequest alloc] initWithURL:usrString];
    
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:HTTP_REQUEST_TIME_OUT];
    [request setUserInfo:userInfo];
    
    [request setRequestMethod:@"GET"];
    [request setUserAgentString:[ToolObject getuseragernt]];
    
    //添加基础参数+++++++
    [request setAuthenticationScheme:(NSString *)kCFHTTPAuthenticationSchemeBasic];
    request.shouldPresentCredentialsBeforeChallenge = YES;          //  NO 表示取消Basic验证
    [request addBasicAuthenticationHeaderWithUsername:[UIFactory getNSUserDefaultsDataWithKey:@"uuid"] andPassword:[UIFactory getNSUserDefaultsDataWithKey:@"access_token"]];//这里的参数的每次登录成功返回的,所以需要从本地提取
    
    //设置请求tag
    request.tag = ++_iRequestTagCount;
    
    //http请求失败时统一处理
    __weak QiHttpRequest* safeRequest = request;
    [request setFailedBlock:^{
        
        id response = [safeRequest jsonValue];
        NSLog(@"REQUEST error:%@", response);
        
        [self dealRequestFail:response request:safeRequest];
        
        //移除观察者
        [self removerHttpObserverWithTag:safeRequest.tag];
        
    }];
    
    [_httpRequestQueue addOperation:request]; // 加入队列
    
    return request;
}

-(QiHttpRequest*)httpRequestGet:(NSString*)strUrl
                       paraDict:(NSArray*)paraArray
                       userInfo:(NSDictionary*)userInfo
{
    NSLog(@"REQUEST data:%@---%@", strUrl, paraArray);
    
    if (strUrl == nil)
    {
        return nil;
    }
    
    //拼接请求参数
    NSString* strVal = nil;
    if ([paraArray count] > 0)
    {
        strUrl = [strUrl stringByAppendingString:@""];
    }
    
    for (int i = 0; i < [paraArray count]; ++i)
    {
        strVal = [paraArray objectAtIndex:i];
        strUrl = [strUrl stringByAppendingFormat:@"/%@", strVal];
        
    }
    
    NSLog(@"REQUEST URL: %@\nUUID:%@\nToken:%@",strUrl,[UIFactory getNSUserDefaultsDataWithKey:@"uuid"],[UIFactory getNSUserDefaultsDataWithKey:@"access_token"]);
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSURL* usrString = [NSURL URLWithString:strUrl];
    
    QiHttpRequest* request = [[QiHttpRequest alloc] initWithURL:usrString];
    
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:HTTP_REQUEST_TIME_OUT];
    [request setUserInfo:userInfo];
    
    [request setRequestMethod:@"GET"];
    [request setUserAgentString:[ToolObject getuseragernt]];
    
    //添加基础参数+++++++
    [request setAuthenticationScheme:(NSString *)kCFHTTPAuthenticationSchemeBasic];
    request.shouldPresentCredentialsBeforeChallenge = YES;          //  NO 表示取消Basic验证
    [request addBasicAuthenticationHeaderWithUsername:[UIFactory getNSUserDefaultsDataWithKey:@"uuid"] andPassword:[UIFactory getNSUserDefaultsDataWithKey:@"access_token"]];//这里的参数的每次登录成功返回的,所以需要从本地提取
    
    //设置请求tag
    request.tag = ++_iRequestTagCount;
    
    //http请求失败时统一处理
    __weak QiHttpRequest* safeRequest = request;
    [request setFailedBlock:^{
        
        id response = [safeRequest jsonValue];
        NSLog(@"REQUEST error:%@", response);
        
        [self dealRequestFail:response request:safeRequest];
        
        //移除观察者
        [self removerHttpObserverWithTag:safeRequest.tag];
        
    }];
    
    [_httpRequestQueue addOperation:request]; // 加入队列
    
    return request;
}



//++++++++++++++++++++++++++++

-(QiHttpRequest*)httpRequestPost:(NSString*)strUrl
                        paraDict:(NSDictionary*)paraDict
                        userInfo:(NSDictionary*)userInfo
{
    NSLog(@"REQUEST data:%@---%@", strUrl, paraDict);
    
    if (strUrl == nil)
    {
        return nil;
    }
    
    NSURL* usrString = [NSURL URLWithString:strUrl];
    
    QiHttpRequest* request = [[QiHttpRequest alloc] initWithURL:usrString];
    
    [request setShouldAttemptPersistentConnection:NO];
    [request setRequestMethod:@"POST"];
    [request setTimeOutSeconds:HTTP_REQUEST_TIME_OUT];
    [request setUserInfo:userInfo];
    [request setUserAgentString:[ToolObject getuseragernt]];
    [request setValidatesSecureCertificate:NO];
    //添加请求参数
    NSArray* keyArray = [paraDict allKeys];
    NSString* strKey = nil;
    NSString* strVal = nil;
    for (int i = 0; i < [keyArray count]; ++i)
    {
        strKey = [keyArray objectAtIndex:i];
        strVal = [paraDict objectForKey:strKey];
        
        [request setPostValue:strVal forKey:strKey];
    }
    
    if (![[UIFactory getNSUserDefaultsDataWithKey:@"uuid"] isEqualToString:NULL_DATA] && ![[UIFactory getNSUserDefaultsDataWithKey:@"access_token"] isEqualToString:NULL_DATA]) {
        
        NSLog(@"REQUEST URL: %@\nUUID:%@\nToken:%@",strUrl,[UIFactory getNSUserDefaultsDataWithKey:@"uuid"],[UIFactory getNSUserDefaultsDataWithKey:@"access_token"]);
        
        //添加基础参数+++++++
        [request setAuthenticationScheme:(NSString *)kCFHTTPAuthenticationSchemeBasic];
        request.shouldPresentCredentialsBeforeChallenge = YES;          //  NO 表示取消Basic验证
        [request addBasicAuthenticationHeaderWithUsername:[UIFactory getNSUserDefaultsDataWithKey:@"uuid"] andPassword:[UIFactory getNSUserDefaultsDataWithKey:@"access_token"]];//这里的参数的每次登录成功返回的,所以需要从本地提取
    }
    
    
    //设置请求tag
    request.tag = ++_iRequestTagCount;
    
    //http请求失败时统一处理
    __weak QiHttpRequest* safeRequest = request;
    [request setFailedBlock:^{
        
        id response = [safeRequest jsonValue];
        NSLog(@"REQUEST error:%@", response);
        
        [self dealRequestFail:response request:safeRequest];
        
        //移除观察者
        [self removerHttpObserverWithTag:safeRequest.tag];
        
    }];
    
    [_httpRequestQueue addOperation:request]; // 加入队列
    
    return request;
}

//取消请求
-(void)cancelHttpRequestWithTag:(NSInteger)iRequestTag
{
    [_httpRequestQueue cancelHttpRquestWithTag:iRequestTag];
    
    //移除观察者
    [self removerHttpObserverWithTag:iRequestTag];
}

-(void)cancelHttpRequestWithObserver:(NSObject*)observer
{
    NSArray* keyArray = [_httpObserverDict allKeys];
    NSNumber* key = nil;
    NSMutableArray* delKeyArray = [NSMutableArray array];
    for (int i = 0; i < [keyArray count]; ++i)
    {
        key = [keyArray objectAtIndex:i];
        if ([_httpObserverDict objectForKey:key] == observer)
        {
            [_httpRequestQueue cancelHttpRquestWithTag:[key integerValue]];
            
            [delKeyArray addObject:key];
        }
    }
    
    [_httpObserverDict removeObjectsForKeys:delKeyArray];
    
}

-(void)cancelAllRequest
{
    //取消HTTP请求
    [_httpRequestQueue cancelAllRequest];
    
    //清空观察者
    [_httpObserverDict removeAllObjects];
    
    _iRequestTagCount = 0;
}

//判断请求是否成功
- (BOOL)requestSuccess:(NSDictionary*)response
{
    BOOL bSuccess = NO;
    if ([response isKindOfClass:[NSDictionary class]])
    {
        id value = [response objectForKey:@"code"];
        if ([value isKindOfClass:[NSNumber class]]
            || [value isKindOfClass:[NSString class]])
        {
            bSuccess = [value integerValue] == 1;
        }
    }
    
    return bSuccess;
}

- (id)parseServerData:(id)data key:(NSString*)strKey
{
    id object = nil;
    if ([data isKindOfClass:[NSDictionary class]]
        && [strKey length] > 0)
    {
        id vaule = [data objectForKey:@"data"];
        if ([vaule isKindOfClass:[NSDictionary class]])
        {
            object = [vaule objectForKey:strKey];
        }
    }
    
    return object;
}

//请求失败处理
-(void)dealRequestFail:(id)response request:(QiHttpRequest*)request
{
    //在这里统一处理错误   比如异地登录  重复登录  登录无效
    //现在没加
    
    
    if ([response isKindOfClass:[NSDictionary class]])
    {
        [self callHttpObserver:response tag:request.tag success:NO];
        
    }else if (response == nil){
        
        [self callHttpObserver:response tag:request.tag success:NO];
    }
}




//调用观察者处理请求结果
-(void)callHttpObserver:(NSDictionary*)response
                    tag:(NSInteger)iRequestTag
                success:(BOOL)bSuccess
{
    NSObject* observer = [_httpObserverDict objectForKey:[NSNumber numberWithInteger:iRequestTag]];
    NSLog(@"observer--%@",observer);
    if (observer)
    {
        if (bSuccess)
        {
            if ([observer respondsToSelector:@selector(requestFinished:tag:)])
            {
                [(id)observer requestFinished:response tag:iRequestTag];
            }
        }
        else
        {
            if ([observer respondsToSelector:@selector(requestFailed:tag:)])
            {
                NSInteger code = [[response objectForKey:@"code"]integerValue];
                if (code == 102) {
                    [UIFactory DeleteAllSaveDataNSUserDefaults];
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGIN_FAILURE object:@"102"];
                }
                [(id)observer requestFailed:response tag:iRequestTag];

            }
        }
    }
}


@end
