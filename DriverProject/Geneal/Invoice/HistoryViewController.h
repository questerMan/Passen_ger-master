//
//  HistoryViewController.h
//  DriverProject
//
//  Created by 林镇杰 on 15/9/15.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import "BesaViewController.h"
#import "InvoiceCell.h"
#import "InvoiceModel.h"
#import "QiFacade+getmodel.h"
#import <MJRefresh.h>

@interface HistoryViewController : BesaViewController<QiFacadeHttpRequestDelegate>

@property(nonatomic, retain)NSMutableArray *invoiceArray;

@property(nonatomic, retain)NSMutableArray *invoiceListArray;

@end
