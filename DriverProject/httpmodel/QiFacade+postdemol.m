//
//  QiFacade+postdemol.m
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-3.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "QiFacade+postdemol.h"

@implementation QiFacade (postdemol)

#pragma - mark 用户注册

-(NSInteger)postRegist:(NSString *)phone password:(NSString *)password vcode:(NSString *)code
{
    
    NSMutableDictionary* requestDict = [NSMutableDictionary dictionary];
    [requestDict setObject:phone forKey:@"phone"];
    [requestDict setObject:password forKey:@"password"];
    [requestDict setObject:code forKey:@"vcode"];
    
    NSString *poatURL=[NSString stringWithFormat:@"%@/common/regist?",SEVER_API];
    
    
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsDictionaryPost:poatURL paraDic:requestDict];
    
    return IntegerPost;
}

#pragma mark   登录

-(NSInteger)postLogon:(NSString *)phone password:(NSString *)password
{
    NSMutableDictionary* requestDict = [NSMutableDictionary dictionary];
    [requestDict setObject:phone forKey:@"phone"];
    [requestDict setObject:password forKey:@"password"];
    
    //    [requestDict setObject:@"15218817202" forKey:@"phone"];
    //    [requestDict setObject:@"111111" forKey:@"password"];
    NSString *poatURL=[NSString stringWithFormat:@"%@/common/login?",SEVER_API];
    
    
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsDictionaryPost:poatURL paraDic:requestDict];
    
    return IntegerPost;
}

#pragma    mark 忘记密码

-(NSInteger)postForgetPassord:(NSString *)phone password:(NSString *)password vcode:(NSString *)code
{
    NSMutableDictionary* requestDict = [NSMutableDictionary dictionary];
    
    [requestDict setObject:phone forKey:@"phone"];
    [requestDict setObject:password forKey:@"password"];
    [requestDict setObject:code forKey:@"vcode"];
    
    //    [requestDict setObject:@"15218817202" forKey:@"phone"];
    //    [requestDict setObject:@"111111" forKey:@"password"];
    //    [requestDict setObject:@"1234" forKey:@"vcode"];
    
    NSString *poatURL=[NSString stringWithFormat:@"%@/common/forgot?",SEVER_API];
    
    
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsDictionaryPost:poatURL paraDic:requestDict];
    
    return IntegerPost;
    
}

#pragma    mark 发送验证码

-(NSInteger)postGetCodeWithphone:(NSString *)phone
{
    
    NSMutableDictionary* requestDict = [NSMutableDictionary dictionary];
    
    [requestDict setObject:phone forKey:@"phone"];
    //[requestDict setObject:@"15218817202" forKey:@"phone"];
    NSString *poatURL=[NSString stringWithFormat:@"%@/common/send_code?",SEVER_API];
    
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsStringPost:poatURL paraDic:requestDict];
    
    return IntegerPost;
    
}

#pragma - mark 意见反馈

-(NSInteger)postFeedback:(NSString *)comment
{
    NSMutableDictionary* requestDict = [NSMutableDictionary dictionary];
    
    [requestDict setObject:comment forKey:@"comment"];
    //[requestDict setObject:@"15218817202" forKey:@"phone"];
    NSString *poatURL=[NSString stringWithFormat:@"%@/common/feedback?",SEVER_API];
    
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsStringPost:poatURL paraDic:requestDict];
    
    return IntegerPost;
}

#pragma - mark 费用预估

-(NSInteger)postFee:(NSString *)distance Time:(NSString *)time Type:(NSString *)type CarType:(NSString *)carType Tip:(NSString *)tip
{
    NSMutableDictionary* requestDict = [NSMutableDictionary dictionary];
    
    [requestDict setObject:distance forKey:@"distance"];
    [requestDict setObject:time forKey:@"duration"];
    [requestDict setObject:type forKey:@"type"];
    [requestDict setObject:tip forKey:@"tip"];
    [requestDict setObject:carType forKey:@"carType"];
    NSLog(@"费用预估参数:%@",requestDict);
    NSString *poatURL=[NSString stringWithFormat:@"%@/common/fee?",SEVER_API];
    
    NSInteger IntegerPost=0;
    IntegerPost = [self handleDataIsStringPost:poatURL paraDic:requestDict];
    
    return IntegerPost;
}

#pragma - mark 预约用车-下单

