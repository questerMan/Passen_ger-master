//
//  TravelUiObject.h
//  DriverProject
//
//  Created by 林镇杰 on 15/9/10.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Masonry.h>

@interface TravelUiObject : NSObject

@property(nonatomic, strong)NSDictionary *driverDic;

@property(nonatomic, copy)NSString *orderType;

@property(nonatomic,strong)NSMutableArray* viewArrays;

@property(nonatomic, strong)UIView *bgView;

@property(nonatomic, strong)UIImageView *statusImage;

@property(nonatomic,strong)UILabel *statusLabel;

@property(nonatomic, strong)UIView *phoneView;

@property(nonatomic, strong)UIView *driverView;

@property(assign)BOOL isBook;

-(void)initUiObjectWith:(NSDictionary *)dic;

-(void)doAutoLayout:(int)status AndStatus:(BOOL)isCancel AndType:(int)type;

@end
