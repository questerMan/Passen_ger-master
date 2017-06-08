//
//  QiFacade+getmodel.m
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-3.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "QiFacade+getmodel.h"

@implementation QiFacade (getmodel)

#pragma - mark 获取司机公开信息

-(NSInteger)getDriverDataWithID:(NSString *)driverID
{
    NSString *StringURL=[NSString stringWithFormat:@"%@/common/driver/%@",SEVER_API,driverID];
    
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsDictionaryGet:StringURL paraDic:nil];
    
    return IntegerPost;
}

#pragma - mark 获取车型列表

-(NSInteger)getCarData
{
    NSString *StringURL=[NSString stringWithFormat:@"%@/common/car",SEVER_API];
    
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsDictionaryGet:StringURL paraDic:nil];
    
    return IntegerPost;
}

#pragma - mark 获取个人资料

- (NSInteger)getAccountData
{
    NSString *StringURL=[NSString stringWithFormat:@"%@/account",SEVER_API];
    
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsDictionaryGet:StringURL paraDic:nil];
    
    return IntegerPost;
}

#pragma - mark 行程记录

- (NSInteger)getOrder:(NSString *)page Per_page:(NSString *)per_page
{
    NSMutableDictionary* requestDict = [NSMutableDictionary dictionary];
    [requestDict setObject:page forKey:@"page"];
    [requestDict setObject:per_page forKey:@"per_page"];
    
    NSString *StringURL=[NSString stringWithFormat:@"%@/order?",SEVER_API];
    
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsDictionaryGet:StringURL paraDic:requestDict];
    
    return IntegerPost;
}

#pragma - mark 行程详情

-(NSInteger)getOrderDetailsWithID:(NSString *)orderID
{
    NSString *StringURL=[NSString stringWithFormat:@"%@/order/%@",SEVER_API,orderID];
    
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsDictionaryGet:StringURL paraDic:nil];
    
    return IntegerPost;
}

#pragma - mark 费用明细

-(NSInteger)getOrderFeeWithID:(NSString *)orderID
{
    NSString *StringURL=[NSString stringWithFormat:@"%@/order/%@/fee",SEVER_API,orderID];
    
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsDictionaryGet:StringURL paraDic:nil];
    
    return IntegerPost;
}

#pragma - mark 我的余额

-(NSInteger)getBalance:(NSString *)page Per_page:(NSString *)per_page
{
    NSMutableDictionary* requestDict = [NSMutableDictionary dictionary];
    [requestDict setObject:page forKey:@"page"];
    [requestDict setObject:per_page forKey:@"per_page"];
    
    NSString *StringURL=[NSString stringWithFormat:@"%@/balance?",SEVER_API];
    
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsDictionaryGet:StringURL paraDic:requestDict];
    
    return IntegerPost;
}

#pragma - mark 获取优惠券

-(NSInteger)getCoupons:(NSString *)page Per_page:(NSString *)per_page
{
    NSMutableDictionary* requestDict = [NSMutableDictionary dictionary];
    [requestDict setObject:page forKey:@"page"];
    [requestDict setObject:per_page forKey:@"per_page"];
    
    NSString *StringURL=[NSString stringWithFormat:@"%@/coupons?",SEVER_API];
    
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsDictionaryGet:StringURL paraDic:requestDict];
    
    return IntegerPost;
}

#pragma - mark 开票历史

-(NSInteger)getInvoice:(NSString *)page Per_page:(NSString *)per_page
{
    NSMutableDictionary* requestDict = [NSMutableDictionary dictionary];
    [requestDict setObject:page forKey:@"page"];
    [requestDict setObject:per_page forKey:@"per_page"];
    
    NSString *StringURL=[NSString stringWithFormat:@"%@/invoice?",SEVER_API];
    
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsDictionaryGet:StringURL paraDic:requestDict];
    
    return IntegerPost;
}

#pragma - mark 微信支付

-(NSInteger)getWePay:(NSString *)orderID
{
    NSString *StringURL=[NSString stringWithFormat:@"%@?orderid=%@",PAY_SEVER_API,orderID];
    
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsDictionaryGet:StringURL paraDic:nil];
    
    return IntegerPost;
}

