//
//  ViewController.m
//  DriverProject
//
//  Created by 曾皇茂 on 15-9-3.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "ViewController.h"
#import "QiFacade+getmodel.h"
#import "QiFacade+postdemol.h"
#import "QiFacade+putmodel.h"
#import "QiFacade+Deletemodel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //GET
    QiFacade*       facade;
    facade=[QiFacade sharedInstance];
    
  
//   NSInteger takeOutMoneyFlag= [facade getTest];
//    NSLog(@"takeOutMoneyFlag=%d",takeOutMoneyFlag);
//    [facade addHttpObserver:self tag:takeOutMoneyFlag];
   
    
//    NSInteger takeOutMoneyFlag= [facade postTest];
//    NSLog(@"takeOutMoneyFlag=%d",takeOutMoneyFlag);
//    [facade addHttpObserver:self tag:takeOutMoneyFlag];
    
//    NSInteger takeOutMoneyFlag= [facade putTest];
//    NSLog(@"takeOutMoneyFlag=%d",takeOutMoneyFlag);
//    [facade addHttpObserver:self tag:takeOutMoneyFlag];
    
    NSInteger takeOutMoneyFlag= [facade DeleteTest];
    NSLog(@"takeOutMoneyFlag=%d",takeOutMoneyFlag);
    [facade addHttpObserver:self tag:takeOutMoneyFlag];

}

- (void)requestFinished:(NSDictionary*)response tag:(NSInteger)iRequestTag
{

    NSLog(@"成功");

}


- (void)requestFailed:(NSDictionary*)response tag:(NSInteger)iRequestTag
{
    NSLog(@"失败");

}

@end
