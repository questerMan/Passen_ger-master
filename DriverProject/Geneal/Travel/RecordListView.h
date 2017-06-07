//
//  RecordListView.h
//  DriverProject
//
//  Created by 林镇杰 on 15/9/6.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "BesaViewController.h"
#import <MJRefresh.h>
#import "QiFacade+getmodel.h"
#import "TravelDetailsController.h"
@interface RecordListView : BesaViewController<UITableViewDataSource,UITableViewDelegate,QiFacadeHttpRequestDelegate,TravelDetailsControllerDelegate>

@property(nonatomic, retain)NSMutableArray *recordArray;
@property(nonatomic, retain)NSMutableArray *recordListArray;
@end