-(NSInteger)postOrder:(NSString *)pre_time
               Origin:(NSString *)origin
          Destination:(NSString *)destination
        Origin_detail:(NSString *)origin_detail 
   destination_detail:(NSString *)destination_detail
       Real_passenger:(NSString *)real_passenger
           Real_phone:(NSString *)real_phone
                 Type:(NSString *)type
          Flight_date:(NSString *)flight_date
            Flight_no:(NSString *)flight_no
         Pre_distance:(NSString *)pre_distance
       Pre_drive_time:(NSString *)pre_drive_time
             Car_type:(NSString *)car_type
             Send_sms:(NSString *)send_sms
              Des_lon:(NSString *)des_lon
              Des_lat:(NSString *)des_lat
              Ori_lat:(NSString *)ori_lat
              Ori_lon:(NSString *)ori_lon
{
    NSMutableDictionary* requestDict = [NSMutableDictionary dictionary];
    
    [requestDict setObject:pre_time forKey:@"pre_time"];
    [requestDict setObject:origin forKey:@"origin"];
    [requestDict setObject:destination forKey:@"destination"];
    [requestDict setObject:origin_detail forKey:@"origin_detail"];
    [requestDict setObject:destination_detail forKey:@"destination_detail"];
    [requestDict setObject:real_passenger forKey:@"real_passenger"];
    [requestDict setObject:real_phone forKey:@"real_phone"];
    [requestDict setObject:type forKey:@"type"];
    [requestDict setObject:flight_date forKey:@"flight_date"];
    [requestDict setObject:flight_no forKey:@"flight_no"];
    [requestDict setObject:pre_distance forKey:@"pre_distance"];
    [requestDict setObject:pre_drive_time forKey:@"pre_drive_time"];
    [requestDict setObject:car_type forKey:@"car_type"];
    [requestDict setObject:send_sms forKey:@"send_sms"];
    [requestDict setObject:des_lon forKey:@"des_lon"];
    [requestDict setObject:des_lat forKey:@"des_lat"];
    [requestDict setObject:ori_lat forKey:@"ori_lat"];
    [requestDict setObject:ori_lon forKey:@"ori_lon"];
    //    [requestDict setObject:@"15218817202" forKey:@"phone"];
    NSLog(@"呼叫专车参数:\n%@",requestDict);
    NSString *poatURL=[NSString stringWithFormat:@"%@/order?",SEVER_API];
    
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsStringPost:poatURL paraDic:requestDict];
    
    return IntegerPost;
}

-(NSInteger)postOrder:(NSString *)reason
{
    NSString *poatURL=[NSString stringWithFormat:@"%@/order?",SEVER_API];
    
    NSInteger IntegerPost=0;
    return IntegerPost;
}

#pragma - mark 行程在线支付

-(NSInteger)postOrderPayOff:(NSString *)pay_remark Result:(NSString *)result Out_trade_no:(NSString *)out_trade_no Pay_type:(NSString *)pay_type WithID:(NSString *)orderID
{
    NSMutableDictionary* requestDict = [NSMutableDictionary dictionary];
    
    [requestDict setObject:pay_remark forKey:@"pay_remark"];
    [requestDict setObject:result forKey:@"result"];
    [requestDict setObject:out_trade_no forKey:@"out_trade_no"];
    [requestDict setObject:pay_type forKey:@"pay_type"];
    //    [requestDict setObject:@"15218817202" forKey:@"phone"];
    NSString *poatURL=[NSString stringWithFormat:@"%@/order/%@/payoff?",SEVER_API,orderID];
    
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsStringPost:poatURL paraDic:requestDict];
    
    return IntegerPost;
}

#pragma - mark 行程投诉

-(NSInteger)postOrderComplain:(NSString *)reason WithID:(NSString *)orderID
{
    NSMutableDictionary* requestDict = [NSMutableDictionary dictionary];
    
    [requestDict setObject:reason forKey:@"reason"];
    //[requestDict setObject:@"15218817202" forKey:@"phone"];
    NSString *poatURL=[NSString stringWithFormat:@"%@/order/%@/complain?",SEVER_API,orderID];
    
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsStringPost:poatURL paraDic:requestDict];
    
    return IntegerPost;
}

#pragma - mark 行程评分

-(NSInteger)postOrderRating:(NSString *)star Comment:(NSString *)comment  WithID:(NSString *)orderID
{
    NSMutableDictionary* requestDict = [NSMutableDictionary dictionary];
    
    [requestDict setObject:star forKey:@"star"];
    [requestDict setObject:comment forKey:@"comment"];
    //[requestDict setObject:@"15218817202" forKey:@"phone"];
    NSString *poatURL=[NSString stringWithFormat:@"%@/order/%@/rating?",SEVER_API,orderID];
    
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsStringPost:poatURL paraDic:requestDict];
    
    return IntegerPost;
}

#pragma - mark 索取单程发票

-(NSInteger)postOrderInvoiceWithID:(NSString *)orderID
{
    NSString *poatURL=[NSString stringWithFormat:@"%@/order/%@/invoice",SEVER_API,orderID];
    
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsStringPost:poatURL paraDic:nil];
    
    return IntegerPost;
}

#pragma - mark 开具发票

-(NSInteger)postInvoice:(NSString *)title Amount:(NSString *)amount Address:(NSString *)address Contactor:(NSString *)contactor Phone:(NSString *)phone
{
    NSMutableDictionary* requestDict = [NSMutableDictionary dictionary];
    
    [requestDict setObject:title forKey:@"title"];
    [requestDict setObject:amount forKey:@"amount"];
    [requestDict setObject:address forKey:@"address"];
    [requestDict setObject:contactor forKey:@"contactor"];
    [requestDict setObject:phone forKey:@"phone"];
    //    [requestDict setObject:@"15218817202" forKey:@"phone"];
    NSString *poatURL=[NSString stringWithFormat:@"%@/invoice?",SEVER_API];
    
    NSInteger IntegerPost=0;
    IntegerPost=[self handleDataIsStringPost:poatURL paraDic:requestDict];
    
    return IntegerPost;
}

#pragma mark   私有方法

-(NSInteger)handleDataIsDictionaryPost:(NSString *)Post paraDic:(NSDictionary *)ParaDic
{
    
    __weak QiHttpRequest* request = [self httpRequestPost:Post
                                                 paraDict:ParaDic
                                                 userInfo:nil];
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


-(NSInteger)handleDataIsStringPost:(NSString *)Post paraDic:(NSDictionary *)ParaDic
{
    
    __weak QiHttpRequest* request = [self httpRequestPost:Post
                                                 paraDict:ParaDic
                                                 userInfo:nil];
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
