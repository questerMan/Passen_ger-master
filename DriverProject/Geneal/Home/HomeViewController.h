//
//  HomeViewController.h
//  DriverProject
//
//  Created by 林镇杰 on 15/9/6.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "BesaViewController.h"
#import "CommonPopView.h"
#import "QiFacade+getmodel.h"
#import "MapView.h"
#import "ConfirmListView.h"
#import "TravelDetailsController.h"
@interface HomeViewController : BesaViewController<QiFacadeHttpRequestDelegate,TravelDetailsControllerDelegate>

@property(nonatomic,strong)NSMutableArray *userButtonArray;
@property(nonatomic, strong)MapView *mapView;
@property(nonatomic, strong)ConfirmListView *confirmListView;


@end
