//
//  QiFacade+putmodel.m
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-3.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "QiFacade+putmodel.h"

@implementation QiFacade (putmodel)

-(NSInteger)putTest
{
    
    NSMutableDictionary* requestDict = [NSMutableDictionary dictionary];
    
    [requestDict setObject:@"32" forKey:@"id"];
    
    
    
    
    __weak QiHttpRequest* request = [self httpRequestPut:SEVER_API
                                                paraDict:requestDict
                                                userInfo:nil];
    
    //请求成功时处理
    [request setCompletionBlock:^{
        NSLog(@"REQUEST respone:------   %@", request);
        id response = [request jsonValue];
        
        NSLog(@"REQUEST respone:%@", response);
        //return ;
        if ([self requestSuccess:response])
        {
            NSString* strMsg = @"";
            id value = [response objectForKey:@"data"];
            if ([value isKindOfClass:[NSString class]])
            {
                strMsg = value;
            }
            
            NSDictionary* responseDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                          response, @""
                                          ,strMsg, @""
                                          ,request.userInfo, @""
                                          ,nil];
            
            [self callHttpObserver:responseDict tag:request.tag success:YES];
        }
        else
        {
            //调用错误统一处理方法
            [self dealRequestFail:response request:request];
        }
        
        //移除观察者
        [self removerHttpObserverWithTag:request.tag];
        
    }];
    
    return request.tag;
    
}

#pragma - mark 更新个人资料

-(NSInteger)putAccountData:(NSString *)nickname
              Home_address:(NSString *)home_address
           Company_address:(NSString *)company_address
          Home_address_lon:(NSString *)home_address_lon
          Home_address_lat:(NSString *)home_address_lat
       Company_address_lat:(NSString *)company_address_lat
       Company_address_lon:(NSString *)company_address_lon
{
    NSMutableDictionary* requestDict = [NSMutableDictionary dictionary];
    
    [requestDict setObject:nickname forKey:@"nickname"];
    [requestDict setObject:home_address forKey:@"home_address"];
    [requestDict setObject:company_address forKey:@"company_address"];
    [requestDict setObject:home_address_lon forKey:@"home_address_lon"];
    [requestDict setObject:home_address_lat forKey:@"home_address_lat"];
    [requestDict setObject:company_address_lat forKey:@"company_address_lat"];
    [requestDict setObject:company_address_lon forKey:@"company_address_lon"];
    
    NSString *StringURL=[NSString stringWithFormat:@"%@/account?",SEVER_API];
    NSInteger IntegerPost=0;
    IntegerPost = [self handleDataIsStringPut:StringURL paraDic:requestDict];
    
    return IntegerPost;
}

#pragma - mark 取消行程

-(NSInteger)putOrder:(NSString *)reason WithID:(NSString *)orderID
{
    NSMutableDictionary* requestDict = [NSMutableDictionary dictionary];
    
    if (reason) {
        
        [requestDict setObject:reason forKey:@"reason"];
    }else{
        
        [requestDict setObject:@" " forKey:@"reason"];
    }
    
    NSString *StringURL=[NSString stringWithFormat:@"%@/order/%@?",SEVER_API,orderID];
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsStringPut:StringURL paraDic:requestDict];
    
    return IntegerPost;
}

#pragma mark   私有方法

-(NSInteger)handleDataIsStringPut:(NSString *)Post paraDic:(NSDictionary *)ParaDic
{
    
    __weak QiHttpRequest* request = [self httpRequestPut:Post
                                                paraDict:ParaDic
                                                userInfo:nil];
    
    //请求成功时处理
    [request setCompletionBlock:^{
        id response = [request jsonValue];
        if ([self requestSuccess:response])
        {
            if ([response isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dic=[[NSDictionary alloc] initWithDictionary:response];
                [self callHttpObserver:dic tag:request.tag success:YES];
                
            }
        }
        else
        {
            //调用错误统一处理方法
            [self dealRequestFail:response request:request];
        }
        
        //移除观察者
        [self removerHttpObserverWithTag:request.tag];
        
    }];
    
    return request.tag;
}

-(NSInteger)handleDataIsStringPut2:(NSString *)Post paraArray:(NSArray *)ParaArray
{
    
    __weak QiHttpRequest* request = [self httpRequestPut:Post paraArray:ParaArray userInfo:nil];
    //请求成功时处理
    [request setCompletionBlock:^{
        id response = [request jsonValue];
        if ([self requestSuccess:response])
        {
            if ([response isKindOfClass:[NSDictionary class]])
            {
                [self callHttpObserver:response tag:request.tag success:YES];
                
            }
        }
        else
        {
            //调用错误统一处理方法
            [self dealRequestFail:response request:request];
        }
        
        //移除观察者
        [self removerHttpObserverWithTag:request.tag];
        
    }];
    
    return request.tag;
}

@end
