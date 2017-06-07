//
//  QiFacade+postdemol.h
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-3.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "QiFacade.h"
#import "QiFacade+http.h"

@interface QiFacade (postdemol)

#pragma - mark 用户注册

-(NSInteger)postRegist:(NSString *)phone password:(NSString *)password vcode:(NSString *)code;

#pragma - mark 登录界面

-(NSInteger)postLogon:(NSString *)phone password:(NSString *)password;

#pragma - mark 忘记密码

-(NSInteger)postForgetPassord:(NSString *)phone password:(NSString *)password vcode:(NSString *)code;

#pragma - mark 发送验证码

-(NSInteger)postGetCodeWithphone:(NSString *)phone;

#pragma - mark 意见反馈

-(NSInteger)postFeedback:(NSString *)comment;

#pragma - mark 费用预估

-(NSInteger)postFee:(NSString *)distance Time:(NSString *)time Type:(NSString *)type CarType:(NSString *)carType Tip:(NSString *)tip;

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
              Ori_lon:(NSString *)ori_lon;

#pragma - mark 行程在线支付

-(NSInteger)postOrderPayOff:(NSString *)pay_remark Result:(NSString *)result Out_trade_no:(NSString *)out_trade_no Pay_type:(NSString *)pay_type WithID:(NSString *)orderID;

#pragma - mark 行程投诉

-(NSInteger)postOrderComplain:(NSString *)reason WithID:(NSString *)orderID;

#pragma - mark 行程评分

-(NSInteger)postOrderRating:(NSString *)star Comment:(NSString *)comment  WithID:(NSString *)orderID;

#pragma - mark 索取单程发票

-(NSInteger)postOrderInvoice;-(NSInteger)postOrderInvoiceWithID:(NSString *)orderID;

#pragma - mark 开具发票

-(NSInteger)postInvoice:(NSString *)title Amount:(NSString *)amount Address:(NSString *)address Contactor:(NSString *)contactor Phone:(NSString *)phone;


@end
