//
//  BookTypeController.h
//  DriverProject
//
//  Created by 林镇杰 on 15/9/20.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "BesaViewController.h"

@protocol BookTypeDelegate <NSObject>

-(void)loadBookTypeDataWithType:(NSString *)type AndOther:(NSDictionary *)otherDic;

@end

@interface BookTypeController : BesaViewController

@property(nonatomic, assign)OrderType type;
@property(nonatomic, strong)NSString  *flightDate;
@property(nonatomic, strong)NSString  *flightNum;

@property(nonatomic, retain)NSMutableArray *typeArray;

@property(nonatomic, retain)NSMutableArray *selectArray;

@property(assign)id<BookTypeDelegate>bookTypeDelegate;

@end