-(NSInteger)getTest
{
    NSMutableDictionary* requestDict = [NSMutableDictionary dictionary];
    
    [requestDict setObject:@"32" forKey:@"id"];
    
    
    
    
    __weak QiHttpRequest* request = [self httpRequest:SEVER_API
                                             paraDict:requestDict
                                             userInfo:nil];
    
    //请求成功时处理
    [request setCompletionBlock:^{
        NSLog(@"REQUEST respone:------   %@", request);
        id response = [request jsonValue];
        
        NSLog(@"REQUEST respone:%@", response);
        
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

#pragma mark   私有方法
-(NSInteger)handleDataIsDictionaryGet:(NSString *)Post paraDic:(NSDictionary *)ParaDic
{
    __weak QiHttpRequest* request = [self httpRequest:Post
                                             paraDict:ParaDic
                                             userInfo:nil];
    
    //请求成功时处理
    [request setCompletionBlock:^{
        id response = [request jsonValue];
        if ([self requestSuccess:response])
        {
            NSDictionary* responseDict =[[NSDictionary alloc] init];
            id value = [response objectForKey:@"data"];
//            if([value isKindOfClass:[NSDictionary class]])
//            {
//                responseDict = value;
//            }
            responseDict = value;
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



-(NSInteger)handleDataIsDictionaryGet2:(NSString *)Post paraArrar:(NSArray*)ParaArray
{
    __weak QiHttpRequest* request = [self httpRequestGet:Post paraDict:ParaArray userInfo:nil];
    
    //请求成功时处理
    [request setCompletionBlock:^{
        id response = [request jsonValue];
        if ([self requestSuccess:response])
        {
            NSDictionary* responseDict =[[NSDictionary alloc] init];
            id value = [response objectForKey:@"data"];
            if([value isKindOfClass:[NSDictionary class]])
            {
                responseDict = value;
            }
            
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


-(NSInteger)handleDataIsArrayGet2:(NSString *)Post paraArrar:(NSArray*)ParaArray
{
    __weak QiHttpRequest* request = [self httpRequestGet:Post paraDict:ParaArray userInfo:nil];
    //请求成功时处理
    [request setCompletionBlock:^{
        id response = [request jsonValue];
        if ([self requestSuccess:response])
        {
            NSArray* responseArray =[[NSArray alloc] init];
            id value = [response objectForKey:@"data"];
            NSString* Num=@"";
            if([value isKindOfClass:[NSArray class]])
            {
                responseArray = value;
            }
            Num=[NSString stringWithFormat:@"%lu",(unsigned long)[responseArray count]];
            NSMutableDictionary *responseDict=[[NSMutableDictionary alloc]init];
            [responseDict setObject:responseArray forKey:@"data"];
            [responseDict setObject:Num forKey:@"number"];
            
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

-(NSInteger)handleDataIsArrayGet3:(NSString *)Post paraArrar:(NSArray*)ParaArray
{
    __weak QiHttpRequest* request = [self httpRequestGet:Post paraDict:ParaArray userInfo:nil];
    //请求成功时处理
    [request setCompletionBlock:^{
        id response = [request jsonValue];
        if ([self requestSuccess:response])
        {
            NSArray* responseArray =[[NSArray alloc] init];
            id value = [[response objectForKey:@"data"] objectForKey:@"format"];
            NSString* Num=@"";
            if([value isKindOfClass:[NSArray class]])
            {
                responseArray = value;
            }
            Num=[NSString stringWithFormat:@"%lu",(unsigned long)[responseArray count]];
            NSMutableDictionary *responseDict=[[NSMutableDictionary alloc]init];
            [responseDict setObject:responseArray forKey:@"format"];
            [responseDict setObject:[[response objectForKey:@"data"] objectForKey:@"fee"] forKey:@"fee"];
            [responseDict setObject:[response objectForKey:@"code"] forKey:@"code"];
            [responseDict setObject:[response objectForKey:@"message"] forKey:@"message"];
            [responseDict setObject:Num forKey:@"number"];
            
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

@end
