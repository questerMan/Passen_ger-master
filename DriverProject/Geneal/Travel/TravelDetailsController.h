//
//  TravelDetailsController.h
//  DriverProject
//
//  Created by 林镇杰 on 15/9/10.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "BesaViewController.h"
#import "TravelUiObject.h"

@protocol TravelDetailsControllerDelegate <NSObject>

@optional
-(void)refreshHomeView;
-(void)refreshRecoedListView;
@end

@interface TravelDetailsController : BesaViewController

@property(nonatomic, strong)NSMutableDictionary *detailDic;

@property(nonatomic, retain)NSMutableArray *travelArray;

@property(assign)BOOL isBook;

@property (nonatomic, weak) id<TravelDetailsControllerDelegate> delegate;

@end
