//
//  InvoiceCell.h
//  DriverProject
//
//  Created by 林镇杰 on 15/9/15.
//  Copyright (c) 2015年 广州市优玩科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvoiceModel.h"
#import "FETableViewCell.h"

@interface InvoiceCell : FETableViewCell

@property(nonatomic, strong)UILabel *name;

@property(nonatomic, strong)UILabel *time;

@property(nonatomic, strong)UILabel *status;

@property(nonatomic, strong)UILabel *amount;

@property(nonatomic, retain)InvoiceModel *invoiceModel;

@end
