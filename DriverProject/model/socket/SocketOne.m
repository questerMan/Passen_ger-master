//
//  SocketOne.m
//  trip
//
//  Created by 曾皇茂 on 15-9-13.
//  Copyright (c) 2015年 广州丽新汽车服务有限公司. All rights reserved.
//

#import "SocketOne.h"

@implementation SocketOne

#define timeout 300
static SocketOne *sharedInstance = nil;
// 单例模式
+(SocketOne *)sharedInstance {
    if (nil == sharedInstance)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^(void) {
            sharedInstance = [[self alloc] init];
        });
    }
    return sharedInstance;
}

//- (void)crateNotification
//{
//    //创建通知
//    NSNotification *notification =[NSNotification notificationWithName:@"NewOrderNotifi" object:nil userInfo:orderDic];
//    //通过通知中心发送通知
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
//}

-(void)connect:(NSString *)ip withPort:(NSInteger)port {
    self.ip = ip;
    self.port = port;
    
    // 连接前先断开已有连接，否则会异常
    self.socket.userData = DisconnectByUser;
    [self disconnect];
    
    self.socket.userData = DisconnectByUser;
    [self connect];
}

// 连接端口
-(void)connect {
    self.socket = [[AsyncSocket alloc] initWithDelegate:self];
    NSError* err = nil;
    [self.socket connectToHost:self.ip onPort:self.port error:&err];
    NSString *sendSocket=[NSString stringWithFormat:@"{\"action\":\"listen\",\"orderid\":\"%@\"}",self.orderID];
    [self send:sendSocket];
}

// 主动断开连接
-(void)disconnect {
    self.socket.userData = DisconnectByNO;
    [self.keepAliveTimer invalidate];
    [self.socket disconnect];
}

// 发送数据
-(void)send:(NSString *)text {
    text = [text stringByAppendingString:@"\n"];
    [self.socket writeData:[text dataUsingEncoding:NSUTF8StringEncoding] withTimeout:timeout tag:0];
}

// 心跳方法
-(void)keepAlive {
//    [self send:@"1\n"];
    NSData *data = [@"1\n" dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:data withTimeout:timeout tag:1];
}

#pragma mark - 实现AsyncSocketDelegate回调
// 连接成功
-(void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
    NSLog(@"连接成功");
    self.keepAliveTimer = [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(keepAlive) userInfo:nil repeats:YES];
    [self.keepAliveTimer fire];
    
    // 开始监听数据
    [self.socket readDataWithTimeout:timeout tag:0];
    
    // send
}

// 断连回调
-(void)onSocketDidDisconnect:(AsyncSocket *)sock {
    NSLog(@"连接断掉了, %ld", sock.userData);
    if (sock.userData == DisconnectByUser) {
        // 掉线重连
        [self connect];
    } else {
        // 用户主动断开，不需要重连
        return;
    }
}

//static int  KK=0;
// 接收数据
-(void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSDictionary *orderDic=[NSDictionary dictionaryWithDictionary:[self DicFromJson:data]];
    [self.socket readDataWithTimeout:timeout tag:0];
    if([self.delegate respondsToSelector:@selector(socketResponseWithData:)]){
        [self.delegate socketResponseWithData:orderDic];
    }
   
//    KK++;
//    if(KK==3)
//    {
//        KK=0;
//        
//        NSDictionary *orderDic=[[NSDictionary alloc] initWithObjectsAndKeys:@"22344",@"origin",@"12332",@"destination",@"12328",@"pre_time",@"1",@"order_type", nil];
//        
//        //创建通知
//        NSNotification *notification =[NSNotification notificationWithName:@"NewOrderNotifi" object:nil userInfo:orderDic];
//        //通过通知中心发送通知
//        [[NSNotificationCenter defaultCenter] postNotification:notification];
//    
//    }
    
    
    
//    NSString *action=[orderDic objectForKey:@"action"];
//
//    if([orderDic count]>1&&[action isEqualToString:@"order_new"])
//    {
//        //创建通知
//        NSNotification *notification =[NSNotification notificationWithName:@"NewOrderNotifi" object:nil userInfo:orderDic];
//        //通过通知中心发送通知
//        [[NSNotificationCenter defaultCenter] postNotification:notification];
//    }
    
    
    
}

-(NSDictionary *)DicFromJson:(NSData *)response
{
    NSError *error;
    NSDictionary *orderDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    if (error != nil)
    {
        return nil;
    }
    return orderDic;
}

/*

 {
 action = "order_new";
 "des_lat" = "23.099586";
 "des_lon" = "113.32536";
 destination = "\U7ec8\U70b9\U7b80\U79f0\Uff0c\U5982\U7436\U6d32\U58f9\U53f7";
 "destination_detail" = "\U7ec8\U70b9\U5168\U5730\U5740\Uff0c\U5e7f\U5dde\U5e02\U6d77\U73e0\U533axxx\U5546\U4e1a\U4e2d\U5fc34B-101";
 "order_id" = 257;
 "order_type" = 2;
 "ori_lat" = "23.119884";
 "ori_lon" = "113.412463";
 origin = "\U666e\U901a\U9884\U7ea6\U5355";
 "origin_detail" = "\U8d77\U70b9\U5168\U5730\U5740\Uff0c\U5e7f\U5dde\U5e02\U6d77\U73e0\U533axxx\U5546\U4e1a\U4e2d\U5fc34B-101";
 "pre_time" = "09\U670824\U65e5 06:10";
 }

*/

@end
