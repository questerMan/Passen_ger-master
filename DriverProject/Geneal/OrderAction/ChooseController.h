//
//  ChooseController.h
//  DriverProject
//
//  Created by 林镇杰 on 15/9/21.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "BesaViewController.h"

@protocol ChooseDelegate <NSObject>

-(void)loadChooseResultWith:(NSString *)phone name:(NSString *)name AndIsMessage:(BOOL)isMessage;

@end
@interface ChooseController : BesaViewController

@property(assign)id<ChooseDelegate>chooseDelegate;

@end
